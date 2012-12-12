Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2LLEEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 23:04:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab2LLEEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 23:04:10 -0500
Date: Tue, 11 Dec 2012 22:57:23 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] KVM: MMU: adjust page size early if gfn used as
 page table
Message-ID: <20121212005723.GA2898@amt.cnet>
References: <50C5A747.1020105@linux.vnet.ibm.com>
 <50C5A79F.3020805@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C5A79F.3020805@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 05:13:03PM +0800, Xiao Guangrong wrote:
> We have two issues in current code:
> - if target gfn is used as its page table, guest will refault then kvm will use
>   small page size to map it. We need two #PF to fix its shadow page table
> 
> - sometimes, say a exception is triggered during vm-exit caused by #PF
>   (see handle_exception() in vmx.c), we remove all the shadow pages shadowed
>   by the target gfn before go into page fault path, it will cause infinite
>   loop:
>   delete shadow pages shadowed by the gfn -> try to use large page size to map
>   the gfn -> retry the access ->...
> 
> To fix these, We can adjust page size early if the target gfn is used as page
> table
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c         |   13 ++++---------
>  arch/x86/kvm/paging_tmpl.h |   33 ++++++++++++++++++++++++++++++++-
>  2 files changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 2a3c890..54fc61e 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2380,15 +2380,10 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	if (pte_access & ACC_WRITE_MASK) {
> 
>  		/*
> -		 * There are two cases:
> -		 * - the one is other vcpu creates new sp in the window
> -		 *   between mapping_level() and acquiring mmu-lock.
> -		 * - the another case is the new sp is created by itself
> -		 *   (page-fault path) when guest uses the target gfn as
> -		 *   its page table.
> -		 * Both of these cases can be fixed by allowing guest to
> -		 * retry the access, it will refault, then we can establish
> -		 * the mapping by using small page.
> +		 * Other vcpu creates new sp in the window between
> +		 * mapping_level() and acquiring mmu-lock. We can
> +		 * allow guest to retry the access, the mapping can
> +		 * be fixed if guest refault.
>  		 */
>  		if (level > PT_PAGE_TABLE_LEVEL &&
>  		    has_wrprotected_page(vcpu->kvm, gfn, level))
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index ec481e9..32d77ff 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -491,6 +491,36 @@ out_gpte_changed:
>  	return 0;
>  }
> 
> + /*
> + * To see whether the mapped gfn can write its page table in the current
> + * mapping.
> + *
> + * It is the helper function of FNAME(page_fault). When guest uses large page
> + * size to map the writable gfn which is used as current page table, we should
> + * force kvm to use small page size to map it because new shadow page will be
> + * created when kvm establishes shadow page table that stop kvm using large
> + * page size. Do it early can avoid unnecessary #PF and emulation.
> + *
> + * Note: the PDPT page table is not checked for PAE-32 bit guest. It is ok
> + * since the PDPT is always shadowed, that means, we can not use large page
> + * size to map the gfn which is used as PDPT.
> + */
> +static bool
> +FNAME(mapped_gfn_can_write_current_pagetable)(struct guest_walker *walker)
> +{
> +	int level;
> +	gfn_t mask = ~(KVM_PAGES_PER_HPAGE(walker->level) - 1);
> +
> +	if (!(walker->pte_access & ACC_WRITE_MASK))
> +		return false;
> +
> +	for (level = walker->level; level <= walker->max_level; level++)
> +		if (!((walker->gfn ^ walker->table_gfn[level - 1]) & mask))
> +			return true;

XOR won't work. Just check with sums and integer comparison, ie.
walker->gfn + KVM_PAGES_PER_HPAGE(walker->level).

Moreover, its confusing to have it checked at this level. What about
doing at reexecute_instruction?

