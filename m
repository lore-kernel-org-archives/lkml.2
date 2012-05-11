Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab2EKBFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 21:05:47 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:32202 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2EKBFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 21:05:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1336698345!4826074!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: register sysfs device attributes with driver core
Date: Thu, 10 May 2012 18:05:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205101805.28589.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the sysfs device attributes are created by the comedi
core after each comedi device is created. This can lead to a race
condition where userspace gets an add event before the files are
created.

Register the device attributes with the comedi class so that the
driver core handles creating them and we avoid the race.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 44ca1fe..7677657 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -227,9 +227,6 @@ static ssize_t store_max_read_buffer_kb(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(max_read_buffer_kb, S_IRUGO | S_IWUSR,
-		show_max_read_buffer_kb, store_max_read_buffer_kb);
-
 static ssize_t show_read_buffer_kb(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -287,9 +284,6 @@ static ssize_t store_read_buffer_kb(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(read_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
-		show_read_buffer_kb, store_read_buffer_kb);
-
 static ssize_t show_max_write_buffer_kb(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
@@ -344,9 +338,6 @@ static ssize_t store_max_write_buffer_kb(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(max_write_buffer_kb, S_IRUGO | S_IWUSR,
-		show_max_write_buffer_kb, store_max_write_buffer_kb);
-
 static ssize_t show_write_buffer_kb(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
@@ -404,19 +395,16 @@ static ssize_t store_write_buffer_kb(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(write_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
-		show_write_buffer_kb, store_write_buffer_kb);
-
-static struct attribute *comedi_attrs[] = {
-	&dev_attr_max_read_buffer_kb.attr,
-	&dev_attr_read_buffer_kb.attr,
-	&dev_attr_max_write_buffer_kb.attr,
-	&dev_attr_write_buffer_kb.attr,
-	NULL
-};
-
-static const struct attribute_group comedi_sysfs_files = {
-	.attrs	= comedi_attrs,
+static struct device_attribute comedi_dev_attrs[] = {
+	__ATTR(max_read_buffer_kb, S_IRUGO | S_IWUSR,
+		show_max_read_buffer_kb, store_max_read_buffer_kb),
+	__ATTR(read_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
+		show_read_buffer_kb, store_read_buffer_kb),
+	__ATTR(max_write_buffer_kb, S_IRUGO | S_IWUSR,
+		show_max_write_buffer_kb, store_max_write_buffer_kb),
+	__ATTR(write_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
+		show_write_buffer_kb, store_write_buffer_kb),
+	__ATTR_NULL
 };
 
 static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
@@ -2355,6 +2343,8 @@ static int __init comedi_init(void)
 		return PTR_ERR(comedi_class);
 	}
 
+	comedi_class->dev_attrs = comedi_dev_attrs;
+
 	/* XXX requires /proc interface */
 	comedi_proc_init();
 
@@ -2496,7 +2486,6 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 	struct comedi_device_file_info *info;
 	struct device *csdev;
 	unsigned i;
-	int retval;
 
 	info = kzalloc(sizeof(struct comedi_device_file_info), GFP_KERNEL);
 	if (info == NULL)
@@ -2532,14 +2521,6 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 		info->device->class_dev = csdev;
 	dev_set_drvdata(csdev, info);
 
-	retval = sysfs_create_group(&csdev->kobj, &comedi_sysfs_files);
-	if (retval) {
-		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute files\n");
-		comedi_free_board_minor(i);
-		return retval;
-	}
-
 	return i;
 }
 
@@ -2590,7 +2571,6 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 	struct comedi_device_file_info *info;
 	struct device *csdev;
 	unsigned i;
-	int retval;
 
 	info = kmalloc(sizeof(struct comedi_device_file_info), GFP_KERNEL);
 	if (info == NULL)
@@ -2621,14 +2601,6 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 		s->class_dev = csdev;
 	dev_set_drvdata(csdev, info);
 
-	retval = sysfs_create_group(&csdev->kobj, &comedi_sysfs_files);
-	if (retval) {
-		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute files\n");
-		comedi_free_subdevice_minor(s);
-		return retval;
-	}
-
 	return i;
 }
 
