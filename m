Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1KZRbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 12:31:07 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63339 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1KZRbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 12:31:02 -0500
Date: Sat, 26 Nov 2011 18:30:53 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-iio@vger.kernel.org, greg@kroah.com, linux-kernel@vger.kernel.org
Cc: federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: [RFC PATCH 4/7] drivers/zio: add triggers and buffers
Message-ID: <655e7c14811e32cedb718c85c30ced4167eb5447.1322328076.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1322328073.git.rubini@gnudd.com>
In-Reply-To: <cover.1322328073.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds two triggers and one buffer.
The files match commit 7d37663 in git://ohwr.org/misc/zio.git .

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Samuel Iglesias Gonsalvez <siglesia@cern.ch>
Acked-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/zio/buffers/Makefile          |    1 +
 drivers/zio/buffers/zio-buf-kmalloc.c |  273 +++++++++++++++++++++++++++++++++
 drivers/zio/triggers/Makefile         |    2 +
 drivers/zio/triggers/zio-trig-irq.c   |  203 ++++++++++++++++++++++++
 drivers/zio/triggers/zio-trig-timer.c |  193 +++++++++++++++++++++++
 5 files changed, 672 insertions(+), 0 deletions(-)
 create mode 100644 drivers/zio/buffers/Makefile
 create mode 100644 drivers/zio/buffers/zio-buf-kmalloc.c
 create mode 100644 drivers/zio/triggers/Makefile
 create mode 100644 drivers/zio/triggers/zio-trig-irq.c
 create mode 100644 drivers/zio/triggers/zio-trig-timer.c

diff --git a/drivers/zio/buffers/Makefile b/drivers/zio/buffers/Makefile
new file mode 100644
index 0000000..34b2f85
--- /dev/null
+++ b/drivers/zio/buffers/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_ZIO) += zio-buf-kmalloc.o
diff --git a/drivers/zio/buffers/zio-buf-kmalloc.c b/drivers/zio/buffers/zio-buf-kmalloc.c
new file mode 100644
index 0000000..857c044
--- /dev/null
+++ b/drivers/zio/buffers/zio-buf-kmalloc.c
@@ -0,0 +1,273 @@
+/* Alessandro Rubini for CERN, 2011, GNU GPLv2 or later */
+
+/*
+ * This is a kmalloc-based buffer for the ZIO framework. It is used both
+ * as a default when no buffer is selected by applications and as an
+ * example about our our structures and methods are used.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include <linux/zio.h>
+#include <linux/zio-buffer.h>
+#include <linux/zio-trigger.h>
+
+/* This is an instance of a buffer, associated to two cdevs */
+struct zbk_instance {
+	struct zio_bi bi;
+	int nitem;
+	struct list_head list; /* items list and lock */
+	struct spinlock lock;
+};
+#define to_zbki(bi) container_of(bi, struct zbk_instance, bi)
+
+/* The list in the structure above collects a bunch of these */
+struct zbk_item {
+	struct zio_block block;
+	struct list_head list;	/* item list */
+	struct zbk_instance *instance;
+};
+#define to_item(block) container_of(block, struct zbk_item, block);
+
+static DEFINE_ZATTR_STD(ZBUF, zbk_std_zattr) = {
+	ZATTR_REG(zbuf, ZATTR_ZBUF_MAXLEN, S_IRUGO | S_IWUGO, 0x0, 16),
+};
+
+int kmalloc_conf_set(struct kobject *kobj, struct zio_attribute *zattr,
+		uint32_t  usr_val)
+{
+	zattr->value = usr_val;
+	return 0;
+}
+struct zio_sys_operations zbk_sysfs_ops = {
+	.conf_set = kmalloc_conf_set,
+};
+
+
+/* Alloc is called by the trigger (for input) or by f->write (for output) */
+static struct zio_block *zbk_alloc_block(struct zio_bi *bi,
+					 struct zio_control *ctrl,
+					 size_t datalen, gfp_t gfp)
+{
+	struct zbk_instance *zbki = to_zbki(bi);
+	struct zbk_item *item;
+	void *data;
+
+	pr_debug("%s:%d\n", __func__, __LINE__);
+
+	/* alloc item and data. Control remains null at this point */
+	item = kzalloc(sizeof(*item), gfp);
+	data = kmalloc(datalen, gfp);
+	if (!item || !data)
+		goto out_free;
+	item->block.data = data;
+	item->block.datalen = datalen;
+	item->instance = zbki;
+
+	zio_set_ctrl(&item->block, ctrl);
+
+	return &item->block;
+
+out_free:
+	kfree(data);
+	kfree(item);
+	return ERR_PTR(-ENOMEM);
+}
+
+/* Free is called by f->read (for input) or by the trigger (for output) */
+static void zbk_free_block(struct zio_bi *bi, struct zio_block *block)
+{
+	struct zbk_item *item;
+	struct zbk_instance *zbki;
+
+	pr_debug("%s:%d\n", __func__, __LINE__);
+
+	item = to_item(block);
+	zbki = item->instance;
+	kfree(block->data);
+	zio_free_control(zio_get_ctrl(block));
+	kfree(item);
+}
+
+/* When write() stores the first block, we try pushing it */
+static inline int __try_push(struct zio_ti *ti, struct zio_channel *chan,
+			     struct zio_block *block)
+{
+	if (ti->t_op->push_block(ti, chan, block) < 0)
+		return 0;
+	return 1;
+}
+
+/* Store is called by the trigger (for input) or by f->write (for output) */
+static int zbk_store_block(struct zio_bi *bi, struct zio_block *block)
+{
+	struct zbk_instance *zbki = to_zbki(bi);
+	struct zio_channel *chan = bi->chan;
+	struct zbk_item *item;
+	int awake = 0, pushed = 0, output;
+
+	pr_debug("%s:%d (%p, %p)\n", __func__, __LINE__, bi, block);
+
+	if (unlikely(!zio_get_ctrl(block))) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	item = to_item(block);
+	output = (bi->flags & ZIO_DIR) == ZIO_DIR_OUTPUT;
+
+	/* add to the buffer instance or push to the trigger */
+	spin_lock(&zbki->lock);
+	if (zbki->nitem == bi->zattr_set.std_zattr[ZATTR_ZBUF_MAXLEN].value)
+		goto out_unlock;
+	if (!zbki->nitem) {
+		if (unlikely(output))
+			pushed = __try_push(chan->cset->ti, chan, block);
+		else
+			awake = 1;
+	}
+	if (likely(!pushed)) {
+		zbki->nitem++;
+		list_add_tail(&item->list, &zbki->list);
+	}
+	spin_unlock(&zbki->lock);
+
+	/* if input, awake user space */
+	if (awake && ((bi->flags & ZIO_DIR) == ZIO_DIR_INPUT))
+		wake_up_interruptible(&bi->q);
+	return 0;
+
+out_unlock:
+	spin_unlock(&zbki->lock);
+	return -ENOSPC;
+}
+
+/* Retr is called by f->read (for input) or by the trigger (for output) */
+static struct zio_block *zbk_retr_block(struct zio_bi *bi)
+{
+	struct zbk_item *item;
+	struct zbk_instance *zbki;
+	struct zio_ti *ti;
+	struct list_head *first;
+	int awake = 0;
+
+	zbki = to_zbki(bi);
+
+	spin_lock(&zbki->lock);
+	if (list_empty(&zbki->list))
+		goto out_unlock;
+	first = zbki->list.next;
+	item = list_entry(first, struct zbk_item, list);
+	list_del(&item->list);
+	if (zbki->nitem == bi->zattr_set.std_zattr[ZATTR_ZBUF_MAXLEN].value)
+		awake = 1;
+	zbki->nitem--;
+	spin_unlock(&zbki->lock);
+
+	if (awake && ((bi->flags & ZIO_DIR) == ZIO_DIR_OUTPUT))
+		wake_up_interruptible(&bi->q);
+	pr_debug("%s:%d (%p, %p)\n", __func__, __LINE__, bi, item);
+	return &item->block;
+
+out_unlock:
+	spin_unlock(&zbki->lock);
+	/* There is no data in buffer, and we may pull to have data soon */
+	ti = bi->cset->ti;
+	if (ti->t_op->pull_block)
+		ti->t_op->pull_block(ti, bi->chan);
+	pr_debug("%s:%d (%p, %p)\n", __func__, __LINE__, bi, NULL);
+	return NULL;
+}
+
+/* Create is called by zio for each channel electing to use this buffer type */
+static struct zio_bi *zbk_create(struct zio_buffer_type *zbuf,
+	struct zio_channel *chan, fmode_t f_flags)
+{
+	struct zbk_instance *zbki;
+
+	pr_debug("%s:%d\n", __func__, __LINE__);
+
+	zbki = kzalloc(sizeof(*zbki), GFP_KERNEL);
+	if (!zbki)
+		return ERR_PTR(-ENOMEM);
+	spin_lock_init(&zbki->lock);
+	INIT_LIST_HEAD(&zbki->list);
+
+	/* all the fields of zio_bi are initialied by the caller */
+	return &zbki->bi;
+}
+
+/* destroy is called by zio on channel removal or if it changes buffer type */
+static void zbk_destroy(struct zio_bi *bi)
+{
+	struct zbk_instance *zbki = to_zbki(bi);
+	struct zbk_item *item;
+	struct list_head *pos, *tmp;
+
+	pr_debug("%s:%d\n", __func__, __LINE__);
+
+	/* no need to lock here, zio ensures we are not active */
+	list_for_each_safe(pos, tmp, &zbki->list) {
+		item = list_entry(pos, struct zbk_item, list);
+		zbk_free_block(&zbki->bi, &item->block);
+	}
+	kfree(zbki);
+}
+
+static const struct zio_buffer_operations zbk_buffer_ops = {
+	.alloc_block =	zbk_alloc_block,
+	.free_block =	zbk_free_block,
+	.store_block =	zbk_store_block,
+	.retr_block =	zbk_retr_block,
+	.create =	zbk_create,
+	.destroy =	zbk_destroy,
+};
+
+/*
+ * File operations. We only have read and write: mmap is definitely
+ * not suitable here, and open/release are not needed.
+ */
+
+static const struct file_operations zbk_file_ops = {
+	.owner =	THIS_MODULE,
+	.read =		zio_generic_read,
+	.write =	zio_generic_write,
+	.poll =		zio_generic_poll,
+	.release =	zio_generic_release,
+};
+
+static struct zio_buffer_type zbk_buffer = {
+	.owner =	THIS_MODULE,
+	.zattr_set = {
+		.std_zattr = zbk_std_zattr,
+	},
+	.s_op = &zbk_sysfs_ops,
+	.b_op = &zbk_buffer_ops,
+	.f_op = &zbk_file_ops,
+};
+
+static int zbk_init(void)
+{
+	return zio_register_buf(&zbk_buffer, "kmalloc");
+}
+
+static void zbk_exit(void)
+{
+	zio_unregister_buf(&zbk_buffer);
+	/* FIXME REMOVE all instances left */
+}
+
+module_init(zbk_init);
+module_exit(zbk_exit);
+MODULE_AUTHOR("Alessandro Rubini");
+MODULE_LICENSE("GPL");
diff --git a/drivers/zio/triggers/Makefile b/drivers/zio/triggers/Makefile
new file mode 100644
index 0000000..8e24b00
--- /dev/null
+++ b/drivers/zio/triggers/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_ZIO) += zio-trig-timer.o
+obj-$(CONFIG_ZIO) += zio-trig-irq.o
diff --git a/drivers/zio/triggers/zio-trig-irq.c b/drivers/zio/triggers/zio-trig-irq.c
new file mode 100644
index 0000000..ff808cd
--- /dev/null
+++ b/drivers/zio/triggers/zio-trig-irq.c
@@ -0,0 +1,203 @@
+/* Alessandro Rubini for CERN, 2011, GNU GPLv2 or later */
+
+/*
+ * This is a trigger based on an external IRQ. You can specify the IRQ
+ * number or the GPIO number -- then the associated IRQ is used
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+
+#include <linux/zio.h>
+#include <linux/zio-sysfs.h>
+#include <linux/zio-buffer.h>
+#include <linux/zio-trigger.h>
+
+static int zti_irq = -1;
+static int zti_gpio = -1;
+module_param_named(irq, zti_irq, int, 0444);
+module_param_named(gpio, zti_gpio, int, 0444);
+
+enum zti_attrs {
+	ZTI_ATTR_NSAMPLES = 0,
+	ZTI_ATTR_IRQ,
+	ZTI_ATTR_GPIO,
+};
+
+static DEFINE_ZATTR_STD(TRIG, zti_std_attr) = {
+	ZATTR_REG(trig, ZATTR_TRIG_NSAMPLES, S_IRUGO | S_IWUGO,
+		  ZTI_ATTR_NSAMPLES, 16),
+};
+
+static struct zio_attribute zti_ext_attr[] = {
+	ZATTR_EXT_REG("irq", S_IRUGO, ZTI_ATTR_IRQ, -1),
+	ZATTR_EXT_REG("gpio", S_IRUGO, ZTI_ATTR_GPIO, -1),
+};
+int zti_conf_set(struct kobject *kobj, struct zio_attribute *zattr,
+		uint32_t  usr_val)
+{
+	struct zio_ti *ti = to_zio_ti(kobj);
+
+	pr_debug("%s:%d\n", __func__, __LINE__);
+	zattr->value = usr_val;
+	switch (zattr->priv.addr) {
+	case ZTI_ATTR_NSAMPLES:
+		ti->current_ctrl->nsamples = usr_val;
+		break;
+	/* other attributes are read-only */
+	default:
+		pr_err("%s: unknown \"addr\" for configuration\n", __func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+struct zio_sys_operations zti_s_ops = {
+	.conf_set = zti_conf_set,
+};
+
+irqreturn_t zti_handler(int irq, void *dev_id)
+{
+	struct zio_ti *ti = dev_id;
+
+	/* When a trigger fires, we must prepare our control and timestamp */
+	getnstimeofday(&ti->tstamp);
+	zio_fire_trigger(ti);
+	return IRQ_HANDLED;
+}
+
+/*
+ * The trigger operations are the core of a trigger type
+ */
+static int zti_push_block(struct zio_ti *ti, struct zio_channel *chan,
+			  struct zio_block *block)
+{
+	/* software triggers must store pending stuff in chan->t_priv */
+	pr_debug("%s:%d\n", __func__, __LINE__);
+
+	if (chan->active_block)
+		return -EBUSY;
+	chan->active_block = block;
+	return 0;
+}
+
+static int zti_config(struct zio_ti *ti, struct zio_control *ctrl)
+{
+	/* FIXME: config is not supported yet */
+
+	pr_debug("%s:%d\n", __func__, __LINE__);
+	return 0;
+}
+
+static struct zio_ti *zti_create(struct zio_trigger_type *trig,
+				 struct zio_cset *cset,
+				 struct zio_control *ctrl, fmode_t flags)
+{
+	struct zio_ti *ti;
+
+	int ret;
+	pr_debug("%s:%d\n", __func__, __LINE__);
+
+	ti = kzalloc(sizeof(*ti), GFP_KERNEL);
+	if (!ti)
+		return ERR_PTR(-ENOMEM);
+
+	/* The current control is already filled: just set nsamples */
+	ctrl->nsamples = zti_std_attr[ZATTR_TRIG_NSAMPLES].value;
+	ti->current_ctrl = ctrl;
+
+	ret = request_irq(zti_irq, zti_handler, IRQF_SHARED
+			  | IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			  KBUILD_MODNAME, ti);
+	if (ret < 0) {
+		kfree(ti);
+		return ERR_PTR(ret);
+	}
+	return ti;
+}
+
+static void zti_destroy(struct zio_ti *ti)
+{
+	pr_debug("%s:%d\n", __func__, __LINE__);
+	free_irq(zti_irq, &ti);
+	kfree(ti);
+}
+
+static const struct zio_trigger_operations zti_trigger_ops = {
+	.push_block = zti_push_block,
+	.pull_block = NULL,
+	.data_done = zio_generic_data_done,
+	.config = zti_config,
+	.create = zti_create,
+	.destroy = zti_destroy,
+};
+
+static struct zio_trigger_type zti_trigger = {
+	.owner = THIS_MODULE,
+	.zattr_set = {
+		.std_zattr = zti_std_attr,
+		.ext_zattr = zti_ext_attr,
+		.n_ext_attr = ARRAY_SIZE(zti_ext_attr),
+	},
+	.s_op = &zti_s_ops,
+	.t_op = &zti_trigger_ops,
+	.f_op = NULL, /* we use buffer fops */
+};
+
+/*
+ * A validation function, called at insmod and at parameter change
+ */
+static int zti_validate(int irq, int gpio)
+{
+	int ret = 0;
+
+	if (irq != -1 && gpio != -1) {
+		pr_err("%s: only set irq or gpio, not both\n", KBUILD_MODNAME);
+		return -EINVAL;
+	}
+	if (irq == -1 && gpio == -1) {
+		pr_err("%s: please set irq or gpio\n", KBUILD_MODNAME);
+		return -EINVAL;
+	}
+	if (gpio != -1) {
+		irq = gpio_to_irq(gpio);
+		if (irq >= 0)
+			ret  = gpio_request(gpio, KBUILD_MODNAME);
+		else
+			ret = irq;
+	}
+	if (ret < 0) {
+		pr_err("%s: invalid irq/gpio (%i/%i)\n", KBUILD_MODNAME,
+		       gpio, irq);
+		return ret;
+	}
+	zti_irq = irq; /* used at trigger_create time */
+	return 0;
+}
+
+/*
+ * init and exit
+ */
+static int __init zti_init(void)
+{
+	int ret = zti_validate(zti_irq, zti_gpio);
+	if (ret)
+		return ret;
+	return zio_register_trig(&zti_trigger, "irq");
+}
+
+static void __exit zti_exit(void)
+{
+	zio_unregister_trig(&zti_trigger);
+	if (zti_gpio)
+		gpio_free(zti_gpio);
+}
+
+module_init(zti_init);
+module_exit(zti_exit);
+MODULE_AUTHOR("Alessandro Rubini");
+MODULE_LICENSE("GPL");
diff --git a/drivers/zio/triggers/zio-trig-timer.c b/drivers/zio/triggers/zio-trig-timer.c
new file mode 100644
index 0000000..c429ecc
--- /dev/null
+++ b/drivers/zio/triggers/zio-trig-timer.c
@@ -0,0 +1,193 @@
+/* Alessandro Rubini for CERN, 2011, GNU GPLv2 or later */
+
+/*
+ * This is a timer-based trigger for the ZIO framework. It is not
+ * specific to a low-level device (every device can use it) and clearly
+ * multi-instance.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+
+#include <linux/zio.h>
+#include <linux/zio-sysfs.h>
+#include <linux/zio-buffer.h>
+#include <linux/zio-trigger.h>
+
+struct ztt_instance {
+	struct zio_ti ti;
+	struct timer_list timer;
+	unsigned long next_run;
+	unsigned long period;
+};
+#define to_ztt_instance(ti) container_of(ti, struct ztt_instance, ti);
+
+enum zti_attrs { /* names for the "addr" value of sw parameters */
+	ZTT_ATTR_NSAMPLES = 0,
+	ZTT_ATTR_PERIOD,
+};
+
+static DEFINE_ZATTR_STD(TRIG, ztt_std_attr) = {
+	ZATTR_REG(trig, ZATTR_TRIG_NSAMPLES, S_IRUGO | S_IWUGO,
+		  ZTT_ATTR_NSAMPLES, 16),
+};
+
+static struct zio_attribute ztt_ext_attr[] = {
+	ZATTR_EXT_REG("ms-period", S_IRUGO | S_IWUGO,
+		      ZTT_ATTR_PERIOD, 2000),
+};
+int ztt_conf_set(struct kobject *kobj, struct zio_attribute *zattr,
+		uint32_t  usr_val)
+{
+	struct zio_ti *ti = to_zio_ti(kobj);
+	struct ztt_instance *ztt;
+
+	pr_debug("%s:%d\n", __func__, __LINE__);
+	zattr->value = usr_val;
+	switch (zattr->priv.addr) {
+	case ZTT_ATTR_NSAMPLES:
+		ti->current_ctrl->nsamples = usr_val;
+		break;
+	case ZTT_ATTR_PERIOD:
+		ztt = to_ztt_instance(ti);
+		ztt->period = msecs_to_jiffies(usr_val);
+	default:
+		pr_err("%s: unknown \"addr\" for configuration\n", __func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+struct zio_sys_operations ztt_s_ops = {
+	.conf_set = ztt_conf_set,
+};
+
+/* This runs when the timer expires */
+static void ztt_fn(unsigned long arg)
+{
+	struct zio_ti *ti = (void *)arg;
+	struct ztt_instance *ztt_instance;
+
+	/* When a trigger fires, we must prepare our control and timestamp */
+	getnstimeofday(&ti->tstamp);
+	/* FIXME: where is the jiffi count placed? */
+
+	ztt_instance = to_ztt_instance(ti);
+	zio_fire_trigger(ti);
+
+	if (!ztt_instance->period)
+		return; /* one-shot */
+
+	ztt_instance = to_ztt_instance(ti)
+	ztt_instance->next_run += ztt_instance->period;
+	mod_timer(&ztt_instance->timer, ztt_instance->next_run);
+}
+
+/*
+ * The trigger operations are the core of a trigger type
+ */
+static int ztt_push_block(struct zio_ti *ti, struct zio_channel *chan,
+			  struct zio_block *block)
+{
+	/* software triggers must store pending stuff in chan->t_priv */
+	pr_debug("%s:%d\n", __func__, __LINE__);
+
+	if (chan->active_block)
+		return -EBUSY;
+	chan->active_block = block;
+	return 0;
+}
+
+static int ztt_config(struct zio_ti *ti, struct zio_control *ctrl)
+{
+	/* FIXME: config is not supported yet */
+
+	pr_debug("%s:%d\n", __func__, __LINE__);
+	return 0;
+}
+
+static struct zio_ti *ztt_create(struct zio_trigger_type *trig,
+				 struct zio_cset *cset,
+				 struct zio_control *ctrl, fmode_t flags)
+{
+	struct ztt_instance *ztt_instance;
+	struct zio_ti *ti;
+	uint32_t ms;
+
+	pr_debug("%s:%d\n", __func__, __LINE__);
+
+	ztt_instance = kzalloc(sizeof(struct ztt_instance), GFP_KERNEL);
+	if (!ztt_instance)
+		return ERR_PTR(-ENOMEM);
+	ti = &ztt_instance->ti;
+
+	/* The current control is already filled: just set nsamples */
+	ctrl->nsamples = ztt_std_attr[ZATTR_TRIG_NSAMPLES].value;
+	ti->current_ctrl = ctrl;
+
+	/* Fill own fields */
+	setup_timer(&ztt_instance->timer, ztt_fn,
+		    (unsigned long)(&ztt_instance->ti));
+	ztt_instance->next_run = jiffies + HZ;
+	ms = ztt_ext_attr[0].value;
+	ztt_instance->period = msecs_to_jiffies(ms); /* module param */
+
+	/* Start the timer (dangerous: ti is not filled) */
+	mod_timer(&ztt_instance->timer, ztt_instance->next_run);
+
+	return ti;
+}
+
+static void ztt_destroy(struct zio_ti *ti)
+{
+	struct ztt_instance *ztt_instance;
+
+	pr_debug("%s:%d\n", __func__, __LINE__);
+	ztt_instance = to_ztt_instance(ti);
+	del_timer_sync(&ztt_instance->timer);
+	kfree(ti);
+}
+
+static const struct zio_trigger_operations ztt_trigger_ops = {
+	.push_block = ztt_push_block,
+	.pull_block = NULL,
+	.data_done = zio_generic_data_done,
+	.config = ztt_config,
+	.create = ztt_create,
+	.destroy = ztt_destroy,
+};
+
+static struct zio_trigger_type ztt_trigger = {
+	.owner = THIS_MODULE,
+	.zattr_set = {
+		.std_zattr = ztt_std_attr,
+		.ext_zattr = ztt_ext_attr,
+		.n_ext_attr = ARRAY_SIZE(ztt_ext_attr),
+	},
+	.s_op = &ztt_s_ops,
+	.t_op = &ztt_trigger_ops,
+	.f_op = NULL, /* we use buffer fops */
+};
+
+/*
+ * init and exit
+ */
+static int __init ztt_init(void)
+{
+	return zio_register_trig(&ztt_trigger, "timer");
+}
+
+static void __exit ztt_exit(void)
+{
+	zio_unregister_trig(&ztt_trigger);
+}
+
+module_init(ztt_init);
+module_exit(ztt_exit);
+MODULE_AUTHOR("Alessandro Rubini");
+MODULE_LICENSE("GPL");
-- 
1.7.7.2
