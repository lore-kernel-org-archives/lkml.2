Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2KQKCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 05:02:00 -0500
Received: from antcom.de ([188.40.178.216]:34444 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab2KQKBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 05:01:02 -0500
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 3/6 v7] gpio: Add userland device interface to block GPIO
Date: Sat, 17 Nov 2012 10:59:50 +0100
Message-Id: <1353146393-19312-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353146393-19312-1-git-send-email-stigge@antcom.de>
References: <1353146393-19312-1-git-send-email-stigge@antcom.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a character device interface to the block GPIO system.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 Documentation/ABI/testing/dev-gpioblock |   25 ++++++
 drivers/gpio/gpiolib.c                  |  117 +++++++++++++++++++++++++++++++-
 include/linux/gpio.h                    |    5 +
 3 files changed, 144 insertions(+), 3 deletions(-)

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
@@ -991,12 +992,13 @@ static ssize_t gpio_block_value_show(str
 		       "0x%016lx\n", gpio_block_get(block, ~0));
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
@@ -2086,6 +2088,106 @@ struct gpio_block *gpio_block_find_by_na
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
+	block->cur_mask = ~0;
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
 	if (gpio_block_find_by_name(block->name))
@@ -2094,6 +2196,14 @@ int gpio_block_register(struct gpio_bloc
 	list_add(&block->list, &gpio_block_list);
 	gpio_block_export(block);
 
+	block->miscdev.name = block->name;
+	block->miscdev.nodename = block->name;
+	block->miscdev.minor = MISC_DYNAMIC_MINOR;
+	block->miscdev.fops = &gpio_block_fops;
+	block->miscdev.mode = S_IWUSR | S_IRUGO;
+
+	misc_register(&block->miscdev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gpio_block_register);
@@ -2106,6 +2216,7 @@ void gpio_block_unregister(struct gpio_b
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
@@ -97,6 +100,8 @@ struct gpio_block {
 	unsigned		*gpio;
 
 	struct list_head	list;
+	struct miscdevice	miscdev;
+	unsigned long		cur_mask;
 };
 
 #ifdef CONFIG_GENERIC_GPIO
