Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3AHVJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:09:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab3AHVIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605142"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 18/21] mei: abstract host and device readieness
Date: Tue,  8 Jan 2013 23:07:29 +0200
Message-Id: <1357679252-12958-19-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mei_host_set_ready function to enable the device
and is_ready function to query the host and me readiness

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c     |   35 ++++++++++++++++++++++++++++++++++-
 drivers/misc/mei/init.c      |   14 ++++++--------
 drivers/misc/mei/interrupt.c |   19 ++++++++++---------
 drivers/misc/mei/mei_dev.h   |    4 ++++
 4 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index ed61659..49b558d 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -172,6 +172,39 @@ void mei_hw_reset(struct mei_device *dev, bool intr_enable)
 	dev_dbg(&dev->pdev->dev, "current HCSR = 0x%08x.\n", hcsr);
 }
 
+/**
+ * mei_host_set_ready - enable device
+ *
+ * @dev - mei device
+ * returns bool
+ */
+
+void mei_host_set_ready(struct mei_device *dev)
+{
+	dev->host_hw_state |= H_IE | H_IG | H_RDY;
+	mei_hcsr_set(dev);
+}
+/**
+ * mei_host_is_ready - check whether the host has turned ready
+ *
+ * @dev - mei device
+ * returns bool
+ */
+bool mei_host_is_ready(struct mei_device *dev)
+{
+	return (dev->host_hw_state & H_RDY) == H_RDY;
+}
+
+/**
+ * mei_me_is_ready - check whether the me has turned ready
+ *
+ * @dev - mei device
+ * returns bool
+ */
+bool mei_me_is_ready(struct mei_device *dev)
+{
+	return (dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA;
+}
 
 /**
  * mei_interrupt_quick_handler - The ISR of the MEI device
@@ -290,7 +323,7 @@ int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
 	dev->host_hw_state |= H_IG;
 	mei_hcsr_set(dev);
 	dev->me_hw_state = mei_mecsr_read(dev);
-	if ((dev->me_hw_state & ME_RDY_HRA) != ME_RDY_HRA)
+	if (!mei_me_is_ready(dev))
 		return -EIO;
 
 	return 0;
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 5c2054d..d0ee02a 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -131,18 +131,18 @@ int mei_hw_init(struct mei_device *dev)
 		goto out;
 	}
 
-	if (!(((dev->host_hw_state & H_RDY) == H_RDY) &&
-	      ((dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA))) {
+	if (!(mei_host_is_ready(dev) && mei_me_is_ready(dev))) {
 		dev->dev_state = MEI_DEV_DISABLED;
+
 		dev_dbg(&dev->pdev->dev,
 			"host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
 			dev->host_hw_state, dev->me_hw_state);
 
-		if (!(dev->host_hw_state & H_RDY))
-			dev_dbg(&dev->pdev->dev, "host turn off H_RDY.\n");
+		if (!mei_host_is_ready(dev))
+			dev_dbg(&dev->pdev->dev, "host is not ready.\n");
 
-		if (!(dev->me_hw_state & ME_RDY_HRA))
-			dev_dbg(&dev->pdev->dev, "ME turn off ME_RDY.\n");
+		if (!mei_me_is_ready(dev))
+			dev_dbg(&dev->pdev->dev, "ME is not ready.\n");
 
 		dev_err(&dev->pdev->dev, "link layer initialization failed.\n");
 		ret = -ENODEV;
@@ -159,9 +159,7 @@ int mei_hw_init(struct mei_device *dev)
 	dev->recvd_msg = false;
 	dev_dbg(&dev->pdev->dev, "host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
 	    dev->host_hw_state, dev->me_hw_state);
-	dev_dbg(&dev->pdev->dev, "ME turn on ME_RDY and host turn on H_RDY.\n");
 	dev_dbg(&dev->pdev->dev, "link layer has been established.\n");
-	dev_dbg(&dev->pdev->dev, "MEI  start success.\n");
 	ret = 0;
 
 out:
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index d7e1b79..27374b6 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -700,7 +700,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 	dev->me_hw_state = mei_mecsr_read(dev);
 
 	/* check if ME wants a reset */
-	if ((dev->me_hw_state & ME_RDY_HRA) == 0 &&
+	if (!mei_me_is_ready(dev) &&
 	    dev->dev_state != MEI_DEV_RESETING &&
 	    dev->dev_state != MEI_DEV_INITIALIZING) {
 		dev_dbg(&dev->pdev->dev, "FW not ready.\n");
@@ -711,16 +711,17 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 
 	dev->host_hw_state = mei_hcsr_read(dev);
 	/*  check if we need to start the dev */
-	if ((dev->host_hw_state & H_RDY) == 0) {
-		if ((dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA) {
+	if (!mei_host_is_ready(dev)) {
+		if (mei_me_is_ready(dev)) {
 			dev_dbg(&dev->pdev->dev, "we need to start the dev.\n");
-			dev->host_hw_state |= (H_IE | H_IG | H_RDY);
-			mei_hcsr_set(dev);
-			dev->dev_state = MEI_DEV_INIT_CLIENTS;
+
+			mei_host_set_ready(dev);
+
 			dev_dbg(&dev->pdev->dev, "link is established start sending messages.\n");
-			/* link is established
-			 * start sending messages.
-			 */
+			/* link is established * start sending messages.  */
+
+			dev->dev_state = MEI_DEV_INIT_CLIENTS;
+
 			mei_hbm_start_req(dev);
 			mutex_unlock(&dev->device_lock);
 			return IRQ_HANDLED;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 8692ac8..7b43659 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -396,6 +396,10 @@ void mei_clear_interrupts(struct mei_device *dev);
 void mei_enable_interrupts(struct mei_device *dev);
 void mei_disable_interrupts(struct mei_device *dev);
 
+void mei_host_set_ready(struct mei_device *dev);
+bool mei_host_is_ready(struct mei_device *dev);
+bool mei_me_is_ready(struct mei_device *dev);
+
 
 
 #define MEI_HDR_FMT "hdr:host=%02d me=%02d len=%d comp=%1d"
-- 
1.7.4.4

