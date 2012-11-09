Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab2KIDXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 22:23:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40102 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab2KIDXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 22:23:21 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/vme: Use dev_ or pr_ printks in devices/vme_user.c
Date: Fri,  9 Nov 2012 12:23:14 +0900
Message-Id: <1352431394-2594-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |   73 +++++++++++++++-----------------
 1 file changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index c3f94f3..e3731eb 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -15,6 +15,8 @@
  * option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -170,7 +172,7 @@ static int vme_user_open(struct inode *inode, struct file *file)
 	mutex_lock(&image[minor].mutex);
 	/* Allow device to be opened if a resource is needed and allocated. */
 	if (minor < CONTROL_MINOR && image[minor].resource == NULL) {
-		printk(KERN_ERR "No resources allocated for device\n");
+		pr_err("No resources allocated for device\n");
 		err = -EINVAL;
 		goto err_res;
 	}
@@ -225,13 +227,13 @@ static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
 			(unsigned long)copied);
 		if (retval != 0) {
 			copied = (copied - retval);
-			printk(KERN_INFO "User copy failed\n");
+			pr_info("User copy failed\n");
 			return -EINVAL;
 		}
 
 	} else {
 		/* XXX Need to write this */
-		printk(KERN_INFO "Currently don't support large transfers\n");
+		pr_info("Currently don't support large transfers\n");
 		/* Map in pages from userspace */
 
 		/* Call vme_master_read to do the transfer */
@@ -265,7 +267,7 @@ static ssize_t resource_from_user(unsigned int minor, const char __user *buf,
 			image[minor].kern_buf, copied, *ppos);
 	} else {
 		/* XXX Need to write this */
-		printk(KERN_INFO "Currently don't support large transfers\n");
+		pr_info("Currently don't support large transfers\n");
 		/* Map in pages from userspace */
 
 		/* Call vme_master_write to do the transfer */
@@ -286,7 +288,7 @@ static ssize_t buffer_to_user(unsigned int minor, char __user *buf,
 	retval = __copy_to_user(buf, image_ptr, (unsigned long)count);
 	if (retval != 0) {
 		retval = (count - retval);
-		printk(KERN_WARNING "Partial copy to userspace\n");
+		pr_warn("Partial copy to userspace\n");
 	} else
 		retval = count;
 
@@ -305,7 +307,7 @@ static ssize_t buffer_from_user(unsigned int minor, const char __user *buf,
 	retval = __copy_from_user(image_ptr, buf, (unsigned long)count);
 	if (retval != 0) {
 		retval = (count - retval);
-		printk(KERN_WARNING "Partial copy to userspace\n");
+		pr_warn("Partial copy to userspace\n");
 	} else
 		retval = count;
 
@@ -476,7 +478,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_from_user(&irq_req, argp,
 						sizeof(struct vme_irq_id));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from userspace\n");
+				pr_warn("Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -503,8 +505,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_to_user(argp, &master,
 				sizeof(struct vme_master));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy to "
-					"userspace\n");
+				pr_warn("Partial copy to userspace\n");
 				return -EFAULT;
 			}
 
@@ -515,8 +516,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 			copied = copy_from_user(&master, argp, sizeof(master));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from "
-					"userspace\n");
+				pr_warn("Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -546,8 +546,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			copied = copy_to_user(argp, &slave,
 				sizeof(struct vme_slave));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy to "
-					"userspace\n");
+				pr_warn("Partial copy to userspace\n");
 				return -EFAULT;
 			}
 
@@ -558,8 +557,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 
 			copied = copy_from_user(&slave, argp, sizeof(slave));
 			if (copied != 0) {
-				printk(KERN_WARNING "Partial copy from "
-					"userspace\n");
+				pr_warn("Partial copy from userspace\n");
 				return -EFAULT;
 			}
 
@@ -599,8 +597,8 @@ static void buf_unalloc(int num)
 {
 	if (image[num].kern_buf) {
 #ifdef VME_DEBUG
-		printk(KERN_DEBUG "UniverseII:Releasing buffer at %p\n",
-			image[num].pci_buf);
+		pr_debug("UniverseII:Releasing buffer at %p\n",
+			 image[num].pci_buf);
 #endif
 
 		vme_free_consistent(image[num].resource, image[num].size_buf,
@@ -612,7 +610,7 @@ static void buf_unalloc(int num)
 
 #ifdef VME_DEBUG
 	} else {
-		printk(KERN_DEBUG "UniverseII: Buffer not allocated\n");
+		pr_debug("UniverseII: Buffer not allocated\n");
 #endif
 	}
 }
@@ -629,11 +627,10 @@ static int __init vme_user_init(void)
 {
 	int retval = 0;
 
-	printk(KERN_INFO "VME User Space Access Driver\n");
+	pr_info("VME User Space Access Driver\n");
 
 	if (bus_num == 0) {
-		printk(KERN_ERR "%s: No cards, skipping registration\n",
-			driver_name);
+		pr_err("No cards, skipping registration\n");
 		retval = -ENODEV;
 		goto err_nocard;
 	}
@@ -642,8 +639,8 @@ static int __init vme_user_init(void)
 	 * in future revisions if that ever becomes necessary.
 	 */
 	if (bus_num > VME_USER_BUS_MAX) {
-		printk(KERN_ERR "%s: Driver only able to handle %d buses\n",
-			driver_name, VME_USER_BUS_MAX);
+		pr_err("Driver only able to handle %d buses\n",
+		       VME_USER_BUS_MAX);
 		bus_num = VME_USER_BUS_MAX;
 	}
 
@@ -683,8 +680,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 
 	/* Save pointer to the bridge device */
 	if (vme_user_bridge != NULL) {
-		printk(KERN_ERR "%s: Driver can only be loaded for 1 device\n",
-			driver_name);
+		dev_err(&vdev->dev, "Driver can only be loaded for 1 device\n");
 		err = -EINVAL;
 		goto err_dev;
 	}
@@ -707,8 +703,8 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	err = register_chrdev_region(MKDEV(VME_MAJOR, 0), VME_DEVS,
 		driver_name);
 	if (err) {
-		printk(KERN_WARNING "%s: Error getting Major Number %d for "
-		"driver.\n", driver_name, VME_MAJOR);
+		dev_warn(&vdev->dev, "Error getting Major Number %d for driver.\n",
+			 VME_MAJOR);
 		goto err_region;
 	}
 
@@ -718,7 +714,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	vme_user_cdev->owner = THIS_MODULE;
 	err = cdev_add(vme_user_cdev, MKDEV(VME_MAJOR, 0), VME_DEVS);
 	if (err) {
-		printk(KERN_WARNING "%s: cdev_all failed\n", driver_name);
+		dev_warn(&vdev->dev, "cdev_all failed\n");
 		goto err_char;
 	}
 
@@ -732,16 +728,16 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 		image[i].resource = vme_slave_request(vme_user_bridge,
 			VME_A24, VME_SCT);
 		if (image[i].resource == NULL) {
-			printk(KERN_WARNING "Unable to allocate slave "
-				"resource\n");
+			dev_warn(&vdev->dev,
+				 "Unable to allocate slave resource\n");
 			goto err_slave;
 		}
 		image[i].size_buf = PCI_BUF_SIZE;
 		image[i].kern_buf = vme_alloc_consistent(image[i].resource,
 			image[i].size_buf, &image[i].pci_buf);
 		if (image[i].kern_buf == NULL) {
-			printk(KERN_WARNING "Unable to allocate memory for "
-				"buffer\n");
+			dev_warn(&vdev->dev,
+				 "Unable to allocate memory for buffer\n");
 			image[i].pci_buf = 0;
 			vme_slave_free(image[i].resource);
 			err = -ENOMEM;
@@ -758,15 +754,15 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 		image[i].resource = vme_master_request(vme_user_bridge,
 			VME_A32, VME_SCT, VME_D32);
 		if (image[i].resource == NULL) {
-			printk(KERN_WARNING "Unable to allocate master "
-				"resource\n");
+			dev_warn(&vdev->dev,
+				 "Unable to allocate master resource\n");
 			goto err_master;
 		}
 		image[i].size_buf = PCI_BUF_SIZE;
 		image[i].kern_buf = kmalloc(image[i].size_buf, GFP_KERNEL);
 		if (image[i].kern_buf == NULL) {
-			printk(KERN_WARNING "Unable to allocate memory for "
-				"master window buffers\n");
+			dev_warn(&vdev->dev,
+				 "Unable to allocate memory for master window buffers\n");
 			err = -ENOMEM;
 			goto err_master_buf;
 		}
@@ -775,7 +771,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	/* Create sysfs entries - on udev systems this creates the dev files */
 	vme_user_sysfs_class = class_create(THIS_MODULE, driver_name);
 	if (IS_ERR(vme_user_sysfs_class)) {
-		printk(KERN_ERR "Error creating vme_user class.\n");
+		dev_err(&vdev->dev, "Error creating vme_user class.\n");
 		err = PTR_ERR(vme_user_sysfs_class);
 		goto err_class;
 	}
@@ -803,8 +799,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 		image[i].device = device_create(vme_user_sysfs_class, NULL,
 					MKDEV(VME_MAJOR, i), NULL, name, num);
 		if (IS_ERR(image[i].device)) {
-			printk(KERN_INFO "%s: Error creating sysfs device\n",
-				driver_name);
+			dev_info(&vdev->dev, "Error creating sysfs device\n");
 			err = PTR_ERR(image[i].device);
 			goto err_sysfs;
 		}
-- 
1.7.9.5

