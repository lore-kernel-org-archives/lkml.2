Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0K3N3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 08:29:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab0K3N3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 08:29:20 -0500
Date: Tue, 30 Nov 2010 15:29:15 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: MMU: fix accessed bit set on prefault path
Message-ID: <20101130132915.GG2187@redhat.com>
References: <4CF4C535.8080405@cn.fujitsu.com>
 <4CF4C587.7080000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF4C587.7080000@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 05:36:07PM +0800, Xiao Guangrong wrote:
> Retry #PF is the speculative path, so don't set the accessed bit,
> especially, stop prefault if shadow_accessed_mask = 0
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    1 +
>  arch/x86/kvm/mmu.c              |   12 +++++++-----
>  arch/x86/kvm/x86.c              |    3 +++
>  3 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a4c5352..209da89 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -632,6 +632,7 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
>  u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
>  
>  extern bool tdp_enabled;
> +extern u64 __read_mostly shadow_accessed_mask;
>  
>  enum emulation_result {
>  	EMULATE_DONE,       /* no further processing */
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 5b71415..f34987d 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -199,8 +199,8 @@ static u64 __read_mostly shadow_notrap_nonpresent_pte;
>  static u64 __read_mostly shadow_nx_mask;
>  static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
>  static u64 __read_mostly shadow_user_mask;
> -static u64 __read_mostly shadow_accessed_mask;
>  static u64 __read_mostly shadow_dirty_mask;
> +u64 __read_mostly shadow_accessed_mask;
>  
>  static inline u64 rsvd_bits(int s, int e)
>  {
> @@ -2214,7 +2214,8 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
>  }
>  
>  static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
> -			int map_writable, int level, gfn_t gfn, pfn_t pfn)
> +			int map_writable, int level, gfn_t gfn, pfn_t pfn,
> +			bool prefault)
>  {
>  	struct kvm_shadow_walk_iterator iterator;
>  	struct kvm_mmu_page *sp;
> @@ -2229,7 +2230,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  				pte_access &= ~ACC_WRITE_MASK;
>  			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, pte_access,
>  				     0, write, 1, &pt_write,
> -				     level, gfn, pfn, false, map_writable);
> +				     level, gfn, pfn, prefault, map_writable);
>  			direct_pte_prefetch(vcpu, iterator.sptep);
>  			++vcpu->stat.pf_fixed;
>  			break;
> @@ -2321,7 +2322,8 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
>  	if (mmu_notifier_retry(vcpu, mmu_seq))
>  		goto out_unlock;
>  	kvm_mmu_free_some_pages(vcpu);
> -	r = __direct_map(vcpu, v, write, map_writable, level, gfn, pfn);
> +	r = __direct_map(vcpu, v, write, map_writable, level, gfn, pfn,
> +			 prefault);
>  	spin_unlock(&vcpu->kvm->mmu_lock);
>  
>  
> @@ -2683,7 +2685,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
>  		goto out_unlock;
>  	kvm_mmu_free_some_pages(vcpu);
>  	r = __direct_map(vcpu, gpa, write, map_writable,
> -			 level, gfn, pfn);
> +			 level, gfn, pfn, prefault);
>  	spin_unlock(&vcpu->kvm->mmu_lock);
>  
>  	return r;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 410d2d1..83ed55f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6178,6 +6178,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  {
>  	int r;
>  
> +	if (!shadow_accessed_mask)
> +		return;
> +
I don't get this. As far as I can see VMX inits shadow_accessed_mask to
be zero if ept is enabled. This line here means that we never prefault with ept
enabled. It is opposite from what it should be.

>  	if (!vcpu->arch.mmu.direct_map || !work->arch.direct_map ||
>  	      is_error_page(work->page))
>  		return;
> -- 
> 1.7.0.4

--
			Gleb.
