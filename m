Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0C3Mav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:30:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47690 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846Ab0C3Mat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:30:49 -0400
Date: Tue, 30 Mar 2010 14:30:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20100330123034.GA11123@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
kernel/early_res.c                 # eed6351: x86: Do not free zero sized per c

 Thanks,

	Ingo

------------------>
Ian Campbell (1):
      x86: Do not free zero sized per cpu areas

Yinghai Lu (2):
      x86: Make smp_locks end with page alignment
      x86: Make sure free_init_pages() frees pages on page boundary


 arch/x86/kernel/head32.c      |    4 +++-
 arch/x86/kernel/head64.c      |    3 ++-
 arch/x86/kernel/setup.c       |   10 ++++++----
 arch/x86/kernel/vmlinux.lds.S |    2 +-
 arch/x86/mm/init.c            |   32 ++++++++++++++++++++++++++------
 kernel/early_res.c            |    6 ++++++
 6 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index adedeef..b2e2460 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -7,6 +7,7 @@
 
 #include <linux/init.h>
 #include <linux/start_kernel.h>
+#include <linux/mm.h>
 
 #include <asm/setup.h>
 #include <asm/sections.h>
@@ -44,9 +45,10 @@ void __init i386_start_kernel(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
+		/* Assume only end is not page aligned */
 		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-		u64 ramdisk_end   = ramdisk_image + ramdisk_size;
+		u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index b5a9896..7147143 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -103,9 +103,10 @@ void __init x86_64_start_reservations(char *real_mode_data)
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
+		/* Assume only end is not page aligned */
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
+		unsigned long ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5d7ba1a..d76e185 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -314,16 +314,17 @@ static void __init reserve_brk(void)
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 static void __init relocate_initrd(void)
 {
-
+	/* Assume only end is not page aligned */
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 area_size     = PAGE_ALIGN(ramdisk_size);
 	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
 	u64 ramdisk_here;
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
 
 	/* We need to move the initrd down into lowmem */
-	ramdisk_here = find_e820_area(0, end_of_lowmem, ramdisk_size,
+	ramdisk_here = find_e820_area(0, end_of_lowmem, area_size,
 					 PAGE_SIZE);
 
 	if (ramdisk_here == -1ULL)
@@ -332,7 +333,7 @@ static void __init relocate_initrd(void)
 
 	/* Note: this includes all the lowmem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	reserve_early(ramdisk_here, ramdisk_here + ramdisk_size,
+	reserve_early(ramdisk_here, ramdisk_here + area_size,
 			 "NEW RAMDISK");
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
@@ -376,9 +377,10 @@ static void __init relocate_initrd(void)
 
 static void __init reserve_initrd(void)
 {
+	/* Assume only end is not page aligned */
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
+	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
 
 	if (!boot_params.hdr.type_of_loader ||
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 44879df..2cc2497 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -291,8 +291,8 @@ SECTIONS
 	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
 		__smp_locks = .;
 		*(.smp_locks)
-		__smp_locks_end = .;
 		. = ALIGN(PAGE_SIZE);
+		__smp_locks_end = .;
 	}
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e71c5cb..452ee5b 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -331,11 +331,23 @@ int devmem_is_allowed(unsigned long pagenr)
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
-	unsigned long addr = begin;
+	unsigned long addr;
+	unsigned long begin_aligned, end_aligned;
 
-	if (addr >= end)
+	/* Make sure boundaries are page aligned */
+	begin_aligned = PAGE_ALIGN(begin);
+	end_aligned   = end & PAGE_MASK;
+
+	if (WARN_ON(begin_aligned != begin || end_aligned != end)) {
+		begin = begin_aligned;
+		end   = end_aligned;
+	}
+
+	if (begin >= end)
 		return;
 
+	addr = begin;
+
 	/*
 	 * If debugging page accesses then do not free this memory but
 	 * mark them not present - any buggy init-section access will
@@ -343,7 +355,7 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	 */
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
-		begin, PAGE_ALIGN(end));
+		begin, end);
 	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
 #else
 	/*
@@ -358,8 +370,7 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	for (; addr < end; addr += PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(addr));
 		init_page_count(virt_to_page(addr));
-		memset((void *)(addr & ~(PAGE_SIZE-1)),
-			POISON_FREE_INITMEM, PAGE_SIZE);
+		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
 		free_page(addr);
 		totalram_pages++;
 	}
@@ -376,6 +387,15 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_init_pages("initrd memory", start, end);
+	/*
+	 * end could be not aligned, and We can not align that,
+	 * decompresser could be confused by aligned initrd_end
+	 * We already reserve the end partial page before in
+	 *   - i386_start_kernel()
+	 *   - x86_64_start_kernel()
+	 *   - relocate_initrd()
+	 * So here We can do PAGE_ALIGN() safely to get partial page to be freed
+	 */
+	free_init_pages("initrd memory", start, PAGE_ALIGN(end));
 }
 #endif
diff --git a/kernel/early_res.c b/kernel/early_res.c
index 3cb2c66..31aa933 100644
--- a/kernel/early_res.c
+++ b/kernel/early_res.c
@@ -333,6 +333,12 @@ void __init free_early_partial(u64 start, u64 end)
 	struct early_res *r;
 	int i;
 
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "  wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
 try_next:
 	i = find_overlapped_early(start, end);
 	if (i >= max_early_res)
