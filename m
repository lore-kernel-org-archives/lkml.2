Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab1CaA5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:57:42 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42881 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933084Ab1CaA5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:57:40 -0400
Message-ID: <4D93D180.6020300@sgi.com>
Date: Wed, 30 Mar 2011 17:57:36 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] printk: Allocate kernel log buffer earlier v2
References: <20110225180633.857892225@gulag1.americas.sgi.com>	<20110225180634.017570095@gulag1.americas.sgi.com>	<20110227120949.GF16453@elte.hu>	<20110227121518.GA19165@elte.hu>	<4D6AFBB0.70401@kernel.org>	<4D6BF63D.2020404@sgi.com>	<AANLkTi=Sn6DKAjGHQjtWGiLGh8vpuS-vmXK=TMDrbjdv@mail.gmail.com>	<4D6BFF46.3050001@sgi.com> <AANLkTi=Xf5RaF559QsRNijmG0YP7amkG569NZFhpt4QY@mail.gmail.com> <4D93CDD7.8000708@sgi.com>
In-Reply-To: <4D93CDD7.8000708@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: printk: Allocate kernel log buffer earlier v2

On larger systems, because of the numerous ACPI, Bootmem and EFI
messages, the static log buffer overflows before the larger one
specified by the log_buf_len param is allocated.  Minimize the
overflow by allocating the new log buffer as soon as possible.

The allocation method is passed in as an argument to make
backporting to "pre-memblock" kernels easier.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 arch/x86/kernel/setup.c |   13 +++++++
 include/linux/kernel.h  |    1 
 include/linux/printk.h  |    5 ++
 init/main.c             |    1 
 kernel/printk.c         |   83 ++++++++++++++++++++++++++++++------------------
 5 files changed, 72 insertions(+), 31 deletions(-)

--- linux.orig/arch/x86/kernel/setup.c
+++ linux/arch/x86/kernel/setup.c
@@ -313,6 +313,17 @@ static void __init reserve_brk(void)
 	_brk_start = 0;
 }
 
+static unsigned long __init reserve_log_buf(unsigned long len)
+{
+	unsigned long mem;
+
+	mem = memblock_alloc(len, PAGE_SIZE);
+	if (mem == MEMBLOCK_ERROR)
+		return 0ULL;
+
+	return (unsigned long)__va(mem);
+}
+
 #ifdef CONFIG_BLK_DEV_INITRD
 
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
@@ -948,6 +959,8 @@ void __init setup_arch(char **cmdline_p)
 	if (init_ohci1394_dma_early)
 		init_ohci1394_dma_on_all_controllers();
 #endif
+	/* Allocate bigger log buffer as early as possible */
+	setup_log_buf(reserve_log_buf);
 
 	reserve_initrd();
 
--- linux.orig/include/linux/kernel.h
+++ linux/include/linux/kernel.h
@@ -19,6 +19,7 @@
 #include <linux/typecheck.h>
 #include <linux/printk.h>
 #include <linux/dynamic_debug.h>
+#include <linux/init.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
 
--- linux.orig/include/linux/printk.h
+++ linux/include/linux/printk.h
@@ -1,6 +1,8 @@
 #ifndef __KERNEL_PRINTK__
 #define __KERNEL_PRINTK__
 
+#include <linux/init.h>
+
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
@@ -89,6 +91,9 @@ int no_printk(const char *fmt, ...)
 extern asmlinkage __attribute__ ((format (printf, 1, 2)))
 void early_printk(const char *fmt, ...);
 
+typedef unsigned long (alloc_method)(unsigned long len);
+void __init setup_log_buf(alloc_method *alloc);
+
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
 
--- linux.orig/init/main.c
+++ linux/init/main.c
@@ -504,6 +504,7 @@ asmlinkage void __init start_kernel(void
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
 	 */
+	setup_log_buf(NULL);
 	pidhash_init();
 	vfs_caches_init_early();
 	sort_main_extable();
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -167,46 +167,67 @@ void log_buf_kexec_setup(void)
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
+void __init setup_log_buf(alloc_method *alloc)
+{
+	unsigned long flags;
+	unsigned start, dest_idx, offset;
+	char *new_log_buf;
+	int free;
+
+	if (!new_log_buf_len)
+		return;
+
+	if (alloc)
+		new_log_buf = (char *)alloc(new_log_buf_len);
+	else
+		new_log_buf = alloc_bootmem_nopanic(new_log_buf_len);
+
+	if (!new_log_buf) {
+		pr_err("log_buf_len: %d bytes not available\n", log_buf_len);
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
 

