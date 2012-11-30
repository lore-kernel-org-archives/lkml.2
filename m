Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab2K3SEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:04:40 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:61316 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759120Ab2K3SEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:04:36 -0500
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, tru@work-microwave.de, sr@denx.de,
        wg@grandegger.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 3/6 v8] gpio: Add userland device interface to block GPIO
Date: Fri, 30 Nov 2012 19:03:53 +0100
Message-Id: <1354298637-25058-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354298637-25058-1-git-send-email-stigge@antcom.de>
References: <1354298637-25058-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a character device interface to the block GPIO system.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 Documentation/ABI/testing/dev-gpioblock |   25 ++++++
 drivers/gpio/gpiolib.c                  |  121 +++++++++++++++++++++++++++++++-
 include/linux/gpio.h                    |    4 +
 3 files changed, 147 insertions(+), 3 deletions(-)

--- /dev/null
+++ linux-2.6/Documentation/ABI/testing/dev-gpioblock
@@ -0,0 +1,25 @@
+What:		/dev/<gpioblock>
+Date:		Nov 2012
+KernelVersion:	3.7
+Contact:	Roland Stigge <stigge@antcom.de>
+Description:	The /dev/<gpioblock> character device node provides userspace
+		access to GPIO blocks, named exactly as the block, e.g.
+		/dev/block0.
+
+		Reading:
+		When reading sizeof(unsigned long) bytes from the device, the
+		current state of the block, masked by the current mask (see
+		below) can be obtained as a word.
+
+		Writing:
+		By writing sizeof(unsigned long) bytes to the device, the
+		current state of the block can be set. This operation is
+		masked by the current mask (see below).
+
+		Setting the mask (default: all bits set):
+		By doing an ioctl(fd, 0, &mask) with an unsigned long mask, the
+		current mask for read and write operations on this gpio block
+		can be set.
+
+		See also Documentation/gpio.txt for an explanation of block
+		GPIO.
--- linux-2.6.orig/drivers/gpio/gpiolib.c
+++ linux-2.6/drivers/gpio/gpiolib.c
@@ -11,6 +11,7 @@
 #include <linux/of_gpio.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/gpio.h>
@@ -193,12 +194,13 @@ err:
 	return ret;
 }
 
-static bool gpio_block_is_output(struct gpio_block *block)
+static bool gpio_block_is_output(struct gpio_block *block, unsigned long mask)
 {
 	int i;
 
 	for (i = 0; i < block->ngpio; i++)
-		if (!test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags))
+		if ((mask & BIT(i)) &&
+		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags))
 			return false;
 	return true;
 }
@@ -1012,7 +1014,7 @@ static ssize_t gpio_block_value_store(st
 	status = kstrtoul(buf, 0, &value);
 	if (status == 0) {
 		mutex_lock(&sysfs_lock);
-		if (gpio_block_is_output(block)) {
+		if (gpio_block_is_output(block, ~0)) {
 			gpio_block_set(block, ~0, value);
 			status = size;
 		} else {
@@ -2121,6 +2123,105 @@ struct gpio_block *gpio_block_find_by_na
 }
 EXPORT_SYMBOL_GPL(gpio_block_find_by_name);
 
+static struct gpio_block *gpio_block_find_by_minor(int minor)
+{
+	struct gpio_block *i;
+
+	list_for_each_entry(i, &gpio_block_list, list)
+		if (i->miscdev.minor == minor)
+			return i;
+	return NULL;
+}
+
+static int gpio_block_fop_open(struct inode *in, struct file *f)
+{
+	int i;
+	struct gpio_block *block = gpio_block_find_by_minor(MINOR(in->i_rdev));
+
+	if (!block)
+		return -ENOENT;
+
+	for (i = 0; i < block->ngpio; i++) {
+		int status = gpio_request(block->gpio[i], "gpioblock dev");
+
+		if (status)
+			return -EBUSY;
+	}
+
+	f->private_data = block;
+
+	return 0;
+}
+
+static int gpio_block_fop_release(struct inode *in, struct file *f)
+{
+	int i;
+	struct gpio_block *block = (struct gpio_block *)f->private_data;
+
+	for (i = 0; i < block->ngpio; i++)
+		gpio_free(block->gpio[i]);
+
+	return 0;
+}
+
+static ssize_t gpio_block_fop_read(struct file *f, char __user *buf, size_t n,
+				   loff_t *offset)
+{
+	struct gpio_block *block = (struct gpio_block *)f->private_data;
+	int err;
+
+	if (n >= sizeof(unsigned long)) {
+		unsigned long values = gpio_block_get(block, block->cur_mask);
+
+		err = put_user(values, buf);
+		if (err)
+			return err;
+
+		return sizeof(unsigned long);
+	}
+	return 0;
+}
+static ssize_t gpio_block_fop_write(struct file *f, const char __user *buf,
+				    size_t n, loff_t *offset)
+{
+	struct gpio_block *block = (struct gpio_block *)f->private_data;
+	int err;
+
+	if (n >= sizeof(unsigned long)) {
+		unsigned long values;
+
+		err = get_user(values, buf);
+		if (err)
+			return err;
+		if (gpio_block_is_output(block, block->cur_mask))
+			gpio_block_set(block, block->cur_mask, values);
+		else
+			return -EPERM;
+		return sizeof(unsigned long);
+	}
+	return 0;
+}
+
+static long gpio_block_fop_ioctl(struct file *f, unsigned int cmd,
+				 unsigned long arg)
+{
+	struct gpio_block *block = (struct gpio_block *)f->private_data;
+	unsigned long __user *x = (unsigned long __user *)arg;
+
+	if (cmd == 0)
+		return get_user(block->cur_mask, x);
+
+	return -EINVAL;
+}
+
+static const struct file_operations gpio_block_fops = {
+	.open = gpio_block_fop_open,
+	.release = gpio_block_fop_release,
+	.read = gpio_block_fop_read,
+	.write = gpio_block_fop_write,
+	.unlocked_ioctl = gpio_block_fop_ioctl,
+};
+
 int gpio_block_register(struct gpio_block *block)
 {
 	int ret;
@@ -2134,9 +2235,22 @@ int gpio_block_register(struct gpio_bloc
 	if (ret)
 		goto err1;
 
+	block->miscdev.name = block->name;
+	block->miscdev.nodename = block->name;
+	block->miscdev.minor = MISC_DYNAMIC_MINOR;
+	block->miscdev.fops = &gpio_block_fops;
+	block->miscdev.mode = S_IWUSR | S_IRUGO;
+
+	ret = misc_register(&block->miscdev);
+	if (ret)
+		goto err2;
+
 	return 0;
+err2:
+	gpio_block_unexport(block);
 err1:
 	list_del(&block->list);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(gpio_block_register);
@@ -2149,6 +2263,7 @@ void gpio_block_unregister(struct gpio_b
 		if (i == block) {
 			list_del(&i->list);
 			gpio_block_unexport(block);
+			misc_deregister(&block->miscdev);
 			break;
 		}
 }
--- linux-2.6.orig/include/linux/gpio.h
+++ linux-2.6/include/linux/gpio.h
@@ -4,6 +4,7 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/miscdevice.h>
 
 /* see Documentation/gpio.txt */
 
@@ -88,6 +89,8 @@ struct gpio_block_chip {
  * @ngpio:      number of gpios in this block
  * @gpio:       list of gpios in this block
  * @list:       global list of blocks, maintained by gpiolib
+ * @miscdev:    userspace API / device
+ * @cur_mask:   currently used gpio mask used by userspace API
  */
 struct gpio_block {
 	struct list_head	gbc_list;
@@ -98,6 +101,7 @@ struct gpio_block {
 
 	struct list_head	list;
 	unsigned long		cur_mask;
+	struct miscdevice	miscdev;
 };
 
 #ifdef CONFIG_GENERIC_GPIO
