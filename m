Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab0DMTvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:51:12 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48804 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0DMTvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:51:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JSJwfWGiVSghcO6Uo4mZyHMFyjbIHYVauyT2Tz2DOGTJuLpAWa3MJTbEQ/PLm0Edzc
         kmf6GtL/dbKQDrcmvyTTPPlFE6o5vQooVmUSrXd5wQC09cTJMZcnNzKWEBBlsrGdKbQ0
         ylA9XZFLyjYNzbD5GdjLlVEb4AIiFlgrW5rvw=
Date: Tue, 13 Apr 2010 21:50:04 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-fbdev@vger.kernel.org, nouveau@lists.freedesktop.org,
       LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       Peter Jones <pjones@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] vga16fb, drm/nouveau: vga16fb->nouveau handoff
Message-ID: <20100413195004.GA4402@joi.lan>
References: <1270929334-3742-1-git-send-email-marcin.slusarz@gmail.com>
 <1271030068.3554.1.camel@localhost>
 <20100412113438.GB2789@joi.lan>
 <1271104101.5726.3.camel@t60prh>
 <20100412213327.GA4463@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412213327.GA4463@joi.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 11:33:27PM +0200, Marcin Slusarz wrote:
> > > > Have you got a pointer to a machine where it fails?
> > > 
> > > No, it failed with an artifical test while I was working on vga16fb handoff
> > > (unfinished).
> > 
> > You won't be able to make this work for vga16fb from what I can see
> > since it access 0xa000 directly, not via any of the defined apertures
> > that vesafb/offb use. vga16fb will need a different approach I suspect.
> 
> Yeah, there's an idea to claim 0xa0000 as an aperture of vga16fb and then
> do the same in KMS driver but only if it's the primary card. 
> (You hinted to use SHADOW resource bit to check whether card is primary)
> I think I'll try this approach soon.

Patch below works for me, but I couldn't test the case when nvidia card is secondary.

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Date: Tue, 13 Apr 2010 09:20:53 +0200
Subject: [PATCH] vga16fb, drm/nouveau: vga16fb->nouveau handoff

let vga16fb claim 0xA0000+0x10000 region as its aperture;
nouveau does not use it, so we need to lie to kick vga16fb,
but only if it's driving the primary card (by checking
IORESOURCE_ROM_SHADOW resource flag)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_state.c |   11 ++++++++++-
 drivers/video/vga16fb.c                 |   26 +++++++++++++++++++-------
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index cfa3239..a101861 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -636,10 +636,12 @@ static void nouveau_OF_copy_vbios_to_ramin(struct drm_device *dev)
 #endif
 }
 
+#define VGA_FB_PHYS 0xA0000
+#define VGA_FB_PHYS_LEN 65536
 static struct apertures_struct *nouveau_get_apertures(struct drm_device *dev)
 {
 	struct pci_dev *pdev = dev->pdev;
-	struct apertures_struct *aper = alloc_apertures(3);
+	struct apertures_struct *aper = alloc_apertures(4);
 	if (!aper)
 		return NULL;
 
@@ -658,6 +660,13 @@ static struct apertures_struct *nouveau_get_apertures(struct drm_device *dev)
 		aper->ranges[aper->count].size = pci_resource_len(pdev, 3);
 		aper->count++;
 	}
+	
+	/* if it's the primary card, claim 0xa0000 as ours to kick vga16fb */
+	if (pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW) {
+		aper->ranges[aper->count].base = VGA_FB_PHYS;
+		aper->ranges[aper->count].size = VGA_FB_PHYS_LEN;
+		aper->count++;
+	}
 
 	return aper;
 }
diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 76d8dae..45d7a3d 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -1264,10 +1264,19 @@ static void vga16fb_imageblit(struct fb_info *info, const struct fb_image *image
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
@@ -1307,6 +1316,11 @@ static int __devinit vga16fb_probe(struct platform_device *dev)
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
@@ -1336,7 +1350,7 @@ static int __devinit vga16fb_probe(struct platform_device *dev)
 	info->fix = vga16fb_fix;
 	/* supports rectangles with widths of multiples of 8 */
 	info->pixmap.blit_x = 1 << 7 | 1 << 15 | 1 << 23 | 1 << 31;
-	info->flags = FBINFO_FLAG_DEFAULT |
+	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE |
 		FBINFO_HWACCEL_YPAN;
 
 	i = (info->var.bits_per_pixel == 8) ? 256 : 16;
@@ -1355,6 +1369,9 @@ static int __devinit vga16fb_probe(struct platform_device *dev)
 
 	vga16fb_update_fix(info);
 
+	info->apertures->ranges[0].base = VGA_FB_PHYS;
+	info->apertures->ranges[0].size = VGA_FB_PHYS_LEN;
+
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR "vga16fb: unable to register framebuffer\n");
 		ret = -EINVAL;
@@ -1381,13 +1398,8 @@ static int vga16fb_remove(struct platform_device *dev)
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
-- 
1.7.0.4


