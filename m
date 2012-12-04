Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2LDOFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:05:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:14163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab2LDOFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:05:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975421"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 09/15] mei: move hw dependent constructs to interface.c
Date: Tue,  4 Dec 2012 16:04:38 +0200
Message-Id: <1354629884-3202-9-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c      |    3 +-
 drivers/misc/mei/interface.c |   92 +++++++++++++++++++++++++++++++++++++++++-
 drivers/misc/mei/interrupt.c |   24 +----------
 drivers/misc/mei/mei_dev.h   |   71 ++------------------------------
 4 files changed, 97 insertions(+), 93 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 08884ef..eb18055 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -142,8 +142,7 @@ int mei_hw_init(struct mei_device *dev)
 	    dev->host_hw_state, dev->me_hw_state);
 
 	/* acknowledge interrupt and stop interupts */
-	if ((dev->host_hw_state & H_IS) == H_IS)
-		mei_reg_write(dev, H_CSR, dev->host_hw_state);
+	mei_clear_interrupts(dev);
 
 	/* Doesn't change in runtime */
 	dev->hbuf_depth = (dev->host_hw_state & H_CBD) >> 24;
diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 810431e..c2faeb1 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -20,7 +20,61 @@
 #include "mei_dev.h"
 #include "interface.h"
 
+/**
+ * mei_reg_read - Reads 32bit data from the mei device
+ *
+ * @dev: the device structure
+ * @offset: offset from which to read the data
+ *
+ * returns register value (u32)
+ */
+static inline u32 mei_reg_read(const struct mei_device *dev,
+			       unsigned long offset)
+{
+	return readl(dev->mem_addr + offset);
+}
+
+
+/**
+ * mei_reg_write - Writes 32bit data to the mei device
+ *
+ * @dev: the device structure
+ * @offset: offset from which to write the data
+ * @value: register value to write (u32)
+ */
+static inline void mei_reg_write(const struct mei_device *dev,
+				 unsigned long offset, u32 value)
+{
+	writel(value, dev->mem_addr + offset);
+}
 
+/**
+ * mei_hcsr_read - Reads 32bit data from the host CSR
+ *
+ * @dev: the device structure
+ *
+ * returns the byte read.
+ */
+u32 mei_hcsr_read(const struct mei_device *dev)
+{
+	return mei_reg_read(dev, H_CSR);
+}
+
+u32 mei_mecbrw_read(const struct mei_device *dev)
+{
+	return mei_reg_read(dev, ME_CB_RW);
+}
+/**
+ * mei_mecsr_read - Reads 32bit data from the ME CSR
+ *
+ * @dev: the device structure
+ *
+ * returns ME_CSR_HA register value (u32)
+ */
+u32 mei_mecsr_read(const struct mei_device *dev)
+{
+	return mei_reg_read(dev, ME_CSR_HA);
+}
 
 /**
  * mei_set_csr_register - writes H_CSR register to the mei device,
@@ -37,7 +91,18 @@ void mei_hcsr_set(struct mei_device *dev)
 }
 
 /**
- * mei_csr_enable_interrupts - enables mei device interrupts
+ * mei_enable_interrupts - clear and stop interrupts
+ *
+ * @dev: the device structure
+ */
+void mei_clear_interrupts(struct mei_device *dev)
+{
+	if ((dev->host_hw_state & H_IS) == H_IS)
+		mei_reg_write(dev, H_CSR, dev->host_hw_state);
+}
+
+/**
+ * mei_enable_interrupts - enables mei device interrupts
  *
  * @dev: the device structure
  */
@@ -48,7 +113,7 @@ void mei_enable_interrupts(struct mei_device *dev)
 }
 
 /**
- * mei_csr_disable_interrupts - disables mei device interrupts
+ * mei_disable_interrupts - disables mei device interrupts
  *
  * @dev: the device structure
  */
@@ -58,6 +123,29 @@ void mei_disable_interrupts(struct mei_device *dev)
 	mei_hcsr_set(dev);
 }
 
+
+/**
+ * mei_interrupt_quick_handler - The ISR of the MEI device
+ *
+ * @irq: The irq number
+ * @dev_id: pointer to the device structure
+ *
+ * returns irqreturn_t
+ */
+irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id)
+{
+	struct mei_device *dev = (struct mei_device *) dev_id;
+	u32 csr_reg = mei_hcsr_read(dev);
+
+	if ((csr_reg & H_IS) != H_IS)
+		return IRQ_NONE;
+
+	/* clear H_IS bit in H_CSR */
+	mei_reg_write(dev, H_CSR, csr_reg);
+
+	return IRQ_WAKE_THREAD;
+}
+
 /**
  * mei_hbuf_filled_slots - gets number of device filled buffer slots
  *
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 0a020ad..cd89b68 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -28,28 +28,6 @@
 
 
 /**
- * mei_interrupt_quick_handler - The ISR of the MEI device
- *
- * @irq: The irq number
- * @dev_id: pointer to the device structure
- *
- * returns irqreturn_t
- */
-irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id)
-{
-	struct mei_device *dev = (struct mei_device *) dev_id;
-	u32 csr_reg = mei_hcsr_read(dev);
-
-	if ((csr_reg & H_IS) != H_IS)
-		return IRQ_NONE;
-
-	/* clear H_IS bit in H_CSR */
-	mei_reg_write(dev, H_CSR, csr_reg);
-
-	return IRQ_WAKE_THREAD;
-}
-
-/**
  * _mei_cmpl - processes completed operation.
  *
  * @cl: private data of the file object.
@@ -1150,7 +1128,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 	/* Ack the interrupt here
 	 * In case of MSI we don't go through the quick handler */
 	if (pci_dev_msi_enabled(dev->pdev))
-		mei_reg_write(dev, H_CSR, dev->host_hw_state);
+		mei_clear_interrupts(dev);
 
 	dev->me_hw_state = mei_mecsr_read(dev);
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index ab085d1..38693c5 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -440,79 +440,18 @@ int mei_amthif_irq_read(struct mei_device *dev, s32 *slots);
  * Register Access Function
  */
 
-/**
- * mei_reg_read - Reads 32bit data from the mei device
- *
- * @dev: the device structure
- * @offset: offset from which to read the data
- *
- * returns register value (u32)
- */
-static inline u32 mei_reg_read(const struct mei_device *dev,
-			       unsigned long offset)
-{
-	return readl(dev->mem_addr + offset);
-}
-
-/**
- * mei_reg_write - Writes 32bit data to the mei device
- *
- * @dev: the device structure
- * @offset: offset from which to write the data
- * @value: register value to write (u32)
- */
-static inline void mei_reg_write(const struct mei_device *dev,
-				 unsigned long offset, u32 value)
-{
-	writel(value, dev->mem_addr + offset);
-}
-
-/**
- * mei_hcsr_read - Reads 32bit data from the host CSR
- *
- * @dev: the device structure
- *
- * returns the byte read.
- */
-static inline u32 mei_hcsr_read(const struct mei_device *dev)
-{
-	return mei_reg_read(dev, H_CSR);
-}
+u32 mei_hcsr_read(const struct mei_device *dev);
+u32 mei_mecsr_read(const struct mei_device *dev);
+u32 mei_mecbrw_read(const struct mei_device *dev);
 
-/**
- * mei_mecsr_read - Reads 32bit data from the ME CSR
- *
- * @dev: the device structure
- *
- * returns ME_CSR_HA register value (u32)
- */
-static inline u32 mei_mecsr_read(const struct mei_device *dev)
-{
-	return mei_reg_read(dev, ME_CSR_HA);
-}
-
-/**
- * get_me_cb_rw - Reads 32bit data from the mei ME_CB_RW register
- *
- * @dev: the device structure
- *
- * returns ME_CB_RW register value (u32)
- */
-static inline u32 mei_mecbrw_read(const struct mei_device *dev)
-{
-	return mei_reg_read(dev, ME_CB_RW);
-}
-
-
-/*
- * mei interface function prototypes
- */
 void mei_hcsr_set(struct mei_device *dev);
 void mei_csr_clear_his(struct mei_device *dev);
 
+void mei_clear_interrupts(struct mei_device *dev);
 void mei_enable_interrupts(struct mei_device *dev);
 void mei_disable_interrupts(struct mei_device *dev);
 
+
 static inline struct mei_msg_hdr *mei_hbm_hdr(u32 *buf, size_t length)
 {
 	struct mei_msg_hdr *hdr = (struct mei_msg_hdr *)buf;
-- 
1.7.4.4

