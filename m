Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab1ERSIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:08:11 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:26559 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372Ab1ERSHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:07:16 -0400
Message-Id: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 17 May 2011 16:26:20 -0400
Subject: [PATCH] arch/tile: add /proc/tile, /proc/sys/tile, and a sysfs cpu attribute
In-Reply-To: <201005252345.15685.arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 18 May 2011 18:07:12.0430 (UTC) FILETIME=[695B64E0:01CC1586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change introduces a few of the less controversial /proc and
/proc/sys interfaces for tile, along with a sysfs attribute for
something that was originally proposed as a /proc/tile file.

Arnd Bergmann reviewed the initial arch/tile submission, which
included a complete set of all the /proc/tile and /proc/sys/tile
knobs that we had added in a somewhat ad hoc way during initial
development, and provided feedback on where most of them should go.

One knob turned out to be similar enough to the existing
/proc/sys/debug/exception-trace that it was re-implemented to use
that model instead (in a separate commit).

Another knob was /proc/tile/grid, which reported the "grid" dimensions
of a tile chip (e.g. 8x8 processors = 64-core chip).  He suggested
looking at sysfs for that, so this change moves that information
to a pair of sysfs attributes (chip_width and chip_height) in the
/sys/devices/system/cpu directory.

The entries that don't seem to have an obvious place in /sys
or elsewhere, and that are added with this patch, are:

/proc/tile/hv
  Version information about the running Tilera hypervisor

/proc/tile/hvconfig
  Detailed configuration description of the hypervisor config

/proc/tile/board
  Information on part numbers, serial numbers, etc., of the
  hardware that the kernel is executing on

/proc/tile/switch
  The type of control path for the onboard network switch, if any.

/proc/tile/hardwall
  Information on the set of currently active hardwalls (note that
  the implementation is already present in arch/tile/kernel/hardwall.c;
  this change just enables it)

/proc/sys/tile/unaligned_fixup/
  Knobs controlling the kernel code to fix up unaligned exceptions

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/Makefile |    2 +-
 arch/tile/kernel/proc.c   |  178 +++++++++++++++++++++++++++++++++++++++++++++
 arch/tile/kernel/sysfs.c  |   52 +++++++++++++
 3 files changed, 231 insertions(+), 1 deletions(-)
 create mode 100644 arch/tile/kernel/sysfs.c

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
diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
index 2e02c41..c871674 100644
--- a/arch/tile/kernel/proc.c
+++ b/arch/tile/kernel/proc.c
@@ -27,6 +27,7 @@
 #include <asm/processor.h>
 #include <asm/sections.h>
 #include <asm/homecache.h>
+#include <asm/hardwall.h>
 #include <arch/chip.h>
 
 
@@ -88,3 +89,180 @@ const struct seq_operations cpuinfo_op = {
 	.stop	= c_stop,
 	.show	= show_cpuinfo,
 };
+
+/*
+ * Support /proc/tile directory
+ */
+
+static struct proc_dir_entry *proc_tile_root;
+
+/*
+ * Define a /proc/tile file which uses a seq_file to provide a more
+ * complex set of data.
+ */
+#define SEQ_PROC_ENTRY(name)						\
+	static int proc_tile_##name##_open(struct inode *inode,		\
+					   struct file *file)		\
+	{								\
+		return single_open(file, proc_tile_##name##_show, NULL); \
+	}								\
+	static const struct file_operations proc_tile_##name##_fops = { \
+		.open		= proc_tile_##name##_open,		\
+		.read		= seq_read,				\
+		.llseek		= seq_lseek,				\
+		.release	= single_release,			\
+	};								\
+	static void proc_tile_##name##_init(void)			\
+	{								\
+		struct proc_dir_entry *entry =				\
+			create_proc_entry(#name, 0444, proc_tile_root); \
+		if (entry)						\
+			entry->proc_fops = &proc_tile_##name##_fops;	\
+	}
+
+/* Print to a seq_file the result of hv_confstr(query). */
+static void proc_tile_seq_strconf(struct seq_file *sf, char* what, int query)
+{
+	char tmpbuf[256];
+	char *bufptr = tmpbuf;
+	int buflen = sizeof(tmpbuf);
+	int len = hv_confstr(query, (HV_VirtAddr) bufptr, buflen);
+
+	if (len > buflen) {
+		bufptr = kmalloc(len, GFP_KERNEL);
+		if (!bufptr)
+			return;
+		buflen = len;
+		len = hv_confstr(query, (HV_VirtAddr) bufptr, buflen);
+	}
+
+	bufptr[buflen - 1] = 0;
+	/* Length includes the trailing null, so if it's 1, it's empty. */
+	if (len > 1) {
+		if (what)
+			seq_printf(sf, "%s: %s\n", what, bufptr);
+		else
+			seq_printf(sf, "%s", bufptr);
+	}
+
+	if (bufptr != tmpbuf)
+		kfree(bufptr);
+}
+
+static int proc_tile_hv_show(struct seq_file *sf, void *v)
+{
+	proc_tile_seq_strconf(sf, "version", HV_CONFSTR_HV_SW_VER);
+	proc_tile_seq_strconf(sf, "config_version", HV_CONFSTR_HV_CONFIG_VER);
+	return 0;
+}
+SEQ_PROC_ENTRY(hv)
+
+static int proc_tile_hvconfig_show(struct seq_file *sf, void *v)
+{
+	proc_tile_seq_strconf(sf, NULL, HV_CONFSTR_HV_CONFIG);
+	return 0;
+}
+SEQ_PROC_ENTRY(hvconfig)
+
+static int proc_tile_board_show(struct seq_file *sf, void *v)
+{
+	proc_tile_seq_strconf(sf, "board_part", HV_CONFSTR_BOARD_PART_NUM);
+	proc_tile_seq_strconf(sf, "board_serial", HV_CONFSTR_BOARD_SERIAL_NUM);
+	proc_tile_seq_strconf(sf, "chip_serial", HV_CONFSTR_CHIP_SERIAL_NUM);
+	proc_tile_seq_strconf(sf, "chip_revision", HV_CONFSTR_CHIP_REV);
+	proc_tile_seq_strconf(sf, "board_revision", HV_CONFSTR_BOARD_REV);
+	proc_tile_seq_strconf(sf, "board_description", HV_CONFSTR_BOARD_DESC);
+	proc_tile_seq_strconf(sf, "mezz_part", HV_CONFSTR_MEZZ_PART_NUM);
+	proc_tile_seq_strconf(sf, "mezz_serial", HV_CONFSTR_MEZZ_SERIAL_NUM);
+	proc_tile_seq_strconf(sf, "mezz_revision", HV_CONFSTR_MEZZ_REV);
+	proc_tile_seq_strconf(sf, "mezz_description", HV_CONFSTR_MEZZ_DESC);
+	return 0;
+}
+SEQ_PROC_ENTRY(board)
+
+static int proc_tile_switch_show(struct seq_file *sf, void *v)
+{
+	proc_tile_seq_strconf(sf, "control", HV_CONFSTR_SWITCH_CONTROL);
+	return 0;
+}
+SEQ_PROC_ENTRY(switch)
+
+
+#ifdef CONFIG_HARDWALL
+/* See arch/tile/kernel/hardwall.c for the implementation. */
+SEQ_PROC_ENTRY(hardwall)
+#endif
+
+static int __init proc_tile_init(void)
+{
+	proc_tile_root = proc_mkdir("tile", NULL);
+	if (!proc_tile_root)
+		return 0;
+
+	proc_tile_board_init();
+	proc_tile_switch_init();
+	proc_tile_hv_init();
+	proc_tile_hvconfig_init();
+#ifdef CONFIG_HARDWALL
+	proc_tile_hardwall_init();
+#endif
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
index 0000000..151deeb
--- /dev/null
+++ b/arch/tile/kernel/sysfs.c
@@ -0,0 +1,52 @@
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
+#include <linux/smp.h>
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
+
+static int __init create_cpu_entries(void)
+{
+	struct sysdev_class *cls = &cpu_sysdev_class;
+	int err = 0;
+
+	if (!err)
+		err = sysfs_create_file(&cls->kset.kobj,
+					&attr_chip_width.attr);
+	if (!err)
+		err = sysfs_create_file(&cls->kset.kobj,
+					&attr_chip_height.attr);
+
+	return err;
+}
+subsys_initcall(create_cpu_entries);
-- 
1.6.5.2

