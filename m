Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1LFGyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:54:08 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33762 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab1LFGyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:54:06 -0500
MIME-Version: 1.0
In-Reply-To: <20111205084159.GD12507@redhat.com>
References: <4ED212A1.3060300@redhat.com>
	<1322807192-14147-1-git-send-email-kernelfans@gmail.com>
	<4ED91871.4050904@siemens.com>
	<CAFgQCTvDQ9E5cGVxRP3ZPv8=TmhFqVOdMbcdcSMC8ctR3S+m6A@mail.gmail.com>
	<20111204121000.GC12507@redhat.com>
	<CAFgQCTu32fTfV2ZwTy+S4RxD4mr_pq8dddQnttLnSGvYsmh+HQ@mail.gmail.com>
	<20111205084159.GD12507@redhat.com>
Date: Tue, 6 Dec 2011 14:54:06 +0800
Message-ID: <CAFgQCTuTBO5WsKbMcZtwei74QiniWZ1mCiMGKivEpUJdP=v2Yg@mail.gmail.com>
Subject: Re: [PATCH] kvm: make vcpu life cycle separated from kvm instance
From: Liu ping fan <kernelfans@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, avi@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 4:41 PM, Gleb Natapov <gleb@redhat.com> wrote:
> On Mon, Dec 05, 2011 at 01:39:37PM +0800, Liu ping fan wrote:
>> On Sun, Dec 4, 2011 at 8:10 PM, Gleb Natapov <gleb@redhat.com> wrote:
>> > On Sun, Dec 04, 2011 at 07:53:37PM +0800, Liu ping fan wrote:
>> >> On Sat, Dec 3, 2011 at 2:26 AM, Jan Kiszka <jan.kiszka@siemens.com> wrote:
>> >> > On 2011-12-02 07:26, Liu Ping Fan wrote:
>> >> >> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>> >> >>
>> >> >> Currently, vcpu can be destructed only when kvm instance destroyed.
>> >> >> Change this to vcpu's destruction taken when its refcnt is zero,
>> >> >> and then vcpu MUST and CAN be destroyed before kvm's destroy.
>> >> >
>> >> > I'm lacking the big picture yet (would be good to have in the change log
>> >> > - at least I'm too lazy to read the code):
>> >> >
>> >> > What increments the refcnt, what decrements it again? IOW, how does user
>> >> > space controls the life-cycle of a vcpu after your changes?
>> >> >
>> >> In local APIC mode, delivering IPI to target APIC, target's refcnt is
>> >> incremented, and decremented when finished. At other times, using RCU to
>> > Why is this needed?
>> >
>> Suppose the following scene:
>>
>> #define kvm_for_each_vcpu(idx, vcpup, kvm) \
>>         for (idx = 0; \
>>              idx < atomic_read(&kvm->online_vcpus) && \
>>              (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
>>              idx++)
>>
>> ------------------------------------------------------------------------------------------>
>> Here kvm_vcpu's destruction is called
>>               vcpup->vcpu_id ...  //oops!
>>
>>
> And this is exactly how your code looks. i.e you do not increment
> reference count in most of the loops, you only increment it twice
> (in pic_unlock() and kvm_irq_delivery_to_apic()) because you are using
> vcpu outside of rcu_read_lock() protected section and I do not see why
> not just extend protected section to include kvm_vcpu_kick(). As far as
> I can see this function does not sleep.
>
:-), I just want to minimize the RCU critical area, and as you say, we
can  extend protected section to include kvm_vcpu_kick()

> What should protect vcpu from disappearing in your example above is RCU
> itself if you are using it right. But since I do not see any calls to
> rcu_assign_pointer()/rcu_dereference() I doubt you are using it right
> actually.
>
Sorry, but I thought it would not be. Please help me to check my thoughts :

struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu)
{
	if (vcpu == NULL)
		return NULL;
	if (atomic_add_unless(&vcpu->refcount, 1, 0))
------------------------------increment
		return vcpu;
	return NULL;
}

void kvm_vcpu_put(struct kvm_vcpu *vcpu)
{
	struct kvm *kvm;
	if (atomic_dec_and_test(&vcpu->refcount)) {
--------------------------decrement
		kvm = vcpu->kvm;
		mutex_lock(&kvm->lock);
		kvm->vcpus[vcpu->vcpu_id] = NULL;
		atomic_dec(&kvm->online_vcpus);
		mutex_unlock(&kvm->lock);
		call_rcu(&vcpu->head, kvm_vcpu_zap);
	}
}

The atomic of decrement and increment are protected by cache coherent protocol.
So once we hold a valid kvm_vcpu pointer through kvm_vcpu_get(),
we will always keep it until we release it, then, the destruction may happen.

Thanks and regards,
ping fan

> --
>                        Gleb.
