Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0GJVwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:52:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59417 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab0GJVwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:52:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.freedesktop.org
Subject: [PATCH 1/3] drm: kill BKL from common code
Date: Sat, 10 Jul 2010 23:51:39 +0200
Message-Id: <1278798701-11171-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278798701-11171-1-git-send-email-arnd@arndb.de>
References: <1278798701-11171-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Mzh6rUP/dIMWjSrSDP3JZbOun1HqXQegf/oaHvgJDmi
 xVf/Qq+6gQto05/Z2YRW67NQM2R6RZMNv0LLyepMz7Xs37i+/y
 zehugg038tZGFpBtx4n6ZoM2VlTBj8ieY4xzpXjBuO/LGxCSfw
 n277e17nQN5ILseOHe3lrXu9SB9a3fTD7EFfEJaqZos43EBGSt
 SSAD5dxI/JE0U64qxHxtw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This restricts the use of the big kernel lock to the i830 and i810
device drivers. The three remaining users in common code (open, ioctl
and release) get converted to a new mutex, the drm_global_mutex,
making the locking stricter than the big kernel lock.

This may have a performance impact, but only in those cases that
currently don't use DRM_UNLOCKED flag in the ioctl list and would
benefit from that anyway.

The reason why i810 and i830 cannot use drm_global_mutex in their
mmap functions is a lock-order inversion problem between the current
use of the BKL and mmap_sem in these drivers. Since the BKL has
release-on-sleep semantics, it's harmless but it would cause trouble
if we replace the BKL with a mutex.

Instead, these drivers get their own ioctl wrappers that take the
BKL around every ioctl call and then set their own handlers as
DRM_UNLOCKED.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_drv.c       |    4 +-
 drivers/gpu/drm/drm_fops.c      |   23 +++++++++----------
 drivers/gpu/drm/i810/i810_dma.c |   44 +++++++++++++++++++++++++-------------
 drivers/gpu/drm/i810/i810_drv.c |    2 +-
 drivers/gpu/drm/i810/i810_drv.h |    1 +
 drivers/gpu/drm/i830/i830_dma.c |   42 ++++++++++++++++++++++++------------
 drivers/gpu/drm/i830/i830_drv.c |    2 +-
 drivers/gpu/drm/i830/i830_drv.h |    1 +
 include/drm/drmP.h              |    2 +-
 9 files changed, 75 insertions(+), 46 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 4a66201..76d98f4 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -506,9 +506,9 @@ long drm_ioctl(struct file *filp,
 		if (ioctl->flags & DRM_UNLOCKED)
 			retcode = func(dev, kdata, file_priv);
 		else {
-			lock_kernel();
+			mutex_lock(&drm_global_mutex);
 			retcode = func(dev, kdata, file_priv);
-			unlock_kernel();
+			mutex_unlock(&drm_global_mutex);
 		}
 
 		if (cmd & IOC_OUT) {
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index e7aace2..2ca8df8 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -39,6 +39,9 @@
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 
+/* from BKL pushdown: note that nothing else serializes idr_find() */
+DEFINE_MUTEX(drm_global_mutex);
+
 static int drm_open_helper(struct inode *inode, struct file *filp,
 			   struct drm_device * dev);
 
@@ -175,8 +178,7 @@ int drm_stub_open(struct inode *inode, struct file *filp)
 
 	DRM_DEBUG("\n");
 
-	/* BKL pushdown: note that nothing else serializes idr_find() */
-	lock_kernel();
+	mutex_lock(&drm_global_mutex);
 	minor = idr_find(&drm_minors_idr, minor_id);
 	if (!minor)
 		goto out;
@@ -197,7 +199,7 @@ int drm_stub_open(struct inode *inode, struct file *filp)
 	fops_put(old_fops);
 
 out:
-	unlock_kernel();
+	mutex_unlock(&drm_global_mutex);
 	return err;
 }
 
@@ -472,7 +474,7 @@ int drm_release(struct inode *inode, struct file *filp)
 	struct drm_device *dev = file_priv->minor->dev;
 	int retcode = 0;
 
-	lock_kernel();
+	mutex_lock(&drm_global_mutex);
 
 	DRM_DEBUG("open_count = %d\n", dev->open_count);
 
@@ -573,17 +575,14 @@ int drm_release(struct inode *inode, struct file *filp)
 		if (atomic_read(&dev->ioctl_count)) {
 			DRM_ERROR("Device busy: %d\n",
 				  atomic_read(&dev->ioctl_count));
-			spin_unlock(&dev->count_lock);
-			unlock_kernel();
-			return -EBUSY;
+			retcode = -EBUSY;
+			goto out;
 		}
-		spin_unlock(&dev->count_lock);
-		unlock_kernel();
-		return drm_lastclose(dev);
+		retcode = drm_lastclose(dev);
 	}
+out:
 	spin_unlock(&dev->count_lock);
-
-	unlock_kernel();
+	mutex_unlock(&drm_global_mutex);
 
 	return retcode;
 }
diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dma.c
index 997d917..0090693 100644
--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -37,6 +37,7 @@
 #include <linux/interrupt.h>	/* For task queue support */
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 
 #define I810_BUF_FREE		2
@@ -1245,22 +1246,35 @@ int i810_driver_dma_quiescent(struct drm_device * dev)
 	return 0;
 }
 
+/*
+ * call the drm_ioctl under the big kernel lock because
+ * to lock against the i810_mmap_buffers function.
+ */
+long i810_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+	lock_kernel();
+	ret = drm_ioctl(file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 struct drm_ioctl_desc i810_ioctls[] = {
-	DRM_IOCTL_DEF(DRM_I810_INIT, i810_dma_init, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
-	DRM_IOCTL_DEF(DRM_I810_VERTEX, i810_dma_vertex, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_CLEAR, i810_clear_bufs, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_FLUSH, i810_flush_ioctl, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_GETAGE, i810_getage, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_GETBUF, i810_getbuf, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_SWAP, i810_swap_bufs, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_COPY, i810_copybuf, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_DOCOPY, i810_docopy, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_OV0INFO, i810_ov0_info, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_FSTATUS, i810_fstatus, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_OV0FLIP, i810_ov0_flip, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_MC, i810_dma_mc, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
-	DRM_IOCTL_DEF(DRM_I810_RSTATUS, i810_rstatus, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I810_FLIP, i810_flip_bufs, DRM_AUTH)
+	DRM_IOCTL_DEF(DRM_I810_INIT, i810_dma_init, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_VERTEX, i810_dma_vertex, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_CLEAR, i810_clear_bufs, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_FLUSH, i810_flush_ioctl, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_GETAGE, i810_getage, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_GETBUF, i810_getbuf, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_SWAP, i810_swap_bufs, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_COPY, i810_copybuf, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_DOCOPY, i810_docopy, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_OV0INFO, i810_ov0_info, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_FSTATUS, i810_fstatus, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_OV0FLIP, i810_ov0_flip, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_MC, i810_dma_mc, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_RSTATUS, i810_rstatus, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I810_FLIP, i810_flip_bufs, DRM_AUTH|DRM_UNLOCKED),
 };
 
 int i810_max_ioctl = DRM_ARRAY_SIZE(i810_ioctls);
diff --git a/drivers/gpu/drm/i810/i810_drv.c b/drivers/gpu/drm/i810/i810_drv.c
index c1e0275..b4250b2 100644
--- a/drivers/gpu/drm/i810/i810_drv.c
+++ b/drivers/gpu/drm/i810/i810_drv.c
@@ -59,7 +59,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .unlocked_ioctl = drm_ioctl,
+		 .unlocked_ioctl = i810_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/gpu/drm/i810/i810_drv.h b/drivers/gpu/drm/i810/i810_drv.h
index 21e2691..cac8f37 100644
--- a/drivers/gpu/drm/i810/i810_drv.h
+++ b/drivers/gpu/drm/i810/i810_drv.h
@@ -126,6 +126,7 @@ extern void i810_driver_reclaim_buffers_locked(struct drm_device * dev,
 					       struct drm_file *file_priv);
 extern int i810_driver_device_is_agp(struct drm_device * dev);
 
+extern long i810_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 extern struct drm_ioctl_desc i810_ioctls[];
 extern int i810_max_ioctl;
 
diff --git a/drivers/gpu/drm/i830/i830_dma.c b/drivers/gpu/drm/i830/i830_dma.c
index 65759a9..7a31d71 100644
--- a/drivers/gpu/drm/i830/i830_dma.c
+++ b/drivers/gpu/drm/i830/i830_dma.c
@@ -36,6 +36,7 @@
 #include "i830_drm.h"
 #include "i830_drv.h"
 #include <linux/interrupt.h>	/* For task queue support */
+#include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
@@ -1516,21 +1517,34 @@ int i830_driver_dma_quiescent(struct drm_device * dev)
 	return 0;
 }
 
+/*
+ * call the drm_ioctl under the big kernel lock because
+ * to lock against the i830_mmap_buffers function.
+ */
+long i830_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+	lock_kernel();
+	ret = drm_ioctl(file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 struct drm_ioctl_desc i830_ioctls[] = {
-	DRM_IOCTL_DEF(DRM_I830_INIT, i830_dma_init, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
-	DRM_IOCTL_DEF(DRM_I830_VERTEX, i830_dma_vertex, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_CLEAR, i830_clear_bufs, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_FLUSH, i830_flush_ioctl, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_GETAGE, i830_getage, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_GETBUF, i830_getbuf, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_SWAP, i830_swap_bufs, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_COPY, i830_copybuf, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_DOCOPY, i830_docopy, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_FLIP, i830_flip_bufs, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_IRQ_EMIT, i830_irq_emit, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_IRQ_WAIT, i830_irq_wait, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_GETPARAM, i830_getparam, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_I830_SETPARAM, i830_setparam, DRM_AUTH)
+	DRM_IOCTL_DEF(DRM_I830_INIT, i830_dma_init, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_VERTEX, i830_dma_vertex, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_CLEAR, i830_clear_bufs, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_FLUSH, i830_flush_ioctl, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_GETAGE, i830_getage, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_GETBUF, i830_getbuf, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_SWAP, i830_swap_bufs, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_COPY, i830_copybuf, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_DOCOPY, i830_docopy, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_FLIP, i830_flip_bufs, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_IRQ_EMIT, i830_irq_emit, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_IRQ_WAIT, i830_irq_wait, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_GETPARAM, i830_getparam, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_I830_SETPARAM, i830_setparam, DRM_AUTH|DRM_UNLOCKED),
 };
 
 int i830_max_ioctl = DRM_ARRAY_SIZE(i830_ioctls);
diff --git a/drivers/gpu/drm/i830/i830_drv.c b/drivers/gpu/drm/i830/i830_drv.c
index 44f990b..a5c66aa 100644
--- a/drivers/gpu/drm/i830/i830_drv.c
+++ b/drivers/gpu/drm/i830/i830_drv.c
@@ -70,7 +70,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .unlocked_ioctl = drm_ioctl,
+		 .unlocked_ioctl = i830_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/gpu/drm/i830/i830_drv.h b/drivers/gpu/drm/i830/i830_drv.h
index da82afe..d8df717 100644
--- a/drivers/gpu/drm/i830/i830_drv.h
+++ b/drivers/gpu/drm/i830/i830_drv.h
@@ -122,6 +122,7 @@ typedef struct drm_i830_private {
 
 } drm_i830_private_t;
 
+long i830_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 extern struct drm_ioctl_desc i830_ioctls[];
 extern int i830_max_ioctl;
 
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index c1b9871..cd0e56b 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -50,7 +50,6 @@
 #include <linux/file.h>
 #include <linux/pci.h>
 #include <linux/jiffies.h>
-#include <linux/smp_lock.h>	/* For (un)lock_kernel */
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
 #include <linux/cdev.h>
@@ -1138,6 +1137,7 @@ extern long drm_compat_ioctl(struct file *filp,
 extern int drm_lastclose(struct drm_device *dev);
 
 				/* Device support (drm_fops.h) */
+extern struct mutex drm_global_mutex;
 extern int drm_open(struct inode *inode, struct file *filp);
 extern int drm_stub_open(struct inode *inode, struct file *filp);
 extern int drm_fasync(int fd, struct file *filp, int on);
-- 
1.7.1

