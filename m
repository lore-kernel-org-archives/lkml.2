Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2LFHMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:12:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab2LFHMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:12:43 -0500
Date: Thu, 6 Dec 2012 09:12:39 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: optimize for set_spte
Message-ID: <20121206071239.GZ19514@redhat.com>
References: <50BD32F7.5080601@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BD32F7.5080601@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 07:17:11AM +0800, Xiao Guangrong wrote:
> There are two cases we need to adjust page size in set_spte:
> 1): the one is other vcpu creates new sp in the window between mapping_level()
>     and acquiring mmu-lock.
> 2): the another case is the new sp is created by itself (page-fault path) when
>     guest uses the target gfn as its page table.
> 
> In current code, set_spte drop the spte and emulate the access for these case,
> it works not good:
> - for the case 1, it may destroy the mapping established by other vcpu, and
>   do expensive instruction emulation.
> - for the case 2, it may emulate the access even if the guest is accessing
>   the page which not used as page table. There is a example, 0~2M is used as
>   huge page in guest, in this huge page, only page 3 used as page table, then
>   guest read/writes on other pages can cause instruction emulation.
> 
> Both of these cases can be fixed by allowing guest to retry the access, it
> will refault, then we can establish the mapping by using small page
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Applied to queue. Thanks.

> ---
>  arch/x86/kvm/mmu.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index b875a9e..01d7c2a 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2382,12 +2382,20 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	    || (!vcpu->arch.mmu.direct_map && write_fault
>  		&& !is_write_protection(vcpu) && !user_fault)) {
> 
> +		/*
> +		 * There are two cases:
> +		 * - the one is other vcpu creates new sp in the window
> +		 *   between mapping_level() and acquiring mmu-lock.
> +		 * - the another case is the new sp is created by itself
> +		 *   (page-fault path) when guest uses the target gfn as
> +		 *   its page table.
> +		 * Both of these cases can be fixed by allowing guest to
> +		 * retry the access, it will refault, then we can establish
> +		 * the mapping by using small page.
> +		 */
>  		if (level > PT_PAGE_TABLE_LEVEL &&
> -		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
> -			ret = 1;
> -			drop_spte(vcpu->kvm, sptep);
> +		    has_wrprotected_page(vcpu->kvm, gfn, level))
>  			goto done;
> -		}
> 
>  		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
> 
> -- 
> 1.7.7.6

--
			Gleb.
