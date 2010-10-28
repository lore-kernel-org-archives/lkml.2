Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0J1JEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 05:04:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57086 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab0J1JEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 05:04:36 -0400
Message-ID: <4CC93DAA.2070406@cn.fujitsu.com>
Date: Thu, 28 Oct 2010 17:08:58 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/8] KVM: make async_pf work queue lockless
References: <4CC7EA7D.5020901@cn.fujitsu.com> <4CC7EC55.7070201@cn.fujitsu.com> <20101027114114.GR26191@redhat.com>
In-Reply-To: <20101027114114.GR26191@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 07:41 PM, Gleb Natapov wrote:
> On Wed, Oct 27, 2010 at 05:09:41PM +0800, Xiao Guangrong wrote:
>> The async_pf number is very few since only pending interrupt can
>> let it re-enter to the guest mode.
>>
>> During my test(Host 4 CPU + 4G, Guest 4 VCPU + 6G), it's no
>> more than 10 requests in the system.
>>
>> So, we can only increase the completion counter in the work queue
>> context, and walk vcpu->async_pf.queue list to get all completed
>> async_pf
>>
> That depends on the load. I used memory cgroups to create very big
> memory pressure and I saw hundreds of apfs per second. We shouldn't
> optimize for very low numbers. With vcpu->async_pf.queue having more
> then one element I am not sure your patch is beneficial.
> 

Maybe we need a new no-lock way to record the complete apfs, i'll reproduce
your test environment and improve it.

>> +
>> +		list_del(&work->queue);
>> +		vcpu->async_pf.queued--;
>> +		kmem_cache_free(async_pf_cache, work);
>> +		if (atomic_dec_and_test(&vcpu->async_pf.done))
>> +			break;
> You should do atomic_dec() and always break. We cannot inject two apfs during
> one vcpu entry.
> 

Sorry, i'm little confused. 

Why 'atomic_dec_and_test(&vcpu->async_pf.done)' always break? async_pf.done is used to
record the complete apfs and many apfs may be completed when vcpu enters guest mode(it
means vcpu->async_pf.done > 1)

Look at the current code:

void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
{
	......
	spin_lock(&vcpu->async_pf.lock);
	work = list_first_entry(&vcpu->async_pf.done, typeof(*work), link);
	list_del(&work->link);
	spin_unlock(&vcpu->async_pf.lock);
	......
}

You only handle one complete apf, why we inject them at once? I missed something? :-(

