Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab2J1IIH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:08:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55242 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754260Ab2J1IHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:07:54 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04/16] block: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:42 -0700
Message-Id: <e2b08ecd904211d8dcfca4ed2846747fdefdbe9c.1351411047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/umem.c |   97 +++++++++++++++++++++++---------------------------
 1 files changed, 45 insertions(+), 52 deletions(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index eb0d821..bd1c14c 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -461,18 +461,18 @@ static void process_page(unsigned long data)
 		if (control & DMASCR_HARD_ERROR) {
 			/* error */
 			clear_bit(BIO_UPTODATE, &bio->bi_flags);
-			dev_printk(KERN_WARNING, &card->dev->dev,
-				"I/O error on sector %d/%d\n",
-				le32_to_cpu(desc->local_addr)>>9,
-				le32_to_cpu(desc->transfer_size));
+			dev_warn(&card->dev->dev,
+				 "I/O error on sector %d/%d\n",
+				 le32_to_cpu(desc->local_addr)>>9,
+				 le32_to_cpu(desc->transfer_size));
 			dump_dmastat(card, control);
 		} else if ((bio->bi_rw & REQ_WRITE) &&
 			   le32_to_cpu(desc->local_addr) >> 9 ==
 				card->init_size) {
 			card->init_size += le32_to_cpu(desc->transfer_size) >> 9;
 			if (card->init_size >> 1 >= card->mm_size) {
-				dev_printk(KERN_INFO, &card->dev->dev,
-					"memory now initialised\n");
+				dev_info(&card->dev->dev,
+					 "memory now initialised\n");
 				set_userbit(card, MEMORY_INITIALIZED, 1);
 			}
 		}
@@ -591,17 +591,16 @@ HW_TRACE(0x30);
 		dump_dmastat(card, dma_status);
 
 		if (stat & 0x01)
-			dev_printk(KERN_ERR, &card->dev->dev,
+			dev_err(&card->dev->dev,
 				"Memory access error detected (err count %d)\n",
 				count);
 		if (stat & 0x02)
-			dev_printk(KERN_ERR, &card->dev->dev,
-				"Multi-bit EDC error\n");
+			dev_err(&card->dev->dev, "Multi-bit EDC error\n");
 
-		dev_printk(KERN_ERR, &card->dev->dev,
+		dev_err(&card->dev->dev,
 			"Fault Address 0x%02x%08x, Fault Data 0x%08x%08x\n",
 			addr_log2, addr_log1, data_log2, data_log1);
-		dev_printk(KERN_ERR, &card->dev->dev,
+		dev_err(&card->dev->dev,
 			"Fault Check 0x%02x, Fault Syndrome 0x%02x\n",
 			check, syndrome);
 
@@ -609,33 +608,31 @@ HW_TRACE(0x30);
 	}
 
 	if (dma_status & DMASCR_PARITY_ERR_REP) {
-		dev_printk(KERN_ERR, &card->dev->dev,
-			"PARITY ERROR REPORTED\n");
+		dev_err(&card->dev->dev, "PARITY ERROR REPORTED\n");
 		pci_read_config_word(card->dev, PCI_STATUS, &cfg_status);
 		pci_write_config_word(card->dev, PCI_STATUS, cfg_status);
 	}
 
 	if (dma_status & DMASCR_PARITY_ERR_DET) {
-		dev_printk(KERN_ERR, &card->dev->dev,
-			"PARITY ERROR DETECTED\n");
+		dev_err(&card->dev->dev, "PARITY ERROR DETECTED\n");
 		pci_read_config_word(card->dev, PCI_STATUS, &cfg_status);
 		pci_write_config_word(card->dev, PCI_STATUS, cfg_status);
 	}
 
 	if (dma_status & DMASCR_SYSTEM_ERR_SIG) {
-		dev_printk(KERN_ERR, &card->dev->dev, "SYSTEM ERROR\n");
+		dev_err(&card->dev->dev, "SYSTEM ERROR\n");
 		pci_read_config_word(card->dev, PCI_STATUS, &cfg_status);
 		pci_write_config_word(card->dev, PCI_STATUS, cfg_status);
 	}
 
 	if (dma_status & DMASCR_TARGET_ABT) {
-		dev_printk(KERN_ERR, &card->dev->dev, "TARGET ABORT\n");
+		dev_err(&card->dev->dev, "TARGET ABORT\n");
 		pci_read_config_word(card->dev, PCI_STATUS, &cfg_status);
 		pci_write_config_word(card->dev, PCI_STATUS, cfg_status);
 	}
 
 	if (dma_status & DMASCR_MASTER_ABT) {
-		dev_printk(KERN_ERR, &card->dev->dev, "MASTER ABORT\n");
+		dev_err(&card->dev->dev, "MASTER ABORT\n");
 		pci_read_config_word(card->dev, PCI_STATUS, &cfg_status);
 		pci_write_config_word(card->dev, PCI_STATUS, cfg_status);
 	}
@@ -676,19 +673,19 @@ static int check_battery(struct cardinfo *card, int battery, int status)
 		card->battery[battery].last_change = jiffies;
 
 		if (card->battery[battery].good) {
-			dev_printk(KERN_ERR, &card->dev->dev,
-				"Battery %d now good\n", battery + 1);
+			dev_err(&card->dev->dev, "Battery %d now good\n",
+				battery + 1);
 			card->battery[battery].warned = 0;
 		} else
-			dev_printk(KERN_ERR, &card->dev->dev,
-				"Battery %d now FAILED\n", battery + 1);
+			dev_err(&card->dev->dev, "Battery %d now FAILED\n",
+				battery + 1);
 
 		return 1;
 	} else if (!card->battery[battery].good &&
 		   !card->battery[battery].warned &&
 		   time_after_eq(jiffies, card->battery[battery].last_change +
 				 (HZ * 60 * 60 * 5))) {
-		dev_printk(KERN_ERR, &card->dev->dev,
+		dev_err(&card->dev->dev,
 			"Battery %d still FAILED after 5 hours\n", battery + 1);
 		card->battery[battery].warned = 1;
 
@@ -819,34 +816,31 @@ static int __devinit mm_pci_probe(struct pci_dev *dev,
 	if (!csr_base || !csr_len)
 		return -ENODEV;
 
-	dev_printk(KERN_INFO, &dev->dev,
-	  "Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))\n");
+	dev_info(&dev->dev,
+		 "Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))\n");
 
 	if (pci_set_dma_mask(dev, DMA_BIT_MASK(64)) &&
 	    pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
-		dev_printk(KERN_WARNING, &dev->dev, "NO suitable DMA found\n");
+		dev_warn(&dev->dev, "NO suitable DMA found\n");
 		return  -ENOMEM;
 	}
 
 	ret = pci_request_regions(dev, DRIVER_NAME);
 	if (ret) {
-		dev_printk(KERN_ERR, &card->dev->dev,
-			"Unable to request memory region\n");
+		dev_err(&card->dev->dev, "Unable to request memory region\n");
 		goto failed_req_csr;
 	}
 
 	card->csr_remap = ioremap_nocache(csr_base, csr_len);
 	if (!card->csr_remap) {
-		dev_printk(KERN_ERR, &card->dev->dev,
-			"Unable to remap memory region\n");
+		dev_err(&card->dev->dev, "Unable to remap memory region\n");
 		ret = -ENOMEM;
 
 		goto failed_remap_csr;
 	}
 
-	dev_printk(KERN_INFO, &card->dev->dev,
-		"CSR 0x%08lx -> 0x%p (0x%lx)\n",
-	       csr_base, card->csr_remap, csr_len);
+	dev_info(&card->dev->dev, "CSR 0x%08lx -> 0x%p (0x%lx)\n",
+		 csr_base, card->csr_remap, csr_len);
 
 	switch (card->dev->device) {
 	case 0x5415:
@@ -871,7 +865,7 @@ static int __devinit mm_pci_probe(struct pci_dev *dev,
 	}
 
 	if (readb(card->csr_remap + MEMCTRLSTATUS_MAGIC) != magic_number) {
-		dev_printk(KERN_ERR, &card->dev->dev, "Magic number invalid\n");
+		dev_err(&card->dev->dev, "Magic number invalid\n");
 		ret = -ENOMEM;
 		goto failed_magic;
 	}
@@ -884,7 +878,7 @@ static int __devinit mm_pci_probe(struct pci_dev *dev,
 						&card->mm_pages[1].page_dma);
 	if (card->mm_pages[0].desc == NULL ||
 	    card->mm_pages[1].desc == NULL) {
-		dev_printk(KERN_ERR, &card->dev->dev, "alloc failed\n");
+		dev_err(&card->dev->dev, "alloc failed\n");
 		goto failed_alloc;
 	}
 	reset_page(&card->mm_pages[0]);
@@ -939,16 +933,17 @@ static int __devinit mm_pci_probe(struct pci_dev *dev,
 	card->battery[0].last_change = card->battery[1].last_change = jiffies;
 
 	if (card->flags & UM_FLAG_NO_BATT)
-		dev_printk(KERN_INFO, &card->dev->dev,
-			"Size %d KB\n", card->mm_size);
+		dev_info(&card->dev->dev, "Size %d KB\n", card->mm_size);
 	else {
-		dev_printk(KERN_INFO, &card->dev->dev,
-			"Size %d KB, Battery 1 %s (%s), Battery 2 %s (%s)\n",
-		       card->mm_size,
-		       batt_status & BATTERY_1_DISABLED ? "Disabled" : "Enabled",
-		       card->battery[0].good ? "OK" : "FAILURE",
-		       batt_status & BATTERY_2_DISABLED ? "Disabled" : "Enabled",
-		       card->battery[1].good ? "OK" : "FAILURE");
+		dev_info(&card->dev->dev,
+			 "Size %d KB, Battery 1 %s (%s), Battery 2 %s (%s)\n",
+			 card->mm_size,
+			 batt_status & BATTERY_1_DISABLED ?
+			 "Disabled" : "Enabled",
+			 card->battery[0].good ? "OK" : "FAILURE",
+			 batt_status & BATTERY_2_DISABLED ?
+			 "Disabled" : "Enabled",
+			 card->battery[1].good ? "OK" : "FAILURE");
 
 		set_fault_to_battery_status(card);
 	}
@@ -964,14 +959,13 @@ static int __devinit mm_pci_probe(struct pci_dev *dev,
 
 	if (request_irq(dev->irq, mm_interrupt, IRQF_SHARED, DRIVER_NAME,
 			card)) {
-		dev_printk(KERN_ERR, &card->dev->dev,
-			"Unable to allocate IRQ\n");
+		dev_err(&card->dev->dev, "Unable to allocate IRQ\n");
 		ret = -ENODEV;
 		goto failed_req_irq;
 	}
 
-	dev_printk(KERN_INFO, &card->dev->dev,
-		"Window size %d bytes, IRQ %d\n", data, dev->irq);
+	dev_info(&card->dev->dev, "Window size %d bytes, IRQ %d\n",
+		 data, dev->irq);
 
 	spin_lock_init(&card->lock);
 
@@ -991,12 +985,11 @@ static int __devinit mm_pci_probe(struct pci_dev *dev,
 	num_cards++;
 
 	if (!get_userbit(card, MEMORY_INITIALIZED)) {
-		dev_printk(KERN_INFO, &card->dev->dev,
-		  "memory NOT initialized. Consider over-writing whole device.\n");
+		dev_info(&card->dev->dev,
+			 "memory NOT initialized. Consider over-writing whole device.\n");
 		card->init_size = 0;
 	} else {
-		dev_printk(KERN_INFO, &card->dev->dev,
-			"memory already initialized\n");
+		dev_info(&card->dev->dev, "memory already initialized\n");
 		card->init_size = card->mm_size;
 	}
 
-- 
1.7.8.112.g3fd21

