Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab0FVI74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:59:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759041Ab0FVI7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:59:54 -0400
Message-ID: <4C207B7E.1060008@redhat.com>
Date: Tue, 22 Jun 2010 11:59:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
Subject: Re: [PATCH V2 1/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>	 <4C1F50D0.70205@redhat.com> <1277171344.2096.567.camel@ymzhang.sh.intel.com>
In-Reply-To: <1277171344.2096.567.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 04:49 AM, Zhang, Yanmin wrote:
>
>>> Is live migration necessary on pv perf support?
>>>
>>>        
>> Yes.
>>      
> Ok. With the PV perf interface, host perf saves all counter info into perf_event
> structure. To support live migration, we need save all host perf_event structure,
> or at least perf_event->count and perf_event->attr. Then, recreate the host perf_event
> after migration.
>    

Much better to save the guest structure (which is an ABI, and doesn't 
change between kernels).

> I check qemu-kvm codes and it seems most live migration is to save cpu states.
> So it seems it's hard for perf pv interface to match current live migration. Any suggestion?
>    

Make it part of the cpu state then.  If you encode the interface as 
MSRs, it comes for free (including migration of the counter values).  If 
not, save the parameters to OP_OPEN and enable/disable state, as well as 
the counters.

But using MSRs will be much more natural.  Almost by definition they 
encode state, instead of hypercalls, which work to maintain state which 
isn't clearly specified.

>>>
>>>        
>> What about documentation for individual fields?  Esp. type, config, and
>> flags, but also the others.
>>      
> They are really perf implementation specific. Even perf_event definition
> has no document but code comments. I will add simple explanation around
> the new structure definition.
>    

Ok.  Please drop anything we don't support and document what we do.  
Note that if the perf implementation changes, we will need to convert 
between the kvm ABI and the new implementation.

>>> +guest_perf_event->count saves the latest count of the event.
>>> +guest_perf_event->overflows means how many times this event has overflowed
>>> +since guest os processes it. Host kernel just inc guest_perf_event->overflows
>>> +when the event overflows. Guest kernel should use a atomic_cmpxchg to reset
>>> +guest_perf_event->overflows to 0 in case there is a race between its reset by
>>> +guest os and host kernel data update.
>>>
>>>        
>> Is overflows really needed?
>>      
> Theoretically, we can remove it. But it could simplify the implementations and touch
> perf generic codes as small as we can.
>    

Since real hardware doesn't provide overflows, guest software is 
prepared to handle it.  So if removing it simplifies the host, it's an 
improvement.

>>    Since the guest can use NMI to read the
>> counter, it should have the highest possible priority, and thus it
>> shouldn't see any overflow unless it configured the threshold really low.
>>
>> If we drop overflow, we can use the RDPMC instruction instead of
>> KVM_PERF_OP_READ.  This allows the guest to allow userspace to read a
>> counter, or prevent userspace from reading the counter, by setting cr4.pce.
>>      
> 1) para virt perf interface is to hide PMU hardware in host os. Guest os shouldn't
> access PMU hardware directly. We could expose PMU hardware to guest os directly, but
> that would be another guest os PMU support method. It shouldn't be a part of para virt
> interface.
>    

RDPMC will be trapped by the host, so it won't access the real PMU.  
It's a convenient shorthand for 'read a counter designated by this index'.

(similarly, without EPT 'mov cr3' doesn't affect the real cr3 but only 
the virtual cr3).

> 2) Consider below scenario: PMU counter overflows and NMI causes guest os vmexit to
> host kernel. Host kernel schedules the vcpu thread to another physical cpu before
> vmenter the guest os again. So later on, guest os just RDPMC the counter on another
> cpu.
>    

Again, RDPMC will access the paravirt counter, not the hardware counter.

> So I think above discussion is around how to expose PMU hardware to guest os. I will
> also check this method after the para virt interface is done.
>
>    
>>      
>>> +Host kernel saves count and overflow update information into guest_perf_event
>>> +pointed by guest_perf_event_param->guest_event_addr.
>>> +
>>> +After host kernel creates the event, this event is at disabled mode.
>>> +
>>> +This hypercall3 return 0 when host kernel creates the event successfully. Or
>>> +other value if it fails.
>>> +
>>> +3) Enable event at host side:
>>> +kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_ENABLE, id);
>>> +
>>> +Parameter id means the event id allocated by guest os. Guest os need call this
>>> +hypercall to enable the event at host side. Then, host side will really start
>>> +to collect statistics by this event.
>>> +
>>> +This hypercall3 return 0 if host kernel succeds. Or other value if it fails.
>>> +
>>> +
>>> +4) Disable event at host side:
>>> +kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_DISABLE, id);
>>> +
>>> +Parameter id means the event id allocated by guest os. Guest os need call this
>>> +hypercall to disable the event at host side. Then, host side will stop
>>> +statistics collection initiated by the event.
>>> +
>>> +This hypercall3 return 0 if host kernel succeds. Or other value if it fails.
>>> +
>>> +
>>> +5) Close event at host side:
>>> +kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_CLOSE, id);
>>> +it will close and delete the event at host side.
>>>
>>>        
>> What about using MSRs to configure the counter like real hardware?  That
>> takes care of live migration, since we already migrate MSRs.  At the end
>> of the migration userspace will read all config and counter data from
>> the source and transfer it to the destination.  This should work with
>> existing userspace since we query the MSR index list from the host.
>>      
> Yes, but it will belong to the method that exposes PMU hardware to guest os directly.
>    

I'm suggesting to use virtual MSRs defined by you.  Those MSRs will 
encode the guest_perf_attr structure.  Since we already copy MSRs on 
live migration, we will have live migration support, and reset will also 
work.  Look at kvmclock for an example of a virtual MSR.

-- 

error compiling committee.c: too many arguments to function

