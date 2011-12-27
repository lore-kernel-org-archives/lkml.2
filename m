Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab1L0Hxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 02:53:45 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34212 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab1L0Hxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 02:53:39 -0500
MIME-Version: 1.0
In-Reply-To: <20111226110943.GB2072@redhat.com>
References: <1323657683-13934-1-git-send-email-kernelfans@gmail.com>
	<1324091975-20930-1-git-send-email-kernelfans@gmail.com>
	<20111226110943.GB2072@redhat.com>
Date: Tue, 27 Dec 2011 15:53:38 +0800
Message-ID: <CAFgQCTuuVyX4RH_8hSDuwW268g7ARKD=FtdA9qqtLphBfJ_9Mw@mail.gmail.com>
Subject: Re: [PATCH v5] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, mtosatti@redhat.com, jan.kiszka@web.de,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 7:09 PM, Gleb Natapov <gleb@redhat.com> wrote:
> On Sat, Dec 17, 2011 at 11:19:35AM +0800, Liu Ping Fan wrote:
>> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>>
>> Currently, vcpu can be destructed only when kvm instance destroyed.
>> Change this to vcpu's destruction before kvm instance, so vcpu MUST
>> and CAN be destroyed before kvm's destroy.
>>
>> Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/i8254.c     |   10 +++--
>>  arch/x86/kvm/i8259.c     |   12 ++++--
>>  arch/x86/kvm/x86.c       |   53 +++++++++++------------
>>  include/linux/kvm_host.h |   20 ++++-----
>>  virt/kvm/irq_comm.c      |    6 ++-
>>  virt/kvm/kvm_main.c      |  106 ++++++++++++++++++++++++++++++++++-----------
>>  6 files changed, 132 insertions(+), 75 deletions(-)
>>
>> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
>> index 76e3f1c..a3a5506 100644
>> --- a/arch/x86/kvm/i8254.c
>> +++ b/arch/x86/kvm/i8254.c
>> @@ -289,9 +289,8 @@ static void pit_do_work(struct work_struct *work)
>>       struct kvm_pit *pit = container_of(work, struct kvm_pit, expired);
>>       struct kvm *kvm = pit->kvm;
>>       struct kvm_vcpu *vcpu;
>> -     int i;
>>       struct kvm_kpit_state *ps = &pit->pit_state;
>> -     int inject = 0;
>> +     int idx, inject = 0;
>>
>>       /* Try to inject pending interrupts when
>>        * last one has been acked.
>> @@ -315,9 +314,12 @@ static void pit_do_work(struct work_struct *work)
>>                * LVT0 to NMI delivery. Other PIC interrupts are just sent to
>>                * VCPU0, and only if its LVT0 is in EXTINT mode.
>>                */
>> -             if (kvm->arch.vapics_in_nmi_mode > 0)
>> -                     kvm_for_each_vcpu(i, vcpu, kvm)
>> +             if (kvm->arch.vapics_in_nmi_mode > 0) {
>> +                     idx = srcu_read_lock(&kvm->srcu_vcpus);
>> +                     kvm_for_each_vcpu(vcpu, kvm)
>>                               kvm_apic_nmi_wd_deliver(vcpu);
>> +                     srcu_read_unlock(&kvm->srcu_vcpus, idx);
>> +             }
>>       }
>>  }
>>
>> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
>> index cac4746..5ef5c05 100644
>> --- a/arch/x86/kvm/i8259.c
>> +++ b/arch/x86/kvm/i8259.c
>> @@ -50,25 +50,29 @@ static void pic_unlock(struct kvm_pic *s)
>>  {
>>       bool wakeup = s->wakeup_needed;
>>       struct kvm_vcpu *vcpu, *found = NULL;
>> -     int i;
>> +     struct kvm *kvm = s->kvm;
>> +     int idx;
>>
>>       s->wakeup_needed = false;
>>
>>       spin_unlock(&s->lock);
>>
>>       if (wakeup) {
>> -             kvm_for_each_vcpu(i, vcpu, s->kvm) {
>> +             idx = srcu_read_lock(&kvm->srcu_vcpus);
>> +             kvm_for_each_vcpu(vcpu, kvm)
>>                       if (kvm_apic_accept_pic_intr(vcpu)) {
>>                               found = vcpu;
>>                               break;
>>                       }
>> -             }
>>
>> -             if (!found)
>> +             if (!found) {
>> +                     srcu_read_unlock(&kvm->srcu_vcpus, idx);
>>                       return;
>> +             }
>>
>>               kvm_make_request(KVM_REQ_EVENT, found);
>>               kvm_vcpu_kick(found);
>> +             srcu_read_unlock(&kvm->srcu_vcpus, idx);
>>       }
>>  }
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 23c93fe..b79739d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1774,14 +1774,20 @@ static int get_msr_hyperv_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>>  static int get_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>>  {
>>       u64 data = 0;
>> +     int idx;
>>
>>       switch (msr) {
>>       case HV_X64_MSR_VP_INDEX: {
>> -             int r;
>> +             int r = 0;
>>               struct kvm_vcpu *v;
>> -             kvm_for_each_vcpu(r, v, vcpu->kvm)
>> +             struct kvm *kvm = vcpu->kvm;
>> +             idx = srcu_read_lock(&kvm->srcu_vcpus);
>> +             kvm_for_each_vcpu(v, vcpu->kvm) {
>>                       if (v == vcpu)
>>                               data = r;
>> +                     r++;
>> +             }
>> +             srcu_read_unlock(&kvm->srcu_vcpus, idx);
>>               break;
>>       }
>>       case HV_X64_MSR_EOI:
>> @@ -4529,7 +4535,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
>>       struct cpufreq_freqs *freq = data;
>>       struct kvm *kvm;
>>       struct kvm_vcpu *vcpu;
>> -     int i, send_ipi = 0;
>> +     int idx, send_ipi = 0;
>>
>>       /*
>>        * We allow guests to temporarily run on slowing clocks,
>> @@ -4579,13 +4585,16 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
>>
>>       raw_spin_lock(&kvm_lock);
>>       list_for_each_entry(kvm, &vm_list, vm_list) {
>> -             kvm_for_each_vcpu(i, vcpu, kvm) {
>> +             idx = srcu_read_lock(&kvm->srcu_vcpus);
>> +             kvm_for_each_vcpu(vcpu, kvm) {
>>                       if (vcpu->cpu != freq->cpu)
>>                               continue;
>>                       kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>>                       if (vcpu->cpu != smp_processor_id())
>>                               send_ipi = 1;
>>               }
>> +             srcu_read_unlock(&kvm->srcu_vcpus, idx);
>> +
>>       }
>>       raw_spin_unlock(&kvm_lock);
>>
>> @@ -5866,13 +5875,17 @@ int kvm_arch_hardware_enable(void *garbage)
>>  {
>>       struct kvm *kvm;
>>       struct kvm_vcpu *vcpu;
>> -     int i;
>> +     int idx;
>>
>>       kvm_shared_msr_cpu_online();
>> -     list_for_each_entry(kvm, &vm_list, vm_list)
>> -             kvm_for_each_vcpu(i, vcpu, kvm)
>> +     list_for_each_entry(kvm, &vm_list, vm_list) {
>> +             idx = srcu_read_lock(&kvm->srcu_vcpus);
>> +             kvm_for_each_vcpu(vcpu, kvm) {
>>                       if (vcpu->cpu == smp_processor_id())
>>                               kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>> +             }
>> +             srcu_read_unlock(&kvm->srcu_vcpus, idx);
>> +     }
>>       return kvm_x86_ops->hardware_enable(garbage);
>>  }
>>
>> @@ -5989,27 +6002,14 @@ static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
>>       vcpu_put(vcpu);
>>  }
>>
>> -static void kvm_free_vcpus(struct kvm *kvm)
>> +void kvm_arch_vcpu_zap(struct kvm_vcpu *vcpu)
>>  {
>> -     unsigned int i;
>> -     struct kvm_vcpu *vcpu;
>> -
>> -     /*
>> -      * Unpin any mmu pages first.
>> -      */
>> -     kvm_for_each_vcpu(i, vcpu, kvm) {
>> -             kvm_clear_async_pf_completion_queue(vcpu);
>> -             kvm_unload_vcpu_mmu(vcpu);
>> -     }
>> -     kvm_for_each_vcpu(i, vcpu, kvm)
>> -             kvm_arch_vcpu_free(vcpu);
>> -
>> -     mutex_lock(&kvm->lock);
>> -     for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
>> -             kvm->vcpus[i] = NULL;
>> +     struct kvm *kvm = vcpu->kvm;
>>
>> -     atomic_set(&kvm->online_vcpus, 0);
>> -     mutex_unlock(&kvm->lock);
>> +     kvm_clear_async_pf_completion_queue(vcpu);
>> +     kvm_unload_vcpu_mmu(vcpu);
>> +     kvm_arch_vcpu_free(vcpu);
>> +     kvm_put_kvm(kvm);
>>  }
>>
>>  void kvm_arch_sync_events(struct kvm *kvm)
>> @@ -6023,7 +6023,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>>       kvm_iommu_unmap_guest(kvm);
>>       kfree(kvm->arch.vpic);
>>       kfree(kvm->arch.vioapic);
>> -     kvm_free_vcpus(kvm);
>>       if (kvm->arch.apic_access_page)
>>               put_page(kvm->arch.apic_access_page);
>>       if (kvm->arch.ept_identity_pagetable)
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 8c5c303..ab22828 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -115,6 +115,7 @@ enum {
>>
>>  struct kvm_vcpu {
>>       struct kvm *kvm;
>> +     struct list_head list;
>>  #ifdef CONFIG_PREEMPT_NOTIFIERS
>>       struct preempt_notifier preempt_notifier;
>>  #endif
>> @@ -249,13 +250,15 @@ struct kvm {
>>       struct mm_struct *mm; /* userspace tied to this vm */
>>       struct kvm_memslots *memslots;
>>       struct srcu_struct srcu;
>> +     struct srcu_struct srcu_vcpus;
>> +
>>  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
>>       u32 bsp_vcpu_id;
>>       struct kvm_vcpu *bsp_vcpu;
> Rebase to latest kvm.git.
>
>>  #endif
>> -     struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>> +     struct list_head vcpus;
>>       atomic_t online_vcpus;
>> -     int last_boosted_vcpu;
>> +     struct kvm_vcpu *last_boosted_vcpu;
>>       struct list_head vm_list;
>>       struct mutex lock;
>>       struct kvm_io_bus *buses[KVM_NR_BUSES];
>> @@ -302,17 +305,10 @@ struct kvm {
>>  #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
>>  #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
>>
>> -static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
>> -{
>> -     smp_rmb();
>> -     return kvm->vcpus[i];
>> -}
>> +void kvm_arch_vcpu_zap(struct kvm_vcpu *vcpu);
>>
>> -#define kvm_for_each_vcpu(idx, vcpup, kvm) \
>> -     for (idx = 0; \
>> -          idx < atomic_read(&kvm->online_vcpus) && \
>> -          (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
>> -          idx++)
>> +#define kvm_for_each_vcpu(vcpu, kvm) \
>> +     list_for_each_entry_rcu(vcpu, &kvm->vcpus, list)
>>
>>  #define kvm_for_each_memslot(memslot, slots) \
>>       for (memslot = &slots->memslots[0];     \
>> diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
>> index 9f614b4..78dc97c 100644
>> --- a/virt/kvm/irq_comm.c
>> +++ b/virt/kvm/irq_comm.c
>> @@ -81,14 +81,15 @@ inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
>>  int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>>               struct kvm_lapic_irq *irq)
>>  {
>> -     int i, r = -1;
>> +     int idx, r = -1;
>>       struct kvm_vcpu *vcpu, *lowest = NULL;
>>
>>       if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
>>                       kvm_is_dm_lowest_prio(irq))
>>               printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
>>
>> -     kvm_for_each_vcpu(i, vcpu, kvm) {
>> +     idx = srcu_read_lock(&kvm->srcu_vcpus);
>> +     kvm_for_each_vcpu(vcpu, kvm) {
>>               if (!kvm_apic_present(vcpu))
>>                       continue;
>>
>> @@ -111,6 +112,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>>       if (lowest)
>>               r = kvm_apic_set_irq(lowest, irq);
>>
>> +     srcu_read_unlock(&kvm->srcu_vcpus, idx);
>>       return r;
>>  }
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index e289486..ec0c920 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -171,7 +171,7 @@ static void ack_flush(void *_completed)
>>
>>  static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>>  {
>> -     int i, cpu, me;
>> +     int cpu, me, idx;
>>       cpumask_var_t cpus;
>>       bool called = true;
>>       struct kvm_vcpu *vcpu;
>> @@ -179,7 +179,8 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>>       zalloc_cpumask_var(&cpus, GFP_ATOMIC);
>>
>>       me = get_cpu();
>> -     kvm_for_each_vcpu(i, vcpu, kvm) {
>> +     idx = srcu_read_lock(&kvm->srcu_vcpus);
>> +     kvm_for_each_vcpu(vcpu, kvm) {
>>               kvm_make_request(req, vcpu);
>>               cpu = vcpu->cpu;
>>
>> @@ -190,12 +191,15 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>>                     kvm_vcpu_exiting_guest_mode(vcpu) != OUTSIDE_GUEST_MODE)
>>                       cpumask_set_cpu(cpu, cpus);
>>       }
>> +     srcu_read_unlock(&kvm->srcu_vcpus, idx);
>> +
>>       if (unlikely(cpus == NULL))
>>               smp_call_function_many(cpu_online_mask, ack_flush, NULL, 1);
>>       else if (!cpumask_empty(cpus))
>>               smp_call_function_many(cpus, ack_flush, NULL, 1);
>>       else
>>               called = false;
>> +
>>       put_cpu();
>>       free_cpumask_var(cpus);
>>       return called;
>> @@ -477,6 +481,8 @@ static struct kvm *kvm_create_vm(void)
>>       kvm_init_memslots_id(kvm);
>>       if (init_srcu_struct(&kvm->srcu))
>>               goto out_err_nosrcu;
>> +     if (init_srcu_struct(&kvm->srcu_vcpus))
>> +             goto out_err_nosrcu_vcpus;
>>       for (i = 0; i < KVM_NR_BUSES; i++) {
>>               kvm->buses[i] = kzalloc(sizeof(struct kvm_io_bus),
>>                                       GFP_KERNEL);
>> @@ -500,10 +506,13 @@ static struct kvm *kvm_create_vm(void)
>>       raw_spin_lock(&kvm_lock);
>>       list_add(&kvm->vm_list, &vm_list);
>>       raw_spin_unlock(&kvm_lock);
>> +     INIT_LIST_HEAD(&kvm->vcpus);
>>
>>       return kvm;
>>
>>  out_err:
>> +     cleanup_srcu_struct(&kvm->srcu_vcpus);
>> +out_err_nosrcu_vcpus:
>>       cleanup_srcu_struct(&kvm->srcu);
>>  out_err_nosrcu:
>>       hardware_disable_all();
>> @@ -587,6 +596,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>>       kvm_arch_destroy_vm(kvm);
>>       kvm_free_physmem(kvm);
>>       cleanup_srcu_struct(&kvm->srcu);
>> +     cleanup_srcu_struct(&kvm->srcu_vcpus);
>>       kvm_arch_free_vm(kvm);
>>       hardware_disable_all();
>>       mmdrop(mm);
>> @@ -1593,11 +1603,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>  {
>>       struct kvm *kvm = me->kvm;
>>       struct kvm_vcpu *vcpu;
>> -     int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
>> -     int yielded = 0;
>> -     int pass;
>> -     int i;
>> -
>> +     struct task_struct *task = NULL;
>> +     struct pid *pid;
>> +     int pass, firststart, lastone, yielded, idx;
>>       /*
>>        * We boost the priority of a VCPU that is runnable but not
>>        * currently running, because it got preempted by something
>> @@ -1605,15 +1613,22 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>        * VCPU is holding the lock that we need and will release it.
>>        * We approximate round-robin by starting at the last boosted VCPU.
>>        */
>> -     for (pass = 0; pass < 2 && !yielded; pass++) {
>> -             kvm_for_each_vcpu(i, vcpu, kvm) {
>> -                     struct task_struct *task = NULL;
>> -                     struct pid *pid;
>> -                     if (!pass && i < last_boosted_vcpu) {
>> -                             i = last_boosted_vcpu;
>> +     for (pass = 0, firststart = 0; pass < 2 && !yielded; pass++) {
>> +
>> +             idx = srcu_read_lock(&kvm->srcu_vcpus);
>> +             kvm_for_each_vcpu(vcpu, kvm) {
>> +                     if (!pass && !firststart &&
>> +                         vcpu != kvm->last_boosted_vcpu &&
>> +                         kvm->last_boosted_vcpu != NULL) {
>> +                             vcpu = kvm->last_boosted_vcpu;
> You access last_boosted_vcpu as if it is protected by srcu, but it
> isn't. kvm_vcpu_release() changes it after synchronize_srcu_expedited()
> call.
>
Oh, get it. It opens a gap to make the access to the reclaimed vcpu possible.

> I do not like this last_boosted_vcpu pointer much. May be we can rid of
> it by remembering last apic_id and searching for it each time we enter
> the function. I do not think this function is to performance sensitive.
> We enter here when vcpu is spinning anyway.
>
Fine, I find it is very hard to protect both the rcu_list and this
pointer at the same time. And vcpu_id give me a way out.

Thanks and regards,
ping fan
>> +                             firststart = 1;
>>                               continue;
>> -                     } else if (pass && i > last_boosted_vcpu)
>> +                     } else if (pass && !lastone) {
>> +                             if (vcpu == kvm->last_boosted_vcpu)
>> +                                     lastone = 1;
>> +                     } else if (pass && lastone)
>>                               break;
>> +
>>                       if (vcpu == me)
>>                               continue;
>>                       if (waitqueue_active(&vcpu->wq))
>> @@ -1629,15 +1644,20 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>                               put_task_struct(task);
>>                               continue;
>>                       }
>> +
>>                       if (yield_to(task, 1)) {
>>                               put_task_struct(task);
>> -                             kvm->last_boosted_vcpu = i;
>> +                             mutex_lock(&kvm->lock);
>> +                             kvm->last_boosted_vcpu = vcpu;
>> +                             mutex_unlock(&kvm->lock);
>>                               yielded = 1;
>>                               break;
>>                       }
>>                       put_task_struct(task);
>>               }
>> +             srcu_read_unlock(&kvm->srcu_vcpus, idx);
>>       }
>> +
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
>>
>> @@ -1673,11 +1693,30 @@ static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
>>       return 0;
>>  }
>>
>> +static void kvm_vcpu_zap(struct kvm_vcpu *vcpu)
>> +{
>> +     kvm_arch_vcpu_zap(vcpu);
>> +}
>> +
>>  static int kvm_vcpu_release(struct inode *inode, struct file *filp)
>>  {
>>       struct kvm_vcpu *vcpu = filp->private_data;
>> +     struct kvm *kvm = vcpu->kvm;
>> +     filp->private_data = NULL;
>> +
>> +     mutex_lock(&kvm->lock);
>> +     list_del_rcu(&vcpu->list);
>> +     atomic_dec(&kvm->online_vcpus);
>> +     mutex_unlock(&kvm->lock);
>> +     synchronize_srcu_expedited(&kvm->srcu_vcpus);
>> +
>> +     mutex_lock(&kvm->lock);
>> +     if (kvm->last_boosted_vcpu == vcpu)
>> +             kvm->last_boosted_vcpu = NULL;
>> +     mutex_unlock(&kvm->lock);
>>
>> -     kvm_put_kvm(vcpu->kvm);
>> +     /*vcpu is out of list,drop it safely*/
>> +     kvm_vcpu_zap(vcpu);
>>       return 0;
>>  }
>>
>> @@ -1699,15 +1738,25 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
>>       return anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, O_RDWR);
>>  }
>>
>> +static struct kvm_vcpu *kvm_vcpu_create(struct kvm *kvm, u32 id)
>> +{
>> +     struct kvm_vcpu *vcpu;
>> +     vcpu = kvm_arch_vcpu_create(kvm, id);
>> +     if (IS_ERR(vcpu))
>> +             return vcpu;
>> +     INIT_LIST_HEAD(&vcpu->list);
>> +     return vcpu;
>> +}
>> +
>>  /*
>>   * Creates some virtual cpus.  Good luck creating more than one.
>>   */
>>  static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>>  {
>> -     int r;
>> +     int r, idx;
>>       struct kvm_vcpu *vcpu, *v;
>>
>> -     vcpu = kvm_arch_vcpu_create(kvm, id);
>> +     vcpu = kvm_vcpu_create(kvm, id);
>>       if (IS_ERR(vcpu))
>>               return PTR_ERR(vcpu);
>>
>> @@ -1723,13 +1772,15 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>>               goto unlock_vcpu_destroy;
>>       }
>>
>> -     kvm_for_each_vcpu(r, v, kvm)
>> +     idx = srcu_read_lock(&kvm->srcu_vcpus);
>> +     kvm_for_each_vcpu(v, kvm) {
>>               if (v->vcpu_id == id) {
>>                       r = -EEXIST;
>> +                     srcu_read_unlock(&kvm->srcu_vcpus, idx);
>>                       goto unlock_vcpu_destroy;
>>               }
>> -
>> -     BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
>> +     }
>> +     srcu_read_unlock(&kvm->srcu_vcpus, idx);
>>
>>       /* Now it's all set up, let userspace reach it */
>>       kvm_get_kvm(kvm);
>> @@ -1739,8 +1790,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>>               goto unlock_vcpu_destroy;
>>       }
>>
>> -     kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
>> -     smp_wmb();
>> +     /*Protected by kvm->lock*/
>> +     list_add_rcu(&vcpu->list, &kvm->vcpus);
>>       atomic_inc(&kvm->online_vcpus);
>>
>>  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
>> @@ -2645,13 +2696,16 @@ static int vcpu_stat_get(void *_offset, u64 *val)
>>       unsigned offset = (long)_offset;
>>       struct kvm *kvm;
>>       struct kvm_vcpu *vcpu;
>> -     int i;
>> +     int idx;
>>
>>       *val = 0;
>>       raw_spin_lock(&kvm_lock);
>> -     list_for_each_entry(kvm, &vm_list, vm_list)
>> -             kvm_for_each_vcpu(i, vcpu, kvm)
>> +     list_for_each_entry(kvm, &vm_list, vm_list) {
>> +             idx = srcu_read_lock(&kvm->srcu_vcpus);
>> +             kvm_for_each_vcpu(vcpu, kvm)
>>                       *val += *(u32 *)((void *)vcpu + offset);
>> +             srcu_read_unlock(&kvm->srcu_vcpus, idx);
>> +     }
>>
>>       raw_spin_unlock(&kvm_lock);
>>       return 0;
>> --
>> 1.7.4.4
>
> --
>                        Gleb.
