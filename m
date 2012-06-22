Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2FVMLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:11:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57315 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932681Ab2FVMLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:11:12 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>
CC: Vikram Pandita <vikram.pandita@ti.com>
Subject: [PATCH v3 1/5] usb: musb: move work_struct(otg_notifier_work) from core to omap glue
Date: Fri, 22 Jun 2012 17:40:51 +0530
Message-ID: <1340367055-19835-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340367055-19835-1-git-send-email-kishon@ti.com>
References: <1340367055-19835-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 712d8e(fixes pm_runtime calls while atomic by using a work
queue. musb pm_runtime_get_sync call happens in interrupt context
on cable attach case. That can result in re-enabling the interrupts and
cause side affect. To avoid this deferred processing is used)

While the issue and the work queue implementation is specific to omap
(omap2430.c), the work_struct is defined as a member of struct musb
(musb_core.h). Hence moved the work_struct from musb_core to omap
glue.

Cc: Vikram Pandita <vikram.pandita@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/musb_core.h |    2 --
 drivers/usb/musb/omap2430.c  |   24 +++++++++++++++---------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index f4a40f0..dbcdeea 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -327,7 +327,6 @@ struct musb {
 
 	irqreturn_t		(*isr)(int, void *);
 	struct work_struct	irq_work;
-	struct work_struct	otg_notifier_work;
 	u16			hwvers;
 
 /* this hub status bit is reserved by USB 2.0 and not seen by usbcore */
@@ -373,7 +372,6 @@ struct musb {
 	u16			int_tx;
 
 	struct usb_phy		*xceiv;
-	u8			xceiv_event;
 
 	int nIrq;
 	unsigned		irq_wake:1;
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index e279cf3..f40c805 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -41,6 +41,8 @@
 struct omap2430_glue {
 	struct device		*dev;
 	struct platform_device	*musb;
+	u8			xceiv_event;
+	struct work_struct	omap_musb_mailbox_work;
 };
 #define glue_to_musb(g)		platform_get_drvdata(g->musb)
 
@@ -226,22 +228,26 @@ static inline void omap2430_low_level_init(struct musb *musb)
 static int musb_otg_notifications(struct notifier_block *nb,
 		unsigned long event, void *unused)
 {
-	struct musb	*musb = container_of(nb, struct musb, nb);
+	struct musb		*musb = container_of(nb, struct musb, nb);
+	struct device		*dev = musb->controller;
+	struct omap2430_glue	*glue = dev_get_drvdata(dev->parent);
 
-	musb->xceiv_event = event;
-	schedule_work(&musb->otg_notifier_work);
+	glue->xceiv_event = event;
+	schedule_work(&glue->omap_musb_mailbox_work);
 
 	return NOTIFY_OK;
 }
 
-static void musb_otg_notifier_work(struct work_struct *data_notifier_work)
+static void omap_musb_mailbox_work(struct work_struct *data_notifier_work)
 {
-	struct musb *musb = container_of(data_notifier_work, struct musb, otg_notifier_work);
+	struct omap2430_glue *glue = container_of(data_notifier_work,
+		struct omap2430_glue, omap_musb_mailbox_work);
+	struct musb *musb = glue_to_musb(glue);
 	struct device *dev = musb->controller;
 	struct musb_hdrc_platform_data *pdata = dev->platform_data;
 	struct omap_musb_board_data *data = pdata->board_data;
 
-	switch (musb->xceiv_event) {
+	switch (glue->xceiv_event) {
 	case USB_EVENT_ID:
 		dev_dbg(musb->controller, "ID GND\n");
 
@@ -298,8 +304,6 @@ static int omap2430_musb_init(struct musb *musb)
 		return -ENODEV;
 	}
 
-	INIT_WORK(&musb->otg_notifier_work, musb_otg_notifier_work);
-
 	status = pm_runtime_get_sync(dev);
 	if (status < 0) {
 		dev_err(dev, "pm_runtime_get_sync FAILED %d\n", status);
@@ -388,7 +392,6 @@ static void omap2430_musb_disable(struct musb *musb)
 static int omap2430_musb_exit(struct musb *musb)
 {
 	del_timer_sync(&musb_idle_timer);
-	cancel_work_sync(&musb->otg_notifier_work);
 
 	omap2430_low_level_exit(musb);
 	usb_put_phy(musb->xceiv);
@@ -441,6 +444,8 @@ static int __devinit omap2430_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, glue);
 
+	INIT_WORK(&glue->omap_musb_mailbox_work, omap_musb_mailbox_work);
+
 	ret = platform_device_add_resources(musb, pdev->resource,
 			pdev->num_resources);
 	if (ret) {
@@ -478,6 +483,7 @@ static int __devexit omap2430_remove(struct platform_device *pdev)
 {
 	struct omap2430_glue		*glue = platform_get_drvdata(pdev);
 
+	cancel_work_sync(&glue->omap_musb_mailbox_work);
 	platform_device_del(glue->musb);
 	platform_device_put(glue->musb);
 	kfree(glue);
-- 
1.7.5.4

