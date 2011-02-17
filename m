Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab1BQSwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:52:08 -0500
Received: from relay1.sgi.com ([192.48.179.29]:39392 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab1BQSvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:51:37 -0500
Message-Id: <20110217185132.735139933@gulag1.americas.sgi.com>
References: <20110217185131.960038922@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 17 Feb 2011 12:51:36 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] printk: Allocate kernel log buffer earlier
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
 include/linux/printk.h  |    4 ++
 init/main.c             |    1 
 kernel/printk.c         |   81 +++++++++++++++++++++++++++++-------------------
 4 files changed, 60 insertions(+), 31 deletions(-)

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
@@ -162,46 +162,65 @@ void log_buf_kexec_setup(void)
 }
 #endif
 
+static unsigned long __initdata new_log_buf_len;
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
 }
+early_param("log_buf_len", log_buf_len_setup);
 
-__setup("log_buf_len=", log_buf_len_setup);
+void __init setup_log_buf(void)
+{
+	unsigned long flags;
+	unsigned start, dest_idx, offset;
+	char *new_log_buf;
+	char first_line[64], *first_nl;
+
+	if (!new_log_buf_len)
+		return;
+
+	new_log_buf = alloc_bootmem(new_log_buf_len);
+	memset(first_line, 0, sizeof(first_line));
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
+		if (dest_idx < sizeof(first_line) - 1)
+			first_line[dest_idx] = __log_buf[log_idx_mask];
+		start++;
+		dest_idx++;
+	}
+	log_start -= offset;
+	con_start -= offset;
+	log_end -= offset;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	first_nl = strchr(first_line, '\n');
+	if (first_nl)
+		*first_nl = '\0';
+
+	pr_info("log_buf_len: %d, first line: %s\n",
+		log_buf_len, first_line);
+
+	pr_debug("bu: %d/%d (%d%%)\n",
+		dest_idx, __LOG_BUF_LEN - dest_idx,
+		(dest_idx * 100) / __LOG_BUF_LEN);
+}
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 

-- 
