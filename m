Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab1LGQR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:17:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235Ab1LGQR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:17:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:26 2011
Message-Id: <20111207160826.398188064@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:06 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Bernd Porr <berndporr@f2s.com>
Subject: [46/80] staging: comedi: fix oops for USB DAQ devices.
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Porr <berndporr@f2s.com>

commit 3ffab428f40849ed5f21bcfd7285bdef7902f9ca upstream.

This fixes kernel oops when an USB DAQ device is plugged out while it's
communicating with the userspace software.

Signed-off-by: Bernd Porr <berndporr@f2s.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/comedi_fops.c |   73 +++++++++++++++++++++++++----------
 1 file changed, 54 insertions(+), 19 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1452,9 +1452,6 @@ static struct vm_operations_struct comed
 static int comedi_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	const unsigned minor = iminor(file->f_dentry->d_inode);
-	struct comedi_device_file_info *dev_file_info =
-	    comedi_get_device_file_info(minor);
-	struct comedi_device *dev = dev_file_info->device;
 	struct comedi_async *async = NULL;
 	unsigned long start = vma->vm_start;
 	unsigned long size;
@@ -1462,6 +1459,15 @@ static int comedi_mmap(struct file *file
 	int i;
 	int retval;
 	struct comedi_subdevice *s;
+	struct comedi_device_file_info *dev_file_info;
+	struct comedi_device *dev;
+
+	dev_file_info = comedi_get_device_file_info(minor);
+	if (dev_file_info == NULL)
+	        return -ENODEV;
+	dev = dev_file_info->device;
+	if (dev == NULL)
+	        return -ENODEV;
 
 	mutex_lock(&dev->mutex);
 	if (!dev->attached) {
@@ -1528,11 +1534,17 @@ static unsigned int comedi_poll(struct f
 {
 	unsigned int mask = 0;
 	const unsigned minor = iminor(file->f_dentry->d_inode);
-	struct comedi_device_file_info *dev_file_info =
-	    comedi_get_device_file_info(minor);
-	struct comedi_device *dev = dev_file_info->device;
 	struct comedi_subdevice *read_subdev;
 	struct comedi_subdevice *write_subdev;
+	struct comedi_device_file_info *dev_file_info;
+	struct comedi_device *dev;
+	dev_file_info = comedi_get_device_file_info(minor);
+
+	if (dev_file_info == NULL)
+	        return -ENODEV;
+	dev = dev_file_info->device;
+	if (dev == NULL)
+	        return -ENODEV;
 
 	mutex_lock(&dev->mutex);
 	if (!dev->attached) {
@@ -1578,9 +1590,15 @@ static ssize_t comedi_write(struct file
 	int n, m, count = 0, retval = 0;
 	DECLARE_WAITQUEUE(wait, current);
 	const unsigned minor = iminor(file->f_dentry->d_inode);
-	struct comedi_device_file_info *dev_file_info =
-	    comedi_get_device_file_info(minor);
-	struct comedi_device *dev = dev_file_info->device;
+	struct comedi_device_file_info *dev_file_info;
+	struct comedi_device *dev;
+	dev_file_info = comedi_get_device_file_info(minor);
+
+	if (dev_file_info == NULL)
+	        return -ENODEV;
+	dev = dev_file_info->device;
+	if (dev == NULL)
+	        return -ENODEV;
 
 	if (!dev->attached) {
 		DPRINTK("no driver configured on comedi%i\n", dev->minor);
@@ -1683,9 +1701,15 @@ static ssize_t comedi_read(struct file *
 	int n, m, count = 0, retval = 0;
 	DECLARE_WAITQUEUE(wait, current);
 	const unsigned minor = iminor(file->f_dentry->d_inode);
-	struct comedi_device_file_info *dev_file_info =
-	    comedi_get_device_file_info(minor);
-	struct comedi_device *dev = dev_file_info->device;
+	struct comedi_device_file_info *dev_file_info;
+	struct comedi_device *dev;
+	dev_file_info = comedi_get_device_file_info(minor);
+
+	if (dev_file_info == NULL)
+	        return -ENODEV;
+	dev = dev_file_info->device;
+	if (dev == NULL)
+	        return -ENODEV;
 
 	if (!dev->attached) {
 		DPRINTK("no driver configured on comedi%i\n", dev->minor);
@@ -1885,11 +1909,17 @@ ok:
 static int comedi_close(struct inode *inode, struct file *file)
 {
 	const unsigned minor = iminor(inode);
-	struct comedi_device_file_info *dev_file_info =
-	    comedi_get_device_file_info(minor);
-	struct comedi_device *dev = dev_file_info->device;
 	struct comedi_subdevice *s = NULL;
 	int i;
+	struct comedi_device_file_info *dev_file_info;
+	struct comedi_device *dev;
+	dev_file_info = comedi_get_device_file_info(minor);
+
+	if (dev_file_info == NULL)
+	        return -ENODEV;
+	dev = dev_file_info->device;
+	if (dev == NULL)
+	        return -ENODEV;
 
 	mutex_lock(&dev->mutex);
 
@@ -1923,10 +1953,15 @@ static int comedi_close(struct inode *in
 static int comedi_fasync(int fd, struct file *file, int on)
 {
 	const unsigned minor = iminor(file->f_dentry->d_inode);
-	struct comedi_device_file_info *dev_file_info =
-	    comedi_get_device_file_info(minor);
-
-	struct comedi_device *dev = dev_file_info->device;
+	struct comedi_device_file_info *dev_file_info;
+	struct comedi_device *dev;
+	dev_file_info = comedi_get_device_file_info(minor);
+
+	if (dev_file_info == NULL)
+	        return -ENODEV;
+	dev = dev_file_info->device;
+	if (dev == NULL)
+	        return -ENODEV;
 
 	return fasync_helper(fd, file, on, &dev->async_queue);
 }


