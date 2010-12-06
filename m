Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0LFX2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:28:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26957 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab0LFXZN (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 12/23] agp/intel-gtt: Utilize the PCI DMA for i8xxx,
Date: Mon,  6 Dec 2010 18:24:24 -0500
Message-Id: <1291677875-30493-13-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AGP drivers for newer chipsets (ICH9 and higher) use
the PCI DMA and get the proper bus address.

For older "legacy" code (say ICH5), this has not been done.
To make those chipsets work properly, we need to program the
bus address of the pages in GATT with the correct address.

When running under Xen, the old trick of PFN << PAGE_SIZE == phys
does not work as the PFN is not neccessary equal to the "real" hardware
PFN (called 'MFN'). As such we need to use the PCI API.

Currently the code works alongside the newer code that
uses scatterlist. In the future we can squish those together.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/intel-gtt.c |   54 +++++++++++++++++++++++++++++++-----------
 1 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index dcd8894..e984559 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -248,17 +248,21 @@ static void intel_fake_agp_enable(struct agp_bridge_data *bridge, u32 mode)
 }
 
 /* Exists to support ARGB cursors */
-static struct page *i8xx_alloc_pages(void)
+static struct page *i8xx_alloc_pages(dma_addr_t *dma_addr)
 {
 	struct page *page;
+	void *addr;
 
-	page = alloc_pages(GFP_KERNEL | GFP_DMA32, 2);
-	if (page == NULL)
+	addr = pci_alloc_consistent(intel_private.pcidev, 4 * PAGE_SIZE,
+				    dma_addr);
+	if (addr == NULL)
 		return NULL;
-
+	page = virt_to_page(addr);
 	if (set_pages_uc(page, 4) < 0) {
 		set_pages_wb(page, 4);
-		__free_pages(page, 2);
+		pci_free_consistent(intel_private.pcidev, 4 * PAGE_SIZE,
+				    addr, *dma_addr);
+		*dma_addr = DMA_ERROR_CODE;
 		return NULL;
 	}
 	get_page(page);
@@ -266,14 +270,18 @@ static struct page *i8xx_alloc_pages(void)
 	return page;
 }
 
-static void i8xx_destroy_pages(struct page *page)
+static void i8xx_destroy_pages(struct page *page, dma_addr_t *dma_addr)
 {
+	void *addr;
 	if (page == NULL)
 		return;
 
 	set_pages_wb(page, 4);
 	put_page(page);
-	__free_pages(page, 2);
+	addr = page_address(page);
+	pci_free_consistent(intel_private.pcidev, 4 * PAGE_SIZE,
+			    addr, *dma_addr);
+	*dma_addr = DMA_ERROR_CODE;
 	atomic_dec(&agp_bridge->current_memory_agp);
 }
 
@@ -322,8 +330,14 @@ static int intel_i810_insert_entries(struct agp_memory *mem, off_t pg_start,
 		if (!mem->is_flushed)
 			global_cache_flush();
 		for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
+			dma_addr_t addr = mem->dma_addr[i];
+			if (addr == DMA_ERROR_CODE) {
+				WARN_ONCE(1, "Caller hasn't converted to DMA" \
+					  "API!\n");
+				addr = page_to_phys(mem->pages[i]);
+			}
 			writel(agp_bridge->driver->mask_memory(agp_bridge,
-					page_to_phys(mem->pages[i]), mask_type),
+					addr, mask_type),
 			       intel_private.registers+I810_PTE_BASE+(j*4));
 		}
 		readl(intel_private.registers+I810_PTE_BASE+((j-1)*4));
@@ -371,7 +385,7 @@ static struct agp_memory *alloc_agpphysmem_i8xx(size_t pg_count, int type)
 		break;
 	case 4:
 		/* kludge to get 4 physical pages for ARGB cursor */
-		page = i8xx_alloc_pages();
+		page = i8xx_alloc_pages(&dma_addr[0]);
 		break;
 	default:
 		return NULL;
@@ -385,11 +399,15 @@ static struct agp_memory *alloc_agpphysmem_i8xx(size_t pg_count, int type)
 		return NULL;
 
 	new->pages[0] = page;
+	new->dma_addr[0] = dma_addr[0];
 	if (pg_count == 4) {
 		/* kludge to get 4 physical pages for ARGB cursor */
 		new->pages[1] = new->pages[0] + 1;
 		new->pages[2] = new->pages[1] + 1;
 		new->pages[3] = new->pages[2] + 1;
+		new->dma_addr[1] = dma_addr[0] + PAGE_SIZE;
+		new->dma_addr[2] = dma_addr[1] + PAGE_SIZE;
+		new->dma_addr[3] = dma_addr[2] + PAGE_SIZE;
 	}
 	new->page_count = pg_count;
 	new->num_scratch_pages = pg_count;
@@ -426,7 +444,7 @@ static void intel_i810_free_by_type(struct agp_memory *curr)
 	agp_free_key(curr->key);
 	if (curr->type == AGP_PHYS_MEMORY) {
 		if (curr->page_count == 4)
-			i8xx_destroy_pages(curr->pages[0]);
+			i8xx_destroy_pages(curr->pages[0], &curr->dma_addr[0]);
 		else {
 			agp_bridge->driver->agp_destroy_page(curr->pages[0],
 							     AGP_PAGE_DESTROY_UNMAP,
@@ -451,10 +469,13 @@ static int intel_gtt_setup_scratch_page(void)
 {
 	struct page *page;
 	dma_addr_t dma_addr;
+	void *addr;
 
-	page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
-	if (page == NULL)
+	addr = pci_alloc_consistent(intel_private.pcidev, PAGE_SIZE, &dma_addr);
+	if (addr == NULL)
 		return -ENOMEM;
+
+	page = virt_to_page(addr);
 	get_page(page);
 	set_pages_uc(page, 1);
 
@@ -466,7 +487,7 @@ static int intel_gtt_setup_scratch_page(void)
 
 		intel_private.scratch_page_dma = dma_addr;
 	} else
-		intel_private.scratch_page_dma = page_to_phys(page);
+		intel_private.scratch_page_dma = dma_addr;
 
 	intel_private.scratch_page = page;
 
@@ -1031,7 +1052,12 @@ static int intel_fake_agp_insert_entries(struct agp_memory *mem,
 					    pg_start, type);
 	} else {
 		for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
-			dma_addr_t addr = page_to_phys(mem->pages[i]);
+			dma_addr_t addr = mem->dma_addr[i];
+			if (addr == DMA_ERROR_CODE) {
+				WARN_ONCE(1, "Caller hasn't converted to DMA "\
+					  "API!\n");
+				addr = page_to_phys(mem->pages[i]);
+			}
 			intel_private.driver->write_entry(addr,
 							  j, type);
 		}
-- 
1.7.1

