Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab1EZQs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:48:28 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:45859 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab1EZQs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:48:27 -0400
Message-Id: <201105261648.p4QGmNKf001636@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 26 May 2011 12:40:09 -0400
Subject: [PATCH v2] arch/tile: more /proc and /sys file support
In-Reply-To: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com>
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com> <201105202159.50780.arnd@arndb.de> <4DDD55ED.2080607@tilera.com> <201105252220.23948.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
X-OriginalArrivalTime: 26 May 2011 16:48:25.0992 (UTC) FILETIME=[BB7C3080:01CC1BC4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change introduces a few of the less controversial /proc and
/proc/sys interfaces for tile, along with sysfs attributes for
various things that were originally proposed as /proc/tile files.
It also adjusts the "hardwall" proc API.

Arnd Bergmann reviewed the initial arch/tile submission, which
included a complete set of all the /proc/tile and /proc/sys/tile
knobs that we had added in a somewhat ad hoc way during initial
development, and provided feedback on where most of them should go.

One knob turned out to be similar enough to the existing
/proc/sys/debug/exception-trace that it was re-implemented to use
that model instead.

Another knob was /proc/tile/grid, which reported the "grid" dimensions
of a tile chip (e.g. 8x8 processors = 64-core chip).  Arnd suggested
looking at sysfs for that, so this change moves that information
to a pair of sysfs attributes (chip_width and chip_height) in the
/sys/devices/system/cpu directory.  We also put the "chip_serial"
and "chip_revision" information from our old /proc/tile/board file
as attributes in /sys/devices/system/cpu.

Other information collected via hypervisor APIs is now placed in
/sys/hypervisor.  We create a /sys/hypervisor/type file (holding the
constant string "tilera") to be parallel with the Xen use of
/sys/hypervisor/type holding "xen".  We create three top-level files,
"version" (the hypervisor's own version), "config_version" (the
version of the configuration file), and "hvconfig" (the contents of
the configuration file).  The remaining information from our old
/proc/tile/board and /proc/tile/switch files becomes an attribute
group appearing under /sys/hypervisor/board/.

Finally, after some feedback from Arnd Berghamm for the previous
version of this patch, the /proc/tile/hardwall file is split up into
two conceptual parts.  First, a directory /proc/tile/hardwall/ which
contains one file per active hardwall, each file named after the
hardwall's ID and holding a cpulist that says which cpus are enclosed by
the hardwall.  Second, a /proc/PID file "hardwall" that is either
empty (for non-hardwall-using processes) or contains the hardwall ID.

Finally, this change pushes the /proc/sys/tile/unaligned_fixup/
directory, with knobs controlling the kernel code for handling the
fixup of unaligned exceptions.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                |    1 +
 arch/tile/include/asm/hardwall.h |   15 +++-
 arch/tile/kernel/Makefile        |    2 +-
 arch/tile/kernel/hardwall.c      |   90 ++++++++++++++-----
 arch/tile/kernel/proc.c          |   73 +++++++++++++++
 arch/tile/kernel/sysfs.c         |  185 ++++++++++++++++++++++++++++++++++++++
 fs/proc/base.c                   |    9 ++
 7 files changed, 347 insertions(+), 28 deletions(-)
 create mode 100644 arch/tile/kernel/sysfs.c

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 635e1bf..3f7d63c 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -12,6 +12,7 @@ config TILE
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select SYS_HYPERVISOR
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/arch/tile/include/asm/hardwall.h b/arch/tile/include/asm/hardwall.h
index 0bed3ec..2ac4228 100644
--- a/arch/tile/include/asm/hardwall.h
+++ b/arch/tile/include/asm/hardwall.h
@@ -40,6 +40,10 @@
 #define HARDWALL_DEACTIVATE \
  _IO(HARDWALL_IOCTL_BASE, _HARDWALL_DEACTIVATE)
 
+#define _HARDWALL_GET_ID 4
+#define HARDWALL_GET_ID \
+ _IO(HARDWALL_IOCTL_BASE, _HARDWALL_GET_ID)
+
 #ifndef __KERNEL__
 
 /* This is the canonical name expected by userspace. */
@@ -47,9 +51,14 @@
 
 #else
 
-/* Hook for /proc/tile/hardwall. */
-struct seq_file;
-int proc_tile_hardwall_show(struct seq_file *sf, void *v);
+/* /proc hooks for hardwall. */
+struct proc_dir_entry;
+#ifdef CONFIG_HARDWALL
+void proc_tile_hardwall_init(struct proc_dir_entry *root);
+int proc_pid_hardwall(struct task_struct *task, char *buffer);
+#else
+static inline void proc_tile_hardwall_init(struct proc_dir_entry *root) {}
+#endif
 
 #endif
 
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index b4c8e8e..b4dbc05 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -5,7 +5,7 @@
 extra-y := vmlinux.lds head_$(BITS).o
 obj-y := backtrace.o entry.o init_task.o irq.o messaging.o \
 	pci-dma.o proc.o process.o ptrace.o reboot.o \
-	setup.o signal.o single_step.o stack.o sys.o time.o traps.o \
+	setup.o signal.o single_step.o stack.o sys.o sysfs.o time.o traps.o \
 	intvec_$(BITS).o regs_$(BITS).o tile-desc_$(BITS).o
 
 obj-$(CONFIG_HARDWALL)		+= hardwall.o
diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index 3bddef7..8c41891 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -40,16 +40,25 @@
 struct hardwall_info {
 	struct list_head list;             /* "rectangles" list */
 	struct list_head task_head;        /* head of tasks in this hardwall */
+	struct cpumask cpumask;            /* cpus in the rectangle */
 	int ulhc_x;                        /* upper left hand corner x coord */
 	int ulhc_y;                        /* upper left hand corner y coord */
 	int width;                         /* rectangle width */
 	int height;                        /* rectangle height */
+	int id;                            /* integer id for this hardwall */
 	int teardown_in_progress;          /* are we tearing this one down? */
 };
 
 /* Currently allocated hardwall rectangles */
 static LIST_HEAD(rectangles);
 
+/* /proc/tile/hardwall */
+static struct proc_dir_entry *hardwall_proc_dir;
+
+/* Functions to manage files in /proc/tile/hardwall. */
+static void hardwall_add_proc(struct hardwall_info *rect);
+static void hardwall_remove_proc(struct hardwall_info *rect);
+
 /*
  * Guard changes to the hardwall data structures.
  * This could be finer grained (e.g. one lock for the list of hardwall
@@ -105,6 +114,8 @@ static int setup_rectangle(struct hardwall_info *r, struct cpumask *mask)
 	r->ulhc_y = cpu_y(ulhc);
 	r->width = cpu_x(lrhc) - r->ulhc_x + 1;
 	r->height = cpu_y(lrhc) - r->ulhc_y + 1;
+	cpumask_copy(&r->cpumask, mask);
+	r->id = ulhc;   /* The ulhc cpu id can be the hardwall id. */
 
 	/* Width and height must be positive */
 	if (r->width <= 0 || r->height <= 0)
@@ -388,6 +399,9 @@ static struct hardwall_info *hardwall_create(
 	/* Set up appropriate hardwalling on all affected cpus. */
 	hardwall_setup(rect);
 
+	/* Create a /proc/tile/hardwall entry. */
+	hardwall_add_proc(rect);
+
 	return rect;
 }
 
@@ -645,6 +659,9 @@ static void hardwall_destroy(struct hardwall_info *rect)
 	/* Restart switch and disable firewall. */
 	on_each_cpu_mask(&mask, restart_udn_switch, NULL, 1);
 
+	/* Remove the /proc/tile/hardwall entry. */
+	hardwall_remove_proc(rect);
+
 	/* Now free the rectangle from the list. */
 	spin_lock_irqsave(&hardwall_lock, flags);
 	BUG_ON(!list_empty(&rect->task_head));
@@ -654,35 +671,57 @@ static void hardwall_destroy(struct hardwall_info *rect)
 }
 
 
-/*
- * Dump hardwall state via /proc; initialized in arch/tile/sys/proc.c.
- */
-int proc_tile_hardwall_show(struct seq_file *sf, void *v)
+static int hardwall_proc_show(struct seq_file *sf, void *v)
 {
-	struct hardwall_info *r;
+	struct hardwall_info *rect = sf->private;
+	char buf[256];
 
-	if (udn_disabled) {
-		seq_printf(sf, "%dx%d 0,0 pids:\n", smp_width, smp_height);
-		return 0;
-	}
-
-	spin_lock_irq(&hardwall_lock);
-	list_for_each_entry(r, &rectangles, list) {
-		struct task_struct *p;
-		seq_printf(sf, "%dx%d %d,%d pids:",
-			   r->width, r->height, r->ulhc_x, r->ulhc_y);
-		list_for_each_entry(p, &r->task_head, thread.hardwall_list) {
-			unsigned int cpu = cpumask_first(&p->cpus_allowed);
-			unsigned int x = cpu % smp_width;
-			unsigned int y = cpu / smp_width;
-			seq_printf(sf, " %d@%d,%d", p->pid, x, y);
-		}
-		seq_printf(sf, "\n");
-	}
-	spin_unlock_irq(&hardwall_lock);
+	int rc = cpulist_scnprintf(buf, sizeof(buf), &rect->cpumask);
+	buf[rc++] = '\n';
+	seq_write(sf, buf, rc);
 	return 0;
 }
 
+static int hardwall_proc_open(struct inode *inode,
+			      struct file *file)
+{
+	return single_open(file, hardwall_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations hardwall_proc_fops = {
+	.open		= hardwall_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void hardwall_add_proc(struct hardwall_info *rect)
+{
+	char buf[64];
+	snprintf(buf, sizeof(buf), "%d", rect->id);
+	proc_create_data(buf, 0444, hardwall_proc_dir,
+			 &hardwall_proc_fops, rect);
+}
+
+static void hardwall_remove_proc(struct hardwall_info *rect)
+{
+	char buf[64];
+	snprintf(buf, sizeof(buf), "%d", rect->id);
+	remove_proc_entry(buf, hardwall_proc_dir);
+}
+
+int proc_pid_hardwall(struct task_struct *task, char *buffer)
+{
+	struct hardwall_info *rect = task->thread.hardwall;
+	return rect ? sprintf(buffer, "%d\n", rect->id) : 0;
+}
+
+void proc_tile_hardwall_init(struct proc_dir_entry *root)
+{
+	if (!udn_disabled)
+		hardwall_proc_dir = proc_mkdir("hardwall", root);
+}
+
 
 /*
  * Character device support via ioctl/close.
@@ -716,6 +755,9 @@ static long hardwall_ioctl(struct file *file, unsigned int a, unsigned long b)
 			return -EINVAL;
 		return hardwall_deactivate(current);
 
+	case _HARDWALL_GET_ID:
+		return rect ? rect->id : -EINVAL;
+
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
index 2e02c41..62d8208 100644
--- a/arch/tile/kernel/proc.c
+++ b/arch/tile/kernel/proc.c
@@ -27,6 +27,7 @@
 #include <asm/processor.h>
 #include <asm/sections.h>
 #include <asm/homecache.h>
+#include <asm/hardwall.h>
 #include <arch/chip.h>
 
 
@@ -88,3 +89,75 @@ const struct seq_operations cpuinfo_op = {
 	.stop	= c_stop,
 	.show	= show_cpuinfo,
 };
+
+/*
+ * Support /proc/tile directory
+ */
+
+static int __init proc_tile_init(void)
+{
+	struct proc_dir_entry *root = proc_mkdir("tile", NULL);
+	if (root == NULL)
+		return 0;
+
+	proc_tile_hardwall_init(root);
+
+	return 0;
+}
+
+arch_initcall(proc_tile_init);
+
+/*
+ * Support /proc/sys/tile directory
+ */
+
+#ifndef __tilegx__  /* FIXME: GX: no support for unaligned access yet */
+static ctl_table unaligned_subtable[] = {
+	{
+		.procname	= "enabled",
+		.data		= &unaligned_fixup,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec
+	},
+	{
+		.procname	= "printk",
+		.data		= &unaligned_printk,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec
+	},
+	{
+		.procname	= "count",
+		.data		= &unaligned_fixup_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec
+	},
+	{}
+};
+
+static ctl_table unaligned_table[] = {
+	{
+		.procname	= "unaligned_fixup",
+		.mode		= 0555,
+		.child		= unaligned_subtable
+	},
+	{}
+};
+#endif
+
+static struct ctl_path tile_path[] = {
+	{ .procname = "tile" },
+	{ }
+};
+
+static int __init proc_sys_tile_init(void)
+{
+#ifndef __tilegx__  /* FIXME: GX: no support for unaligned access yet */
+	register_sysctl_paths(tile_path, unaligned_table);
+#endif
+	return 0;
+}
+
+arch_initcall(proc_sys_tile_init);
diff --git a/arch/tile/kernel/sysfs.c b/arch/tile/kernel/sysfs.c
new file mode 100644
index 0000000..b671a86
--- /dev/null
+++ b/arch/tile/kernel/sysfs.c
@@ -0,0 +1,185 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * /sys entry support.
+ */
+
+#include <linux/sysdev.h>
+#include <linux/cpu.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <hv/hypervisor.h>
+
+/* Return a string queried from the hypervisor, truncated to page size. */
+static ssize_t get_hv_confstr(char *page, int query)
+{
+	ssize_t n = hv_confstr(query, (unsigned long)page, PAGE_SIZE - 1);
+	n = n < 0 ? 0 : min(n, (ssize_t)PAGE_SIZE - 1) - 1;
+	if (n)
+		page[n++] = '\n';
+	page[n] = '\0';
+	return n;
+}
+
+static ssize_t chip_width_show(struct sysdev_class *dev,
+			       struct sysdev_class_attribute *attr,
+			       char *page)
+{
+	return sprintf(page, "%u\n", smp_width);
+}
+static SYSDEV_CLASS_ATTR(chip_width, 0444, chip_width_show, NULL);
+
+static ssize_t chip_height_show(struct sysdev_class *dev,
+				struct sysdev_class_attribute *attr,
+				char *page)
+{
+	return sprintf(page, "%u\n", smp_height);
+}
+static SYSDEV_CLASS_ATTR(chip_height, 0444, chip_height_show, NULL);
+
+static ssize_t chip_serial_show(struct sysdev_class *dev,
+				struct sysdev_class_attribute *attr,
+				char *page)
+{
+	return get_hv_confstr(page, HV_CONFSTR_CHIP_SERIAL_NUM);
+}
+static SYSDEV_CLASS_ATTR(chip_serial, 0444, chip_serial_show, NULL);
+
+static ssize_t chip_revision_show(struct sysdev_class *dev,
+				  struct sysdev_class_attribute *attr,
+				  char *page)
+{
+	return get_hv_confstr(page, HV_CONFSTR_CHIP_REV);
+}
+static SYSDEV_CLASS_ATTR(chip_revision, 0444, chip_revision_show, NULL);
+
+
+static ssize_t type_show(struct sysdev_class *dev,
+			    struct sysdev_class_attribute *attr,
+			    char *page)
+{
+	return sprintf(page, "tilera\n");
+}
+static SYSDEV_CLASS_ATTR(type, 0444, type_show, NULL);
+
+#define HV_CONF_ATTR(name, conf)					\
+	static ssize_t name ## _show(struct sysdev_class *dev,		\
+				     struct sysdev_class_attribute *attr, \
+				     char *page)			\
+	{								\
+		return get_hv_confstr(page, conf);			\
+	}								\
+	static SYSDEV_CLASS_ATTR(name, 0444, name ## _show, NULL);
+
+HV_CONF_ATTR(version,		HV_CONFSTR_HV_SW_VER)
+HV_CONF_ATTR(config_version,	HV_CONFSTR_HV_CONFIG_VER)
+
+HV_CONF_ATTR(board_part,	HV_CONFSTR_BOARD_PART_NUM)
+HV_CONF_ATTR(board_serial,	HV_CONFSTR_BOARD_SERIAL_NUM)
+HV_CONF_ATTR(board_revision,	HV_CONFSTR_BOARD_REV)
+HV_CONF_ATTR(board_description,	HV_CONFSTR_BOARD_DESC)
+HV_CONF_ATTR(mezz_part,		HV_CONFSTR_MEZZ_PART_NUM)
+HV_CONF_ATTR(mezz_serial,	HV_CONFSTR_MEZZ_SERIAL_NUM)
+HV_CONF_ATTR(mezz_revision,	HV_CONFSTR_MEZZ_REV)
+HV_CONF_ATTR(mezz_description,	HV_CONFSTR_MEZZ_DESC)
+HV_CONF_ATTR(switch_control,	HV_CONFSTR_SWITCH_CONTROL)
+
+static struct attribute *board_attrs[] = {
+	&attr_board_part.attr,
+	&attr_board_serial.attr,
+	&attr_board_revision.attr,
+	&attr_board_description.attr,
+	&attr_mezz_part.attr,
+	&attr_mezz_serial.attr,
+	&attr_mezz_revision.attr,
+	&attr_mezz_description.attr,
+	&attr_switch_control.attr,
+	NULL
+};
+
+static struct attribute_group board_attr_group = {
+	.name   = "board",
+	.attrs  = board_attrs,
+};
+
+
+static struct bin_attribute hvconfig_bin;
+
+static ssize_t
+hvconfig_bin_read(struct file *filp, struct kobject *kobj,
+		  struct bin_attribute *bin_attr,
+		  char *buf, loff_t off, size_t count)
+{
+	static size_t size;
+
+	/* Lazily learn the true size (minus the trailing NUL). */
+	if (size == 0)
+		size = hv_confstr(HV_CONFSTR_HV_CONFIG, 0, 0) - 1;
+
+	/* Check and adjust input parameters. */
+	if (off > size)
+		return -EINVAL;
+	if (count > size - off)
+		count = size - off;
+
+	if (count) {
+		/* Get a copy of the hvc and copy out the relevant portion. */
+		char *hvc;
+
+		size = off + count;
+		hvc = kmalloc(size, GFP_KERNEL);
+		if (hvc == NULL)
+			return -ENOMEM;
+		hv_confstr(HV_CONFSTR_HV_CONFIG, (unsigned long)hvc, size);
+		memcpy(buf, hvc + off, count);
+		kfree(hvc);
+	}
+
+	return count;
+}
+
+static int __init create_sysfs_entries(void)
+{
+	struct sysdev_class *cls = &cpu_sysdev_class;
+	int err = 0;
+
+#define create_cpu_attr(name)						\
+	if (!err)							\
+		err = sysfs_create_file(&cls->kset.kobj, &attr_##name.attr);
+	create_cpu_attr(chip_width);
+	create_cpu_attr(chip_height);
+	create_cpu_attr(chip_serial);
+	create_cpu_attr(chip_revision);
+
+#define create_hv_attr(name)						\
+	if (!err)							\
+		err = sysfs_create_file(hypervisor_kobj, &attr_##name.attr);
+	create_hv_attr(type);
+	create_hv_attr(version);
+	create_hv_attr(config_version);
+
+	if (!err)
+		err = sysfs_create_group(hypervisor_kobj, &board_attr_group);
+
+	if (!err) {
+		sysfs_bin_attr_init(&hvconfig_bin);
+		hvconfig_bin.attr.name = "hvconfig";
+		hvconfig_bin.attr.mode = S_IRUGO;
+		hvconfig_bin.read = hvconfig_bin_read;
+		hvconfig_bin.size = PAGE_SIZE;
+		err = sysfs_create_bin_file(hypervisor_kobj, &hvconfig_bin);
+	}
+
+	return err;
+}
+subsys_initcall(create_sysfs_entries);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index dfa5327..3ad615f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -83,6 +83,9 @@
 #include <linux/pid_namespace.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
+#ifdef CONFIG_HARDWALL
+#include <asm/hardwall.h>
+#endif
 #include "internal.h"
 
 /* NOTE:
@@ -2894,6 +2897,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, proc_tgid_io_accounting),
 #endif
+#ifdef CONFIG_HARDWALL
+	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
@@ -3232,6 +3238,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, proc_tid_io_accounting),
 #endif
+#ifdef CONFIG_HARDWALL
+	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file * filp,
-- 
1.6.5.2

