Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab0FVIFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:05:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab0FVIFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:05:08 -0400
Message-ID: <4C206EA0.3060101@redhat.com>
Date: Tue, 22 Jun 2010 11:04:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH V2 3/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112703.2096.511.camel@ymzhang.sh.intel.com>	 <20100621135659.GL4689@redhat.com> <1277185636.2096.675.camel@ymzhang.sh.intel.com>
In-Reply-To: <1277185636.2096.675.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 08:47 AM, Zhang, Yanmin wrote:
> On Mon, 2010-06-21 at 16:56 +0300, Gleb Natapov wrote:
>    
>> On Mon, Jun 21, 2010 at 05:31:43PM +0800, Zhang, Yanmin wrote:
>>      
>>> The 3rd patch is to implement para virt perf at host kernel.
>>>
>>> Signed-off-by: Zhang Yanmin<yanmin_zhang@linux.intel.com>
>>>
>>>        
> <snip>
>
>    
>>> +
>>> +static void kvm_copy_event_to_guest(struct kvm_vcpu *vcpu,
>>> +			struct perf_event *host_event)
>>> +{
>>> +	struct host_perf_shadow *shadow = host_event->host_perf_shadow;
>>> +	struct guest_perf_event counter;
>>> +	int ret;
>>> +	s32 overflows;
>>> +
>>> +	ret = kvm_read_guest(vcpu->kvm, shadow->guest_event_addr,
>>> +				&counter, sizeof(counter));
>>> +	if (ret<  0)
>>> +		return;
>>> +
>>> +again:
>>> +	overflows = atomic_read(&shadow->counter.overflows);
>>> +	if (atomic_cmpxchg(&shadow->counter.overflows, overflows, 0) !=
>>> +			overflows)
>>> +		goto again;
>>> +
>>> +	counter.count = shadow->counter.count;
>>> +	atomic_add(overflows,&counter.overflows);
>>> +
>>> +	kvm_write_guest(vcpu->kvm,
>>> +			shadow->guest_event_addr,
>>> +			&counter,
>>> +			sizeof(counter));
>>>        
>> Those kind of interfaces worry me since the can cause bugs that are
>> very hard to catch.  What if guest enables some events and crashes into
>> kdump kernel (or kexec new kernel) without reseting HW. Now host may
>> write over guest memory without guest expecting it. Do you handle this
>> scenario in a guest side? I think you need to register reboot notify
>> and disable events from there.
>>      
> Sorry for missing your comments.
>
> My patch could take care of dead guest os by cleaning up all events in function
> kvm_arch_destroy_vm, so all events are closed if host user kills the guest
> qemu process.
>
>    

A reset does not involve destroying a vm; you have to clean up as part 
of the rest process.

Note MSRs are automatically cleared, so that's something in favour of an 
MSR interface.

> As for your scenario, I will register reboot notify and add a new pv perf
> hypercall interface to vmexit to host kernel to do cleanup.
>    

You aren't guaranteed a reboot notifier will be called.  On the other 
hand, we need a kexec handler.


-- 
error compiling committee.c: too many arguments to function

