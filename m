Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3AHVIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab3AHVIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605111"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 16/21] mei: don't use cached value for hcsr in mei_hw_reset
Date: Tue,  8 Jan 2013 23:07:27 +0200
Message-Id: <1357679252-12958-17-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Open code mei_hw_reset to avoid using cached hcsr.
Using cached hcsr can cause unwanted side effects.

Move mei_hw_restet function to hw-me.c as it is hw dependent

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c   |   35 +++++++++++++++++++++++++++++++++++
 drivers/misc/mei/init.c    |   28 ----------------------------
 drivers/misc/mei/mei_dev.h |    1 +
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 1e82e33..ec4ab89 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -132,6 +132,41 @@ void mei_disable_interrupts(struct mei_device *dev)
 	mei_hcsr_set(dev);
 }
 
+/**
+ * mei_hw_reset - resets fw via mei csr register.
+ *
+ * @dev: the device structure
+ * @interrupts_enabled: if interrupt should be enabled after reset.
+ */
+void mei_hw_reset(struct mei_device *dev, bool intr_enable)
+{
+	u32 hcsr = mei_hcsr_read(dev);
+
+	dev_dbg(&dev->pdev->dev, "before reset HCSR = 0x%08x.\n", hcsr);
+
+	hcsr |= (H_RST | H_IG);
+
+	if (intr_enable)
+		hcsr |= H_IE;
+	else
+		hcsr &= ~H_IE;
+
+	hcsr &= ~H_IS;
+
+	mei_reg_write(dev, H_CSR, hcsr);
+	hcsr = mei_hcsr_read(dev);
+
+	hcsr &= ~H_RST;
+	hcsr |= H_IG;
+	hcsr &= ~H_IS;
+
+	mei_reg_write(dev, H_CSR, hcsr);
+
+	hcsr = mei_hcsr_read(dev);
+
+	dev_dbg(&dev->pdev->dev, "current HCSR = 0x%08x.\n", hcsr);
+}
+
 
 /**
  * mei_interrupt_quick_handler - The ISR of the MEI device
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 2391832..5c2054d 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -170,22 +170,6 @@ out:
 }
 
 /**
- * mei_hw_reset - resets fw via mei csr register.
- *
- * @dev: the device structure
- * @interrupts_enabled: if interrupt should be enabled after reset.
- */
-static void mei_hw_reset(struct mei_device *dev, int interrupts_enabled)
-{
-	dev->host_hw_state |= (H_RST | H_IG);
-
-	if (interrupts_enabled)
-		mei_enable_interrupts(dev);
-	else
-		mei_disable_interrupts(dev);
-}
-
-/**
  * mei_reset - resets host and fw.
  *
  * @dev: the device structure
@@ -207,20 +191,8 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 			dev->dev_state != MEI_DEV_POWER_DOWN &&
 			dev->dev_state != MEI_DEV_POWER_UP);
 
-	dev->host_hw_state = mei_hcsr_read(dev);
-
-	dev_dbg(&dev->pdev->dev, "before reset host_hw_state = 0x%08x.\n",
-	    dev->host_hw_state);
-
 	mei_hw_reset(dev, interrupts_enabled);
 
-	dev->host_hw_state &= ~H_RST;
-	dev->host_hw_state |= H_IG;
-
-	mei_hcsr_set(dev);
-
-	dev_dbg(&dev->pdev->dev, "currently saved host_hw_state = 0x%08x.\n",
-	    dev->host_hw_state);
 
 	if (dev->dev_state != MEI_DEV_INITIALIZING) {
 		if (dev->dev_state != MEI_DEV_DISABLED &&
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 88fa194..8692ac8 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -385,6 +385,7 @@ void mei_watchdog_unregister(struct mei_device *dev);
  * Register Access Function
  */
 
+void mei_hw_reset(struct mei_device *dev, bool intr_enable);
 u32 mei_hcsr_read(const struct mei_device *dev);
 void mei_hcsr_set(struct mei_device *dev);
 u32 mei_mecsr_read(const struct mei_device *dev);
-- 
1.7.4.4

