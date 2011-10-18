Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab1JRQKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:10:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59978 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab1JRQK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:10:29 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 24/26] staging: et131x: Remove some forward declarations
Date: Tue, 18 Oct 2011 17:07:57 +0100
Message-Id: <1318954079-16666-25-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved functions in et131x.c file to remove the following forward
declarations:

et131x_align_allocated_memory
et131x_disable_interrupts
et131x_enable_interrupts
et131x_error_timer_handler

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |  126 ++++++++++++++++++--------------------
 1 files changed, 60 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index cf6f7a2..8048d67 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -576,12 +576,6 @@ struct et131x_adapter {
 	struct net_device_stats net_stats;
 };
 
-void et131x_error_timer_handler(unsigned long data);
-void et131x_enable_interrupts(struct et131x_adapter *adapter);
-void et131x_disable_interrupts(struct et131x_adapter *adapter);
-void et131x_align_allocated_memory(struct et131x_adapter *adapter,
-				   u64 *phys_addr,
-				   u64 *offset, u64 mask);
 void et131x_adapter_setup(struct et131x_adapter *adapter);
 void et131x_soft_reset(struct et131x_adapter *adapter);
 void et131x_isr_handler(struct work_struct *work);
@@ -1872,6 +1866,33 @@ static inline u32 bump_free_buff_ring(u32 *free_buff_ring, u32 limit)
 }
 
 /**
+ * et131x_align_allocated_memory - Align allocated memory on a given boundary
+ * @adapter: pointer to our adapter structure
+ * @phys_addr: pointer to Physical address
+ * @offset: pointer to the offset variable
+ * @mask: correct mask
+ */
+void et131x_align_allocated_memory(struct et131x_adapter *adapter,
+				   uint64_t *phys_addr,
+				   uint64_t *offset, uint64_t mask)
+{
+	uint64_t new_addr;
+
+	*offset = 0;
+
+	new_addr = *phys_addr & ~mask;
+
+	if (new_addr != *phys_addr) {
+		/* Move to next aligned block */
+		new_addr += mask + 1;
+		/* Return offset for adjusting virt addr */
+		*offset = new_addr - *phys_addr;
+		/* Return new physical address */
+		*phys_addr = new_addr;
+	}
+}
+
+/**
  * et131x_rx_dma_memory_alloc
  * @adapter: pointer to our private adapter structure
  *
@@ -3938,6 +3959,27 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 }
 
 /**
+ *	et131x_enable_interrupts	-	enable interrupt
+ *	@adapter: et131x device
+ *
+ *	Enable the appropriate interrupts on the ET131x according to our
+ *	configuration
+ */
+void et131x_enable_interrupts(struct et131x_adapter *adapter)
+{
+	u32 mask;
+
+	/* Enable all global interrupts */
+	if (adapter->flowcontrol == FLOW_TXONLY ||
+			    adapter->flowcontrol == FLOW_BOTH)
+		mask = INT_MASK_ENABLE;
+	else
+		mask = INT_MASK_ENABLE_NO_FLOW;
+
+	writel(mask, &adapter->regs->global.int_mask);
+}
+
+/**
  * et131x_error_timer_handler
  * @data: timer-specific variable; here a pointer to our adapter structure
  *
@@ -4071,33 +4113,6 @@ void et131x_soft_reset(struct et131x_adapter *adapter)
 }
 
 /**
- * et131x_align_allocated_memory - Align allocated memory on a given boundary
- * @adapter: pointer to our adapter structure
- * @phys_addr: pointer to Physical address
- * @offset: pointer to the offset variable
- * @mask: correct mask
- */
-void et131x_align_allocated_memory(struct et131x_adapter *adapter,
-				   uint64_t *phys_addr,
-				   uint64_t *offset, uint64_t mask)
-{
-	uint64_t new_addr;
-
-	*offset = 0;
-
-	new_addr = *phys_addr & ~mask;
-
-	if (new_addr != *phys_addr) {
-		/* Move to next aligned block */
-		new_addr += mask + 1;
-		/* Return offset for adjusting virt addr */
-		*offset = new_addr - *phys_addr;
-		/* Return new physical address */
-		*phys_addr = new_addr;
-	}
-}
-
-/**
  * et131x_adapter_memory_alloc
  * @adapter: pointer to our private adapter structure
  *
@@ -4339,6 +4354,18 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 }
 
 /**
+ *	et131x_disable_interrupts	-	interrupt disable
+ *	@adapter: et131x device
+ *
+ *	Block all interrupts from the et131x device at the device itself
+ */
+void et131x_disable_interrupts(struct et131x_adapter *adapter)
+{
+	/* Disable all global interrupts */
+	writel(INT_MASK_DISABLE, &adapter->regs->global.int_mask);
+}
+
+/**
  * et131x_pci_setup - Perform device initialization
  * @pdev: a pointer to the device's pci_dev structure
  * @ent: this device's entry in the pci_device_id table
@@ -4633,39 +4660,6 @@ module_exit(et131x_cleanup_module);
 /* ISR functions */
 
 /**
- *	et131x_enable_interrupts	-	enable interrupt
- *	@adapter: et131x device
- *
- *	Enable the appropriate interrupts on the ET131x according to our
- *	configuration
- */
-void et131x_enable_interrupts(struct et131x_adapter *adapter)
-{
-	u32 mask;
-
-	/* Enable all global interrupts */
-	if (adapter->flowcontrol == FLOW_TXONLY ||
-			    adapter->flowcontrol == FLOW_BOTH)
-		mask = INT_MASK_ENABLE;
-	else
-		mask = INT_MASK_ENABLE_NO_FLOW;
-
-	writel(mask, &adapter->regs->global.int_mask);
-}
-
-/**
- *	et131x_disable_interrupts	-	interrupt disable
- *	@adapter: et131x device
- *
- *	Block all interrupts from the et131x device at the device itself
- */
-void et131x_disable_interrupts(struct et131x_adapter *adapter)
-{
-	/* Disable all global interrupts */
-	writel(INT_MASK_DISABLE, &adapter->regs->global.int_mask);
-}
-
-/**
  * et131x_isr - The Interrupt Service Routine for the driver.
  * @irq: the IRQ on which the interrupt was received.
  * @dev_id: device-specific info (here a pointer to a net_device struct)
-- 
1.7.6.4

