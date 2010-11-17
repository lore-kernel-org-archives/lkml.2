Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934833Ab0KQP1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:27:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52037 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934791Ab0KQP1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:27:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 2/7] drm/i810: remove the BKL
Date: Wed, 17 Nov 2010 16:26:54 +0100
Message-Id: <1290007619-5787-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290007619-5787-1-git-send-email-arnd@arndb.de>
References: <1290007619-5787-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Ce4fCsOQqK9fEP4MyYTwP5qD/0PhezmKfl/jTd1hDlZ
 dvc7GyzhvVG4yWom2wAgsI7c5ZQ7uljYDmAo5lVeLH21QEl3qO
 iYUxChKE/k5QeEIv0gIDKjDcA/GpYG+sE+/ZJhVbnR7KJz6hqZ
 7cLaWCxaSs9LsGHbyki1kKdyZxdN+mlXxffLRNYTb9NTa/mpGx
 Sz1S4k7H+Btm4jmyl8f9A==
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
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/Kconfig         |    4 ++--
 drivers/gpu/drm/i810/i810_dma.c |   18 +-----------------
 drivers/gpu/drm/i810/i810_drv.c |    6 +++++-
 3 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 7af4436..ddc122f 100644
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

