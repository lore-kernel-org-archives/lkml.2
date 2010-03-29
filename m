Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0C2Ctw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:49:52 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:43364 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab0C2Cqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:46:47 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/31] x86: Make sure free_init_pages() free pages in boundary
Date: Sun, 28 Mar 2010 19:42:55 -0700
Message-Id: <1269830604-26214-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BB0147B.004A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_NO_BOOTMEM, it could use memory more effient, or more compact.

Example is:
Allocated new RAMDISK: 00ec2000 - 0248ce57
Move RAMDISK from 000000002ea04000 - 000000002ffcee56 to 00ec2000 - 0248ce56

The new RAMDISK's end is not page aligned.
Last page could use shared with other user.

When free_init_pages are called for initrd or .init, the page could be freed
could have chance to corrupt other data.

code segment in free_init_pages()
|        for (; addr < end; addr += PAGE_SIZE) {
|                ClearPageReserved(virt_to_page(addr));
|                init_page_count(virt_to_page(addr));
|                memset((void *)(addr & ~(PAGE_SIZE-1)),
|                        POISON_FREE_INITMEM, PAGE_SIZE);
|                free_page(addr);
|                totalram_pages++;
|        }
last half page could be used as one whole free page.

Try to make the boundaries to be page aligned.

-v2: make the original initramdisk to be aligned, according to Johannes.
     otherwise we have chance to lose one page.
     we still need to keep initrd_end not aligned, otherwise it could
     confuse decompresser.
-v3: change to WARN_ON instead according to Johannes.
-v4: use PAGE_ALIGN according to Johannes.
     We may fix that MARCO name later to PAGE_ALIGN_UP, and PAGE_ALIGN_DOWN
     Add comments about assuming ramdisk start is aligned
     in relocate_initrd(), change to re get ramdisk_image instead of save it
	to make diff smaller.
     Add WARN for wrong range according Johannes.
-v6: remove one WARN
     We need align begin in free_init_pages()
     not copy more than ramdisk_size according to Johannes

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 arch/x86/kernel/head32.c |    3 ++-
 arch/x86/kernel/head64.c |    3 ++-
 arch/x86/kernel/setup.c  |   10 ++++++----
 arch/x86/mm/init.c       |   32 ++++++++++++++++++++++++++------
 4 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index adedeef..9a97504 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -44,9 +44,10 @@ void __init i386_start_kernel(void)
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
-- 
1.6.4.2

