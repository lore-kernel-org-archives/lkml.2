Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3AHXsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:48:50 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53664 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab3AHXho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Bernd Porr <berndporr@f2s.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 31/77] staging: comedi: fix oops for USB DAQ devices.
Date: Tue, 8 Jan 2013 18:35:10 -0500
Message-ID: <1357688156-25387-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Porr <berndporr@f2s.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3ffab428f40849ed5f21bcfd7285bdef7902f9ca upstream.

This fixes kernel oops when an USB DAQ device is plugged out while it's
communicating with the userspace software.

Signed-off-by: Bernd Porr <berndporr@f2s.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/comedi/comedi_fops.c | 71 +++++++++++++++++++++++++++---------
 1 file changed, 53 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index ac6527c..48ac52b 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1391,9 +1391,6 @@ static struct vm_operations_struct comedi_vm_ops = {
 static int comedi_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	const unsigned minor = iminor(file->f_dentry->d_inode);
-	struct comedi_device_file_info *dev_file_info =
-	    comedi_get_device_file_info(minor);
-	struct comedi_device *dev = dev_file_info->device;
 	struct comedi_async *async = NULL;
 	unsigned long start = vma->vm_start;
 	unsigned long size;
@@ -1401,6 +1398,15 @@ static int comedi_mmap(struct file *file, struct vm_area_struct *vma)
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
@@ -1467,11 +1473,17 @@ static unsigned int comedi_poll(struct file *file, poll_table * wait)
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
@@ -1517,9 +1529,15 @@ static ssize_t comedi_write(struct file *file, const char *buf, size_t nbytes,
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
@@ -1619,9 +1637,15 @@ static ssize_t comedi_read(struct file *file, char *buf, size_t nbytes,
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
@@ -1814,11 +1838,17 @@ ok:
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
 
@@ -1852,10 +1882,15 @@ static int comedi_close(struct inode *inode, struct file *file)
 static int comedi_fasync(int fd, struct file *file, int on)
 {
 	const unsigned minor = iminor(file->f_dentry->d_inode);
-	struct comedi_device_file_info *dev_file_info =
-	    comedi_get_device_file_info(minor);
+	struct comedi_device_file_info *dev_file_info;
+	struct comedi_device *dev;
+	dev_file_info = comedi_get_device_file_info(minor);
 
-	struct comedi_device *dev = dev_file_info->device;
+	if (dev_file_info == NULL)
+	        return -ENODEV;
+	dev = dev_file_info->device;
+	if (dev == NULL)
+	        return -ENODEV;
 
 	return fasync_helper(fd, file, on, &dev->async_queue);
 }
-- 
1.7.12.1

