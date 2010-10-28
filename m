Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0J1JO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 05:14:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab0J1JOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 05:14:55 -0400
Date: Thu, 28 Oct 2010 11:14:50 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/8] KVM: make async_pf work queue lockless
Message-ID: <20101028091450.GT26191@redhat.com>
References: <4CC7EA7D.5020901@cn.fujitsu.com>
 <4CC7EC55.7070201@cn.fujitsu.com>
 <20101027114114.GR26191@redhat.com>
 <4CC93DAA.2070406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC93DAA.2070406@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 05:08:58PM +0800, Xiao Guangrong wrote:
> On 10/27/2010 07:41 PM, Gleb Natapov wrote:
> > On Wed, Oct 27, 2010 at 05:09:41PM +0800, Xiao Guangrong wrote:
> >> The async_pf number is very few since only pending interrupt can
> >> let it re-enter to the guest mode.
> >>
> >> During my test(Host 4 CPU + 4G, Guest 4 VCPU + 6G), it's no
> >> more than 10 requests in the system.
> >>
> >> So, we can only increase the completion counter in the work queue
> >> context, and walk vcpu->async_pf.queue list to get all completed
> >> async_pf
> >>
> > That depends on the load. I used memory cgroups to create very big
> > memory pressure and I saw hundreds of apfs per second. We shouldn't
> > optimize for very low numbers. With vcpu->async_pf.queue having more
> > then one element I am not sure your patch is beneficial.
> > 
> 
> Maybe we need a new no-lock way to record the complete apfs, i'll reproduce
> your test environment and improve it.
> 
That is always welcomed :)

> >> +
> >> +		list_del(&work->queue);
> >> +		vcpu->async_pf.queued--;
> >> +		kmem_cache_free(async_pf_cache, work);
> >> +		if (atomic_dec_and_test(&vcpu->async_pf.done))
> >> +			break;
> > You should do atomic_dec() and always break. We cannot inject two apfs during
> > one vcpu entry.
> > 
> 
> Sorry, i'm little confused. 
> 
> Why 'atomic_dec_and_test(&vcpu->async_pf.done)' always break? async_pf.done is used to
In your code it is not, but it should (at least if guest is PV, read
below).

> record the complete apfs and many apfs may be completed when vcpu enters guest mode(it
> means vcpu->async_pf.done > 1)
> 
Correct, but only one apf should be handled on each vcpu entry in case
of PV guest. Look at kvm_arch_async_page_present(vcpu, work); that is called
in a loop in your code. If vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED
is not null it injects exception into the guest. You can't inject more
then one exception on each guest entry. If guest is not PV you are
correct that we can loop here until vcpu->async_pf.done == 0.

> Look at the current code:
> 
> void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
> {
> 	......
> 	spin_lock(&vcpu->async_pf.lock);
> 	work = list_first_entry(&vcpu->async_pf.done, typeof(*work), link);
> 	list_del(&work->link);
> 	spin_unlock(&vcpu->async_pf.lock);
> 	......
> }
> 
> You only handle one complete apf, why we inject them at once? I missed something? :-(

--
			Gleb.
