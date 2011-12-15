Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1LOFeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:34:07 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:59897 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab1LOFd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:33:57 -0500
Message-ID: <4EE9869F.4070702@linux.vnet.ibm.com>
Date: Thu, 15 Dec 2011 13:33:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Liu Ping Fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, gleb@redhat.com, mtosatti@redhat.com,
        jan.kiszka@web.de
Subject: Re: [PATCH v4] kvm: make vcpu life cycle separated from kvm instance
References: <CAFgQCTtkaTpjDyyzEaNwNv_+FdjTQ+ZbYAAbAUKZ6NmWXJfheA@mail.gmail.com> <1323923328-917-1-git-send-email-kernelfans@gmail.com>
In-Reply-To: <1323923328-917-1-git-send-email-kernelfans@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121419-9264-0000-0000-00000067AC61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 12:28 PM, Liu Ping Fan wrote:


> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1833,11 +1833,12 @@ static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
> 
>  static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
>  {
> -	int i;
>  	struct kvm_vcpu *vcpu;
> 
> -	kvm_for_each_vcpu(i, vcpu, kvm)
> +	rcu_read_lock();
> +	kvm_for_each_vcpu(vcpu, kvm)
>  		vcpu->arch.last_pte_updated = NULL;
> +	rcu_read_unlock();
>  }
> 


I am sure that you should rebase it on the current kvm tree.

>  static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c38efd7..acaa154 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1830,11 +1830,13 @@ static int get_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
> 
>  	switch (msr) {
>  	case HV_X64_MSR_VP_INDEX: {
> -		int r;
> +		int r = 0;
>  		struct kvm_vcpu *v;
> -		kvm_for_each_vcpu(r, v, vcpu->kvm)
> +		kvm_for_each_vcpu(v, vcpu->kvm) {
>  			if (v == vcpu)
>  				data = r;
> +			r++;
> +		}


Do not need rcu_lock?

> +struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_put(struct kvm_vcpu *vcpu);
> +void kvm_arch_vcpu_zap(struct work_struct *work);
> +
> +#define kvm_for_each_vcpu(vcpu, kvm) \
> +	list_for_each_entry_rcu(vcpu, &kvm->vcpus, list)
> 
> -#define kvm_for_each_vcpu(idx, vcpup, kvm) \
> -	for (idx = 0; \
> -	     idx < atomic_read(&kvm->online_vcpus) && \
> -	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
> -	     idx++)
> +#define kvm_for_each_vcpu_continue(vcpu, kvm) \
> +	list_for_each_entry_continue_rcu(vcpu, &kvm->vcpus, list)
> 


Where is it used?

> +struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu == NULL)
> +		return NULL;
> +	if (atomic_add_unless(&vcpu->refcount, 1, 0))


Why do not use atomic_inc()?
Also, i think a memory barrier is needed after increasing refcount.

> -	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
> +	/*Protected by kvm->lock*/
> +	list_add_rcu(&vcpu->list, &kvm->vcpus);
> +
>  	smp_wmb();


This barrier can also be removed.

>  	atomic_inc(&kvm->online_vcpus);
> 
>  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
>  	if (kvm->bsp_vcpu_id == id)
> -		kvm->bsp_vcpu = vcpu;
> +		kvm->bsp_vcpu = kvm_vcpu_get(vcpu);
>  #endif
>  	mutex_unlock(&kvm->lock);
>  	return r;
> @@ -2593,13 +2667,15 @@ static int vcpu_stat_get(void *_offset, u64 *val)
>  	unsigned offset = (long)_offset;
>  	struct kvm *kvm;
>  	struct kvm_vcpu *vcpu;
> -	int i;
> 
>  	*val = 0;
>  	raw_spin_lock(&kvm_lock);
> -	list_for_each_entry(kvm, &vm_list, vm_list)
> -		kvm_for_each_vcpu(i, vcpu, kvm)
> +	list_for_each_entry(kvm, &vm_list, vm_list) {
> +		rcu_read_lock();
> +		kvm_for_each_vcpu(vcpu, kvm)
>  			*val += *(u32 *)((void *)vcpu + offset);
> +		rcu_read_unlock();
> +	}
> 
>  	raw_spin_unlock(&kvm_lock);
>  	return 0;
> @@ -2765,7 +2841,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	kvm_preempt_ops.sched_out = kvm_sched_out;
> 
>  	kvm_init_debug();
> -


You don not change anything, please do not touch this line.

