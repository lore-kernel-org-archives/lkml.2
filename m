Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2FMXXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:23:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826Ab2FMXXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:23:52 -0400
Date: Wed, 13 Jun 2012 18:39:05 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 5/9] KVM: MMU: introduce SPTE_MMU_WRITEABLE bit
Message-ID: <20120613213905.GD19290@amt.cnet>
References: <4FC470C7.5040700@linux.vnet.ibm.com>
 <4FC4716A.8030304@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC4716A.8030304@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 02:49:14PM +0800, Xiao Guangrong wrote:
> This bit indicates whether the spte can be writable on MMU, that means
> the corresponding gpte is writable and the corresponding gfn is not
> protected by shadow page protection
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   41 +++++++++++++++++++++++++++--------------
>  1 files changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 4810992..150c5ad 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -145,7 +145,8 @@ module_param(dbg, bool, 0644);
>  #define CREATE_TRACE_POINTS
>  #include "mmutrace.h"
> 
> -#define SPTE_HOST_WRITEABLE (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
> +#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
> +#define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
> 
>  #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
> 
> @@ -1065,32 +1066,43 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
>  		rmap_remove(kvm, sptep);
>  }
> 
> +static bool spte_can_be_writable(u64 spte)
> +{
> +	return !(~spte & (SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE));
> +}
> +
>  /* Return true if the spte is dropped. */
> -static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush)
> +static bool
> +spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
>  {
>  	u64 spte = *sptep;
> 
> -	if (!is_writable_pte(spte))
> +	if (!is_writable_pte(spte) &&
> +	      !(pt_protect && spte_can_be_writable(spte)))
>  		return false;
> 
>  	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
> 
> -	*flush |= true;
>  	if (is_large_pte(spte)) {
>  		WARN_ON(page_header(__pa(sptep))->role.level ==
>  		       PT_PAGE_TABLE_LEVEL);
> +
> +		*flush |= true;
>  		drop_spte(kvm, sptep);
>  		--kvm->stat.lpages;
>  		return true;
>  	}
> 
> +	if (pt_protect)
> +		spte &= ~SPTE_MMU_WRITEABLE;
>  	spte = spte & ~PT_WRITABLE_MASK;
> -	mmu_spte_update(sptep, spte);
> +
> +	*flush = mmu_spte_update(sptep, spte);

This clears previous flush value when looping over multiple sptes in 
a single rmapp.

