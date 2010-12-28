Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab0L1AtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 19:49:10 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32080 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0L1AtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 19:49:09 -0500
Message-ID: <4D1933D8.4020201@kernel.org>
Date: Mon, 27 Dec 2010 16:48:24 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] x86: Use early pre-allocated page table buffer top-down
References: <4D0C072D.1040201@kernel.org> <4D19320B.7030007@kernel.org>
In-Reply-To: <4D19320B.7030007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We pre-allocate those buffer from top, so should use it top-down, so could
return unused part will be bottom side.
Will get less one hole in not used RAM.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/init.h |    6 +++---
 arch/x86/mm/init.c          |   12 ++++++------
 arch/x86/mm/init_32.c       |    4 ++--
 arch/x86/mm/init_64.c       |    5 +++--
 4 files changed, 14 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/x86/include/asm/init.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/init.h
+++ linux-2.6/arch/x86/include/asm/init.h
@@ -11,8 +11,8 @@ kernel_physical_mapping_init(unsigned lo
 			     unsigned long page_size_mask);
 
 
-extern unsigned long __initdata e820_table_start;
-extern unsigned long __meminitdata e820_table_end;
-extern unsigned long __meminitdata e820_table_top;
+extern unsigned long __meminitdata e820_table_start;
+extern unsigned long __initdata e820_table_end;
+extern unsigned long __meminitdata e820_table_bottom;
 
 #endif /* _ASM_X86_INIT_32_H */
Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -18,9 +18,9 @@
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-unsigned long __initdata e820_table_start;
-unsigned long __meminitdata e820_table_end;
-unsigned long __meminitdata e820_table_top;
+unsigned long __meminitdata e820_table_start;
+unsigned long __initdata e820_table_end;
+unsigned long __meminitdata e820_table_bottom;
 
 int after_bootmem;
 
@@ -73,12 +73,12 @@ static void __init find_early_table_spac
 	if (base == MEMBLOCK_ERROR)
 		panic("Cannot find space for the kernel page tables");
 
-	e820_table_start = base >> PAGE_SHIFT;
+	e820_table_start = (base + tables) >> PAGE_SHIFT;
 	e820_table_end = e820_table_start;
-	e820_table_top = e820_table_start + (tables >> PAGE_SHIFT);
+	e820_table_bottom = base >> PAGE_SHIFT;
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, e820_table_start << PAGE_SHIFT, e820_table_top << PAGE_SHIFT);
+		end, e820_table_bottom << PAGE_SHIFT, e820_table_end << PAGE_SHIFT);
 }
 
 struct map_range {
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -61,10 +61,10 @@ bool __read_mostly __vmalloc_start_set =
 
 static __init void *alloc_low_page(void)
 {
-	unsigned long pfn = e820_table_end++;
+	unsigned long pfn = --e820_table_start;
 	void *adr;
 
-	if (pfn >= e820_table_top)
+	if (pfn < e820_table_bottom)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = __va(pfn * PAGE_SIZE);
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -314,7 +314,7 @@ void __init cleanup_highmap(void)
 
 static __ref void *alloc_low_page(unsigned long *phys)
 {
-	unsigned long pfn = e820_table_end++;
+	unsigned long pfn;
 	void *adr;
 
 	if (after_bootmem) {
@@ -324,7 +324,8 @@ static __ref void *alloc_low_page(unsign
 		return adr;
 	}
 
-	if (pfn >= e820_table_top)
+	pfn = --e820_table_start;
+	if (pfn < e820_table_bottom)
 		panic("alloc_low_page: ran out of memory");
 
 	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
