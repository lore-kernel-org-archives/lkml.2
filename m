Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934851Ab0KQPwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:52:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab0KQPwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:52:35 -0500
Date: Wed, 17 Nov 2010 13:29:43 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] KVM: MMU: fix forgot flush vcpu tlbs
Message-ID: <20101117152943.GA18959@amt.cnet>
References: <4CE355A0.6020907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE355A0.6020907@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 12:10:08PM +0800, Xiao Guangrong wrote:
> Some paths forgot to flush vcpu tlbs after remove rmap, this
> patch fix it.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c         |   14 +++++++++++---
>  arch/x86/kvm/paging_tmpl.h |    1 +
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index bdb9fa9..e008ae7 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -736,10 +736,16 @@ static int set_spte_track_bits(u64 *sptep, u64 new_spte)
>  	return 1;
>  }
>  
> -static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
> +static bool drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
>  {
> -	if (set_spte_track_bits(sptep, new_spte))
> +	bool ret = false;
> +
> +	if (set_spte_track_bits(sptep, new_spte)) {
>  		rmap_remove(kvm, sptep);
> +		ret = true;
> +	}
> +
> +	return ret;
>  }
>  
>  static u64 *rmap_next(struct kvm *kvm, unsigned long *rmapp, u64 *spte)
> @@ -1997,7 +2003,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		if (level > PT_PAGE_TABLE_LEVEL &&
>  		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
>  			ret = 1;
> -			drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
> +			if (drop_spte(vcpu->kvm, sptep,
> +				      shadow_trap_nonpresent_pte))
> +				kvm_flush_remote_tlbs(vcpu->kvm);
>  			goto done;

The spte should not be present before (this condition can happen if the
has_wrprotected_page check from mapping_level races, which is possible
since it runs without mmu_lock protection).

> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index ba00eef..58b4d9a 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -781,6 +781,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  			else
>  				nonpresent = shadow_notrap_nonpresent_pte;
>  			drop_spte(vcpu->kvm, &sp->spt[i], nonpresent);
> +			kvm_flush_remote_tlbs(vcpu->kvm);
>  			continue;
>  		}

This is not needed. Guest is responsible for flushing on
present->nonpresent change.
