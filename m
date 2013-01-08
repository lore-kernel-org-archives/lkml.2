Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3AHVId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab3AHVI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605171"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 20/21] mei: make host csr and me csr internal to hw-me
Date: Tue,  8 Jan 2013 23:07:31 +0200
Message-Id: <1357679252-12958-21-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move csr reading into me hardware functional calls.
Since we gave up on registers caching we remove some of the unnecessary
queries in mei_hw_init ane mei_reset functions.

We add mei_hw_config function to wrap up host buffer depth configuration.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c     |   19 ++++++++++--
 drivers/misc/mei/init.c      |   63 ++++++++++++-----------------------------
 drivers/misc/mei/interrupt.c |    4 --
 drivers/misc/mei/mei_dev.h   |    4 +-
 4 files changed, 37 insertions(+), 53 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 3190027..93a2a56 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -67,7 +67,7 @@ u32 mei_mecbrw_read(const struct mei_device *dev)
  *
  * returns ME_CSR_HA register value (u32)
  */
-u32 mei_mecsr_read(const struct mei_device *dev)
+static inline u32 mei_mecsr_read(const struct mei_device *dev)
 {
 	return mei_reg_read(dev, ME_CSR_HA);
 }
@@ -79,7 +79,7 @@ u32 mei_mecsr_read(const struct mei_device *dev)
  *
  * returns H_CSR register value (u32)
  */
-u32 mei_hcsr_read(const struct mei_device *dev)
+static inline u32 mei_hcsr_read(const struct mei_device *dev)
 {
 	return mei_reg_read(dev, H_CSR);
 }
@@ -96,6 +96,18 @@ static inline void mei_hcsr_set(struct mei_device *dev, u32 hcsr)
 	mei_reg_write(dev, H_CSR, hcsr);
 }
 
+
+/**
+ * me_hw_config - configure hw dependent settings
+ *
+ * @dev: mei device
+ */
+void mei_hw_config(struct mei_device *dev)
+{
+	u32 hcsr = mei_hcsr_read(dev);
+	/* Doesn't change in runtime */
+	dev->hbuf_depth = (hcsr & H_CBD) >> 24;
+}
 /**
  * mei_clear_interrupts - clear and stop interrupts
  *
@@ -183,6 +195,7 @@ void mei_host_set_ready(struct mei_device *dev)
  */
 bool mei_host_is_ready(struct mei_device *dev)
 {
+	dev->host_hw_state = mei_hcsr_read(dev);
 	return (dev->host_hw_state & H_RDY) == H_RDY;
 }
 
@@ -194,6 +207,7 @@ bool mei_host_is_ready(struct mei_device *dev)
  */
 bool mei_me_is_ready(struct mei_device *dev)
 {
+	dev->me_hw_state = mei_mecsr_read(dev);
 	return (dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA;
 }
 
@@ -313,7 +327,6 @@ int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
 
 	hcsr = mei_hcsr_read(dev) | H_IG;
 	mei_hcsr_set(dev, hcsr);
-	dev->me_hw_state = mei_mecsr_read(dev);
 	if (!mei_me_is_ready(dev))
 		return -EIO;
 
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index d0ee02a..98a7fc1 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -89,82 +89,64 @@ struct mei_device *mei_device_init(struct pci_dev *pdev)
  */
 int mei_hw_init(struct mei_device *dev)
 {
-	int err = 0;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&dev->device_lock);
 
-	dev->host_hw_state = mei_hcsr_read(dev);
-	dev->me_hw_state = mei_mecsr_read(dev);
-	dev_dbg(&dev->pdev->dev, "host_hw_state = 0x%08x, mestate = 0x%08x.\n",
-	    dev->host_hw_state, dev->me_hw_state);
-
 	/* acknowledge interrupt and stop interupts */
 	mei_clear_interrupts(dev);
 
-	/* Doesn't change in runtime */
-	dev->hbuf_depth = (dev->host_hw_state & H_CBD) >> 24;
+	mei_hw_config(dev);
 
 	dev->recvd_msg = false;
 	dev_dbg(&dev->pdev->dev, "reset in start the mei device.\n");
 
 	mei_reset(dev, 1);
 
-	dev_dbg(&dev->pdev->dev, "host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
-	    dev->host_hw_state, dev->me_hw_state);
-
 	/* wait for ME to turn on ME_RDY */
 	if (!dev->recvd_msg) {
 		mutex_unlock(&dev->device_lock);
-		err = wait_event_interruptible_timeout(dev->wait_recvd_msg,
+		ret = wait_event_interruptible_timeout(dev->wait_recvd_msg,
 			dev->recvd_msg,
 			mei_secs_to_jiffies(MEI_INTEROP_TIMEOUT));
 		mutex_lock(&dev->device_lock);
 	}
 
-	if (err <= 0 && !dev->recvd_msg) {
+	if (ret <= 0 && !dev->recvd_msg) {
 		dev->dev_state = MEI_DEV_DISABLED;
 		dev_dbg(&dev->pdev->dev,
 			"wait_event_interruptible_timeout failed"
 			"on wait for ME to turn on ME_RDY.\n");
-		ret = -ENODEV;
-		goto out;
+		goto err;
 	}
 
-	if (!(mei_host_is_ready(dev) && mei_me_is_ready(dev))) {
-		dev->dev_state = MEI_DEV_DISABLED;
-
-		dev_dbg(&dev->pdev->dev,
-			"host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
-			dev->host_hw_state, dev->me_hw_state);
-
-		if (!mei_host_is_ready(dev))
-			dev_dbg(&dev->pdev->dev, "host is not ready.\n");
 
-		if (!mei_me_is_ready(dev))
-			dev_dbg(&dev->pdev->dev, "ME is not ready.\n");
+	if (!mei_host_is_ready(dev)) {
+		dev_err(&dev->pdev->dev, "host is not ready.\n");
+		goto err;
+	}
 
-		dev_err(&dev->pdev->dev, "link layer initialization failed.\n");
-		ret = -ENODEV;
-		goto out;
+	if (!mei_me_is_ready(dev)) {
+		dev_err(&dev->pdev->dev, "ME is not ready.\n");
+		goto err;
 	}
 
 	if (dev->version.major_version != HBM_MAJOR_VERSION ||
 	    dev->version.minor_version != HBM_MINOR_VERSION) {
 		dev_dbg(&dev->pdev->dev, "MEI start failed.\n");
-		ret = -ENODEV;
-		goto out;
+		goto err;
 	}
 
 	dev->recvd_msg = false;
-	dev_dbg(&dev->pdev->dev, "host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
-	    dev->host_hw_state, dev->me_hw_state);
 	dev_dbg(&dev->pdev->dev, "link layer has been established.\n");
-	ret = 0;
 
-out:
 	mutex_unlock(&dev->device_lock);
-	return ret;
+	return 0;
+err:
+	dev_err(&dev->pdev->dev, "link layer initialization failed.\n");
+	dev->dev_state = MEI_DEV_DISABLED;
+	mutex_unlock(&dev->device_lock);
+	return -ENODEV;
 }
 
 /**
@@ -221,13 +203,6 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	dev->rd_msg_hdr = 0;
 	dev->wd_pending = false;
 
-	/* update the state of the registers after reset */
-	dev->host_hw_state = mei_hcsr_read(dev);
-	dev->me_hw_state = mei_mecsr_read(dev);
-
-	dev_dbg(&dev->pdev->dev, "after reset host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
-	    dev->host_hw_state, dev->me_hw_state);
-
 	if (unexpected)
 		dev_warn(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
 			 mei_dev_state_str(dev->dev_state));
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 27374b6..b04ed9b 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -697,8 +697,6 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 	if (pci_dev_msi_enabled(dev->pdev))
 		mei_clear_interrupts(dev);
 
-	dev->me_hw_state = mei_mecsr_read(dev);
-
 	/* check if ME wants a reset */
 	if (!mei_me_is_ready(dev) &&
 	    dev->dev_state != MEI_DEV_RESETING &&
@@ -709,7 +707,6 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	dev->host_hw_state = mei_hcsr_read(dev);
 	/*  check if we need to start the dev */
 	if (!mei_host_is_ready(dev)) {
 		if (mei_me_is_ready(dev)) {
@@ -746,7 +743,6 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 	rets = mei_irq_thread_write_handler(dev, &complete_list);
 end:
 	dev_dbg(&dev->pdev->dev, "end of bottom half function.\n");
-	dev->host_hw_state = mei_hcsr_read(dev);
 	dev->mei_host_buffer_is_empty = mei_hbuf_is_empty(dev);
 
 	bus_message_received = false;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index ae4c5ff..d6589d0 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -385,12 +385,12 @@ void mei_watchdog_unregister(struct mei_device *dev);
  * Register Access Function
  */
 
+void mei_hw_config(struct mei_device *dev);
 void mei_hw_reset(struct mei_device *dev, bool intr_enable);
-u32 mei_hcsr_read(const struct mei_device *dev);
-u32 mei_mecsr_read(const struct mei_device *dev);
 u32 mei_mecbrw_read(const struct mei_device *dev);
 
 
+
 void mei_clear_interrupts(struct mei_device *dev);
 void mei_enable_interrupts(struct mei_device *dev);
 void mei_disable_interrupts(struct mei_device *dev);
-- 
1.7.4.4

