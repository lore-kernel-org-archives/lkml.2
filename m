Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab0EPPa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 11:30:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64433 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0EPPa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 11:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=soYREaFG3jFwQlGezaZz8aCRJfIv+MlRw3w4oAhEAa3UbK/nXOt6CsmZSRG1mRv/TX
         oRmS9FDHYXMjEOaXQKnqx47vcRZzvI4LaPlwqfCuJGI6hXJQNYF8I6tx+hLWrPUxF3SJ
         wI44+FGrj4D2mVw6H1PZJSiookUIBDbWvD6AI=
Date: Sun, 16 May 2010 17:29:56 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Didier Spaier <didier.spaier@epsm.fr>, Ben Skeggs <bskeggs@redhat.com>,
       Dave Airlie <airlied@redhat.com>, Peter Jones <pjones@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       nouveau@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH v2 2/3] fbmem, drm/nouveau: kick firmware framebuffers as
 soon as possible
Message-ID: <20100516152956.GB2793@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently vesafb/efifb/... is kicked when hardware driver is registering
framebuffer. To do it hardware must be fully functional, so there's a short
window between start of initialisation and framebuffer registration when
two drivers touch the hardware. Unfortunately sometimes it breaks nouveau
initialisation.

Fix it by kicking firmware driver(s) before we start touching the hardware.

Reported-by: Didier Spaier <didier.spaier@epsm.fr>
Tested-by: Didier Spaier <didier.spaier@epsm.fr>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
no changes since last submission
---
 drivers/gpu/drm/nouveau/nouveau_drv.h   |    2 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |   19 +-------------
 drivers/gpu/drm/nouveau/nouveau_state.c |   43 +++++++++++++++++++++++++++++++
 drivers/video/fbmem.c                   |   43 ++++++++++++++++++-------------
 include/linux/fb.h                      |    1 +
 5 files changed, 72 insertions(+), 36 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index ace630a..59641eb 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -621,6 +621,8 @@ struct drm_nouveau_private {
 	struct {
 		struct dentry *channel_root;
 	} debugfs;
+
+	struct apertures_struct *apertures;
 };
 
 static inline struct drm_nouveau_private *
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 6b2d5ab..660746b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -194,7 +194,6 @@ nouveau_fbcon_create(struct drm_device *dev, uint32_t fb_width,
 	struct drm_mode_fb_cmd mode_cmd;
 	struct pci_dev *pdev = dev->pdev;
 	struct device *device = &pdev->dev;
-	struct apertures_struct *aper;
 	int size, ret;
 
 	mode_cmd.width = surface_width;
@@ -281,28 +280,12 @@ nouveau_fbcon_create(struct drm_device *dev, uint32_t fb_width,
 	info->fix.mmio_len = pci_resource_len(pdev, 1);
 
 	/* Set aperture base/size for vesafb takeover */
-	aper = info->apertures = alloc_apertures(3);
+	info->apertures = dev_priv->apertures;
 	if (!info->apertures) {
 		ret = -ENOMEM;
 		goto out_unref;
 	}
 
-	aper->ranges[0].base = pci_resource_start(pdev, 1);
-	aper->ranges[0].size = pci_resource_len(pdev, 1);
-	aper->count = 1;
-
-	if (pci_resource_len(pdev, 2)) {
-		aper->ranges[aper->count].base = pci_resource_start(pdev, 2);
-		aper->ranges[aper->count].size = pci_resource_len(pdev, 2);
-		aper->count++;
-	}
-
-	if (pci_resource_len(pdev, 3)) {
-		aper->ranges[aper->count].base = pci_resource_start(pdev, 3);
-		aper->ranges[aper->count].size = pci_resource_len(pdev, 3);
-		aper->count++;
-	}
-
 	info->pixmap.size = 64*1024;
 	info->pixmap.buf_align = 8;
 	info->pixmap.access_align = 32;
diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index e171064..3efc339 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -637,6 +637,43 @@ static void nouveau_OF_copy_vbios_to_ramin(struct drm_device *dev)
 #endif
 }
 
+static struct apertures_struct *nouveau_get_apertures(struct drm_device *dev)
+{
+	struct pci_dev *pdev = dev->pdev;
+	struct apertures_struct *aper = alloc_apertures(3);
+	if (!aper)
+		return NULL;
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
+	}
+
+	return aper;
+}
+
+static int nouveau_remove_conflicting_drivers(struct drm_device *dev)
+{
+	struct drm_nouveau_private *dev_priv = dev->dev_private;
+	dev_priv->apertures = nouveau_get_apertures(dev);
+	if (!dev_priv->apertures)
+		return -ENOMEM;
+	
+	remove_conflicting_framebuffers(dev_priv->apertures, "nouveaufb");
+	return 0;
+}
+
 int nouveau_load(struct drm_device *dev, unsigned long flags)
 {
 	struct drm_nouveau_private *dev_priv;
@@ -724,6 +761,12 @@ int nouveau_load(struct drm_device *dev, unsigned long flags)
 	NV_INFO(dev, "Detected an NV%2x generation card (0x%08x)\n",
 		dev_priv->card_type, reg0);
 
+	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+		int ret = nouveau_remove_conflicting_drivers(dev);
+		if (ret)
+			return ret;
+	}
+
 	/* map larger RAMIN aperture on NV40 cards */
 	dev_priv->ramin  = NULL;
 	if (dev_priv->card_type >= NV_40) {
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 03f2dc2..7cfcd71 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1479,11 +1479,10 @@ static bool apertures_overlap(struct aperture *gen, struct aperture *hw)
 	return false;
 }
 
-static bool fb_do_apertures_overlap(struct fb_info *gen, struct fb_info *hw)
+static bool fb_do_apertures_overlap(struct apertures_struct *gena,
+				    struct apertures_struct *hwa)
 {
 	int i, j;
-	struct apertures_struct *hwa = hw->apertures;
-	struct apertures_struct *gena = gen->apertures;
 	if (!hwa || !gena)
 		return false;
 
@@ -1501,6 +1500,28 @@ static bool fb_do_apertures_overlap(struct fb_info *gen, struct fb_info *hw)
 	return false;
 }
 
+void remove_conflicting_framebuffers(struct apertures_struct *a, const char *name)
+{
+	int i;
+
+	/* check all firmware fbs and kick off if the base addr overlaps */
+	for (i = 0 ; i < FB_MAX; i++) {
+		if (!registered_fb[i])
+			continue;
+
+		if (!(registered_fb[i]->flags & FBINFO_MISC_FIRMWARE))
+			continue;
+
+		if (fb_do_apertures_overlap(registered_fb[i]->apertures, a)) {
+			printk(KERN_ERR "fb: conflicting fb hw usage "
+			       "%s vs %s - removing generic driver\n",
+			       name, registered_fb[i]->fix.id);
+			unregister_framebuffer(registered_fb[i]);
+		}
+	}
+}
+EXPORT_SYMBOL(remove_conflicting_framebuffers);
+
 /**
  *	register_framebuffer - registers a frame buffer device
  *	@fb_info: frame buffer info structure
@@ -1524,21 +1545,7 @@ register_framebuffer(struct fb_info *fb_info)
 	if (fb_check_foreignness(fb_info))
 		return -ENOSYS;
 
-	/* check all firmware fbs and kick off if the base addr overlaps */
-	for (i = 0 ; i < FB_MAX; i++) {
-		if (!registered_fb[i])
-			continue;
-
-		if (registered_fb[i]->flags & FBINFO_MISC_FIRMWARE) {
-			if (fb_do_apertures_overlap(registered_fb[i], fb_info)) {
-				printk(KERN_ERR "fb: conflicting fb hw usage "
-				       "%s vs %s - removing generic driver\n",
-				       fb_info->fix.id,
-				       registered_fb[i]->fix.id);
-				unregister_framebuffer(registered_fb[i]);
-			}
-		}
-	}
+	remove_conflicting_framebuffers(fb_info->apertures, fb_info->fix.id);
 
 	num_registered_fb++;
 	for (i = 0 ; i < FB_MAX; i++)
diff --git a/include/linux/fb.h b/include/linux/fb.h
index de5ff5f..f88e254 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -971,6 +971,7 @@ extern ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
 /* drivers/video/fbmem.c */
 extern int register_framebuffer(struct fb_info *fb_info);
 extern int unregister_framebuffer(struct fb_info *fb_info);
+extern void remove_conflicting_framebuffers(struct apertures_struct *a, const char *name);
 extern int fb_prepare_logo(struct fb_info *fb_info, int rotate);
 extern int fb_show_logo(struct fb_info *fb_info, int rotate);
 extern char* fb_get_buffer_offset(struct fb_info *info, struct fb_pixmap *buf, u32 size);
-- 
1.7.1

