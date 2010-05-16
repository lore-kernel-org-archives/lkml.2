Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab0EPP2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 11:28:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47769 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab0EPP2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 11:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xBjpJ6NH9U0yXbL4wmBQ5cXhOJCNVufeKRX9U84nyVN7IfZDvpUhuZyrQH0qsRNgX4
         rHJ9EsKY9C3L6xGOVm0Hz3MtYKwzCZ6DcIoiTLRgT7mKOg/M59uO4Q2u4BqJg3QjCHrQ
         OWmULZbuME45b8le8HJB00QCwlVtVYPNi0yRI=
Date: Sun, 16 May 2010 17:27:03 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Anholt <eric@anholt.net>, Ben Skeggs <bskeggs@redhat.com>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Dave Airlie <airlied@redhat.com>, Peter Jones <pjones@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       nouveau@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/3] fbdev: allow passing more than one aperture for
 handoff
Message-ID: <20100516152703.GA2793@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It removes a hack from nouveau code which had to detect which
region to pass to kick vesafb/efifb.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Eric Anholt <eric@anholt.net>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
v2 - rebase after drop of patch 1/3
v3 - compile fix after mainline include changes
---
 drivers/gpu/drm/i915/intel_fb.c         |   11 +++-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |   84 +++++++++---------------------
 drivers/gpu/drm/radeon/radeon_fb.c      |    9 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c      |   10 +++-
 drivers/video/efifb.c                   |   11 +++-
 drivers/video/fbmem.c                   |   29 ++++++++++-
 drivers/video/fbsysfs.c                 |    1 +
 drivers/video/offb.c                    |   28 ++++++----
 drivers/video/vesafb.c                  |   11 +++-
 include/linux/fb.h                      |   17 ++++++-
 10 files changed, 123 insertions(+), 88 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 8a0b3bc..6127c28 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -191,11 +191,16 @@ static int intelfb_create(struct drm_device *dev, uint32_t fb_width,
 
 
 	/* setup aperture base/size for vesafb takeover */
-	info->aperture_base = dev->mode_config.fb_base;
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures) {
+		ret = -ENOMEM;
+		goto out_unpin;
+	}
+	info->apertures->ranges[0].base = dev->mode_config.fb_base;
 	if (IS_I9XX(dev))
-		info->aperture_size = pci_resource_len(dev->pdev, 2);
+		info->apertures->ranges[0].size = pci_resource_len(dev->pdev, 2);
 	else
-		info->aperture_size = pci_resource_len(dev->pdev, 0);
+		info->apertures->ranges[0].size = pci_resource_len(dev->pdev, 0);
 
 	info->fix.smem_start = dev->mode_config.fb_base + obj_priv->gtt_offset;
 	info->fix.smem_len = size;
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 8e7dc1d..6b2d5ab 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -160,44 +160,6 @@ static struct drm_fb_helper_funcs nouveau_fbcon_helper_funcs = {
 	.gamma_get = nouveau_fbcon_gamma_get
 };
 
-#if defined(__i386__) || defined(__x86_64__)
-static bool
-nouveau_fbcon_has_vesafb_or_efifb(struct drm_device *dev)
-{
-	struct pci_dev *pdev = dev->pdev;
-	int ramin;
-
-	if (screen_info.orig_video_isVGA != VIDEO_TYPE_VLFB &&
-	    screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
-		return false;
-
-	if (screen_info.lfb_base < pci_resource_start(pdev, 1))
-		goto not_fb;
-
-	if (screen_info.lfb_base + screen_info.lfb_size >=
-	    pci_resource_start(pdev, 1) + pci_resource_len(pdev, 1))
-		goto not_fb;
-
-	return true;
-not_fb:
-	ramin = 2;
-	if (pci_resource_len(pdev, ramin) == 0) {
-		ramin = 3;
-		if (pci_resource_len(pdev, ramin) == 0)
-			return false;
-	}
-
-	if (screen_info.lfb_base < pci_resource_start(pdev, ramin))
-		return false;
-
-	if (screen_info.lfb_base + screen_info.lfb_size >=
-	    pci_resource_start(pdev, ramin) + pci_resource_len(pdev, ramin))
-		return false;
-
-	return true;
-}
-#endif
-
 void
 nouveau_fbcon_zfill(struct drm_device *dev)
 {
@@ -230,7 +192,9 @@ nouveau_fbcon_create(struct drm_device *dev, uint32_t fb_width,
 	struct nouveau_framebuffer *nouveau_fb;
 	struct nouveau_bo *nvbo;
 	struct drm_mode_fb_cmd mode_cmd;
-	struct device *device = &dev->pdev->dev;
+	struct pci_dev *pdev = dev->pdev;
+	struct device *device = &pdev->dev;
+	struct apertures_struct *aper;
 	int size, ret;
 
 	mode_cmd.width = surface_width;
@@ -313,28 +277,30 @@ nouveau_fbcon_create(struct drm_device *dev, uint32_t fb_width,
 	drm_fb_helper_fill_var(info, fb, fb_width, fb_height);
 
 	/* FIXME: we really shouldn't expose mmio space at all */
-	info->fix.mmio_start = pci_resource_start(dev->pdev, 1);
-	info->fix.mmio_len = pci_resource_len(dev->pdev, 1);
+	info->fix.mmio_start = pci_resource_start(pdev, 1);
+	info->fix.mmio_len = pci_resource_len(pdev, 1);
 
 	/* Set aperture base/size for vesafb takeover */
-#if defined(__i386__) || defined(__x86_64__)
-	if (nouveau_fbcon_has_vesafb_or_efifb(dev)) {
-		/* Some NVIDIA VBIOS' are stupid and decide to put the
-		 * framebuffer in the middle of the PRAMIN BAR for
-		 * whatever reason.  We need to know the exact lfb_base
-		 * to get vesafb kicked off, and the only reliable way
-		 * we have left is to find out lfb_base the same way
-		 * vesafb did.
-		 */
-		info->aperture_base = screen_info.lfb_base;
-		info->aperture_size = screen_info.lfb_size;
-		if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB)
-			info->aperture_size *= 65536;
-	} else
-#endif
-	{
-		info->aperture_base = info->fix.mmio_start;
-		info->aperture_size = info->fix.mmio_len;
+	aper = info->apertures = alloc_apertures(3);
+	if (!info->apertures) {
+		ret = -ENOMEM;
+		goto out_unref;
+	}
+
+	aper->ranges[0].base = pci_resource_start(pdev, 1);
+	aper->ranges[0].size = pci_resource_len(pdev, 1);
+	aper->count = 1;
+
+	if (pci_resource_len(pdev, 2)) {
+		aper->ranges[aper->count].base = pci_resource_start(pdev, 2);
+		aper->ranges[aper->count].size = pci_resource_len(pdev, 2);
+		aper->count++;
+	}
+
+	if (pci_resource_len(pdev, 3)) {
+		aper->ranges[aper->count].base = pci_resource_start(pdev, 3);
+		aper->ranges[aper->count].size = pci_resource_len(pdev, 3);
+		aper->count++;
 	}
 
 	info->pixmap.size = 64*1024;
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 9ac57a0..df06cdf 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -264,8 +264,13 @@ int radeonfb_create(struct drm_device *dev,
 	drm_fb_helper_fill_var(info, fb, fb_width, fb_height);
 
 	/* setup aperture base/size for vesafb takeover */
-	info->aperture_base = rdev->ddev->mode_config.fb_base;
-	info->aperture_size = rdev->mc.real_vram_size;
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures) {
+		ret = -ENOMEM;
+		goto out_unref;
+	}
+	info->apertures->ranges[0].base = rdev->ddev->mode_config.fb_base;
+	info->apertures->ranges[0].size = rdev->mc.real_vram_size;
 
 	info->fix.mmio_start = 0;
 	info->fix.mmio_len = 0;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
index a933670..0248c6b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
@@ -559,8 +559,13 @@ int vmw_fb_init(struct vmw_private *vmw_priv)
 	info->pixmap.scan_align = 1;
 #endif
 
-	info->aperture_base = vmw_priv->vram_start;
-	info->aperture_size = vmw_priv->vram_size;
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures) {
+		ret = -ENOMEM;
+		goto err_aper;
+	}
+	info->apertures->ranges[0].base = vmw_priv->vram_start;
+	info->apertures->ranges[0].size = vmw_priv->vram_size;
 
 	/*
 	 * Dirty & Deferred IO
@@ -580,6 +585,7 @@ int vmw_fb_init(struct vmw_private *vmw_priv)
 
 err_defio:
 	fb_deferred_io_cleanup(info);
+err_aper:
 	ttm_bo_kunmap(&par->map);
 err_unref:
 	ttm_bo_unref((struct ttm_buffer_object **)&par->vmw_bo);
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index ecf4055..4a56f46 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -168,7 +168,7 @@ static void efifb_destroy(struct fb_info *info)
 {
 	if (info->screen_base)
 		iounmap(info->screen_base);
-	release_mem_region(info->aperture_base, info->aperture_size);
+	release_mem_region(info->apertures->ranges[0].base, info->apertures->ranges[0].size);
 	framebuffer_release(info);
 }
 
@@ -292,8 +292,13 @@ static int __devinit efifb_probe(struct platform_device *dev)
 	info->pseudo_palette = info->par;
 	info->par = NULL;
 
-	info->aperture_base = efifb_fix.smem_start;
-	info->aperture_size = size_remap;
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures) {
+		err = -ENOMEM;
+		goto err_release_fb;
+	}
+	info->apertures->ranges[0].base = efifb_fix.smem_start;
+	info->apertures->ranges[0].size = size_remap;
 
 	info->screen_base = ioremap(efifb_fix.smem_start, efifb_fix.smem_len);
 	if (!info->screen_base) {
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index a15b44e..03f2dc2 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1468,16 +1468,39 @@ static int fb_check_foreignness(struct fb_info *fi)
 	return 0;
 }
 
-static bool fb_do_apertures_overlap(struct fb_info *gen, struct fb_info *hw)
+static bool apertures_overlap(struct aperture *gen, struct aperture *hw)
 {
 	/* is the generic aperture base the same as the HW one */
-	if (gen->aperture_base == hw->aperture_base)
+	if (gen->base == hw->base)
 		return true;
 	/* is the generic aperture base inside the hw base->hw base+size */
-	if (gen->aperture_base > hw->aperture_base && gen->aperture_base <= hw->aperture_base + hw->aperture_size)
+	if (gen->base > hw->base && gen->base <= hw->base + hw->size)
 		return true;
 	return false;
 }
+
+static bool fb_do_apertures_overlap(struct fb_info *gen, struct fb_info *hw)
+{
+	int i, j;
+	struct apertures_struct *hwa = hw->apertures;
+	struct apertures_struct *gena = gen->apertures;
+	if (!hwa || !gena)
+		return false;
+
+	for (i = 0; i < hwa->count; ++i) {
+		struct aperture *h = &hwa->ranges[i];
+		for (j = 0; j < gena->count; ++j) {
+			struct aperture *g = &gena->ranges[j];
+			printk(KERN_DEBUG "checking generic (%llx %llx) vs hw (%llx %llx)\n",
+				g->base, g->size, h->base, h->size);
+			if (apertures_overlap(g, h))
+				return true;
+		}
+	}
+
+	return false;
+}
+
 /**
  *	register_framebuffer - registers a frame buffer device
  *	@fb_info: frame buffer info structure
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index 81aa312..0a08f13 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -80,6 +80,7 @@ EXPORT_SYMBOL(framebuffer_alloc);
  */
 void framebuffer_release(struct fb_info *info)
 {
+	kfree(info->apertures);
 	kfree(info);
 }
 EXPORT_SYMBOL(framebuffer_release);
diff --git a/drivers/video/offb.c b/drivers/video/offb.c
index 61f8b8f..46dda7d 100644
--- a/drivers/video/offb.c
+++ b/drivers/video/offb.c
@@ -285,7 +285,7 @@ static void offb_destroy(struct fb_info *info)
 {
 	if (info->screen_base)
 		iounmap(info->screen_base);
-	release_mem_region(info->aperture_base, info->aperture_size);
+	release_mem_region(info->apertures->ranges[0].base, info->apertures->ranges[0].size);
 	framebuffer_release(info);
 }
 
@@ -491,8 +491,11 @@ static void __init offb_init_fb(const char *name, const char *full_name,
 	var->vmode = FB_VMODE_NONINTERLACED;
 
 	/* set offb aperture size for generic probing */
-	info->aperture_base = address;
-	info->aperture_size = fix->smem_len;
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures)
+		goto out_aper;
+	info->apertures->ranges[0].base = address;
+	info->apertures->ranges[0].size = fix->smem_len;
 
 	info->fbops = &offb_ops;
 	info->screen_base = ioremap(address, fix->smem_len);
@@ -501,17 +504,20 @@ static void __init offb_init_fb(const char *name, const char *full_name,
 
 	fb_alloc_cmap(&info->cmap, 256, 0);
 
-	if (register_framebuffer(info) < 0) {
-		iounmap(par->cmap_adr);
-		par->cmap_adr = NULL;
-		iounmap(info->screen_base);
-		framebuffer_release(info);
-		release_mem_region(res_start, res_size);
-		return;
-	}
+	if (register_framebuffer(info) < 0)
+		goto out_err;
 
 	printk(KERN_INFO "fb%d: Open Firmware frame buffer device on %s\n",
 	       info->node, full_name);
+	return;
+
+out_err:
+	iounmap(info->screen_base);
+out_aper:
+	iounmap(par->cmap_adr);
+	par->cmap_adr = NULL;
+	framebuffer_release(info);
+	release_mem_region(res_start, res_size);
 }
 
 
diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index 0cadf7a..090aa1a 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -177,7 +177,7 @@ static void vesafb_destroy(struct fb_info *info)
 {
 	if (info->screen_base)
 		iounmap(info->screen_base);
-	release_mem_region(info->aperture_base, info->aperture_size);
+	release_mem_region(info->apertures->ranges[0].base, info->apertures->ranges[0].size);
 	framebuffer_release(info);
 }
 
@@ -295,8 +295,13 @@ static int __init vesafb_probe(struct platform_device *dev)
 	info->par = NULL;
 
 	/* set vesafb aperture size for generic probing */
-	info->aperture_base = screen_info.lfb_base;
-	info->aperture_size = size_total;
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures) {
+		err = -ENOMEM;
+		goto err;
+	}
+	info->apertures->ranges[0].base = screen_info.lfb_base;
+	info->apertures->ranges[0].size = size_total;
 
 	info->screen_base = ioremap(vesafb_fix.smem_start, vesafb_fix.smem_len);
 	if (!info->screen_base) {
diff --git a/include/linux/fb.h b/include/linux/fb.h
index c10163b..de5ff5f 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -403,6 +403,7 @@ struct fb_cursor {
 #include <linux/notifier.h>
 #include <linux/list.h>
 #include <linux/backlight.h>
+#include <linux/slab.h>
 #include <asm/io.h>
 
 struct vm_area_struct;
@@ -862,10 +863,22 @@ struct fb_info {
 	/* we need the PCI or similiar aperture base/size not
 	   smem_start/size as smem_start may just be an object
 	   allocated inside the aperture so may not actually overlap */
-	resource_size_t aperture_base;
-	resource_size_t aperture_size;
+	struct apertures_struct {
+		unsigned int count;
+		struct aperture {
+			resource_size_t base;
+			resource_size_t size;
+		} ranges[0];
+	} *apertures;
 };
 
+static inline struct apertures_struct *alloc_apertures(unsigned int max_num) {
+	struct apertures_struct *a = kzalloc(sizeof(struct apertures_struct)
+			+ max_num * sizeof(struct aperture), GFP_KERNEL);
+	a->count = max_num;
+	return a;
+}
+
 #ifdef MODULE
 #define FBINFO_DEFAULT	FBINFO_MODULE
 #else
-- 
1.7.1

