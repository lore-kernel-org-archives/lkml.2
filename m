Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1AUKJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:09:14 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:44208 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab1AUKIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:08:47 -0500
Message-Id: <20110121100842.039354578@linux.vnet.ibm.com>
User-Agent: quilt/0.47-1
Date: Fri, 21 Jan 2011 11:06:53 +0100
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
To: robert.richter@amd.com
Cc: mingo@elte.hu, oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
Subject: [patch v2 2/3] This patch enhances OProfile to support System zs hardware sampling feature
References: <20110121100651.821690659@linux.vnet.ibm.com>
Content-Disposition: inline; filename=oprofile_vfs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>

OProfile is enhanced to export all files for controlling System z's hardware sampling,
and to invoke hwsampler exported functions to initialize and use System z's hardware sampling.

The patch invokes hwsampler_setup() during oprofile init and exports following
hwsampler files under oprofilefs if hwsampler's setup succeeded:

A new directory for hardware sampling based files

 /dev/oprofile/hwsampling/

The userland daemon must explicitly write to the following files
to disable (or enable) hardware based sampling

 /dev/oprofile/hwsampling/hwsampler

to modify the actual sampling rate

 /dev/oprofile/hwsampling/hw_interval

to modify the amount of sampling memory (measured in 4K pages)

 /dev/oprofile/hwsampling/hw_sdbt_blocks

The following files are read only and show
the possible minimum sampling rate

 /dev/oprofile/hwsampling/hw_min_interval

the possible maximum sampling rate

 /dev/oprofile/hwsampling/hw_max_interval

The patch splits the oprofile_timer_[init/exit] function so that it can be also called
through user context (oprofilefs) to avoid kernel oops.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
---
 arch/s390/oprofile/Makefile          |    3 
 arch/s390/oprofile/hwsampler_files.c |  146 +++++++++++++++++++++++++++++++++++
 arch/s390/oprofile/init.c            |    7 +
 drivers/oprofile/oprof.c             |   32 +++++++
 drivers/oprofile/oprof.h             |    2 
 drivers/oprofile/timer_int.c         |   16 +++
 include/linux/oprofile.h             |   21 +++++
 7 files changed, 222 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/s390/oprofile/hwsampler_files.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/s390/oprofile/hwsampler_files.c
@@ -0,0 +1,146 @@
+/**
+ * arch/s390/oprofile/hwsampler_files.c
+ *
+ * Copyright IBM Corp. 2010
+ * Author: Mahesh Salgaonkar (mahesh@linux.vnet.ibm.com)
+ */
+#include <linux/oprofile.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+
+#include "hwsampler.h"
+
+#define DEFAULT_INTERVAL	4096
+
+#define DEFAULT_SDBT_BLOCKS	1
+#define DEFAULT_SDB_BLOCKS	511
+
+static unsigned long oprofile_hw_interval = DEFAULT_INTERVAL;
+static unsigned long oprofile_min_interval;
+static unsigned long oprofile_max_interval;
+
+static unsigned long oprofile_sdbt_blocks = DEFAULT_SDBT_BLOCKS;
+static unsigned long oprofile_sdb_blocks = DEFAULT_SDB_BLOCKS;
+
+static unsigned long oprofile_hwsampler;
+
+static int oprofile_hwsampler_start(void)
+{
+	int retval;
+
+	retval = hwsampler_allocate(oprofile_sdbt_blocks, oprofile_sdb_blocks);
+	if (retval)
+		return retval;
+
+	retval = hwsampler_start_all(oprofile_hw_interval);
+	if (retval)
+		hwsampler_deallocate();
+
+	return retval;
+}
+
+static void oprofile_hwsampler_stop(void)
+{
+	hwsampler_stop_all();
+	hwsampler_deallocate();
+	return;
+}
+
+int oprofile_arch_set_hwsampler(struct oprofile_operations *ops)
+{
+	printk(KERN_INFO "oprofile: using hardware sampling\n");
+	ops->start = oprofile_hwsampler_start;
+	ops->stop = oprofile_hwsampler_stop;
+	ops->cpu_type = "timer";
+
+	return 0;
+}
+
+static ssize_t hwsampler_read(struct file *file, char __user *buf,
+		size_t count, loff_t *offset)
+{
+	return oprofilefs_ulong_to_user(oprofile_hwsampler, buf, count, offset);
+}
+
+static ssize_t hwsampler_write(struct file *file, char const __user *buf,
+		size_t count, loff_t *offset)
+{
+	unsigned long val;
+	int retval;
+
+	if (*offset)
+		return -EINVAL;
+
+	retval = oprofilefs_ulong_from_user(&val, buf, count);
+	if (retval)
+		return retval;
+
+	if (oprofile_hwsampler == val)
+		return -EINVAL;
+
+	retval = oprofile_set_hwsampler(val);
+
+	if (retval)
+		return retval;
+
+	oprofile_hwsampler = val;
+	return count;
+}
+
+static const struct file_operations hwsampler_fops = {
+	.read		= hwsampler_read,
+	.write		= hwsampler_write,
+};
+
+static int oprofile_create_hwsampling_files(struct super_block *sb,
+						struct dentry *root)
+{
+	struct dentry *hw_dir;
+
+	/* reinitialize default values */
+	oprofile_hwsampler = 1;
+
+	hw_dir = oprofilefs_mkdir(sb, root, "hwsampling");
+	if (!hw_dir)
+		return -EINVAL;
+
+	oprofilefs_create_file(sb, hw_dir, "hwsampler", &hwsampler_fops);
+	oprofilefs_create_ulong(sb, hw_dir, "hw_interval",
+				&oprofile_hw_interval);
+	oprofilefs_create_ro_ulong(sb, hw_dir, "hw_min_interval",
+				&oprofile_min_interval);
+	oprofilefs_create_ro_ulong(sb, hw_dir, "hw_max_interval",
+				&oprofile_max_interval);
+	oprofilefs_create_ulong(sb, hw_dir, "hw_sdbt_blocks",
+				&oprofile_sdbt_blocks);
+
+	return 0;
+}
+
+int oprofile_hwsampler_init(struct oprofile_operations* ops)
+{
+	if (hwsampler_setup())
+		return -ENODEV;
+
+	/*
+	 * create hwsampler files only if hwsampler_setup() succeeds.
+	 */
+	ops->create_files = oprofile_create_hwsampling_files;
+	oprofile_min_interval = hwsampler_query_min_interval();
+	if (oprofile_min_interval < 0) {
+		oprofile_min_interval = 0;
+		return -ENODEV;
+	}
+	oprofile_max_interval = hwsampler_query_max_interval();
+	if (oprofile_max_interval < 0) {
+		oprofile_max_interval = 0;
+		return -ENODEV;
+	}
+	oprofile_arch_set_hwsampler(ops);
+	return 0;
+}
+
+void oprofile_hwsampler_exit(void)
+{
+	hwsampler_shutdown();
+}
Index: linux-2.6/drivers/oprofile/oprof.c
===================================================================
--- linux-2.6.orig/drivers/oprofile/oprof.c
+++ linux-2.6/drivers/oprofile/oprof.c
@@ -239,6 +239,38 @@ int oprofile_set_ulong(unsigned long *ad
 	return err;
 }
 
+#ifdef CONFIG_HAVE_HWSAMPLER
+int oprofile_set_hwsampler(unsigned long val)
+{
+	int err = 0;
+
+	mutex_lock(&start_mutex);
+
+	if (oprofile_started) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	switch (val) {
+	case 1:
+		/* Switch to hardware sampling. */
+		__oprofile_timer_exit();
+		err = oprofile_arch_set_hwsampler(&oprofile_ops);
+		break;
+	case 0:
+		printk(KERN_INFO "oprofile: using timer interrupt.\n");
+		err = __oprofile_timer_init(&oprofile_ops);
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+out:
+	mutex_unlock(&start_mutex);
+	return err;
+}
+#endif /* CONFIG_HAVE_HWSAMPLER */
+
 static int __init oprofile_init(void)
 {
 	int err;
Index: linux-2.6/drivers/oprofile/oprof.h
===================================================================
--- linux-2.6.orig/drivers/oprofile/oprof.h
+++ linux-2.6/drivers/oprofile/oprof.h
@@ -35,7 +35,9 @@ struct dentry;
 
 void oprofile_create_files(struct super_block *sb, struct dentry *root);
 int oprofile_timer_init(struct oprofile_operations *ops);
+int __oprofile_timer_init(struct oprofile_operations *ops);
 void oprofile_timer_exit(void);
+void __oprofile_timer_exit(void);
 
 int oprofile_set_ulong(unsigned long *addr, unsigned long val);
 int oprofile_set_timeout(unsigned long time);
Index: linux-2.6/drivers/oprofile/timer_int.c
===================================================================
--- linux-2.6.orig/drivers/oprofile/timer_int.c
+++ linux-2.6/drivers/oprofile/timer_int.c
@@ -97,14 +97,13 @@ static struct notifier_block __refdata o
 	.notifier_call = oprofile_cpu_notify,
 };
 
-int __init oprofile_timer_init(struct oprofile_operations *ops)
+int  __oprofile_timer_init(struct oprofile_operations *ops)
 {
 	int rc;
 
 	rc = register_hotcpu_notifier(&oprofile_cpu_notifier);
 	if (rc)
 		return rc;
-	ops->create_files = NULL;
 	ops->setup = NULL;
 	ops->shutdown = NULL;
 	ops->start = oprofile_hrtimer_start;
@@ -113,7 +112,18 @@ int __init oprofile_timer_init(struct op
 	return 0;
 }
 
-void __exit oprofile_timer_exit(void)
+int __init oprofile_timer_init(struct oprofile_operations *ops)
+{
+	return __oprofile_timer_init(ops);
+}
+
+void __oprofile_timer_exit(void)
 {
 	unregister_hotcpu_notifier(&oprofile_cpu_notifier);
 }
+
+void __exit oprofile_timer_exit(void)
+{
+	__oprofile_timer_exit();
+}
+
Index: linux-2.6/include/linux/oprofile.h
===================================================================
--- linux-2.6.orig/include/linux/oprofile.h
+++ linux-2.6/include/linux/oprofile.h
@@ -89,6 +89,27 @@ int oprofile_arch_init(struct oprofile_o
  */
 void oprofile_arch_exit(void);
 
+#ifdef CONFIG_HAVE_HWSAMPLER
+/**
+ * setup hardware sampler for oprofiling.
+ */
+
+int oprofile_set_hwsampler(unsigned long);
+
+/**
+ * hardware sampler module initialization for the s390 arch
+ */
+
+int oprofile_arch_set_hwsampler(struct oprofile_operations *ops);
+
+/**
+ * Add an s390 hardware sample.
+ */
+void oprofile_add_ext_hw_sample(unsigned long pc, struct pt_regs * const regs,
+	unsigned long event, int is_kernel,
+	struct task_struct *task);
+#endif /* CONFIG_HAVE_HWSAMPLER */
+
 /**
  * Add a sample. This may be called from any context.
  */
Index: linux-2.6/arch/s390/oprofile/init.c
===================================================================
--- linux-2.6.orig/arch/s390/oprofile/init.c
+++ linux-2.6/arch/s390/oprofile/init.c
@@ -11,16 +11,21 @@
 #include <linux/oprofile.h>
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/fs.h>
 
+extern int oprofile_hwsampler_init(struct oprofile_operations* ops);
+extern void oprofile_hwsampler_exit(void);
 
 extern void s390_backtrace(struct pt_regs * const regs, unsigned int depth);
 
 int __init oprofile_arch_init(struct oprofile_operations* ops)
 {
 	ops->backtrace = s390_backtrace;
-	return -ENODEV;
+
+	return oprofile_hwsampler_init(ops);
 }
 
 void oprofile_arch_exit(void)
 {
+	oprofile_hwsampler_exit();
 }
Index: linux-2.6/arch/s390/oprofile/Makefile
===================================================================
--- linux-2.6.orig/arch/s390/oprofile/Makefile
+++ linux-2.6/arch/s390/oprofile/Makefile
@@ -6,4 +6,5 @@ DRIVER_OBJS = $(addprefix ../../../drive
 		oprofilefs.o oprofile_stats.o  \
 		timer_int.o )
 
-oprofile-y				:= $(DRIVER_OBJS) init.o backtrace.o
+oprofile-y				:= $(DRIVER_OBJS) init.o backtrace.o \
+					hwsampler_files.o hwsampler.o

