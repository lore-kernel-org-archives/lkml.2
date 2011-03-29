Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1C2RZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 13:25:48 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:14016 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1C2RZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 13:25:47 -0400
X-IronPort-AV: E=Sophos;i="4.63,263,1299456000"; 
   d="scan'208";a="5032593"
Date: Tue, 29 Mar 2011 18:25:56 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: another pagetable initialization crash on xen
In-Reply-To: <alpine.DEB.2.00.1103281929390.5516@kaball-desktop>
Message-ID: <alpine.DEB.2.00.1103291620560.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103281729190.5516@kaball-desktop> <alpine.DEB.2.00.1103281929390.5516@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Stefano Stabellini wrote:
> On Mon, 28 Mar 2011, Stefano Stabellini wrote:
> > Hi Yinghai,
> > unfortunately I found another pagetable initialization bug on xen
> > affecting linux 2.6.39-rc0.
> > The problem is that on xen we need to make sure that all the pagetable pages
> > are mapped read-only, in fact in xen_set_pte we have this check:
> > 
> > if (pfn >= pgt_buf_start && pfn < pgt_buf_end)
> >     /* make the pte read-only */
> > 
> > however pgt_buf_end is where the kernel pagetable *currently* ends, so
> > some kernel pagetable pages allocated after pgt_buf_end might be marked
> > read-write by mistake.  A simple way to fix the issue would be to use
> > pgt_buf_top instead:
> > 
> > if (pfn >= pgt_buf_start && pfn < pgt_buf_top)
> >     /* make the pte read-only */
> > 
> > however after building the kernel pagetable in init_memory_mapping we
> > only reserve memory between pgt_buf_start and pgt_buf_end:
> > 
> > if (!after_bootmem && pgt_buf_end > pgt_buf_start)
> >         memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
> >                  pgt_buf_end << PAGE_SHIFT, "PGTABLE");
> > 
> > so feature allocations might use memory between the final value of
> > pgt_buf_end and pgt_buf_top that has been marked read-only in the xen
> > specific code, causing a crash.
> > The only way I could find to fix the crash is to reserve also the memory
> > region between pgt_buf_start and pgt_buf_top on xen, but that would
> > require an ugly if(xen_domain()) at the of init_memory_mapping or
> > the introduction of a new pvop function to reserve the pagetable memory.
> > I don't like the idea, but I couldn't find anything better.
> > Yinghai, do you have any better suggestions?
> 
> Just to make it clearer, this is the not-so-pretty patch I am talking
> about:


I kept working on refactoring this code, and I think I was able to come
up with a slightly better patch.
Do you think this is acceptable?



commit c576ff205060e92b36224e80a989492b245e806d
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Tue Mar 29 10:59:02 2011 +0000

    x86: introduce kernel_pagetable hooks
    
    Introduce two new pvop hooks:
    
    - kernel_pagetable_alloc is used to allocate the initial kernel
    pagetable pages;
    
    - kernel_pagetable_reserve is used to reserved the kernel pagetable
    memory range;
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 7db7723..a3ab967 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -299,6 +299,12 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 /* Install a pte for a particular vaddr in kernel space. */
 void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
+struct map_range;
+void native_kernel_pagetable_alloc(struct map_range *mr,
+		unsigned long *pgt_start,
+		unsigned long *pgt_top);
+void native_kernel_pagetable_reserve(unsigned long pgt_start,
+		unsigned long pgt_end);
 #ifdef CONFIG_X86_32
 extern void native_pagetable_setup_start(pgd_t *base);
 extern void native_pagetable_setup_done(pgd_t *base);
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 643ebf2..984ce6f 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -69,10 +69,26 @@ struct x86_init_oem {
 
 /**
  * struct x86_init_paging - platform specific paging functions
+ * @kernel_pagetable_alloc:	platform specific kernel pagetable
+ *                                      allocation function
+ * @kernel_pagetable_reserve:	platform specific kernel pagetable
+ *                                      reserve memory function
  * @pagetable_setup_start:	platform specific pre paging_init() call
  * @pagetable_setup_done:	platform specific post paging_init() call
  */
 struct x86_init_paging {
+	/* @mr:     (in) memory range to map
+	 * @pgt_start - @pgt_top:  (out) memory allocated for the kernel
+	 *								pagetable pages
+	 */
+	void (*kernel_pagetable_alloc)(struct map_range *mr,
+		unsigned long *pgt_start,
+		unsigned long *pgt_top);
+	/* @pgt_start - @pgt_end: memory region used for the kernel
+	 *							pagetable pages
+	 */
+	void (*kernel_pagetable_reserve)(unsigned long pgt_start,
+			unsigned long pgt_end);
 	void (*pagetable_setup_start)(pgd_t *base);
 	void (*pagetable_setup_done)(pgd_t *base);
 };
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index c11514e..1048a3d 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -62,6 +62,8 @@ struct x86_init_ops x86_init __initdata = {
 	},
 
 	.paging = {
+		.kernel_pagetable_alloc = native_kernel_pagetable_alloc,
+		.kernel_pagetable_reserve = native_kernel_pagetable_reserve,
 		.pagetable_setup_start	= native_pagetable_setup_start,
 		.pagetable_setup_done	= native_pagetable_setup_done,
 	},
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 286d289..67d0792 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -30,11 +30,21 @@ int direct_gbpages
 #endif
 ;
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
+void __init native_kernel_pagetable_alloc(struct map_range *mr,
+		unsigned long *pgt_start,
+		unsigned long *pgt_top)
 {
-	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
+	unsigned long puds, pmds, ptes, tables, start = 0,
+	end = mr->end, good_end = end;
 	phys_addr_t base;
+	int use_pse = mr->page_size_mask & PG_LEVEL_2M;
+	int use_gbpages = mr->page_size_mask & PG_LEVEL_1G;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
@@ -73,19 +83,20 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 	if (base == MEMBLOCK_ERROR)
 		panic("Cannot find space for the kernel page tables");
 
-	pgt_buf_start = base >> PAGE_SHIFT;
-	pgt_buf_end = pgt_buf_start;
-	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
+	*pgt_start = base >> PAGE_SHIFT;
+	*pgt_top = *pgt_start + (tables >> PAGE_SHIFT);
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
+		end, *pgt_start << PAGE_SHIFT, *pgt_top << PAGE_SHIFT);
 }
 
-struct map_range {
-	unsigned long start;
-	unsigned long end;
-	unsigned page_size_mask;
-};
+void __init native_kernel_pagetable_reserve(unsigned long pgt_start,
+		unsigned long pgt_end)
+{
+	if (pgt_start > pgt_end)
+		memblock_x86_reserve_range(pgt_start << PAGE_SHIFT,
+				pgt_end << PAGE_SHIFT, "PGTABLE");
+}
 
 #ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
@@ -257,9 +268,15 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * memory mapped. Unfortunately this is done currently before the
 	 * nodes are discovered.
 	 */
-	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
-
+	if (!after_bootmem) {
+		struct map_range map;
+		map.start = start;
+		map.end = end;
+		map.page_size_mask = page_size_mask;
+		x86_init.paging.kernel_pagetable_alloc(&map, &pgt_buf_start, &pgt_buf_top);
+		pgt_buf_end = pgt_buf_start;
+	}
+		
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
 						   mr[i].page_size_mask);
@@ -272,9 +289,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	__flush_tlb_all();
 
-	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
-		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
-				 pgt_buf_end << PAGE_SHIFT, "PGTABLE");
+	if (!after_bootmem)
+		x86_init.paging.kernel_pagetable_reserve(pgt_buf_start, pgt_buf_end);
 
 	if (!after_bootmem)
 		early_memtest(start, end);
