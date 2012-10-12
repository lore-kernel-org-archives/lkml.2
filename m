Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2JLJvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:51:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33510 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab2JLJvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:51:13 -0400
Date: Fri, 12 Oct 2012 10:51:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Will Deacon <will.deacon@arm.com>, arnd@arndb.de,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>, dmurphy@ti.com
Subject: Re: [PATCH] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
Message-ID: <20121012095107.GE12567@gmail.com>
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org>
 <20121011201735.GA15313@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011201735.GA15313@kahuna>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, please disgard the last patch. Lots of fixups since.

Author: Lee Jones <lee.jones@linaro.org>
Date:   Wed Jun 30 14:00:40 2010 +0200

    Boottime: A tool for automatic measurement of kernel/bootloader boot time
    
    The overhead is very low and the results will be found under
    sysfs/bootime, as well as detailed results in debugfs under
    boottime/. The bootgraph* files are compatible with
    scripts/bootgraph.pl. The reason for this patch is to provide
    data (sysfs/boottime) suitable for automatic test-cases as
    well as help for developers to reduce the boot time (debugfs).
    
    Based heavily on the original driver by Jonas Aaberg.
    
    Cc: Russell King <linux@arm.linux.org.uk>
    Cc: Will Deacon <will.deacon@arm.com>
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
    Signed-off-by: Lee Jones <lee.jones@linaro.org>
    Reviewed-by: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
    Tested-by: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>

diff --git a/arch/arm/common/Makefile b/arch/arm/common/Makefile
index e8a4e58..8522356 100644
--- a/arch/arm/common/Makefile
+++ b/arch/arm/common/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_SHARP_PARAM)	+= sharpsl_param.o
 obj-$(CONFIG_SHARP_SCOOP)	+= scoop.o
 obj-$(CONFIG_PCI_HOST_ITE8152)  += it8152.o
 obj-$(CONFIG_ARM_TIMER_SP804)	+= timer-sp.o
+obj-$(CONFIG_BOOTTIME)		+= boottime.o
diff --git a/arch/arm/common/boottime.c b/arch/arm/common/boottime.c
new file mode 100644
index 0000000..73e9e04
--- /dev/null
+++ b/arch/arm/common/boottime.c
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2009-2010
+ *
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ *
+ * Store boot times measured during for example u-boot startup.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/boottime.h>
+#include <linux/string.h>
+#include <asm/setup.h>
+
+static u32 bootloader_idle;
+static u32 bootloader_total;
+
+static int __init boottime_parse_tag(const struct tag *tag)
+{
+	int i;
+	char buff[BOOTTIME_MAX_NAME_LEN];
+
+	bootloader_idle = tag->u.boottime.idle;
+	bootloader_total = tag->u.boottime.total;
+
+	for (i = 0; i < tag->u.boottime.num; i++) {
+		snprintf(buff, BOOTTIME_MAX_NAME_LEN, "%s+0x0/0x0",
+			 tag->u.boottime.entry[i].name);
+		buff[BOOTTIME_MAX_NAME_LEN - 1] = '\0';
+		boottime_mark_wtime(buff, tag->u.boottime.entry[i].time);
+	}
+
+	return 0;
+}
+
+__tagtable(ATAG_BOOTTIME,  boottime_parse_tag);
+
+int boottime_bootloader_idle(void)
+{
+	if (bootloader_total == 0)
+		return 0;
+
+	return (int) ((bootloader_idle) / (bootloader_total / 100));
+}
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index 24d284a..e8da062 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -143,6 +143,23 @@ struct tag_memclk {
 	__u32 fmemclk;
 };
 
+/* for automatic boot timing testcases */
+#define ATAG_BOOTTIME  0x41000403
+#define BOOTTIME_MAX_NAME_LEN 64
+#define BOOTTIME_MAX 10
+
+struct boottime_entry {
+	u32 time; /* in us */
+	u8  name[BOOTTIME_MAX_NAME_LEN];
+};
+
+struct tag_boottime {
+	struct boottime_entry entry[BOOTTIME_MAX];
+	u32 idle;  /* in us */
+	u32 total; /* in us */
+	u8 num;
+};
+
 struct tag {
 	struct tag_header hdr;
 	union {
@@ -165,6 +182,10 @@ struct tag {
 		 * DC21285 specific
 		 */
 		struct tag_memclk	memclk;
+		/*
+		 * Boot time
+		 */
+		struct tag_boottime	boottime;
 	} u;
 };
 
diff --git a/include/linux/boottime.h b/include/linux/boottime.h
new file mode 100644
index 0000000..d330ecd
--- /dev/null
+++ b/include/linux/boottime.h
@@ -0,0 +1,89 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2009-2010
+ *
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ *
+ * boottime is a tool for collecting start-up timing
+ * information and can together with boot loader support
+ * display a total system start-up time.
+ *
+ */
+
+#ifndef LINUX_BOOTTIME_H
+#define LINUX_BOOTTIME_H
+
+#ifdef CONFIG_BOOTTIME
+#include <linux/kernel.h>
+
+/**
+ * struct boottime_timer - Callbacks for generic timer.
+ * @init: Function to call at boottime initialization
+ * @get_time: Returns the number of us since start-up
+ *            Preferable this is based upon a free running timer.
+ *            This is the only required entry.
+ * @finalize: Called before init is executed and boottime is done.
+ */
+struct boottime_timer {
+	int (*init)(void);
+	unsigned long (*get_time)(void);
+	void (*finalize)(void);
+};
+
+/**
+ * boottime_mark_wtime()
+ * Add a sample point with a given time. Useful for adding data collected
+ * by for example a boot loader.
+ * @name: The name of the sample point
+ * @time: The time in us when this point was reached
+ */
+void __init boottime_mark_wtime(char *name, unsigned long time);
+
+/**
+ * boottime_mark()
+ * Add a sample point with the current time.
+ * @name: The name of this sample point
+ */
+void boottime_mark(char *name);
+
+/**
+ * boottime_mark_symbolic()
+ * Add a sample point where the name is a symbolic function
+ * and %pF is needed to get the correct function name.
+ * @name: function name.
+ */
+void __init boottime_mark_symbolic(void *name);
+
+/**
+ * boottime_activate()
+ * Activates boottime and register callbacks.
+ * @bt: struct with callbacks.
+ */
+void __ref boottime_activate(struct boottime_timer *bt);
+
+/**
+ * boottime_deactivate()
+ * This function is called when the kernel boot is done.
+ * (before "free init memory" is called)
+ */
+void boottime_deactivate(void);
+
+/**
+ * boottime_system_up()
+ * A function is called when the basics of the kernel
+ * is up and running.
+ */
+void __init boottime_system_up(void);
+
+#else
+
+#define boottime_mark_wtime(name, time)
+#define boottime_mark(name)
+#define boottime_mark_symbolic(name)
+#define boottime_activate(bt)
+#define boottime_deactivate()
+#define boottime_system_up()
+#endif
+
+#endif /* LINUX_BOOTTIME_H */
diff --git a/init/Kconfig b/init/Kconfig
index 4c93533..d0df8ff 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1464,6 +1464,15 @@ config PROFILING
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.
 
+config BOOTTIME
+	bool "Boot time measurements"
+	default n
+	help
+		Adds sysfs entries (boottime/) with start-up timing information.
+		If CONFIG_DEBUG_FS is enabled, detailed information about the
+		boot time, including system load during boot can be extracted.
+		This information can be visualised with help of the bootgraph script.
+
 #
 # Place an empty function call at each tracepoint site. Can be
 # dynamically changed for a probe function.
diff --git a/init/Makefile b/init/Makefile
index 7bc47ee..356d529 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -9,6 +9,7 @@ else
 obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
 endif
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
+obj-$(CONFIG_BOOTTIME)		      += boottime.o
 
 ifneq ($(CONFIG_ARCH_INIT_TASK),y)
 obj-y                          += init_task.o
diff --git a/init/boottime.c b/init/boottime.c
new file mode 100644
index 0000000..793c184
--- /dev/null
+++ b/init/boottime.c
@@ -0,0 +1,475 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2009-2010
+ *
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ *
+ * boottime is a tool for collecting start-up timing
+ * information and can together with boot loader support
+ * display a total system start-up time.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/spinlock.h>
+#include <linux/boottime.h>
+#include <linux/kernel_stat.h>
+#include <linux/kobject.h>
+#include <linux/device.h>
+#include <linux/sysfs.h>
+#include <linux/slab.h>
+
+/*
+ * BOOTTIME_MAX_NAME_LEN is defined in arch/arm/include/asm/setup.h to 64.
+ * No crisis if they don't match.
+ */
+#ifndef BOOTTIME_MAX_NAME_LEN
+#define BOOTTIME_MAX_NAME_LEN 64
+#endif
+
+/*
+ * We have a few static entries, since it is good to have measure points
+ * before the system is up and running properly
+ */
+#define NUM_STATIC_BOOTTIME_ENTRIES 32
+
+struct boottime_list {
+	struct list_head list;
+	char name[BOOTTIME_MAX_NAME_LEN];
+	/* Time in us since power on, possible including boot loader. */
+	unsigned long time;
+	bool cpu_load;
+	struct kernel_cpustat cpu_usage[NR_CPUS];
+};
+
+enum boottime_filter_type {
+	BOOTTIME_FILTER_OUT_ZERO,
+	BOOTTIME_FILTER_OUT_LESS_100,
+	BOOTTIME_FILTER_NOTHING,
+};
+
+enum boottime_symbolic_print {
+	BOOTTIME_SYMBOLIC_PRINT,
+	BOOTTIME_NORMAL_PRINT,
+};
+
+enum boottime_cpu_load {
+	BOOTTIME_CPU_LOAD,
+	BOOTTIME_NO_CPU_LOAD,
+};
+
+static LIST_HEAD(boottime_list);
+static DEFINE_SPINLOCK(boottime_list_lock);
+static struct boottime_timer boottime_timer;
+static int num_const_boottime_list;
+static struct boottime_list const_boottime_list[NUM_STATIC_BOOTTIME_ENTRIES];
+static unsigned long time_kernel_done;
+static unsigned long time_bootloader_done;
+static bool system_up;
+static bool boottime_done;
+
+int __attribute__((weak)) boottime_arch_startup(void)
+{
+	return 0;
+}
+
+int __attribute__((weak)) boottime_bootloader_idle(void)
+{
+	return 0;
+}
+
+static void boottime_mark_core(char *name,
+				      unsigned long time,
+				      enum boottime_symbolic_print symbolic,
+				      enum boottime_cpu_load cpu_load)
+{
+	struct boottime_list *b;
+	unsigned long flags = 0;
+	int i;
+
+	if (system_up) {
+		b = kmalloc(sizeof(struct boottime_list), GFP_KERNEL);
+		if (!b) {
+			printk(KERN_ERR
+			       "boottime: failed to allocate memory!\n");
+			return;
+		}
+
+	} else {
+		if (num_const_boottime_list < NUM_STATIC_BOOTTIME_ENTRIES) {
+			b = &const_boottime_list[num_const_boottime_list];
+			num_const_boottime_list++;
+		} else {
+			printk(KERN_ERR
+			       "boottime: too many early measure points!\n");
+			return;
+		}
+	}
+
+	INIT_LIST_HEAD(&b->list);
+
+	if (symbolic == BOOTTIME_SYMBOLIC_PRINT)
+		snprintf(b->name, BOOTTIME_MAX_NAME_LEN, "%pF", name);
+	else
+		strncpy(b->name, name, BOOTTIME_MAX_NAME_LEN);
+
+	b->name[BOOTTIME_MAX_NAME_LEN - 1] = '\0';
+	b->time = time;
+	b->cpu_load = cpu_load;
+
+	if (cpu_load == BOOTTIME_CPU_LOAD && system_up)
+		for_each_possible_cpu(i) {
+			b->cpu_usage[i].cpustat[CPUTIME_SYSTEM] =
+				kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
+			b->cpu_usage[i].cpustat[CPUTIME_IDLE] =
+				kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
+			b->cpu_usage[i].cpustat[CPUTIME_IOWAIT] =
+				kcpustat_cpu(i).cpustat[CPUTIME_IOWAIT];
+			b->cpu_usage[i].cpustat[CPUTIME_IRQ] =
+				kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
+			/*
+			 * TODO: Make sure that user, nice, softirq, steal
+			 * and guest are not used during boot
+			 */
+		}
+	else
+		b->cpu_load = BOOTTIME_NO_CPU_LOAD;
+
+	if (system_up) {
+		spin_lock_irqsave(&boottime_list_lock, flags);
+		list_add(&b->list, &boottime_list);
+		spin_unlock_irqrestore(&boottime_list_lock, flags);
+	} else {
+		list_add(&b->list, &boottime_list);
+	}
+}
+
+void __init boottime_mark_wtime(char *name, unsigned long time)
+{
+	boottime_mark_core(name, time,
+			   BOOTTIME_NORMAL_PRINT,
+			   BOOTTIME_NO_CPU_LOAD);
+}
+
+void __ref boottime_mark_symbolic(void *name)
+{
+
+	if (boottime_done)
+		return;
+
+	if (boottime_timer.get_time)
+		boottime_mark_core((char *) name,
+				   boottime_timer.get_time(),
+				   BOOTTIME_SYMBOLIC_PRINT,
+				   BOOTTIME_CPU_LOAD);
+}
+
+void boottime_mark(char *name)
+{
+	if (boottime_timer.get_time)
+		boottime_mark_core(name,
+				   boottime_timer.get_time(),
+				   BOOTTIME_NORMAL_PRINT,
+				   BOOTTIME_CPU_LOAD);
+}
+
+void __init boottime_activate(struct boottime_timer *bt)
+{
+	struct boottime_list *b;
+	int res = 0;
+	unsigned long flags;
+
+	if (bt == NULL) {
+		printk(KERN_ERR
+		       "boottime: error: bad configured\n");
+		return;
+	}
+
+	if (bt->get_time == NULL) {
+		printk(KERN_ERR
+		       "boottime: error: you must provide a get_time() function\n");
+		return;
+	}
+	memcpy(&boottime_timer, bt, sizeof(struct boottime_timer));
+
+	if (boottime_timer.init)
+		res = boottime_timer.init();
+
+	if (res) {
+		printk(KERN_ERR "boottime: initialization failed\n");
+		return;
+	}
+
+	if (boottime_arch_startup())
+		printk(KERN_ERR
+		       "boottime: arch specfic initialization failed\n");
+
+	spin_lock_irqsave(&boottime_list_lock, flags);
+
+	if (!list_empty(&boottime_list)) {
+
+		b = list_first_entry(&boottime_list, struct boottime_list,
+				     list);
+		if (b)
+			time_bootloader_done = b->time;
+	}
+
+	spin_unlock_irqrestore(&boottime_list_lock, flags);
+}
+
+void __init boottime_system_up(void)
+{
+	system_up = true;
+}
+
+void boottime_deactivate(void)
+{
+	struct boottime_list *b;
+	unsigned long flags;
+
+	boottime_mark("execute_init+0x0/0x0");
+
+	boottime_done = true;
+
+	spin_lock_irqsave(&boottime_list_lock, flags);
+	b = list_first_entry(&boottime_list, struct boottime_list, list);
+	spin_unlock_irqrestore(&boottime_list_lock, flags);
+
+	time_kernel_done = b->time;
+
+	if (boottime_timer.finalize)
+		boottime_timer.finalize();
+}
+
+#ifdef CONFIG_DEBUG_FS
+static void boottime_debugfs_load(struct seq_file *s,
+				  struct boottime_list *b,
+				  struct boottime_list *p)
+{
+	int i;
+	unsigned long total_p, total_b;
+	unsigned long system_total, idle_total, irq_total, iowait_total;
+	unsigned long system_load, idle_load, irq_load, iowait_load;
+
+	for_each_possible_cpu(i) {
+		total_b = (b->cpu_usage[i].cpustat[CPUTIME_SYSTEM] +
+			   b->cpu_usage[i].cpustat[CPUTIME_IDLE] +
+			   b->cpu_usage[i].cpustat[CPUTIME_IOWAIT] +
+			   b->cpu_usage[i].cpustat[CPUTIME_IRQ]);
+
+		total_p = (p->cpu_usage[i].cpustat[CPUTIME_SYSTEM] +
+			   p->cpu_usage[i].cpustat[CPUTIME_IDLE] +
+			   p->cpu_usage[i].cpustat[CPUTIME_IOWAIT] +
+			   p->cpu_usage[i].cpustat[CPUTIME_IRQ]);
+
+		if (total_b == total_p)
+			continue;
+
+		system_total = b->cpu_usage[i].cpustat[CPUTIME_SYSTEM]
+			- p->cpu_usage[i].cpustat[CPUTIME_SYSTEM];
+		idle_total = b->cpu_usage[i].cpustat[CPUTIME_IDLE]
+			- p->cpu_usage[i].cpustat[CPUTIME_IDLE];
+		irq_total = b->cpu_usage[i].cpustat[CPUTIME_IRQ]
+			- p->cpu_usage[i].cpustat[CPUTIME_IRQ];
+		iowait_total = b->cpu_usage[i].cpustat[CPUTIME_IOWAIT]
+			- p->cpu_usage[i].cpustat[CPUTIME_IOWAIT];
+
+		system_load = (100 * system_total / (total_b - total_p));
+		idle_load = (100 * idle_total / (total_b - total_p));
+		irq_load = (100 * irq_total / (total_b - total_p));
+		iowait_load = (100 * iowait_total / (total_b - total_p));
+
+		seq_printf(s,
+			   " cpu%d system: %lu%% idle: %lu%% iowait: %lu%% irq: %lu%%",
+			   i,
+			   system_load,
+			   idle_load,
+			   iowait_load,
+			   irq_load);
+	}
+	seq_printf(s, "\n");
+}
+
+static void boottime_debugfs_print(struct seq_file *s,
+				   struct boottime_list *b,
+				   struct boottime_list *p)
+{
+	seq_printf(s, "[%5lu.%06lu] calling  %s\n",
+		   p->time / 1000000,
+		   (p->time  % 1000000),
+		   p->name);
+	seq_printf(s, "[%5lu.%06lu] initcall %s returned 0 after %ld msecs.",
+		   b->time / 1000000,
+		   (b->time  % 1000000),
+		   p->name, (b->time - p->time) / 1000);
+
+	if (p->cpu_load == BOOTTIME_NO_CPU_LOAD ||
+	    b->cpu_load == BOOTTIME_NO_CPU_LOAD) {
+		seq_printf(s, "\n");
+		return;
+	}
+
+	boottime_debugfs_load(s, b, p);
+}
+
+static int boottime_debugfs_bootgraph_show(struct seq_file *s, void *iter)
+{
+	struct boottime_list *b, *p = NULL, *old_p = NULL;
+	enum boottime_filter_type filter = (int)s->private;
+
+	list_for_each_entry_reverse(b, &boottime_list, list) {
+		if (p) {
+			if (!(filter == BOOTTIME_FILTER_OUT_ZERO &&
+			     (b->time - p->time) / 1000 == 0)
+			   && !(filter == BOOTTIME_FILTER_OUT_LESS_100 &&
+				(b->time - p->time) < 100 * 1000))
+				boottime_debugfs_print(s, b, p);
+			old_p = p;
+		}
+		p = b;
+	}
+
+	if (filter == BOOTTIME_FILTER_NOTHING && p)
+		boottime_debugfs_print(s, p, p);
+
+	if (p)
+		seq_printf(s, "[%5lu.%06lu] Freeing init memory: 0K\n",
+			   p->time / 1000000, p->time  % 1000000);
+	return 0;
+}
+
+static int boottime_debugfs_summary_show(struct seq_file *s, void *data)
+{
+	struct boottime_list *b, b_zero;
+
+	if (time_bootloader_done)
+		seq_printf(s, "bootloader: %ld msecs\n",
+			   time_bootloader_done / 1000);
+
+	seq_printf(s, "kernel: %ld msecs\ntotal: %ld msecs\n",
+		   (time_kernel_done - time_bootloader_done) / 1000,
+		   time_kernel_done / 1000);
+	seq_printf(s, "kernel:");
+	b = list_first_entry(&boottime_list,
+			     struct boottime_list, list);
+	memset(&b_zero, 0, sizeof(struct boottime_list));
+	boottime_debugfs_load(s, b, &b_zero);
+
+	if (time_bootloader_done)
+		seq_printf(s,
+			   "bootloader: cpu0 system: %d%% idle: %d%% iowait: 0%% irq: 0%%\n",
+			   100 - boottime_bootloader_idle(),
+			   boottime_bootloader_idle());
+	return 0;
+}
+
+static int boottime_debugfs_bootgraph_open(struct inode *inode,
+					   struct file *file)
+{
+	return single_open(file,
+			   boottime_debugfs_bootgraph_show,
+			   inode->i_private);
+}
+
+static int boottime_debugfs_summary_open(struct inode *inode,
+					 struct file *file)
+{
+	return single_open(file,
+			   boottime_debugfs_summary_show,
+			   inode->i_private);
+}
+
+static const struct file_operations boottime_debugfs_bootgraph_operations = {
+	.open		= boottime_debugfs_bootgraph_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations boottime_debugfs_summary_operations = {
+	.open		= boottime_debugfs_summary_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+void boottime_debugfs_init(void)
+{
+	struct dentry *dir;
+
+	dir = debugfs_create_dir("boottime", NULL);
+
+	(void) debugfs_create_file("bootgraph", S_IFREG | S_IRUGO,
+				   dir, (void *)BOOTTIME_FILTER_NOTHING,
+				   &boottime_debugfs_bootgraph_operations);
+	(void) debugfs_create_file("bootgraph_all_except0", S_IFREG | S_IRUGO,
+				   dir, (void *)BOOTTIME_FILTER_OUT_ZERO,
+				   &boottime_debugfs_bootgraph_operations);
+	(void) debugfs_create_file("bootgraph_larger100",
+				   S_IFREG | S_IRUGO,
+				   dir, (void *)BOOTTIME_FILTER_OUT_LESS_100,
+				   &boottime_debugfs_bootgraph_operations);
+	(void) debugfs_create_file("summary", S_IFREG | S_IRUGO,
+				   dir, NULL,
+				   &boottime_debugfs_summary_operations);
+}
+#else
+#define boottime_debugfs_init(x)
+#endif
+
+static ssize_t show_bootloader(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	return sprintf(buf, "%ld\n", time_bootloader_done / 1000);
+}
+
+static ssize_t show_kernel(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	return sprintf(buf, "%ld\n",
+		       (time_kernel_done - time_bootloader_done) / 1000);
+}
+
+DEVICE_ATTR(kernel, 0444, show_kernel, NULL);
+DEVICE_ATTR(bootloader, 0444, show_bootloader, NULL);
+
+static struct attribute *boottime_sysfs_entries[] = {
+	&dev_attr_kernel.attr,
+	&dev_attr_bootloader.attr,
+	NULL
+};
+
+static struct attribute_group boottime_attr_grp = {
+	.name = NULL,
+	.attrs = boottime_sysfs_entries,
+};
+
+static int __init boottime_init(void)
+{
+	struct kobject *boottime_kobj;
+
+	boottime_kobj = kobject_create_and_add("boottime", NULL);
+	if (!boottime_kobj) {
+		printk(KERN_ERR "boottime: out of memory!\n");
+		return -ENOMEM;
+	}
+
+	if (sysfs_create_group(boottime_kobj, &boottime_attr_grp) < 0) {
+		kobject_put(boottime_kobj);
+		printk(KERN_ERR "boottime: Failed creating sysfs group\n");
+		return -ENOMEM;
+	}
+
+	boottime_debugfs_init();
+
+	return 0;
+}
+
+late_initcall(boottime_init);
diff --git a/init/main.c b/init/main.c
index 313360f..c06afd0 100644
--- a/init/main.c
+++ b/init/main.c
@@ -69,6 +69,7 @@
 #include <linux/slab.h>
 #include <linux/perf_event.h>
 #include <linux/file.h>
+#include <linux/boottime.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -679,6 +680,8 @@ int __init_or_module do_one_initcall(initcall_t fn)
 	int count = preempt_count();
 	int ret;
 
+	boottime_mark_symbolic(fn);
+
 	if (initcall_debug)
 		ret = do_one_initcall_debug(fn);
 	else
@@ -804,6 +807,7 @@ static noinline int init_post(void)
 {
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
+	boottime_deactivate();
 	free_initmem();
 	mark_rodata_ro();
 	system_state = SYSTEM_RUNNING;
@@ -863,6 +867,7 @@ static int __init kernel_init(void * unused)
 
 	do_pre_smp_initcalls();
 	lockup_detector_init();
+	boottime_system_up();
 
 	smp_init();
 	sched_init_smp();
@@ -885,6 +890,7 @@ static int __init kernel_init(void * unused)
 
 	if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
 		ramdisk_execute_command = NULL;
+		boottime_mark("mount+0x0/0x0");
 		prepare_namespace();
 	}
