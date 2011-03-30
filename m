Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1C3QZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:25:43 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:47266 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab1C3QZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:25:42 -0400
X-IronPort-AV: E=Sophos;i="4.63,269,1299456000"; 
   d="scan'208";a="5056119"
Date: Wed, 30 Mar 2011 17:26:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: another pagetable initialization crash on xen
In-Reply-To: <4D9221DA.90900@kernel.org>
Message-ID: <alpine.DEB.2.00.1103301714250.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103281729190.5516@kaball-desktop> <alpine.DEB.2.00.1103281929390.5516@kaball-desktop> <alpine.DEB.2.00.1103291620560.16492@kaball-desktop> <4D9221DA.90900@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011, Yinghai Lu wrote:
> 1. x86_init.paging is the right place for those two functions?
> 2. native_kernel_pagetable_alloc... should be function that do FIND + RESERVE.
>     or We just have one function : free_not_used with (pgt_buf_end, pgt_buf_top) ?

I like this suggestion very much!
I just added a single hook called x86_init.mapping.pagetable_free that
is a noop on native but on Xen set the memory from RO to RW.
How does it look like now?


I have another unrelated question: init_memory_mapping is called on the
range 0 - max_low_pfn, but that range usually includes a reserved region
below the first MB. On one machine of mine the IOAPIC mmio region falls
in that memory range therefore we are mapping the IOAPIC mmio region in
init_memory_mapping without going through the fixmap as we should.
This is causing problems on Xen, but I guess it could theoretically
cause problems on other platforms as well. Should we avoid reserved
memory regions below the first MB from the initial memory mappings?


---

commit fca74103af73ef871174fcd627c2317991f28911
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Wed Mar 30 16:17:33 2011 +0000

    x86,xen: introduce x86_init.mapping.pagetable_free
    
    Introduce a new x86_init hook called pagetable_free that is a noop on
    native but on xen makes sure that the spare memory previously allocated
    for kernel pagetable pages can be used for other purposes (set the
    corresponding pagetable entries from RO to RW).
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 643ebf2..38df202 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -68,6 +68,14 @@ struct x86_init_oem {
 };
 
 /**
+ * struct x86_init_mapping - platform specific initial kernel mappings setup
+ * @pagetable_free:	free a range of unused kernel pagetable memory
+ */
+struct x86_init_mapping {
+	void (*pagetable_free)(unsigned long start_pfn, unsigned long end_pfn);
+};
+
+/**
  * struct x86_init_paging - platform specific paging functions
  * @pagetable_setup_start:	platform specific pre paging_init() call
  * @pagetable_setup_done:	platform specific post paging_init() call
@@ -123,6 +131,7 @@ struct x86_init_ops {
 	struct x86_init_mpparse		mpparse;
 	struct x86_init_irqs		irqs;
 	struct x86_init_oem		oem;
+	struct x86_init_mapping		mapping;
 	struct x86_init_paging		paging;
 	struct x86_init_timers		timers;
 	struct x86_init_iommu		iommu;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index c11514e..07e4fdc 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -24,6 +24,7 @@
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
+void __init x86_init_ul_ul_noop(unsigned long u1, unsigned long u2) { }
 void __init x86_init_pgd_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
@@ -61,6 +62,10 @@ struct x86_init_ops x86_init __initdata = {
 		.banner			= default_banner,
 	},
 
+	.mapping = {
+		.pagetable_free			= x86_init_ul_ul_noop,
+	},
+
 	.paging = {
 		.pagetable_setup_start	= native_pagetable_setup_start,
 		.pagetable_setup_done	= native_pagetable_setup_done,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 286d289..afea949 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -272,10 +272,13 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	__flush_tlb_all();
 
-	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
+	if (!after_bootmem && pgt_buf_end > pgt_buf_start) {
 		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
 				 pgt_buf_end << PAGE_SHIFT, "PGTABLE");
 
+		x86_init.mapping.pagetable_free(pgt_buf_end, pgt_buf_top);
+	}
+
 	if (!after_bootmem)
 		early_memtest(start, end);
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index c82df6c..14ce8e5 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1275,6 +1275,18 @@ static __init void xen_pagetable_setup_start(pgd_t *base)
 {
 }
 
+static __init void xen_mapping_pagetable_free(unsigned long start_pfn,
+		unsigned long end_pfn)
+{
+	unsigned long pfn = start_pfn;
+	printk(KERN_DEBUG "xen: setting RW the range %lx - %lx\n",
+			start_pfn << PAGE_SHIFT, end_pfn << PAGE_SHIFT);
+	while (pfn < end_pfn) {
+		make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
+		pfn++;
+	}
+}
+
 static void xen_post_allocator_init(void);
 
 static __init void xen_pagetable_setup_done(pgd_t *base)
@@ -2100,6 +2112,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
 void __init xen_init_mmu_ops(void)
 {
+	x86_init.mapping.pagetable_free = xen_mapping_pagetable_free;
 	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
 	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
