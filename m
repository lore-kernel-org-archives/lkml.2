Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013Ab1DNOts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:49:48 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:2858 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926Ab1DNOtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:49:47 -0400
X-IronPort-AV: E=Sophos;i="4.64,211,1301875200"; 
   d="scan'208";a="5307702"
Date: Thu, 14 Apr 2011 15:49:41 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/4] x86,xen: introduce
 x86_init.mapping.pagetable_reserve
In-Reply-To: <alpine.DEB.2.00.1104141218110.22672@kaball-desktop>
Message-ID: <alpine.DEB.2.00.1104141524250.10886@kaball-desktop>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com> <4DA5EAE4.2060406@linux.intel.com> <alpine.DEB.2.00.1104141218110.22672@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Stefano Stabellini wrote:
> On Wed, 13 Apr 2011, H. Peter Anvin wrote:
> > On 04/12/2011 04:19 AM, stefano.stabellini@eu.citrix.com wrote:
> > > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > 
> > > Introduce a new x86_init hook called pagetable_reserve that during the
> > > initial memory mapping is used to reserve a range of memory addresses for
> > > kernel pagetable usage.
> > > 
> > > On native it just calls memblock_x86_reserve_range while on xen it also
> > > takes care of setting the spare memory previously allocated
> > > for kernel pagetable pages from RO to RW, so that it can be used for
> > > other purposes.
> > > 
> > 
> > What are the *semantics* of this hook?
> > 
> > Hooks are insanely nasty if they are just defined by a particular code
> > flow, as evidenced by the royal mess called paravirt_ops.
> 
> I hope that the other email I have just sent clarifies the purpose of
> the hook.
> I admit that as it is it wouldn't find much usage outside
> init_memory_mapping.
> Maybe adding the corresponding hook to allocate the initial kernel
> pagetable pages would help generalizing it.  Or maybe we just need a
> better comment in the code:
> 
> 
> /* Reserve the kernel pagetable pages we used and free the other ones so
>  * that they can be reused for other purposes.
>  * 
>  * On native it just means calling memblock_x86_reserve_range, on Xen it
>  * also means marking RW the pagetable pages that we allocated before
>  * but that haven't been used here.
>  */
> if (!after_bootmem && pgt_buf_end > pgt_buf_start)
> 		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
> 				PFN_PHYS(pgt_buf_end));


I added a detailed explanation to the commit message and in the code, I
hope this version is better:


commit 6f97ad736f304d600669cba1498e788099cea2cd
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Wed Mar 30 16:17:33 2011 +0000

    x86,xen: introduce x86_init.mapping.pagetable_reserve
    
    Introduce a new x86_init hook called pagetable_reserve that at the end
    of init_memory_mapping is used to reserve a range of memory addresses for
    the kernel pagetable pages we used and free the other ones.
    
    On native it just calls memblock_x86_reserve_range while on xen it also
    takes care of setting the spare memory previously allocated
    for kernel pagetable pages from RO to RW, so that it can be used for
    other purposes.
    
    A detailed explanation of the reason why this hook is needed follows.
    
    As a consequence of the commit:
    
    commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e
    Author: Yinghai Lu <yinghai@kernel.org>
    Date:   Fri Dec 17 16:58:28 2010 -0800
    
        x86-64, mm: Put early page table high
    
    at some point init_memory_mapping is going to reach the pagetable pages
    area and map those pages too (mapping them as normal memory that falls
    in the range of addresses passed to init_memory_mapping as argument).
    Some of those pages are already pagetable pages (they are in the range
    pgt_buf_start-pgt_buf_end) therefore they are going to be mapped RO and
    everything is fine.
    Some of these pages are not pagetable pages yet (they fall in the range
    pgt_buf_end-pgt_buf_top; for example the page at pgt_buf_end) so they
    are going to be mapped RW.  When these pages become pagetable pages and
    are hooked into the pagetable, xen will find that the guest has already
    a RW mapping of them somewhere and fail the operation.
    The reason Xen requires pagetables to be RO is that the hypervisor needs
    to verify that the pagetables are valid before using them. The validation
    operations are called "pinning" (more details in arch/x86/xen/mmu.c).
    
    In order to fix the issue we mark all the pages in the entire range
    pgt_buf_start-pgt_buf_top as RO, however when the pagetable allocation
    is completed only the range pgt_buf_start-pgt_buf_end is reserved by
    init_memory_mapping. Hence the kernel is going to crash as soon as one
    of the pages in the range pgt_buf_end-pgt_buf_top is reused (b/c those
    ranges are RO).
    
    For this reason we need a hook to reserve the kernel pagetable pages we
    used and free the other ones so that they can be reused for other
    purposes.
    On native it just means calling memblock_x86_reserve_range, on Xen it
    also means marking RW the pagetable pages that we allocated before but
    that haven't been used before.
    
    Another way to fix this is without using the hook is by adding a 'if
    (xen_pv_domain)' in the 'init_memory_mapping' code and calling the Xen
    counterpart, but that is just nasty.
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    Acked-by: Yinghai Lu <yinghai@kernel.org>
    Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Cc: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 7db7723..d56187c 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -299,6 +299,7 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 /* Install a pte for a particular vaddr in kernel space. */
 void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
+extern void native_pagetable_reserve(u64 start, u64 end);
 #ifdef CONFIG_X86_32
 extern void native_pagetable_setup_start(pgd_t *base);
 extern void native_pagetable_setup_done(pgd_t *base);
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 643ebf2..d3d8590 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -68,6 +68,17 @@ struct x86_init_oem {
 };
 
 /**
+ * struct x86_init_mapping - platform specific initial kernel pagetable setup
+ * @pagetable_reserve:	reserve a range of addresses for kernel pagetable usage
+ *
+ * For more details on the purpose of this hook, look in
+ * init_memory_mapping and the commit that added it.
+ */
+struct x86_init_mapping {
+	void (*pagetable_reserve)(u64 start, u64 end);
+};
+
+/**
  * struct x86_init_paging - platform specific paging functions
  * @pagetable_setup_start:	platform specific pre paging_init() call
  * @pagetable_setup_done:	platform specific post paging_init() call
@@ -123,6 +134,7 @@ struct x86_init_ops {
 	struct x86_init_mpparse		mpparse;
 	struct x86_init_irqs		irqs;
 	struct x86_init_oem		oem;
+	struct x86_init_mapping		mapping;
 	struct x86_init_paging		paging;
 	struct x86_init_timers		timers;
 	struct x86_init_iommu		iommu;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index c11514e..75ef4b1 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -61,6 +61,10 @@ struct x86_init_ops x86_init __initdata = {
 		.banner			= default_banner,
 	},
 
+	.mapping = {
+		.pagetable_reserve		= native_pagetable_reserve,
+	},
+
 	.paging = {
 		.pagetable_setup_start	= native_pagetable_setup_start,
 		.pagetable_setup_done	= native_pagetable_setup_done,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 286d289..08fee27 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -81,6 +81,11 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
 }
 
+void native_pagetable_reserve(u64 start, u64 end)
+{
+	memblock_x86_reserve_range(start, end, "PGTABLE");
+}
+
 struct map_range {
 	unsigned long start;
 	unsigned long end;
@@ -272,9 +277,24 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	__flush_tlb_all();
 
+	/* 
+	 * Reserve the kernel pagetable pages we used (pgt_buf_start -
+	 * pgt_buf_end) and free the other ones (pgt_buf_end - pgt_buf_top)
+	 * so that they can be reused for other purposes.
+	 * 
+	 * On native it just means calling memblock_x86_reserve_range, on Xen it
+	 * also means marking RW the pagetable pages that we allocated before
+	 * but that haven't been used.
+	 *
+	 * In fact on xen we mark RO the whole range pgt_buf_start -
+	 * pgt_buf_top, because we have to make sure that when
+	 * init_memory_mapping reaches the pagetable pages area, it maps
+	 * RO all the pagetable pages, including the ones that are beyond
+	 * pgt_buf_end at that time.
+	 */
 	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
-		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
-				 pgt_buf_end << PAGE_SHIFT, "PGTABLE");
+		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
+				PFN_PHYS(pgt_buf_end));
 
 	if (!after_bootmem)
 		early_memtest(start, end);
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6b833db..7ad0292 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1275,6 +1275,20 @@ static __init void xen_pagetable_setup_start(pgd_t *base)
 {
 }
 
+static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
+{
+	/* reserve the range used */
+	native_pagetable_reserve(start, end);
+
+	/* set as RW the rest */
+	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n", end,
+			PFN_PHYS(pgt_buf_top));
+	while (end < PFN_PHYS(pgt_buf_top)) {
+		make_lowmem_page_readwrite(__va(end));
+		end += PAGE_SIZE;
+	}
+}
+
 static void xen_post_allocator_init(void);
 
 static __init void xen_pagetable_setup_done(pgd_t *base)
@@ -2100,6 +2114,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
 void __init xen_init_mmu_ops(void)
 {
+	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
 	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
 	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
