Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0LFX0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:26:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27254 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab0LFXZc (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 10/23] ati/agp: Utilize the PCI API for creating/inserting pages.
Date: Mon,  6 Dec 2010 18:24:22 -0500
Message-Id: <1291677875-30493-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/ati-agp.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index dc30e22..9c8d19d 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -44,19 +44,23 @@ static struct gatt_mask ati_generic_masks[] =
 struct ati_page_map {
 	unsigned long *real;
 	unsigned long __iomem *remapped;
+	dma_addr_t dma_addr;
 };
 
 static struct _ati_generic_private {
 	volatile u8 __iomem *registers;
 	struct ati_page_map **gatt_pages;
 	int num_tables;
+	struct pci_dev *pcidev;
 } ati_generic_private;
 
 static int ati_create_page_map(struct ati_page_map *page_map)
 {
 	int i, err = 0;
 
-	page_map->real = (unsigned long *) __get_free_page(GFP_KERNEL);
+	page_map->real = (unsigned long *) pci_alloc_consistent(ati_generic_private.pcidev,
+								PAGE_SIZE,
+								&page_map->dma_addr);
 	if (page_map->real == NULL)
 		return -ENOMEM;
 
@@ -77,7 +81,9 @@ static void ati_free_page_map(struct ati_page_map *page_map)
 {
 	unmap_page_from_agp(virt_to_page(page_map->real));
 	set_memory_wb((unsigned long)page_map->real, 1);
-	free_page((unsigned long) page_map->real);
+	pci_free_consistent(ati_generic_private.pcidev, PAGE_SIZE,
+			    (void *)page_map->real, page_map->dma_addr);
+	page_map->dma_addr = DMA_ERROR_CODE;
 }
 
 
@@ -302,7 +308,7 @@ static int ati_insert_memory(struct agp_memory * mem,
 		addr = (j * PAGE_SIZE) + agp_bridge->gart_bus_addr;
 		cur_gatt = GET_GATT(addr);
 		writel(agp_bridge->driver->mask_memory(agp_bridge,	
-						       page_to_phys(mem->pages[i]),
+						       mem->dma_addr[i],
 						       mem->type),
 		       cur_gatt+GET_GATT_OFF(addr));
 	}
@@ -361,7 +367,7 @@ static int ati_create_gatt_table(struct agp_bridge_data *bridge)
 
 	agp_bridge->gatt_table_real = (u32 *)page_dir.real;
 	agp_bridge->gatt_table = (u32 __iomem *) page_dir.remapped;
-	agp_bridge->gatt_bus_addr = virt_to_phys(page_dir.real);
+	agp_bridge->gatt_bus_addr = page_dir.dma_addr;
 
 	/* Write out the size register */
 	current_size = A_SIZE_LVL2(agp_bridge->current_size);
@@ -391,7 +397,7 @@ static int ati_create_gatt_table(struct agp_bridge_data *bridge)
 
 	/* Calculate the agp offset */
 	for (i = 0; i < value->num_entries / 1024; i++, addr += 0x00400000) {
-		writel(virt_to_phys(ati_generic_private.gatt_pages[i]->real) | 1,
+		writel(ati_generic_private.gatt_pages[i]->dma_addr | 1,
 			page_dir.remapped+GET_PAGE_DIR_OFF(addr));
 		readl(page_dir.remapped+GET_PAGE_DIR_OFF(addr));	/* PCI Posting. */
 	}
@@ -521,9 +527,9 @@ found:
 	bridge->capndx = cap_ptr;
 
 	bridge->driver = &ati_generic_bridge;
-
 	dev_info(&pdev->dev, "Ati %s chipset\n", devs[j].chipset_name);
 
+	ati_generic_private.pcidev = pdev;
 	/* Fill in the mode register */
 	pci_read_config_dword(pdev,
 			bridge->capndx+PCI_AGP_STATUS,
-- 
1.7.1

