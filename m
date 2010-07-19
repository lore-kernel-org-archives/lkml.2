Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936500Ab0GSSj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:39:27 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26225 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192Ab0GSSjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:39:20 -0400
Subject: [PATCH 02/26] cciss: save pdev pointer in per hba structure early to
	avoid passing it around so much.
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:44:50 -0500
Message-ID: <20100719184450.7908.59976.stgit@beardog.cce.hp.com>
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

cciss: save pdev pointer in per hba structure early to avoid passing it around so much.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   61 +++++++++++++++++++++++++------------------------
 1 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 665a470..b79ce8e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -199,8 +199,7 @@ static void cciss_geometry_inquiry(int ctlr, int logvol,
 			sector_t total_size,
 			unsigned int block_size, InquiryData_struct *inq_buff,
 				   drive_info_struct *drv);
-static void __devinit cciss_interrupt_mode(ctlr_info_t *, struct pci_dev *,
-					   __u32);
+static void __devinit cciss_interrupt_mode(ctlr_info_t *, __u32);
 static void start_io(ctlr_info_t *h);
 static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
 			__u8 page_code, unsigned char scsi3addr[],
@@ -3933,8 +3932,7 @@ clean_up:
  * controllers that are capable. If not, we use IO-APIC mode.
  */
 
-static void __devinit cciss_interrupt_mode(ctlr_info_t *c,
-					   struct pci_dev *pdev, __u32 board_id)
+static void __devinit cciss_interrupt_mode(ctlr_info_t *c, __u32 board_id)
 {
 #ifdef CONFIG_PCI_MSI
 	int err;
@@ -3948,8 +3946,8 @@ static void __devinit cciss_interrupt_mode(ctlr_info_t *c,
 	    (board_id == 0x40820E11) || (board_id == 0x40830E11))
 		goto default_int_mode;
 
-	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
-		err = pci_enable_msix(pdev, cciss_msix_entries, 4);
+	if (pci_find_capability(c->pdev, PCI_CAP_ID_MSIX)) {
+		err = pci_enable_msix(c->pdev, cciss_msix_entries, 4);
 		if (!err) {
 			c->intr[0] = cciss_msix_entries[0].vector;
 			c->intr[1] = cciss_msix_entries[1].vector;
@@ -3968,8 +3966,8 @@ static void __devinit cciss_interrupt_mode(ctlr_info_t *c,
 			goto default_int_mode;
 		}
 	}
-	if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
-		if (!pci_enable_msi(pdev)) {
+	if (pci_find_capability(c->pdev, PCI_CAP_ID_MSI)) {
+		if (!pci_enable_msi(c->pdev)) {
 			c->msi_vector = 1;
 		} else {
 			printk(KERN_WARNING "cciss: MSI init failed\n");
@@ -3978,11 +3976,11 @@ static void __devinit cciss_interrupt_mode(ctlr_info_t *c,
 default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
 	/* if we get here we're going to use the default interrupt mode */
-	c->intr[PERF_MODE_INT] = pdev->irq;
+	c->intr[PERF_MODE_INT] = c->pdev->irq;
 	return;
 }
 
-static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
+static int __devinit cciss_pci_init(ctlr_info_t *c)
 {
 	ushort subsystem_vendor_id, subsystem_device_id, command;
 	__u32 board_id, scratchpad = 0;
@@ -3992,8 +3990,8 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	int i, prod_index, err;
 	__u32 trans_offset;
 
-	subsystem_vendor_id = pdev->subsystem_vendor;
-	subsystem_device_id = pdev->subsystem_device;
+	subsystem_vendor_id = c->pdev->subsystem_vendor;
+	subsystem_device_id = c->pdev->subsystem_device;
 	board_id = (((__u32) (subsystem_device_id << 16) & 0xffff0000) |
 		    subsystem_vendor_id);
 
@@ -4006,7 +4004,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	}
 	prod_index = i;
 	if (prod_index == ARRAY_SIZE(products)) {
-		dev_warn(&pdev->dev,
+		dev_warn(&c->pdev->dev,
 			"unrecognized board ID: 0x%08lx, ignoring.\n",
 			(unsigned long) board_id);
 		return -ENODEV;
@@ -4014,20 +4012,20 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 
 	/* check to see if controller has been disabled */
 	/* BEFORE trying to enable it */
-	(void)pci_read_config_word(pdev, PCI_COMMAND, &command);
+	(void)pci_read_config_word(c->pdev, PCI_COMMAND, &command);
 	if (!(command & 0x02)) {
 		printk(KERN_WARNING
 		       "cciss: controller appears to be disabled\n");
 		return -ENODEV;
 	}
 
-	err = pci_enable_device(pdev);
+	err = pci_enable_device(c->pdev);
 	if (err) {
 		printk(KERN_ERR "cciss: Unable to Enable PCI device\n");
 		return err;
 	}
 
-	err = pci_request_regions(pdev, "cciss");
+	err = pci_request_regions(c->pdev, "cciss");
 	if (err) {
 		printk(KERN_ERR "cciss: Cannot obtain PCI resources, "
 		       "aborting\n");
@@ -4035,19 +4033,19 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 	}
 
 #ifdef CCISS_DEBUG
-	printk("command = %x\n", command);
-	printk("irq = %x\n", pdev->irq);
-	printk("board_id = %x\n", board_id);
+	printk(KERN_INFO "command = %x\n", command);
+	printk(KERN_INFO "irq = %x\n", c->pdev->irq);
+	printk(KERN_INFO "board_id = %x\n", board_id);
 #endif				/* CCISS_DEBUG */
 
 /* If the kernel supports MSI/MSI-X we will try to enable that functionality,
  * else we use the IO-APIC interrupt assigned to us by system ROM.
  */
-	cciss_interrupt_mode(c, pdev, board_id);
+	cciss_interrupt_mode(c, board_id);
 
 	/* find the memory BAR */
 	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM)
+		if (pci_resource_flags(c->pdev, i) & IORESOURCE_MEM)
 			break;
 	}
 	if (i == DEVICE_COUNT_RESOURCE) {
@@ -4056,7 +4054,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 		goto err_out_free_res;
 	}
 
-	c->paddr = pci_resource_start(pdev, i); /* addressing mode bits
+	c->paddr = pci_resource_start(c->pdev, i); /* addressing mode bits
 						 * already removed
 						 */
 
@@ -4086,7 +4084,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 #ifdef CCISS_DEBUG
 	printk("cfg base address = %x\n", cfg_base_addr);
 #endif				/* CCISS_DEBUG */
-	cfg_base_addr_index = find_PCI_BAR_index(pdev, cfg_base_addr);
+	cfg_base_addr_index = find_PCI_BAR_index(c->pdev, cfg_base_addr);
 #ifdef CCISS_DEBUG
 	printk("cfg base address index = %llx\n",
 		(unsigned long long)cfg_base_addr_index);
@@ -4101,12 +4099,12 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 #ifdef CCISS_DEBUG
 	printk("cfg offset = %llx\n", (unsigned long long)cfg_offset);
 #endif				/* CCISS_DEBUG */
-	c->cfgtable = remap_pci_mem(pci_resource_start(pdev,
+	c->cfgtable = remap_pci_mem(pci_resource_start(c->pdev,
 						       cfg_base_addr_index) +
 				    cfg_offset, sizeof(CfgTable_struct));
 	/* Find performant mode table. */
 	trans_offset = readl(&(c->cfgtable->TransMethodOffset));
-	c->transtable = remap_pci_mem(pci_resource_start(pdev,
+	c->transtable = remap_pci_mem(pci_resource_start(c->pdev,
 		cfg_base_addr_index) + cfg_offset+trans_offset,
 		sizeof(*c->transtable));
 	c->board_id = board_id;
@@ -4173,9 +4171,11 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 		dma_prefetch = readl(c->vaddr + I2O_DMA1_CFG);
 		dma_prefetch |= 0x8000;
 		writel(dma_prefetch, c->vaddr + I2O_DMA1_CFG);
-		pci_read_config_dword(pdev, PCI_COMMAND_PARITY, &dma_refetch);
+		pci_read_config_dword(c->pdev, PCI_COMMAND_PARITY,
+			&dma_refetch);
 		dma_refetch |= 0x1;
-		pci_write_config_dword(pdev, PCI_COMMAND_PARITY, dma_refetch);
+		pci_write_config_dword(c->pdev, PCI_COMMAND_PARITY,
+			dma_refetch);
 	}
 
 #ifdef CCISS_DEBUG
@@ -4189,7 +4189,7 @@ err_out_free_res:
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
-	pci_release_regions(pdev);
+	pci_release_regions(c->pdev);
 	return err;
 }
 
@@ -4466,17 +4466,18 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	i = alloc_cciss_hba();
 	if (i < 0)
 		return -1;
+
+	hba[i]->pdev = pdev;
 	hba[i]->busy_initializing = 1;
 	INIT_HLIST_HEAD(&hba[i]->cmpQ);
 	INIT_HLIST_HEAD(&hba[i]->reqQ);
 	mutex_init(&hba[i]->busy_shutting_down);
 
-	if (cciss_pci_init(hba[i], pdev) != 0)
+	if (cciss_pci_init(hba[i]) != 0)
 		goto clean_no_release_regions;
 
 	sprintf(hba[i]->devname, "cciss%d", i);
 	hba[i]->ctlr = i;
-	hba[i]->pdev = pdev;
 
 	init_completion(&hba[i]->scan_wait);
 

