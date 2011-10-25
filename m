Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1JYS0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:26:19 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47305 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab1JYS0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:26:18 -0400
Date: Tue, 25 Oct 2011 14:24:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: akpm@google.com, linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, hpa@zytor.com, jeremy.fitzhardinge@citrix.com,
        mingo@redhat.com, stable@kernel.org, tglx@linutronix.de,
        mm-commits@vger.kernel.org
Subject: Not really merged? Re: [merged]
 x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
 removed from -mm tree
Message-ID: <20111025182450.GA9843@phenom.dumpdata.com>
References: <201110141951.p9EJpn3A006989@hpaq5.eem.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110141951.p9EJpn3A006989@hpaq5.eem.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4EA6FEFC.00E7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 12:51:48PM -0700, akpm@google.com wrote:
> 
> The patch titled
>      Subject: x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, regardless of lazy_mmu mode
> has been removed from the -mm tree.  Its filename was
>      x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
> 
> This patch was dropped because it was merged into mainline or a subsystem tree

Hey Andrew,

I am actually not seeing this in mainline? Was it accidently dropped out of your tree?

If that is the case I can convience you to put it back in or can I drive it to Linus with
your Ack-ed by?

> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Subject: x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, regardless of lazy_mmu mode
> 
> Fix an outstanding issue that has been reported since 2.6.37.  Under a
> heavy loaded machine processing "fork()" calls could crash with:
> 
> BUG: unable to handle kernel paging request at f573fc8c
> IP: [<c01abc54>] swap_count_continued+0x104/0x180
> *pdpt = 000000002a3b9027 *pde = 0000000001bed067 *pte = 0000000000000000
> Oops: 0000 [#1] SMP
> Modules linked in:
> Pid: 1638, comm: apache2 Not tainted 3.0.4-linode37 #1
> EIP: 0061:[<c01abc54>] EFLAGS: 00210246 CPU: 3
> EIP is at swap_count_continued+0x104/0x180
> .. snip..
> Call Trace:
>  [<c01ac222>] ? __swap_duplicate+0xc2/0x160
>  [<c01040f7>] ? pte_mfn_to_pfn+0x87/0xe0
>  [<c01ac2e4>] ? swap_duplicate+0x14/0x40
>  [<c01a0a6b>] ? copy_pte_range+0x45b/0x500
>  [<c01a0ca5>] ? copy_page_range+0x195/0x200
>  [<c01328c6>] ? dup_mmap+0x1c6/0x2c0
>  [<c0132cf8>] ? dup_mm+0xa8/0x130
>  [<c013376a>] ? copy_process+0x98a/0xb30
>  [<c013395f>] ? do_fork+0x4f/0x280
>  [<c01573b3>] ? getnstimeofday+0x43/0x100
>  [<c010f770>] ? sys_clone+0x30/0x40
>  [<c06c048d>] ? ptregs_clone+0x15/0x48
>  [<c06bfb71>] ? syscall_call+0x7/0xb
> 
> The problem is that in copy_page_range() we turn lazy mode on, and then in
> swap_entry_free() we call swap_count_continued() which ends up in:
> 
>          map = kmap_atomic(page, KM_USER0) + offset;
> 
> and then later we touch *map.
> 
> Since we are running in batched mode (lazy) we don't actually set up the
> PTE mappings and the kmap_atomic is not done synchronously and ends up
> trying to dereference a page that has not been set.
> 
> Looking at kmap_atomic_prot_pfn(), it uses 'arch_flush_lazy_mmu_mode' and
> doing the same in kmap_atomic_prot() and __kunmap_atomic() makes the problem
> go away.
> 
> Interestingly, commit b8bcfe997e4615 ("x86/paravirt: remove lazy mode in
> interrupts") removed part of this to fix an interrupt issue - but it went
> to far and did not consider this scenario.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: <stable@kernel.org>
> Signed-off-by: Andrew Morton <akpm@google.com>
> ---
> 
>  arch/x86/mm/highmem_32.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff -puN arch/x86/mm/highmem_32.c~x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode arch/x86/mm/highmem_32.c
> --- a/arch/x86/mm/highmem_32.c~x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode
> +++ a/arch/x86/mm/highmem_32.c
> @@ -45,6 +45,7 @@ void *kmap_atomic_prot(struct page *page
>  	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
>  	BUG_ON(!pte_none(*(kmap_pte-idx)));
>  	set_pte(kmap_pte-idx, mk_pte(page, prot));
> +	arch_flush_lazy_mmu_mode();
>  
>  	return (void *)vaddr;
>  }
> @@ -88,6 +89,7 @@ void __kunmap_atomic(void *kvaddr)
>  		 */
>  		kpte_clear_flush(kmap_pte-idx, vaddr);
>  		kmap_atomic_idx_pop();
> +		arch_flush_lazy_mmu_mode();
>  	}
>  #ifdef CONFIG_DEBUG_HIGHMEM
>  	else {
> _
> 
> Patches currently in -mm which might be from konrad.wilk@oracle.com are
> 
> origin.patch
> linux-next.patch
> stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch
