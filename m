Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0C2Sn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:43:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:45407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab0C2Sn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:43:27 -0400
Date: Mon, 29 Mar 2010 18:42:54 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, torvalds@linux-foundation.org, hannes@cmpxchg.org,
       davem@davemloft.net, benh@kernel.crashing.org, tglx@linutronix.de,
       sgruszka@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, torvalds@linux-foundation.org, hannes@cmpxchg.org,
       davem@davemloft.net, benh@kernel.crashing.org, tglx@linutronix.de,
       sgruszka@redhat.com, mingo@elte.hu
In-Reply-To: <1269830604-26214-3-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-3-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Make sure free_init_pages() frees pages on page boundary
Message-ID: <tip-c967da6a0ba837f762042e931d4afcf72045547c@git.kernel.org>
Git-Commit-ID: c967da6a0ba837f762042e931d4afcf72045547c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 18:42:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c967da6a0ba837f762042e931d4afcf72045547c
Gitweb:     http://git.kernel.org/tip/c967da6a0ba837f762042e931d4afcf72045547c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 28 Mar 2010 19:42:55 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Mar 2010 18:55:33 +0200

x86: Make sure free_init_pages() frees pages on page boundary

When CONFIG_NO_BOOTMEM=y, it could use memory more effiently, or
in a more compact fashion.

Example:

 Allocated new RAMDISK: 00ec2000 - 0248ce57
 Move RAMDISK from 000000002ea04000 - 000000002ffcee56 to 00ec2000 - 0248ce56

The new RAMDISK's end is not page aligned.
Last page could be shared with other users.

When free_init_pages are called for initrd or .init, the page
could be freed and we could corrupt other data.

code segment in free_init_pages():

 |        for (; addr < end; addr += PAGE_SIZE) {
 |                ClearPageReserved(virt_to_page(addr));
 |                init_page_count(virt_to_page(addr));
 |                memset((void *)(addr & ~(PAGE_SIZE-1)),
 |                        POISON_FREE_INITMEM, PAGE_SIZE);
 |                free_page(addr);
 |                totalram_pages++;
 |        }

last half page could be used as one whole free page.

So page align the boundaries.

-v2: make the original initramdisk to be aligned, according to
     Johannes, otherwise we have the chance to lose one page.
     we still need to keep initrd_end not aligned, otherwise it could
     confuse decompressor.
-v3: change to WARN_ON instead, suggested by Johannes.
-v4: use PAGE_ALIGN, suggested by Johannes.
     We may fix that macro name later to PAGE_ALIGN_UP, and PAGE_ALIGN_DOWN
     Add comments about assuming ramdisk start is aligned
     in relocate_initrd(), change to re get ramdisk_image instead of save it
     to make diff smaller. Add warning for wrong range, suggested by Johannes.
-v6: remove one WARN()
     We need to align beginning in free_init_pages()
     do not copy more than ramdisk_size, noticed by Johannes

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1269830604-26214-3-git-send-email-yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/head32.c |    4 +++-
 arch/x86/kernel/head64.c |    3 ++-
 arch/x86/kernel/setup.c  |   10 ++++++----
 arch/x86/mm/init.c       |   32 ++++++++++++++++++++++++++------
 4 files changed, 37 insertions(+), 12 deletions(-)

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
