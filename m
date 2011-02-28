Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1B1BhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 20:37:15 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59112 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1B1BhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 20:37:13 -0500
Message-ID: <4D6AFBB0.70401@kernel.org>
Date: Sun, 27 Feb 2011 17:34:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>
CC: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] printk: Allocate kernel log buffer earlier
References: <20110225180633.857892225@gulag1.americas.sgi.com> <20110225180634.017570095@gulag1.americas.sgi.com> <20110227120949.GF16453@elte.hu> <20110227121518.GA19165@elte.hu>
In-Reply-To: <20110227121518.GA19165@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D6AFC2D.0071,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2011 04:15 AM, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> You could avoid all this ugly workaround of bootmem limitations by moving the 
>> allocation to memblock_alloc() and desupporting the log_buf_len= boot parameter on 
>> non-memblock architectures.
> 
> memblock_alloc() could return -ENOSYS on architectures that do not implement it - 
> thus enabling such optional features without ugly #ifdef CONFIG_HAVE_MEMBLOCK 
> conditionals.

Mike,

please check updated patch...

with the memblock change, you don't need to change acpi SRAT handling etc any more.

new buffer will be near high mem under 4g.

Thanks

Yinghai

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a47fe00..69b8995 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -974,6 +974,11 @@ void __init setup_arch(char **cmdline_p)
 	memblock.current_limit = get_max_mapped();
 
 	/*
+	 * Allocate bigger log buffer as early as possible
+	 */
+	setup_log_buf();
+
+	/*
 	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
 	 */
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 62a10c2..c3ade22 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -2,6 +2,8 @@
 #define _LINUX_MEMBLOCK_H
 #ifdef __KERNEL__
 
+#define MEMBLOCK_ERROR		0
+
 #ifdef CONFIG_HAVE_MEMBLOCK
 /*
  * Logical memory blocks.
@@ -20,7 +22,6 @@
 #include <asm/memblock.h>
 
 #define INIT_MEMBLOCK_REGIONS	128
-#define MEMBLOCK_ERROR		0
 
 struct memblock_region {
 	phys_addr_t base;
@@ -160,6 +161,12 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
 #define __initdata_memblock
 #endif
 
+#else
+static inline phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align)
+{
+	return MEMBLOCK_ERROR;
+}
+
 #endif /* CONFIG_HAVE_MEMBLOCK */
 
 #endif /* __KERNEL__ */
diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..fd266a8 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
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
 
diff --git a/init/main.c b/init/main.c
index 33c37c3..2085bb3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -592,6 +592,7 @@ asmlinkage void __init start_kernel(void)
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
 	 */
+	setup_log_buf();
 	pidhash_init();
 	vfs_caches_init_early();
 	sort_main_extable();
diff --git a/kernel/printk.c b/kernel/printk.c
index 3623152..14fa4d0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -31,6 +31,7 @@
 #include <linux/smp.h>
 #include <linux/security.h>
 #include <linux/bootmem.h>
+#include <linux/memblock.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
 #include <linux/kdb.h>
@@ -162,46 +163,64 @@ void log_buf_kexec_setup(void)
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
+	if (size > log_buf_len)
+		new_log_buf_len = size;
 
-		new_log_buf = alloc_bootmem(size);
-		if (!new_log_buf) {
-			printk(KERN_WARNING "log_buf_len: allocation failed\n");
-			goto out;
-		}
+	return 0;
+}
+early_param("log_buf_len", log_buf_len_setup);
 
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
+void __init setup_log_buf(void)
+{
+	unsigned long flags;
+	unsigned start, dest_idx, offset;
+	char *new_log_buf;
+	phys_addr_t new_addr;
+	int free;
+
+	if (!new_log_buf_len)
+		return;
 
-		printk(KERN_NOTICE "log_buf_len: %d\n", log_buf_len);
+	new_addr = memblock_alloc(new_log_buf_len, PAGE_SIZE);
+	if (new_addr != MEMBLOCK_ERROR)
+		new_log_buf = __va(new_addr);
+	else
+		new_log_buf = alloc_bootmem(new_log_buf_len);
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
 	}
-out:
-	return 1;
-}
+	log_start -= offset;
+	con_start -= offset;
+	log_end -= offset;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
 
-__setup("log_buf_len=", log_buf_len_setup);
+	pr_info("log_buf_len: %d\n", log_buf_len);
+	pr_info("early log buf free: %d(%d%%)\n",
+		free, (free * 100) / __LOG_BUF_LEN);
+}
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 

