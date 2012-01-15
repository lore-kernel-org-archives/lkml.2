Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab2AONRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 08:17:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60600 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2AONRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 08:17:39 -0500
MIME-Version: 1.0
In-Reply-To: <4F0ED40F.7050700@redhat.com>
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com>
	<1325904901-10317-1-git-send-email-kernelfans@gmail.com>
	<4F0ED40F.7050700@redhat.com>
Date: Sun, 15 Jan 2012 21:17:38 +0800
Message-ID: <CAFgQCTv1zqo+gPEWtGEcEwsVzeOM-otDK-W51LLphBY5q+dnbg@mail.gmail.com>
Subject: Re: [PATCH v7] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        gleb@redhat.com, mtosatti@redhat.com, xiaoguangrong.eric@gmail.com,
        jan.kiszka@web.de, yoshikawa.takuya@oss.ntt.co.jp,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 8:37 PM, Avi Kivity <avi@redhat.com> wrote:
> On 01/07/2012 04:55 AM, Liu Ping Fan wrote:
>> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>>
>> Currently, vcpu will be destructed only after kvm instance is
>> destroyed. This result to vcpu keep idle in kernel, but can not
>> be freed when it is unplugged in guest.
>>
>> Change this to vcpu's destruction before kvm instance, so vcpu MUST
>
> Must?
>
Yes, in kvm_arch_vcpu_destruct-->kvm_put_kvm(kvm); so after all vcpu
destroyed, then can kvm instance

>> and CAN be destroyed before kvm instance. By this way, we can remove
>> vcpu when guest does not need it any longer.
>>
>> TODO: push changes to other archs besides x86.
>>
>> -Rename kvm_vcpu_zap to kvm_vcpu_destruct and so on.
>
> kvm_vcpu_destroy.
>
The name "kvm_arch_vcpu_destroy" is already occupied in different arch.
So change
  kvm_vcpu_zap -> kvm_vcpu_destruct
  kvm_vcpu_arch_zap -> kvm_vcpu_arch_destruct

>>
>>  struct kvm_vcpu {
>>       struct kvm *kvm;
>> +     struct list_head list;
>
> vcpu_list_link, so it's clear this is not a head but a link, and so we
> know which list it belongs to.
>
OK
>> -     struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>> +     struct list_head vcpus;
>
> This has the potential for a slight performance regression by bouncing
> an extra cache line, but it's acceptable IMO.  We can always introduce

Sorry, not clear about this scene, do you mean that the changing of
vcpu link list will cause the invalid of cache between SMP? But the
link list is not changed often.
> an apic ID -> vcpu hash table which improves things all around.
>
>> |
>> @@ -1593,11 +1598,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
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
>
> Avoid unrelated changes please.
>
OK
>> @@ -1605,15 +1608,26 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
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
>> +             idx = srcu_read_lock(&kvm->srcu);
>
> Can move the lock to the top level.
>
OK
>> +             kvm_for_each_vcpu(vcpu, kvm) {
>> +                     if (kvm->last_boosted_vcpu_id < 0 && !pass) {
>> +                             pass = 1;
>> +                             break;
>> +                     }
>> +                     if (!pass && !firststart &&
>> +                         vcpu->vcpu_id != kvm->last_boosted_vcpu_id) {
>> +                             continue;
>> +                     } else if (!pass && !firststart) {
>> +                             firststart = 1;
>>                               continue;
>> -                     } else if (pass && i > last_boosted_vcpu)
>> +                     } else if (pass && !lastone) {
>> +                             if (vcpu->vcpu_id == kvm->last_boosted_vcpu_id)
>> +                                     lastone = 1;
>> +                     } else if (pass && lastone)
>>                               break;
>> +
>
> Seems like a large change.  Is this because the vcpu list is unordered?
> Maybe it's better to order it.
>
To find the last boosted vcpu (I guest it is more likely the lock
holder), we must enumerate the vcpu link list. While implemented by
kvm->vcpus[], it is more facile.

> Rik?
>
>>                       if (vcpu == me)
>>                               continue;
>>                       if (waitqueue_active(&vcpu->wq))
>> @@ -1629,15 +1643,20 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>                               put_task_struct(task);
>>                               continue;
>>                       }
>> +
>>                       if (yield_to(task, 1)) {
>>                               put_task_struct(task);
>> -                             kvm->last_boosted_vcpu = i;
>> +                             mutex_lock(&kvm->lock);
>> +                             kvm->last_boosted_vcpu_id = vcpu->vcpu_id;
>> +                             mutex_unlock(&kvm->lock);
>
> Why take the mutex?
>
In kvm_vcpu_release()
       mutex_lock(&kvm->lock);
       if (kvm->last_boosted_vcpu_id == vcpu->vcpu_id)

----------------------------------------->CAN NOT break
               kvm->last_boosted_vcpu_id = -1;
       mutex_unlock(&kvm->lock);

>> @@ -1673,11 +1692,30 @@ static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
>>       return 0;
>>  }
>>
>> +static void kvm_vcpu_destruct(struct kvm_vcpu *vcpu)
>> +{
>> +     kvm_arch_vcpu_destruct(vcpu);
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
>> +     synchronize_srcu_expedited(&kvm->srcu);
>
> Why _expedited?
>
> Even better would be call_srcu() but it doesn't exist.
>
> I think we can actually use regular rcu.  The only user that blocks is
> kvm_vcpu_on_spin(), yes? so we can convert the vcpu to a task using
> get_pid_task(), then, outside the rcu lock, call yield_to().
>
Yes,  kvm_vcpu_on_spin() is the only one. But I think if outside the
rcu lock, call yield_to(), it will be like the following

again:
    rcu_lock()
    kvm_for_each_vcpu(){
    ......
    }
    rcu_unlock()
    if (yield_to(task, 1)) {
    .....
    } else
        goto again;

We must travel through the linked list again to find the next vcpu.

>
>>
>> -     kvm_put_kvm(vcpu->kvm);
>> +     mutex_lock(&kvm->lock);
>> +     if (kvm->last_boosted_vcpu_id == vcpu->vcpu_id)
>> +             kvm->last_boosted_vcpu_id = -1;
>> +     mutex_unlock(&kvm->lock);
>> +
>> +     /*vcpu is out of list,drop it safely*/
>> +     kvm_vcpu_destruct(vcpu);
>
> Can all kvm_arch_vcpu_destroy() directly.
>
>> +static struct kvm_vcpu *kvm_vcpu_create(struct kvm *kvm, u32 id)
>> +{
>> +     struct kvm_vcpu *vcpu;
>> +     vcpu = kvm_arch_vcpu_create(kvm, id);
>> +     if (IS_ERR(vcpu))
>> +             return vcpu;
>> +     INIT_LIST_HEAD(&vcpu->list);
>
> Really needed?
>
Yes, it is unnecessary
>> +     return vcpu;
>> +}
>
> Just fold this into the caller.
>
OK

Thanks and regards,
ping fan
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
>> @@ -1723,13 +1771,15 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>>               goto unlock_vcpu_destroy;
>>       }
>>
>> -     kvm_for_each_vcpu(r, v, kvm)
>> +     idx = srcu_read_lock(&kvm->srcu);
>> +     kvm_for_each_vcpu(v, kvm) {
>>               if (v->vcpu_id == id) {
>>                       r = -EEXIST;
>> +                     srcu_read_unlock(&kvm->srcu, idx);
>
> Put that in the error path please (add a new label if needed).
>
>>                       goto unlock_vcpu_destroy;
>
>>
>> -     kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
>> -     smp_wmb();
>> +     /*Protected by kvm->lock*/
>
> Spaces.
>
>> +     list_add_rcu(&vcpu->list, &kvm->vcpus);
>>       atomic_inc(&kvm->online_vcpus);
>
>
>
> --
> error compiling committee.c: too many arguments to function
>
