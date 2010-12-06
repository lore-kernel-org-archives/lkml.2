Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0LFXZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:25:13 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26822 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab0LFXZK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 14/23] ia64/agp/i460: Use PCI API for inserting pages in DIG (non-VT-d) platforms.
Date: Mon,  6 Dec 2010 18:24:26 -0500
Message-Id: <1291677875-30493-15-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i460-agp.c code sets its own GATT up, but relies on
agp_generic_[alloc|destroy]_page[|s] functions, which use the PCI API.

The code can support large-pages (more than 4KB) but the code is
disabled with "insane" comment so did not attempt to grok it.

Following the chain of functions that pci_alloc_consistent does
on a DIG platform it ends up using the SWIOTLB. The SWIOTLB calls
ia64_swiotlb_alloc_coherent which ends up calling alloc_page.

The dma_address they come up with is virt_to_phys(addr) or in case
of needing to use the SWIOTLB, it is the DMA address of the virtual
pages in SWIOTLB pool.

Since the dma_addr[i] ends up having the value from virt_to_phys(addr)
or page_to_phys(addr), lets utilize the dma_addr[i] and stick
a WARN_ON just in case.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/i460-agp.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
index 75b763c..bfd9234 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -297,8 +297,8 @@ static int i460_insert_memory_small_io_page (struct agp_memory *mem,
 	int i, j, k, num_entries;
 	void *temp;
 
-	pr_debug("i460_insert_memory_small_io_page(mem=%p, pg_start=%ld, type=%d, paddr0=0x%lx)\n",
-		 mem, pg_start, type, page_to_phys(mem->pages[0]));
+	pr_debug("i460_insert_memory_small_io_page(mem=%p, pg_start=%ld, type=%d, paddr0=0x%lx (0x%lx)\n",
+		 mem, pg_start, type, page_to_phys(mem->pages[0]),(unsigned long)mem->dma_addr[0]);
 
 	if (type >= AGP_USER_TYPES || mem->type >= AGP_USER_TYPES)
 		return -EINVAL;
@@ -325,7 +325,8 @@ static int i460_insert_memory_small_io_page (struct agp_memory *mem,
 
 	io_page_size = 1UL << I460_IO_PAGE_SHIFT;
 	for (i = 0, j = io_pg_start; i < mem->page_count; i++) {
-		paddr = page_to_phys(mem->pages[i]);
+		paddr = mem->dma_addr[i];
+		WARN_ON(page_to_phys(mem->pages[i]) != paddr);
 		for (k = 0; k < I460_IOPAGES_PER_KPAGE; k++, j++, paddr += io_page_size)
 			WR_GATT(j, i460_mask_memory(agp_bridge, paddr, mem->type));
 	}
-- 
1.7.1

