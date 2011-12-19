Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab1LSBPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 20:15:47 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:49889 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1LSBPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 20:15:45 -0500
Message-ID: <4EEE9077.8090006@oss.ntt.co.jp>
Date: Mon, 19 Dec 2011 10:16:39 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Liu ping fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, gleb@redhat.com, mtosatti@redhat.com,
        jan.kiszka@web.de
Subject: Re: [PATCH v4] kvm: make vcpu life cycle separated from kvm instance
References: <CAFgQCTtkaTpjDyyzEaNwNv_+FdjTQ+ZbYAAbAUKZ6NmWXJfheA@mail.gmail.com>	<1323923328-917-1-git-send-email-kernelfans@gmail.com>	<4EE99846.5080302@oss.ntt.co.jp> <CAFgQCTv8URYPXzL5wjnpnS=KTUERdj5Mvi7jzSOiVwThhJ9yCg@mail.gmail.com>
In-Reply-To: <CAFgQCTv8URYPXzL5wjnpnS=KTUERdj5Mvi7jzSOiVwThhJ9yCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liu ping fan wrote:
> Suppose the following scene,
> Firstly, creating 10 kvm_vcpu for guest to take the advantage of
> multi-core. Now, reclaiming some of the kvm_vcpu, so we can limit the
> guest's usage of cpu. Then what about the kvm_vcpu unused? Currently
> they are just idle in kernel, but with this patch, we can remove them.

Then why not write it in the changelog?

>>> +void kvm_arch_vcpu_zap(struct work_struct *work)
>>> +{
>>> +     struct kvm_vcpu *vcpu = container_of(work, struct kvm_vcpu,
>>> +                     zap_work);
>>> +     struct kvm *kvm = vcpu->kvm;
>>>
>>> -     atomic_set(&kvm->online_vcpus, 0);
>>> -     mutex_unlock(&kvm->lock);
>>> +     kvm_clear_async_pf_completion_queue(vcpu);
>>> +     kvm_unload_vcpu_mmu(vcpu);
>>> +     kvm_arch_vcpu_free(vcpu);
>>> +     kvm_put_kvm(kvm);
>>>    }
>>
>> zap is really a good name for this?
>>
> zap = destroy, so I think it is OK.

Stronger than that.
My dictionary says "to destroy sth suddenly and with force."

In the case of shadow pages, I see what the author wanted to mean by "zap".

In your case, the host really destroy a VCPU suddenly?
The guest have to unplug it before, I guess.

If you just mean "destroy", why not use it?

>>> +#define kvm_for_each_vcpu(vcpu, kvm) \
>>> +     list_for_each_entry_rcu(vcpu,&kvm->vcpus, list)
>>
>> Is this macro really worth it?
>> _rcu shows readers important information, I think.
>>
> I guest kvm_for_each_vcpu is designed for hiding the details of
> internal implement, and currently it is implemented by array, and my
> patch will change it to linked-list,
> so IMO, we can still hide the details.

Then why are you doing
	list_add_rcu(&vcpu->list, &kvm->vcpus);
without introducing kvm_add_vcpu()?

You are just hiding part of the interface.
I believe this kind of incomplete abstraction should not be added.

The original code was complex enough to introduce a macro, but
list_for_each_entry_rcu(vcpu, &kvm->vcpus, list)
is simple and shows clear meaning by itself.

	Takuya
