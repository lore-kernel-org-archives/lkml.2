Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2IWJNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 05:13:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab2IWJNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 05:13:38 -0400
Date: Sun, 23 Sep 2012 11:13:35 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] KVM: MMU: fix release noslot pfn
Message-ID: <20120923091335.GA20907@redhat.com>
References: <505C0FA8.5070007@linux.vnet.ibm.com>
 <505C0FCF.2070308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505C0FCF.2070308@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 02:57:19PM +0800, Xiao Guangrong wrote:
> We can not directly call kvm_release_pfn_clean to release the pfn
> since we can meet noslot pfn which is used to cache mmio info into
> spte
> 
Wouldn't it be better to move the check into kvm_release_pfn_clean()?

> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c         |    6 ++++--
>  arch/x86/kvm/paging_tmpl.h |    6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index aa0b469..0f56169 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2877,7 +2877,8 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
> 
>  out_unlock:
>  	spin_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(pfn);
> +	if (likely(!is_noslot_pfn(pfn)))
> +		kvm_release_pfn_clean(pfn);
>  	return 0;
>  }
> 
> @@ -3345,7 +3346,8 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
> 
>  out_unlock:
>  	spin_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(pfn);
> +	if (likely(!is_noslot_pfn(pfn)))
> +		kvm_release_pfn_clean(pfn);
>  	return 0;
>  }
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index bf8c42b..9ce6bc0 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -544,7 +544,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>  out_gpte_changed:
>  	if (sp)
>  		kvm_mmu_put_page(sp, it.sptep);
> -	kvm_release_pfn_clean(pfn);
> +	if (likely(!is_noslot_pfn(pfn)))
> +		kvm_release_pfn_clean(pfn);
>  	return NULL;
>  }
> 
> @@ -645,7 +646,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
> 
>  out_unlock:
>  	spin_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(pfn);
> +	if (likely(!is_noslot_pfn(pfn)))
> +		kvm_release_pfn_clean(pfn);
>  	return 0;
>  }
> 
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
