Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2IKHQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 03:16:27 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56038 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2IKHQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 03:16:25 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Manohar Vanga <manohar.vanga@gmail.com>,
        linux-kernel@vger.kernel.org, Martyn Welch <martyn.welch@ge.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 1/2] staging/vme: Use pr_ printks in vme_user.c
Date: Tue, 11 Sep 2012 16:16:14 +0900
Message-Id: <1347347775-9282-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120904202053.GA23449@kroah.com>
References: <20120904202053.GA23449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warnings was fixed,

-WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
-WARNING: Prefer pr_warn(... to printk(KERN_WARNING, ...
-WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

and added pr_fmt.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |   37 ++++++++++++++------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 0170788..1e3311d 100644
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
@@ -629,11 +631,10 @@ static int __init vme_user_init(void)
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
@@ -642,8 +643,8 @@ static int __init vme_user_init(void)
 	 * in future revisions if that ever becomes necessary.
 	 */
 	if (bus_num > VME_USER_BUS_MAX) {
-		printk(KERN_ERR "%s: Driver only able to handle %d buses\n",
-			driver_name, VME_USER_BUS_MAX);
+		pr_err("Driver only able to handle %d buses\n",
+		       VME_USER_BUS_MAX);
 		bus_num = VME_USER_BUS_MAX;
 	}
 
@@ -683,8 +684,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 
 	/* Save pointer to the bridge device */
 	if (vme_user_bridge != NULL) {
-		printk(KERN_ERR "%s: Driver can only be loaded for 1 device\n",
-			driver_name);
+		pr_err("Driver can only be loaded for 1 device\n");
 		err = -EINVAL;
 		goto err_dev;
 	}
@@ -707,8 +707,8 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	err = register_chrdev_region(MKDEV(VME_MAJOR, 0), VME_DEVS,
 		driver_name);
 	if (err) {
-		printk(KERN_WARNING "%s: Error getting Major Number %d for "
-		"driver.\n", driver_name, VME_MAJOR);
+		pr_warn("Error getting Major Number %d for driver.\n",
+			VME_MAJOR);
 		goto err_region;
 	}
 
@@ -718,7 +718,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	vme_user_cdev->owner = THIS_MODULE;
 	err = cdev_add(vme_user_cdev, MKDEV(VME_MAJOR, 0), VME_DEVS);
 	if (err) {
-		printk(KERN_WARNING "%s: cdev_all failed\n", driver_name);
+		pr_warn("cdev_all failed\n");
 		goto err_char;
 	}
 
@@ -732,16 +732,14 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 		image[i].resource = vme_slave_request(vme_user_bridge,
 			VME_A24, VME_SCT);
 		if (image[i].resource == NULL) {
-			printk(KERN_WARNING "Unable to allocate slave "
-				"resource\n");
+			pr_warn("Unable to allocate slave resource\n");
 			goto err_slave;
 		}
 		image[i].size_buf = PCI_BUF_SIZE;
 		image[i].kern_buf = vme_alloc_consistent(image[i].resource,
 			image[i].size_buf, &image[i].pci_buf);
 		if (image[i].kern_buf == NULL) {
-			printk(KERN_WARNING "Unable to allocate memory for "
-				"buffer\n");
+			pr_warn("Unable to allocate memory for buffer\n");
 			image[i].pci_buf = 0;
 			vme_slave_free(image[i].resource);
 			err = -ENOMEM;
@@ -758,15 +756,13 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 		image[i].resource = vme_master_request(vme_user_bridge,
 			VME_A32, VME_SCT, VME_D32);
 		if (image[i].resource == NULL) {
-			printk(KERN_WARNING "Unable to allocate master "
-				"resource\n");
+			pr_warn("Unable to allocate master resource\n");
 			goto err_master;
 		}
 		image[i].size_buf = PCI_BUF_SIZE;
 		image[i].kern_buf = kmalloc(image[i].size_buf, GFP_KERNEL);
 		if (image[i].kern_buf == NULL) {
-			printk(KERN_WARNING "Unable to allocate memory for "
-				"master window buffers\n");
+			pr_warn("Unable to allocate memory for master window buffers\n");
 			err = -ENOMEM;
 			goto err_master_buf;
 		}
@@ -775,7 +771,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 	/* Create sysfs entries - on udev systems this creates the dev files */
 	vme_user_sysfs_class = class_create(THIS_MODULE, driver_name);
 	if (IS_ERR(vme_user_sysfs_class)) {
-		printk(KERN_ERR "Error creating vme_user class.\n");
+		pr_err("Error creating vme_user class.\n");
 		err = PTR_ERR(vme_user_sysfs_class);
 		goto err_class;
 	}
@@ -803,8 +799,7 @@ static int __devinit vme_user_probe(struct vme_dev *vdev)
 		image[i].device = device_create(vme_user_sysfs_class, NULL,
 					MKDEV(VME_MAJOR, i), NULL, name, num);
 		if (IS_ERR(image[i].device)) {
-			printk(KERN_INFO "%s: Error creating sysfs device\n",
-				driver_name);
+			pr_info("Error creating sysfs device\n");
 			err = PTR_ERR(image[i].device);
 			goto err_sysfs;
 		}
-- 
1.7.9.5

