Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab0KPU3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:29:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab0KPU3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:29:02 -0500
Date: Tue, 16 Nov 2010 18:24:15 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] KVM: MMU: don't drop spte if overwrite it from W to
 RO
Message-ID: <20101116202414.GA24156@amt.cnet>
References: <4CDD173E.8010706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDD173E.8010706@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 06:30:22PM +0800, Xiao Guangrong wrote:
> We just need flush tlb if overwrite a writable spte with a read-only one
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |   19 +++++++++----------
>  1 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 4b6d54c..1a93ab4 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2044,6 +2044,15 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	if (pte_access & ACC_WRITE_MASK)
>  		mark_page_dirty(vcpu->kvm, gfn);
>  
> +	/*
> +	 * If we overwrite a writable spte with a read-only one,
> +	 * flush remote TLBs. Otherwise rmap_write_protect will
> +	 * find a read-only spte, even though the writable spte
> +	 * might be cached on a CPU's TLB.
> +	 */
> +	else if (is_writable_pte(*sptep))
> +		ret = 1;
> +

The return value of set_spte indicates whether the gfn being mapped to
was write protected, not if a TLB flush is necessary.

>  set_pte:
>  	update_spte(sptep, spte);
>  done:
> @@ -2084,16 +2093,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  				 spte_to_pfn(*sptep), pfn);
>  			drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
>  			kvm_flush_remote_tlbs(vcpu->kvm);
> -		/*
> -		 * If we overwrite a writable spte with a read-only one,
> -		 * drop it and flush remote TLBs. Otherwise rmap_write_protect
> -		 * will find a read-only spte, even though the writable spte
> -		 * might be cached on a CPU's TLB.
> -		 */
> -		} else if (is_writable_pte(*sptep) &&
> -			  (!(pte_access & ACC_WRITE_MASK) || !dirty)) {
> -			drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
> -			kvm_flush_remote_tlbs(vcpu->kvm);
>  		} else
>  			was_rmapped = 1;

And here, flush will only happen if overwrite is RW->RO.

