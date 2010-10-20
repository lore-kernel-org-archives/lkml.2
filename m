Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab0JTBhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:37:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:62723 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab0JTBhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:37:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="565620646"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 5/9] Hardware error device core
Date: Wed, 20 Oct 2010 09:36:56 +0800
Message-Id: <1287538620-7442-6-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware error device is a kind of device which can report hardware
errors.  The examples of hardware error device include APEI GHES, PCIe
AER, etc.

Hardware error device core in this patch provides common services for
various hardware error devices.

Hardware error record data structure is defined to accommodate various
hardware error information.  Several error sections can be
incorporated into one error record to accumulate information for
multiple hardware components related to one error.  For example, for
an error on a device on the secondary side of a PCIe bridge, it is
useful to record error information from PCIe bridge and from the PCIe
device.

To manage various hardware error devices, struct herr_dev is defined
as a "sub-class" of "struct device".  It should be created as the
child device of the "real" hardware error device such as APEI GHES to
represent the hardware error reporting aspect of the device.  The
class of struct herr_dev instances is "error", so that all hardware
error devices can be enumerated via listing all links in
/sys/class/error.

The most important functionality that this patch provided is hardware
error reporting support.  Details is as follow.

A lock-less hardware error record allocator is provided.  So for
hardware error that can be ignored (such as corrected errors), it is
not needed to pre-allocate the error record or allocate the error
record on stack.

After filling in all necessary fields in hardware error record, the
error reporting is quite straightforward, just calling
herr_record_report, parameters are the error record itself and the
corresponding struct herr_dev.  All other special processing including
user space interface is handled by hardware error device core, this
make it much easier to write a hardware error handler.

Because the possibility for two or more hardware parts to go error
simultaneously is quite low, it is not necessary to create one device
file for each hardware error device.  One device file (/dev/error)
which mixed error records from all hardware error devices is created
as the user space interface.  Then, the user space hardware error
daemon can do some further processing (including logging into disk),
based on the hardware error records read from the device file.

Although the in-kernel and user space interface of hardware error
reporting is quite simple, there is some special consideration in
hardware error reporting implementation.

Hardware errors may burst, for example, same hardware errors may be
reported at high rate within a short interval, this will use up all
pre-allocated memory for error reporting, so that other hardware
errors come from same or different hardware device can not be logged.
To deal with this issue, a burst control algorithm is implemented.
The logging rate for errors come from one hardware error device is
throttled based on the available pre-allocated memory for error
reporting.  In this way we can log as many kinds of errors as possible
comes from as many error devices as possible.

This patch is designed by Andi Kleen and Huang Ying.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/char/Kconfig            |    2 
 drivers/char/Makefile           |    2 
 drivers/char/herror/Kconfig     |    4 
 drivers/char/herror/Makefile    |    1 
 drivers/char/herror/herr-core.c |  599 ++++++++++++++++++++++++++++++++++++++++
 include/linux/Kbuild            |    1 
 include/linux/herror.h          |   69 ++++
 include/linux/herror_record.h   |  100 ++++++
 8 files changed, 778 insertions(+)
 create mode 100644 drivers/char/herror/Kconfig
 create mode 100644 drivers/char/herror/Makefile
 create mode 100644 drivers/char/herror/herr-core.c
 create mode 100644 include/linux/herror.h
 create mode 100644 include/linux/herror_record.h

--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1129,5 +1129,7 @@ config RAMOOPS
 	  This enables panic and oops messages to be logged to a circular
 	  buffer in RAM where it can be read back at some later point.
 
+source "drivers/char/herror/Kconfig"
+
 endmenu
 
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -115,6 +115,8 @@ obj-$(CONFIG_RAMOOPS)		+= ramoops.o
 obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
 
+obj-$(CONFIG_HERR_DEV_CORE)	+= herror/
+
 # Files generated that shall be removed upon make clean
 clean-files := consolemap_deftbl.c defkeymap.c
 
--- /dev/null
+++ b/drivers/char/herror/Kconfig
@@ -0,0 +1,4 @@
+config HERR_DEV_CORE
+	bool
+	select LLIST
+	select LLALLOC
--- /dev/null
+++ b/drivers/char/herror/Makefile
@@ -0,0 +1 @@
+obj-y				+= herr-core.o
--- /dev/null
+++ b/drivers/char/herror/herr-core.c
@@ -0,0 +1,599 @@
+/*
+ * Hardware error device core
+ *
+ * Hardware error device is a kind of device which can report hardware
+ * errors.  The examples of hardware error device include APEI GHES,
+ * PCIe AER, etc.
+ *
+ * Hardware error device core provides common services for various
+ * hardware error devices, including hardware error record lock-less
+ * allocator, error reporting mechanism, hardware error device
+ * management, etc.
+ *
+ * Copyright 2010 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation;
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rculist.h>
+#include <linux/mutex.h>
+#include <linux/percpu.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/trace_clock.h>
+#include <linux/uaccess.h>
+#include <linux/poll.h>
+#include <linux/ratelimit.h>
+#include <linux/nmi.h>
+#include <linux/llist.h>
+#include <linux/llalloc.h>
+#include <linux/herror.h>
+
+#define HERR_NOTIFY_BIT			0
+
+static unsigned long herr_flags;
+
+/*
+ * Record list management and error reporting
+ */
+
+struct herr_node {
+	struct llist_head llist;
+	struct herr_record ercd __attribute__((aligned(HERR_MIN_ALIGN)));
+};
+
+#define HERR_NODE_LEN(rcd_len)					\
+	((rcd_len) + sizeof(struct herr_node) - sizeof(struct herr_record))
+
+#define HERR_MIN_ALLOC_ORDER	HERR_MIN_ALIGN_ORDER
+#define HERR_CHUNK_ORDER	0
+#define HERR_CHUNKS_PER_CPU	2
+#define HERR_RCD_LIST_NUM	2
+
+struct herr_rcd_lists {
+	struct llist_head *write;
+	struct llist_head *read;
+	struct llist_head heads[HERR_RCD_LIST_NUM];
+};
+
+static DEFINE_PER_CPU(struct herr_rcd_lists, herr_rcd_lists);
+
+static DEFINE_PER_CPU(struct ll_pool *, herr_ll_pool);
+
+static void herr_rcd_lists_init(void)
+{
+	int cpu, i;
+	struct herr_rcd_lists *lists;
+
+	for_each_possible_cpu(cpu) {
+		lists = per_cpu_ptr(&herr_rcd_lists, cpu);
+		for (i = 0; i < HERR_RCD_LIST_NUM; i++)
+			init_llist_head(&lists->heads[i]);
+		lists->write = &lists->heads[0];
+		lists->read = &lists->heads[1];
+	}
+}
+
+static void herr_pool_fini(void)
+{
+	struct ll_pool *pool;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		pool = per_cpu(herr_ll_pool, cpu);
+		ll_pool_destroy(pool);
+	}
+}
+
+static int herr_pool_init(void)
+{
+	struct ll_pool **pool;
+	int cpu, rc;
+
+	for_each_possible_cpu(cpu) {
+		pool = per_cpu_ptr(&herr_ll_pool, cpu);
+		rc = -ENOMEM;
+		*pool = ll_pool_create(HERR_MIN_ALLOC_ORDER, HERR_CHUNK_ORDER,
+				       HERR_CHUNKS_PER_CPU, cpu_to_node(cpu));
+		if (!*pool)
+			goto err_pool_fini;
+	}
+
+	return 0;
+err_pool_fini:
+	herr_pool_fini();
+	return rc;
+}
+
+/* Max interval: about 2 second */
+#define HERR_BURST_BASE_INTVL	NSEC_PER_USEC
+#define HERR_BURST_MAX_RATIO	21
+#define HERR_BURST_MAX_INTVL						\
+	((1ULL << HERR_BURST_MAX_RATIO) * HERR_BURST_BASE_INTVL)
+/*
+ * Pool size/used ratio considered spare, before this, interval
+ * between error reporting is ignored. After this, minimal interval
+ * needed is increased exponentially to max interval.
+ */
+#define HERR_BURST_SPARE_RATIO	3
+
+static int herr_burst_control(struct herr_dev *edev)
+{
+	struct ll_pool *pool;
+	unsigned long long last, now, min_intvl;
+	unsigned int size, used, ratio;
+
+	pool = __get_cpu_var(herr_ll_pool);
+	size = ll_pool_size(pool);
+	used = size - ll_pool_avail(pool);
+	if (HERR_BURST_SPARE_RATIO * used < size)
+		goto pass;
+	now = trace_clock_local();
+	last = atomic64_read(&edev->timestamp);
+	ratio = (used * HERR_BURST_SPARE_RATIO - size) * HERR_BURST_MAX_RATIO;
+	ratio = ratio / (size * HERR_BURST_SPARE_RATIO - size) + 1;
+	min_intvl = (1ULL << ratio) * HERR_BURST_BASE_INTVL;
+	if ((long long)(now - last) > min_intvl)
+		goto pass;
+	atomic_inc(&edev->bursts);
+	return 0;
+pass:
+	return 1;
+}
+
+static u64 herr_record_next_id(void)
+{
+	static atomic64_t seq = ATOMIC64_INIT(0);
+
+	if (!atomic64_read(&seq))
+		atomic64_set(&seq, (u64)get_seconds() << 32);
+
+	return atomic64_inc_return(&seq);
+}
+
+void herr_record_init(struct herr_record *ercd)
+{
+	ercd->flags = 0;
+	ercd->rev = HERR_RCD_REV1_0;
+	ercd->id = herr_record_next_id();
+	ercd->timestamp = trace_clock_local();
+}
+EXPORT_SYMBOL_GPL(herr_record_init);
+
+struct herr_record *herr_record_alloc(unsigned int len, struct herr_dev *edev,
+				      unsigned int flags)
+{
+	struct ll_pool *pool;
+	struct herr_node *enode;
+	struct herr_record *ercd = NULL;
+
+	preempt_disable();
+	if (!(flags & HERR_ALLOC_NO_BURST_CONTROL)) {
+		if (!herr_burst_control(edev)) {
+			preempt_enable_no_resched();
+			return NULL;
+		}
+	}
+
+	pool = __get_cpu_var(herr_ll_pool);
+	enode = ll_pool_alloc(pool, HERR_NODE_LEN(len));
+	if (enode) {
+		ercd = &enode->ercd;
+		herr_record_init(ercd);
+		ercd->length = len;
+
+		atomic64_set(&edev->timestamp, trace_clock_local());
+		atomic_inc(&edev->logs);
+	} else
+		atomic_inc(&edev->overflows);
+	preempt_enable_no_resched();
+
+	return ercd;
+}
+EXPORT_SYMBOL_GPL(herr_record_alloc);
+
+int herr_record_report(struct herr_record *ercd, struct herr_dev *edev)
+{
+	struct herr_rcd_lists *lists;
+	struct herr_node *enode;
+
+	preempt_disable();
+	lists = this_cpu_ptr(&herr_rcd_lists);
+	enode = container_of(ercd, struct herr_node, ercd);
+	llist_add(&enode->llist, lists->write);
+	preempt_enable_no_resched();
+
+	set_bit(HERR_NOTIFY_BIT, &herr_flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(herr_record_report);
+
+void herr_record_free(struct herr_record *ercd)
+{
+	struct herr_node *enode;
+
+	enode = container_of(ercd, struct herr_node, ercd);
+	ll_pool_free(enode, HERR_NODE_LEN(enode->ercd.length));
+}
+EXPORT_SYMBOL_GPL(herr_record_free);
+
+/*
+ * The low 16 bit is freeze count, high 16 bit is thaw count. If they
+ * are not equal, someone is freezing the reader
+ */
+static u32 herr_freeze_thaw;
+
+/*
+ * Stop the reader to consume error records, so that the error records
+ * can be checked in kernel space safely.
+ */
+static void herr_freeze_reader(void)
+{
+	u32 old, new;
+
+	do {
+		new = old = herr_freeze_thaw;
+		new = ((new + 1) & 0xffff) | (old & 0xffff0000);
+	} while (cmpxchg(&herr_freeze_thaw, old, new) != old);
+}
+
+static void herr_thaw_reader(void)
+{
+	u32 old, new;
+
+	do {
+		old = herr_freeze_thaw;
+		new = old + 0x10000;
+	} while (cmpxchg(&herr_freeze_thaw, old, new) != old);
+}
+
+static int herr_reader_is_frozen(void)
+{
+	u32 freeze_thaw = herr_freeze_thaw;
+	return (freeze_thaw & 0xffff) != (freeze_thaw >> 16);
+}
+
+int herr_for_each_record(herr_traverse_func_t func, void *data)
+{
+	int i, cpu, rc = 0;
+	struct herr_rcd_lists *lists;
+	struct herr_node *enode;
+
+	preempt_disable();
+	herr_freeze_reader();
+	for_each_possible_cpu(cpu) {
+		lists = per_cpu_ptr(&herr_rcd_lists, cpu);
+		for (i = 0; i < HERR_RCD_LIST_NUM; i++) {
+			llist_for_each_entry(enode, &lists->heads[i], llist) {
+				rc = func(&enode->ercd, data);
+				if (rc)
+					goto out;
+			}
+		}
+	}
+out:
+	herr_thaw_reader();
+	preempt_enable_no_resched();
+	return rc;
+}
+EXPORT_SYMBOL_GPL(herr_for_each_record);
+
+static ssize_t herr_rcd_lists_read(char __user *ubuf, size_t usize,
+				   struct mutex *read_mutex)
+{
+	int cpu, rc = 0, read;
+	struct herr_rcd_lists *lists;
+	ssize_t len, rsize = 0;
+	struct herr_node *enode;
+	struct llist_head *old_read, *to_read;
+
+	do {
+		read = 0;
+		for_each_possible_cpu(cpu) {
+			lists = per_cpu_ptr(&herr_rcd_lists, cpu);
+			if (llist_empty(lists->read)) {
+				if (llist_empty(lists->write))
+					continue;
+				/*
+				 * Error records are output in batch, so old
+				 * error records can be output before new ones.
+				 */
+				old_read = lists->read;
+				lists->read = lists->write;
+				lists->write = old_read;
+			}
+			rc = rsize ? 0 : -EBUSY;
+			if (herr_reader_is_frozen())
+				goto out;
+			to_read = llist_del_first(lists->read);
+			if (herr_reader_is_frozen())
+				goto out_readd;
+			enode = llist_entry(to_read, struct herr_node, llist);
+			len = enode->ercd.length;
+			rc = rsize ? 0 : -EINVAL;
+			if (len > usize - rsize)
+				goto out_readd;
+			rc = -EFAULT;
+			if (copy_to_user(ubuf + rsize, &enode->ercd, len))
+				goto out_readd;
+			ll_pool_free(enode, HERR_NODE_LEN(len));
+			rsize += len;
+			read = 1;
+		}
+		if (need_resched()) {
+			mutex_unlock(read_mutex);
+			cond_resched();
+			mutex_lock(read_mutex);
+		}
+	} while (read);
+	rc = 0;
+out:
+	return rc ? rc : rsize;
+out_readd:
+	llist_add(to_read, lists->read);
+	goto out;
+}
+
+static int herr_rcd_lists_is_empty(void)
+{
+	int cpu, i;
+	struct herr_rcd_lists *lists;
+
+	for_each_possible_cpu(cpu) {
+		lists = per_cpu_ptr(&herr_rcd_lists, cpu);
+		for (i = 0; i < HERR_RCD_LIST_NUM; i++) {
+			if (!llist_empty(&lists->heads[i]))
+				return 0;
+		}
+	}
+	return 1;
+}
+
+
+/*
+ * Hardware Error Reporting Device Management
+ */
+
+static ssize_t herr_dev_name_show(struct device *device,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct herr_dev *dev = to_herr_dev(device);
+	return sprintf(buf, "%s\n", dev->name);
+}
+
+static struct device_attribute herr_dev_attr_name =
+	__ATTR(name, 0400, herr_dev_name_show, NULL);
+
+#define HERR_DEV_COUNTER_ATTR(_name)					\
+	static ssize_t herr_dev_##_name##_show(struct device *device,	\
+					       struct device_attribute *attr, \
+					       char *buf)		\
+	{								\
+		struct herr_dev *dev = to_herr_dev(device);		\
+		int counter;						\
+									\
+		counter = atomic_read(&dev->_name);			\
+		return sprintf(buf, "%d\n", counter);			\
+	}								\
+	static ssize_t herr_dev_##_name##_store(struct device *device,	\
+						struct device_attribute *attr, \
+						const char *buf,	\
+						size_t count)		\
+	{								\
+		struct herr_dev *dev = to_herr_dev(device);		\
+									\
+		atomic_set(&dev->_name, 0);				\
+		return count;						\
+	}								\
+	static struct device_attribute herr_dev_attr_##_name =		\
+		__ATTR(_name, 0600, herr_dev_##_name##_show,		\
+		       herr_dev_##_name##_store)
+
+HERR_DEV_COUNTER_ATTR(logs);
+HERR_DEV_COUNTER_ATTR(overflows);
+HERR_DEV_COUNTER_ATTR(bursts);
+
+static struct attribute *herr_dev_attrs[] = {
+	&herr_dev_attr_name.attr,
+	&herr_dev_attr_logs.attr,
+	&herr_dev_attr_overflows.attr,
+	&herr_dev_attr_bursts.attr,
+	NULL,
+};
+
+static struct attribute_group herr_dev_attr_group = {
+	.attrs	= herr_dev_attrs,
+};
+
+static const struct attribute_group *herr_dev_attr_groups[] = {
+	&herr_dev_attr_group,
+	NULL,
+};
+
+static void herr_dev_release(struct device *device)
+{
+	struct herr_dev *dev = to_herr_dev(device);
+
+	kfree(dev);
+}
+
+static struct device_type herr_dev_type = {
+	.groups		= herr_dev_attr_groups,
+	.release	= herr_dev_release,
+};
+
+static char *herr_devnode(struct device *dev, mode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "error/%s", dev_name(dev));
+}
+
+struct class herr_class = {
+	.name		= "error",
+	.devnode	= herr_devnode,
+};
+EXPORT_SYMBOL_GPL(herr_class);
+
+struct herr_dev *herr_dev_alloc(void)
+{
+	struct herr_dev *dev;
+
+	dev = kzalloc(sizeof(struct herr_dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+	dev->dev.type = &herr_dev_type;
+	dev->dev.class = &herr_class;
+	device_initialize(&dev->dev);
+	atomic_set(&dev->logs, 0);
+	atomic_set(&dev->overflows, 0);
+	atomic_set(&dev->bursts, 0);
+	atomic64_set(&dev->timestamp, 0);
+
+	return dev;
+}
+EXPORT_SYMBOL_GPL(herr_dev_alloc);
+
+void herr_dev_free(struct herr_dev *dev)
+{
+	if (dev)
+		herr_dev_put(dev);
+}
+EXPORT_SYMBOL_GPL(herr_dev_free);
+
+int herr_dev_register(struct herr_dev *dev)
+{
+	static atomic_t herr_no = ATOMIC_INIT(0);
+	const char *path;
+	int rc;
+
+	dev_set_name(&dev->dev, "error%d", atomic_inc_return(&herr_no) - 1);
+
+	rc = device_add(&dev->dev);
+	if (rc)
+		goto err;
+
+	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
+	pr_info("error: %s as %s\n", dev->name ? dev->name : "Unspecified device",
+		path ? path : "N/A");
+	kfree(path);
+
+	return 0;
+err:
+	return rc;
+}
+EXPORT_SYMBOL_GPL(herr_dev_register);
+
+void herr_dev_unregister(struct herr_dev *dev)
+{
+	device_unregister(&dev->dev);
+}
+EXPORT_SYMBOL_GPL(herr_dev_unregister);
+
+
+/*
+ * Hardware Error Mix Reporting Device
+ */
+
+static int herr_major;
+static DECLARE_WAIT_QUEUE_HEAD(herr_mix_wait);
+
+void herr_notify(void)
+{
+	if (test_and_clear_bit(HERR_NOTIFY_BIT, &herr_flags))
+		wake_up_interruptible(&herr_mix_wait);
+}
+EXPORT_SYMBOL_GPL(herr_notify);
+
+static ssize_t herr_mix_read(struct file *filp, char __user *ubuf,
+			     size_t usize, loff_t *off)
+{
+	int rc;
+	static DEFINE_MUTEX(read_mutex);
+
+	if (*off != 0)
+		return -EINVAL;
+
+	rc = mutex_lock_interruptible(&read_mutex);
+	if (rc)
+		return rc;
+	rc = herr_rcd_lists_read(ubuf, usize, &read_mutex);
+	mutex_unlock(&read_mutex);
+
+	return rc;
+}
+
+static unsigned int herr_mix_poll(struct file *file, poll_table *wait)
+{
+	poll_wait(file, &herr_mix_wait, wait);
+	if (!herr_rcd_lists_is_empty())
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static const struct file_operations herr_mix_dev_fops = {
+	.owner		= THIS_MODULE,
+	.read		= herr_mix_read,
+	.poll		= herr_mix_poll,
+};
+
+static int __init herr_mix_dev_init(void)
+{
+	struct device *dev;
+	dev_t devt;
+
+	devt = MKDEV(herr_major, 0);
+	dev = device_create(&herr_class, NULL, devt, NULL, "error");
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	return 0;
+}
+device_initcall(herr_mix_dev_init);
+
+static int __init herr_core_init(void)
+{
+	int rc;
+
+	BUILD_BUG_ON(sizeof(struct herr_node) % HERR_MIN_ALIGN);
+	BUILD_BUG_ON(sizeof(struct herr_record) % HERR_MIN_ALIGN);
+	BUILD_BUG_ON(sizeof(struct herr_section) % HERR_MIN_ALIGN);
+
+	herr_rcd_lists_init();
+
+	rc = herr_pool_init();
+	if (rc)
+		goto err;
+
+	rc = class_register(&herr_class);
+	if (rc)
+		goto err_free_pool;
+
+	rc = herr_major = register_chrdev(0, "error", &herr_mix_dev_fops);
+	if (rc < 0)
+		goto err_free_class;
+
+	return 0;
+err_free_class:
+	class_unregister(&herr_class);
+err_free_pool:
+	herr_pool_fini();
+err:
+	return rc;
+}
+/* Initialize data structure used by device driver, so subsys_initcall */
+subsys_initcall(herr_core_init);
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -140,6 +140,7 @@ header-y += gigaset_dev.h
 header-y += hdlc.h
 header-y += hdlcdrv.h
 header-y += hdreg.h
+header-y += herror_record.h
 header-y += hid.h
 header-y += hiddev.h
 header-y += hidraw.h
--- /dev/null
+++ b/include/linux/herror.h
@@ -0,0 +1,69 @@
+#ifndef LINUX_HERROR_H
+#define LINUX_HERROR_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/device.h>
+#include <linux/herror_record.h>
+
+/*
+ * Hardware error reporting
+ */
+
+#define HERR_ALLOC_NO_BURST_CONTROL	0x0001
+
+struct herr_dev;
+
+/* allocate a herr_record lock-lessly */
+struct herr_record *herr_record_alloc(unsigned int len,
+				      struct herr_dev *edev,
+				      unsigned int flags);
+void herr_record_init(struct herr_record *ercd);
+/* report error via error record */
+int herr_record_report(struct herr_record *ercd, struct herr_dev *edev);
+/* free the herr_record allocated before */
+void herr_record_free(struct herr_record *ercd);
+/*
+ * Notify waited user space hardware error daemon for the new error
+ * record, can not be used in NMI context
+ */
+void herr_notify(void);
+
+/* Traverse all error records not consumed by user space */
+typedef int (*herr_traverse_func_t)(struct herr_record *ercd, void *data);
+int herr_for_each_record(herr_traverse_func_t func, void *data);
+
+
+/*
+ * Hardware Error Reporting Device Management
+ */
+extern struct class herr_class;
+
+struct herr_dev {
+	const char *name;
+	atomic_t overflows;
+	atomic_t logs;
+	atomic_t bursts;
+	struct device dev;
+	struct list_head list;
+	atomic64_t timestamp;
+};
+#define to_herr_dev(d)	container_of(d, struct herr_dev, dev)
+
+struct herr_dev *herr_dev_alloc(void);
+void herr_dev_free(struct herr_dev *dev);
+
+static inline struct herr_dev *herr_dev_get(struct herr_dev *dev)
+{
+	return dev ? to_herr_dev(get_device(&dev->dev)) : NULL;
+}
+
+static inline void herr_dev_put(struct herr_dev *dev)
+{
+	if (dev)
+		put_device(&dev->dev);
+}
+
+int herr_dev_register(struct herr_dev *dev);
+void herr_dev_unregister(struct herr_dev *dev);
+#endif
--- /dev/null
+++ b/include/linux/herror_record.h
@@ -0,0 +1,100 @@
+#ifndef LINUX_HERROR_RECORD_H
+#define LINUX_HERROR_RECORD_H
+
+#include <linux/types.h>
+
+/*
+ * Hardware Error Record Definition
+ */
+enum herr_severity {
+	HERR_SEV_NONE,
+	HERR_SEV_CORRECTED,
+	HERR_SEV_RECOVERABLE,
+	HERR_SEV_FATAL,
+};
+
+#define HERR_RCD_REV1_0		0x0100
+#define HERR_MIN_ALIGN_ORDER	3
+#define HERR_MIN_ALIGN		(1 << HERR_MIN_ALIGN_ORDER)
+
+enum herr_record_flags {
+	HERR_RCD_PREV		= 0x0001, /* record is for previous boot */
+	HERR_RCD_PERSIST	= 0x0002, /* record is from flash, need to be
+					   * cleared after writing to disk */
+};
+
+/*
+ * sizeof(struct herr_record) and sizeof(struct herr_section) should
+ * be multiple of HERR_MIN_ALIGN to make error record packing easier.
+ */
+struct herr_record {
+	__u16	length;
+	__u16	flags;
+	__u16	rev;
+	__u8	severity;
+	__u8	pad1;
+	__u64	id;
+	__u64	timestamp;
+	__u8	data[0];
+};
+
+/* Section type ID are allocated here */
+enum herr_section_type_id {
+	/* 0x0 - 0xff are reserved by core */
+	/* 0x100 - 0x1ff are allocated to CPER */
+	HERR_TYPE_CPER		= 0x0100,
+	HERR_TYPE_GESR		= 0x0110, /* acpi_hest_generic_status */
+	/* 0x200 - 0x2ff are allocated to PCI/PCIe subsystem */
+	HERR_TYPE_PCIE_AER	= 0x0200,
+};
+
+struct herr_section {
+	__u16	length;
+	__u16	flags;
+	__u32	type;
+	__u8	data[0];
+};
+
+#define herr_record_for_each_section(ercd, esec)		\
+	for ((esec) = (struct herr_section *)(ercd)->data;	\
+	     (void *)(esec) - (void *)(ercd) < (ercd)->length;	\
+	     (esec) = (void *)(esec) + (esec)->length)
+
+#define HERR_SEC_LEN_ROUND(len)						\
+	(((len) + HERR_MIN_ALIGN - 1) & ~(HERR_MIN_ALIGN - 1))
+#define HERR_SEC_LEN(type)						\
+	(sizeof(struct herr_section) + HERR_SEC_LEN_ROUND(sizeof(type)))
+
+#define HERR_RECORD_LEN_ROUND1(sec_len1)				\
+	(sizeof(struct herr_record) + HERR_SEC_LEN_ROUND(sec_len1))
+#define HERR_RECORD_LEN_ROUND2(sec_len1, sec_len2)			\
+	(sizeof(struct herr_record) + HERR_SEC_LEN_ROUND(sec_len1) +	\
+	 HERR_SEC_LEN_ROUND(sec_len2))
+#define HERR_RECORD_LEN_ROUND3(sec_len1, sec_len2, sec_len3)		\
+	(sizeof(struct herr_record) + HERR_SEC_LEN_ROUND(sec_len1) +	\
+	 HERR_SEC_LEN_ROUND(sec_len2) + HERR_SEC_LEN_ROUND(sec_len3))
+
+#define HERR_RECORD_LEN1(sec_type1)				\
+	(sizeof(struct herr_record) + HERR_SEC_LEN(sec_type1))
+#define HERR_RECORD_LEN2(sec_type1, sec_type2)			\
+	(sizeof(struct herr_record) + HERR_SEC_LEN(sec_type1) + \
+	 HERR_SEC_LEN(sec_type2))
+#define HERR_RECORD_LEN3(sec_type1, sec_type2, sec_type3)	\
+	(sizeof(struct herr_record) + HERR_SEC_LEN(sec_type1) + \
+	 HERR_SEC_LEN(sec_type2) + HERR_SEC_LEN(sec_type3))
+
+static inline struct herr_section *herr_first_sec(struct herr_record *ercd)
+{
+	return (struct herr_section *)(ercd + 1);
+}
+
+static inline struct herr_section *herr_next_sec(struct herr_section *esrc)
+{
+	return (void *)esrc + esrc->length;
+}
+
+static inline void *herr_sec_data(struct herr_section *esec)
+{
+	return (void *)(esec + 1);
+}
+#endif
