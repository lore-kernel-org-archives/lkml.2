Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab0EPPeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 11:34:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:65180 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0EPPeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 11:34:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IajVAhpKC1K7y0uRZX6ENVm0WW+7i8RyIWsOLBebY8Xj4NKxNenz7zVaZHK39bmPhV
         cISexMYZ2saWKF8pmjpXUf8VGFtByIvZezeBIIrUqbAf2RRQ8pw/S6lEqj4kC4xRsvRS
         FlEcer9fiAQ9KFvUstOJXYlCBXMgoE7DXBiWk=
Date: Sun, 16 May 2010 17:33:09 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Simmons <jsimmons@infradead.org>, Ben Skeggs <bskeggs@redhat.com>,
       Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
       nouveau@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       Peter Jones <pjones@redhat.com>
Subject: [PATCH v2 3/3] vga16fb, drm: vga16fb->drm handoff
Message-ID: <20100516153309.GC2793@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

let vga16fb claim 0xA0000+0x10000 region as its aperture;
drm drivers don't use it, so we have to detect it and kick
vga16fb manually - but only if drm is driving the primary card

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
---
no changes since last submission
---
 drivers/gpu/drm/nouveau/nouveau_state.c |    7 ++++++-
 drivers/video/fbmem.c                   |   14 +++++++++++---
 drivers/video/vga16fb.c                 |   26 +++++++++++++++++++-------
 include/linux/fb.h                      |    3 ++-
 4 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index 3efc339..83c6c6b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -666,11 +666,16 @@ static struct apertures_struct *nouveau_get_apertures(struct drm_device *dev)
 static int nouveau_remove_conflicting_drivers(struct drm_device *dev)
 {
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
+	bool primary = false;
 	dev_priv->apertures = nouveau_get_apertures(dev);
 	if (!dev_priv->apertures)
 		return -ENOMEM;
+
+#ifdef CONFIG_X86
+	primary = dev->pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
+#endif
 	
-	remove_conflicting_framebuffers(dev_priv->apertures, "nouveaufb");
+	remove_conflicting_framebuffers(dev_priv->apertures, "nouveaufb", primary);
 	return 0;
 }
 
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 7cfcd71..6deb57c 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1500,19 +1500,26 @@ static bool fb_do_apertures_overlap(struct apertures_struct *gena,
 	return false;
 }
 
-void remove_conflicting_framebuffers(struct apertures_struct *a, const char *name)
+#define VGA_FB_PHYS 0xA0000
+void remove_conflicting_framebuffers(struct apertures_struct *a,
+				     const char *name, bool primary)
 {
 	int i;
 
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
@@ -1545,7 +1552,8 @@ register_framebuffer(struct fb_info *fb_info)
 	if (fb_check_foreignness(fb_info))
 		return -ENOSYS;
 
-	remove_conflicting_framebuffers(fb_info->apertures, fb_info->fix.id);
+	remove_conflicting_framebuffers(fb_info->apertures, fb_info->fix.id,
+					 fb_is_primary_device(fb_info));
 
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
index f88e254..1296af4 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -971,7 +971,8 @@ extern ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
 /* drivers/video/fbmem.c */
 extern int register_framebuffer(struct fb_info *fb_info);
 extern int unregister_framebuffer(struct fb_info *fb_info);
-extern void remove_conflicting_framebuffers(struct apertures_struct *a, const char *name);
+extern void remove_conflicting_framebuffers(struct apertures_struct *a,
+				const char *name, bool primary);
 extern int fb_prepare_logo(struct fb_info *fb_info, int rotate);
 extern int fb_show_logo(struct fb_info *fb_info, int rotate);
 extern char* fb_get_buffer_offset(struct fb_info *info, struct fb_pixmap *buf, u32 size);
-- 
1.7.1

