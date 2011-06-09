Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab1FIUJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:09:49 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52532 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab1FIUJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:09:48 -0400
Date: Thu, 9 Jun 2011 13:09:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 10/15] KVM: MMU: lockless walking shadow page table
Message-ID: <20110609200945.GK2285@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DEE205E.8000601@cn.fujitsu.com>
 <4DEE21E2.8000301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEE21E2.8000301@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 09:04:34PM +0800, Xiao Guangrong wrote:
> Using rcu to protect shadow pages table to be freed, so we can safely walk it,
> it should run fast and is needed by mmio page fault

A couple of question below.

							Thanx, Paul

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

This is the slowpath to be executed if there are currently readers
in kvm->arch.reader_counter(), correct?

> +		free_mmu_pages_unlock_parts(invalid_list);
> +		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
> +		list_del_init(invalid_list);
> +		call_rcu(&sp->rcu, free_invalid_pages_rcu);
> +		return;
> +	}

OK, so it also looks like kvm->arch.reader_counter could transition from
zero to non-zero at this point due to a concurrent call from a reader in
the kvm_mmu_walk_shadow_page_lockless() function.  Does the following code
avoid messing up the reader?  If so, why bother with the slowpath above?

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
> +
> +	/* Decrease the counter after walking shadow page table finished */
> +	smp_mb__before_atomic_dec();
> +	atomic_dec(&vcpu->kvm->arch.reader_counter);
> +
> +	rcu_read_unlock();
> +
> +	return nr_sptes;
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_walk_shadow_page_lockless);
> +
>  static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
>  				u32 error_code, bool prefault)
>  {
> @@ -3684,24 +3745,6 @@ out:
>  	return r;
>  }
> 
> -int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
> -{
> -	struct kvm_shadow_walk_iterator iterator;
> -	int nr_sptes = 0;
> -
> -	spin_lock(&vcpu->kvm->mmu_lock);
> -	for_each_shadow_entry(vcpu, addr, iterator) {
> -		sptes[iterator.level-1] = *iterator.sptep;
> -		nr_sptes++;
> -		if (!is_shadow_present_pte(*iterator.sptep))
> -			break;
> -	}
> -	spin_unlock(&vcpu->kvm->mmu_lock);
> -
> -	return nr_sptes;
> -}
> -EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);
> -
>  void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
>  {
>  	ASSERT(vcpu);
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 05310b1..e7725c4 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -48,7 +48,9 @@
>  #define PFERR_RSVD_MASK (1U << 3)
>  #define PFERR_FETCH_MASK (1U << 4)
> 
> -int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
> +int kvm_mmu_walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
> +				      u64 sptes[4]);
> +
>  int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
> 
>  static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index b54c186..20dbf7f 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -4681,7 +4681,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>  	printk(KERN_ERR "EPT: Misconfiguration.\n");
>  	printk(KERN_ERR "EPT: GPA: 0x%llx\n", gpa);
> 
> -	nr_sptes = kvm_mmu_get_spte_hierarchy(vcpu, gpa, sptes);
> +	nr_sptes = kvm_mmu_walk_shadow_page_lockless(vcpu, gpa, sptes);
> 
>  	for (i = PT64_ROOT_LEVEL; i > PT64_ROOT_LEVEL - nr_sptes; --i)
>  		ept_misconfig_inspect_spte(vcpu, sptes[i-1], i);
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
