Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab1LPHui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 02:50:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52112 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1LPHug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 02:50:36 -0500
MIME-Version: 1.0
In-Reply-To: <20111215091037.GB21664@redhat.com>
References: <CAFgQCTtkaTpjDyyzEaNwNv_+FdjTQ+ZbYAAbAUKZ6NmWXJfheA@mail.gmail.com>
	<1323923328-917-1-git-send-email-kernelfans@gmail.com>
	<20111215091037.GB21664@redhat.com>
Date: Fri, 16 Dec 2011 15:50:35 +0800
Message-ID: <CAFgQCTvH3tguhHD1ThmVmgP88uwDa5Dow_eCed7Nk=N5ooJyjA@mail.gmail.com>
Subject: Re: [PATCH v4] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, mtosatti@redhat.com, jan.kiszka@web.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBG7olxl014095

On Thu, Dec 15, 2011 at 5:10 PM, Gleb Natapov <gleb@redhat.com> wrote:
> On Thu, Dec 15, 2011 at 12:28:48PM +0800, Liu Ping Fan wrote:
>> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>>
>> Currently, vcpu can be destructed only when kvm instance destroyed.
>> Change this to vcpu's destruction before kvm instance, so vcpu MUST
>> and CAN be destroyed before kvm's destroy.
>>
> I see reference counting is back.
>
Resort to SRCU in next version, I will remove refcnt.

>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index d9cfb78..71dda47 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -141,6 +141,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
>>  {
>>       int cpu;
>>
>> +     kvm_vcpu_get(vcpu);
>>       mutex_lock(&vcpu->mutex);
>>       if (unlikely(vcpu->pid != current->pids[PIDTYPE_PID].pid)) {
>>               /* The thread running this VCPU changed. */
>> @@ -163,6 +164,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
>>       preempt_notifier_unregister(&vcpu->preempt_notifier);
>>       preempt_enable();
>>       mutex_unlock(&vcpu->mutex);
>> +     kvm_vcpu_put(vcpu);
>>  }
>>
> Why is kvm_vcpu_get/kvm_vcpu_put is needed in vcpu_load/vcpu_put?
> As far as I see load/put are only called in vcpu ioctl,
> kvm_arch_vcpu_setup(), kvm_arch_vcpu_destroy() and kvm_arch_destroy_vm().
>
> kvm_arch_vcpu_setup() and kvm_arch_vcpu_destroy() are called before vcpu is
> added to vcpus list, so it can't be accessed by other thread at this
> point. kvm_arch_destroy_vm() is  called on KVM destruction path when all
> vcpus should be destroyed already. So the only interesting place is vcpu
> ioctl and I think we are protected by fd refcount there. vcpu fd can't
> be closed while ioctl is executing for that vcpu. Otherwise we would
> have problem now too.
>
Yeah, ioctl is protected by fd refcount. That is what I had aimed to,
but as you pointed out, it is unnecessary at all.

>> @@ -1539,12 +1547,10 @@ EXPORT_SYMBOL_GPL(kvm_resched);
>>  void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>  {
>>       struct kvm *kvm = me->kvm;
>> -     struct kvm_vcpu *vcpu;
>> -     int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
>> -     int yielded = 0;
>> -     int pass;
>> -     int i;
>> -
>> +     struct kvm_vcpu *vcpu, *v;
>> +     struct task_struct *task = NULL;
>> +     struct pid *pid;
>> +     int pass, firststart, lastone, yielded;
>>       /*
>>        * We boost the priority of a VCPU that is runnable but not
>>        * currently running, because it got preempted by something
>> @@ -1552,15 +1558,22 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
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
>> +             rcu_read_lock();
>> +             kvm_for_each_vcpu(vcpu, kvm) {
>> +                     if (!pass && !firststart &&
>> +                         vcpu != kvm->last_boosted_vcpu &&
>> +                         kvm->last_boosted_vcpu != NULL) {
>> +                             vcpu = kvm->last_boosted_vcpu;
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
>> @@ -1576,15 +1589,29 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>                               put_task_struct(task);
>>                               continue;
>>                       }
>> +                     v = kvm_vcpu_get(vcpu);
>> +                     if (v == NULL)
>> +                             continue;
>> +
>> +                     rcu_read_unlock();
>>                       if (yield_to(task, 1)) {
>>                               put_task_struct(task);
>> -                             kvm->last_boosted_vcpu = i;
>> +                             mutex_lock(&kvm->lock);
>> +                             /*Remeber to release it.*/
>> +                             if (kvm->last_boosted_vcpu != NULL)
>> +                                     kvm_vcpu_put(kvm->last_boosted_vcpu);
>> +                             kvm->last_boosted_vcpu = vcpu;
>> +                             mutex_unlock(&kvm->lock);
>>                               yielded = 1;
> I think we can be smart and protect kvm->last_boosted_vcpu with the same
> rcu as vcpus, but yeild_to() can sleep anyway. Hmm may be we should use
> srcu in the first place :( Or rewrite the logic of the functions
> somehow to call yield_to() outside of the loop. This is heuristics anyway.
>
And I think changing to srcu will be easier :-), and have started to do it.

Thanks and regards
ping fan
> --
>                        Gleb.
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
