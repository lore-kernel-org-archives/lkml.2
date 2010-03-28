Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0C1XhE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 19:37:04 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:57834 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab0C1XhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 19:37:00 -0400
Date: Mon, 29 Mar 2010 01:35:02 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [patch v5] x86: page-alin initrd area size
Message-ID: <20100328233502.GC10304@cmpxchg.org>
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org> <1269642114-16588-3-git-send-email-yinghai@kernel.org> <20100326230615.GB29222@cmpxchg.org> <4BAD4734.8020503@kernel.org> <20100327000723.GF29222@cmpxchg.org> <4BAD5D25.5060909@kernel.org> <20100328000306.GA10304@cmpxchg.org> <4BAEA7BE.1030707@kernel.org> <20100328010113.GB10304@cmpxchg.org> <4BAEB7CE.70305@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAEB7CE.70305@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initrd memory is freed late and page-wise, so allocate full pages and
not share the last one with somebody else.

Also add a warning and a fixup in free_init_pages() to catch unaligned
ranges more explicitely in the future.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/x86/kernel/head32.c |    8 +++++++-
 arch/x86/kernel/head64.c |    8 +++++++-
 arch/x86/kernel/setup.c  |   14 ++++++++++----
 arch/x86/mm/init.c       |   12 ++++++++----
 4 files changed, 32 insertions(+), 10 deletions(-)

On Sat, Mar 27, 2010 at 06:58:38PM -0700, Yinghai Lu wrote:
> please check.

I am really fed up with you replying to one point of an email and
skipping over five others.  So here is my version of the patch,
the maintainers can choose.

Differences:
  o only align the allocation area size, no need to also copy
    alignment bits in relocate_initrd()
  o keep the alignment fixup in free_init_pages() out of line and
    self-contained

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index adedeef..086392a 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -46,7 +46,13 @@ void __init i386_start_kernel(void)
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
 		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-		u64 ramdisk_end   = ramdisk_image + ramdisk_size;
+		u64 ramdisk_end;
+		/*
+		 * Initrd memory is freed late and page-wise, so make
+		 * sure not to share a page with other users.  Assume
+		 * start is aligned.
+		 */
+		ramdisk_end = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index b5a9896..b2c2321 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -105,7 +105,13 @@ void __init x86_64_start_reservations(char *real_mode_data)
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
+		unsigned long ramdisk_end;
+		/*
+		 * Initrd memory is freed late and page-wise, so make
+		 * sure not to share a page with other users.  Assume
+		 * start is aligned.
+		 */
+		ramdisk_end = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5d7ba1a..f5bde5f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -318,12 +318,18 @@ static void __init relocate_initrd(void)
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
-	u64 ramdisk_here;
+	u64 ramdisk_here, area_size;
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
 
+	/*	
+	 * Initrd memory is freed late and page-wise, so make sure not
+	 * to share a page with other users.  Assume start is aligned.
+	 */
+	area_size = PAGE_ALIGN(ramdisk_size);
+
 	/* We need to move the initrd down into lowmem */
-	ramdisk_here = find_e820_area(0, end_of_lowmem, ramdisk_size,
+	ramdisk_here = find_e820_area(0, end_of_lowmem, area_size,
 					 PAGE_SIZE);
 
 	if (ramdisk_here == -1ULL)
@@ -332,7 +338,7 @@ static void __init relocate_initrd(void)
 
 	/* Note: this includes all the lowmem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	reserve_early(ramdisk_here, ramdisk_here + ramdisk_size,
+	reserve_early(ramdisk_here, ramdisk_here + area_size,
 			 "NEW RAMDISK");
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
@@ -378,7 +384,7 @@ static void __init reserve_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
+	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
 
 	if (!boot_params.hdr.type_of_loader ||
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e71c5cb..4b28d5e 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -333,6 +333,11 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
 	unsigned long addr = begin;
 
+	if (WARN_ON(addr & ~PAGE_MASK || end & ~PAGE_MASK)) {
+		addr = PAGE_ALIGN(addr);
+		end &= PAGE_MASK;
+	}
+
 	if (addr >= end)
 		return;
 
@@ -355,11 +360,10 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 
-	for (; addr < end; addr += PAGE_SIZE) {
+	for (; addr != end; addr += PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(addr));
 		init_page_count(virt_to_page(addr));
-		memset((void *)(addr & ~(PAGE_SIZE-1)),
-			POISON_FREE_INITMEM, PAGE_SIZE);
+		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
 		free_page(addr);
 		totalram_pages++;
 	}
@@ -376,6 +380,6 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_init_pages("initrd memory", start, end);
+	free_init_pages("initrd memory", start, PAGE_ALIGN(end));
 }
 #endif
-- 
1.7.0.2
