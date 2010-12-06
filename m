Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab0LFX3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:29:10 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26917 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab0LFXZM (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 11/23] agp/serverworks: Utilize the PCI API for allocating/inserting pages.
Date: Mon,  6 Dec 2010 18:24:23 -0500
Message-Id: <1291677875-30493-12-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/sworks-agp.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index 13acaaf..494cc65 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -31,6 +31,7 @@
 struct serverworks_page_map {
 	unsigned long *real;
 	unsigned long __iomem *remapped;
+	dma_addr_t dma_addr;
 };
 
 static struct _serverworks_private {
@@ -48,7 +49,10 @@ static int serverworks_create_page_map(struct serverworks_page_map *page_map)
 {
 	int i;
 
-	page_map->real = (unsigned long *) __get_free_page(GFP_KERNEL);
+	page_map->real = (unsigned long *)pci_alloc_consistent(serverworks_private.svrwrks_dev,
+							       PAGE_SIZE,
+							       &page_map->dma_addr);
+
 	if (page_map->real == NULL) {
 		return -ENOMEM;
 	}
@@ -66,7 +70,9 @@ static int serverworks_create_page_map(struct serverworks_page_map *page_map)
 static void serverworks_free_page_map(struct serverworks_page_map *page_map)
 {
 	set_memory_wb((unsigned long)page_map->real, 1);
-	free_page((unsigned long) page_map->real);
+	pci_free_consistent(serverworks_private.svrwrks_dev, PAGE_SIZE,
+			    (void *) page_map->real, page_map->dma_addr);
+	page_map->dma_addr = DMA_ERROR_CODE;
 }
 
 static void serverworks_free_gatt_pages(void)
@@ -155,7 +161,7 @@ static int serverworks_create_gatt_table(struct agp_bridge_data *bridge)
 	/* Create a fake scratch directory */
 	for (i = 0; i < 1024; i++) {
 		writel(agp_bridge->scratch_page, serverworks_private.scratch_dir.remapped+i);
-		writel(virt_to_phys(serverworks_private.scratch_dir.real) | 1, page_dir.remapped+i);
+		writel(serverworks_private.scratch_dir.dma_addr | 1, page_dir.remapped+i);
 	}
 
 	retval = serverworks_create_gatt_pages(value->num_entries / 1024);
@@ -167,7 +173,7 @@ static int serverworks_create_gatt_table(struct agp_bridge_data *bridge)
 
 	agp_bridge->gatt_table_real = (u32 *)page_dir.real;
 	agp_bridge->gatt_table = (u32 __iomem *)page_dir.remapped;
-	agp_bridge->gatt_bus_addr = virt_to_phys(page_dir.real);
+	agp_bridge->gatt_bus_addr = page_dir.dma_addr;
 
 	/* Get the address for the gart region.
 	 * This is a bus address even on the alpha, b/c its
@@ -179,7 +185,7 @@ static int serverworks_create_gatt_table(struct agp_bridge_data *bridge)
 
 	/* Calculate the agp offset */
 	for (i = 0; i < value->num_entries / 1024; i++)
-		writel(virt_to_phys(serverworks_private.gatt_pages[i]->real)|1, page_dir.remapped+i);
+		writel(serverworks_private.gatt_pages[i]->dma_addr|1, page_dir.remapped+i);
 
 	return 0;
 }
@@ -350,7 +356,7 @@ static int serverworks_insert_memory(struct agp_memory *mem,
 		addr = (j * PAGE_SIZE) + agp_bridge->gart_bus_addr;
 		cur_gatt = SVRWRKS_GET_GATT(addr);
 		writel(agp_bridge->driver->mask_memory(agp_bridge, 
-				page_to_phys(mem->pages[i]), mem->type),
+				mem->dma_addr[i], mem->type),
 		       cur_gatt+GET_GATT_OFF(addr));
 	}
 	serverworks_tlbflush(mem);
-- 
1.7.1

