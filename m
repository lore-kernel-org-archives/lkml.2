Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1CJWGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:06:12 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53490
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753546Ab1CJWGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:06:09 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 20/21] Staging: hv: Get rid of the forward declaration for vmbus_isr
Date: Thu, 10 Mar 2011 14:15:47 -0800
Message-Id: <1299795347-1598-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of vmbus_isr by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   47 +++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 7c16acd..dfa3c66 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -51,7 +51,6 @@ struct hv_bus {
 };
 
 
-static irqreturn_t vmbus_isr(int irq, void *dev_id);
 
 static ssize_t vmbus_show_device_attr(struct device *dev,
 				      struct device_attribute *dev_attr,
@@ -94,6 +93,7 @@ static struct device_attribute vmbus_device_attrs[] = {
 	__ATTR_NULL
 };
 
+
 /*
  * vmbus_uevent - add uevent for our device
  *
@@ -420,6 +420,28 @@ static int vmbus_on_isr(void)
 	return ret;
 }
 
+
+static irqreturn_t vmbus_isr(int irq, void *dev_id)
+{
+	int ret;
+
+	ret = vmbus_on_isr();
+
+	/* Schedules a dpc if necessary */
+	if (ret > 0) {
+		if (test_bit(0, (unsigned long *)&ret))
+			tasklet_schedule(&hv_bus.msg_dpc);
+
+		if (test_bit(1, (unsigned long *)&ret))
+			tasklet_schedule(&hv_bus.event_dpc);
+
+		return IRQ_HANDLED;
+	} else {
+		return IRQ_NONE;
+	}
+}
+
+
 static void get_channel_info(struct hv_device *device,
 			     struct hv_device_info *info)
 {
@@ -858,29 +880,6 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
 }
 
 
-
-static irqreturn_t vmbus_isr(int irq, void *dev_id)
-{
-	int ret;
-
-	ret = vmbus_on_isr();
-
-	/* Schedules a dpc if necessary */
-	if (ret > 0) {
-		if (test_bit(0, (unsigned long *)&ret))
-			tasklet_schedule(&hv_bus.msg_dpc);
-
-		if (test_bit(1, (unsigned long *)&ret))
-			tasklet_schedule(&hv_bus.event_dpc);
-
-		return IRQ_HANDLED;
-	} else {
-		return IRQ_NONE;
-	}
-}
-
-
-
 static int __devinit hv_pci_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-- 
1.5.5.6

