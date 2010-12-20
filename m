Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab0LTSM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:12:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52078 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0LTSM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:12:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: [BISECTED] agp/intel: revert "Remove confusion of stolen entries not stolen memory"
Date: Mon, 20 Dec 2010 19:12:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-next-20101220+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012201912.19051.arnd@arndb.de>
X-Provags-ID: V02:K0:gehEh/Hejy6iwTmpKlMDrEY83/ARIYCSda/qXZbAGZl
 w34qUKjL4uUqv27JAKMWjEhXZGOHDMIR8jRWnZEcEyOhuSaDG9
 Cswy92p5AoaFRINvI3mxXJxT6zfm0Gie98sNZ5F54CEMGn1UmT
 O+Ag/Er8xQeJ8BOqvY16y/H4pAC2pLKyuobuPqLkNmC6JFT5fP
 Kw+tJPJ2aleZupTaOE3YQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c64f7ba5f10 "agp/intel: Remove confusion of stolen entries not stolen memory" caused a regression on my Intel G45 based system, using the VESA
Xorg driver or uvesafb. I have not tried if i915 with KMS shows the same
behaviour, but can try if necessary.

Reverting the patch on Friday's linux-next restores the normal behaviour
and lets me use X again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 356f73e..7812a3a 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -342,12 +342,13 @@ static const struct aper_size_info_fixed intel_fake_agp_sizes[] = {
 	{512, 131072, 7},
 };
 
-static unsigned int intel_gtt_stolen_size(void)
+static unsigned int intel_gtt_stolen_entries(void)
 {
 	u16 gmch_ctrl;
 	u8 rdct;
 	int local = 0;
 	static const int ddt[4] = { 0, 16, 32, 64 };
+	unsigned int overhead_entries;
 	unsigned int stolen_size = 0;
 
 	if (INTEL_GTT_GEN == 1)
@@ -356,6 +357,14 @@ static unsigned int intel_gtt_stolen_size(void)
 	pci_read_config_word(intel_private.bridge_dev,
 			     I830_GMCH_CTRL, &gmch_ctrl);
 
+	if (INTEL_GTT_GEN > 4 || IS_PINEVIEW)
+		overhead_entries = 0;
+	else
+		overhead_entries = intel_private.base.gtt_mappable_entries
+			/ 1024;
+
+	overhead_entries += 1; /* BIOS popup */
+
 	if (intel_private.bridge_dev->device == PCI_DEVICE_ID_INTEL_82830_HB ||
 	    intel_private.bridge_dev->device == PCI_DEVICE_ID_INTEL_82845G_HB) {
 		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
@@ -490,7 +499,7 @@ static unsigned int intel_gtt_stolen_size(void)
 		stolen_size = 0;
 	}
 
-	return stolen_size;
+	return stolen_size/KB(4) - overhead_entries;
 }
 
 static void i965_adjust_pgetbl_size(unsigned int size_flag)
@@ -686,7 +695,7 @@ static int intel_gtt_init(void)
 
 	global_cache_flush();   /* FIXME: ? */
 
-	intel_private.base.stolen_size = intel_gtt_stolen_size();
+	intel_private.base.gtt_stolen_entries = intel_gtt_stolen_entries();
 
 	ret = intel_gtt_setup_scratch_page();
 	if (ret != 0) {
@@ -867,7 +876,8 @@ static int intel_fake_agp_configure(void)
 
 	agp_bridge->gart_bus_addr = intel_private.gma_bus_addr;
 
-	for (i = 0; i < intel_private.base.gtt_total_entries; i++) {
+	for (i = intel_private.base.gtt_stolen_entries;
+			i < intel_private.base.gtt_total_entries; i++) {
 		intel_private.driver->write_entry(intel_private.scratch_page_dma,
 						  i, 0);
 	}
@@ -942,7 +952,17 @@ static int intel_fake_agp_insert_entries(struct agp_memory *mem,
 	if (mem->page_count == 0)
 		goto out;
 
-	if (pg_start + mem->page_count > intel_private.base.gtt_total_entries)
+	if (pg_start < intel_private.base.gtt_stolen_entries) {
+		dev_printk(KERN_DEBUG, &intel_private.pcidev->dev,
+			   "pg_start == 0x%.8lx, gtt_stolen_entries == 0x%.8x\n",
+			   pg_start, intel_private.base.gtt_stolen_entries);
+
+		dev_info(&intel_private.pcidev->dev,
+			 "trying to insert into local/stolen memory\n");
+		goto out_err;
+	}
+
+	if ((pg_start + mem->page_count) > intel_private.base.gtt_total_entries)
 		goto out_err;
 
 	if (type != mem->type)
@@ -991,6 +1011,12 @@ static int intel_fake_agp_remove_entries(struct agp_memory *mem,
 	if (mem->page_count == 0)
 		return 0;
 
+	if (pg_start < intel_private.base.gtt_stolen_entries) {
+		dev_info(&intel_private.pcidev->dev,
+			 "trying to disable local/stolen memory\n");
+		return -EINVAL;
+	}
+
 	if (intel_private.base.needs_dmar) {
 		intel_gtt_unmap_memory(mem->sg_list, mem->num_sg);
 		mem->sg_list = NULL;
@@ -1489,7 +1515,7 @@ int intel_gmch_probe(struct pci_dev *pdev,
 }
 EXPORT_SYMBOL(intel_gmch_probe);
 
-const struct intel_gtt *intel_gtt_get(void)
+struct intel_gtt *intel_gtt_get(void)
 {
 	return &intel_private.base;
 }
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 3f7b203..1655c39 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1049,7 +1049,7 @@ static unsigned long i915_stolen_to_phys(struct drm_device *dev, u32 offset)
 		pci_read_config_byte(pdev, 0x9c, &val);
 		base = val >> 3 << 27;
 	}
-	base -= dev_priv->mm.gtt->stolen_size;
+	base -= dev_priv->mm.gtt->gtt_stolen_entries << PAGE_SHIFT;
 #endif
 
 	return base + offset;
@@ -1173,7 +1173,7 @@ static int i915_load_modeset_init(struct drm_device *dev)
 	unsigned long prealloc_size, gtt_size, mappable_size;
 	int ret = 0;
 
-	prealloc_size = dev_priv->mm.gtt->stolen_size;
+	prealloc_size = dev_priv->mm.gtt->gtt_stolen_entries << PAGE_SHIFT;
 	gtt_size = dev_priv->mm.gtt->gtt_total_entries << PAGE_SHIFT;
 	mappable_size = dev_priv->mm.gtt->gtt_mappable_entries << PAGE_SHIFT;
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 30780f2..b41edf6 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -532,7 +532,7 @@ typedef struct drm_i915_private {
 
 	struct {
 		/** Bridge to intel-gtt-ko */
-		const struct intel_gtt *gtt;
+		struct intel_gtt *gtt;
 		/** Memory allocator for GTT stolen memory */
 		struct drm_mm stolen;
 		/** Memory allocator for GTT */
diff --git a/include/drm/intel-gtt.h b/include/drm/intel-gtt.h
index 9e343c0..75c2088 100644
--- a/include/drm/intel-gtt.h
+++ b/include/drm/intel-gtt.h
@@ -2,10 +2,9 @@
 
 #ifndef _DRM_INTEL_GTT_H
 #define	_DRM_INTEL_GTT_H
-
-const struct intel_gtt {
-	/* Size of memory reserved for graphics by the BIOS */
-	unsigned int stolen_size;
+struct intel_gtt {
+	/* Number of stolen gtt entries at the beginning. */
+	unsigned int gtt_stolen_entries;
 	/* Total number of gtt entries. */
 	unsigned int gtt_total_entries;
 	/* Part of the gtt that is mappable by the cpu, for those chips where
