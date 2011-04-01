Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab1DASEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:04:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37976 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755300Ab1DASEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:04:13 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 4/9] gma500: Add a test ioctl for issuing 2D accel ops via
 user space
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Apr 2011 18:41:30 +0100
Message-ID: <20110401174128.18112.72945.stgit@localhost.localdomain>
In-Reply-To: <20110401173554.18112.67483.stgit@localhost.localdomain>
References: <20110401173554.18112.67483.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_2d.c  |    2 +-
 drivers/staging/gma500/psb_drv.h |    3 +++
 drivers/staging/gma500/psb_fb.c  |   26 ++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
index 9a0691f..94bce5c 100644
--- a/drivers/staging/gma500/psb_2d.c
+++ b/drivers/staging/gma500/psb_2d.c
@@ -84,7 +84,7 @@ static int psb_2d_wait_available(struct drm_psb_private *dev_priv,
 /* FIXME: Remember if we expose the 2D engine to the DRM we need to serialize
    it with console use */
 
-static int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
+int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
 	 	  	   unsigned size)
 {
 	int ret = 0;
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 7361fbf..8c1eceb 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -709,6 +709,9 @@ extern int psbfb_sync(struct fb_info *info);
 
 extern void psb_spank(struct drm_psb_private *dev_priv);
 
+extern int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
+	 	  	   unsigned size);
+
 /*
  *psb_reset.c
  */
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 6c75df5..6499f28 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -270,6 +270,31 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	return 0;
 }
 
+static int psbfb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
+{
+	struct psb_fbdev *fbdev = info->par;
+	struct psb_framebuffer *psbfb = fbdev->pfb;
+	struct drm_device *dev = psbfb->base.dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 __user *p = (u32 __user *)arg;
+	u32 l;
+	u32 buf[32];
+	switch (cmd) {
+	case 0x12345678:
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		if (get_user(l, p))
+			return -EFAULT;
+		if (l > 32)
+			return -EMSGSIZE;
+		if (copy_from_user(buf, p + 1, l))
+			return -EFAULT;
+		psbfb_2d_submit(dev_priv, buf, l);
+		return 0;
+	default:
+		return -ENOTTY;
+	}
+}
 
 static struct fb_ops psbfb_ops = {
 	.owner = THIS_MODULE,
@@ -282,6 +307,7 @@ static struct fb_ops psbfb_ops = {
 	.fb_imageblit = psbfb_imageblit,
 	.fb_mmap = psbfb_mmap,
 	.fb_sync = psbfb_sync,
+	.fb_ioctl = psbfb_ioctl,
 };
 
 static struct drm_framebuffer *psb_framebuffer_create

