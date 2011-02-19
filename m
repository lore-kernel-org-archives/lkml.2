Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab1BSCrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 21:47:45 -0500
Received: from relay3.sgi.com ([192.48.152.1]:42554 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753504Ab1BSCrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 21:47:11 -0500
Message-Id: <20110219024706.263104271@gulag1.americas.sgi.com>
References: <20110219024705.308511527@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Feb 2011 20:47:11 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] printk: Allocate kernel log buffer earlier
Content-Disposition: inline; filename=get_log_buff_early
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On larger systems, because of the numerous ACPI, Bootmem and EFI
messages, the static log buffer overflows before the larger one
specified by the log_buf_len param is allocated.  Minimize the
overflow by allocating the new log buffer as soon as possible.

All arch's are covered by the "setup_log_buf" in start_kernel().
The x86 arch allocates it right after bootmem is created.

v1: Added pertinent __init & __initdata specifiers.
v2: updated to apply to x86-tip

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 arch/x86/kernel/setup.c |    5 ++
 include/linux/printk.h  |    4 +
 init/main.c             |    1 
 kernel/printk.c         |  108 ++++++++++++++++++++++++++++++++++--------------
 4 files changed, 87 insertions(+), 31 deletions(-)

--- linux.orig/arch/x86/kernel/setup.c
+++ linux/arch/x86/kernel/setup.c
@@ -1007,6 +1007,11 @@ void __init setup_arch(char **cmdline_p)
 	memblock_find_dma_reserve();
 	dma32_reserve_bootmem();
 
+	/*
+	 * Allocate bigger log buffer as early as possible
+	 */
+	setup_log_buf();
+
 #ifdef CONFIG_KVM_CLOCK
 	kvmclock_init();
 #endif
--- linux.orig/include/linux/printk.h
+++ linux/include/linux/printk.h
@@ -1,6 +1,8 @@
 #ifndef __KERNEL_PRINTK__
 #define __KERNEL_PRINTK__
 
+#include <linux/init.h>
+
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
@@ -89,6 +91,8 @@ int no_printk(const char *fmt, ...)
 extern asmlinkage __attribute__ ((format (printf, 1, 2)))
 void early_printk(const char *fmt, ...);
 
+void __init setup_log_buf(void);
+
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
 
--- linux.orig/init/main.c
+++ linux/init/main.c
@@ -592,6 +592,7 @@ asmlinkage void __init start_kernel(void
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
 	 */
+	setup_log_buf();
 	pidhash_init();
 	vfs_caches_init_early();
 	sort_main_extable();
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -162,46 +162,92 @@ void log_buf_kexec_setup(void)
 }
 #endif
 
+/* requested log_buf_len from kernel cmdline */
+static unsigned long __initdata new_log_buf_len;
+
+/* save requested log_buf_len since it's too early to process it */
 static int __init log_buf_len_setup(char *str)
 {
 	unsigned size = memparse(str, &str);
-	unsigned long flags;
 
 	if (size)
 		size = roundup_pow_of_two(size);
-	if (size > log_buf_len) {
-		unsigned start, dest_idx, offset;
-		char *new_log_buf;
-
-		new_log_buf = alloc_bootmem(size);
-		if (!new_log_buf) {
-			printk(KERN_WARNING "log_buf_len: allocation failed\n");
-			goto out;
-		}
-
-		spin_lock_irqsave(&logbuf_lock, flags);
-		log_buf_len = size;
-		log_buf = new_log_buf;
-
-		offset = start = min(con_start, log_start);
-		dest_idx = 0;
-		while (start != log_end) {
-			log_buf[dest_idx] = __log_buf[start & (__LOG_BUF_LEN - 1)];
-			start++;
-			dest_idx++;
-		}
-		log_start -= offset;
-		con_start -= offset;
-		log_end -= offset;
-		spin_unlock_irqrestore(&logbuf_lock, flags);
+	if (size > log_buf_len)
+		new_log_buf_len = size;
 
-		printk(KERN_NOTICE "log_buf_len: %d\n", log_buf_len);
-	}
-out:
-	return 1;
+	return 0;
+}
+early_param("log_buf_len", log_buf_len_setup);
+
+/*
+ * Debug code to determine if early log buffer overflowed and by how much.
+ * Length of first line saved is arbitrary as all we need is some context
+ * from the that line.
+ */
+static char __initdata first_line[40];
+
+/* Grab part of the first line from early log buf */
+static void __init fl_buf_copy(unsigned dest_idx, char c)
+{
+	if (dest_idx < sizeof(first_line) - 1)
+		first_line[dest_idx] = c;
+}
+
+/*
+ * Print free bytes left in early log buffer (might be negative)
+ * and part of first line.
+ */
+static void __init fl_print_stats(unsigned dest_idx)
+{
+	char *first_nl;
+	int free = __LOG_BUF_LEN - dest_idx;
+
+	/*
+	 * If first line was shorter than length of first_line buffer,
+	 * remove the newline so we don't get a blank line in the output.
+	 */
+	first_nl = strchr(first_line, '\n');
+	if (first_nl)
+		*first_nl = '\0';
+
+	pr_info("early log_buf free: %d(%d%%) first line: %s\n",
+		free, (free * 100) / __LOG_BUF_LEN, first_line);
 }
 
-__setup("log_buf_len=", log_buf_len_setup);
+void __init setup_log_buf(void)
+{
+	unsigned long flags;
+	unsigned start, dest_idx, offset;
+	char *new_log_buf;
+
+	if (!new_log_buf_len)
+		return;
+
+	new_log_buf = alloc_bootmem(new_log_buf_len);
+
+	spin_lock_irqsave(&logbuf_lock, flags);
+	log_buf_len = new_log_buf_len;
+	log_buf = new_log_buf;
+	new_log_buf_len = 0;
+
+	offset = start = min(con_start, log_start);
+	dest_idx = 0;
+	while (start != log_end) {
+		unsigned log_idx_mask = start & (__LOG_BUF_LEN - 1);
+
+		log_buf[dest_idx] = __log_buf[log_idx_mask];
+		fl_buf_copy(dest_idx, __log_buf[log_idx_mask]);
+		start++;
+		dest_idx++;
+	}
+	log_start -= offset;
+	con_start -= offset;
+	log_end -= offset;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	pr_info("log_buf_len: %d\n", log_buf_len);
+	fl_print_stats(dest_idx);
+}
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 

-- 
