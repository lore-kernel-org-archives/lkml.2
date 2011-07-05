Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1GEVIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 17:08:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab1GEVIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 17:08:50 -0400
Date: Tue, 5 Jul 2011 16:04:57 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 04/19] KVM: MMU: cache mmio info on page fault path
Message-ID: <20110705190457.GA24417@amt.cnet>
References: <4E0C3178.2080603@cn.fujitsu.com>
 <4E0C31EA.5070403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0C31EA.5070403@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 04:20:58PM +0800, Xiao Guangrong wrote:
> If the page fault is caused by mmio, we can cache the mmio info, later, we do
> not need to walk guest page table and quickly know it is a mmio fault while we
> emulate the mmio instruction
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    5 +++++
>  arch/x86/kvm/mmu.c              |   21 +++++++--------------
>  arch/x86/kvm/mmu.h              |   23 +++++++++++++++++++++++
>  arch/x86/kvm/paging_tmpl.h      |   21 ++++++++++++++-------
>  arch/x86/kvm/x86.c              |   11 +++++++++++
>  arch/x86/kvm/x86.h              |   36 ++++++++++++++++++++++++++++++++++++
>  6 files changed, 96 insertions(+), 21 deletions(-)
> 

> index 7086ca8..05310b1 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -76,4 +76,27 @@ static inline int is_present_gpte(unsigned long pte)
>  	return pte & PT_PRESENT_MASK;
>  }
>  
> +static inline int is_writable_pte(unsigned long pte)
> +{
> +	return pte & PT_WRITABLE_MASK;
> +}
> +
> +static inline bool is_write_protection(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_read_cr0_bits(vcpu, X86_CR0_WP);
> +}
> +
> +static inline bool check_write_user_access(struct kvm_vcpu *vcpu,
> +					   bool write_fault, bool user_fault,
> +					   unsigned long pte)
> +{
> +	if (unlikely(write_fault && !is_writable_pte(pte)
> +	      && (user_fault || is_write_protection(vcpu))))
> +		return false;
> +
> +	if (unlikely(user_fault && !(pte & PT_USER_MASK)))
> +		return false;
> +
> +	return true;
> +}
>  #endif
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 1caeb4d..13978dc 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -201,11 +201,8 @@ walk:
>  			break;
>  		}
>  
> -		if (unlikely(write_fault && !is_writable_pte(pte)
> -			     && (user_fault || is_write_protection(vcpu))))
> -			eperm = true;
> -
> -		if (unlikely(user_fault && !(pte & PT_USER_MASK)))
> +		if (!check_write_user_access(vcpu, write_fault, user_fault,
> +					  pte))
>  			eperm = true;
>  
>  #if PTTYPE == 64
> @@ -631,8 +628,16 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>  		return 0;
>  
>  	/* mmio */
> -	if (is_error_pfn(pfn))
> -		return kvm_handle_bad_page(vcpu->kvm, walker.gfn, pfn);
> +	if (is_error_pfn(pfn)) {
> +		unsigned access = walker.pte_access;
> +		bool dirty = is_dirty_gpte(walker.ptes[walker.level - 1]);
> +
> +		if (dirty)
> +			access &= ~ACC_WRITE_MASK;
> +
> +		return kvm_handle_bad_page(vcpu, mmu_is_nested(vcpu) ? 0 :
> +					   addr, access, walker.gfn, pfn);
> +	}

Don't get this... if guest pte is dirty you cache without allowing
write access? Why?

