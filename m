Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab0DAB7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:59:33 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51105 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab0DAB7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=qoLoNy8etj9qQ6q1jTvqksZ5YyCMS6n6Hp8KKRKG0HJ/vGnhoDYnryorsC5qE2WrIX
         8ukrKSqE4cVghEjMVcEHtvntRXkGUvMR6PcMf2FYLqwfz1+eDjF3k2SqaSB5AVxH8OOD
         wIgJ51pozWDyPZig/EsuLM5T3S3WOiDGtqtnQ=
MIME-Version: 1.0
Date: Wed, 31 Mar 2010 21:59:15 -0400
Message-ID: <t2r817ecb6f1003311859me67dd181qf85a1d4f667cc43c@mail.gmail.com>
Subject: [PATCH 3/4] [tip:x86/mm] NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: this patch depends on "Correct improper large page preservation" patch

This patch expands functionality of CONFIG_DEBUG_RODATA to set main
(static) kernel data area as NX.
The following steps are taken to achieve this:
1. Linker script is adjusted so .text always starts and ends on a page boundary
2. Linker script is adjusted so .rodata and .data always start and
end on a page boundary
3. void mark_nxdata_nx(void) added to arch/x86/mm/init.c with actual
functionality: NX is set for all pages from _etext through _end.
4. mark_nxdata_nx() called from free_initmem() (after init has been released)
5. free_init_pages() sets released memory NX in arch/x86/mm/init.c

The results of patch application may be observed in the diff of kernel page
table dumps:
--- data_nx_pt_before.txt       2009-10-13 07:48:59.000000000 -0400
+++ data_nx_pt_after.txt        2009-10-13 07:26:46.000000000 -0400
@@ -2,8 +2,9 @@
 0x00000000-0xc0000000           3G                           pmd
 ---[ Kernel Mapping ]---
 0xc0000000-0xc0100000           1M     RW             GLB x  pte
-0xc0100000-0xc048d000        3636K     ro             GLB x  pte
-0xc048d000-0xc0600000        1484K     RW             GLB x  pte
+0xc0100000-0xc0381000        2564K     ro             GLB x  pte
+0xc0381000-0xc048d000        1072K     ro             GLB NX pte
+0xc048d000-0xc0600000        1484K     RW             GLB NX pte
 0xc0600000-0xf7800000         882M     RW         PSE GLB NX pmd
 0xf7800000-0xf79fe000        2040K     RW             GLB NX pte
 0xf79fe000-0xf7a00000           8K                           pte


The patch have been developed for Linux 2.6.34-rc2 x86 by Siarhei Liakh
<sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.

V1:  initial patch for 2.6.30
V2:  patch for 2.6.31-rc7
V3:  moved all code into arch/x86, adjusted credits
V4:  fixed ifdef, removed credits from CREDITS
V5:  fixed an address calculation bug in mark_nxdata_nx()
V6:  added acked-by and PT dump diff to commit log
V7:  minor adjustments for -tip

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Reviewed-by: James Morris <jmorris@namei.org>
---

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 2cc2497..7f82438 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -69,7 +69,7 @@ jiffies_64 = jiffies;

 PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
-	data PT_LOAD FLAGS(7);          /* RWE */
+	data PT_LOAD FLAGS(6);          /* RW_ */
 #ifdef CONFIG_X86_64
 	user PT_LOAD FLAGS(5);          /* R_E */
 #ifdef CONFIG_SMP
@@ -108,6 +108,8 @@ SECTIONS
 		IRQENTRY_TEXT
 		*(.fixup)
 		*(.gnu.warning)
+		/* .text should occupy whole number of pages */
+		. = ALIGN(PAGE_SIZE);
 		/* End of text section */
 		_etext = .;
 	} :text = 0x9090
@@ -121,6 +123,7 @@ SECTIONS
 	X64_ALIGN_DEBUG_RODATA_END

 	/* Data */
+	. = ALIGN(PAGE_SIZE);
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
 		/* Start of data section */
 		_sdata = .;
@@ -143,6 +146,8 @@ SECTIONS
 		/* rarely changed data like cpu maps */
 		READ_MOSTLY_DATA(INTERNODE_CACHE_BYTES)

+		/* .data should occupy whole number of pages */
+		. = ALIGN(PAGE_SIZE);
 		/* End of data section */
 		_edata = .;
 	} :data
@@ -307,7 +312,7 @@ SECTIONS
 		__bss_start = .;
 		*(.bss.page_aligned)
 		*(.bss)
-		. = ALIGN(4);
+		. = ALIGN(PAGE_SIZE);
 		__bss_stop = .;
 	}

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 452ee5b..240dcb0 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -361,8 +361,9 @@ void free_init_pages(char *what, unsigned long
begin, unsigned long end)
 	/*
 	 * We just marked the kernel text read only above, now that
 	 * we are going to free part of that, we need to make that
-	 * writeable first.
+	 * writeable and non-executable first.
 	 */
+	set_memory_nx(begin, (end - begin) >> PAGE_SHIFT);
 	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);

 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
@@ -377,11 +378,29 @@ void free_init_pages(char *what, unsigned long
begin, unsigned long end)
 #endif
 }

+void mark_nxdata_nx(void)
+{
+#ifdef CONFIG_DEBUG_RODATA
+	/*
+	 * When this called, init has already been executed and released,
+	 * so everything past _etext sould be NX.
+	 */
+	unsigned long start = PAGE_ALIGN((unsigned long)(&_etext));
+	unsigned long size = PAGE_ALIGN((unsigned long)(&_end)) - start;
+
+	printk(KERN_INFO "NX-protecting the kernel data: %lx, %lu pages\n",
+		start, size >> PAGE_SHIFT);
+	set_memory_nx(start, size >> PAGE_SHIFT);
+#endif
+}
+
 void free_initmem(void)
 {
 	free_init_pages("unused kernel memory",
 			(unsigned long)(&__init_begin),
 			(unsigned long)(&__init_end));
+	/* Set kernel's data as NX */
+	mark_nxdata_nx();
 }

 #ifdef CONFIG_BLK_DEV_INITRD
