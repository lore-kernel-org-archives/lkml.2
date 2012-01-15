Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab2AONha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 08:37:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2AONh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 08:37:29 -0500
Message-ID: <4F12D68F.7000701@redhat.com>
Date: Sun, 15 Jan 2012 15:37:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Liu ping fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        gleb@redhat.com, mtosatti@redhat.com, xiaoguangrong.eric@gmail.com,
        jan.kiszka@web.de, yoshikawa.takuya@oss.ntt.co.jp,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v7] kvm: make vcpu life cycle separated from kvm instance
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com> <1325904901-10317-1-git-send-email-kernelfans@gmail.com> <4F0ED40F.7050700@redhat.com> <CAFgQCTv1zqo+gPEWtGEcEwsVzeOM-otDK-W51LLphBY5q+dnbg@mail.gmail.com>
In-Reply-To: <CAFgQCTv1zqo+gPEWtGEcEwsVzeOM-otDK-W51LLphBY5q+dnbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2012 03:17 PM, Liu ping fan wrote:
> On Thu, Jan 12, 2012 at 8:37 PM, Avi Kivity <avi@redhat.com> wrote:
> > On 01/07/2012 04:55 AM, Liu Ping Fan wrote:
> >> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> >>
> >> Currently, vcpu will be destructed only after kvm instance is
> >> destroyed. This result to vcpu keep idle in kernel, but can not
> >> be freed when it is unplugged in guest.
> >>
> >> Change this to vcpu's destruction before kvm instance, so vcpu MUST
> >
> > Must?
> >
> Yes, in kvm_arch_vcpu_destruct-->kvm_put_kvm(kvm); so after all vcpu
> destroyed, then can kvm instance

Oh.  Words like MUST imply that the user has to do something different. 
It's just that the normal order of operations changes.

> >> and CAN be destroyed before kvm instance. By this way, we can remove
> >> vcpu when guest does not need it any longer.
> >>
> >> TODO: push changes to other archs besides x86.
> >>
> >> -Rename kvm_vcpu_zap to kvm_vcpu_destruct and so on.
> >
> > kvm_vcpu_destroy.
> >
> The name "kvm_arch_vcpu_destroy" is already occupied in different arch.

It's actually in all archs.  But having both kvm_arch_vcpu_destroy() and
kvm_arch_vcpu_destruct() isn't going to make the code more
understandable, need to merge the two, or find different names.

> So change
>   kvm_vcpu_zap -> kvm_vcpu_destruct
>   kvm_vcpu_arch_zap -> kvm_vcpu_arch_destruct



> >> -     struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
> >> +     struct list_head vcpus;
> >
> > This has the potential for a slight performance regression by bouncing
> > an extra cache line, but it's acceptable IMO.  We can always introduce
>
> Sorry, not clear about this scene, do you mean that the changing of
> vcpu link list will cause the invalid of cache between SMP? But the
> link list is not changed often.

No, I mean that kvm_for_each_vcpu() now has to bounce a cacheline for
each vcpu, in order to read the link.

> >> +             kvm_for_each_vcpu(vcpu, kvm) {
> >> +                     if (kvm->last_boosted_vcpu_id < 0 && !pass) {
> >> +                             pass = 1;
> >> +                             break;
> >> +                     }
> >> +                     if (!pass && !firststart &&
> >> +                         vcpu->vcpu_id != kvm->last_boosted_vcpu_id) {
> >> +                             continue;
> >> +                     } else if (!pass && !firststart) {
> >> +                             firststart = 1;
> >>                               continue;
> >> -                     } else if (pass && i > last_boosted_vcpu)
> >> +                     } else if (pass && !lastone) {
> >> +                             if (vcpu->vcpu_id == kvm->last_boosted_vcpu_id)
> >> +                                     lastone = 1;
> >> +                     } else if (pass && lastone)
> >>                               break;
> >> +
> >
> > Seems like a large change.  Is this because the vcpu list is unordered?
> > Maybe it's better to order it.
> >
> To find the last boosted vcpu (I guest it is more likely the lock
> holder), we must enumerate the vcpu link list. While implemented by
> kvm->vcpus[], it is more facile.

Please simplify this code, it's pretty complicated.

> >> +
> >>                       if (yield_to(task, 1)) {
> >>                               put_task_struct(task);
> >> -                             kvm->last_boosted_vcpu = i;
> >> +                             mutex_lock(&kvm->lock);
> >> +                             kvm->last_boosted_vcpu_id = vcpu->vcpu_id;
> >> +                             mutex_unlock(&kvm->lock);
> >
> > Why take the mutex?
> >
> In kvm_vcpu_release()
>        mutex_lock(&kvm->lock);
>        if (kvm->last_boosted_vcpu_id == vcpu->vcpu_id)
>
> ----------------------------------------->CAN NOT break
>                kvm->last_boosted_vcpu_id = -1;
>        mutex_unlock(&kvm->lock);

It's not pretty taking a vm-wide lock here.  Just make the code
resilient to incorrect vcpu_id.  If it doesn't find
last_boosted_vcpu_id, it should just pick something, like the first or
last vcpu in the list.

>
> >>  static int kvm_vcpu_release(struct inode *inode, struct file *filp)
> >>  {
> >>       struct kvm_vcpu *vcpu = filp->private_data;
> >> +     struct kvm *kvm = vcpu->kvm;
> >> +     filp->private_data = NULL;
> >> +
> >> +     mutex_lock(&kvm->lock);
> >> +     list_del_rcu(&vcpu->list);
> >> +     atomic_dec(&kvm->online_vcpus);
> >> +     mutex_unlock(&kvm->lock);
> >> +     synchronize_srcu_expedited(&kvm->srcu);
> >
> > Why _expedited?
> >
> > Even better would be call_srcu() but it doesn't exist.
> >
> > I think we can actually use regular rcu.  The only user that blocks is
> > kvm_vcpu_on_spin(), yes? so we can convert the vcpu to a task using
> > get_pid_task(), then, outside the rcu lock, call yield_to().
> >
> Yes,  kvm_vcpu_on_spin() is the only one. But I think if outside the
> rcu lock, call yield_to(), it will be like the following
>
> again:
>     rcu_lock()
>     kvm_for_each_vcpu(){
>     ......
>     }
>     rcu_unlock()
>     if (yield_to(task, 1)) {
>     .....
>     } else
>         goto again;
>
> We must travel through the linked list again to find the next vcpu.

Annoying... maybe we should use an array instead of a list after all.

>
> >
> >> +static struct kvm_vcpu *kvm_vcpu_create(struct kvm *kvm, u32 id)
> >> +{
> >> +     struct kvm_vcpu *vcpu;
> >> +     vcpu = kvm_arch_vcpu_create(kvm, id);
> >> +     if (IS_ERR(vcpu))
> >> +             return vcpu;
> >> +     INIT_LIST_HEAD(&vcpu->list);
> >
> > Really needed?
> >
> Yes, it is unnecessary

Why?  list_add_rcu() will overwrite it anyway.

-- 
error compiling committee.c: too many arguments to function

