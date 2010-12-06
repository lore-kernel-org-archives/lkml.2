Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0LFX2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:28:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26978 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab0LFXZO (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 09/23] agp/amd-k7: Utilize the PCI API for creating/inserting pages.
Date: Mon,  6 Dec 2010 18:24:21 -0500
Message-Id: <1291677875-30493-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/amd-k7-agp.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index b1b4362..4be8f65 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -25,19 +25,23 @@ static struct pci_device_id agp_amdk7_pci_table[];
 struct amd_page_map {
 	unsigned long *real;
 	unsigned long __iomem *remapped;
+	dma_addr_t dma_addr;
 };
 
 static struct _amd_irongate_private {
 	volatile u8 __iomem *registers;
 	struct amd_page_map **gatt_pages;
 	int num_tables;
+	struct pci_dev *pcidev;
 } amd_irongate_private;
 
 static int amd_create_page_map(struct amd_page_map *page_map)
 {
 	int i;
 
-	page_map->real = (unsigned long *) __get_free_page(GFP_KERNEL);
+	page_map->real = (unsigned long *)pci_alloc_consistent(amd_irongate_private.pcidev,
+							       PAGE_SIZE,
+							       &page_map->dma_addr);
 	if (page_map->real == NULL)
 		return -ENOMEM;
 
@@ -48,7 +52,8 @@ static int amd_create_page_map(struct amd_page_map *page_map)
 					    PAGE_SIZE);
 	if (page_map->remapped == NULL) {
 		ClearPageReserved(virt_to_page(page_map->real));
-		free_page((unsigned long) page_map->real);
+		pci_free_consistent(amd_irongate_private.pcidev, PAGE_SIZE,
+				    (void *) page_map->real, page_map->dma_addr);
 		page_map->real = NULL;
 		return -ENOMEM;
 	}
@@ -74,7 +79,9 @@ static void amd_free_page_map(struct amd_page_map *page_map)
 #else
 	set_memory_wb((unsigned long)page_map->real, 1);
 #endif
-	free_page((unsigned long) page_map->real);
+	pci_free_consistent(amd_irongate_private.pcidev, PAGE_SIZE,
+			    (void *) page_map->real, page_map->dma_addr);
+	page_map->dma_addr = DMA_ERROR_CODE;
 }
 
 static void amd_free_gatt_pages(void)
@@ -161,7 +168,7 @@ static int amd_create_gatt_table(struct agp_bridge_data *bridge)
 
 	agp_bridge->gatt_table_real = (u32 *)page_dir.real;
 	agp_bridge->gatt_table = (u32 __iomem *)page_dir.remapped;
-	agp_bridge->gatt_bus_addr = virt_to_phys(page_dir.real);
+	agp_bridge->gatt_bus_addr = page_dir.dma_addr;
 
 	/* Get the address for the gart region.
 	 * This is a bus address even on the alpha, b/c its
@@ -174,7 +181,7 @@ static int amd_create_gatt_table(struct agp_bridge_data *bridge)
 
 	/* Calculate the agp offset */
 	for (i = 0; i < value->num_entries / 1024; i++, addr += 0x00400000) {
-		writel(virt_to_phys(amd_irongate_private.gatt_pages[i]->real) | 1,
+		writel(amd_irongate_private.gatt_pages[i]->dma_addr | 1,
 			page_dir.remapped+GET_PAGE_DIR_OFF(addr));
 		readl(page_dir.remapped+GET_PAGE_DIR_OFF(addr));	/* PCI Posting. */
 	}
@@ -334,7 +341,7 @@ static int amd_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 		addr = (j * PAGE_SIZE) + agp_bridge->gart_bus_addr;
 		cur_gatt = GET_GATT(addr);
 		writel(agp_generic_mask_memory(agp_bridge,
-					       page_to_phys(mem->pages[i]),
+					       mem->dma_addr[i],
 					       mem->type),
 		       cur_gatt+GET_GATT_OFF(addr));
 		readl(cur_gatt+GET_GATT_OFF(addr));	/* PCI Posting. */
@@ -447,6 +454,7 @@ static int __devinit agp_amdk7_probe(struct pci_dev *pdev,
 	bridge->dev_private_data = &amd_irongate_private,
 	bridge->dev = pdev;
 	bridge->capndx = cap_ptr;
+	amd_irongate_private.pcidev = bridge->dev;
 
 	/* 751 Errata (22564_B-1.PDF)
 	   erratum 20: strobe glitch with Nvidia NV10 GeForce cards.
-- 
1.7.1

