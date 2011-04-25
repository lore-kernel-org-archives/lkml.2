Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab1DYSLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:11:40 -0400
Received: from relay2.sgi.com ([192.48.179.30]:34833 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756078Ab1DYSLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:11:38 -0400
Message-Id: <20110425181136.342333648@gulag1.americas.sgi.com>
References: <20110425181136.055235992@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Apr 2011 13:11:38 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] printk: Allocate kernel log buffer earlier v2
Content-Disposition: inline; filename=get_log_buff_early
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	On larger systems, because of the numerous ACPI, Bootmem
	and EFI messages, the static log buffer overflows before the
	larger one specified by the log_buf_len param is allocated.
	Minimize the overflow by allocating the new log buffer as
	soon as possible.

	On kernels without memblock, a later call to setup_log_buf
	from kernel/init.c is the fallback.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/setup.c |    2 +
 include/linux/printk.h  |    4 ++
 init/main.c             |    1 
 kernel/printk.c         |   91 +++++++++++++++++++++++++++++++-----------------
 4 files changed, 67 insertions(+), 31 deletions(-)

--- linux.orig/arch/x86/kernel/setup.c
+++ linux/arch/x86/kernel/setup.c
@@ -975,6 +975,8 @@ void __init setup_arch(char **cmdline_p)
 	if (init_ohci1394_dma_early)
 		init_ohci1394_dma_on_all_controllers();
 #endif
+	/* Allocate bigger log buffer */
+	setup_log_buf(1);
 
 	reserve_initrd();
 
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
 
+void __init setup_log_buf(int early);
+
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
 
--- linux.orig/init/main.c
+++ linux/init/main.c
@@ -592,6 +592,7 @@ asmlinkage void __init start_kernel(void
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
 	 */
+	setup_log_buf(0);
 	pidhash_init();
 	vfs_caches_init_early();
 	sort_main_extable();
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -31,6 +31,7 @@
 #include <linux/smp.h>
 #include <linux/security.h>
 #include <linux/bootmem.h>
+#include <linux/memblock.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
 #include <linux/kdb.h>
@@ -162,46 +163,74 @@ void log_buf_kexec_setup(void)
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
 }
+early_param("log_buf_len", log_buf_len_setup);
 
-__setup("log_buf_len=", log_buf_len_setup);
+void __init setup_log_buf(int early)
+{
+	unsigned long flags;
+	unsigned start, dest_idx, offset;
+	char *new_log_buf;
+	int free;
+
+	if (!new_log_buf_len)
+		return;
+
+	if (early) {
+		unsigned long mem;
+
+		mem = memblock_alloc(new_log_buf_len, PAGE_SIZE);
+		if (mem == MEMBLOCK_ERROR)
+			return;
+		new_log_buf = __va(mem);
+	}
+	else
+		new_log_buf = alloc_bootmem_nopanic(new_log_buf_len);
+
+	if (unlikely(!new_log_buf)) {
+		pr_err("log_buf_len: %ld bytes not available\n",
+			new_log_buf_len);
+		return;
+	}
+
+	spin_lock_irqsave(&logbuf_lock, flags);
+	log_buf_len = new_log_buf_len;
+	log_buf = new_log_buf;
+	new_log_buf_len = 0;
+	free = __LOG_BUF_LEN - log_end;
+
+	offset = start = min(con_start, log_start);
+	dest_idx = 0;
+	while (start != log_end) {
+		unsigned log_idx_mask = start & (__LOG_BUF_LEN - 1);
+
+		log_buf[dest_idx] = __log_buf[log_idx_mask];
+		start++;
+		dest_idx++;
+	}
+	log_start -= offset;
+	con_start -= offset;
+	log_end -= offset;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	pr_info("log_buf_len: %d\n", log_buf_len);
+	pr_info("early log buf free: %d(%d%%)\n",
+		free, (free * 100) / __LOG_BUF_LEN);
+}
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 

-- 
