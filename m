Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1GOQlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:41:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35804 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1GOQlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:41:02 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/15] gma500: Move the 2D operations into DRM
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:32:13 +0100
Message-ID: <20110715163137.28759.43236.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We currently have a test hack framebuffer mode ioctl, turn that into a DRM
interface.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/accel_2d.c    |   60 ++++++++++++++++++++++++++++++++--
 drivers/staging/gma500/framebuffer.c |   25 +-------------
 drivers/staging/gma500/psb_drm.h     |   13 +++++++
 drivers/staging/gma500/psb_drv.c     |    9 +++--
 drivers/staging/gma500/psb_drv.h     |    7 +++-
 5 files changed, 82 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/gma500/accel_2d.c b/drivers/staging/gma500/accel_2d.c
index c719017..ed00854 100644
--- a/drivers/staging/gma500/accel_2d.c
+++ b/drivers/staging/gma500/accel_2d.c
@@ -105,19 +105,20 @@ static int psb_2d_wait_available(struct drm_psb_private *dev_priv,
  *	Issue one or more 2D commands to the accelerator. This needs to be
  *	serialized later when we add the GEM interfaces for acceleration
  */
-int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
+static int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
 								unsigned size)
 {
 	int ret = 0;
 	int i;
 	unsigned submit_size;
 
+	mutex_lock(&dev_priv->mutex_2d);
 	while (size > 0) {
 		submit_size = (size < 0x60) ? size : 0x60;
 		size -= submit_size;
 		ret = psb_2d_wait_available(dev_priv, submit_size);
 		if (ret)
-			return ret;
+		        break;
 
 		submit_size <<= 2;
 
@@ -126,7 +127,8 @@ int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
 
 		(void)PSB_RSGX32(PSB_SGX_2D_SLAVE_PORT + i - 4);
 	}
-	return 0;
+	mutex_unlock(&dev_priv->mutex_2d);
+	return ret;
 }
 
 
@@ -326,6 +328,7 @@ int psbfb_sync(struct fb_info *info)
 	unsigned long _end = jiffies + DRM_HZ;
 	int busy = 0;
 
+	mutex_lock(&dev_priv->mutex_2d);
 	/*
 	 * First idle the 2D engine.
 	 */
@@ -354,5 +357,56 @@ int psbfb_sync(struct fb_info *info)
 					_PSB_C2B_STATUS_BUSY) != 0);
 
 out:
+	mutex_unlock(&dev_priv->mutex_2d);
 	return (busy) ? -EBUSY : 0;
 }
+
+int psb_accel_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_psb_2d_op *op = data;
+	u32 *op_ptr = &op->cmd[0];
+	int i;
+	struct drm_gem_object *obj;
+	struct gtt_range *gtt;
+	int err = -EINVAL;
+
+	if (!dev_priv->ops->accel_2d)
+		return -EOPNOTSUPP;
+	if (op->size > PSB_2D_OP_BUFLEN)
+		return -EINVAL;
+
+	/* The GEM object being used. We need to support separate src/dst/etc
+	   in the end but for now keep them all the same */
+	obj = drm_gem_object_lookup(dev, file, op->src);
+	if (obj == NULL)
+		return -ENOENT;
+	gtt = container_of(obj, struct gtt_range, gem);
+
+	if (psb_gtt_pin(gtt) < 0)
+		goto bad_2;
+	for (i = 0; i < op->size; i++, op_ptr++) {
+		u32 r = *op_ptr & 0xF0000000;
+		/* Fill in the GTT offsets for the command buffer */
+        	if (r == PSB_2D_SRC_SURF_BH ||
+			r == PSB_2D_DST_SURF_BH || 
+			r == PSB_2D_MASK_SURF_BH ||
+			r == PSB_2D_PAT_SURF_BH) {
+			i++;
+			op_ptr++;
+			if (i == op->size)
+				goto bad;
+                        if (*op_ptr)
+				goto bad;
+                        *op_ptr = gtt->offset;
+                        continue;
+                }
+	}
+	psbfb_2d_submit(dev_priv, op->cmd, op->size);
+	err = 0;
+bad:
+	psb_gtt_unpin(gtt);
+bad_2:
+	drm_gem_object_unreference(obj);
+	return err;
+}
diff --git a/drivers/staging/gma500/framebuffer.c b/drivers/staging/gma500/framebuffer.c
index 76b986f..d890a50 100644
--- a/drivers/staging/gma500/framebuffer.c
+++ b/drivers/staging/gma500/framebuffer.c
@@ -200,30 +200,7 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 static int psbfb_ioctl(struct fb_info *info, unsigned int cmd,
 						unsigned long arg)
 {
-	struct psb_fbdev *fbdev = info->par;
-	struct psb_framebuffer *psbfb = &fbdev->pfb;
-	struct drm_device *dev = psbfb->base.dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	u32 __user *p = (u32 __user *)arg;
-	u32 l;
-	u32 buf[32];
-	switch (cmd) {
-	case 0x12345678:
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-		if (!dev_priv->ops->accel_2d)
-			return -EOPNOTSUPP;
-		if (get_user(l, p))
-			return -EFAULT;
-		if (l > 32)
-			return -EMSGSIZE;
-		if (copy_from_user(buf, p + 1, l * sizeof(u32)))
-			return -EFAULT;
-		psbfb_2d_submit(dev_priv, buf, l);
-		return 0;
-	default:
-		return -ENOTTY;
-	}
+	return -ENOTTY;
 }
 
 static struct fb_ops psbfb_ops = {
diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
index 7175117..eef53f3 100644
--- a/drivers/staging/gma500/psb_drm.h
+++ b/drivers/staging/gma500/psb_drm.h
@@ -161,6 +161,7 @@ struct drm_psb_register_rw_arg {
  */
 
 #define DRM_PSB_GEM_CREATE	0x10
+#define DRM_PSB_2D_OP		0x11
 #define DRM_PSB_DPST		0x1B
 #define DRM_PSB_GAMMA		0x1C
 #define DRM_PSB_DPST_BL		0x1D
@@ -190,4 +191,16 @@ struct drm_psb_gem_create {
 	__u32 pad;
 };
 
+#define PSB_2D_OP_BUFLEN		16
+
+struct drm_psb_2d_op {
+	__u32 src;		/* Handles, only src supported right now */
+	__u32 dst;
+	__u32 mask;
+	__u32 pat;
+	__u32 size;		/* In dwords of command */
+	__u32 spare;		/* And bumps array to u64 align */
+	__u32 cmd[PSB_2D_OP_BUFLEN];
+};
+
 #endif
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index a753977..36bb716 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -124,6 +124,9 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 #define DRM_IOCTL_PSB_GEM_CREATE	\
 		DRM_IOWR(DRM_PSB_GEM_CREATE + DRM_COMMAND_BASE, \
 			 struct drm_psb_gem_create)
+#define DRM_IOCTL_PSB_2D_OP	\
+		DRM_IOW(DRM_PSB_2D_OP + DRM_COMMAND_BASE, \
+			 struct drm_psb_2d_op)
 
 static int psb_sizes_ioctl(struct drm_device *dev, void *data,
 			   struct drm_file *file_priv);
@@ -164,7 +167,7 @@ static struct drm_ioctl_desc psb_ioctls[] = {
 					psb_intel_get_pipe_from_crtc_id, 0),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GEM_CREATE, psb_gem_create_ioctl,
 						DRM_UNLOCKED | DRM_AUTH),
-
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_2D_OP, psb_accel_ioctl, DRM_UNLOCKED),
 };
 
 static void psb_lastclose(struct drm_device *dev)
@@ -179,8 +182,7 @@ static void psb_do_takedown(struct drm_device *dev)
 
 static int psb_do_init(struct drm_device *dev)
 {
-	struct drm_psb_private *dev_priv =
-	    (struct drm_psb_private *) dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct psb_gtt *pg = &dev_priv->gtt;
 
 	uint32_t stolen_gtt;
@@ -221,6 +223,7 @@ static int psb_do_init(struct drm_device *dev)
 
 
 	spin_lock_init(&dev_priv->irqmask_lock);
+	mutex_init(&dev_priv->mutex_2d);
 
 	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK0);
 	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK1);
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 12d13ae..db3e356 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -599,6 +599,9 @@ struct drm_psb_private {
 	bool dsr_enable;
 	void (*exit_idle)(struct drm_device *dev, u32 update_src, void *p_surfaceAddr, bool check_hw_on_only);
 
+	/* 2D acceleration */
+	struct mutex mutex_2d;
+
 	/* FIXME: Arrays anyone ? */
 	struct mdfld_dsi_encoder *encoder0;	
 	struct mdfld_dsi_encoder *encoder2;	
@@ -744,8 +747,8 @@ extern void psbfb_copyarea(struct fb_info *info,
 					const struct fb_copyarea *region);
 extern int psbfb_sync(struct fb_info *info);
 extern void psb_spank(struct drm_psb_private *dev_priv);
-extern int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
-					unsigned size);
+extern int psb_accel_ioctl(struct drm_device *dev, void *data,
+							struct drm_file *file);
 
 /*
  * psb_reset.c

