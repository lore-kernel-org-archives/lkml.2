Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab0KSQMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:12:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab0KSQMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:12:18 -0500
Date: Fri, 19 Nov 2010 14:11:18 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] KVM: MMU: delay flush all tlbs on sync_page path
Message-ID: <20101119161118.GB20279@amt.cnet>
References: <4CE63CF4.80502@cn.fujitsu.com>
 <4CE63DE2.9050408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE63DE2.9050408@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 05:05:38PM +0800, Xiao Guangrong wrote:
> Quote from Avi:
> | I don't think we need to flush immediately; set a "tlb dirty" bit somewhere
> | that is cleareded when we flush the tlb.  kvm_mmu_notifier_invalidate_page()
> | can consult the bit and force a flush if set. 
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |    4 ++--
>  include/linux/kvm_host.h   |    7 +++++++
>  virt/kvm/kvm_main.c        |    8 +++++++-
>  3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index dfb906f..d5c302a 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -781,14 +781,14 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		gfn = gpte_to_gfn(gpte);
>  
>  		if (FNAME(map_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
> -			kvm_flush_remote_tlbs(vcpu->kvm);
> +			kvm_mark_tlbs_dirty(vcpu->kvm);
>  			continue;
>  		}
>  
>  		if (gfn != sp->gfns[i]) {
>  			drop_spte(vcpu->kvm, &sp->spt[i],
>  				      shadow_trap_nonpresent_pte);
> -			kvm_flush_remote_tlbs(vcpu->kvm);
> +			kvm_mark_tlbs_dirty(vcpu->kvm);
>  			continue;
>  		}
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4bd663d..82d449b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -249,6 +249,7 @@ struct kvm {
>  	struct mmu_notifier mmu_notifier;
>  	unsigned long mmu_notifier_seq;
>  	long mmu_notifier_count;
> +	atomic_t tlbs_dirty;
>  #endif
>  };
>  
> @@ -377,6 +378,12 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu);
>  void kvm_resched(struct kvm_vcpu *vcpu);
>  void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
>  void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> +
> +static inline void kvm_mark_tlbs_dirty(struct kvm *kvm)
> +{
> +	atomic_inc(&kvm->tlbs_dirty);
> +}
> +
>  void kvm_flush_remote_tlbs(struct kvm *kvm);
>  void kvm_reload_remote_mmus(struct kvm *kvm);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fb93ff9..2962569 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -168,8 +168,12 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>  
>  void kvm_flush_remote_tlbs(struct kvm *kvm)
>  {
> +	int dirty_count = atomic_read(&kvm->tlbs_dirty);
> +
> +	smp_mb();
>  	if (make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
>  		++kvm->stat.remote_tlb_flush;
> +	atomic_sub(dirty_count, &kvm->tlbs_dirty);
>  }

This is racy because kvm_flush_remote_tlbs might be called without
mmu_lock protection. You could decrease the counter on
invalidate_page/invalidate_range_start only, these are not fast paths
anyway.

>  
>  void kvm_reload_remote_mmus(struct kvm *kvm)
> @@ -249,7 +253,8 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
>  	idx = srcu_read_lock(&kvm->srcu);
>  	spin_lock(&kvm->mmu_lock);
>  	kvm->mmu_notifier_seq++;
> -	need_tlb_flush = kvm_unmap_hva(kvm, address);
> +	need_tlb_flush = kvm_unmap_hva(kvm, address) |
> +			      atomic_read(&kvm->tlbs_dirty);
>  	spin_unlock(&kvm->mmu_lock);
>  	srcu_read_unlock(&kvm->srcu, idx);
>  
> @@ -293,6 +298,7 @@ static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>  	kvm->mmu_notifier_count++;
>  	for (; start < end; start += PAGE_SIZE)
>  		need_tlb_flush |= kvm_unmap_hva(kvm, start);
> +	need_tlb_flush |= atomic_read(&kvm->tlbs_dirty);
>  	spin_unlock(&kvm->mmu_lock);
>  	srcu_read_unlock(&kvm->srcu, idx);
>  

