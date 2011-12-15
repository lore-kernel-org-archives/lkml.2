Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1LOGxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:53:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62269 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab1LOGxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:53:15 -0500
MIME-Version: 1.0
In-Reply-To: <4EE9869F.4070702@linux.vnet.ibm.com>
References: <CAFgQCTtkaTpjDyyzEaNwNv_+FdjTQ+ZbYAAbAUKZ6NmWXJfheA@mail.gmail.com>
	<1323923328-917-1-git-send-email-kernelfans@gmail.com>
	<4EE9869F.4070702@linux.vnet.ibm.com>
Date: Thu, 15 Dec 2011 14:53:14 +0800
Message-ID: <CAFgQCTu_S9=ve1=FTZ-BHaXExqPhtPu2D92Gy=85XaZw=e81bQ@mail.gmail.com>
Subject: Re: [PATCH v4] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, gleb@redhat.com, mtosatti@redhat.com,
        jan.kiszka@web.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 1:33 PM, Xiao Guangrong
<xiaoguangrong@linux.vnet.ibm.com> wrote:
> On 12/15/2011 12:28 PM, Liu Ping Fan wrote:
>
>
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1833,11 +1833,12 @@ static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
>>
>>  static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
>>  {
>> -     int i;
>>       struct kvm_vcpu *vcpu;
>>
>> -     kvm_for_each_vcpu(i, vcpu, kvm)
>> +     rcu_read_lock();
>> +     kvm_for_each_vcpu(vcpu, kvm)
>>               vcpu->arch.last_pte_updated = NULL;
>> +     rcu_read_unlock();
>>  }
>>
>
>
> I am sure that you should rebase it on the current kvm tree.
>
OK, I will rebase it in next patch

>>  static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c38efd7..acaa154 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1830,11 +1830,13 @@ static int get_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>>
>>       switch (msr) {
>>       case HV_X64_MSR_VP_INDEX: {
>> -             int r;
>> +             int r = 0;
>>               struct kvm_vcpu *v;
>> -             kvm_for_each_vcpu(r, v, vcpu->kvm)
>> +             kvm_for_each_vcpu(v, vcpu->kvm) {
>>                       if (v == vcpu)
>>                               data = r;
>> +                     r++;
>> +             }
>
>
> Do not need rcu_lock?
>
Need! Sorry, forget.

>> +struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu);
>> +void kvm_vcpu_put(struct kvm_vcpu *vcpu);
>> +void kvm_arch_vcpu_zap(struct work_struct *work);
>> +
>> +#define kvm_for_each_vcpu(vcpu, kvm) \
>> +     list_for_each_entry_rcu(vcpu, &kvm->vcpus, list)
>>
>> -#define kvm_for_each_vcpu(idx, vcpup, kvm) \
>> -     for (idx = 0; \
>> -          idx < atomic_read(&kvm->online_vcpus) && \
>> -          (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
>> -          idx++)
>> +#define kvm_for_each_vcpu_continue(vcpu, kvm) \
>> +     list_for_each_entry_continue_rcu(vcpu, &kvm->vcpus, list)
>>
>
>
> Where is it used?
>
Once I used it in kvm_vcpu_on_spin, but now, it is useless. I will remove it.

>> +struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu)
>> +{
>> +     if (vcpu == NULL)
>> +             return NULL;
>> +     if (atomic_add_unless(&vcpu->refcount, 1, 0))
>
>
> Why do not use atomic_inc()?
> Also, i think a memory barrier is needed after increasing refcount.
>
Because when refcout==0, we prepare to destroy vcpu, and do not to
disturb it by increasing the refcount.
And sorry but I can not figure out the scene why memory barrier needed
here.  Seems no risks on SMP.

>> -     kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
>> +     /*Protected by kvm->lock*/
>> +     list_add_rcu(&vcpu->list, &kvm->vcpus);
>> +
>>       smp_wmb();
>
>
> This barrier can also be removed.
>
Yes, I think you are right.

Thanks and regards,
ping fan


>>       atomic_inc(&kvm->online_vcpus);
>>
>>  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
>>       if (kvm->bsp_vcpu_id == id)
>> -             kvm->bsp_vcpu = vcpu;
>> +             kvm->bsp_vcpu = kvm_vcpu_get(vcpu);
>>  #endif
>>       mutex_unlock(&kvm->lock);
>>       return r;
>> @@ -2593,13 +2667,15 @@ static int vcpu_stat_get(void *_offset, u64 *val)
>>       unsigned offset = (long)_offset;
>>       struct kvm *kvm;
>>       struct kvm_vcpu *vcpu;
>> -     int i;
>>
>>       *val = 0;
>>       raw_spin_lock(&kvm_lock);
>> -     list_for_each_entry(kvm, &vm_list, vm_list)
>> -             kvm_for_each_vcpu(i, vcpu, kvm)
>> +     list_for_each_entry(kvm, &vm_list, vm_list) {
>> +             rcu_read_lock();
>> +             kvm_for_each_vcpu(vcpu, kvm)
>>                       *val += *(u32 *)((void *)vcpu + offset);
>> +             rcu_read_unlock();
>> +     }
>>
>>       raw_spin_unlock(&kvm_lock);
>>       return 0;
>> @@ -2765,7 +2841,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>>       kvm_preempt_ops.sched_out = kvm_sched_out;
>>
>>       kvm_init_debug();
>> -
>
>
> You don not change anything, please do not touch this line.
>
