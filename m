Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2FKGNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:13:20 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:54613 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2FKGNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:13:18 -0400
From: Heiko Schocher <hs@denx.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Heiko Schocher <hs@denx.de>, Igor Lisitsin <igor@emcraft.com>,
        Wolfgang Denk <wd@denx.de>, Grant Erickson <gerickson@nuovations.com>,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        Kay Sievers <kay@vrfy.org>
Subject: [RFC] kernel, logbuf: add support for external log buffer
Date: Mon, 11 Jun 2012 08:13:08 +0200
Message-Id: <1339395188-10166-1-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This merges support for the previously DENX-only kernel
feature of specifying an alternative, "external" buffer
for kernel printk messages and their associated metadata.
This patch is based on DENX-only kernel commit:

commit 212f61c7fd3b952a81d1459dd32a86a32ddfd4ce
Author: Igor Lisitsin <igor@emcraft.com>
Date:   Wed Apr 18 14:55:19 2007 +0400

Add support for external log buffer.

Add support for external log buffer, for example passed by U-Boot,
which may already contain messages (from the boot loader and/or POST).

Signed-off-by: Igor Lisitsin <igor@emcraft.com>

see:
http://git.denx.de/?p=linux-denx.git;a=commit;h=212f61c7fd3b952a81d1459dd32a86a32ddfd4ce

When this option is enabled, an architecture- or machine-specific log
buffer is used for all printk messages. This allows entities such as
boot loaders (e.g. U-Boot) to place printk-compatible messages into
this buffer and for the kernel to coalesce them with its normal
messages. This patch support this feature for arch/arm based
boards.

Signed-off-by: Heiko Schocher <hs@denx.de>
Cc: Wolfgang Denk <wd@denx.de>
Cc: Igor Lisitsin <igor@emcraft.com>
Cc: Grant Erickson <gerickson@nuovations.com>
Cc: linux-kernel@vger.kernel.org
Cc: Tim Bird <tim.bird@am.sony.com>
Cc: CE Linux Developers List <celinux-dev@lists.celinuxforum.org>
Cc: Kay Sievers <kay@vrfy.org>

---
restage prior discussion from lkml:

https://lkml.org/lkml/2009/1/21/250

Discussion stopped, and I want to reanimate it, also there is a
Project Proposal on the "CE Linux Developers List" for such a feature,
see here:

http://www.mail-archive.com/celinux-dev@lists.celinuxforum.org/msg00103.html

Maybe it is now the time to discuss this again?

Is it worth to try to get this old code in current kernel, or
should we investigate Kay Sievers proposal for a structured logging
system, which will alter the format of the messages as they are
stored in the log buffer, and discuss for this a "logbuffer support"?

See this discussion here:

http://thread.gmane.org/gmane.linux.kernel/1277619

 arch/arm/mm/init.c      |   25 ++++++++++
 include/linux/logbuff.h |   51 ++++++++++++++++++++
 init/Kconfig            |   12 +++++
 init/main.c             |    5 ++
 kernel/printk.c         |  117 +++++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 206 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/logbuff.h

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 8f5813b..9609a8e 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -20,6 +20,7 @@
 #include <linux/highmem.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
+#include <linux/logbuff.h>
 
 #include <asm/mach-types.h>
 #include <asm/memblock.h>
@@ -38,6 +39,10 @@
 static unsigned long phys_initrd_start __initdata = 0;
 static unsigned long phys_initrd_size __initdata = 0;
 
+#ifdef CONFIG_LOGBUFFER
+static unsigned long ext_logbuff __initdata;
+#endif
+
 static int __init early_initrd(char *p)
 {
 	unsigned long start, size;
@@ -325,6 +330,9 @@ phys_addr_t __init arm_memblock_steal(phys_addr_t size, phys_addr_t align)
 void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 {
 	int i;
+#ifdef CONFIG_LOGBUFFER
+	unsigned long	log_buf_base;
+#endif
 
 	for (i = 0; i < mi->nr_banks; i++)
 		memblock_add(mi->bank[i].start, mi->bank[i].size);
@@ -356,6 +364,16 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 		initrd_end = initrd_start + phys_initrd_size;
 	}
 #endif
+#ifdef CONFIG_LOGBUFFER
+	log_buf_base = memblock_end_of_DRAM() - LOGBUFF_RESERVE;
+	if (memblock_is_region_reserved(log_buf_base, LOGBUFF_RESERVE)) {
+		pr_err("LOGBUF: could not use addr: %lx for logbuf support -" \
+			" disabling logbuf support\n", log_buf_base);
+	} else {
+		memblock_reserve(log_buf_base, LOGBUFF_RESERVE);
+		ext_logbuff = __phys_to_virt(log_buf_base);
+	}
+#endif
 
 	arm_mm_memblock_reserve();
 	arm_dt_memblock_reserve();
@@ -409,6 +427,13 @@ void __init bootmem_init(void)
 	max_pfn = max_high - PHYS_PFN_OFFSET;
 }
 
+#ifdef CONFIG_LOGBUFFER
+void * __init setup_ext_logbuff_mem(void)
+{
+	return (void *)ext_logbuff;
+}
+#endif
+
 static inline int free_area(unsigned long pfn, unsigned long end, char *s)
 {
 	unsigned int pages = 0, size = (end - pfn) << (PAGE_SHIFT - 10);
diff --git a/include/linux/logbuff.h b/include/linux/logbuff.h
new file mode 100644
index 0000000..3c8ceff
--- /dev/null
+++ b/include/linux/logbuff.h
@@ -0,0 +1,51 @@
+/*
+ * (C) Copyright 2007
+ * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
+ *
+ * See file CREDITS for list of people who contributed to this
+ * project.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+#ifndef _LOGBUFF_H_
+#define _LOGBUFF_H_
+
+#ifdef CONFIG_LOGBUFFER
+
+#define LOGBUFF_MAGIC		0xc0de4ced
+#define LOGBUFF_LEN		16384
+#define LOGBUFF_OVERHEAD	4096
+#define LOGBUFF_RESERVE		(LOGBUFF_LEN + LOGBUFF_OVERHEAD)
+
+/*
+ * The mapping used here has to be the same as in logbuff_init_ptrs ()
+ * in u-boot/common/cmd_log.c
+ */
+struct logbuff {
+	unsigned long	tag;
+	unsigned long	start;
+	unsigned long	con;	/* next char to be sent to consoles	*/
+	unsigned long	end;
+	unsigned long	chars;
+	unsigned char	buf[0];
+};
+
+extern void setup_ext_logbuff(void);
+extern void *setup_ext_logbuff_mem(void); /* arch specific */
+
+#endif /* CONFIG_LOGBUFFER */
+
+#endif /* _LOGBUFF_H_ */
diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..0badc3c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1031,6 +1031,18 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config LOGBUFFER
+	bool "External logbuffer" if PRINTK
+	default n
+	depends on ARM
+	help
+	  This option enables support for an alternative, "external"
+	  printk log buffer. When enabled, an architecture- or machine-
+	  specific log buffer is used for all printk messages. This
+	  allows entities such as boot loaders to place printk-compatible
+	  messages into this buffer and for the kernel to coalesce them
+	  with its normal messages.
+
 config BUG
 	bool "BUG() support" if EXPERT
 	default y
diff --git a/init/main.c b/init/main.c
index 44b2433..608e0b2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -68,6 +68,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/perf_event.h>
+#include <linux/logbuff.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -492,6 +493,7 @@ asmlinkage void __init start_kernel(void)
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
+
 	printk(KERN_NOTICE "%s", linux_banner);
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
@@ -522,6 +524,9 @@ asmlinkage void __init start_kernel(void)
 	sort_main_extable();
 	trap_init();
 	mm_init();
+#ifdef CONFIG_LOGBUFFER
+	setup_ext_logbuff();
+#endif
 
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
diff --git a/kernel/printk.c b/kernel/printk.c
index b663c2c..7e3086e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -41,6 +41,8 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/rculist.h>
+#include <linux/jiffies.h>
+#include <linux/logbuff.h>
 
 #include <asm/uaccess.h>
 
@@ -112,15 +114,42 @@ static DEFINE_RAW_SPINLOCK(logbuf_lock);
  * The indices into log_buf are not constrained to log_buf_len - they
  * must be masked before subscripting
  */
-static unsigned log_start;	/* Index into log_buf: next char to be read by syslog() */
-static unsigned con_start;	/* Index into log_buf: next char to be sent to consoles */
-static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
 
 /*
  * If exclusive_console is non-NULL then only this console is to be printed to.
  */
 static struct console *exclusive_console;
 
+#ifdef CONFIG_LOGBUFFER
+/* Indexes to the local log buffer */
+static unsigned long _log_start;
+static unsigned long _con_start;
+static unsigned long _log_end;
+static unsigned long _logged_chars;
+/* These will be switched to the external log buffer */
+static unsigned long *ext_log_start = &_log_start;
+static unsigned long *ext_con_start = &_con_start;
+static unsigned long *ext_log_end = &_log_end;
+static unsigned long *ext_logged_chars = &_logged_chars;
+#define log_start	(*ext_log_start)
+#define con_start	(*ext_con_start)
+#define log_end		(*ext_log_end)
+#define logged_chars	(*ext_logged_chars)
+#else
+static unsigned long log_start;	/*
+				 * Index into log_buf: next char to be
+				 * read by syslog()
+				 */
+static unsigned long con_start;	/*
+				 * Index into log_buf: next char to be
+				 * sent to consoles
+				 */
+static unsigned long log_end;	/*
+				 * Index into log_buf: most-recently-
+				 * written-char + 1
+				 */
+#endif /* CONFIG_LOGBUFFER */
+
 /*
  *	Array of consoles built from command line options (console=)
  */
@@ -150,8 +179,83 @@ static int console_may_schedule;
 static char __log_buf[__LOG_BUF_LEN];
 static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
-static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 static int saved_console_loglevel = -1;
+#ifndef CONFIG_LOGBUFFER
+/* Number of chars produced since last read+clear operation */
+static unsigned long logged_chars;
+#endif
+
+#ifdef CONFIG_LOGBUFFER
+void __init setup_ext_logbuff(void)
+{
+	char *extbuf;
+	struct logbuff *log;
+	unsigned long start, dest_idx, offset;
+	unsigned long count = 0;
+	unsigned long flags;
+
+	extbuf = setup_ext_logbuff_mem();
+	if (!extbuf) {
+		printk(KERN_NOTICE "Failed to setup external logbuffer - " \
+			"ignoring it\n");
+		return;
+	}
+	log = (struct logbuff *)(extbuf + LOGBUFF_OVERHEAD) - 1;
+
+	/* When no properly setup buffer is found, reset pointers */
+	if (log->tag != LOGBUFF_MAGIC) {
+		log->start = log->end = 0;
+		printk(KERN_NOTICE "Properly setup external logbuffer " \
+			"not found - using it anyway!\n");
+	}
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+
+	/* Limit pointers */
+	if (log->end - log->start > LOGBUFF_LEN)
+		log->start = log->end - LOGBUFF_LEN;
+
+	if (log->end - log->con > LOGBUFF_LEN)
+		log->con = log->end - LOGBUFF_LEN;
+
+	log->chars = logged_chars + log->end - log->start;
+	if (log->chars > LOGBUFF_LEN)
+		log->chars = LOGBUFF_LEN;
+
+	/*
+	 * Chars passed by the boot loader will appear before
+	 * those we already have in the local buffer
+	 */
+	offset = log->end - log->start;
+	start = min_t(long, con_start, log_start);
+	dest_idx = log->end;
+	while (start != log_end) {
+		log->buf[dest_idx & (LOGBUFF_LEN - 1)] = LOG_BUF(start);
+		start++;
+		dest_idx++;
+		count++;
+	}
+	log->end += count;
+	if (log->end - log->start > log_buf_len)
+		log->start = log->end - log_buf_len;
+	log->con = log->start;
+	log->chars = count + offset;
+	if (log->chars > LOGBUFF_LEN)
+		log->chars = LOGBUFF_LEN;
+
+	/* Switch to the external log buffer */
+	ext_log_start = &log->start;
+	ext_con_start = &log->con;
+	ext_log_end = &log->end;
+	ext_logged_chars = &log->chars;
+
+	log_buf = log->buf;
+	log_buf_len = LOGBUFF_LEN;
+
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	printk("Kernel logbuffer at 0x%p\n", log->buf);
+}
+#endif /* CONFIG_LOGBUFFER */
 
 #ifdef CONFIG_KEXEC
 /*
@@ -179,6 +283,11 @@ static int __init log_buf_len_setup(char *str)
 {
 	unsigned size = memparse(str, &str);
 
+#ifdef CONFIG_LOGBUFFER
+	/* Log buffer size is LOGBUFF_LEN bytes */
+	printk(KERN_NOTICE "Ignoring log_buf_len param\n");
+	return 1;
+#endif
 	if (size)
 		size = roundup_pow_of_two(size);
 	if (size > log_buf_len)
-- 
1.7.7.6

