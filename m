Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1F1WIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:08:39 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41004 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab1F1WIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:08:31 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 21/29] gma500: psb_fb tidy/cleanup pass
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:08:04 +0100
Message-ID: <20110628220759.898.24723.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Eliminate unused stuff and clean up the code ordering.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drm.h |    4 -
 drivers/staging/gma500/psb_drv.c |    9 ---
 drivers/staging/gma500/psb_drv.h |    6 --
 drivers/staging/gma500/psb_fb.c  |  135 ++++++++------------------------------
 4 files changed, 29 insertions(+), 125 deletions(-)


diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
index c541137..5dcf045 100644
--- a/drivers/staging/gma500/psb_drm.h
+++ b/drivers/staging/gma500/psb_drm.h
@@ -145,8 +145,6 @@ struct drm_psb_register_rw_arg {
 
 /* Controlling the kernel modesetting buffers */
 
-#define DRM_PSB_KMS_OFF		0x00
-#define DRM_PSB_KMS_ON		0x01
 #define DRM_PSB_SIZES           0x07
 #define DRM_PSB_FUSE_REG	0x08
 #define DRM_PSB_DC_STATE	0x0A
@@ -155,7 +153,7 @@ struct drm_psb_register_rw_arg {
 #define DRM_PSB_STOLEN_MEMORY	0x0D
 #define DRM_PSB_REGISTER_RW	0x0E
 
-/**
+/*
  * NOTE: Add new commands here, but increment
  * the values below and increment their
  * corresponding defines where they're
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index cbdc02c..0d65f75 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -75,10 +75,6 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
  * Standard IOCTLs.
  */
 
-#define DRM_IOCTL_PSB_KMS_OFF	\
-		DRM_IO(DRM_PSB_KMS_OFF + DRM_COMMAND_BASE)
-#define DRM_IOCTL_PSB_KMS_ON	\
-		DRM_IO(DRM_PSB_KMS_ON + DRM_COMMAND_BASE)
 #define DRM_IOCTL_PSB_SIZES	\
 		DRM_IOR(DRM_PSB_SIZES + DRM_COMMAND_BASE, \
 			struct drm_psb_sizes_arg)
@@ -134,11 +130,6 @@ static int psb_dpst_bl_ioctl(struct drm_device *dev, void *data,
 	[DRM_IOCTL_NR(ioctl) - DRM_COMMAND_BASE] = {ioctl, flags, func}
 
 static struct drm_ioctl_desc psb_ioctls[] = {
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_KMS_OFF, psbfb_kms_off_ioctl,
-		      DRM_ROOT_ONLY),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_KMS_ON,
-			psbfb_kms_on_ioctl,
-			DRM_ROOT_ONLY),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_SIZES, psb_sizes_ioctl, DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_DC_STATE, psb_dc_state_ioctl, DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_ADB, psb_adb_ioctl, DRM_AUTH),
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 86abf26..3b2ee08 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -704,12 +704,6 @@ extern int psb_intel_opregion_init(struct drm_device *dev);
 extern int psbfb_probed(struct drm_device *dev);
 extern int psbfb_remove(struct drm_device *dev,
 			struct drm_framebuffer *fb);
-extern int psbfb_kms_off_ioctl(struct drm_device *dev, void *data,
-			       struct drm_file *file_priv);
-extern int psbfb_kms_on_ioctl(struct drm_device *dev, void *data,
-			      struct drm_file *file_priv);
-extern void *psbfb_vdc_reg(struct drm_device* dev);
-
 /*
  * psb_2d.c
  */
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 8377a99..83095fc 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -52,13 +52,6 @@ static const struct drm_framebuffer_funcs psb_fb_funcs = {
 
 #define CMAP_TOHW(_val, _width) ((((_val) << (_width)) + 0x7FFF - (_val)) >> 16)
 
-void *psbfb_vdc_reg(struct drm_device *dev)
-{
-	struct drm_psb_private *dev_priv;
-	dev_priv = (struct drm_psb_private *) dev->dev_private;
-	return dev_priv->vdc_reg;
-}
-
 static int psbfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 			   unsigned blue, unsigned transp,
 			   struct fb_info *info)
@@ -98,108 +91,60 @@ static int psbfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 	return 0;
 }
 
-static int psbfb_kms_off(struct drm_device *dev, int suspend)
+
+void psbfb_suspend(struct drm_device *dev)
 {
 	struct drm_framebuffer *fb = 0;
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
 
+	console_lock();
 	mutex_lock(&dev->mode_config.mutex);
 	list_for_each_entry(fb, &dev->mode_config.fb_list, head) {
 		struct fb_info *info = psbfb->fbdev;
-
-		if (suspend) {
-			fb_set_suspend(info, 1);
-			drm_fb_helper_blank(FB_BLANK_POWERDOWN, info);
-		}
+		fb_set_suspend(info, 1);
+		drm_fb_helper_blank(FB_BLANK_POWERDOWN, info);
 	}
 	mutex_unlock(&dev->mode_config.mutex);
-	return 0;
-}
-
-int psbfb_kms_off_ioctl(struct drm_device *dev, void *data,
-			struct drm_file *file_priv)
-{
-	int ret;
-
-	if (drm_psb_no_fb)
-		return 0;
-	console_lock();
-	ret = psbfb_kms_off(dev, 0);
 	console_unlock();
-
-	return ret;
 }
 
-static int psbfb_kms_on(struct drm_device *dev, int resume)
+void psbfb_resume(struct drm_device *dev)
 {
 	struct drm_framebuffer *fb = 0;
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
 
+	console_lock();
 	mutex_lock(&dev->mode_config.mutex);
 	list_for_each_entry(fb, &dev->mode_config.fb_list, head) {
 		struct fb_info *info = psbfb->fbdev;
-
-		if (resume) {
-			fb_set_suspend(info, 0);
-			drm_fb_helper_blank(FB_BLANK_UNBLANK, info);
-		}
+		fb_set_suspend(info, 0);
+		drm_fb_helper_blank(FB_BLANK_UNBLANK, info);
 	}
 	mutex_unlock(&dev->mode_config.mutex);
-
-	return 0;
-}
-
-int psbfb_kms_on_ioctl(struct drm_device *dev, void *data,
-		       struct drm_file *file_priv)
-{
-	int ret;
-
-	if (drm_psb_no_fb)
-		return 0;
-	console_lock();
-	ret = psbfb_kms_on(dev, 0);
-	console_unlock();
-	drm_helper_disable_unused_functions(dev);
-	return ret;
-}
-
-void psbfb_suspend(struct drm_device *dev)
-{
-	console_lock();
-	psbfb_kms_off(dev, 1);
-	console_unlock();
-}
-
-void psbfb_resume(struct drm_device *dev)
-{
-	console_lock();
-	psbfb_kms_on(dev, 1);
 	console_unlock();
 	drm_helper_disable_unused_functions(dev);
 }
 
 static int psbfb_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	int page_num = 0;
-	int i;
-	unsigned long address = 0;
-	int ret;
-	unsigned long pfn;
 	struct psb_framebuffer *psbfb = vma->vm_private_data;
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
-
+	int page_num;
+	int i;
+	unsigned long address;
+	int ret;
+	unsigned long pfn;
 	/* FIXME: assumes fb at stolen base which may not be true */
 	unsigned long phys_addr = (unsigned long)dev_priv->stolen_base;
 
 	page_num = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-
 	address = (unsigned long)vmf->virtual_address;
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	for (i = 0; i < page_num; i++) {
-		pfn = (phys_addr >> PAGE_SHIFT); /* phys_to_pfn(phys_addr); */
+		pfn = (phys_addr >> PAGE_SHIFT);
 
 		ret = vm_insert_mixed(vma, address, pfn);
 		if (unlikely((ret == -EBUSY) || (ret != 0 && i > 0)))
@@ -208,11 +153,9 @@ static int psbfb_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 			ret = (ret == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS;
 			return ret;
 		}
-
 		address += PAGE_SIZE;
 		phys_addr += PAGE_SIZE;
 	}
-
 	return VM_FAULT_NOPAGE;
 }
 
@@ -234,7 +177,6 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	struct psb_fbdev *fbdev = info->par;
 	struct psb_framebuffer *psbfb = &fbdev->pfb;
-	char *fb_screen_base = NULL;
 
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
@@ -243,9 +185,6 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 
 	if (!psbfb->addr_space)
 		psbfb->addr_space = vma->vm_file->f_mapping;
-
-	fb_screen_base = (char *)info->screen_base;
-
 	/*
 	 * If this is a GEM object then info->screen_base is the virtual
 	 * kernel remapping of the object. FIXME: Review if this is
@@ -272,8 +211,8 @@ static int psbfb_ioctl(struct fb_info *info, unsigned int cmd,
 	case 0x12345678:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
-	        if (IS_MFLD(dev))
-                        return -EOPNOTSUPP;
+		if (IS_MFLD(dev))
+			return -EOPNOTSUPP;
 		if (get_user(l, p))
 			return -EFAULT;
 		if (l > 32)
@@ -488,9 +427,9 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	info->flags = FBINFO_DEFAULT;
 	/* No 2D engine */
 	if (IS_MFLD(dev))
-	        info->fbops = &psbfb_mfld_ops;
-        else
-        	info->fbops = &psbfb_ops;
+		info->fbops = &psbfb_mfld_ops;
+	else
+		info->fbops = &psbfb_ops;
 
 	ret = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (ret) {
@@ -518,7 +457,6 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 		psbfb->vm_map = 1;
 	}
 	info->screen_size = size;
-/*	memset(info->screen_base, 0, size); */
 
 	if (dev_priv->pg->stolen_size) {
 		info->apertures = alloc_apertures(1);
@@ -644,15 +582,8 @@ int psb_fbdev_destroy(struct drm_device *dev, struct psb_fbdev *fbdev)
 	drm_fb_helper_fini(&fbdev->psb_fb_helper);
 	drm_framebuffer_cleanup(&psbfb->base);
 
-	if (psbfb->gtt) {
-		/* FIXME: this is a bit more inside knowledge than I'd like
-		   but I don't see how to make a fake GEM object of the
-		   stolen space nicely */
-		if (psbfb->gtt->stolen)
-			psb_gtt_free_range(dev, psbfb->gtt);
-		else
-			drm_gem_object_unreference(&psbfb->gtt->gem);
-	}
+	if (psbfb->gtt)
+		drm_gem_object_unreference(&psbfb->gtt->gem);
 	return 0;
 }
 
@@ -671,6 +602,7 @@ int psb_fbdev_init(struct drm_device *dev)
 	dev_priv->fbdev = fbdev;
 	fbdev->psb_fb_helper.funcs = &psb_fb_helper_funcs;
 
+	/* FIXME: check Medfield */
 	num_crtc = 2;
 
 	drm_fb_helper_init(dev, &fbdev->psb_fb_helper, num_crtc,
@@ -769,17 +701,14 @@ static const struct drm_mode_config_funcs psb_mode_funcs = {
 
 static int psb_create_backlight_property(struct drm_device *dev)
 {
-	struct drm_psb_private *dev_priv
-				= (struct drm_psb_private *) dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct drm_property *backlight;
 
 	if (dev_priv->backlight_property)
 		return 0;
 
-	backlight = drm_property_create(dev,
-					DRM_MODE_PROP_RANGE,
-					"backlight",
-					2);
+	backlight = drm_property_create(dev, DRM_MODE_PROP_RANGE,
+							"backlight", 2);
 	backlight->values[0] = 0;
 	backlight->values[1] = 100;
 
@@ -790,12 +719,10 @@ static int psb_create_backlight_property(struct drm_device *dev)
 
 static void psb_setup_outputs(struct drm_device *dev)
 {
-	struct drm_psb_private *dev_priv =
-	    (struct drm_psb_private *) dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct drm_connector *connector;
 
 	drm_mode_create_scaling_mode_property(dev);
-
 	psb_create_backlight_property(dev);
 
 	if (IS_MRST(dev)) {
@@ -805,7 +732,7 @@ static void psb_setup_outputs(struct drm_device *dev)
 			dev_err(dev->dev, "DSI is not supported\n");
 	} else if (IS_MFLD(dev)) {
 		mdfld_output_init(dev);
-        } else {
+	} else {
 		psb_intel_lvds_init(dev, &dev_priv->mode_dev);
 		psb_intel_sdvo_init(dev, SDVOB);
 	}
@@ -843,11 +770,9 @@ static void psb_setup_outputs(struct drm_device *dev)
 			clone_mask = (1 << INTEL_OUTPUT_HDMI);
 			break;
 		}
-
 		encoder->possible_crtcs = crtc_mask;
 		encoder->possible_clones =
 		    psb_intel_connector_clones(dev, clone_mask);
-
 	}
 }
 
@@ -878,9 +803,6 @@ void psb_modeset_init(struct drm_device *dev)
 	dev->mode_config.max_height = 2048;
 
 	psb_setup_outputs(dev);
-
-	/* setup fbs */
-	/* drm_initial_config(dev); */
 }
 
 void psb_modeset_cleanup(struct drm_device *dev)
@@ -889,7 +811,6 @@ void psb_modeset_cleanup(struct drm_device *dev)
 
 	drm_kms_helper_poll_fini(dev);
 	psb_fbdev_fini(dev);
-
 	drm_mode_config_cleanup(dev);
 
 	mutex_unlock(&dev->struct_mutex);

