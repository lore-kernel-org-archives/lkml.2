Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1ARVSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:18:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1ARVSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:18:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Dave Airlie <airlied@linux.ie>
Subject: [PATCH 1/4] drm/i810: remove the BKL
Date: Tue, 18 Jan 2011 22:16:59 +0100
Message-Id: <1295385422-3592-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295385422-3592-1-git-send-email-arnd@arndb.de>
References: <1295385422-3592-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:R8/qSF8ed3u5Orx1BRh9VEn9e0BaBvrguO9Zl0NTHao
 771Kp74kgrGDw7lsmcYjjwIidaORP5FRb9HxyulUsNsQfKsEaS
 397qxjE6XGBwcN0/SnhCA4d462MznXbJN0JiK/o5o2tTxO4o9v
 k3YArLZgXn8dxL8LY4drt/1qcuTHHYEev0cAVdnYtfc0inJBVh
 gvtJPILnBZGp3wz1J9srQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMP i810 systems were practically nonexistent and the configuration
was not officially supported by Intel at the time when Pentium-III
was common.

With this change, it is still possible to build a distribution kernel
that has support for SMP and includes the i810 driver without the BKL.
As a precaution, check for the theoretical SMP case at run time and
refuse to load the driver.

We also need to disable CONFIG_PREEMPT builds for this driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/Kconfig         |    4 ++--
 drivers/gpu/drm/i810/i810_dma.c |   18 +-----------------
 drivers/gpu/drm/i810/i810_drv.c |    6 +++++-
 3 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 64828a7..4df921e 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -73,8 +73,8 @@ source "drivers/gpu/drm/radeon/Kconfig"
 
 config DRM_I810
 	tristate "Intel I810"
-	# BKL usage in order to avoid AB-BA deadlocks, may become BROKEN_ON_SMP
-	depends on DRM && AGP && AGP_INTEL && BKL
+	# !PREEMPT because of missing ioctl locking
+	depends on DRM && AGP && AGP_INTEL && (!PREEMPT || BROKEN)
 	help
 	  Choose this option if you have an Intel I810 graphics card.  If M is
 	  selected, the module will be called i810.  AGP support is required
diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dma.c
index ff33e53..8f371e8 100644
--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -37,7 +37,6 @@
 #include <linux/interrupt.h>	/* For task queue support */
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 
 #define I810_BUF_FREE		2
@@ -94,7 +93,6 @@ static int i810_mmap_buffers(struct file *filp, struct vm_area_struct *vma)
 	struct drm_buf *buf;
 	drm_i810_buf_priv_t *buf_priv;
 
-	lock_kernel();
 	dev = priv->minor->dev;
 	dev_priv = dev->dev_private;
 	buf = dev_priv->mmap_buffer;
@@ -104,7 +102,6 @@ static int i810_mmap_buffers(struct file *filp, struct vm_area_struct *vma)
 	vma->vm_file = filp;
 
 	buf_priv->currently_mapped = I810_BUF_MAPPED;
-	unlock_kernel();
 
 	if (io_remap_pfn_range(vma, vma->vm_start,
 			       vma->vm_pgoff,
@@ -116,7 +113,7 @@ static int i810_mmap_buffers(struct file *filp, struct vm_area_struct *vma)
 static const struct file_operations i810_buffer_fops = {
 	.open = drm_open,
 	.release = drm_release,
-	.unlocked_ioctl = i810_ioctl,
+	.unlocked_ioctl = drm_ioctl,
 	.mmap = i810_mmap_buffers,
 	.fasync = drm_fasync,
 	.llseek = noop_llseek,
@@ -1242,19 +1239,6 @@ int i810_driver_dma_quiescent(struct drm_device *dev)
 	return 0;
 }
 
-/*
- * call the drm_ioctl under the big kernel lock because
- * to lock against the i810_mmap_buffers function.
- */
-long i810_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	int ret;
-	lock_kernel();
-	ret = drm_ioctl(file, cmd, arg);
-	unlock_kernel();
-	return ret;
-}
-
 struct drm_ioctl_desc i810_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(I810_INIT, i810_dma_init, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY|DRM_UNLOCKED),
 	DRM_IOCTL_DEF_DRV(I810_VERTEX, i810_dma_vertex, DRM_AUTH|DRM_UNLOCKED),
diff --git a/drivers/gpu/drm/i810/i810_drv.c b/drivers/gpu/drm/i810/i810_drv.c
index 88bcd33..0152fa2 100644
--- a/drivers/gpu/drm/i810/i810_drv.c
+++ b/drivers/gpu/drm/i810/i810_drv.c
@@ -57,7 +57,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .unlocked_ioctl = i810_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
@@ -79,6 +79,10 @@ static struct drm_driver driver = {
 
 static int __init i810_init(void)
 {
+	if (num_possible_cpus() > 1) {
+		pr_err("drm/i810 does not support SMP\n");
+		return -EINVAL;
+	}
 	driver.num_ioctls = i810_max_ioctl;
 	return drm_init(&driver);
 }
-- 
1.7.1

