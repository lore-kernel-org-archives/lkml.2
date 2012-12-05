Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2LEQLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:11:15 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56729 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab2LEQJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:47 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 41/44] metag: OProfile
Date: Wed, 5 Dec 2012 16:08:59 +0000
Message-ID: <1354723742-6195-42-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add oprofile support for metag.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/Kconfig                    |    1 +
 arch/metag/Makefile                   |    2 +
 arch/metag/oprofile/Makefile          |   16 ++
 arch/metag/oprofile/backtrace.c       |  134 ++++++++++++++++++
 arch/metag/oprofile/backtrace.h       |    6 +
 arch/metag/oprofile/op_model_meta12.c |  242 +++++++++++++++++++++++++++++++++
 6 files changed, 401 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/oprofile/Makefile
 create mode 100644 arch/metag/oprofile/backtrace.c
 create mode 100644 arch/metag/oprofile/backtrace.h
 create mode 100644 arch/metag/oprofile/op_model_meta12.c

diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index 4c731d80..d198c9b 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -26,6 +26,7 @@ config METAG
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_MOD_ARCH_SPECIFIC
+	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS
 	select HAVE_SYSCALL_TRACEPOINTS
 	select IRQ_DOMAIN
diff --git a/arch/metag/Makefile b/arch/metag/Makefile
index d455140..53fc094 100644
--- a/arch/metag/Makefile
+++ b/arch/metag/Makefile
@@ -49,6 +49,8 @@ core-y					+= arch/metag/mm/
 libs-y					+= arch/metag/lib/
 libs-y					+= arch/metag/tbx/
 
+drivers-$(CONFIG_OPROFILE)		+= arch/metag/oprofile/
+
 boot					:= arch/metag/boot
 
 boot_targets				+= uImage
diff --git a/arch/metag/oprofile/Makefile b/arch/metag/oprofile/Makefile
new file mode 100644
index 0000000..4b4ceee
--- /dev/null
+++ b/arch/metag/oprofile/Makefile
@@ -0,0 +1,16 @@
+obj-y		+= oprofile.o
+
+oprofile-core-y	+= buffer_sync.o
+oprofile-core-y	+= cpu_buffer.o
+oprofile-core-y	+= event_buffer.o
+oprofile-core-y	+= oprof.o
+oprofile-core-y	+= oprofile_files.o
+oprofile-core-y	+= oprofile_stats.o
+oprofile-core-y	+= oprofilefs.o
+oprofile-core-y	+= timer_int.o
+
+oprofile-y	+= backtrace.o
+oprofile-y	+= op_model_meta12.o
+oprofile-y	+= $(addprefix ../../../drivers/oprofile/,$(oprofile-core-y))
+
+ccflags-y	+= -Werror
diff --git a/arch/metag/oprofile/backtrace.c b/arch/metag/oprofile/backtrace.c
new file mode 100644
index 0000000..0ae7489
--- /dev/null
+++ b/arch/metag/oprofile/backtrace.c
@@ -0,0 +1,134 @@
+/*
+ * Copyright (C) 2010 Imagination Technologies Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/oprofile.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include "backtrace.h"
+
+#ifdef CONFIG_FRAME_POINTER
+
+#ifdef CONFIG_KALLSYMS
+#include <linux/kallsyms.h>
+#include <linux/module.h>
+
+static unsigned long tbi_boing_addr;
+static unsigned long tbi_boing_size;
+#endif
+
+static void user_backtrace_fp(unsigned long __user *fp, unsigned int depth)
+{
+	while (depth-- && access_ok(VERIFY_READ, fp, 8)) {
+		unsigned long addr;
+		unsigned long __user *fpnew;
+		if (__copy_from_user_inatomic(&addr, fp + 1, sizeof(addr)))
+			break;
+		addr -= 4;
+
+		oprofile_add_trace(addr);
+
+		/* stack grows up, so frame pointers must decrease */
+		if (__copy_from_user_inatomic(&fpnew, fp + 0, sizeof(fpnew)))
+			break;
+		if (fpnew > fp)
+			break;
+		fp = fpnew;
+	}
+}
+
+static void kernel_backtrace_fp(unsigned long *fp, unsigned long *stack,
+				unsigned int depth)
+{
+#ifdef CONFIG_KALLSYMS
+	/* We need to know where TBIBoingVec is and it's size */
+	if (!tbi_boing_addr) {
+		unsigned long size;
+		unsigned long offset;
+		char modname[MODULE_NAME_LEN];
+		char name[KSYM_NAME_LEN];
+		tbi_boing_addr = kallsyms_lookup_name("___TBIBoingVec");
+		if (!tbi_boing_addr)
+			tbi_boing_addr = 1;
+		else if (!lookup_symbol_attrs(tbi_boing_addr, &size,
+						&offset, modname, name))
+			tbi_boing_size = size;
+	}
+#endif
+	/* detect when the frame pointer has been used for other purposes and
+	 * doesn't point to the stack (it may point completely elsewhere which
+	 * kstack_end may not detect).
+	 */
+	while (depth-- && fp >= stack && fp + 8 <= stack + THREAD_SIZE) {
+		unsigned long addr;
+		unsigned long *fpnew;
+
+		addr = fp[1] - 4;
+		if (!__kernel_text_address(addr))
+			break;
+
+		oprofile_add_trace(addr);
+
+		/* stack grows up, so frame pointers must decrease */
+		fpnew = (unsigned long *)fp[0];
+		if (fpnew > fp)
+			break;
+		fp = fpnew;
+
+#ifdef CONFIG_KALLSYMS
+		/* If we've reached TBIBoingVec then we're at an interrupt
+		 * entry point or a syscall entry point. The frame pointer
+		 * points to a pt_regs which can be used to continue tracing on
+		 * the other side of the boing.
+		 */
+		if (tbi_boing_size && addr >= tbi_boing_addr &&
+				addr < tbi_boing_addr + tbi_boing_size) {
+			struct pt_regs *regs = (struct pt_regs *)fp;
+			/* OProfile doesn't understand backtracing into
+			 * userland.
+			 */
+			if (!user_mode(regs) && --depth) {
+				oprofile_add_trace(regs->ctx.CurrPC);
+				metag_backtrace(regs, depth);
+			}
+			break;
+		}
+#endif
+	}
+}
+#else
+static void kernel_backtrace_sp(unsigned long *sp, unsigned int depth)
+{
+	while (!kstack_end(sp)) {
+		unsigned long addr = *sp--;
+
+		if (!__kernel_text_address(addr - 4))
+			continue;
+		if (!depth--)
+			break;
+		oprofile_add_trace(addr);
+	}
+}
+#endif
+
+void metag_backtrace(struct pt_regs * const regs, unsigned int depth)
+{
+#ifdef CONFIG_FRAME_POINTER
+	unsigned long *fp = (unsigned long *)regs->ctx.AX[1].U0;
+	if (user_mode(regs))
+		user_backtrace_fp((unsigned long __user __force *)fp, depth);
+	else
+		kernel_backtrace_fp(fp, task_stack_page(current), depth);
+#else
+	if (!user_mode(regs)) {
+		unsigned long *sp = (unsigned long *)regs->ctx.AX[0].U0;
+		kernel_backtrace_sp(sp, depth);
+	}
+#endif
+}
diff --git a/arch/metag/oprofile/backtrace.h b/arch/metag/oprofile/backtrace.h
new file mode 100644
index 0000000..c0fcc42
--- /dev/null
+++ b/arch/metag/oprofile/backtrace.h
@@ -0,0 +1,6 @@
+#ifndef _METAG_OPROFILE_BACKTRACE_H
+#define _METAG_OPROFILE_BACKTRACE_H
+
+void metag_backtrace(struct pt_regs * const regs, unsigned int depth);
+
+#endif
diff --git a/arch/metag/oprofile/op_model_meta12.c b/arch/metag/oprofile/op_model_meta12.c
new file mode 100644
index 0000000..0cb103c
--- /dev/null
+++ b/arch/metag/oprofile/op_model_meta12.c
@@ -0,0 +1,242 @@
+/*
+ *  Meta version derived from arch/sh/oprofile/op_model_sh7750.c
+ *    Copyright (C) 2008 Imagination Technologies Ltd.
+ *
+ * arch/sh/oprofile/op_model_sh7750.c
+ *
+ * OProfile support for SH7750/SH7750S Performance Counters
+ *
+ * Copyright (C) 2003, 2004  Paul Mundt
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#include <linux/kernel.h>
+#include <linux/oprofile.h>
+#include <linux/profile.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/fs.h>
+#include <asm/uaccess.h>
+#include <asm/io.h>
+#include <asm/metag_mem.h>
+
+#include "backtrace.h"
+
+/*
+ * Meta has 2 perf counters
+ */
+#define NR_CNTRS	2
+
+struct op_counter_config {
+	unsigned long enabled;
+	unsigned long event;
+	unsigned long count;
+	unsigned long unit_mask;
+
+	/* Dummy values for userspace tool compliance */
+	unsigned long kernel;
+	unsigned long user;
+};
+
+static struct op_counter_config ctr[NR_CNTRS];
+
+static u32 meta_read_counter(int counter)
+{
+	u32 val = metag_in32(counter ? PERF_COUNT0 : PERF_COUNT1);
+	return val;
+}
+
+static void meta_write_counter(int counter, u32 val)
+{
+	metag_out32(val, counter ? PERF_COUNT0 : PERF_COUNT1);
+}
+
+/*
+ * Unfortunately we don't have a native exception or interrupt for counter
+ * overflow.
+ *
+ * OProfile on the other hand likes to have samples taken periodically, so
+ * for now we just piggyback the timer interrupt to get the expected
+ * behavior.
+ */
+
+static int meta_timer_notify(struct pt_regs *regs)
+{
+	int i;
+	u32 val, total_val, sub_val;
+	u32 enabled_threads;
+
+	for (i = 0; i < NR_CNTRS; i++) {
+		if (!ctr[i].enabled)
+			continue;
+
+		/* Disable performance monitoring. */
+		enabled_threads = meta_read_counter(i);
+		meta_write_counter(i, 0);
+
+		sub_val = total_val = val = enabled_threads & PERF_COUNT_BITS;
+
+		if (val >= ctr[i].count) {
+			while (val > ctr[i].count) {
+				oprofile_add_sample(regs, i);
+				val -= ctr[i].count;
+			}
+			/* val may be < ctr[i].count but > 0 */
+			sub_val -= val;
+			total_val -= sub_val;
+		}
+
+		/* Enable performance monitoring. */
+		enabled_threads &= (PERF_CTRL_BITS | PERF_THREAD_BITS);
+		enabled_threads = enabled_threads | total_val;
+		meta_write_counter(i, enabled_threads);
+	}
+
+	return 0;
+}
+
+/*
+ * Files will be in a path like:
+ *
+ *  /<oprofilefs mount point>/<counter number>/<file>
+ *
+ * So when dealing with <file>, we look to the parent dentry for the counter
+ * number.
+ */
+static inline int to_counter(struct file *file)
+{
+	long val;
+	const unsigned char *name = file->f_path.dentry->d_parent->d_name.name;
+
+	if (kstrtol(name, 10, &val))
+		return 0;
+
+	return val;
+}
+
+static ssize_t meta_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos, int mask, int shift)
+{
+	int counter = to_counter(file);
+	unsigned long write_val;
+	u32 read_val;
+
+	if (oprofilefs_ulong_from_user(&write_val, buf, count))
+		return -EFAULT;
+
+	read_val = meta_read_counter(counter) & ~mask;
+	write_val <<= shift;
+
+	write_val = read_val | (write_val & mask);
+	meta_write_counter(counter, write_val);
+
+	return count;
+}
+
+/*
+ * These functions handle turning perfomance counters on for particular
+ * threads by writing to files.
+ */
+static ssize_t meta_read_thread(struct file *file, char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	int counter = to_counter(file);
+	u32 val = meta_read_counter(counter);
+
+	val &= PERF_THREAD_BITS;
+	val >>= PERF_THREAD_S;
+
+	return oprofilefs_ulong_to_user((unsigned long)val, buf, count, ppos);
+}
+
+static ssize_t meta_write_thread(struct file *file, const char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	meta_write(file, buf, count, ppos, PERF_THREAD_BITS, PERF_THREAD_S);
+	return count;
+}
+
+static const struct file_operations thread_fops = {
+	.read		= meta_read_thread,
+	.write		= meta_write_thread,
+};
+
+static int meta_perf_counter_create_files(struct super_block *sb,
+					  struct dentry *root)
+{
+	int i;
+
+	for (i = 0; i < NR_CNTRS; i++) {
+		struct dentry *dir;
+		char buf[4];
+
+		snprintf(buf, sizeof(buf), "%d", i);
+		dir = oprofilefs_mkdir(sb, root, buf);
+
+		oprofilefs_create_ulong(sb, dir, "enabled", &ctr[i].enabled);
+		oprofilefs_create_ulong(sb, dir, "event", &ctr[i].event);
+		oprofilefs_create_ulong(sb, dir, "count", &ctr[i].count);
+		oprofilefs_create_file(sb, dir, "unit_mask", &thread_fops);
+
+		/* Dummy entries */
+		oprofilefs_create_ulong(sb, dir, "kernel", &ctr[i].kernel);
+		oprofilefs_create_ulong(sb, dir, "user", &ctr[i].user);
+	}
+
+	return 0;
+}
+
+static int meta_perf_counter_start(void)
+{
+	int i;
+	u32 event, read_val;
+
+	for (i = 0; i < NR_CNTRS; i++) {
+		if (!ctr[i].enabled)
+			continue;
+
+		event = ctr[i].event << PERF_CTRL_S;
+		read_val = meta_read_counter(i) & ~PERF_CTRL_BITS;
+		meta_write_counter(i, read_val | event);
+	}
+
+	return register_timer_hook(meta_timer_notify);
+}
+
+static void meta_perf_counter_stop(void)
+{
+	u32 val;
+
+	val = meta_read_counter(0) & ~PERF_THREAD_BITS;
+	meta_write_counter(0, val);
+
+	val = meta_read_counter(1) & ~PERF_THREAD_BITS;
+	meta_write_counter(1, val);
+
+	unregister_timer_hook(meta_timer_notify);
+}
+
+int __init oprofile_arch_init(struct oprofile_operations *ops)
+{
+	ops->cpu_type = "metag";
+	ops->create_files = meta_perf_counter_create_files;
+	ops->start = meta_perf_counter_start;
+	ops->stop = meta_perf_counter_stop;
+	ops->backtrace = metag_backtrace;
+
+	pr_info("oprofile: using %s performance monitoring.\n", ops->cpu_type);
+
+	/* Clear the counters. */
+	meta_write_counter(0, 0);
+	meta_write_counter(1, 0);
+
+	return 0;
+}
+
+void oprofile_arch_exit(void)
+{
+}
+
-- 
1.7.7.6


