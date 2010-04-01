Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0DAOyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 10:54:54 -0400
Received: from nox.protox.org ([88.191.38.29]:43040 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab0DAOyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 10:54:47 -0400
Date: Thu, 1 Apr 2010 16:54:42 +0200
From: Jerome Glisse <glisse@freedesktop.org>
To: airlied@gmail.com
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: AGP force use of scratch page
Message-ID: <20100401145442.GE2715@barney.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Attached is a patch which force the use of the scratch page
for all AGP bridges, only tested on SIS or Intel bridges,
i am bit skeptical for alpha bridges. If you prefer i can
just force this for x86 & PPC bridge for which we can easily
get tester.

Cheers,
Jerome

--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-agp-force-use-of-scratch-page.patch"

>From 5b2469a7149280fb6866345cb6d3d395ee400cd8 Mon Sep 17 00:00:00 2001
From: Jerome Glisse <jglisse@redhat.com>
Date: Thu, 1 Apr 2010 16:46:15 +0200
Subject: [PATCH] agp: force use of scratch page

It seems that some AGP hardware can induce activity on bus
after reporting being idle with the memory (preteching maybe).
As new infrastructure for GPU is dynamicly binding/unbinding
memory this result in hardware possibly trying to access invalid
memory to avoid this situation the patch for the use of the
scratch page mecanism for all the AGP driver. It remove the
needs_scratch_page flags and fix the insert_memory/remove_memory
to deal properly with scratch_page.

Been tested on intel & sis agp bridges.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/char/agp/agp.h          |    1 -
 drivers/char/agp/backend.c      |   57 +++++++++++++++++---------------------
 drivers/char/agp/hp-agp.c       |    2 +-
 drivers/char/agp/i460-agp.c     |    2 +-
 drivers/char/agp/intel-agp.c    |   30 +++++++-------------
 drivers/char/agp/parisc-agp.c   |    2 +-
 drivers/char/agp/sgi-agp.c      |    5 +--
 drivers/char/agp/uninorth-agp.c |    3 +-
 8 files changed, 42 insertions(+), 60 deletions(-)

diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 870f12c..db68c7b 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -100,7 +100,6 @@ struct agp_bridge_driver {
 	int num_aperture_sizes;
 	enum aper_size_type size_type;
 	bool cant_use_aperture;
-	bool needs_scratch_page;
 	const struct gatt_mask *masks;
 	int (*fetch_size)(void);
 	int (*configure)(void);
diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index c3ab46d..fed5e46 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -136,35 +136,32 @@ static int agp_find_max(void)
 static int agp_backend_initialize(struct agp_bridge_data *bridge)
 {
 	int size_value, rc, got_gatt=0, got_keylist=0;
+	struct page *page;
+	void *va;
 
 	bridge->max_memory_agp = agp_find_max();
 	bridge->version = &agp_current_version;
 
-	if (bridge->driver->needs_scratch_page) {
-		struct page *page = bridge->driver->agp_alloc_page(bridge);
-
-		if (!page) {
-			dev_err(&bridge->dev->dev,
+	page = bridge->driver->agp_alloc_page(bridge);
+	if (!page) {
+		dev_err(&bridge->dev->dev,
 				"can't get memory for scratch page\n");
-			return -ENOMEM;
-		}
-
-		bridge->scratch_page_page = page;
-		if (bridge->driver->agp_map_page) {
-			if (bridge->driver->agp_map_page(page,
-							 &bridge->scratch_page_dma)) {
-				dev_err(&bridge->dev->dev,
+		return -ENOMEM;
+	}
+	bridge->scratch_page_page = page;
+	if (bridge->driver->agp_map_page) {
+		if (bridge->driver->agp_map_page(page,
+					&bridge->scratch_page_dma)) {
+			dev_err(&bridge->dev->dev,
 					"unable to dma-map scratch page\n");
-				rc = -ENOMEM;
-				goto err_out_nounmap;
-			}
-		} else {
-			bridge->scratch_page_dma = page_to_phys(page);
+			rc = -ENOMEM;
+			goto err_out_nounmap;
 		}
-
-		bridge->scratch_page = bridge->driver->mask_memory(bridge,
-						   bridge->scratch_page_dma, 0);
+	} else {
+		bridge->scratch_page_dma = page_to_phys(page);
 	}
+	bridge->scratch_page = bridge->driver->mask_memory(bridge,
+			bridge->scratch_page_dma, 0);
 
 	size_value = bridge->driver->fetch_size();
 	if (size_value == 0) {
@@ -203,18 +200,15 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 	return 0;
 
 err_out:
-	if (bridge->driver->needs_scratch_page &&
-	    bridge->driver->agp_unmap_page) {
+	if (bridge->driver->agp_unmap_page) {
 		bridge->driver->agp_unmap_page(bridge->scratch_page_page,
 					       bridge->scratch_page_dma);
 	}
 err_out_nounmap:
-	if (bridge->driver->needs_scratch_page) {
-		void *va = page_address(bridge->scratch_page_page);
+	va = page_address(bridge->scratch_page_page);
+	bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
+	bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
 
-		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
-		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
-	}
 	if (got_gatt)
 		bridge->driver->free_gatt_table(bridge);
 	if (got_keylist) {
@@ -227,6 +221,8 @@ err_out_nounmap:
 /* cannot be __exit b/c as it could be called from __init code */
 static void agp_backend_cleanup(struct agp_bridge_data *bridge)
 {
+	void *va;
+
 	if (bridge->driver->cleanup)
 		bridge->driver->cleanup();
 	if (bridge->driver->free_gatt_table)
@@ -235,9 +231,8 @@ static void agp_backend_cleanup(struct agp_bridge_data *bridge)
 	vfree(bridge->key_list);
 	bridge->key_list = NULL;
 
-	if (bridge->driver->agp_destroy_page &&
-	    bridge->driver->needs_scratch_page) {
-		void *va = page_address(bridge->scratch_page_page);
+	if (bridge->driver->agp_destroy_page) {
+		va = page_address(bridge->scratch_page_page);
 
 		if (bridge->driver->agp_unmap_page)
 			bridge->driver->agp_unmap_page(bridge->scratch_page_page,
diff --git a/drivers/char/agp/hp-agp.c b/drivers/char/agp/hp-agp.c
index 58752b7..01dd174 100644
--- a/drivers/char/agp/hp-agp.c
+++ b/drivers/char/agp/hp-agp.c
@@ -347,7 +347,7 @@ hp_zx1_insert_memory (struct agp_memory *mem, off_t pg_start, int type)
 
 	j = io_pg_start;
 	while (j < (io_pg_start + io_pg_count)) {
-		if (hp->gatt[j]) {
+		if (!PGE_EMPTY(agp_bridge, hp->gatt[j])) {
 			return -EBUSY;
 		}
 		j++;
diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
index e763d33..e8aa763 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -344,7 +344,7 @@ static int i460_remove_memory_small_io_page(struct agp_memory *mem,
 	pg_start = I460_IOPAGES_PER_KPAGE * pg_start;
 
 	for (i = pg_start; i < (pg_start + I460_IOPAGES_PER_KPAGE * mem->page_count); i++)
-		WR_GATT(i, 0);
+		WR_GATT(i, agp_bridge->scatch_page);
 	WR_FLUSH_GATT(i - 1);
 	return 0;
 }
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index c1c07a2..6192579 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -399,12 +399,11 @@ static int intel_i810_configure(void)
 	writel(agp_bridge->gatt_bus_addr | I810_PGETBL_ENABLED, intel_private.registers+I810_PGETBL_CTL);
 	readl(intel_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
 
-	if (agp_bridge->driver->needs_scratch_page) {
-		for (i = 0; i < current_size->num_entries; i++) {
-			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
-		}
-		readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));	/* PCI posting. */
+	for (i = 0; i < current_size->num_entries; i++) {
+		writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
 	}
+	readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));	/* PCI posting. */
+
 	global_cache_flush();
 	return 0;
 }
@@ -1029,12 +1028,10 @@ static int intel_i830_configure(void)
 	writel(agp_bridge->gatt_bus_addr|I810_PGETBL_ENABLED, intel_private.registers+I810_PGETBL_CTL);
 	readl(intel_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
 
-	if (agp_bridge->driver->needs_scratch_page) {
-		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
-			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
-		}
-		readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));	/* PCI Posting. */
+	for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
+		writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
 	}
+	readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));	/* PCI Posting. */
 
 	global_cache_flush();
 
@@ -1245,12 +1242,10 @@ static int intel_i915_configure(void)
 	writel(agp_bridge->gatt_bus_addr|I810_PGETBL_ENABLED, intel_private.registers+I810_PGETBL_CTL);
 	readl(intel_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
 
-	if (agp_bridge->driver->needs_scratch_page) {
-		for (i = intel_private.gtt_entries; i < intel_private.gtt_total_size; i++) {
-			writel(agp_bridge->scratch_page, intel_private.gtt+i);
-		}
-		readl(intel_private.gtt+i-1);	/* PCI Posting. */
+	for (i = intel_private.gtt_entries; i < intel_private.gtt_total_size; i++) {
+		writel(agp_bridge->scratch_page, intel_private.gtt+i);
 	}
+	readl(intel_private.gtt+i-1);	/* PCI Posting. */
 
 	global_cache_flush();
 
@@ -1988,7 +1983,6 @@ static const struct agp_bridge_driver intel_810_driver = {
 	.aperture_sizes		= intel_i810_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 2,
-	.needs_scratch_page	= true,
 	.configure		= intel_i810_configure,
 	.fetch_size		= intel_i810_fetch_size,
 	.cleanup		= intel_i810_cleanup,
@@ -2041,7 +2035,6 @@ static const struct agp_bridge_driver intel_830_driver = {
 	.aperture_sizes		= intel_i830_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 4,
-	.needs_scratch_page	= true,
 	.configure		= intel_i830_configure,
 	.fetch_size		= intel_i830_fetch_size,
 	.cleanup		= intel_i830_cleanup,
@@ -2226,7 +2219,6 @@ static const struct agp_bridge_driver intel_915_driver = {
 	.aperture_sizes		= intel_i830_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 4,
-	.needs_scratch_page	= true,
 	.configure		= intel_i915_configure,
 	.fetch_size		= intel_i9xx_fetch_size,
 	.cleanup		= intel_i915_cleanup,
@@ -2260,7 +2252,6 @@ static const struct agp_bridge_driver intel_i965_driver = {
 	.aperture_sizes		= intel_i830_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 4,
-	.needs_scratch_page	= true,
 	.configure		= intel_i915_configure,
 	.fetch_size		= intel_i9xx_fetch_size,
 	.cleanup		= intel_i915_cleanup,
@@ -2320,7 +2311,6 @@ static const struct agp_bridge_driver intel_g33_driver = {
 	.aperture_sizes		= intel_i830_sizes,
 	.size_type		= FIXED_APER_SIZE,
 	.num_aperture_sizes	= 4,
-	.needs_scratch_page	= true,
 	.configure		= intel_i915_configure,
 	.fetch_size		= intel_i9xx_fetch_size,
 	.cleanup		= intel_i915_cleanup,
diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 1c12921..789265c 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -140,7 +140,7 @@ parisc_agp_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
 
 	j = io_pg_start;
 	while (j < (io_pg_start + io_pg_count)) {
-		if (info->gatt[j])
+		if (!PGE_EMPTY(agp_bridge, info->gatt[j]))
 			return -EBUSY;
 		j++;
 	}
diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index 0d426ae..8a5727a 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -177,7 +177,7 @@ static int sgi_tioca_insert_memory(struct agp_memory *mem, off_t pg_start,
 	j = pg_start;
 
 	while (j < (pg_start + mem->page_count)) {
-		if (table[j])
+		if (!PGE_EMPTY(agp_bridge, table[j]))
 			return -EBUSY;
 		j++;
 	}
@@ -216,7 +216,7 @@ static int sgi_tioca_remove_memory(struct agp_memory *mem, off_t pg_start,
 	table = (u64 *)bridge->gatt_table;
 
 	for (i = pg_start; i < (mem->page_count + pg_start); i++) {
-		table[i] = 0;
+		table[i] = agp_bridge->scratch_page;
 	}
 
 	bridge->driver->tlb_flush(mem);
@@ -266,7 +266,6 @@ const struct agp_bridge_driver sgi_tioca_driver = {
 	.agp_destroy_page = agp_generic_destroy_page,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture = true,
-	.needs_scratch_page = false,
 	.num_aperture_sizes = 1,
 };
 
diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
index d89da4a..d54d674 100644
--- a/drivers/char/agp/uninorth-agp.c
+++ b/drivers/char/agp/uninorth-agp.c
@@ -171,7 +171,7 @@ static int uninorth_insert_memory(struct agp_memory *mem, off_t pg_start, int ty
 
 	gp = (u32 *) &agp_bridge->gatt_table[pg_start];
 	for (i = 0; i < mem->page_count; ++i) {
-		if (gp[i]) {
+		if (!PGE_EMPTY(agp_bridge, gp[i])) {
 			dev_info(&agp_bridge->dev->dev,
 				 "uninorth_insert_memory: entry 0x%x occupied (%x)\n",
 				 i, gp[i]);
@@ -545,7 +545,6 @@ const struct agp_bridge_driver u3_agp_driver = {
 	.agp_destroy_pages	= agp_generic_destroy_pages,
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 	.cant_use_aperture	= true,
-	.needs_scratch_page	= true,
 };
 
 static struct agp_device_ids uninorth_agp_device_ids[] __devinitdata = {
-- 
1.6.6.1


--R3G7APHDIzY6R/pk--
