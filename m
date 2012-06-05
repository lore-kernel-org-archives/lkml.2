Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab2FERS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:18:28 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:32117 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2FERS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:18:27 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1338916645!24525859!40
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: cleanup sysfs functions
Date: Tue, 5 Jun 2012 10:18:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206051018.02735.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the comedi sysfs functions a bit more concise by shortening
some of the verbose variable names and reusing some of the
variables that were used for intermediate calculations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/comedi_fops.c |  202 ++++++++++++----------------------
 1 files changed, 72 insertions(+), 130 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 7677657..b3b86d4 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -172,28 +172,19 @@ static int resize_async_buffer(struct comedi_device *dev,
 
 /* sysfs attribute files */
 
-static const unsigned bytes_per_kibi = 1024;
-
 static ssize_t show_max_read_buffer_kb(struct device *dev,
 				       struct device_attribute *attr, char *buf)
 {
-	ssize_t retval;
 	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned max_buffer_size_kb = 0;
-	struct comedi_subdevice *const read_subdevice =
-	    comedi_get_read_subdevice(info);
+	struct comedi_subdevice *s = comedi_get_read_subdevice(info);
+	unsigned int size = 0;
 
 	mutex_lock(&info->device->mutex);
-	if (read_subdevice &&
-	    (read_subdevice->subdev_flags & SDF_CMD_READ) &&
-	    read_subdevice->async) {
-		max_buffer_size_kb = read_subdevice->async->max_bufsize /
-		    bytes_per_kibi;
-	}
-	retval = snprintf(buf, PAGE_SIZE, "%i\n", max_buffer_size_kb);
+	if (s && (s->subdev_flags & SDF_CMD_READ) && s->async)
+		size = s->async->max_bufsize / 1024;
 	mutex_unlock(&info->device->mutex);
 
-	return retval;
+	return snprintf(buf, PAGE_SIZE, "%i\n", size);
 }
 
 static ssize_t store_max_read_buffer_kb(struct device *dev,
@@ -201,52 +192,40 @@ static ssize_t store_max_read_buffer_kb(struct device *dev,
 					const char *buf, size_t count)
 {
 	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned int new_max_size_kb;
-	unsigned int new_max_size;
-	int ret;
-	struct comedi_subdevice *const read_subdevice =
-	    comedi_get_read_subdevice(info);
+	struct comedi_subdevice *s = comedi_get_read_subdevice(info);
+	unsigned int size;
+	int err;
 
-	ret = kstrtouint(buf, 10, &new_max_size_kb);
-	if (ret)
-		return ret;
-	if (new_max_size_kb > (UINT_MAX / bytes_per_kibi))
+	err = kstrtouint(buf, 10, &size);
+	if (err)
+		return err;
+	if (size > (UINT_MAX / 1024))
 		return -EINVAL;
-	new_max_size = new_max_size_kb * bytes_per_kibi;
+	size *= 1024;
 
 	mutex_lock(&info->device->mutex);
-	if (read_subdevice == NULL ||
-	    (read_subdevice->subdev_flags & SDF_CMD_READ) == 0 ||
-	    read_subdevice->async == NULL) {
-		mutex_unlock(&info->device->mutex);
-		return -EINVAL;
-	}
-	read_subdevice->async->max_bufsize = new_max_size;
+	if (s && (s->subdev_flags & SDF_CMD_READ) && s->async)
+		s->async->max_bufsize = size;
+	else
+		err = -EINVAL;
 	mutex_unlock(&info->device->mutex);
 
-	return count;
+	return err ? err : count;
 }
 
 static ssize_t show_read_buffer_kb(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	ssize_t retval;
 	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned buffer_size_kb = 0;
-	struct comedi_subdevice *const read_subdevice =
-	    comedi_get_read_subdevice(info);
+	struct comedi_subdevice *s = comedi_get_read_subdevice(info);
+	unsigned int size = 0;
 
 	mutex_lock(&info->device->mutex);
-	if (read_subdevice &&
-	    (read_subdevice->subdev_flags & SDF_CMD_READ) &&
-	    read_subdevice->async) {
-		buffer_size_kb = read_subdevice->async->prealloc_bufsz /
-		    bytes_per_kibi;
-	}
-	retval = snprintf(buf, PAGE_SIZE, "%i\n", buffer_size_kb);
+	if (s && (s->subdev_flags & SDF_CMD_READ) && s->async)
+		size = s->async->prealloc_bufsz / 1024;
 	mutex_unlock(&info->device->mutex);
 
-	return retval;
+	return snprintf(buf, PAGE_SIZE, "%i\n", size);
 }
 
 static ssize_t store_read_buffer_kb(struct device *dev,
@@ -254,57 +233,41 @@ static ssize_t store_read_buffer_kb(struct device *dev,
 				    const char *buf, size_t count)
 {
 	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned int new_size_kb;
-	unsigned int new_size;
-	int retval;
-	int ret;
-	struct comedi_subdevice *const read_subdevice =
-	    comedi_get_read_subdevice(info);
+	struct comedi_subdevice *s = comedi_get_read_subdevice(info);
+	unsigned int size;
+	int err;
 
-	ret = kstrtouint(buf, 10, &new_size_kb);
-	if (ret)
-		return ret;
-	if (new_size_kb > (UINT_MAX / bytes_per_kibi))
+	err = kstrtouint(buf, 10, &size);
+	if (err)
+		return err;
+	if (size > (UINT_MAX / 1024))
 		return -EINVAL;
-	new_size = new_size_kb * bytes_per_kibi;
+	size *= 1024;
 
 	mutex_lock(&info->device->mutex);
-	if (read_subdevice == NULL ||
-	    (read_subdevice->subdev_flags & SDF_CMD_READ) == 0 ||
-	    read_subdevice->async == NULL) {
-		mutex_unlock(&info->device->mutex);
-		return -EINVAL;
-	}
-	retval = resize_async_buffer(info->device, read_subdevice,
-				     read_subdevice->async, new_size);
+	if (s && (s->subdev_flags & SDF_CMD_READ) && s->async)
+		err = resize_async_buffer(info->device, s, s->async, size);
+	else
+		err = -EINVAL;
 	mutex_unlock(&info->device->mutex);
 
-	if (retval < 0)
-		return retval;
-	return count;
+	return err ? err : count;
 }
 
 static ssize_t show_max_write_buffer_kb(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	ssize_t retval;
 	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned max_buffer_size_kb = 0;
-	struct comedi_subdevice *const write_subdevice =
-	    comedi_get_write_subdevice(info);
+	struct comedi_subdevice *s = comedi_get_write_subdevice(info);
+	unsigned int size = 0;
 
 	mutex_lock(&info->device->mutex);
-	if (write_subdevice &&
-	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) &&
-	    write_subdevice->async) {
-		max_buffer_size_kb = write_subdevice->async->max_bufsize /
-		    bytes_per_kibi;
-	}
-	retval = snprintf(buf, PAGE_SIZE, "%i\n", max_buffer_size_kb);
+	if (s && (s->subdev_flags & SDF_CMD_WRITE) && s->async)
+		size = s->async->max_bufsize / 1024;
 	mutex_unlock(&info->device->mutex);
 
-	return retval;
+	return snprintf(buf, PAGE_SIZE, "%i\n", size);
 }
 
 static ssize_t store_max_write_buffer_kb(struct device *dev,
@@ -312,52 +275,40 @@ static ssize_t store_max_write_buffer_kb(struct device *dev,
 					 const char *buf, size_t count)
 {
 	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned int new_max_size_kb;
-	unsigned int new_max_size;
-	int ret;
-	struct comedi_subdevice *const write_subdevice =
-	    comedi_get_write_subdevice(info);
+	struct comedi_subdevice *s = comedi_get_write_subdevice(info);
+	unsigned int size;
+	int err;
 
-	ret = kstrtouint(buf, 10, &new_max_size_kb);
-	if (ret)
-		return ret;
-	if (new_max_size_kb > (UINT_MAX / bytes_per_kibi))
+	err = kstrtouint(buf, 10, &size);
+	if (err)
+		return err;
+	if (size > (UINT_MAX / 1024))
 		return -EINVAL;
-	new_max_size = new_max_size_kb * bytes_per_kibi;
+	size *= 1024;
 
 	mutex_lock(&info->device->mutex);
-	if (write_subdevice == NULL ||
-	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) == 0 ||
-	    write_subdevice->async == NULL) {
-		mutex_unlock(&info->device->mutex);
-		return -EINVAL;
-	}
-	write_subdevice->async->max_bufsize = new_max_size;
+	if (s && (s->subdev_flags & SDF_CMD_WRITE) && s->async)
+		s->async->max_bufsize = size;
+	else
+		err = -EINVAL;
 	mutex_unlock(&info->device->mutex);
 
-	return count;
+	return err ? err : count;
 }
 
 static ssize_t show_write_buffer_kb(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	ssize_t retval;
 	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned buffer_size_kb = 0;
-	struct comedi_subdevice *const write_subdevice =
-	    comedi_get_write_subdevice(info);
+	struct comedi_subdevice *s = comedi_get_write_subdevice(info);
+	unsigned int size = 0;
 
 	mutex_lock(&info->device->mutex);
-	if (write_subdevice &&
-	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) &&
-	    write_subdevice->async) {
-		buffer_size_kb = write_subdevice->async->prealloc_bufsz /
-		    bytes_per_kibi;
-	}
-	retval = snprintf(buf, PAGE_SIZE, "%i\n", buffer_size_kb);
+	if (s && (s->subdev_flags & SDF_CMD_WRITE) && s->async)
+		size = s->async->prealloc_bufsz / 1024;
 	mutex_unlock(&info->device->mutex);
 
-	return retval;
+	return snprintf(buf, PAGE_SIZE, "%i\n", size);
 }
 
 static ssize_t store_write_buffer_kb(struct device *dev,
@@ -365,34 +316,25 @@ static ssize_t store_write_buffer_kb(struct device *dev,
 				     const char *buf, size_t count)
 {
 	struct comedi_device_file_info *info = dev_get_drvdata(dev);
-	unsigned int new_size_kb;
-	unsigned int new_size;
-	int retval;
-	int ret;
-	struct comedi_subdevice *const write_subdevice =
-	    comedi_get_write_subdevice(info);
+	struct comedi_subdevice *s = comedi_get_write_subdevice(info);
+	unsigned int size;
+	int err;
 
-	ret = kstrtouint(buf, 10, &new_size_kb);
-	if (ret)
-		return ret;
-	if (new_size_kb > (UINT_MAX / bytes_per_kibi))
+	err = kstrtouint(buf, 10, &size);
+	if (err)
+		return err;
+	if (size > (UINT_MAX / 1024))
 		return -EINVAL;
-	new_size = ((uint64_t) new_size_kb) * bytes_per_kibi;
+	size *= 1024;
 
 	mutex_lock(&info->device->mutex);
-	if (write_subdevice == NULL ||
-	    (write_subdevice->subdev_flags & SDF_CMD_WRITE) == 0 ||
-	    write_subdevice->async == NULL) {
-		mutex_unlock(&info->device->mutex);
-		return -EINVAL;
-	}
-	retval = resize_async_buffer(info->device, write_subdevice,
-				     write_subdevice->async, new_size);
+	if (s && (s->subdev_flags & SDF_CMD_WRITE) && s->async)
+		err = resize_async_buffer(info->device, s, s->async, size);
+	else
+		err = -EINVAL;
 	mutex_unlock(&info->device->mutex);
 
-	if (retval < 0)
-		return retval;
-	return count;
+	return err ? err : count;
 }
 
 static struct device_attribute comedi_dev_attrs[] = {
