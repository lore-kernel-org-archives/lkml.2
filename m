Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297Ab2LFVsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:48:25 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:38297 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965261Ab2LFVsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:48:22 -0500
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, tru@work-microwave.de, sr@denx.de,
        wg@grandegger.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 3/6 v10] gpio: Add userland device interface to block GPIO
Date: Thu,  6 Dec 2012 22:47:33 +0100
Message-Id: <1354830456-17590-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354830456-17590-1-git-send-email-stigge@antcom.de>
References: <1354830456-17590-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a character device interface to the block GPIO system.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 Documentation/ABI/testing/dev-gpioblock |   34 ++++
 drivers/gpio/gpiolib.c                  |  224 +++++++++++++++++++++++++++++++-
 include/linux/gpio.h                    |   13 +
 3 files changed, 270 insertions(+), 1 deletion(-)

--- /dev/null
+++ linux-2.6/Documentation/ABI/testing/dev-gpioblock
@@ -0,0 +1,34 @@
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
+		below) can be obtained as a word. When the device is opened
+		with O_NONBLOCK, read() always returns with data immediately,
+		otherwise it blocks until data is available, see IRQ handling
+		below.
+
+		Writing:
+		By writing sizeof(unsigned long) bytes to the device, the
+		current state of the block can be set. This operation is
+		masked by the current mask (see below).
+
+		IRQ handling:
+		When one or more IRQs in the block are IRQ capable, you can
+		poll() on the device to check/wait for this IRQ. If no IRQ
+		is available, poll() returns -ENOSYS and userspace needs to
+		(busy) poll itself if necessary.
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
@@ -11,6 +11,8 @@
 #include <linux/of_gpio.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/poll.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/gpio.h>
@@ -2122,6 +2124,206 @@ struct gpio_block *gpio_block_find_by_na
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
+static bool gpio_block_is_irq_duplicate(struct gpio_block *block, int index)
+{
+	int irq = gpio_to_irq(block->gpio[index]);
+	int i;
+
+	for (i = 0; i < index; i++)
+		if (gpio_to_irq(block->gpio[i]) == irq)
+			return true;
+	return false;
+}
+
+static irqreturn_t gpio_block_irq_handler(int irq, void *dev)
+{
+	struct gpio_block *block = dev;
+
+	wake_up_interruptible(&block->wait_queue);
+	block->got_int = true;
+
+	return IRQ_HANDLED;
+}
+
+static int gpio_block_fop_open(struct inode *in, struct file *f)
+{
+	int i;
+	struct gpio_block *block = gpio_block_find_by_minor(MINOR(in->i_rdev));
+	int status;
+	int irq;
+
+	if (!block)
+		return -ENOENT;
+
+	block->irq_controlled = false;
+	block->got_int = false;
+	spin_lock_init(&block->lock);
+	init_waitqueue_head(&block->wait_queue);
+	f->private_data = block;
+
+	for (i = 0; i < block->ngpio; i++) {
+		status = gpio_request(block->gpio[i], block->name);
+		if (status)
+			goto err1;
+
+		irq = gpio_to_irq(block->gpio[i]);
+		if (irq >= 0 &&
+		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags) &&
+		    !gpio_block_is_irq_duplicate(block, i)) {
+			status = request_irq(irq, gpio_block_irq_handler,
+					     IRQF_SHARED,
+					     block->name, block);
+			if (status)
+				goto err2;
+
+			block->irq_controlled = true;
+		}
+	}
+
+	return 0;
+
+err1:
+	while (i > 0) {
+		i--;
+
+		irq = gpio_to_irq(block->gpio[i]);
+		if (irq >= 0 &&
+		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags) &&
+		    !gpio_block_is_irq_duplicate(block, i))
+			free_irq(irq, block);
+err2:
+		gpio_free(block->gpio[i]);
+	}
+	return status;
+}
+
+static int gpio_block_fop_release(struct inode *in, struct file *f)
+{
+	int i;
+	struct gpio_block *block = (struct gpio_block *)f->private_data;
+
+	for (i = 0; i < block->ngpio; i++) {
+		int irq = gpio_to_irq(block->gpio[i]);
+
+		if (irq >= 0 &&
+		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags) &&
+		    !gpio_block_is_irq_duplicate(block, i))
+			free_irq(irq, block);
+
+		gpio_free(block->gpio[i]);
+	}
+
+	return 0;
+}
+
+static int got_int(struct gpio_block *block)
+{
+	unsigned long flags;
+	int result;
+
+	spin_lock_irqsave(&block->lock, flags);
+	result = block->got_int;
+	spin_unlock_irqrestore(&block->lock, flags);
+
+	return result;
+}
+
+static ssize_t gpio_block_fop_read(struct file *f, char __user *buf, size_t n,
+				   loff_t *offset)
+{
+	struct gpio_block *block = (struct gpio_block *)f->private_data;
+	int err;
+	unsigned long flags;
+
+	if (block->irq_controlled) {
+		if (!(f->f_flags & O_NONBLOCK))
+			wait_event_interruptible(block->wait_queue,
+						 got_int(block));
+		spin_lock_irqsave(&block->lock, flags);
+		block->got_int = 0;
+		spin_unlock_irqrestore(&block->lock, flags);
+	}
+
+	if (n >= sizeof(unsigned long)) {
+		unsigned long values = gpio_block_get(block, block->cur_mask);
+
+		err = put_user(values, (unsigned long __user *)buf);
+		if (err)
+			return err;
+
+		return sizeof(unsigned long);
+	}
+	return 0;
+}
+
+static ssize_t gpio_block_fop_write(struct file *f, const char __user *buf,
+				    size_t n, loff_t *offset)
+{
+	struct gpio_block *block = (struct gpio_block *)f->private_data;
+	int err;
+
+	if (n >= sizeof(unsigned long)) {
+		unsigned long values;
+
+		err = get_user(values, (unsigned long __user *)buf);
+		if (err)
+			return err;
+		if (gpio_block_is_output(block))
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
+unsigned int gpio_block_fop_poll(struct file *f, struct poll_table_struct *pt)
+{
+	struct gpio_block *block = (struct gpio_block *)f->private_data;
+
+	if (!block->irq_controlled)
+		return -ENOSYS;
+
+	if (!got_int(block))
+		poll_wait(f, &block->wait_queue, pt);
+
+	if (got_int(block))
+		return POLLIN;
+
+	return 0;
+}
+
+static const struct file_operations gpio_block_fops = {
+	.open = gpio_block_fop_open,
+	.release = gpio_block_fop_release,
+	.read = gpio_block_fop_read,
+	.write = gpio_block_fop_write,
+	.unlocked_ioctl = gpio_block_fop_ioctl,
+	.poll = gpio_block_fop_poll,
+};
+
 int gpio_block_register(struct gpio_block *block)
 {
 	int ret;
@@ -2132,12 +2334,31 @@ int gpio_block_register(struct gpio_bloc
 	list_add(&block->list, &gpio_block_list);
 
 	ret = gpio_block_export(block);
-	if (ret)
+
+	/*
+	 * ret == ENOSYS is the case where GPIO_SYSFS is deactivated. In this
+	 * case, we can continue safely anyway, since we can provide the device
+	 * interface.
+	 */
+	if (ret && ret != -ENOSYS)
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
@@ -2150,6 +2371,7 @@ void gpio_block_unregister(struct gpio_b
 		if (i == block) {
 			list_del(&i->list);
 			gpio_block_unexport(block);
+			misc_deregister(&block->miscdev);
 			break;
 		}
 }
--- linux-2.6.orig/include/linux/gpio.h
+++ linux-2.6/include/linux/gpio.h
@@ -4,6 +4,9 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/sched.h>
+#include <linux/miscdevice.h>
+#include <linux/spinlock.h>
 
 /* see Documentation/gpio.txt */
 
@@ -89,6 +92,11 @@ struct gpio_block_chip {
  * @gpio:       list of gpios in this block
  * @list:       global list of blocks, maintained by gpiolib
  * @cur_mask:   currently used gpio mask used by userspace API
+ * @miscdev:    userspace API: device
+ * @wait_queue: userspace API: wait queue waiting for IRQ
+ * @irq_controlled: userspace API: flag: using IRQ or not
+ * @got_int:    userspace API: change detection via IRQ
+ * @lock:	userspace API: spinlock for IRQ manipulated data
  */
 struct gpio_block {
 	struct list_head	gbc_list;
@@ -99,6 +107,11 @@ struct gpio_block {
 
 	struct list_head	list;
 	unsigned long		cur_mask;
+	struct miscdevice	miscdev;
+	wait_queue_head_t	wait_queue;
+	bool			irq_controlled;
+	bool			got_int;
+	spinlock_t		lock;
 };
 
 #ifdef CONFIG_GENERIC_GPIO
