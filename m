Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1IZSXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:23:38 -0400
Received: from claw.goop.org ([74.207.240.146]:32947 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1IZSXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:23:37 -0400
Message-ID: <4E80A6BD.3070703@goop.org>
Date: Mon, 26 Sep 2011 09:22:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        stable@kernel.org
Subject: Re: [PATCH] x86/paravirt: Partially revert "remove lazy mode in interrupts"
References: <1317042797-19975-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1317042797-19975-1-git-send-email-konrad.wilk@oracle.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 06:13 AM, Konrad Rzeszutek Wilk wrote:
> which has git commit b8bcfe997e46150fedcc3f5b26b846400122fdd9.
>
> The unintended consequence of removing the flushing of MMU
> updates when doing kmap_atomic (or kunmap_atomic) is that we can
> hit a dereference bug when processing a "fork()" under a heavy loaded
> machine. Specifically we can hit:

The patch is all OK, but I wouldn't have headlined it as a "partial
revert" - the important point is that the pte updates in k(un)map_atomic
need to be synchronous, regardless of whether we're in lazy_mmu mode.

The fact that b8bcfe997e4 introduced the problem is interesting to note,
but only somewhat relevant to the analysis of what's being fixed here.

    J

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
> The problem looks that in copy_page_range we turn lazy mode on, and then
> in swap_entry_free we call swap_count_continued which ends up in:
>
>          map = kmap_atomic(page, KM_USER0) + offset;
>
> and then later touches *map.
>
> Since we are running in batched mode (lazy) we don't actually set up the
> PTE mappings and the kmap_atomic is not done synchronously and ends up
> trying to dereference a page that has not been set.
>
> Looking at kmap_atomic_prot_pfn, it uses 'arch_flush_lazy_mmu_mode' and
> sprinkling that in kmap_atomic_prot and __kunmap_atomic makes the problem
> go away.
>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: x86@kernel.org
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: stable@kernel.org
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/mm/highmem_32.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
> index b499626..f4f29b1 100644
> --- a/arch/x86/mm/highmem_32.c
> +++ b/arch/x86/mm/highmem_32.c
> @@ -45,6 +45,7 @@ void *kmap_atomic_prot(struct page *page, pgprot_t prot)
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

