Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab0KZMHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:07:40 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:38589 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab0KZMHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:07:38 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH 2/2] MFD: ab8500-debugfs irq support
Date: Fri, 26 Nov 2010 13:07:09 +0100
Message-ID: <1290773229-9119-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it possible to listned for ab8500 interrupts
from userspace. A sysfs file is dynamically created
and sysfs_notify is called when an interrupt occurs. This will
make the userspace poll call to be released.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |  236 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 231 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index dfdc76e..8d5e30a 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -10,6 +10,9 @@
 #include <linux/fs.h>
 #include <linux/debugfs.h>
 #include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/kobject.h>
+#include <linux/slab.h>
 
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/ab8500.h>
@@ -17,6 +20,13 @@
 static u32 debug_bank;
 static u32 debug_address;
 
+static int irq_first;
+static int irq_last;
+static u32 irq_count[AB8500_NR_IRQS];
+
+static struct device_attribute *dev_attr[AB8500_NR_IRQS];
+static char *event_name[AB8500_NR_IRQS];
+
 /**
  * struct ab8500_reg_range
  * @first: the first address of the range
@@ -44,7 +54,7 @@ struct ab8500_i2c_ranges {
 #define AB8500_NAME_STRING "ab8500"
 #define AB8500_NUM_BANKS 22
 
-#define AB8500_REV_REG 0x80
+#define AB8500_REV_REG	0x80
 
 static struct ab8500_i2c_ranges debug_ranges[AB8500_NUM_BANKS] = {
 	[0x0] = {
@@ -353,6 +363,24 @@ static struct ab8500_i2c_ranges debug_ranges[AB8500_NUM_BANKS] = {
 	},
 };
 
+static irqreturn_t ab8500_debug_handler(int irq, void *data)
+{
+	char buf[16];
+	struct kobject *kobj = (struct kobject *)data;
+	unsigned int irq_abb = irq - irq_first;
+
+	if (irq_abb < AB8500_NR_IRQS)
+		irq_count[irq_abb]++;
+	/*
+	 * This makes it possible to use poll for events (POLLPRI | POLLERR)
+	 * from userspace on sysfs file named <irq-nr>
+	 */
+	sprintf(buf, "%d", irq);
+	sysfs_notify(kobj, NULL, buf);
+
+	return IRQ_HANDLED;
+}
+
 static int ab8500_registers_print(struct seq_file *s, void *p)
 {
 	struct device *dev = s->private;
@@ -382,8 +410,10 @@ static int ab8500_registers_print(struct seq_file *s, void *p)
 				reg, value);
 			if (err < 0) {
 				dev_err(dev, "seq_printf overflow\n");
-				/* Error is not returned here since
-				 * the output is wanted in any case */
+				/*
+				 * Error is not returned here since
+				 * the output is wanted in any case
+				 */
 				return 0;
 			}
 		}
@@ -537,6 +567,152 @@ static ssize_t ab8500_val_write(struct file *file,
 	return buf_size;
 }
 
+static int ab8500_subscribe_unsubscribe_print(struct seq_file *s, void *p)
+{
+	seq_printf(s, "%d\n", irq_first);
+
+	return 0;
+}
+
+static int ab8500_subscribe_unsubscribe_open(struct inode *inode,
+	struct file *file)
+{
+	return single_open(file, ab8500_subscribe_unsubscribe_print,
+		inode->i_private);
+}
+
+/*
+ * Userspace should use poll() on this file. When an event occur
+ * the blocking poll will be released.
+ */
+static ssize_t show_irq(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	unsigned long name;
+	unsigned int irq_index;
+	int err;
+
+	err = strict_strtoul(attr->attr.name, 0, &name);
+	if (err)
+		return err;
+
+	irq_index = name - irq_first;
+	if (irq_index >= AB8500_NR_IRQS)
+		return -EINVAL;
+	else
+		return sprintf(buf, "%u\n", irq_count[irq_index]);
+}
+
+static ssize_t ab8500_subscribe_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct device *dev = ((struct seq_file *)(file->private_data))->private;
+	char buf[32];
+	int buf_size;
+	unsigned long user_val;
+	int err;
+	unsigned int irq_index;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_val);
+	if (err)
+		return -EINVAL;
+	if (user_val < irq_first) {
+		dev_err(dev, "debugfs error input < %d\n", irq_first);
+		return -EINVAL;
+	}
+	if (user_val > irq_last) {
+		dev_err(dev, "debugfs error input > %d\n", irq_last);
+		return -EINVAL;
+	}
+
+	irq_index = user_val - irq_first;
+	if (irq_index >= AB8500_NR_IRQS)
+		return -EINVAL;
+
+	/*
+	 * This will create a sysfs file named <irq-nr> which userspace can
+	 * use to select or poll and get the AB8500 events
+	 */
+	dev_attr[irq_index] = kmalloc(sizeof(struct device_attribute),
+		GFP_KERNEL);
+	event_name[irq_index] = kmalloc(buf_size, GFP_KERNEL);
+	sprintf(event_name[irq_index], "%lu", user_val);
+	dev_attr[irq_index]->show = show_irq;
+	dev_attr[irq_index]->store = NULL;
+	dev_attr[irq_index]->attr.name = event_name[irq_index];
+	dev_attr[irq_index]->attr.mode = S_IRUGO;
+	err = sysfs_create_file(&dev->kobj, &dev_attr[irq_index]->attr);
+	if (err < 0) {
+		printk(KERN_ERR "sysfs_create_file failed %d\n", err);
+		return err;
+	}
+
+	err = request_threaded_irq(user_val, NULL, ab8500_debug_handler,
+		IRQF_SHARED | IRQF_NO_SUSPEND, "ab8500-debug", &dev->kobj);
+	if (err < 0) {
+		printk(KERN_ERR "request_threaded_irq failed %d, %lu\n",
+			err, user_val);
+		sysfs_remove_file(&dev->kobj, &dev_attr[irq_index]->attr);
+		return err;
+	}
+
+	return buf_size;
+}
+
+static ssize_t ab8500_unsubscribe_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct device *dev = ((struct seq_file *)(file->private_data))->private;
+	char buf[32];
+	int buf_size;
+	unsigned long user_val;
+	int err;
+	unsigned int irq_index;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_val);
+	if (err)
+		return -EINVAL;
+	if (user_val < irq_first) {
+		dev_err(dev, "debugfs error input < %d\n", irq_first);
+		return -EINVAL;
+	}
+	if (user_val > irq_last) {
+		dev_err(dev, "debugfs error input > %d\n", irq_last);
+		return -EINVAL;
+	}
+
+	irq_index = user_val - irq_first;
+	if (irq_index >= AB8500_NR_IRQS)
+		return -EINVAL;
+
+	/* Set irq count to 0 when unsubscribe */
+	irq_count[irq_index] = 0;
+
+	if (dev_attr[irq_index])
+		sysfs_remove_file(&dev->kobj, &dev_attr[irq_index]->attr);
+
+
+	free_irq(user_val, &dev->kobj);
+	kfree(event_name[irq_index]);
+	kfree(dev_attr[irq_index]);
+
+	return buf_size;
+}
+
 static const struct file_operations ab8500_bank_fops = {
 	.open = ab8500_bank_open,
 	.write = ab8500_bank_write,
@@ -564,17 +740,51 @@ static const struct file_operations ab8500_val_fops = {
 	.owner = THIS_MODULE,
 };
 
+static const struct file_operations ab8500_subscribe_fops = {
+	.open = ab8500_subscribe_unsubscribe_open,
+	.write = ab8500_subscribe_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations ab8500_unsubscribe_fops = {
+	.open = ab8500_subscribe_unsubscribe_open,
+	.write = ab8500_unsubscribe_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static struct dentry *ab8500_dir;
 static struct dentry *ab8500_reg_file;
 static struct dentry *ab8500_bank_file;
 static struct dentry *ab8500_address_file;
 static struct dentry *ab8500_val_file;
+static struct dentry *ab8500_subscribe_file;
+static struct dentry *ab8500_unsubscribe_file;
 
 static int __devinit ab8500_debug_probe(struct platform_device *plf)
 {
 	debug_bank = AB8500_MISC;
 	debug_address = AB8500_REV_REG & 0x00FF;
 
+	irq_first = platform_get_irq_byname(plf, "IRQ_FIRST");
+	if (irq_first < 0) {
+		dev_err(&plf->dev, "First irq not found, err %d\n",
+			irq_first);
+		return irq_first;
+	}
+
+	irq_last = platform_get_irq_byname(plf, "IRQ_LAST");
+	if (irq_last < 0) {
+		dev_err(&plf->dev, "Last irq not found, err %d\n",
+			irq_last);
+		return irq_last;
+	}
+
 	ab8500_dir = debugfs_create_dir(AB8500_NAME_STRING, NULL);
 	if (!ab8500_dir)
 		goto exit_no_debugfs;
@@ -600,8 +810,24 @@ static int __devinit ab8500_debug_probe(struct platform_device *plf)
 	if (!ab8500_val_file)
 		goto exit_destroy_address;
 
+	ab8500_subscribe_file = debugfs_create_file("irq-subscribe",
+		(S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev,
+		&ab8500_subscribe_fops);
+	if (!ab8500_subscribe_file)
+		goto exit_destroy_val;
+
+	ab8500_unsubscribe_file = debugfs_create_file("irq-unsubscribe",
+		(S_IRUGO | S_IWUGO), ab8500_dir, &plf->dev,
+		&ab8500_unsubscribe_fops);
+	if (!ab8500_unsubscribe_file)
+		goto exit_destroy_subscribe;
+
 	return 0;
 
+exit_destroy_subscribe:
+	debugfs_remove(ab8500_subscribe_file);
+exit_destroy_val:
+	debugfs_remove(ab8500_val_file);
 exit_destroy_address:
 	debugfs_remove(ab8500_address_file);
 exit_destroy_bank:
@@ -631,8 +857,8 @@ static struct platform_driver ab8500_debug_driver = {
 		.name = "ab8500-debug",
 		.owner = THIS_MODULE,
 	},
-	.probe  = ab8500_debug_probe,
-	.remove = __devexit_p(ab8500_debug_remove)
+	.probe	= ab8500_debug_probe,
+	.remove	= __devexit_p(ab8500_debug_remove)
 };
 
 static int __init ab8500_debug_init(void)
-- 
1.7.2.2

