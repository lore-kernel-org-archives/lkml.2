Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183Ab2EIQUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:20:48 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:5463 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab2EIQUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:20:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1336580394!5016448!66
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] staging: comedi: refactor sysfs files in comedi_fops.c
Date: Wed, 9 May 2012 09:20:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205090920.09769.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the sysfs attributes and functions to remove
the need for the forward declarations and use the
DEVICE_ATTR macro to define them.

Instead of individually creating sysfs device attribute
files, wrap them in an attribute_group and use the
sysfs_create_group function to create them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

v2: fix a copy-paste error in comedi_alloc_subdevice_minor

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 06fc656..44ca1fe 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -129,15 +129,295 @@ static int do_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
 static int comedi_fasync(int fd, struct file *file, int on);
 
 static int is_device_busy(struct comedi_device *dev);
+
 static int resize_async_buffer(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
-			       struct comedi_async *async, unsigned new_size);
+			       struct comedi_async *async, unsigned new_size)
+{
+	int retval;
 
-/* declarations for sysfs attribute files */
-static struct device_attribute dev_attr_max_read_buffer_kb;
-static struct device_attribute dev_attr_read_buffer_kb;
-static struct device_attribute dev_attr_max_write_buffer_kb;
-static struct device_attribute dev_attr_write_buffer_kb;
+	if (new_size > async->max_bufsize)
+		return -EPERM;
+
+	if (s->busy) {
+		DPRINTK("subdevice is busy, cannot resize buffer\n");
+		return -EBUSY;
+	}
+	if (async->mmap_count) {
+		DPRINTK("subdevice is mmapped, cannot resize buffer\n");
+		return -EBUSY;
+	}
+
+	if (!async->prealloc_buf)
+		return -EINVAL;
+
+	/* make sure buffer is an integral number of pages
+	 * (we round up) */
+	new_size = (new_size + PAGE_SIZE - 1) & PAGE_MASK;
+
+	retval = comedi_buf_alloc(dev, s, new_size);
+	if (retval < 0)
+		return retval;
+
+	if (s->buf_change) {
+		retval = s->buf_change(dev, s, new_size);
+		if (retval < 0)
+			return retval;
+	}
+
+	DPRINTK("comedi%i subd %d buffer resized to %i bytes\n",
+		dev->minor, (int)(s - dev->subdevices), async->prealloc_bufsz);
+	return 0;
+}
+
+/* sysfs attribute files */
+
+static const unsigned bytes_per_kibi = 1024;
+
+static ssize_t show_max_read_buffer_kb(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	ssize_t retval;
+	struct comedi_device_file_info *info = dev_get_drvdata(dev);
+	unsigned max_buffer_size_kb = 0;
+	struct comedi_subdevice *const read_subdevice =
+	    comedi_get_read_subdevice(info);
+
+	mutex_lock(&info->device->mutex);
+	if (read_subdevice &&
+	    (read_subdevice->subdev_flags & SDF_CMD_READ) &&
+	    read_subdevice->async) {
+		max_buffer_size_kb = read_subdevice->async->max_bufsize /
+		    bytes_per_kibi;
+	}
+	retval = snprintf(buf, PAGE_SIZE, "%i\n", max_buffer_size_kb);
+	mutex_unlock(&info->device->mutex);
+
+	return retval;
+}
+
+static ssize_t store_max_read_buffer_kb(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct comedi_device_file_info *info = dev_get_drvdata(dev);
+	unsigned int new_max_size_kb;
+	unsigned int new_max_size;
+	int ret;
+	struct comedi_subdevice *const read_subdevice =
+	    comedi_get_read_subdevice(info);
+
+	ret = kstrtouint(buf, 10, &new_max_size_kb);
+	if (ret)
+		return ret;
+	if (new_max_size_kb > (UINT_MAX / bytes_per_kibi))
+		return -EINVAL;
+	new_max_size = new_max_size_kb * bytes_per_kibi;
+
+	mutex_lock(&info->device->mutex);
+	if (read_subdevice == NULL ||
+	    (read_subdevice->subdev_flags & SDF_CMD_READ) == 0 ||
+	    read_subdevice->async == NULL) {
+		mutex_unlock(&info->device->mutex);
+		return -EINVAL;
+	}
+	read_subdevice->async->max_bufsize = new_max_size;
+	mutex_unlock(&info->device->mutex);
+
+	return count;
+}
+
+static DEVICE_ATTR(max_read_buffer_kb, S_IRUGO | S_IWUSR,
+		show_max_read_buffer_kb, store_max_read_buffer_kb);
+
+static ssize_t show_read_buffer_kb(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	ssize_t retval;
+	struct comedi_device_file_info *info = dev_get_drvdata(dev);
+	unsigned buffer_size_kb = 0;
+	struct comedi_subdevice *const read_subdevice =
+	    comedi_get_read_subdevice(info);
+
+	mutex_lock(&info->device->mutex);
+	if (read_subdevice &&
+	    (read_subdevice->subdev_flags & SDF_CMD_READ) &&
+	    read_subdevice->async) {
+		buffer_size_kb = read_subdevice->async->prealloc_bufsz /
+		    bytes_per_kibi;
+	}
+	retval = snprintf(buf, PAGE_SIZE, "%i\n", buffer_size_kb);
+	mutex_unlock(&info->device->mutex);
+
+	return retval;
+}
+
+static ssize_t store_read_buffer_kb(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct comedi_device_file_info *info = dev_get_drvdata(dev);
+	unsigned int new_size_kb;
+	unsigned int new_size;
+	int retval;
+	int ret;
+	struct comedi_subdevice *const read_subdevice =
+	    comedi_get_read_subdevice(info);
+
+	ret = kstrtouint(buf, 10, &new_size_kb);
+	if (ret)
+		return ret;
+	if (new_size_kb > (UINT_MAX / bytes_per_kibi))
+		return -EINVAL;
+	new_size = new_size_kb * bytes_per_kibi;
+
+	mutex_lock(&info->device->mutex);
+	if (read_subdevice == NULL ||
+	    (read_subdevice->subdev_flags & SDF_CMD_READ) == 0 ||
+	    read_subdevice->async == NULL) {
+		mutex_unlock(&info->device->mutex);
+		return -EINVAL;
+	}
+	retval = resize_async_buffer(info->device, read_subdevice,
+				     read_subdevice->async, new_size);
+	mutex_unlock(&info->device->mutex);
+
+	if (retval < 0)
+		return retval;
+	return count;
+}
+
+static DEVICE_ATTR(read_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
+		show_read_buffer_kb, store_read_buffer_kb);
+
+static ssize_t show_max_write_buffer_kb(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	ssize_t retval;
+	struct comedi_device_file_info *info = dev_get_drvdata(dev);
+	unsigned max_buffer_size_kb = 0;
+	struct comedi_subdevice *const write_subdevice =
+	    comedi_get_write_subdevice(info);
+
+	mutex_lock(&info->device->mutex);
+	if (write_subdevice &&
+	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) &&
+	    write_subdevice->async) {
+		max_buffer_size_kb = write_subdevice->async->max_bufsize /
+		    bytes_per_kibi;
+	}
+	retval = snprintf(buf, PAGE_SIZE, "%i\n", max_buffer_size_kb);
+	mutex_unlock(&info->device->mutex);
+
+	return retval;
+}
+
+static ssize_t store_max_write_buffer_kb(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct comedi_device_file_info *info = dev_get_drvdata(dev);
+	unsigned int new_max_size_kb;
+	unsigned int new_max_size;
+	int ret;
+	struct comedi_subdevice *const write_subdevice =
+	    comedi_get_write_subdevice(info);
+
+	ret = kstrtouint(buf, 10, &new_max_size_kb);
+	if (ret)
+		return ret;
+	if (new_max_size_kb > (UINT_MAX / bytes_per_kibi))
+		return -EINVAL;
+	new_max_size = new_max_size_kb * bytes_per_kibi;
+
+	mutex_lock(&info->device->mutex);
+	if (write_subdevice == NULL ||
+	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) == 0 ||
+	    write_subdevice->async == NULL) {
+		mutex_unlock(&info->device->mutex);
+		return -EINVAL;
+	}
+	write_subdevice->async->max_bufsize = new_max_size;
+	mutex_unlock(&info->device->mutex);
+
+	return count;
+}
+
+static DEVICE_ATTR(max_write_buffer_kb, S_IRUGO | S_IWUSR,
+		show_max_write_buffer_kb, store_max_write_buffer_kb);
+
+static ssize_t show_write_buffer_kb(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	ssize_t retval;
+	struct comedi_device_file_info *info = dev_get_drvdata(dev);
+	unsigned buffer_size_kb = 0;
+	struct comedi_subdevice *const write_subdevice =
+	    comedi_get_write_subdevice(info);
+
+	mutex_lock(&info->device->mutex);
+	if (write_subdevice &&
+	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) &&
+	    write_subdevice->async) {
+		buffer_size_kb = write_subdevice->async->prealloc_bufsz /
+		    bytes_per_kibi;
+	}
+	retval = snprintf(buf, PAGE_SIZE, "%i\n", buffer_size_kb);
+	mutex_unlock(&info->device->mutex);
+
+	return retval;
+}
+
+static ssize_t store_write_buffer_kb(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct comedi_device_file_info *info = dev_get_drvdata(dev);
+	unsigned int new_size_kb;
+	unsigned int new_size;
+	int retval;
+	int ret;
+	struct comedi_subdevice *const write_subdevice =
+	    comedi_get_write_subdevice(info);
+
+	ret = kstrtouint(buf, 10, &new_size_kb);
+	if (ret)
+		return ret;
+	if (new_size_kb > (UINT_MAX / bytes_per_kibi))
+		return -EINVAL;
+	new_size = ((uint64_t) new_size_kb) * bytes_per_kibi;
+
+	mutex_lock(&info->device->mutex);
+	if (write_subdevice == NULL ||
+	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) == 0 ||
+	    write_subdevice->async == NULL) {
+		mutex_unlock(&info->device->mutex);
+		return -EINVAL;
+	}
+	retval = resize_async_buffer(info->device, write_subdevice,
+				     write_subdevice->async, new_size);
+	mutex_unlock(&info->device->mutex);
+
+	if (retval < 0)
+		return retval;
+	return count;
+}
+
+static DEVICE_ATTR(write_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
+		show_write_buffer_kb, store_write_buffer_kb);
+
+static struct attribute *comedi_attrs[] = {
+	&dev_attr_max_read_buffer_kb.attr,
+	&dev_attr_read_buffer_kb.attr,
+	&dev_attr_max_write_buffer_kb.attr,
+	&dev_attr_write_buffer_kb.attr,
+	NULL
+};
+
+static const struct attribute_group comedi_sysfs_files = {
+	.attrs	= comedi_attrs,
+};
 
 static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
 				  unsigned long arg)
@@ -2251,42 +2531,15 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 	if (!IS_ERR(csdev))
 		info->device->class_dev = csdev;
 	dev_set_drvdata(csdev, info);
-	retval = device_create_file(csdev, &dev_attr_max_read_buffer_kb);
+
+	retval = sysfs_create_group(&csdev->kobj, &comedi_sysfs_files);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: "
-		       "failed to create sysfs attribute file \"%s\".\n",
-		       dev_attr_max_read_buffer_kb.attr.name);
-		comedi_free_board_minor(i);
-		return retval;
-	}
-	retval = device_create_file(csdev, &dev_attr_read_buffer_kb);
-	if (retval) {
-		printk(KERN_ERR
-		       "comedi: "
-		       "failed to create sysfs attribute file \"%s\".\n",
-		       dev_attr_read_buffer_kb.attr.name);
-		comedi_free_board_minor(i);
-		return retval;
-	}
-	retval = device_create_file(csdev, &dev_attr_max_write_buffer_kb);
-	if (retval) {
-		printk(KERN_ERR
-		       "comedi: "
-		       "failed to create sysfs attribute file \"%s\".\n",
-		       dev_attr_max_write_buffer_kb.attr.name);
-		comedi_free_board_minor(i);
-		return retval;
-	}
-	retval = device_create_file(csdev, &dev_attr_write_buffer_kb);
-	if (retval) {
-		printk(KERN_ERR
-		       "comedi: "
-		       "failed to create sysfs attribute file \"%s\".\n",
-		       dev_attr_write_buffer_kb.attr.name);
+		       "comedi: failed to create sysfs attribute files\n");
 		comedi_free_board_minor(i);
 		return retval;
 	}
+
 	return i;
 }
 
@@ -2367,42 +2620,15 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 	if (!IS_ERR(csdev))
 		s->class_dev = csdev;
 	dev_set_drvdata(csdev, info);
-	retval = device_create_file(csdev, &dev_attr_max_read_buffer_kb);
+
+	retval = sysfs_create_group(&csdev->kobj, &comedi_sysfs_files);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: "
-		       "failed to create sysfs attribute file \"%s\".\n",
-		       dev_attr_max_read_buffer_kb.attr.name);
-		comedi_free_subdevice_minor(s);
-		return retval;
-	}
-	retval = device_create_file(csdev, &dev_attr_read_buffer_kb);
-	if (retval) {
-		printk(KERN_ERR
-		       "comedi: "
-		       "failed to create sysfs attribute file \"%s\".\n",
-		       dev_attr_read_buffer_kb.attr.name);
-		comedi_free_subdevice_minor(s);
-		return retval;
-	}
-	retval = device_create_file(csdev, &dev_attr_max_write_buffer_kb);
-	if (retval) {
-		printk(KERN_ERR
-		       "comedi: "
-		       "failed to create sysfs attribute file \"%s\".\n",
-		       dev_attr_max_write_buffer_kb.attr.name);
-		comedi_free_subdevice_minor(s);
-		return retval;
-	}
-	retval = device_create_file(csdev, &dev_attr_write_buffer_kb);
-	if (retval) {
-		printk(KERN_ERR
-		       "comedi: "
-		       "failed to create sysfs attribute file \"%s\".\n",
-		       dev_attr_write_buffer_kb.attr.name);
+		       "comedi: failed to create sysfs attribute files\n");
 		comedi_free_subdevice_minor(s);
 		return retval;
 	}
+
 	return i;
 }
 
@@ -2441,300 +2667,3 @@ struct comedi_device_file_info *comedi_get_device_file_info(unsigned minor)
 	return info;
 }
 EXPORT_SYMBOL_GPL(comedi_get_device_file_info);
-
-static int resize_async_buffer(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_async *async, unsigned new_size)
-{
-	int retval;
-
-	if (new_size > async->max_bufsize)
-		return -EPERM;
-
-	if (s->busy) {
-		DPRINTK("subdevice is busy, cannot resize buffer\n");
-		return -EBUSY;
-	}
-	if (async->mmap_count) {
-		DPRINTK("subdevice is mmapped, cannot resize buffer\n");
-		return -EBUSY;
-	}
-
-	if (!async->prealloc_buf)
-		return -EINVAL;
-
-	/* make sure buffer is an integral number of pages
-	 * (we round up) */
-	new_size = (new_size + PAGE_SIZE - 1) & PAGE_MASK;
-
-	retval = comedi_buf_alloc(dev, s, new_size);
-	if (retval < 0)
-		return retval;
-
-	if (s->buf_change) {
-		retval = s->buf_change(dev, s, new_size);
-		if (retval < 0)
-			return retval;
-	}
-
-	DPRINTK("comedi%i subd %d buffer resized to %i bytes\n",
-		dev->minor, (int)(s - dev->subdevices), async->prealloc_bufsz);
-	return 0;
-}
-
-/* sysfs attribute files */
-
-static const unsigned bytes_per_kibi = 1024;
-
-static ssize_t show_max_read_buffer_kb(struct device *dev,
-				       struct device_attribute *attr, char *buf)
-{
-	ssize_t retval;
-	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned max_buffer_size_kb = 0;
-	struct comedi_subdevice *const read_subdevice =
-	    comedi_get_read_subdevice(info);
-
-	mutex_lock(&info->device->mutex);
-	if (read_subdevice &&
-	    (read_subdevice->subdev_flags & SDF_CMD_READ) &&
-	    read_subdevice->async) {
-		max_buffer_size_kb = read_subdevice->async->max_bufsize /
-		    bytes_per_kibi;
-	}
-	retval = snprintf(buf, PAGE_SIZE, "%i\n", max_buffer_size_kb);
-	mutex_unlock(&info->device->mutex);
-
-	return retval;
-}
-
-static ssize_t store_max_read_buffer_kb(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t count)
-{
-	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned int new_max_size_kb;
-	unsigned int new_max_size;
-	int ret;
-	struct comedi_subdevice *const read_subdevice =
-	    comedi_get_read_subdevice(info);
-
-	ret = kstrtouint(buf, 10, &new_max_size_kb);
-	if (ret)
-		return ret;
-	if (new_max_size_kb > (UINT_MAX / bytes_per_kibi))
-		return -EINVAL;
-	new_max_size = new_max_size_kb * bytes_per_kibi;
-
-	mutex_lock(&info->device->mutex);
-	if (read_subdevice == NULL ||
-	    (read_subdevice->subdev_flags & SDF_CMD_READ) == 0 ||
-	    read_subdevice->async == NULL) {
-		mutex_unlock(&info->device->mutex);
-		return -EINVAL;
-	}
-	read_subdevice->async->max_bufsize = new_max_size;
-	mutex_unlock(&info->device->mutex);
-
-	return count;
-}
-
-static struct device_attribute dev_attr_max_read_buffer_kb = {
-	.attr = {
-		 .name = "max_read_buffer_kb",
-		 .mode = S_IRUGO | S_IWUSR},
-	.show = &show_max_read_buffer_kb,
-	.store = &store_max_read_buffer_kb
-};
-
-static ssize_t show_read_buffer_kb(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	ssize_t retval;
-	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned buffer_size_kb = 0;
-	struct comedi_subdevice *const read_subdevice =
-	    comedi_get_read_subdevice(info);
-
-	mutex_lock(&info->device->mutex);
-	if (read_subdevice &&
-	    (read_subdevice->subdev_flags & SDF_CMD_READ) &&
-	    read_subdevice->async) {
-		buffer_size_kb = read_subdevice->async->prealloc_bufsz /
-		    bytes_per_kibi;
-	}
-	retval = snprintf(buf, PAGE_SIZE, "%i\n", buffer_size_kb);
-	mutex_unlock(&info->device->mutex);
-
-	return retval;
-}
-
-static ssize_t store_read_buffer_kb(struct device *dev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t count)
-{
-	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned int new_size_kb;
-	unsigned int new_size;
-	int retval;
-	int ret;
-	struct comedi_subdevice *const read_subdevice =
-	    comedi_get_read_subdevice(info);
-
-	ret = kstrtouint(buf, 10, &new_size_kb);
-	if (ret)
-		return ret;
-	if (new_size_kb > (UINT_MAX / bytes_per_kibi))
-		return -EINVAL;
-	new_size = new_size_kb * bytes_per_kibi;
-
-	mutex_lock(&info->device->mutex);
-	if (read_subdevice == NULL ||
-	    (read_subdevice->subdev_flags & SDF_CMD_READ) == 0 ||
-	    read_subdevice->async == NULL) {
-		mutex_unlock(&info->device->mutex);
-		return -EINVAL;
-	}
-	retval = resize_async_buffer(info->device, read_subdevice,
-				     read_subdevice->async, new_size);
-	mutex_unlock(&info->device->mutex);
-
-	if (retval < 0)
-		return retval;
-	return count;
-}
-
-static struct device_attribute dev_attr_read_buffer_kb = {
-	.attr = {
-		 .name = "read_buffer_kb",
-		 .mode = S_IRUGO | S_IWUSR | S_IWGRP},
-	.show = &show_read_buffer_kb,
-	.store = &store_read_buffer_kb
-};
-
-static ssize_t show_max_write_buffer_kb(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	ssize_t retval;
-	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned max_buffer_size_kb = 0;
-	struct comedi_subdevice *const write_subdevice =
-	    comedi_get_write_subdevice(info);
-
-	mutex_lock(&info->device->mutex);
-	if (write_subdevice &&
-	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) &&
-	    write_subdevice->async) {
-		max_buffer_size_kb = write_subdevice->async->max_bufsize /
-		    bytes_per_kibi;
-	}
-	retval = snprintf(buf, PAGE_SIZE, "%i\n", max_buffer_size_kb);
-	mutex_unlock(&info->device->mutex);
-
-	return retval;
-}
-
-static ssize_t store_max_write_buffer_kb(struct device *dev,
-					 struct device_attribute *attr,
-					 const char *buf, size_t count)
-{
-	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned int new_max_size_kb;
-	unsigned int new_max_size;
-	int ret;
-	struct comedi_subdevice *const write_subdevice =
-	    comedi_get_write_subdevice(info);
-
-	ret = kstrtouint(buf, 10, &new_max_size_kb);
-	if (ret)
-		return ret;
-	if (new_max_size_kb > (UINT_MAX / bytes_per_kibi))
-		return -EINVAL;
-	new_max_size = new_max_size_kb * bytes_per_kibi;
-
-	mutex_lock(&info->device->mutex);
-	if (write_subdevice == NULL ||
-	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) == 0 ||
-	    write_subdevice->async == NULL) {
-		mutex_unlock(&info->device->mutex);
-		return -EINVAL;
-	}
-	write_subdevice->async->max_bufsize = new_max_size;
-	mutex_unlock(&info->device->mutex);
-
-	return count;
-}
-
-static struct device_attribute dev_attr_max_write_buffer_kb = {
-	.attr = {
-		 .name = "max_write_buffer_kb",
-		 .mode = S_IRUGO | S_IWUSR},
-	.show = &show_max_write_buffer_kb,
-	.store = &store_max_write_buffer_kb
-};
-
-static ssize_t show_write_buffer_kb(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	ssize_t retval;
-	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned buffer_size_kb = 0;
-	struct comedi_subdevice *const write_subdevice =
-	    comedi_get_write_subdevice(info);
-
-	mutex_lock(&info->device->mutex);
-	if (write_subdevice &&
-	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) &&
-	    write_subdevice->async) {
-		buffer_size_kb = write_subdevice->async->prealloc_bufsz /
-		    bytes_per_kibi;
-	}
-	retval = snprintf(buf, PAGE_SIZE, "%i\n", buffer_size_kb);
-	mutex_unlock(&info->device->mutex);
-
-	return retval;
-}
-
-static ssize_t store_write_buffer_kb(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned int new_size_kb;
-	unsigned int new_size;
-	int retval;
-	int ret;
-	struct comedi_subdevice *const write_subdevice =
-	    comedi_get_write_subdevice(info);
-
-	ret = kstrtouint(buf, 10, &new_size_kb);
-	if (ret)
-		return ret;
-	if (new_size_kb > (UINT_MAX / bytes_per_kibi))
-		return -EINVAL;
-	new_size = ((uint64_t) new_size_kb) * bytes_per_kibi;
-
-	mutex_lock(&info->device->mutex);
-	if (write_subdevice == NULL ||
-	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) == 0 ||
-	    write_subdevice->async == NULL) {
-		mutex_unlock(&info->device->mutex);
-		return -EINVAL;
-	}
-	retval = resize_async_buffer(info->device, write_subdevice,
-				     write_subdevice->async, new_size);
-	mutex_unlock(&info->device->mutex);
-
-	if (retval < 0)
-		return retval;
-	return count;
-}
-
-static struct device_attribute dev_attr_write_buffer_kb = {
-	.attr = {
-		 .name = "write_buffer_kb",
-		 .mode = S_IRUGO | S_IWUSR | S_IWGRP},
-	.show = &show_write_buffer_kb,
-	.store = &store_write_buffer_kb
-};
