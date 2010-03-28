Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0C1ADg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 20:03:36 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:54823 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab0C1ADe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 20:03:34 -0400
Date: Sun, 28 Mar 2010 01:03:06 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH -v3] x86: Make sure free_init_pages() free pages in boundary
Message-ID: <20100328000306.GA10304@cmpxchg.org>
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org> <1269642114-16588-3-git-send-email-yinghai@kernel.org> <20100326230615.GB29222@cmpxchg.org> <4BAD4734.8020503@kernel.org> <20100327000723.GF29222@cmpxchg.org> <4BAD5D25.5060909@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAD5D25.5060909@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 26, 2010 at 06:19:33PM -0700, Yinghai Lu wrote:
> 
> 
> When CONFIG_NO_BOOTMEM, it could use memory more effient, or more compact.
> 
> Example is:
> Allocated new RAMDISK: 00ec2000 - 0248ce57
> Move RAMDISK from 000000002ea04000 - 000000002ffcee56 to 00ec2000 - 0248ce56
> 
> The new RAMDISK's end is not page aligned.
> Last page could use shared with other user.
> 
> When free_init_pages are called for initrd or .init, the page could be freed
> could have chance to corrupt other data.
> 
> code segment in free_init_pages()
> |        for (; addr < end; addr += PAGE_SIZE) {
> |                ClearPageReserved(virt_to_page(addr));
> |                init_page_count(virt_to_page(addr));
> |                memset((void *)(addr & ~(PAGE_SIZE-1)),
> |                        POISON_FREE_INITMEM, PAGE_SIZE);
> |                free_page(addr);
> |                totalram_pages++;
> |        }
> last half page could be used as one whole free page.
> 
> Try to make the boundaries to be page aligned.
> 
> -v2: make the original initramdisk to be aligned, according to Johannes.
>      otherwise we have chance to lose one page.
>      we still need to keep initrd_end not aligned, otherwise it could
>      confuse decompresser.
> -v3: change to WARN_ON instead according to Johannes.
> 
> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Here is what I had in mind when I wrote what you did not read, maybe diff
works better?

Main differences:
  o only fix the area allocation in relocate_initrd(), no need to do
    copy the alignment bits
  o keep alignment fixups in free_init_pages() out of line
  o use PAGE_SIZE(); you might dislike the name, it is still the proper
    operation here.  if you want to fix it, please do it properly

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index adedeef..ec7c672 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -46,7 +46,8 @@ void __init i386_start_kernel(void)
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
 		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-		u64 ramdisk_end   = ramdisk_image + ramdisk_size;
+		u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
+
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index b5a9896..a26a8fd 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -105,7 +105,9 @@ void __init x86_64_start_reservations(char *real_mode_data)
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
+		unsigned long ramdisk_end   = PAGE_ALIGN(ramdisk_image +
+							 ramdisk_size);
+
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ca3f8fa..0594923 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -317,13 +317,14 @@ static void __init relocate_initrd(void)
 
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
@@ -378,7 +379,7 @@ static void __init reserve_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
+	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
 	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
 
 	if (!boot_params.hdr.type_of_loader ||
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e71c5cb..018e793 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -336,6 +336,11 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	if (addr >= end)
 		return;
 
+	if (WARN_ON(addr & ~PAGE_MASK || end & ~PAGE_MASK)) {
+		addr = PAGE_ALIGN(addr);
+		end &= PAGE_MASK;
+	}
+
 	/*
 	 * If debugging page accesses then do not free this memory but
 	 * mark them not present - any buggy init-section access will
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
