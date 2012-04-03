Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2DCLOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:14:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53337 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2DCLOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:14:49 -0400
From: santosh nayak <santoshprasadnayak@gmail.com>
To: gregkh@linuxfoundation.org
Cc: martyn.welch@ge.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] Staging: vme: Replace semaphore by mutex.
Date: Tue,  3 Apr 2012 16:42:51 +0530
Message-Id: <1333451571-17765-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Replace binary semaphore by mutex for code cleanup. 
Mutex also gives better performance than semaphore.

Add 'mutex_destroy()' in 'vme_user_remove()' routine.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |   43 ++++++++++++++++---------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 7dcd162..10269d5 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -27,7 +27,7 @@
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/pci.h>
-#include <linux/semaphore.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
@@ -95,7 +95,7 @@ struct image_desc {
 	void *kern_buf;	/* Buffer address in kernel space */
 	dma_addr_t pci_buf;	/* Buffer address in PCI address space */
 	unsigned long long size_buf;	/* Buffer size */
-	struct semaphore sem;	/* Semaphore for locking image */
+	struct mutex mutex;	/* Mutex for locking image */
 	struct device *device;	/* Sysfs device */
 	struct vme_resource *resource;	/* VME resource */
 	int users;		/* Number of current users */
@@ -168,7 +168,7 @@ static int vme_user_open(struct inode *inode, struct file *file)
 	int err;
 	unsigned int minor = MINOR(inode->i_rdev);
 
-	down(&image[minor].sem);
+	mutex_lock(&image[minor].mutex);
 	/* Allow device to be opened if a resource is needed and allocated. */
 	if (minor < CONTROL_MINOR && image[minor].resource == NULL) {
 		printk(KERN_ERR "No resources allocated for device\n");
@@ -179,12 +179,12 @@ static int vme_user_open(struct inode *inode, struct file *file)
 	/* Increment user count */
 	image[minor].users++;
 
-	up(&image[minor].sem);
+	mutex_unlock(&image[minor].mutex);
 
 	return 0;
 
 err_res:
-	up(&image[minor].sem);
+	mutex_unlock(&image[minor].mutex);
 
 	return err;
 }
@@ -193,12 +193,12 @@ static int vme_user_release(struct inode *inode, struct file *file)
 {
 	unsigned int minor = MINOR(inode->i_rdev);
 
-	down(&image[minor].sem);
+	mutex_lock(&image[minor].mutex);
 
 	/* Decrement user count */
 	image[minor].users--;
 
-	up(&image[minor].sem);
+	mutex_unlock(&image[minor].mutex);
 
 	return 0;
 }
@@ -325,14 +325,14 @@ static ssize_t vme_user_read(struct file *file, char __user *buf, size_t count,
 	if (minor == CONTROL_MINOR)
 		return 0;
 
-	down(&image[minor].sem);
+	mutex_lock(&image[minor].mutex);
 
 	/* XXX Do we *really* want this helper - we can use vme_*_get ? */
 	image_size = vme_get_size(image[minor].resource);
 
 	/* Ensure we are starting at a valid location */
 	if ((*ppos < 0) || (*ppos > (image_size - 1))) {
-		up(&image[minor].sem);
+		mutex_unlock(&image[minor].mutex);
 		return 0;
 	}
 
@@ -353,8 +353,7 @@ static ssize_t vme_user_read(struct file *file, char __user *buf, size_t count,
 		retval = -EINVAL;
 	}
 
-	up(&image[minor].sem);
-
+	mutex_unlock(&image[minor].mutex);
 	if (retval > 0)
 		*ppos += retval;
 
@@ -372,13 +371,13 @@ static ssize_t vme_user_write(struct file *file, const char __user *buf,
 	if (minor == CONTROL_MINOR)
 		return 0;
 
-	down(&image[minor].sem);
+	mutex_lock(&image[minor].mutex);
 
 	image_size = vme_get_size(image[minor].resource);
 
 	/* Ensure we are starting at a valid location */
 	if ((*ppos < 0) || (*ppos > (image_size - 1))) {
-		up(&image[minor].sem);
+		mutex_unlock(&image[minor].mutex);
 		return 0;
 	}
 
@@ -398,8 +397,8 @@ static ssize_t vme_user_write(struct file *file, const char __user *buf,
 	default:
 		retval = -EINVAL;
 	}
-
-	up(&image[minor].sem);
+	
+	mutex_unlock(&image[minor].mutex);
 
 	if (retval > 0)
 		*ppos += retval;
@@ -416,7 +415,7 @@ static loff_t vme_user_llseek(struct file *file, loff_t off, int whence)
 	if (minor == CONTROL_MINOR)
 		return -EINVAL;
 
-	down(&image[minor].sem);
+	mutex_lock(&image[minor].mutex);
 	image_size = vme_get_size(image[minor].resource);
 
 	switch (whence) {
@@ -430,19 +429,19 @@ static loff_t vme_user_llseek(struct file *file, loff_t off, int whence)
 		absolute = image_size + off;
 		break;
 	default:
-		up(&image[minor].sem);
+		mutex_unlock(&image[minor].mutex);
 		return -EINVAL;
 		break;
 	}
 
 	if ((absolute < 0) || (absolute >= image_size)) {
-		up(&image[minor].sem);
+		mutex_unlock(&image[minor].mutex);
 		return -EINVAL;
 	}
 
 	file->f_pos = absolute;
 
-	up(&image[minor].sem);
+	mutex_unlock(&image[minor].mutex);
 
 	return absolute;
 }
@@ -696,7 +695,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	for (i = 0; i < VME_DEVS; i++) {
 		image[i].kern_buf = NULL;
 		image[i].pci_buf = 0;
-		sema_init(&image[i].sem, 1);
+		mutex_init(&image[i].mutex);
 		image[i].device = NULL;
 		image[i].resource = NULL;
 		image[i].users = 0;
@@ -858,8 +857,10 @@ static int __devexit vme_user_remove(struct vme_dev *dev)
 	int i;
 
 	/* Remove sysfs Entries */
-	for (i = 0; i < VME_DEVS; i++)
+	for (i = 0; i < VME_DEVS; i++) {
+		mutex_destroy(&image[i].mutex);
 		device_destroy(vme_user_sysfs_class, MKDEV(VME_MAJOR, i));
+	}
 	class_destroy(vme_user_sysfs_class);
 
 	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++) {
-- 
1.7.4.4

