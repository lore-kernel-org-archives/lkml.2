Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0LFXZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:25:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27239 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab0LFXZ3 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:29 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 05/23] agp: Make agp_generic_[alloc|destroy]_page use _agp_[alloc|free]_page macro.
Date: Mon,  6 Dec 2010 18:24:17 -0500
Message-Id: <1291677875-30493-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad@kernel.org>

This change is purely synthetic. We are adding in an extra
argument to agp_generic_[alloc|destroy] which is the dma_addr value.

We also update all drivers to be compile error-free.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/agp.h       |    8 ++++----
 drivers/char/agp/ali-agp.c   |   16 +++++++++-------
 drivers/char/agp/backend.c   |   17 +++++++++++------
 drivers/char/agp/generic.c   |   17 ++++++++++-------
 drivers/char/agp/intel-gtt.c |    9 ++++++---
 drivers/char/agp/sgi-agp.c   |    3 ++-
 6 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 5259065..6c60d68 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -115,9 +115,9 @@ struct agp_bridge_driver {
 	int (*remove_memory)(struct agp_memory *, off_t, int);
 	struct agp_memory *(*alloc_by_type) (size_t, int);
 	void (*free_by_type)(struct agp_memory *);
-	struct page *(*agp_alloc_page)(struct agp_bridge_data *);
+	struct page *(*agp_alloc_page)(struct agp_bridge_data *, dma_addr_t *dma_addr);
 	int (*agp_alloc_pages)(struct agp_bridge_data *, struct agp_memory *, size_t);
-	void (*agp_destroy_page)(struct page *, int flags);
+	void (*agp_destroy_page)(struct page *, int flags, dma_addr_t *dma_addr);
 	void (*agp_destroy_pages)(struct agp_memory *);
 	int (*agp_type_to_mask_type) (struct agp_bridge_data *, int);
 	void (*chipset_flush)(struct agp_bridge_data *);
@@ -199,10 +199,10 @@ int agp_generic_insert_memory(struct agp_memory *mem, off_t pg_start, int type);
 int agp_generic_remove_memory(struct agp_memory *mem, off_t pg_start, int type);
 struct agp_memory *agp_generic_alloc_by_type(size_t page_count, int type);
 void agp_generic_free_by_type(struct agp_memory *curr);
-struct page *agp_generic_alloc_page(struct agp_bridge_data *bridge);
+struct page *agp_generic_alloc_page(struct agp_bridge_data *bridge, dma_addr_t *dma_addr);
 int agp_generic_alloc_pages(struct agp_bridge_data *agp_bridge,
 			    struct agp_memory *memory, size_t page_count);
-void agp_generic_destroy_page(struct page *page, int flags);
+void agp_generic_destroy_page(struct page *page, int flags, dma_addr_t *dma_addr);
 void agp_generic_destroy_pages(struct agp_memory *memory);
 void agp_free_key(int key);
 int agp_num_entries(void);
diff --git a/drivers/char/agp/ali-agp.c b/drivers/char/agp/ali-agp.c
index fd79351..ede9d0a 100644
--- a/drivers/char/agp/ali-agp.c
+++ b/drivers/char/agp/ali-agp.c
@@ -141,9 +141,10 @@ static void m1541_cache_flush(void)
 	}
 }
 
-static struct page *m1541_alloc_page(struct agp_bridge_data *bridge)
+static struct page *m1541_alloc_page(struct agp_bridge_data *bridge,
+				     dma_addr_t *dma_addr)
 {
-	struct page *page = agp_generic_alloc_page(agp_bridge);
+	struct page *page = agp_generic_alloc_page(agp_bridge, dma_addr);
 	u32 temp;
 
 	if (!page)
@@ -156,18 +157,19 @@ static struct page *m1541_alloc_page(struct agp_bridge_data *bridge)
 	return page;
 }
 
-static void ali_destroy_page(struct page *page, int flags)
+static void ali_destroy_page(struct page *page, int flags, dma_addr_t *dma_addr)
 {
 	if (page) {
 		if (flags & AGP_PAGE_DESTROY_UNMAP) {
 			global_cache_flush();	/* is this really needed?  --hch */
-			agp_generic_destroy_page(page, flags);
+			agp_generic_destroy_page(page, flags, dma_addr);
 		} else
-			agp_generic_destroy_page(page, flags);
+			agp_generic_destroy_page(page, flags, dma_addr);
 	}
 }
 
-static void m1541_destroy_page(struct page *page, int flags)
+static void m1541_destroy_page(struct page *page, int flags,
+			       dma_addr_t *dma_addr)
 {
 	u32 temp;
 
@@ -182,7 +184,7 @@ static void m1541_destroy_page(struct page *page, int flags)
 				       (((temp & ALI_CACHE_FLUSH_ADDR_MASK) |
 					 page_to_phys(page)) | ALI_CACHE_FLUSH_EN));
 	}
-	agp_generic_destroy_page(page, flags);
+	agp_generic_destroy_page(page, flags, dma_addr);
 }
 
 
diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index f27d0d0..d119e89 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -142,7 +142,9 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 	bridge->version = &agp_current_version;
 
 	if (bridge->driver->needs_scratch_page) {
-		struct page *page = bridge->driver->agp_alloc_page(bridge);
+		struct page *page;
+		page = bridge->driver->agp_alloc_page(bridge,
+					&bridge->scratch_page_dma);
 
 		if (!page) {
 			dev_err(&bridge->dev->dev,
@@ -151,7 +153,6 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 		}
 
 		bridge->scratch_page_page = page;
-		bridge->scratch_page_dma = page_to_phys(page);
 
 		bridge->scratch_page = bridge->driver->mask_memory(bridge,
 						   bridge->scratch_page_dma, 0);
@@ -197,8 +198,10 @@ err_out:
 	if (bridge->driver->needs_scratch_page) {
 		void *va = page_address(bridge->scratch_page_page);
 
-		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
-		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
+		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP,
+						 &bridge->scratch_page_dma);
+		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE,
+						 &bridge->scratch_page_dma);
 	}
 	if (got_gatt)
 		bridge->driver->free_gatt_table(bridge);
@@ -224,8 +227,10 @@ static void agp_backend_cleanup(struct agp_bridge_data *bridge)
 	    bridge->driver->needs_scratch_page) {
 		void *va = page_address(bridge->scratch_page_page);
 
-		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
-		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
+		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP,
+						 &bridge->scratch_page_dma);
+		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE,
+						 &bridge->scratch_page_dma);
 	}
 }
 
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index cf465b5..65fd7c7 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -212,12 +212,14 @@ void agp_free_memory(struct agp_memory *curr)
 			for (i = 0; i < curr->page_count; i++) {
 				curr->bridge->driver->agp_destroy_page(
 					curr->pages[i],
-					AGP_PAGE_DESTROY_UNMAP);
+					AGP_PAGE_DESTROY_UNMAP,
+					&curr->dma_addr[i]);
 			}
 			for (i = 0; i < curr->page_count; i++) {
 				curr->bridge->driver->agp_destroy_page(
 					curr->pages[i],
-					AGP_PAGE_DESTROY_FREE);
+					AGP_PAGE_DESTROY_FREE,
+					&curr->dma_addr[i]);
 			}
 		}
 	}
@@ -284,7 +286,8 @@ struct agp_memory *agp_allocate_memory(struct agp_bridge_data *bridge,
 	}
 
 	for (i = 0; i < page_count; i++) {
-		struct page *page = bridge->driver->agp_alloc_page(bridge);
+		struct page *page;
+		page = bridge->driver->agp_alloc_page(bridge, &new->dma_addr[i]);
 
 		if (page == NULL) {
 			agp_free_memory(new);
@@ -1257,11 +1260,11 @@ out:
 }
 EXPORT_SYMBOL(agp_generic_alloc_pages);
 
-struct page *agp_generic_alloc_page(struct agp_bridge_data *bridge)
+struct page *agp_generic_alloc_page(struct agp_bridge_data *bridge, dma_addr_t *dma_addr)
 {
 	struct page * page;
 
-	page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
+	page = _agp_alloc_page(agp_bridge, dma_addr);
 	if (page == NULL)
 		return NULL;
 
@@ -1299,7 +1302,7 @@ void agp_generic_destroy_pages(struct agp_memory *mem)
 }
 EXPORT_SYMBOL(agp_generic_destroy_pages);
 
-void agp_generic_destroy_page(struct page *page, int flags)
+void agp_generic_destroy_page(struct page *page, int flags, dma_addr_t *dma_addr)
 {
 	if (page == NULL)
 		return;
@@ -1309,7 +1312,7 @@ void agp_generic_destroy_page(struct page *page, int flags)
 
 	if (flags & AGP_PAGE_DESTROY_FREE) {
 		put_page(page);
-		__free_page(page);
+		_agp_free_page(agp_bridge, page, dma_addr);
 		atomic_dec(&agp_bridge->current_memory_agp);
 	}
 }
diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 9272c38..dcd8894 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -364,9 +364,10 @@ static struct agp_memory *alloc_agpphysmem_i8xx(size_t pg_count, int type)
 {
 	struct agp_memory *new;
 	struct page *page;
+	dma_addr_t dma_addr[4];
 
 	switch (pg_count) {
-	case 1: page = agp_bridge->driver->agp_alloc_page(agp_bridge);
+	case 1: page = agp_bridge->driver->agp_alloc_page(agp_bridge, &dma_addr[0]);
 		break;
 	case 4:
 		/* kludge to get 4 physical pages for ARGB cursor */
@@ -428,9 +429,11 @@ static void intel_i810_free_by_type(struct agp_memory *curr)
 			i8xx_destroy_pages(curr->pages[0]);
 		else {
 			agp_bridge->driver->agp_destroy_page(curr->pages[0],
-							     AGP_PAGE_DESTROY_UNMAP);
+							     AGP_PAGE_DESTROY_UNMAP,
+							     &curr->dma_addr[0]);
 			agp_bridge->driver->agp_destroy_page(curr->pages[0],
-							     AGP_PAGE_DESTROY_FREE);
+							     AGP_PAGE_DESTROY_FREE,
+							     &curr->dma_addr[0]);
 		}
 		agp_free_page_array(curr);
 	}
diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index ffa888c..4436438 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -39,7 +39,8 @@ static struct aper_size_info_fixed sgi_tioca_sizes[] = {
 	{0, 0, 0},
 };
 
-static struct page *sgi_tioca_alloc_page(struct agp_bridge_data *bridge)
+static struct page *sgi_tioca_alloc_page(struct agp_bridge_data *bridge,
+					 dma_addr_t *dma_addr)
 {
 	struct page *page;
 	int nid;
-- 
1.7.1

