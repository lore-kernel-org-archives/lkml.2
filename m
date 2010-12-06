Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0LFXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:25:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27212 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab0LFXZY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Russ Anderson <rja@sgi.com>
Subject: [PATCH 21/23] agp/sgi: Use PCI API for inserting/creating pages on SGI Altix.
Date: Mon,  6 Dec 2010 18:24:33 -0500
Message-Id: <1291677875-30493-22-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SGI Altix code sets its own GATT up, but rulies on
agp_generic_destroy_page[|s] functions, which use the PCI API.

Interestingly the sgi_tioca_alloc_page, which this patch removes,
had an optimization to allocate pages from a specific node. This optimization
also exists in the SGI sn/pci/pci_dma.c code when setting up a page
and since agp_generic_alloc_page uses that, we end up using it
in the generic allocation path.

The other change is that this patch is to utilize the dma_addr[]
field instead of doing page_to_phys(mem->pages[]) as that has
already been done in the PCI API.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Russ Anderson <rja@sgi.com>
---
 drivers/char/agp/sgi-agp.c |   22 ++--------------------
 1 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index 4436438..fcaf16a 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -39,24 +39,6 @@ static struct aper_size_info_fixed sgi_tioca_sizes[] = {
 	{0, 0, 0},
 };
 
-static struct page *sgi_tioca_alloc_page(struct agp_bridge_data *bridge,
-					 dma_addr_t *dma_addr)
-{
-	struct page *page;
-	int nid;
-	struct tioca_kernel *info =
-	    (struct tioca_kernel *)bridge->dev_private_data;
-
-	nid = info->ca_closest_node;
-	page = alloc_pages_node(nid, GFP_KERNEL, 0);
-	if (!page)
-		return NULL;
-
-	get_page(page);
-	atomic_inc(&agp_bridge->current_memory_agp);
-	return page;
-}
-
 /*
  * Flush GART tlb's.  Cannot selectively flush based on memory so the mem
  * arg is ignored.
@@ -192,7 +174,7 @@ static int sgi_tioca_insert_memory(struct agp_memory *mem, off_t pg_start,
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		table[j] =
 		    bridge->driver->mask_memory(bridge,
-						page_to_phys(mem->pages[i]),
+						mem->dma_addr[i],
 						mem->type);
 	}
 
@@ -264,7 +246,7 @@ const struct agp_bridge_driver sgi_tioca_driver = {
 	.remove_memory = sgi_tioca_remove_memory,
 	.alloc_by_type = agp_generic_alloc_by_type,
 	.free_by_type = agp_generic_free_by_type,
-	.agp_alloc_page = sgi_tioca_alloc_page,
+	.agp_alloc_page = agp_generic_alloc_page,
 	.agp_destroy_page = agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture = true,
-- 
1.7.1

