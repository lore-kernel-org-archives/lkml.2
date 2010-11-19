Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab0KSIKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 03:10:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:59974 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab0KSIKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 03:10:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,221,1288594800"; 
   d="scan'208";a="350764284"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] Generic hardware error reporting mechanism
Date: Fri, 19 Nov 2010 16:10:32 +0800
Message-Id: <1290154233-28695-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many hardware error detecting and reporting components in
kernel, including x86 Machine Check, PCIe AER, EDAC, APEI GHES
etc. Each one has its error reporting implementation, including user
space interface, error record format, in kernel buffer, etc. This
patch provides a generic hardware error reporting mechanism to reduce
the duplicated effort and add more common services.


A highly extensible generic hardware error record data structure is
defined to accommodate various hardware error information from various
hardware error sources. The overall structure of error record is as
follow:

  -----------------------------------------------------------------
  | rcd hdr | sec 1 hdr | sec 1 data | sec 2 hdr | sec2 data | ...
  -----------------------------------------------------------------

Several error sections can be incorporated into one error record to
accumulate information from multiple hardware components related to
one error.  For example, for an error on a device on the secondary
side of a PCIe bridge, it is useful to record error information from
the PCIe bridge and the PCIe device.  Multiple section can be used to
hold both the cooked and the raw error information.  So that the
abstract information can be provided by the cooked one and no
information will be lost because the raw one is provided too.

There are "reversion" (rev) and "length" field in record header and
"type" and "length" field in section header, so the user space error
daemon can skip unrecognized error record or error section.  This
makes old version error daemon can work with the newer kernel.

New error section type can be added to support new error type, error
sources.


The hardware error reporting mechanism designed by the patch
integrates well with device model in kernel.  struct dev_herr_info is
defined and pointed to by "error" field of struct device.  This is
used to hold error reporting related information for each device.  One
sysfs directory "error" will be created for each hardware error
reporting device.  Some files for error reporting statistics and
control are created in sysfs "error" directory.  For example, the
"error" directory for APEI GHES is as follow.

/sys/devices/platform/GHES.0/error/logs
/sys/devices/platform/GHES.0/error/overflows
/sys/devices/platform/GHES.0/error/throttles

Where "logs" is number of error records logged; "throttles" is number
of error records not logged because the reporting rate is too high;
"overflows" is number of error records not logged because there is no
space available.

Not all devices will report errors, so struct dev_herr_info and sysfs
directory/files are only allocated/created for devices explicitly
enable it.  So to enumerate the error sources of system, you just need
to enumerate "error" directory for each device directory in
/sys/devices.


One device file (/dev/error/error) which mixed error records from all
hardware error reporting devices is created to convey error records
from kernel space to user space.  Because hardware devices are dealt
with, a device file is the most natural way to do that.  Because
hardware error reporting should not hurts system performance, the
throughput of the interface should be controlled to a low level (done
by user space error daemon), ordinary "read" is sufficient from
performance point of view.


The patch provides common services for hardware error reporting
devices too.

A lock-less hardware error record allocator is provided.  So for
hardware error that can be ignored (such as corrected errors), it is
not needed to pre-allocate the error record or allocate the error
record on stack.  Because the possibility for two hardware parts to go
error simultaneously is very small, one big unified memory pool for
hardware errors is better than one memory pool or buffer for each
device.

After filling in all necessary fields in hardware error record, the
error reporting is quite straightforward, just calling
herr_record_report, parameters are the error record itself and the
corresponding struct device.

Hardware errors may burst, for example, same hardware errors may be
reported at high rate within a short interval, this will use up all
pre-allocated memory for error reporting, so that other hardware
errors come from same or different hardware device can not be logged.
To deal with this issue, a throttle algorithm is implemented.  The
logging rate for errors come from one hardware error device is
throttled based on the available pre-allocated memory for error
reporting.  In this way we can log as many kinds of errors as possible
comes from as many devices as possible.


This patch is designed by Andi Kleen and Huang Ying.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/Kconfig               |    2 
 drivers/Makefile              |    1 
 drivers/base/Makefile         |    1 
 drivers/base/herror.c         |   98 ++++++++
 drivers/herror/Kconfig        |    5 
 drivers/herror/Makefile       |    1 
 drivers/herror/herr-core.c    |  488 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/Kbuild          |    1 
 include/linux/device.h        |   14 +
 include/linux/herror.h        |   35 +++
 include/linux/herror_record.h |  100 ++++++++
 kernel/Makefile               |    1 
 12 files changed, 747 insertions(+)
 create mode 100644 drivers/base/herror.c
 create mode 100644 drivers/herror/Kconfig
 create mode 100644 drivers/herror/Makefile
 create mode 100644 drivers/herror/herr-core.c
 create mode 100644 include/linux/herror.h
 create mode 100644 include/linux/herror_record.h

--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -111,4 +111,6 @@ source "drivers/xen/Kconfig"
 source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
+
+source "drivers/herror/Kconfig"
 endmenu
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -115,3 +115,4 @@ obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
 obj-y				+= ieee802154/
+obj-$(CONFIG_HERR_CORE)		+= herror/
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -18,6 +18,7 @@ ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_MODULES)	+= module.o
 endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
+obj-$(CONFIG_HERR_CORE) += herror.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
--- /dev/null
+++ b/drivers/base/herror.c
@@ -0,0 +1,98 @@
+/*
+ * Hardware error reporting related functions
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
+#include <linux/device.h>
+#include <linux/slab.h>
+
+#define HERR_COUNTER_ATTR(_name)					\
+	static ssize_t herr_##_name##_show(struct device *dev,		\
+					   struct device_attribute *attr, \
+					   char *buf)			\
+	{								\
+		int counter;						\
+									\
+		counter = atomic_read(&dev->error->_name);		\
+		return sprintf(buf, "%d\n", counter);			\
+	}								\
+	static ssize_t herr_##_name##_store(struct device *dev,	\
+					    struct device_attribute *attr, \
+					    const char *buf,		\
+					    size_t count)		\
+	{								\
+		atomic_set(&dev->error->_name, 0);			\
+		return count;						\
+	}								\
+	static struct device_attribute herr_attr_##_name =		\
+		__ATTR(_name, 0600, herr_##_name##_show,		\
+		       herr_##_name##_store)
+
+HERR_COUNTER_ATTR(logs);
+HERR_COUNTER_ATTR(overflows);
+HERR_COUNTER_ATTR(throttles);
+
+static struct attribute *herr_attrs[] = {
+	&herr_attr_logs.attr,
+	&herr_attr_overflows.attr,
+	&herr_attr_throttles.attr,
+	NULL,
+};
+
+static struct attribute_group herr_attr_group = {
+	.name	= "error",
+	.attrs	= herr_attrs,
+};
+
+static void device_herr_init(struct device *dev)
+{
+	atomic_set(&dev->error->logs, 0);
+	atomic_set(&dev->error->overflows, 0);
+	atomic_set(&dev->error->throttles, 0);
+	atomic64_set(&dev->error->timestamp, 0);
+}
+
+int device_enable_error_reporting(struct device *dev)
+{
+	int rc;
+
+	BUG_ON(dev->error);
+	dev->error = kzalloc(sizeof(*dev->error), GFP_KERNEL);
+	if (!dev->error)
+		return -ENOMEM;
+	device_herr_init(dev);
+	rc = sysfs_create_group(&dev->kobj, &herr_attr_group);
+	if (rc)
+		goto err;
+	return 0;
+err:
+	kfree(dev->error);
+	dev->error = NULL;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(device_enable_error_reporting);
+
+void device_disable_error_reporting(struct device *dev)
+{
+	if (dev->error) {
+		sysfs_remove_group(&dev->kobj, &herr_attr_group);
+		kfree(dev->error);
+	}
+}
+EXPORT_SYMBOL_GPL(device_disable_error_reporting);
--- /dev/null
+++ b/drivers/herror/Kconfig
@@ -0,0 +1,5 @@
+config HERR_CORE
+	bool "Hardware error reporting"
+	depends on ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select LLIST
+	select GENERIC_ALLOCATOR
--- /dev/null
+++ b/drivers/herror/Makefile
@@ -0,0 +1 @@
+obj-y				+= herr-core.o
--- /dev/null
+++ b/drivers/herror/herr-core.c
@@ -0,0 +1,488 @@
+/*
+ * Generic hardware error reporting support
+ *
+ * This file provides some common services for hardware error
+ * reporting, including hardware error record lock-less allocator,
+ * error reporting mechanism, user space interface etc.
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
+#include <linux/genalloc.h>
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
+	struct llist_node llist;
+	struct herr_record ercd __attribute__((aligned(HERR_MIN_ALIGN)));
+};
+
+#define HERR_NODE_LEN(rcd_len)					\
+	((rcd_len) + sizeof(struct herr_node) - sizeof(struct herr_record))
+
+#define HERR_MIN_ALLOC_ORDER	HERR_MIN_ALIGN_ORDER
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
+static DEFINE_PER_CPU(struct gen_pool *, herr_gen_pool);
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
+	struct gen_pool *pool;
+	struct gen_pool_chunk *chunk;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		pool = per_cpu(herr_gen_pool, cpu);
+		gen_pool_for_each_chunk(chunk, pool)
+			free_page(chunk->start_addr);
+		gen_pool_destroy(pool);
+	}
+}
+
+static int herr_pool_init(void)
+{
+	struct gen_pool **pool;
+	int cpu, rc, nid, i;
+	unsigned long addr;
+
+	for_each_possible_cpu(cpu) {
+		pool = per_cpu_ptr(&herr_gen_pool, cpu);
+		rc = -ENOMEM;
+		nid = cpu_to_node(cpu);
+		*pool = gen_pool_create(HERR_MIN_ALLOC_ORDER, nid);
+		if (!*pool)
+			goto err_pool_fini;
+		for (i = 0; i < HERR_CHUNKS_PER_CPU; i++) {
+			rc = -ENOMEM;
+			addr = __get_free_page(GFP_KERNEL);
+			if (!addr)
+				goto err_pool_fini;
+			rc = gen_pool_add(*pool, addr, PAGE_SIZE, nid);
+			if (rc)
+				goto err_pool_fini;
+		}
+	}
+
+	return 0;
+err_pool_fini:
+	herr_pool_fini();
+	return rc;
+}
+
+/* Max interval: about 2 second */
+#define HERR_THROTTLE_BASE_INTVL	NSEC_PER_USEC
+#define HERR_THROTTLE_MAX_RATIO		21
+#define HERR_THROTTLE_MAX_INTVL						\
+	((1ULL << HERR_THROTTLE_MAX_RATIO) * HERR_THROTTLE_BASE_INTVL)
+/*
+ * Pool size/used ratio considered spare, before this, interval
+ * between error reporting is ignored. After this, minimal interval
+ * needed is increased exponentially to max interval.
+ */
+#define HERR_THROTTLE_SPARE_RATIO	3
+
+static int herr_throttle(struct device *dev)
+{
+	struct gen_pool *pool;
+	unsigned long long last, now, min_intvl;
+	unsigned int size, used, ratio;
+
+	pool = __get_cpu_var(herr_gen_pool);
+	size = gen_pool_size(pool);
+	used = size - gen_pool_avail(pool);
+	if (HERR_THROTTLE_SPARE_RATIO * used < size)
+		goto pass;
+	now = trace_clock_local();
+	last = atomic64_read(&dev->error->timestamp);
+	ratio = (used * HERR_THROTTLE_SPARE_RATIO - size) * \
+		HERR_THROTTLE_MAX_RATIO;
+	ratio = ratio / (size * HERR_THROTTLE_SPARE_RATIO - size) + 1;
+	min_intvl = (1ULL << ratio) * HERR_THROTTLE_BASE_INTVL;
+	if ((long long)(now - last) > min_intvl)
+		goto pass;
+	atomic_inc(&dev->error->throttles);
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
+struct herr_record *herr_record_alloc(unsigned int len, struct device *dev,
+				      unsigned int flags)
+{
+	struct gen_pool *pool;
+	struct herr_node *enode;
+	struct herr_record *ercd = NULL;
+
+	BUG_ON(!dev->error);
+	preempt_disable();
+	if (!(flags & HERR_ALLOC_NO_THROTTLE)) {
+		if (!herr_throttle(dev)) {
+			preempt_enable_no_resched();
+			return NULL;
+		}
+	}
+
+	pool = __get_cpu_var(herr_gen_pool);
+	enode = (struct herr_node *)gen_pool_alloc(pool, HERR_NODE_LEN(len));
+	if (enode) {
+		ercd = &enode->ercd;
+		herr_record_init(ercd);
+		ercd->length = len;
+
+		atomic64_set(&dev->error->timestamp, trace_clock_local());
+		atomic_inc(&dev->error->logs);
+	} else
+		atomic_inc(&dev->error->overflows);
+	preempt_enable_no_resched();
+
+	return ercd;
+}
+EXPORT_SYMBOL_GPL(herr_record_alloc);
+
+int herr_record_report(struct herr_record *ercd, struct device *dev)
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
+	struct gen_pool *pool;
+
+	enode = container_of(ercd, struct herr_node, ercd);
+	pool = get_cpu_var(herr_gen_pool);
+	gen_pool_free(pool, (unsigned long)enode,
+		      HERR_NODE_LEN(enode->ercd.length));
+	put_cpu_var(pool);
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
+			struct llist_head *head = &lists->heads[i];
+			llist_for_each_entry(enode, head->first, llist) {
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
+	struct gen_pool *pool;
+	ssize_t len, rsize = 0;
+	struct herr_node *enode;
+	struct llist_head *old_read;
+	struct llist_node *to_read;
+
+	do {
+		read = 0;
+		for_each_possible_cpu(cpu) {
+			lists = per_cpu_ptr(&herr_rcd_lists, cpu);
+			pool = per_cpu(herr_gen_pool, cpu);
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
+			gen_pool_free(pool, (unsigned long)enode,
+				      HERR_NODE_LEN(len));
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
+ * Hardware Error Mix Reporting Device
+ */
+
+static int herr_major;
+static DECLARE_WAIT_QUEUE_HEAD(herr_mix_wait);
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
@@ -141,6 +141,7 @@ header-y += gigaset_dev.h
 header-y += hdlc.h
 header-y += hdlcdrv.h
 header-y += hdreg.h
+header-y += herror_record.h
 header-y += hid.h
 header-y += hiddev.h
 header-y += hidraw.h
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -394,6 +394,14 @@ extern int devres_release_group(struct d
 extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
 extern void devm_kfree(struct device *dev, void *p);
 
+/* Device hardware error reporting related information */
+struct dev_herr_info {
+	atomic_t logs;
+	atomic_t overflows;
+	atomic_t throttles;
+	atomic64_t timestamp;
+};
+
 struct device_dma_parameters {
 	/*
 	 * a low level driver may set these to teach IOMMU code about
@@ -422,6 +430,9 @@ struct device {
 	void		*platform_data;	/* Platform specific data, device
 					   core doesn't touch it */
 	struct dev_pm_info	power;
+#ifdef CONFIG_HERR_CORE
+	struct dev_herr_info	*error;	/* Hardware error reporting info */
+#endif
 
 #ifdef CONFIG_NUMA
 	int		numa_node;	/* NUMA node this device is close to */
@@ -523,6 +534,9 @@ static inline bool device_async_suspend_
 	return !!dev->power.async_suspend;
 }
 
+extern int device_enable_error_reporting(struct device *dev);
+extern void device_disable_error_reporting(struct device *dev);
+
 static inline void device_lock(struct device *dev)
 {
 	mutex_lock(&dev->mutex);
--- /dev/null
+++ b/include/linux/herror.h
@@ -0,0 +1,35 @@
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
+#define HERR_ALLOC_NO_THROTTLE	0x0001
+
+struct herr_dev;
+
+/* allocate a herr_record lock-lessly */
+struct herr_record *herr_record_alloc(unsigned int len,
+				      struct device *dev,
+				      unsigned int flags);
+void herr_record_init(struct herr_record *ercd);
+/* report error */
+int herr_record_report(struct herr_record *ercd, struct device *dev);
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
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
+obj-$(CONFIG_HERR_CORE) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
