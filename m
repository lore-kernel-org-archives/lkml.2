Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1FTR1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:27:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab1FTR0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:26:54 -0400
Date: Mon, 20 Jun 2011 13:37:04 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 10/15] KVM: MMU: lockless walking shadow page table
Message-ID: <20110620163704.GD17130@amt.cnet>
References: <4DEE205E.8000601@cn.fujitsu.com>
 <4DEE21E2.8000301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEE21E2.8000301@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 09:04:34PM +0800, Xiao Guangrong wrote:
> Using rcu to protect shadow pages table to be freed, so we can safely walk it,
> it should run fast and is needed by mmio page fault
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    4 ++
>  arch/x86/kvm/mmu.c              |   79 ++++++++++++++++++++++++++++++---------
>  arch/x86/kvm/mmu.h              |    4 +-
>  arch/x86/kvm/vmx.c              |    2 +-
>  4 files changed, 69 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 326af42..260582b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -232,6 +232,8 @@ struct kvm_mmu_page {
>  	unsigned int unsync_children;
>  	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
>  	DECLARE_BITMAP(unsync_child_bitmap, 512);
> +
> +	struct rcu_head rcu;
>  };
>  
>  struct kvm_pv_mmu_op_buffer {
> @@ -478,6 +480,8 @@ struct kvm_arch {
>  	u64 hv_guest_os_id;
>  	u64 hv_hypercall;
>  
> +	atomic_t reader_counter;
> +
>  	#ifdef CONFIG_KVM_MMU_AUDIT
>  	int audit_point;
>  	#endif
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 9f3a746..52d4682 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1675,6 +1675,30 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>  	return ret;
>  }
>  
> +static void free_mmu_pages_unlock_parts(struct list_head *invalid_list)
> +{
> +	struct kvm_mmu_page *sp;
> +
> +	list_for_each_entry(sp, invalid_list, link)
> +		kvm_mmu_free_lock_parts(sp);
> +}
> +
> +static void free_invalid_pages_rcu(struct rcu_head *head)
> +{
> +	struct kvm_mmu_page *next, *sp;
> +
> +	sp = container_of(head, struct kvm_mmu_page, rcu);
> +	while (sp) {
> +		if (!list_empty(&sp->link))
> +			next = list_first_entry(&sp->link,
> +				      struct kvm_mmu_page, link);
> +		else
> +			next = NULL;
> +		kvm_mmu_free_unlock_parts(sp);
> +		sp = next;
> +	}
> +}
> +
>  static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>  				    struct list_head *invalid_list)
>  {
> @@ -1685,6 +1709,14 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>  
>  	kvm_flush_remote_tlbs(kvm);
>  
> +	if (atomic_read(&kvm->arch.reader_counter)) {
> +		free_mmu_pages_unlock_parts(invalid_list);
> +		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
> +		list_del_init(invalid_list);
> +		call_rcu(&sp->rcu, free_invalid_pages_rcu);
> +		return;
> +	}

This is probably wrong, the caller wants the page to be zapped by the 
time the function returns, not scheduled sometime in the future.

> +
>  	do {
>  		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
>  		WARN_ON(!sp->role.invalid || sp->root_count);
> @@ -2601,6 +2633,35 @@ static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
>  	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, access);
>  }
>  
> +int kvm_mmu_walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
> +				      u64 sptes[4])
> +{
> +	struct kvm_shadow_walk_iterator iterator;
> +	int nr_sptes = 0;
> +
> +	rcu_read_lock();
> +
> +	atomic_inc(&vcpu->kvm->arch.reader_counter);
> +	/* Increase the counter before walking shadow page table */
> +	smp_mb__after_atomic_inc();
> +
> +	for_each_shadow_entry(vcpu, addr, iterator) {
> +		sptes[iterator.level-1] = *iterator.sptep;
> +		nr_sptes++;
> +		if (!is_shadow_present_pte(*iterator.sptep))
> +			break;
> +	}

Why is lockless access needed for the MMIO optimization? Note the spte 
contents are copied to the array here are used for debugging purposes
only, their contents are potentially stale.

