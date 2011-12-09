Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab1LIOXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:23:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab1LIOXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:23:16 -0500
Date: Fri, 9 Dec 2011 16:23:03 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Liu Ping Fan <kernelfans@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, jan.kiszka@web.de
Subject: Re: [PATCH V2] kvm: make vcpu life cycle separated from kvm instance
Message-ID: <20111209142303.GC31323@redhat.com>
References: <1322807192-14147-1-git-send-email-kernelfans@gmail.com>
 <1323408198-9145-1-git-send-email-kernelfans@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323408198-9145-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 01:23:18PM +0800, Liu Ping Fan wrote:
> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> 
> Currently, vcpu can be destructed only when kvm instance destroyed.
> Change this to vcpu's destruction taken when its refcnt is zero,
> and then vcpu MUST and CAN be destroyed before kvm's destroy.
> 
Now refcount is completely unused. It's just set to 1 during vcpu
creation and reset to 0 during destruction. Just drop it.

> Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/i8254.c     |   10 ++++--
>  arch/x86/kvm/i8259.c     |   12 ++++--
>  arch/x86/kvm/mmu.c       |    7 ++--
>  arch/x86/kvm/x86.c       |   54 ++++++++++++++++--------------
>  include/linux/kvm_host.h |   77 +++++++++++++++++++++++++++++++++++++++---
>  virt/kvm/irq_comm.c      |    7 +++-
>  virt/kvm/kvm_main.c      |   82 ++++++++++++++++++++++++++++++++++++++++------
>  7 files changed, 196 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 76e3f1c..ac79598 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -289,7 +289,7 @@ static void pit_do_work(struct work_struct *work)
>  	struct kvm_pit *pit = container_of(work, struct kvm_pit, expired);
>  	struct kvm *kvm = pit->kvm;
>  	struct kvm_vcpu *vcpu;
> -	int i;
> +	struct kvm_iter it;
>  	struct kvm_kpit_state *ps = &pit->pit_state;
>  	int inject = 0;
>  
> @@ -315,9 +315,13 @@ static void pit_do_work(struct work_struct *work)
>  		 * LVT0 to NMI delivery. Other PIC interrupts are just sent to
>  		 * VCPU0, and only if its LVT0 is in EXTINT mode.
>  		 */
> -		if (kvm->arch.vapics_in_nmi_mode > 0)
> -			kvm_for_each_vcpu(i, vcpu, kvm)
> +		if (kvm->arch.vapics_in_nmi_mode > 0) {
> +			rcu_read_lock();
> +			kvm_for_each_vcpu(it, vcpu, kvm) {
>  				kvm_apic_nmi_wd_deliver(vcpu);
> +			}
> +			rcu_read_unlock();
> +		}
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index cac4746..2186b30 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -50,25 +50,29 @@ static void pic_unlock(struct kvm_pic *s)
>  {
>  	bool wakeup = s->wakeup_needed;
>  	struct kvm_vcpu *vcpu, *found = NULL;
> -	int i;
> +	struct kvm *kvm = s->kvm;
> +	struct kvm_iter it;
>  
>  	s->wakeup_needed = false;
>  
>  	spin_unlock(&s->lock);
>  
>  	if (wakeup) {
> -		kvm_for_each_vcpu(i, vcpu, s->kvm) {
> +		rcu_read_lock();
> +		kvm_for_each_vcpu(it, vcpu, kvm)
>  			if (kvm_apic_accept_pic_intr(vcpu)) {
>  				found = vcpu;
>  				break;
>  			}
> -		}
>  
> -		if (!found)
> +		if (!found) {
> +			rcu_read_unlock();
>  			return;
> +		}
>  
>  		kvm_make_request(KVM_REQ_EVENT, found);
>  		kvm_vcpu_kick(found);
> +		rcu_read_unlock();
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index f1b36cf..c16887e 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1833,11 +1833,12 @@ static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
>  
>  static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
>  {
> -	int i;
> +	struct kvm_iter it;
>  	struct kvm_vcpu *vcpu;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm)
> +	rcu_read_lock();
> +	kvm_for_each_vcpu(it, vcpu, kvm)
>  		vcpu->arch.last_pte_updated = NULL;
> +	rcu_read_unlock();
>  }
>  
>  static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c38efd7..a302470 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1831,10 +1831,15 @@ static int get_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  	switch (msr) {
>  	case HV_X64_MSR_VP_INDEX: {
>  		int r;
> +		struct kvm_iter it;
>  		struct kvm_vcpu *v;
> -		kvm_for_each_vcpu(r, v, vcpu->kvm)
> +		struct kvm *kvm =  vcpu->kvm;
> +		rcu_read_lock();
> +		kvm_for_each_vcpu(it, v, kvm) {
>  			if (v == vcpu)
>  				data = r;
> +		}
> +		rcu_read_unlock();
>  		break;
>  	}
>  	case HV_X64_MSR_EOI:
> @@ -4966,7 +4971,8 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
>  	struct cpufreq_freqs *freq = data;
>  	struct kvm *kvm;
>  	struct kvm_vcpu *vcpu;
> -	int i, send_ipi = 0;
> +	int send_ipi = 0;
> +	struct kvm_iter it;
>  
>  	/*
>  	 * We allow guests to temporarily run on slowing clocks,
> @@ -5016,13 +5022,16 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
>  
>  	raw_spin_lock(&kvm_lock);
>  	list_for_each_entry(kvm, &vm_list, vm_list) {
> -		kvm_for_each_vcpu(i, vcpu, kvm) {
> +
> +		rcu_read_lock();
> +		kvm_for_each_vcpu(it, vcpu, kvm) {
>  			if (vcpu->cpu != freq->cpu)
>  				continue;
>  			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>  			if (vcpu->cpu != smp_processor_id())
>  				send_ipi = 1;
>  		}
> +		rcu_read_unlock();
>  	}
>  	raw_spin_unlock(&kvm_lock);
>  
> @@ -6433,13 +6442,17 @@ int kvm_arch_hardware_enable(void *garbage)
>  {
>  	struct kvm *kvm;
>  	struct kvm_vcpu *vcpu;
> -	int i;
> +	struct kvm_iter it;
>  
>  	kvm_shared_msr_cpu_online();
> -	list_for_each_entry(kvm, &vm_list, vm_list)
> -		kvm_for_each_vcpu(i, vcpu, kvm)
> +	list_for_each_entry(kvm, &vm_list, vm_list) {
> +		rcu_read_lock();
> +		kvm_for_each_vcpu(it, vcpu, kvm) {
>  			if (vcpu->cpu == smp_processor_id())
>  				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> +		}
> +		rcu_read_unlock();
> +	}
>  	return kvm_x86_ops->hardware_enable(garbage);
>  }
>  
> @@ -6560,27 +6573,19 @@ static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
>  	vcpu_put(vcpu);
>  }
>  
> -static void kvm_free_vcpus(struct kvm *kvm)
> -{
> -	unsigned int i;
> -	struct kvm_vcpu *vcpu;
>  
> -	/*
> -	 * Unpin any mmu pages first.
> -	 */
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		kvm_clear_async_pf_completion_queue(vcpu);
> -		kvm_unload_vcpu_mmu(vcpu);
> -	}
> -	kvm_for_each_vcpu(i, vcpu, kvm)
> -		kvm_arch_vcpu_free(vcpu);
>  
> -	mutex_lock(&kvm->lock);
> -	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
> -		kvm->vcpus[i] = NULL;
> +void kvm_arch_vcpu_zap(struct work_struct *work)
> +{
> +	struct kvm_vcpu *vcpu = container_of(work, struct kvm_vcpu,
> +			zap_work);
> +	struct kvm *kvm = vcpu->kvm;
>  
> -	atomic_set(&kvm->online_vcpus, 0);
> -	mutex_unlock(&kvm->lock);
> +	printk(KERN_INFO "%s, zap vcpu:0x%x\n", __func__, vcpu->vcpu_id);
> +	kvm_clear_async_pf_completion_queue(vcpu);
> +	kvm_unload_vcpu_mmu(vcpu);
> +	kvm_arch_vcpu_free(vcpu);
> +	kvm_put_kvm(kvm);
>  }
>  
>  void kvm_arch_sync_events(struct kvm *kvm)
> @@ -6594,7 +6599,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	kvm_iommu_unmap_guest(kvm);
>  	kfree(kvm->arch.vpic);
>  	kfree(kvm->arch.vioapic);
> -	kvm_free_vcpus(kvm);
>  	if (kvm->arch.apic_access_page)
>  		put_page(kvm->arch.apic_access_page);
>  	if (kvm->arch.ept_identity_pagetable)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d526231..f16fd09 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -19,6 +19,7 @@
>  #include <linux/slab.h>
>  #include <linux/rcupdate.h>
>  #include <linux/ratelimit.h>
> +#include <linux/atomic.h>
>  #include <asm/signal.h>
>  
>  #include <linux/kvm.h>
> @@ -113,6 +114,9 @@ enum {
>  
>  struct kvm_vcpu {
>  	struct kvm *kvm;
> +	atomic_t refcount;
> +	struct rcu_head head;
> +	struct work_struct zap_work;
>  #ifdef CONFIG_PREEMPT_NOTIFIERS
>  	struct preempt_notifier preempt_notifier;
>  #endif
> @@ -290,17 +294,78 @@ struct kvm {
>  #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
>  #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
>  
> +struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_put(struct kvm_vcpu *vcpu);
> +void kvm_arch_vcpu_zap(struct work_struct *work);
> +
> +/*search vcpu, must be protected by rcu_read_lock*/
>  static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
>  {
> +	struct kvm_vcpu *vcpu;
>  	smp_rmb();
> -	return kvm->vcpus[i];
> +	vcpu = rcu_dereference(kvm->vcpus[i]);
> +	if (vcpu != NULL && atomic_read(&vcpu->refcount) != 0)
> +		return vcpu;
> +
> +	return NULL;
> +}
> +
> +/*Must be protected by RCU*/
> +struct kvm_iter {
> +	struct kvm *kvm;
> +	int idx;
> +	int cnt;
> +};
> +
> +static inline
> +struct kvm_vcpu *kvm_fev_init(struct kvm *kvm, struct kvm_iter *it)
> +{
> +	int idx, cnt;
> +	struct kvm_vcpu *vcpup;
> +	vcpup = NULL;
> +	for (idx = 0, cnt = 0;
> +		cnt < atomic_read(&kvm->online_vcpus) && idx < KVM_MAX_VCPUS;
> +		idx++) {
> +			vcpup = kvm_get_vcpu(kvm, idx);
> +			if (unlikely(vcpup == NULL))
> +				continue;
> +			cnt++;
> +			break;
> +	}
> +
> +	it->kvm = kvm;
> +	it->idx = idx;
> +	it->cnt = cnt;
> +	return vcpup;
> +}
> +
> +static inline
> +struct kvm_vcpu *kvm_fev_next(struct kvm_iter *it)
> +{
> +	int idx, cnt;
> +	struct kvm_vcpu *vcpup;
> +	struct kvm *kvm = it->kvm;
> +
> +	vcpup = NULL;
> +	for (idx = it->idx+1, cnt = it->cnt;
> +		cnt < atomic_read(&kvm->online_vcpus) && idx < KVM_MAX_VCPUS;
> +		idx++) {
> +			vcpup = kvm_get_vcpu(kvm, idx);
> +			if (unlikely(vcpup == NULL))
> +				continue;
> +			 cnt++;
> +			 break;
> +	}
> +
> +	it->idx = idx;
> +	it->cnt = cnt;
> +	return vcpup;
>  }
>  
> -#define kvm_for_each_vcpu(idx, vcpup, kvm) \
> -	for (idx = 0; \
> -	     idx < atomic_read(&kvm->online_vcpus) && \
> -	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
> -	     idx++)
> +#define kvm_for_each_vcpu(it, vcpu, kvm) \
> +	for (vcpu = kvm_fev_init(kvm, &it); \
> +		vcpu; \
> +		vcpu = kvm_fev_next(&it))
>  
>  int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
>  void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> index 9f614b4..87eae96 100644
> --- a/virt/kvm/irq_comm.c
> +++ b/virt/kvm/irq_comm.c
> @@ -81,14 +81,16 @@ inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
>  int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>  		struct kvm_lapic_irq *irq)
>  {
> -	int i, r = -1;
> +	int r = -1;
> +	struct kvm_iter it;
>  	struct kvm_vcpu *vcpu, *lowest = NULL;
>  
>  	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
>  			kvm_is_dm_lowest_prio(irq))
>  		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
>  
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> +	rcu_read_lock();
> +	kvm_for_each_vcpu(it, vcpu, kvm) {
>  		if (!kvm_apic_present(vcpu))
>  			continue;
>  
> @@ -111,6 +113,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>  	if (lowest)
>  		r = kvm_apic_set_irq(lowest, irq);
>  
> +	rcu_read_unlock();
>  	return r;
>  }
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d9cfb78..929cfce 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -171,7 +171,8 @@ static void ack_flush(void *_completed)
>  
>  static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>  {
> -	int i, cpu, me;
> +	int cpu, me;
> +	struct kvm_iter it;
>  	cpumask_var_t cpus;
>  	bool called = true;
>  	struct kvm_vcpu *vcpu;
> @@ -179,7 +180,9 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>  	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
>  
>  	me = get_cpu();
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> +
> +	rcu_read_lock();
> +	kvm_for_each_vcpu(it, vcpu, kvm) {
>  		kvm_make_request(req, vcpu);
>  		cpu = vcpu->cpu;
>  
> @@ -190,12 +193,15 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>  		      kvm_vcpu_exiting_guest_mode(vcpu) != OUTSIDE_GUEST_MODE)
>  			cpumask_set_cpu(cpu, cpus);
>  	}
> +
>  	if (unlikely(cpus == NULL))
>  		smp_call_function_many(cpu_online_mask, ack_flush, NULL, 1);
>  	else if (!cpumask_empty(cpus))
>  		smp_call_function_many(cpus, ack_flush, NULL, 1);
>  	else
>  		called = false;
> +	rcu_read_unlock();
> +
>  	put_cpu();
>  	free_cpumask_var(cpus);
>  	return called;
> @@ -580,6 +586,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	kvm_arch_free_vm(kvm);
>  	hardware_disable_all();
>  	mmdrop(mm);
> +	printk(KERN_INFO "%s finished\n", __func__);
>  }
>  
>  void kvm_get_kvm(struct kvm *kvm)
> @@ -1543,6 +1550,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>  	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
>  	int yielded = 0;
>  	int pass;
> +	struct kvm_iter it;
>  	int i;
>  
>  	/*
> @@ -1553,9 +1561,11 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>  	 * We approximate round-robin by starting at the last boosted VCPU.
>  	 */
>  	for (pass = 0; pass < 2 && !yielded; pass++) {
> -		kvm_for_each_vcpu(i, vcpu, kvm) {
> +		rcu_read_lock();
> +		kvm_for_each_vcpu(it, vcpu, kvm) {
>  			struct task_struct *task = NULL;
>  			struct pid *pid;
> +			i = it.idx;
>  			if (!pass && i < last_boosted_vcpu) {
>  				i = last_boosted_vcpu;
>  				continue;
> @@ -1584,6 +1594,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>  			}
>  			put_task_struct(task);
>  		}
> +		rcu_read_unlock();
>  	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
> @@ -1623,8 +1634,8 @@ static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
>  static int kvm_vcpu_release(struct inode *inode, struct file *filp)
>  {
>  	struct kvm_vcpu *vcpu = filp->private_data;
> -
> -	kvm_put_kvm(vcpu->kvm);
> +	filp->private_data = NULL;
> +	kvm_vcpu_put(vcpu);
>  	return 0;
>  }
>  
> @@ -1646,6 +1657,48 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
>  	return anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, O_RDWR);
>  }
>  
> +/*Can not block*/
> +void kvm_vcpu_zap(struct rcu_head *rcu)
> +{
> +	struct kvm_vcpu *vcpu = container_of(rcu, struct kvm_vcpu, head);
> +	schedule_work(&vcpu->zap_work);
> +}
> +
> +/*increase refcnt*/
> +struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu == NULL)
> +		return NULL;
> +	if (atomic_add_unless(&vcpu->refcount, 1, 0))
> +		return vcpu;
> +	return NULL;
> +}
> +
> +void kvm_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm;
> +	if (atomic_dec_and_test(&vcpu->refcount)) {
> +		kvm = vcpu->kvm;
> +		mutex_lock(&kvm->lock);
> +		rcu_assign_pointer(kvm->vcpus[vcpu->vcpu_id], NULL);
> +		atomic_dec(&kvm->online_vcpus);
> +		mutex_unlock(&kvm->lock);
> +		call_rcu(&vcpu->head, kvm_vcpu_zap);
> +	}
> +}
> +
> +static struct kvm_vcpu *kvm_vcpu_create(struct kvm *kvm, u32 id)
> +{
> +	struct kvm_vcpu *vcpu;
> +	vcpu = kvm_arch_vcpu_create(kvm, id);
> +	if (IS_ERR(vcpu))
> +		return vcpu;
> +
> +	atomic_set(&vcpu->refcount, 1);
> +	INIT_WORK(&vcpu->zap_work, kvm_arch_vcpu_zap);
> +	return vcpu;
> +}
> +
>  /*
>   * Creates some virtual cpus.  Good luck creating more than one.
>   */
> @@ -1653,8 +1706,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  {
>  	int r;
>  	struct kvm_vcpu *vcpu, *v;
> +	struct kvm_iter it;
>  
> -	vcpu = kvm_arch_vcpu_create(kvm, id);
> +	vcpu = kvm_vcpu_create(kvm, id);
>  	if (IS_ERR(vcpu))
>  		return PTR_ERR(vcpu);
>  
> @@ -1670,11 +1724,15 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  		goto unlock_vcpu_destroy;
>  	}
>  
> -	kvm_for_each_vcpu(r, v, kvm)
> +	rcu_read_lock();
> +	kvm_for_each_vcpu(it, v, kvm) {
>  		if (v->vcpu_id == id) {
> +			rcu_read_unlock();
>  			r = -EEXIST;
>  			goto unlock_vcpu_destroy;
>  		}
> +	}
> +	rcu_read_unlock();
>  
>  	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
>  
> @@ -2593,13 +2651,17 @@ static int vcpu_stat_get(void *_offset, u64 *val)
>  	unsigned offset = (long)_offset;
>  	struct kvm *kvm;
>  	struct kvm_vcpu *vcpu;
> -	int i;
> +	struct kvm_iter it;
>  
>  	*val = 0;
>  	raw_spin_lock(&kvm_lock);
> -	list_for_each_entry(kvm, &vm_list, vm_list)
> -		kvm_for_each_vcpu(i, vcpu, kvm)
> +	list_for_each_entry(kvm, &vm_list, vm_list) {
> +		rcu_read_lock();
> +		kvm_for_each_vcpu(it, vcpu, kvm) {
>  			*val += *(u32 *)((void *)vcpu + offset);
> +		}
> +		rcu_read_unlock();
> +	}
>  
>  	raw_spin_unlock(&kvm_lock);
>  	return 0;
> -- 
> 1.7.4.4

--
			Gleb.
