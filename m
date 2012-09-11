Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab2IKHRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 03:17:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48656 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2IKHRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 03:17:11 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Manohar Vanga <manohar.vanga@gmail.com>,
        linux-kernel@vger.kernel.org, Martyn Welch <martyn.welch@ge.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 2/2] staging/vme: Use dev_ printks in vme_user.c
Date: Tue, 11 Sep 2012 16:17:03 +0900
Message-Id: <1347347823-9316-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347347775-9282-1-git-send-email-yamanetoshi@gmail.com>
References: <1347347775-9282-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warnings was fixed,

-WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
-WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...
-WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
-WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 1e3311d..206c37b 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -172,7 +172,7 @@ static int vme_user_open(struct inode *inode, struct file *file)
 	mutex_lock(&image[minor].mutex);
 	/* Allow device to be opened if a resource is needed and allocated. */
 	if (minor < CONTROL_MINOR && image[minor].resource == NULL) {
-		printk(KERN_ERR "No resources allocated for device\n");
+		dev_err(image[minor].device, "No resources allocated for device\n");
 		err = -EINVAL;
 		goto err_res;
 	}
@@ -227,13 +227,13 @@ static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
 			(unsigned long)copied);
 		if (retval != 0) {
 			copied = (copied - retval);
-			printk(KERN_INFO "User copy failed\n");
+			dev_info(image[minor].device, "User copy failed\n");
 			return -EINVAL;
 		}
 
 	} else {
 		/* XXX Need to write this */
-		printk(KERN_INFO "Currently don't support large transfers\n");
+		dev_info(image[minor].device, "Currently don't support large transfers\n");
 		/* Map in pages from userspace */
 
 		/* Call vme_master_read to do the transfer */
@@ -267,7 +267,7 @@ static ssize_t resource_from_user(unsigned int minor, const char __user *buf,
 			image[minor].kern_buf, copied, *ppos);
 	} else {
 		/* XXX Need to write this */
-		printk(KERN_INFO "Currently don't support large transfers\n");
+		dev_info(image[minor].device, "Currently don't support large transfers\n");
 		/* Map in pages from userspace */
 
 		/* Call vme_master_write to do the transfer */
@@ -288,7 +288,7 @@ static ssize_t buffer_to_user(unsigned int minor, char __user *buf,
 	retval = __copy_to_user(buf, image_ptr, (unsigned long)count);
 	if (retval != 0) {
 		retval = (count - retval);
-		printk(KERN_WARNING "Partial copy to userspace\n");
+		dev_warn(image[minor].device, "Partial copy to userspace\n");
 	} else
 		retval = count;
 
@@ -307,7 +307,7 @@ static ssize_t buffer_from_user(unsigned int minor, const char __user *buf,
 	retval = __copy_from_user(image_ptr, buf, (unsigned long)count);
 	if (retval != 0) {
 		retval = (count - retval);
-		printk(KERN_WARNING "Partial copy to userspace\n");
+		dev_warn(image[minor].device, "Partial copy to userspace\n");
 	} else
 		retval = count;
 
@@ -478,7 +478,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_from_user(&irq_req, argp,
 						sizeof(struct vme_irq_id));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from userspace\n");
+				dev_warn(image[minor].device, "Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -505,8 +505,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_to_user(argp, &master,
 				sizeof(struct vme_master));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy to "
-					"userspace\n");
+				dev_warn(image[minor].device, "Partial copy to userspace\n");
 				return -EFAULT;
 			}
 
@@ -517,8 +516,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 			copied = copy_from_user(&master, argp, sizeof(master));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from "
-					"userspace\n");
+				dev_warn(image[minor].device, "Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -548,8 +546,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_to_user(argp, &slave,
 				sizeof(struct vme_slave));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy to "
-					"userspace\n");
+				dev_warn(image[minor].device, "Partial copy to userspace\n");
 				return -EFAULT;
 			}
 
@@ -560,8 +557,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 			copied = copy_from_user(&slave, argp, sizeof(slave));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from "
-					"userspace\n");
+				dev_warn(image[minor].device, "Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -601,8 +597,8 @@ static void buf_unalloc(int num)
 {
 	if (image[num].kern_buf) {
 #ifdef VME_DEBUG
-		printk(KERN_DEBUG "UniverseII:Releasing buffer at %p\n",
-			image[num].pci_buf);
+		dev_debug(image[num].device, "UniverseII:Releasing buffer at %p\n",
+			  image[num].pci_buf);
 #endif
 
 		vme_free_consistent(image[num].resource, image[num].size_buf,
@@ -614,7 +610,7 @@ static void buf_unalloc(int num)
 
 #ifdef VME_DEBUG
 	} else {
-		printk(KERN_DEBUG "UniverseII: Buffer not allocated\n");
+		dev_debug(image[num].device, "UniverseII: Buffer not allocated\n");
 #endif
 	}
 }
-- 
1.7.9.5

