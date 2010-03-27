Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0C0BUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 21:20:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:51251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab0C0BUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 21:20:47 -0400
Message-ID: <4BAD5D25.5060909@kernel.org>
Date: Fri, 26 Mar 2010 18:19:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH -v3] x86: Make sure free_init_pages() free pages in boundary
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org> <1269642114-16588-3-git-send-email-yinghai@kernel.org> <20100326230615.GB29222@cmpxchg.org> <4BAD4734.8020503@kernel.org> <20100327000723.GF29222@cmpxchg.org>
In-Reply-To: <20100327000723.GF29222@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>

---
 arch/x86/kernel/head32.c |    1 +
 arch/x86/kernel/head64.c |    1 +
 arch/x86/kernel/setup.c  |   40 +++++++++++++++++++++++-----------------
 arch/x86/mm/init.c       |   24 +++++++++++++++++++++++-
 4 files changed, 48 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -332,6 +332,16 @@ int devmem_is_allowed(unsigned long page
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
 	unsigned long addr = begin;
+	unsigned long addr_aligned, end_aligned;
+
+	/* Make sure boundaries are page aligned */
+	addr_aligned = PFN_UP(addr) << PAGE_SHIFT;
+	end_aligned = PFN_DOWN(end) << PAGE_SHIFT;
+
+	if (WARN_ON(addr_aligned != addr || end_aligned != end)) {
+		addr = addr_aligned;
+		end = end_aligned;
+	}
 
 	if (addr >= end)
 		return;
@@ -376,6 +386,18 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_init_pages("initrd memory", start, end);
+	unsigned long end_aligned;
+
+	/*
+	 * end could be not aligned, and We can not align that,
+	 * decompresser could be confused by aligned initrd_end
+	 * We already reserve the end partial page before in
+	 *   - i386_start_kernel()
+	 *   - x86_64_start_kernel()
+	 *   - relocate_initrd()
+	 * So here we can do PFN_UP() safely to get partial page to be freed
+	 */
+	end_aligned = PFN_UP(end) << PAGE_SHIFT;
+	free_init_pages("initrd memory", start, end_aligned);
 }
 #endif
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -47,6 +47,7 @@ void __init i386_start_kernel(void)
 		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 		u64 ramdisk_end   = ramdisk_image + ramdisk_size;
+		ramdisk_end = PFN_UP(ramdisk_end) << PAGE_SHIFT;
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -106,6 +106,7 @@ void __init x86_64_start_reservations(ch
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
 		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
+		ramdisk_end = PFN_UP(ramdisk_end) << PAGE_SHIFT;
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -317,57 +317,61 @@ static void __init relocate_initrd(void)
 
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
 	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
+	u64 image, size_aligned;
 	u64 ramdisk_here;
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
 
+	ramdisk_end = PFN_UP(ramdisk_end) << PAGE_SHIFT;
+	size_aligned = ramdisk_end - ramdisk_image;
+
 	/* We need to move the initrd down into lowmem */
-	ramdisk_here = find_e820_area(0, end_of_lowmem, ramdisk_size,
+	ramdisk_here = find_e820_area(0, end_of_lowmem, size_aligned,
 					 PAGE_SIZE);
 
 	if (ramdisk_here == -1ULL)
 		panic("Cannot find place for new RAMDISK of size %lld\n",
-			 ramdisk_size);
+			 size_aligned);
 
 	/* Note: this includes all the lowmem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	reserve_early(ramdisk_here, ramdisk_here + ramdisk_size,
+	reserve_early(ramdisk_here, ramdisk_here + size_aligned,
 			 "NEW RAMDISK");
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
 	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
-			 ramdisk_here, ramdisk_here + ramdisk_size);
+			 ramdisk_here, ramdisk_here + size_aligned);
 
 	q = (char *)initrd_start;
 
 	/* Copy any lowmem portion of the initrd */
-	if (ramdisk_image < end_of_lowmem) {
-		clen = end_of_lowmem - ramdisk_image;
-		p = (char *)__va(ramdisk_image);
+	image = ramdisk_image;
+	if (image < end_of_lowmem) {
+		clen = end_of_lowmem - image;
+		p = (char *)__va(image);
 		memcpy(q, p, clen);
 		q += clen;
-		ramdisk_image += clen;
-		ramdisk_size  -= clen;
+		image += clen;
+		size_aligned  -= clen;
 	}
 
 	/* Copy the highmem portion of the initrd */
-	while (ramdisk_size) {
-		slop = ramdisk_image & ~PAGE_MASK;
-		clen = ramdisk_size;
+	while (size_aligned) {
+		slop = image & ~PAGE_MASK;
+		clen = size_aligned;
 		if (clen > MAX_MAP_CHUNK-slop)
 			clen = MAX_MAP_CHUNK-slop;
-		mapaddr = ramdisk_image & PAGE_MASK;
+		mapaddr = image & PAGE_MASK;
 		p = early_memremap(mapaddr, clen+slop);
 		memcpy(q, p+slop, clen);
 		early_iounmap(p, clen+slop);
 		q += clen;
-		ramdisk_image += clen;
-		ramdisk_size  -= clen;
+		image += clen;
+		size_aligned  -= clen;
 	}
 	/* high pages is not converted by early_res_to_bootmem */
-	ramdisk_image = boot_params.hdr.ramdisk_image;
-	ramdisk_size  = boot_params.hdr.ramdisk_size;
 	printk(KERN_INFO "Move RAMDISK from %016llx - %016llx to"
 		" %08llx - %08llx\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
@@ -385,6 +389,8 @@ static void __init reserve_initrd(void)
 	    !ramdisk_image || !ramdisk_size)
 		return;		/* No initrd provided by bootloader */
 
+	ramdisk_end = PFN_UP(ramdisk_end) << PAGE_SHIFT;
+
 	initrd_start = 0;
 
 	if (ramdisk_size >= (end_of_lowmem>>1)) {
