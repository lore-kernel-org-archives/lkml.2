Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966371Ab0GSSpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:45:55 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25781 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936529Ab0GSSjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:39:25 -0400
Subject: [PATCH 03/26] cciss: factor out cciss_lookup_board_id
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:44:55 -0500
Message-ID: <20100719184455.7908.24283.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: factor out cciss_lookup_board_id

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   66 ++++++++++++++++++++++++++-----------------------
 1 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b79ce8e..d4167c2 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3980,35 +3980,43 @@ default_int_mode:
 	return;
 }
 
-static int __devinit cciss_pci_init(ctlr_info_t *c)
+static int __devinit cciss_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 {
-	ushort subsystem_vendor_id, subsystem_device_id, command;
-	__u32 board_id, scratchpad = 0;
-	__u64 cfg_offset;
-	__u32 cfg_base_addr;
-	__u64 cfg_base_addr_index;
-	int i, prod_index, err;
-	__u32 trans_offset;
+	int i;
+	u32 subsystem_vendor_id, subsystem_device_id;
 
-	subsystem_vendor_id = c->pdev->subsystem_vendor;
-	subsystem_device_id = c->pdev->subsystem_device;
-	board_id = (((__u32) (subsystem_device_id << 16) & 0xffff0000) |
-		    subsystem_vendor_id);
+	subsystem_vendor_id = pdev->subsystem_vendor;
+	subsystem_device_id = pdev->subsystem_device;
+	*board_id = ((subsystem_device_id << 16) & 0xffff0000) |
+			subsystem_vendor_id;
 
 	for (i = 0; i < ARRAY_SIZE(products); i++) {
 		/* Stand aside for hpsa driver on request */
 		if (cciss_allow_hpsa && products[i].board_id == HPSA_BOUNDARY)
 			return -ENODEV;
-		if (board_id == products[i].board_id)
-			break;
+		if (*board_id == products[i].board_id)
+			return i;
 	}
-	prod_index = i;
-	if (prod_index == ARRAY_SIZE(products)) {
-		dev_warn(&c->pdev->dev,
-			"unrecognized board ID: 0x%08lx, ignoring.\n",
-			(unsigned long) board_id);
+	dev_warn(&pdev->dev, "unrecognized board ID: 0x%08x, ignoring.\n",
+		*board_id);
+	return -ENODEV;
+}
+
+static int __devinit cciss_pci_init(ctlr_info_t *c)
+{
+	ushort command;
+	__u32 scratchpad = 0;
+	__u64 cfg_offset;
+	__u32 cfg_base_addr;
+	__u64 cfg_base_addr_index;
+	__u32 trans_offset;
+	int i, prod_index, err;
+
+	prod_index = cciss_lookup_board_id(c->pdev, &c->board_id);
+	if (prod_index < 0)
 		return -ENODEV;
-	}
+	c->product_name = products[prod_index].product_name;
+	c->access = *(products[prod_index].access);
 
 	/* check to see if controller has been disabled */
 	/* BEFORE trying to enable it */
@@ -4035,13 +4043,13 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 #ifdef CCISS_DEBUG
 	printk(KERN_INFO "command = %x\n", command);
 	printk(KERN_INFO "irq = %x\n", c->pdev->irq);
-	printk(KERN_INFO "board_id = %x\n", board_id);
+	printk(KERN_INFO "board_id = %x\n", c->board_id);
 #endif				/* CCISS_DEBUG */
 
 /* If the kernel supports MSI/MSI-X we will try to enable that functionality,
  * else we use the IO-APIC interrupt assigned to us by system ROM.
  */
-	cciss_interrupt_mode(c, board_id);
+	cciss_interrupt_mode(c, c->board_id);
 
 	/* find the memory BAR */
 	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
@@ -4107,11 +4115,9 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 	c->transtable = remap_pci_mem(pci_resource_start(c->pdev,
 		cfg_base_addr_index) + cfg_offset+trans_offset,
 		sizeof(*c->transtable));
-	c->board_id = board_id;
-
-	#ifdef CCISS_DEBUG
-		print_cfg_table(c->cfgtable);
-	#endif				/* CCISS_DEBUG */
+#ifdef CCISS_DEBUG
+	print_cfg_table(c->cfgtable);
+#endif				/* CCISS_DEBUG */
 
 	/* Some controllers support Zero Memory Raid (ZMR).
 	 * When configured in ZMR mode the number of supported
@@ -4139,8 +4145,6 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 		c->chainsize = 0;       /* traditional */
 	}
 
-	c->product_name = products[prod_index].product_name;
-	c->access = *(products[prod_index].access);
 	c->nr_cmds = c->max_commands - 4;
 	if ((readb(&c->cfgtable->Signature[0]) != 'C') ||
 	    (readb(&c->cfgtable->Signature[1]) != 'I') ||
@@ -4165,8 +4169,8 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 	 * We've disabled prefetch for some time now. Testing with XEN
 	 * kernels revealed a bug in the refetch if dom0 resides on a P600.
 	 */
-	if(board_id == 0x3225103C) {
-			__u32 dma_prefetch;
+	if (c->board_id == 0x3225103C) {
+		__u32 dma_prefetch;
 		__u32 dma_refetch;
 		dma_prefetch = readl(c->vaddr + I2O_DMA1_CFG);
 		dma_prefetch |= 0x8000;

