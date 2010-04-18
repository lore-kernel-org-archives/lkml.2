Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0DRV63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 17:58:29 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:39778 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab0DRV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 17:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C7SNn6E+AF7iXPjPffwwvQm57lYXmToT32LzMdkMl0rv0Rl4BVbOJ4gvTG27rs8MMB
         BTPo8st8uTO9RNQSkBC3p7rETOGvVBp+cY49B63Kt+fb3hQiy0Te5Fz1H9DE5sBsbo+z
         ATQeWqNuB+qE4hDcg74+0fO0Fmq5o6N+nYzEU=
Date: Sun, 18 Apr 2010 23:57:51 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-fbdev@vger.kernel.org, nouveau@lists.freedesktop.org,
       LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       Peter Jones <pjones@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] vga16fb, drm: vga16fb->drm handoff
Message-ID: <20100418215751.GA2733@joi.lan>
References: <1270929334-3742-1-git-send-email-marcin.slusarz@gmail.com>
 <1271030068.3554.1.camel@localhost>
 <20100412113438.GB2789@joi.lan>
 <1271104101.5726.3.camel@t60prh>
 <20100412213327.GA4463@joi.lan>
 <20100413195004.GA4402@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413195004.GA4402@joi.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 09:50:04PM +0200, Marcin Slusarz wrote:
> On Mon, Apr 12, 2010 at 11:33:27PM +0200, Marcin Slusarz wrote:
> > > > > Have you got a pointer to a machine where it fails?
> > > > 
> > > > No, it failed with an artifical test while I was working on vga16fb handoff
> > > > (unfinished).
> > > 
> > > You won't be able to make this work for vga16fb from what I can see
> > > since it access 0xa000 directly, not via any of the defined apertures
> > > that vesafb/offb use. vga16fb will need a different approach I suspect.
> > 
> > Yeah, there's an idea to claim 0xa0000 as an aperture of vga16fb and then
> > do the same in KMS driver but only if it's the primary card. 
> > (You hinted to use SHADOW resource bit to check whether card is primary)
> > I think I'll try this approach soon.
> 
> Patch below works for me, but I couldn't test the case when nvidia card is secondary.
> 
> ---
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Date: Tue, 13 Apr 2010 09:20:53 +0200
> Subject: [PATCH] vga16fb, drm/nouveau: vga16fb->nouveau handoff
> 
> let vga16fb claim 0xA0000+0x10000 region as its aperture;
> nouveau does not use it, so we need to lie to kick vga16fb,
> but only if it's driving the primary card (by checking
> IORESOURCE_ROM_SHADOW resource flag)
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_state.c |   11 ++++++++++-
>  drivers/video/vga16fb.c                 |   26 +++++++++++++++++++-------
>  2 files changed, 29 insertions(+), 8 deletions(-)
> 

More generic approach below - it should work for all drm drivers.
Unfortunately vga16fb handoff has 2 other issues:
- It can be compiled as module, so it can be loaded after KMS driver (and
  nothing prevents it right now)
- vga16fb registration error path is iounmapping memory which was not
  ioremapped.
I'm going to fix it soon.

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] vga16fb, drm: vga16fb->drm handoff

let vga16fb claim 0xA0000+0x10000 region as its aperture;
drm drivers don't use it, so we have to detect it and kick
vga16fb manually - but only if drm is driving the primary card
(by checking IORESOURCE_ROM_SHADOW resource flag)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/gpu/drm/i915/intel_fb.c         |    1 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |    1 +
 drivers/gpu/drm/nouveau/nouveau_state.c |    3 ++-
 drivers/gpu/drm/radeon/radeon_fb.c      |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c      |    1 +
 drivers/video/fbmem.c                   |   19 ++++++++++++++++---
 drivers/video/vga16fb.c                 |   26 +++++++++++++++++++-------
 include/linux/fb.h                      |    4 +++-
 8 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 6dbc277..8e403be 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -201,6 +201,7 @@ static int intelfb_create(struct drm_device *dev, uint32_t fb_width,
 		info->apertures->ranges[0].size = pci_resource_len(dev->pdev, 2);
 	else
 		info->apertures->ranges[0].size = pci_resource_len(dev->pdev, 0);
+	info->pcidev = dev->pdev;
 
 	info->fix.smem_start = dev->mode_config.fb_base + obj_priv->gtt_offset;
 	info->fix.smem_len = size;
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 660746b..2e0d840 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -285,6 +285,7 @@ nouveau_fbcon_create(struct drm_device *dev, uint32_t fb_width,
 		ret = -ENOMEM;
 		goto out_unref;
 	}
+	info->pcidev = pdev;
 
 	info->pixmap.size = 64*1024;
 	info->pixmap.buf_align = 8;
diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index 3efc339..4916cf2 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -670,7 +670,8 @@ static int nouveau_remove_conflicting_drivers(struct drm_device *dev)
 	if (!dev_priv->apertures)
 		return -ENOMEM;
 	
-	remove_conflicting_framebuffers(dev_priv->apertures, "nouveaufb");
+	remove_conflicting_framebuffers(dev_priv->apertures, "nouveaufb",
+					dev->pdev);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index df06cdf..17de92a 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -271,6 +271,7 @@ int radeonfb_create(struct drm_device *dev,
 	}
 	info->apertures->ranges[0].base = rdev->ddev->mode_config.fb_base;
 	info->apertures->ranges[0].size = rdev->mc.real_vram_size;
+	info->pcidev = dev->pdev;
 
 	info->fix.mmio_start = 0;
 	info->fix.mmio_len = 0;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
index 0248c6b..eda1336 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
@@ -566,6 +566,7 @@ int vmw_fb_init(struct vmw_private *vmw_priv)
 	}
 	info->apertures->ranges[0].base = vmw_priv->vram_start;
 	info->apertures->ranges[0].size = vmw_priv->vram_size;
+	info->pcidev = vmw_priv->dev->pdev;
 
 	/*
 	 * Dirty & Deferred IO
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 7cfcd71..4628a59 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -32,6 +32,7 @@
 #include <linux/device.h>
 #include <linux/efi.h>
 #include <linux/fb.h>
+#include <linux/pci.h>
 
 #include <asm/fb.h>
 
@@ -1500,19 +1501,30 @@ static bool fb_do_apertures_overlap(struct apertures_struct *gena,
 	return false;
 }
 
-void remove_conflicting_framebuffers(struct apertures_struct *a, const char *name)
+#define VGA_FB_PHYS 0xA0000
+void remove_conflicting_framebuffers(struct apertures_struct *a,
+				     const char *name, struct pci_dev *pcidev)
 {
 	int i;
+	bool primary = false;
+
+	if (pcidev)
+		primary = pcidev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
 
 	/* check all firmware fbs and kick off if the base addr overlaps */
 	for (i = 0 ; i < FB_MAX; i++) {
+		struct apertures_struct *gen_aper;
 		if (!registered_fb[i])
 			continue;
 
 		if (!(registered_fb[i]->flags & FBINFO_MISC_FIRMWARE))
 			continue;
+		
+		gen_aper = registered_fb[i]->apertures;
+		if (fb_do_apertures_overlap(gen_aper, a) ||
+			(primary && gen_aper && gen_aper->count &&
+			 gen_aper->ranges[0].base == VGA_FB_PHYS)) {
 
-		if (fb_do_apertures_overlap(registered_fb[i]->apertures, a)) {
 			printk(KERN_ERR "fb: conflicting fb hw usage "
 			       "%s vs %s - removing generic driver\n",
 			       name, registered_fb[i]->fix.id);
@@ -1545,7 +1557,8 @@ register_framebuffer(struct fb_info *fb_info)
 	if (fb_check_foreignness(fb_info))
 		return -ENOSYS;
 
-	remove_conflicting_framebuffers(fb_info->apertures, fb_info->fix.id);
+	remove_conflicting_framebuffers(fb_info->apertures, fb_info->fix.id,
+					fb_info->pcidev);
 
 	num_registered_fb++;
 	for (i = 0 ; i < FB_MAX; i++)
diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index bf638a4..149c47a 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -1263,10 +1263,19 @@ static void vga16fb_imageblit(struct fb_info *info, const struct fb_image *image
 		vga_imageblit_color(info, image);
 }
 
+static void vga16fb_destroy(struct fb_info *info)
+{
+	iounmap(info->screen_base);
+	fb_dealloc_cmap(&info->cmap);
+	/* XXX unshare VGA regions */
+	framebuffer_release(info);
+}
+
 static struct fb_ops vga16fb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_open        = vga16fb_open,
 	.fb_release     = vga16fb_release,
+	.fb_destroy	= vga16fb_destroy,
 	.fb_check_var	= vga16fb_check_var,
 	.fb_set_par	= vga16fb_set_par,
 	.fb_setcolreg 	= vga16fb_setcolreg,
@@ -1306,6 +1315,11 @@ static int __devinit vga16fb_probe(struct platform_device *dev)
 		ret = -ENOMEM;
 		goto err_fb_alloc;
 	}
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures) {
+		ret = -ENOMEM;
+		goto err_ioremap;
+	}
 
 	/* XXX share VGA_FB_PHYS and I/O region with vgacon and others */
 	info->screen_base = (void __iomem *)VGA_MAP_MEM(VGA_FB_PHYS, 0);
@@ -1335,7 +1349,7 @@ static int __devinit vga16fb_probe(struct platform_device *dev)
 	info->fix = vga16fb_fix;
 	/* supports rectangles with widths of multiples of 8 */
 	info->pixmap.blit_x = 1 << 7 | 1 << 15 | 1 << 23 | 1 << 31;
-	info->flags = FBINFO_FLAG_DEFAULT |
+	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE |
 		FBINFO_HWACCEL_YPAN;
 
 	i = (info->var.bits_per_pixel == 8) ? 256 : 16;
@@ -1354,6 +1368,9 @@ static int __devinit vga16fb_probe(struct platform_device *dev)
 
 	vga16fb_update_fix(info);
 
+	info->apertures->ranges[0].base = VGA_FB_PHYS;
+	info->apertures->ranges[0].size = VGA_FB_PHYS_LEN;
+
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR "vga16fb: unable to register framebuffer\n");
 		ret = -EINVAL;
@@ -1380,13 +1397,8 @@ static int vga16fb_remove(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 
-	if (info) {
+	if (info)
 		unregister_framebuffer(info);
-		iounmap(info->screen_base);
-		fb_dealloc_cmap(&info->cmap);
-	/* XXX unshare VGA regions */
-		framebuffer_release(info);
-	}
 
 	return 0;
 }
diff --git a/include/linux/fb.h b/include/linux/fb.h
index f88e254..4b48e2f 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -870,6 +870,7 @@ struct fb_info {
 			resource_size_t size;
 		} ranges[0];
 	} *apertures;
+	struct pci_dev *pcidev;
 };
 
 static inline struct apertures_struct *alloc_apertures(unsigned int max_num) {
@@ -971,7 +972,8 @@ extern ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
 /* drivers/video/fbmem.c */
 extern int register_framebuffer(struct fb_info *fb_info);
 extern int unregister_framebuffer(struct fb_info *fb_info);
-extern void remove_conflicting_framebuffers(struct apertures_struct *a, const char *name);
+extern void remove_conflicting_framebuffers(struct apertures_struct *a,
+				const char *name, struct pci_dev *pcidev);
 extern int fb_prepare_logo(struct fb_info *fb_info, int rotate);
 extern int fb_show_logo(struct fb_info *fb_info, int rotate);
 extern char* fb_get_buffer_offset(struct fb_info *info, struct fb_pixmap *buf, u32 size);
-- 
1.7.0.4


