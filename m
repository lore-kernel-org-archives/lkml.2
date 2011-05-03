Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab1ECAzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:55:47 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47007 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab1ECAzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:55:45 -0400
Date: Tue, 3 May 2011 02:55:27 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        yinghai@kernel.org, hpa@zytor.com, xen-devel@lists.xensource.com
Subject: Re: [PATCH 1/2] xen/mmu: Add workaround "x86-64, mm: Put early page table high"
Message-ID: <20110503005527.GA6735@router-fw-old.local.net-space.pl>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com> <1304356942-17656-2-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304356942-17656-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 01:22:21PM -0400, Konrad Rzeszutek Wilk wrote:
> As a consequence of the commit:
>
> commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Fri Dec 17 16:58:28 2010 -0800
>
>     x86-64, mm: Put early page table high
>
> it causes the Linux kernel to crash under Xen:
>
> mapping kernel into physical memory
> Xen: setup ISA identity maps
> about to get started...
> (XEN) mm.c:2466:d0 Bad type (saw 7400000000000001 != exp 1000000000000000) for mfn b1d89 (pfn bacf7)
> (XEN) mm.c:3027:d0 Error while pinning mfn b1d89
> (XEN) traps.c:481:d0 Unhandled invalid opcode fault/trap [#6] on VCPU 0 [ec=0000]
> (XEN) domain_crash_sync called from entry.S
> (XEN) Domain 0 (vcpu#0) crashed on cpu#0:
> ...

I was hit by this bug when I was working on memory hotplug.
After some investigation I found myself above mentioned patch
as a guilty and later I discovered that you are working on that
issue. I have tested your patch and discoverd some issues with it.
First of all it has compilation issues on gcc version 4.1.2 20061115
(prerelease) (Debian 4.1.1-21). Details below.

Additionlly, I think that your patch does not work as you expected.
I found that git commit 24bdb0b62cc82120924762ae6bc85afc8c3f2b26
(xen: do not create the extra e820 region at an addr lower than 4G)
do this work (to some extent). When this patch is removed domU
is crashing with following error:

(early) Linux version 2.6.39-rc5-x86_64.xenU.all.r0+ (root@dev-00) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #5 SMP Tue May 3 01:43:26 CEST 2011
(early) Command line: root=/dev/xvda debug earlyprintk=xen noapic nolapic console=hvc0
(early) ACPI in unprivileged domain disabled
(early) released 0 pages of unused memory
(early) Set 0 page(s) to 1-1 mapping.
(early) BIOS-provided physical RAM map:
(early)  Xen: 0000000000000000 - 00000000000a0000 (usable)
(early)  Xen: 00000000000a0000 - 0000000000100000 (reserved)
(early)  Xen: 0000000000100000 - 0000000026000000 (usable)
(early) bootconsole [xenboot0] enabled
(early) NX (Execute Disable) protection: active
(early) DMI not present or invalid.
(early) e820 update range: 0000000000000000 - 0000000000010000 (early) (usable)(early)  ==> (early) (reserved)(early)
(early) e820 remove range: 00000000000a0000 - 0000000000100000 (early) (usable)(early)
(early) No AGP bridge found
(early) last_pfn = 0x26000 max_arch_pfn = 0x400000000
(early) initial memory mapped : 0 - 01693000
(early) Base memory trampoline at [ffff88000009e000] 9e000 size 8192
(early) init_memory_mapping: 0000000000000000-0000000026000000
(early)  0000000000 - 0026000000 page 4k
(early) kernel direct mapping tables up to 26000000 @ 256ce000-25800000
(early) BUG: unable to handle kernel (early) NULL pointer dereference(early)  at           (null)
(early) IP:(early)  [<ffffffff814a33f2>] find_range_array+0x4e/0x57
(early) PGD 0 (early)
(early) Oops: 0003 [#1] (early) SMP (early)
(early) last sysfs file:
(early) CPU 0 (early)
(early) Modules linked in:(early)
(early)
(early) Pid: 0, comm: swapper Not tainted 2.6.39-rc5-x86_64.xenU.all.r0+ #5(early)   (early)
(early) RIP: e030:[<ffffffff814a33f2>] (early)  [<ffffffff814a33f2>] find_range_array+0x4e/0x57
(early) RSP: e02b:ffffffff81427e58  EFLAGS: 00010046
(early) RAX: 0000000000000000 RBX: 00000000000000e0 RCX: 00000000000000e0
(early) RDX: ffff8800257fff20 RSI: 00000000257fff20 RDI: ffff8800257fff20
(early) RBP: ffffffff81427e68 R08: 0000000000000005 R09: 0000000000000050
(early) R10: 0000000000000005 R11: 0000000025800000 R12: ffffffff814bd000
(early) R13: 0000000000000000 R14: 000000000000000e R15: 0000000000001000
(early) FS:  0000000000000000(0000) GS:ffffffff8147f000(0000) knlGS:0000000000000000
(early) CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
(early) CR2: 0000000000000000 CR3: 0000000001441000 CR4: 0000000000002660
(early) DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
(early) DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
(early) Process swapper (pid: 0, threadinfo ffffffff81426000, task ffffffff81449020)
(early) Stack:
(early)  ffffffff81427e88(early)  0000000000000000(early)  ffffffff81427ea8(early)  ffffffff814a343d(early)
(early)  0000000000000100(early)  0000000026000000(early)  ffffffff814bd000(early)  ffffffffffffffff(early)
(early)  0000000000000000(early)  0000000000000000(early)  ffffffff81427eb8(early)  ffffffff814a3577(early)
(early) Call Trace:
(early)  [<ffffffff814a343d>] __memblock_x86_memory_in_range+0x42/0x171
(early)  [<ffffffff814a3577>] memblock_x86_memory_in_range+0xb/0xd
(early)  [<ffffffff81497348>] memblock_find_dma_reserve+0x15/0x3b
(early)  [<ffffffff81496b50>] setup_arch+0x721/0x7e5
(early)  [<ffffffff810065fd>] ? __raw_callee_save_xen_irq_disable+0x11/0x1e
(early)  [<ffffffff81493955>] start_kernel+0x8a/0x2db
(early)  [<ffffffff81493299>] x86_64_start_reservations+0x84/0x88
(early)  [<ffffffff814947d9>] xen_start_kernel+0x3e1/0x3e8
(early) Code: (early) 66 (early) 00 (early) 00 (early) 48 (early) 85 (early) c0 (early) 75 (early) 0c (early) 48 (early) c7 (early) c7 (early) 86 (early) 80 (early) 3a (early) 81 (early) e8 (early) 55 (early) 41 (early) b9 (early) ff (early) 48 (early) bf (early) 00 (early) 00 (early) 00 (early) 00 (early) 00 (early) 88 (early) ff (early) ff (early) 48 (early) 89 (early) d9 (early) 48 (early) 8d (early) 14 (early) 38 (early) 31 (early) c0 (early) fc (early) 48 (early) 89 (early) d7 (early) <f3> (early) aa (early) 48 (early) 89 (early) d0 (early) 5f (early) 5b (early) c9 (early) c3 (early) 55 (early) 48 (early) 89 (early) e5 (early) 41 (early) 57 (early) 49 (early) 89 (early) f7 (early) 49 (early) c1 (early) ef (early)
(early) RIP (early)  [<ffffffff814a33f2>] find_range_array+0x4e/0x57
(early)  RSP <ffffffff81427e58>
(early) CR2: 0000000000000000
(early) ---[ end trace 4eaa2a86a8e2da22 ]---
(early) Kernel panic - not syncing: Attempted to kill the idle task!
(early) Pid: 0, comm: swapper Tainted: G      D     2.6.39-rc5-x86_64.xenU.all.r0+ #5
(early) Call Trace:
(early)  [<ffffffff810375ed>] panic+0xbd/0x1c7
(early)  [<ffffffff810383c7>] ? printk+0x67/0x69
(early)  [<ffffffff811fd7b0>] ? account+0xe1/0xf0
(early)  [<ffffffff8103a641>] do_exit+0xb4/0x676
(early)  [<ffffffff81037b53>] ? spin_unlock_irqrestore+0x9/0xb
(early)  [<ffffffff81038c24>] ? kmsg_dump+0x4a/0xd9
(early)  [<ffffffff8100d11d>] oops_end+0xc1/0xc9
(early)  [<ffffffff810252b1>] no_context+0x1f5/0x204
(early)  [<ffffffff81025448>] __bad_area_nosemaphore+0x188/0x1ab
(early)  [<ffffffff810065df>] ? __raw_callee_save_xen_restore_fl+0x11/0x1e
(early)  [<ffffffff810254e1>] bad_area_nosemaphore+0xe/0x10
(early)  [<ffffffff81025991>] do_page_fault+0x18c/0x337
(early)  [<ffffffff810065df>] ? __raw_callee_save_xen_restore_fl+0x11/0x1e
(early)  [<ffffffff810065df>] ? __raw_callee_save_xen_restore_fl+0x11/0x1e
(early)  [<ffffffff810065df>] ? __raw_callee_save_xen_restore_fl+0x11/0x1e
(early)  [<ffffffff812eebd5>] page_fault+0x25/0x30
(early)  [<ffffffff814a33f2>] ? find_range_array+0x4e/0x57
(early)  [<ffffffff814a33ca>] ? find_range_array+0x26/0x57
(early)  [<ffffffff814a343d>] __memblock_x86_memory_in_range+0x42/0x171
(early)  [<ffffffff814a3577>] memblock_x86_memory_in_range+0xb/0xd
(early)  [<ffffffff81497348>] memblock_find_dma_reserve+0x15/0x3b
(early)  [<ffffffff81496b50>] setup_arch+0x721/0x7e5
(early)  [<ffffffff810065fd>] ? __raw_callee_save_xen_irq_disable+0x11/0x1e
(early)  [<ffffffff81493955>] start_kernel+0x8a/0x2db
(early)  [<ffffffff81493299>] x86_64_start_reservations+0x84/0x88
(early)  [<ffffffff814947d9>] xen_start_kernel+0x3e1/0x3e8

I think that (Stefano please confirm or not) this patch was prepared
as workaround for similar issues. However, I do not like this patch
because on systems with small amount of memory it leaves huge (to some
extent) hole between max_low_pfn and 4G. Additionally, it affects
memory hotplug a bit because it allocates memory starting from current
max_mfn. It also breaks memory hotplug on i386 (maybe also others
thinks, however, I could not confirm that). If it stay for some
reason it should be amended in follwing way:

#ifdef CONFIG_X86_32
        xen_extra_mem_start = mem_end;
#else
        xen_extra_mem_start = max((1ULL << 32), mem_end);
#endif

Regarding comment for this patch it should be mentioned that without this
patch e820_end_of_low_ram_pfn() is not broken. It is not called simply.

Last but least. I found that memory sizes below and including exactly 1 GiB and
exactly 2 GiB, 3 GiB (maybe higher, i.e. 4 GiB, 5 GiB, ...; I was not able to test
them because I do not have sufficient memory) are magic. It means that if memory
is set with those sizes everything is working good (without 4b239f458c229de044d6905c2b0f9fe16ed9e01e
and 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 applied). It means that domU
should be tested with sizes which are not power of two nor multiple of that.

> The reason is that at some point init_memory_mapping is going to reach
> the pagetable pages area and map those pages too (mapping them as normal
> memory that falls in the range of addresses passed to init_memory_mapping
> as argument). Some of those pages are already pagetable pages (they are
> in the range pgt_buf_start-pgt_buf_end) therefore they are going to be
> mapped RO and everything is fine.
> Some of these pages are not pagetable pages yet (they fall in the range
> pgt_buf_end-pgt_buf_top; for example the page at pgt_buf_end) so they
> are going to be mapped RW.  When these pages become pagetable pages and
> are hooked into the pagetable, xen will find that the guest has already
> a RW mapping of them somewhere and fail the operation.
> The reason Xen requires pagetables to be RO is that the hypervisor needs
> to verify that the pagetables are valid before using them. The validation
> operations are called "pinning" (more details in arch/x86/xen/mmu.c).
> 
> In order to fix the issue we mark all the pages in the entire range
> pgt_buf_start-pgt_buf_top as RO, however when the pagetable allocation
> is completed only the range pgt_buf_start-pgt_buf_end is reserved by
> init_memory_mapping. Hence the kernel is going to crash as soon as one
> of the pages in the range pgt_buf_end-pgt_buf_top is reused (b/c those
> ranges are RO).
> 
> For this reason, this function is introduced which is called _after_
> the init_memory_mapping has completed (in a perfect world we would
> call this function from init_memory_mapping, but lets ignore that).
> 
> Because we are called _after_ init_memory_mapping the pgt_buf_[start,
> end,top] have all changed to new values (b/c another init_memory_mapping
> is called). Hence, the first time we enter this function, we save
> away the pgt_buf_start value and update the pgt_buf_[end,top].
> 
> When we detect that the "old" pgt_buf_start through pgt_buf_end
> PFNs have been reserved (so memblock_x86_reserve_range has been called),
> we immediately set out to RW the "old" pgt_buf_end through pgt_buf_top.
> 
> And then we update those "old" pgt_buf_[end|top] with the new ones
> so that we can redo this on the next pagetable.
> 
> Reviewed-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> [v1: Updated with Jeremy's comments]
> [v2: Added the crash output]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 123 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index aef7af9..1bca25f 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1463,6 +1463,119 @@ static int xen_pgd_alloc(struct mm_struct *mm)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_X86_64
> +static __initdata u64 __last_pgt_set_rw = 0;
> +static __initdata u64 __pgt_buf_start = 0;
> +static __initdata u64 __pgt_buf_end = 0;
> +static __initdata u64 __pgt_buf_top = 0;

Please look into include/linux/init.h for proper
usage of __init macros. It should be changed to

static u64 __last_pgt_set_rw __initdata = 0;
...
...

Additionally,

static const struct pv_mmu_ops xen_mmu_ops __initdata = {

should be changed to:

static const struct pv_mmu_ops xen_mmu_ops __initconst = {

It is not in your patch, however, it conflicts
with your definitions.

> +/*
> + * As a consequence of the commit:
> + * 
> + * commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e
> + * Author: Yinghai Lu <yinghai@kernel.org>
> + * Date:   Fri Dec 17 16:58:28 2010 -0800
> + * 
> + *     x86-64, mm: Put early page table high
> + * 
> + * at some point init_memory_mapping is going to reach the pagetable pages
> + * area and map those pages too (mapping them as normal memory that falls
> + * in the range of addresses passed to init_memory_mapping as argument).
> + * Some of those pages are already pagetable pages (they are in the range
> + * pgt_buf_start-pgt_buf_end) therefore they are going to be mapped RO and
> + * everything is fine.
> + * Some of these pages are not pagetable pages yet (they fall in the range
> + * pgt_buf_end-pgt_buf_top; for example the page at pgt_buf_end) so they
> + * are going to be mapped RW.  When these pages become pagetable pages and
> + * are hooked into the pagetable, xen will find that the guest has already
> + * a RW mapping of them somewhere and fail the operation.
> + * The reason Xen requires pagetables to be RO is that the hypervisor needs
> + * to verify that the pagetables are valid before using them. The validation
> + * operations are called "pinning".
> + * 
> + * In order to fix the issue we mark all the pages in the entire range
> + * pgt_buf_start-pgt_buf_top as RO, however when the pagetable allocation
> + * is completed only the range pgt_buf_start-pgt_buf_end is reserved by
> + * init_memory_mapping. Hence the kernel is going to crash as soon as one
> + * of the pages in the range pgt_buf_end-pgt_buf_top is reused (b/c those
> + * ranges are RO).
> + * 
> + * For this reason, 'mark_rw_past_pgt' is introduced which is called _after_
> + * the init_memory_mapping has completed (in a perfect world we would
> + * call this function from init_memory_mapping, but lets ignore that).
> + * 
> + * Because we are called _after_ init_memory_mapping the pgt_buf_[start,
> + * end,top] have all changed to new values (b/c init_memory_mapping
> + * is called and setting up another new page-table). Hence, the first time
> + * we enter this function, we save away the pgt_buf_start value and update
> + * the pgt_buf_[end,top].
> + * 
> + * When we detect that the "old" pgt_buf_start through pgt_buf_end
> + * PFNs have been reserved (so memblock_x86_reserve_range has been called),
> + * we immediately set out to RW the "old" pgt_buf_end through pgt_buf_top.
> + * 
> + * And then we update those "old" pgt_buf_[end|top] with the new ones
> + * so that we can redo this on the next pagetable.
> + */
> +static __init void mark_rw_past_pgt(void) {

Please look into include/linux/init.h. I found much more similar
mistakes in current Xen code. I will prepare relevant patch
shortly.

> +	if (pgt_buf_end > pgt_buf_start) {
> +		u64 addr, size;
> +
> +		/* Save it away. */
> +		if (!__pgt_buf_start) {
> +			__pgt_buf_start = pgt_buf_start;
> +			__pgt_buf_end = pgt_buf_end;
> +			__pgt_buf_top = pgt_buf_top;
> +			return;
> +		}
> +		/* If we get the range that starts at __pgt_buf_end that means
> +		 * the range is reserved, and that in 'init_memory_mapping'
> +		 * the 'memblock_x86_reserve_range' has been called with the
> +		 * outdated __pgt_buf_start, __pgt_buf_end (the "new"
> +		 * pgt_buf_[start|end|top] refer now to a new pagetable.
> +		 * Note: we are called _after_ the pgt_buf_[..] have been
> +		 * updated.*/
> +
> +		addr = memblock_x86_find_in_range_size(PFN_PHYS(__pgt_buf_start),
> +						       &size, PAGE_SIZE);
> +
> +		/* Still not reserved, meaning 'memblock_x86_reserve_range'
> +		 * hasn't been called yet. Update the _end and _top.*/
> +		if (addr == PFN_PHYS(__pgt_buf_start)) {
> +			__pgt_buf_end = pgt_buf_end;
> +			__pgt_buf_top = pgt_buf_top;
> +			return;
> +		}
> +
> +		/* OK, the area is reserved, meaning it is time for us to
> +		 * set RW for the old end->top PFNs. */
> +
> +		/* ..unless we had already done this. */
> +		if (__pgt_buf_end == __last_pgt_set_rw)
> +			return;
> +
> +		addr = PFN_PHYS(__pgt_buf_end);
> +		
> +		/* set as RW the rest */
> +		printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n",
> +			PFN_PHYS(__pgt_buf_end), PFN_PHYS(__pgt_buf_top));
> +		
> +		while (addr < PFN_PHYS(__pgt_buf_top)) {
> +			make_lowmem_page_readwrite(__va(addr));
> +			addr += PAGE_SIZE;
> +		}
> +		/* And update everything so that we are ready for the next
> +		 * pagetable (the one created for regions past 4GB) */
> +		__last_pgt_set_rw = __pgt_buf_end;
> +		__pgt_buf_start = pgt_buf_start;
> +		__pgt_buf_end = pgt_buf_end;
> +		__pgt_buf_top = pgt_buf_top;
> +	}
> +	return;

I think that this return is superfluous.

> +}
> +#else
> +static __init void mark_rw_past_pgt(void) { }

Dito.

> +#endif
>  static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
>  {
>  #ifdef CONFIG_X86_64
> @@ -1489,6 +1602,14 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
>  	unsigned long pfn = pte_pfn(pte);
>  
>  	/*
> +	 * A bit of optimization. We do not need to call the workaround
> +	 * when xen_set_pte_init is called with a PTE with 0 as PFN.
> +	 * That is b/c the pagetable at that point are just being populated
> +	 * with empty values and we can save some cycles by not calling
> +	 * the 'memblock' code.*/
> +	if (pfn)
> +		mark_rw_past_pgt();
> +	/*
>  	 * If the new pfn is within the range of the newly allocated
>  	 * kernel pagetable, and it isn't being mapped into an
>  	 * early_ioremap fixmap slot as a freshly allocated page, make sure
> @@ -1997,6 +2118,8 @@ __init void xen_ident_map_ISA(void)
>  
>  static __init void xen_post_allocator_init(void)

Dito.

Daniel
