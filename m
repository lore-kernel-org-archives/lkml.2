Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab1BPLTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 06:19:54 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:47977 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab1BPLT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 06:19:28 -0500
Message-Id: <20110216111923.699465217@linux.vnet.ibm.com>
User-Agent: quilt/0.47-1
Date: Wed, 16 Feb 2011 12:01:20 +0100
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
To: robert.richter@amd.com
Cc: mingo@elte.hu, oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Subject: [patch v2 2/3] Remove hwsampler_files.c and merge its contents into init.c 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,
References: <20110216110118.316927092@linux.vnet.ibm.com>
Content-Disposition: inline; filename=oprofile_merge_init.patch

From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>

I've merged the contents of hwsampler_files.c into according to Robert Richter's comment.
 
Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
---
 arch/s390/oprofile/Makefile          |    2 
 arch/s390/oprofile/hwsampler_files.c |  162 -----------------------------------
 arch/s390/oprofile/init.c            |  161 ++++++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+), 166 deletions(-)

Index: s390/arch/s390/oprofile/init.c
===================================================================
--- s390.orig/arch/s390/oprofile/init.c
+++ s390/arch/s390/oprofile/init.c
@@ -4,19 +4,174 @@
  * S390 Version
  *   Copyright (C) 2003 IBM Deutschland Entwicklung GmbH, IBM Corporation
  *   Author(s): Thomas Spatzier (tspat@de.ibm.com)
+ *   Author(s): Mahesh Salgaonkar (mahesh@linux.vnet.ibm.com)
+ *   Author(s): Heinz Graalfs (graalfs@linux.vnet.ibm.com)
  *
- * @remark Copyright 2002 OProfile authors
+ * @remark Copyright 2002-2011 OProfile authors
  */
 
 #include <linux/oprofile.h>
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/oprofile.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+
+#include "../../../drivers/oprofile/oprof.h"
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
 
-extern int oprofile_hwsampler_init(struct oprofile_operations* ops);
-extern void oprofile_hwsampler_exit(void);
+static unsigned long oprofile_sdbt_blocks = DEFAULT_SDBT_BLOCKS;
+static unsigned long oprofile_sdb_blocks = DEFAULT_SDB_BLOCKS;
+
+static int hwsampler_file;
+static int hwsampler_running;	/* start_mutex must be held to change */
+
+static struct oprofile_operations timer_ops;
 
 extern void s390_backtrace(struct pt_regs * const regs, unsigned int depth);
 
+static int oprofile_hwsampler_start(void)
+{
+	int retval;
+
+	hwsampler_running = hwsampler_file;
+
+	if (!hwsampler_running)
+		return timer_ops.start();
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
+	if (!hwsampler_running) {
+		timer_ops.stop();
+		return;
+	}
+
+	hwsampler_stop_all();
+	hwsampler_deallocate();
+	return;
+}
+
+static ssize_t hwsampler_read(struct file *file, char __user *buf,
+		size_t count, loff_t *offset)
+{
+	return oprofilefs_ulong_to_user(hwsampler_file, buf, count, offset);
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
+	if (oprofile_started)
+		/*
+		 * save to do without locking as we set
+		 * hwsampler_running in start() when start_mutex is
+		 * held
+		 */
+		return -EBUSY;
+
+	hwsampler_file = val;
+
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
+	hwsampler_file = 1;
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
+
+	if (oprofile_timer_init(ops))
+		return -ENODEV;
+
+	printk(KERN_INFO "oprofile: using hardware sampling\n");
+
+	memcpy(&timer_ops, ops, sizeof(timer_ops));
+
+	ops->start = oprofile_hwsampler_start;
+	ops->stop = oprofile_hwsampler_stop;
+	ops->create_files = oprofile_create_hwsampling_files;
+
+	return 0;
+}
+
+void oprofile_hwsampler_exit(void)
+{
+	oprofile_timer_exit();
+	hwsampler_shutdown();
+}
+
 int __init oprofile_arch_init(struct oprofile_operations* ops)
 {
 	ops->backtrace = s390_backtrace;
Index: s390/arch/s390/oprofile/Makefile
===================================================================
--- s390.orig/arch/s390/oprofile/Makefile
+++ s390/arch/s390/oprofile/Makefile
@@ -6,4 +6,4 @@ DRIVER_OBJS = $(addprefix ../../../drive
 		oprofilefs.o oprofile_stats.o  \
 		timer_int.o )
 
-oprofile-y :=	$(DRIVER_OBJS) init.o backtrace.o hwsampler.o hwsampler_files.o
+oprofile-y :=	$(DRIVER_OBJS) init.o backtrace.o hwsampler.o
Index: s390/arch/s390/oprofile/hwsampler_files.c
===================================================================
--- s390.orig/arch/s390/oprofile/hwsampler_files.c
+++ /dev/null
@@ -1,162 +0,0 @@
-/**
- * arch/s390/oprofile/hwsampler_files.c
- *
- * Copyright IBM Corp. 2010
- * Author: Mahesh Salgaonkar (mahesh@linux.vnet.ibm.com)
- */
-#include <linux/oprofile.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-
-#include "../../../drivers/oprofile/oprof.h"
-#include "hwsampler.h"
-
-#define DEFAULT_INTERVAL	4096
-
-#define DEFAULT_SDBT_BLOCKS	1
-#define DEFAULT_SDB_BLOCKS	511
-
-static unsigned long oprofile_hw_interval = DEFAULT_INTERVAL;
-static unsigned long oprofile_min_interval;
-static unsigned long oprofile_max_interval;
-
-static unsigned long oprofile_sdbt_blocks = DEFAULT_SDBT_BLOCKS;
-static unsigned long oprofile_sdb_blocks = DEFAULT_SDB_BLOCKS;
-
-static int hwsampler_file;
-static int hwsampler_running;	/* start_mutex must be held to change */
-
-static struct oprofile_operations timer_ops;
-
-static int oprofile_hwsampler_start(void)
-{
-	int retval;
-
-	hwsampler_running = hwsampler_file;
-
-	if (!hwsampler_running)
-		return timer_ops.start();
-
-	retval = hwsampler_allocate(oprofile_sdbt_blocks, oprofile_sdb_blocks);
-	if (retval)
-		return retval;
-
-	retval = hwsampler_start_all(oprofile_hw_interval);
-	if (retval)
-		hwsampler_deallocate();
-
-	return retval;
-}
-
-static void oprofile_hwsampler_stop(void)
-{
-	if (!hwsampler_running) {
-		timer_ops.stop();
-		return;
-	}
-
-	hwsampler_stop_all();
-	hwsampler_deallocate();
-	return;
-}
-
-static ssize_t hwsampler_read(struct file *file, char __user *buf,
-		size_t count, loff_t *offset)
-{
-	return oprofilefs_ulong_to_user(hwsampler_file, buf, count, offset);
-}
-
-static ssize_t hwsampler_write(struct file *file, char const __user *buf,
-		size_t count, loff_t *offset)
-{
-	unsigned long val;
-	int retval;
-
-	if (*offset)
-		return -EINVAL;
-
-	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
-		return retval;
-
-	if (oprofile_started)
-		/*
-		 * save to do without locking as we set
-		 * hwsampler_running in start() when start_mutex is
-		 * held
-		 */
-		return -EBUSY;
-
-	hwsampler_file = val;
-
-	return count;
-}
-
-static const struct file_operations hwsampler_fops = {
-	.read		= hwsampler_read,
-	.write		= hwsampler_write,
-};
-
-static int oprofile_create_hwsampling_files(struct super_block *sb,
-						struct dentry *root)
-{
-	struct dentry *hw_dir;
-
-	/* reinitialize default values */
-	hwsampler_file = 1;
-
-	hw_dir = oprofilefs_mkdir(sb, root, "hwsampling");
-	if (!hw_dir)
-		return -EINVAL;
-
-	oprofilefs_create_file(sb, hw_dir, "hwsampler", &hwsampler_fops);
-	oprofilefs_create_ulong(sb, hw_dir, "hw_interval",
-				&oprofile_hw_interval);
-	oprofilefs_create_ro_ulong(sb, hw_dir, "hw_min_interval",
-				&oprofile_min_interval);
-	oprofilefs_create_ro_ulong(sb, hw_dir, "hw_max_interval",
-				&oprofile_max_interval);
-	oprofilefs_create_ulong(sb, hw_dir, "hw_sdbt_blocks",
-				&oprofile_sdbt_blocks);
-
-	return 0;
-}
-
-int oprofile_hwsampler_init(struct oprofile_operations* ops)
-{
-	if (hwsampler_setup())
-		return -ENODEV;
-
-	/*
-	 * create hwsampler files only if hwsampler_setup() succeeds.
-	 */
-	oprofile_min_interval = hwsampler_query_min_interval();
-	if (oprofile_min_interval < 0) {
-		oprofile_min_interval = 0;
-		return -ENODEV;
-	}
-	oprofile_max_interval = hwsampler_query_max_interval();
-	if (oprofile_max_interval < 0) {
-		oprofile_max_interval = 0;
-		return -ENODEV;
-	}
-
-	if (oprofile_timer_init(ops))
-		return -ENODEV;
-
-	printk(KERN_INFO "oprofile: using hardware sampling\n");
-
-	memcpy(&timer_ops, ops, sizeof(timer_ops));
-
-	ops->start = oprofile_hwsampler_start;
-	ops->stop = oprofile_hwsampler_stop;
-	ops->create_files = oprofile_create_hwsampling_files;
-
-	return 0;
-}
-
-void oprofile_hwsampler_exit(void)
-{
-	oprofile_timer_exit();
-	hwsampler_shutdown();
-}

