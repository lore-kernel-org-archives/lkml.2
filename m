Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab1COVz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:55:59 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53194
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758789Ab1COVxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:53:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 11/12] Staging: hv: Get rid of the forward declaration for vmbus_isr
Date: Tue, 15 Mar 2011 15:03:43 -0700
Message-Id: <1300226624-27004-12-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1300226624-27004-11-git-send-email-kys@microsoft.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-2-git-send-email-kys@microsoft.com>
 <1300226624-27004-3-git-send-email-kys@microsoft.com>
 <1300226624-27004-4-git-send-email-kys@microsoft.com>
 <1300226624-27004-5-git-send-email-kys@microsoft.com>
 <1300226624-27004-6-git-send-email-kys@microsoft.com>
 <1300226624-27004-7-git-send-email-kys@microsoft.com>
 <1300226624-27004-8-git-send-email-kys@microsoft.com>
 <1300226624-27004-9-git-send-email-kys@microsoft.com>
 <1300226624-27004-10-git-send-email-kys@microsoft.com>
 <1300226624-27004-11-git-send-email-kys@microsoft.com>
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
index 976175b..194926c 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -48,7 +48,6 @@ struct hv_bus {
 };
 
 
-static irqreturn_t vmbus_isr(int irq, void *dev_id);
 
 static ssize_t vmbus_show_device_attr(struct device *dev,
 				      struct device_attribute *dev_attr,
@@ -91,6 +90,7 @@ static struct device_attribute vmbus_device_attrs[] = {
 	__ATTR_NULL
 };
 
+
 /*
  * vmbus_uevent - add uevent for our device
  *
@@ -417,6 +417,28 @@ static int vmbus_on_isr(void)
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
@@ -836,29 +858,6 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
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

