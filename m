Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1LQD5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 22:57:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44539 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1LQD5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 22:57:01 -0500
MIME-Version: 1.0
In-Reply-To: <4EE99846.5080302@oss.ntt.co.jp>
References: <CAFgQCTtkaTpjDyyzEaNwNv_+FdjTQ+ZbYAAbAUKZ6NmWXJfheA@mail.gmail.com>
	<1323923328-917-1-git-send-email-kernelfans@gmail.com>
	<4EE99846.5080302@oss.ntt.co.jp>
Date: Sat, 17 Dec 2011 11:57:00 +0800
Message-ID: <CAFgQCTv8URYPXzL5wjnpnS=KTUERdj5Mvi7jzSOiVwThhJ9yCg@mail.gmail.com>
Subject: Re: [PATCH v4] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, gleb@redhat.com, mtosatti@redhat.com,
        jan.kiszka@web.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/15 Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>:
> (2011/12/15 13:28), Liu Ping Fan wrote:
>> From: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
>>
>> Currently, vcpu can be destructed only when kvm instance destroyed.
>> Change this to vcpu's destruction before kvm instance, so vcpu MUST
>> and CAN be destroyed before kvm's destroy.
>
> Could you explain why this change is needed here?
> Would be helpful for those, including me, who will read the commit later.
>
Suppose the following scene,
Firstly, creating 10 kvm_vcpu for guest to take the advantage of
multi-core. Now, reclaiming some of the kvm_vcpu, so we can limit the
guest's usage of cpu. Then what about the kvm_vcpu unused? Currently
they are just idle in kernel, but with this patch, we can remove them.

>>
>> Signed-off-by: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
>> ---
>
> ...
>
>> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
>> index cac4746..f275b8c 100644
>> --- a/arch/x86/kvm/i8259.c
>> +++ b/arch/x86/kvm/i8259.c
>> @@ -50,25 +50,28 @@ static void pic_unlock(struct kvm_pic *s)
>>   {
>>       bool wakeup = s->wakeup_needed;
>>       struct kvm_vcpu *vcpu, *found = NULL;
>> -     int i;
>> +     struct kvm *kvm = s->kvm;
>>
>>       s->wakeup_needed = false;
>>
>>       spin_unlock(&s->lock);
>>
>>       if (wakeup) {
>> -             kvm_for_each_vcpu(i, vcpu, s->kvm) {
>> +             rcu_read_lock();
>> +             kvm_for_each_vcpu(vcpu, kvm)
>>                       if (kvm_apic_accept_pic_intr(vcpu)) {
>>                               found = vcpu;
>>                               break;
>>                       }
>> -             }
>>
>> -             if (!found)
>> +             if (!found) {
>> +                     rcu_read_unlock();
>>                       return;
>> +             }
>>
>>               kvm_make_request(KVM_REQ_EVENT, found);
>>               kvm_vcpu_kick(found);
>> +             rcu_read_unlock();
>>       }
>>   }
>
> How about this? (just about stylistic issues)
>
:-), I just want to change based on old code. But your style is OK too.

>        if (!wakeup)
>                return;
>
>        rcu_read_lock();
>        kvm_for_each_vcpu(vcpu, kvm)
>                if (kvm_apic_accept_pic_intr(vcpu)) {
>                        found = vcpu;
>                        break;
>                }
>
>        if (!found)
>                goto out;
>
>        kvm_make_request(KVM_REQ_EVENT, found);
>        kvm_vcpu_kick(found);
> out:
>        rcu_read_unlock();
>
> ...
>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>
> ...
>
>> +void kvm_arch_vcpu_zap(struct work_struct *work)
>> +{
>> +     struct kvm_vcpu *vcpu = container_of(work, struct kvm_vcpu,
>> +                     zap_work);
>> +     struct kvm *kvm = vcpu->kvm;
>>
>> -     atomic_set(&kvm->online_vcpus, 0);
>> -     mutex_unlock(&kvm->lock);
>> +     kvm_clear_async_pf_completion_queue(vcpu);
>> +     kvm_unload_vcpu_mmu(vcpu);
>> +     kvm_arch_vcpu_free(vcpu);
>> +     kvm_put_kvm(kvm);
>>   }
>
> zap is really a good name for this?
>
zap = destroy, so I think it is OK.
> ...
>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index d526231..733de1c 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -19,6 +19,7 @@
>>   #include<linux/slab.h>
>>   #include<linux/rcupdate.h>
>>   #include<linux/ratelimit.h>
>> +#include<linux/atomic.h>
>>   #include<asm/signal.h>
>>
>>   #include<linux/kvm.h>
>> @@ -113,6 +114,10 @@ enum {
>>
>>   struct kvm_vcpu {
>>       struct kvm *kvm;
>> +     atomic_t refcount;
>> +     struct list_head list;
>> +     struct rcu_head head;
>> +     struct work_struct zap_work;
>
> How about adding some comments?
> zap_work is not at all self explanatory, IMO.
>
>
>>   #ifdef CONFIG_PREEMPT_NOTIFIERS
>>       struct preempt_notifier preempt_notifier;
>>   #endif
>> @@ -241,9 +246,9 @@ struct kvm {
>>       u32 bsp_vcpu_id;
>>       struct kvm_vcpu *bsp_vcpu;
>>   #endif
>> -     struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>> +     struct list_head vcpus;
>>       atomic_t online_vcpus;
>> -     int last_boosted_vcpu;
>> +     struct kvm_vcpu *last_boosted_vcpu;
>>       struct list_head vm_list;
>>       struct mutex lock;
>>       struct kvm_io_bus *buses[KVM_NR_BUSES];
>> @@ -290,17 +295,15 @@ struct kvm {
>>   #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
>>   #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
>>
>> -static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
>> -{
>> -     smp_rmb();
>> -     return kvm->vcpus[i];
>> -}
>> +struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu);
>> +void kvm_vcpu_put(struct kvm_vcpu *vcpu);
>> +void kvm_arch_vcpu_zap(struct work_struct *work);
>> +
>> +#define kvm_for_each_vcpu(vcpu, kvm) \
>> +     list_for_each_entry_rcu(vcpu,&kvm->vcpus, list)
>
> Is this macro really worth it?
> _rcu shows readers important information, I think.
>
I guest kvm_for_each_vcpu is designed for hiding the details of
internal implement, and currently it is implemented by array, and my
patch will change it to linked-list,
so IMO, we can still hide the details.

Regards,
ping fan

>>
>> -#define kvm_for_each_vcpu(idx, vcpup, kvm) \
>> -     for (idx = 0; \
>> -          idx<  atomic_read(&kvm->online_vcpus)&&  \
>> -          (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
>> -          idx++)
>> +#define kvm_for_each_vcpu_continue(vcpu, kvm) \
>> +     list_for_each_entry_continue_rcu(vcpu,&kvm->vcpus, list)
>
> Same here.
> Why do you want to hide _rcu from readers?
>
>
>        Takuya
