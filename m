Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1C1TEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:04:44 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:9380 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab1C1TEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:04:43 -0400
X-IronPort-AV: E=Sophos;i="4.63,257,1299456000"; 
   d="scan'208";a="5013407"
Date: Mon, 28 Mar 2011 20:04:44 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: another pagetable initialization crash on xen
In-Reply-To: <alpine.DEB.2.00.1103281729190.5516@kaball-desktop>
Message-ID: <alpine.DEB.2.00.1103281929390.5516@kaball-desktop>
References: <alpine.DEB.2.00.1103281729190.5516@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Stefano Stabellini wrote:
> Hi Yinghai,
> unfortunately I found another pagetable initialization bug on xen
> affecting linux 2.6.39-rc0.
> The problem is that on xen we need to make sure that all the pagetable pages
> are mapped read-only, in fact in xen_set_pte we have this check:
> 
> if (pfn >= pgt_buf_start && pfn < pgt_buf_end)
>     /* make the pte read-only */
> 
> however pgt_buf_end is where the kernel pagetable *currently* ends, so
> some kernel pagetable pages allocated after pgt_buf_end might be marked
> read-write by mistake.  A simple way to fix the issue would be to use
> pgt_buf_top instead:
> 
> if (pfn >= pgt_buf_start && pfn < pgt_buf_top)
>     /* make the pte read-only */
> 
> however after building the kernel pagetable in init_memory_mapping we
> only reserve memory between pgt_buf_start and pgt_buf_end:
> 
> if (!after_bootmem && pgt_buf_end > pgt_buf_start)
>         memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
>                  pgt_buf_end << PAGE_SHIFT, "PGTABLE");
> 
> so feature allocations might use memory between the final value of
> pgt_buf_end and pgt_buf_top that has been marked read-only in the xen
> specific code, causing a crash.
> The only way I could find to fix the crash is to reserve also the memory
> region between pgt_buf_start and pgt_buf_top on xen, but that would
> require an ugly if(xen_domain()) at the of init_memory_mapping or
> the introduction of a new pvop function to reserve the pagetable memory.
> I don't like the idea, but I couldn't find anything better.
> Yinghai, do you have any better suggestions?

Just to make it clearer, this is the not-so-pretty patch I am talking
about:

---



diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 7db7723..49e7f36 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -299,6 +299,7 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 /* Install a pte for a particular vaddr in kernel space. */
 void set_pte_vaddr(unsigned long vaddr, pte_t pte);
 
+void native_kernel_pagetable_reserve(void);
 #ifdef CONFIG_X86_32
 extern void native_pagetable_setup_start(pgd_t *base);
 extern void native_pagetable_setup_done(pgd_t *base);
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 643ebf2..214ee51 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -73,6 +73,7 @@ struct x86_init_oem {
  * @pagetable_setup_done:	platform specific post paging_init() call
  */
 struct x86_init_paging {
+	void (*kernel_pagetable_reserve)(void);
 	void (*pagetable_setup_start)(pgd_t *base);
 	void (*pagetable_setup_done)(pgd_t *base);
 };
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index c11514e..a0e920c 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -62,6 +62,7 @@ struct x86_init_ops x86_init __initdata = {
 	},
 
 	.paging = {
+		.kernel_pagetable_reserve = native_kernel_pagetable_reserve,
 		.pagetable_setup_start	= native_pagetable_setup_start,
 		.pagetable_setup_done	= native_pagetable_setup_done,
 	},
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 286d289..07a9aa6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -109,6 +109,13 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
+void __init native_kernel_pagetable_reserve(void)
+{
+	if (pgt_buf_end > pgt_buf_start)
+		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
+				pgt_buf_end << PAGE_SHIFT, "PGTABLE");
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -272,10 +279,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	__flush_tlb_all();
 
-	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
-		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
-				 pgt_buf_end << PAGE_SHIFT, "PGTABLE");
-
+	if (!after_bootmem)
+		x86_init.paging.kernel_pagetable_reserve();
+		
 	if (!after_bootmem)
 		early_memtest(start, end);
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index c82df6c..30b768f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1275,6 +1275,13 @@ static __init void xen_pagetable_setup_start(pgd_t *base)
 {
 }
 
+static __init void xen_kernel_pagetable_reserve(void)
+{
+	if (pgt_buf_end > pgt_buf_start)
+		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
+				pgt_buf_top << PAGE_SHIFT, "PGTABLE");
+}
+
 static void xen_post_allocator_init(void);
 
 static __init void xen_pagetable_setup_done(pgd_t *base)
@@ -2100,6 +2107,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
 void __init xen_init_mmu_ops(void)
 {
+	x86_init.paging.kernel_pagetable_reserve = xen_kernel_pagetable_reserve;
 	x86_init.paging.pagetable_setup_start = xen_pagetable_setup_start;
 	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
