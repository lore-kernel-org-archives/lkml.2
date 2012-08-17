Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011Ab2HQXVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 19:21:53 -0400
Received: from [12.239.217.82] ([12.239.217.82]:28612 "EHLO
	venom.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757196Ab2HQXUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 19:20:50 -0400
X-Greylist: delayed 3724 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2012 19:20:45 EDT
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 5/17] input: rmidev character driver for RMI4 sensors
Date: Fri, 17 Aug 2012 15:17:45 -0700
Message-Id: <1345241877-16200-6-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for Synaptics touchscreens using RMI4 protocol.

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

---

 drivers/input/rmi4/rmi_dev.c |  448 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 448 insertions(+), 0 deletions(-)

diff --git a/drivers/input/rmi4/rmi_dev.c b/drivers/input/rmi4/rmi_dev.c
new file mode 100644
index 0000000..080db55
--- /dev/null
+++ b/drivers/input/rmi4/rmi_dev.c
@@ -0,0 +1,448 @@
+/*
+ * Copyright (c) 2011 Synaptics Incorporated
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/syscalls.h>
+
+#include <linux/rmi.h>
+#include "rmi_driver.h"
+
+#define CHAR_DEVICE_NAME "rmi"
+#define DEVICE_CLASS_NAME "rmidev"
+
+#define RMI_CHAR_DEV_TMPBUF_SZ 128
+#define RMI_REG_ADDR_PAGE_SELECT 0xFF
+#define REG_ADDR_LIMIT 0xFFFF
+
+struct rmidev_data {
+	/* mutex for file operation*/
+	struct mutex file_mutex;
+	/* main char dev structure */
+	struct cdev main_dev;
+
+	/* pointer to the corresponding RMI4 device.  We use this to do */
+	/* read, write, etc. */
+	struct rmi_device *rmi_dev;
+	/* reference count */
+	int ref_count;
+
+	struct class *device_class;
+};
+
+/*store dynamically allocated major number of char device*/
+static int rmidev_major_num;
+
+
+static struct class *rmidev_device_class;
+
+
+/* file operations for RMI char device */
+
+/*
+ * rmidev_llseek: - use to setup register address
+ *
+ * @filp: file structure for seek
+ * @off: offset
+ *       if whence == SEEK_SET,
+ *       high 16 bits: page address
+ *       low 16 bits: register address
+ *
+ *       if whence == SEEK_CUR,
+ *       offset from current position
+ *
+ *       if whence == SEEK_END,
+ *       offset from END(0xFFFF)
+ *
+ * @whence: SEEK_SET , SEEK_CUR or SEEK_END
+ */
+static loff_t rmidev_llseek(struct file *filp, loff_t off, int whence)
+{
+	loff_t newpos;
+	struct rmidev_data *data = filp->private_data;
+
+	if (IS_ERR(data)) {
+		pr_err("%s: pointer of char device is invalid", __func__);
+		return -EBADF;
+	}
+
+	mutex_lock(&(data->file_mutex));
+
+	switch (whence) {
+	case SEEK_SET:
+		newpos = off;
+		break;
+
+	case SEEK_CUR:
+		newpos = filp->f_pos + off;
+		break;
+
+	case SEEK_END:
+		newpos = REG_ADDR_LIMIT + off;
+		break;
+
+	default:		/* can't happen */
+		newpos = -EINVAL;
+		goto clean_up;
+	}
+
+	if (newpos < 0 || newpos > REG_ADDR_LIMIT) {
+		dev_err(&data->rmi_dev->dev, "newpos 0x%04x is invalid.\n",
+			(unsigned int)newpos);
+		newpos = -EINVAL;
+		goto clean_up;
+	}
+
+	filp->f_pos = newpos;
+
+clean_up:
+	mutex_unlock(&(data->file_mutex));
+	return newpos;
+}
+
+/*
+ *  rmidev_read: - use to read data from RMI stream
+ *
+ *  @filp: file structure for read
+ *  @buf: user-level buffer pointer
+ *
+ *  @count: number of byte read
+ *  @f_pos: offset (starting register address)
+ *
+ *	@return number of bytes read into user buffer (buf) if succeeds
+ *          negative number if error occurs.
+ */
+static ssize_t rmidev_read(struct file *filp, char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	struct rmidev_data *data = filp->private_data;
+	ssize_t retval  = 0;
+	unsigned char tmpbuf[count+1];
+
+	/* limit offset to REG_ADDR_LIMIT-1 */
+	if (count > (REG_ADDR_LIMIT - *f_pos))
+		count = REG_ADDR_LIMIT - *f_pos;
+
+	if (count == 0)
+		return 0;
+
+	if (IS_ERR(data)) {
+		pr_err("%s: pointer of char device is invalid", __func__);
+		return -EBADF;
+	}
+
+	mutex_lock(&(data->file_mutex));
+
+	retval = rmi_read_block(data->rmi_dev, *f_pos, tmpbuf, count);
+
+	if (retval < 0)
+		goto clean_up;
+
+	if (copy_to_user(buf, tmpbuf, count))
+		retval = -EFAULT;
+	else
+		*f_pos += retval;
+
+clean_up:
+
+	mutex_unlock(&(data->file_mutex));
+
+	return retval;
+}
+
+/*
+ * rmidev_write: - use to write data into RMI stream
+ *
+ * @filep : file structure for write
+ * @buf: user-level buffer pointer contains data to be written
+ * @count: number of byte be be written
+ * @f_pos: offset (starting register address)
+ *
+ * @return number of bytes written from user buffer (buf) if succeeds
+ *         negative number if error occurs.
+ */
+static ssize_t rmidev_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	struct rmidev_data *data = filp->private_data;
+	ssize_t retval  = 0;
+	unsigned char tmpbuf[count+1];
+
+	/* limit offset to REG_ADDR_LIMIT-1 */
+	if (count > (REG_ADDR_LIMIT - *f_pos))
+		count = REG_ADDR_LIMIT - *f_pos;
+
+	if (count == 0)
+		return 0;
+
+	if (IS_ERR(data)) {
+		pr_err("%s: pointer of char device is invalid", __func__);
+		return -EBADF;
+	}
+
+	if (copy_from_user(tmpbuf, buf, count))
+		return -EFAULT;
+
+	mutex_lock(&(data->file_mutex));
+
+	retval = rmi_write_block(data->rmi_dev, *f_pos, tmpbuf, count);
+
+	if (retval >= 0)
+		*f_pos += count;
+
+	mutex_unlock(&(data->file_mutex));
+
+	return retval;
+}
+
+/*
+ * rmidev_open: - get a new handle for from RMI stream
+ * @inp : inode struture
+ * @filp: file structure for read/write
+ *
+ * @return 0 if succeeds
+ */
+static int rmidev_open(struct inode *inp, struct file *filp)
+{
+	struct rmidev_data *data = container_of(inp->i_cdev,
+			struct rmidev_data, main_dev);
+	int retval = 0;
+
+	filp->private_data = data;
+
+	if (!data->rmi_dev)
+		return -EACCES;
+
+	mutex_lock(&(data->file_mutex));
+	if (data->ref_count < 1)
+		data->ref_count++;
+	else
+		retval = -EACCES;
+
+	mutex_unlock(&(data->file_mutex));
+
+	return retval;
+}
+
+/*
+ *  rmidev_release: - release an existing handle
+ *  @inp: inode structure
+ *  @filp: file structure for read/write
+ *
+ *  @return 0 if succeeds
+ */
+static int rmidev_release(struct inode *inp, struct file *filp)
+{
+	struct rmidev_data *data = container_of(inp->i_cdev,
+			struct rmidev_data, main_dev);
+
+	if (!data->rmi_dev)
+		return -EACCES;
+
+	mutex_lock(&(data->file_mutex));
+
+	data->ref_count--;
+	if (data->ref_count < 0)
+		data->ref_count = 0;
+
+	mutex_unlock(&(data->file_mutex));
+
+	return 0;
+}
+
+static const struct file_operations rmidev_fops = {
+	.owner =    THIS_MODULE,
+	.llseek =   rmidev_llseek,
+	.read =     rmidev_read,
+	.write =    rmidev_write,
+	.open =     rmidev_open,
+	.release =  rmidev_release,
+};
+
+/*
+ * rmidev_device_cleanup - release memory or unregister driver
+ * @rmidev_data: instance data for a particular device.
+ *
+ */
+static void rmidev_device_cleanup(struct rmidev_data *data)
+{
+	dev_t devno;
+
+	/* Get rid of our char dev entries */
+	if (data) {
+		devno = data->main_dev.dev;
+
+		if (data->device_class)
+			device_destroy(data->device_class, devno);
+
+		cdev_del(&data->main_dev);
+		kfree(data);
+
+		/* cleanup_module is never called if registering failed */
+		unregister_chrdev_region(devno, 1);
+		pr_debug("%s: rmidev device is removed\n", __func__);
+	}
+}
+
+/*
+ * rmi_char_devnode - return device permission
+ *
+ * @dev: char device structure
+ * @mode: file permission
+ *
+ */
+static char *rmi_char_devnode(struct device *dev, mode_t *mode)
+{
+	if (!mode)
+		return NULL;
+	/**mode = 0666*/
+	*mode = (S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH);
+
+	return kasprintf(GFP_KERNEL, "rmi/%s", dev_name(dev));
+}
+
+static int rmidev_init_device(struct rmi_char_device *cd)
+{
+	struct rmi_device *rmi_dev = cd->rmi_dev;
+	struct rmidev_data *data;
+	dev_t dev_no;
+	int retval;
+	struct device *device_ptr;
+
+	if (rmidev_major_num) {
+		dev_no = MKDEV(rmidev_major_num, cd->rmi_dev->number);
+		retval = register_chrdev_region(dev_no, 1, CHAR_DEVICE_NAME);
+	} else {
+		retval = alloc_chrdev_region(&dev_no, 0, 1, CHAR_DEVICE_NAME);
+		/* let kernel allocate a major for us */
+		rmidev_major_num = MAJOR(dev_no);
+		dev_info(&rmi_dev->dev, "Major number of rmidev: %d\n",
+				 rmidev_major_num);
+	}
+	if (retval < 0) {
+		dev_err(&rmi_dev->dev,
+			"Failed to get minor dev number %d, code %d.\n",
+			cd->rmi_dev->number, retval);
+		return retval;
+	} else
+		dev_info(&rmi_dev->dev, "Allocated rmidev %d %d.\n",
+			 MAJOR(dev_no), MINOR(dev_no));
+
+	data = kzalloc(sizeof(struct rmidev_data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&rmi_dev->dev, "Failed to allocate rmidev_data.\n");
+		/* unregister the char device region */
+		__unregister_chrdev(rmidev_major_num, MINOR(dev_no), 1,
+				CHAR_DEVICE_NAME);
+		return -ENOMEM;
+	}
+
+	mutex_init(&data->file_mutex);
+
+	data->rmi_dev = cd->rmi_dev;
+	cd->data = data;
+
+	cdev_init(&data->main_dev, &rmidev_fops);
+
+	retval = cdev_add(&data->main_dev, dev_no, 1);
+	if (retval) {
+		dev_err(&cd->rmi_dev->dev, "Error %d adding rmi_char_dev.\n",
+			retval);
+		rmidev_device_cleanup(data);
+		return retval;
+	}
+
+	dev_set_name(&cd->dev, "rmidev%d", MINOR(dev_no));
+	data->device_class = rmidev_device_class;
+	device_ptr = device_create(
+			data->device_class,
+			NULL, dev_no, NULL,
+			CHAR_DEVICE_NAME"%d",
+			MINOR(dev_no));
+
+	if (IS_ERR(device_ptr)) {
+		dev_err(&cd->rmi_dev->dev, "Failed to create rmi device.\n");
+		rmidev_device_cleanup(data);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void rmidev_remove_device(struct rmi_char_device *cd)
+{
+	struct rmidev_data *data;
+
+	dev_dbg(&cd->dev, "%s: removing an rmidev device.\n", __func__);
+	if (!cd)
+		return;
+
+	data = cd->data;
+	if (data)
+		rmidev_device_cleanup(data);
+}
+
+static struct rmi_char_driver rmidev_driver = {
+	.driver = {
+		.name = "rmidev",
+		.owner = THIS_MODULE,
+	},
+
+	.init = rmidev_init_device,
+	.remove = rmidev_remove_device,
+};
+
+static int __init rmidev_init(void)
+{
+	int error = 0;
+	pr_debug("%s: rmi_dev initialization.\n", __func__);
+
+	/* create device node */
+	rmidev_device_class = class_create(THIS_MODULE, DEVICE_CLASS_NAME);
+
+	if (IS_ERR(rmidev_device_class)) {
+		pr_err("%s: ERROR - Failed to create /dev/%s.\n", __func__,
+			CHAR_DEVICE_NAME);
+		return -ENODEV;
+	}
+	/* setup permission */
+	rmidev_device_class->devnode = rmi_char_devnode;
+
+	error = rmi_register_character_driver(&rmidev_driver);
+	if (error)
+		class_destroy(rmidev_device_class);
+	return error;
+}
+
+static void __exit rmidev_exit(void)
+{
+	pr_debug("%s: exiting.\n", __func__);
+	rmi_unregister_character_driver(&rmidev_driver);
+	class_destroy(rmidev_device_class);
+}
+
+module_init(rmidev_init);
+module_exit(rmidev_exit);
+
+MODULE_AUTHOR("Christopher Heiny <cheiny@synaptics.com>");
+MODULE_DESCRIPTION("RMI4 Char Device");
+MODULE_LICENSE("GPL");
