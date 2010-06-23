Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab0FWFwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 01:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab0FWFwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 01:52:37 -0400
Message-ID: <4C21A0FB.7030509@redhat.com>
Date: Wed, 23 Jun 2010 08:51:55 +0300
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
       tim.c.chen@intel.com, Alexander Graf <agraf@suse.de>,
       Carsten Otte <carsteno@de.ibm.com>,
       "Zhang, Xiantao" <xiantao.zhang@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH V2 3/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112703.2096.511.camel@ymzhang.sh.intel.com>	 <4C1F5C21.7070902@redhat.com>	 <1277176333.2096.650.camel@ymzhang.sh.intel.com>	 <4C207475.9010006@redhat.com> <1277262774.2096.838.camel@ymzhang.sh.intel.com>
In-Reply-To: <1277262774.2096.838.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 06:12 AM, Zhang, Yanmin wrote:
>>>
>>> This design is to deal with a task context perf collection in guest os.
>>> Scenario 1:
>>> 1) guest os starts to collect statistics of process A on vcpu 0;
>>> 2) process A is scheduled to vcpu 1. Then, the perf_event at host side need
>>> to be moved to VCPU 1 's thread. With the per KVM instance design, we needn't
>>> move host_perf_shadow among vcpus.
>>>
>>>        
>> First, the guest already knows how to deal with per-cpu performance
>> monitors, since that's how most (all) hardware works.  So we aren't
>> making the guest more complex, and on the other hand we simplify the host.
>>      
> I agree that we need keep things simple.
>
>    
>> Second, if process A is migrated, and the guest uses per-process
>> counters, the guest will need to stop/start the counter during the
>> migration.  This will cause the host to migrate the counter,
>>      
> Agree. My patches do so.
>
> Question: Where does host migrate the counter?
> The perf event at host side is bound to specific vcpu thread.
>    

If the perf event is bound to the vm, not a vcpu, then on guest process 
migration you will have to disable it on one vcpu and enable it on the 
other, no?


>>   so while we
>> didn't move the counter to a different vcpu,
>>      
> Disagree here. If process A on vcpu 0 in guest os is migrated to vcpu 1,
> host has to move process A's perf_event to vcpu 1 thread.
>    

Sorry, I'm confused now (lost track of our example).  But whatever we 
do, if a guest process is migrated, the host will have to migrate the 
perf event, yes?

>
>    
>>   we still have to move it to
>> a different cpu.
>>
>>      
>>> Scenario 2:
>>> 1) guest os creates a perf_event at host side on vcpu 0;
>>> 2) malicious guest os calls close to delete the host perf_event on vcpu 1, but
>>> enables the perf_event on vcpu0 at the same time. When close thread runs to get the
>>> host_perf_shadow from the list, enable thread also gets it. Then, close thread
>>> deletes the perf_event, and enable thread will cause host kernel panic when using
>>> host_perf_shadow.
>>>
>>>        
>> With per-vcpu events, this can't happen.  Each vcpu has its own set of
>> perf events in their own ID namespace.  vcpu 0 can't touch vcpu 1's
>> events even if it knows their IDs.
>>      
> What does 'touch' mean here?
>    

Read or write using hypercalls.

> With the task (process) context event in guest os, we have to migrate the event
> among vcpus when guest process scheduler balances processes among vcpus. So all
> events in a guest os instance uses the same ID name space.
>    

On real hardware a process running on cpu 0 might use counter X but 
after migrating to cpu 1 it might use counter Y.

So the same perf_event object can be mapped to different hardware 
resources depending on which cpu it is running on and on time (due to 
changing resource requirements).

Same thing with guest processes.  A process starts at vcpu 0 using 
counter X, migrates to vcpu 1 using counter Y.

> What you mentioned is really right when the event is cpu context event, but
> not with task context event.
>    

Real hardware supports only per-cpu events, and perf implements 
per-process events on top of that.  We could do the same with virtual 
hardware.




>>> We use a mutex_trylock in NMI hanlder. If it can't get the lock, there is a NMI miss
>>> happening, but host kernel still updates perf_event->host_perf_shadow.counter, so the
>>> overflow data will be accumulated.
>>>
>>>        
>> I see.  I don't think this is needed if we disable the counters during
>> guest->host switch,
>>      
> We don't disable counters during guest->host switch. Generic perf codes will
> disable it when:
> 1) host kernel process scheduler schedules the task out if the event is a task
> context event.
> 2) guest os calls DISABLE hypercall.
>    

I think we should.  Otherwise we will measure kvm host code and 
unrelated host interrupt handlers.

>>   we can just copy the data and set a bit in
>> vcpu->requests so that we can update the guest during next entry.
>>      
> We can use a bit of vcpu->requests, but it has no far difference from a simple
> checking (vcpu->arch.overflows == 0) in function kvm_sync_events_to_guest.
>
> The key is how to save pending perf_event pointers, so kvm could update
> their data to guest. vcpu->arch.overflow_events does so.
>    

Ok.

>>    The guest NMI handlers and callbacks are all
>>      
>>>> serialized by the guest itself.
>>>>          
> In guest NMI and callbacks are serialized on a specific perf event, but perf_close
> isn't. perf generic codes have good consideration on it. Under guest/host environment,
> we need new lock to coordinate it.
>
> In addition, pls. consider a malicious guest os who might doesn't serialize
> the operations to try to cause host kernel panic.
>    

The guest NMI handler is the guest's problem.  But yes, the host NMI 
handler can race with close.


>>>>
>>>>          
>>> This is to fight with malicious guest os kernel. Just like what I mention above,
>>> the race might happen when:
>>> 1) NMI handler accesses it;
>>> 2) vmx_handle_exit codes access overflow_events to sync data to guest os;
>>> 3) Another vcpu thread of the same guest os calls close to delete the perf_event;
>>>
>>>        
>> This goes away with per-vcpu events.
>>      
> Again, per-vcpu event couldn't work well with task context event in guest.
>
>    

I don't understand why.  Real hardware has per-cpu events.

>>>>>     struct kvm_arch {
>>>>>     	struct kvm_mem_aliases *aliases;
>>>>>
>>>>> @@ -415,6 +431,15 @@ struct kvm_arch {
>>>>>     	/* fields used by HYPER-V emulation */
>>>>>     	u64 hv_guest_os_id;
>>>>>     	u64 hv_hypercall;
>>>>> +
>>>>> +	/*
>>>>> +	 * fields used by PARAVIRT perf interface:
>>>>> +	 * Used to organize all host perf_events representing guest
>>>>> +	 * perf_event on a specific kvm instance
>>>>> +	 */
>>>>> +	atomic_t kvm_pv_event_num;
>>>>> +	spinlock_t shadow_lock;
>>>>> +	struct list_head *shadow_hash_table;
>>>>>
>>>>>
>>>>>            
>>>> Need to be per-vcpu.  Also wrap in a kvm_vcpu_perf structure, the names
>>>> are very generic.
>>>>          
> If we move it to per-vcpu, host kernel need move the entry (struct host_perf_shadow)
> among vcpu when an event be migrated to another vcpu. That causes codes a little complicated
> and might introduce something like deadlock or new race.

Any complication will be in guest code, not host code, and the guest is 
already prepared for it.

>   With my implementation, there is
> only one potential performance issue as there are some lock contention on shadow_lock.
> But the performance issue is not severe, because:
> 1) guest os doesn't support too many vcpu (usually no larger than 8);
>    

We support 64 now, and might increase it.  Please don't introduce new 
barriers to scalability.

>>> This limitation is different from hardware PMU counter imitation. When any application or
>>> guest os vcpu thread creates perf_event, host kernel has no limitation. Kernel just arranges
>>> all perf_event in a list (not considering group case) and schedules them to PMU hardware
>>> by a round-robin method.
>>>
>>>        
>> In practice, it will take such a long time to cycle through all events
>> that measurement quality will deteriorate.
>>      
> There are 2 things.
> 1) We provide a good capability to support applications to submit more events;
> 2) Application just use a small group of event, typically one cpu context event per vcpu.
>
> They are very different. As usual case about 2), the measurement quality wouldn't
> deteriorate.
>    

In the untypical case, quality will deteriorate and the guest will have 
no way of knowing it.

If the number of events is restricted, the guest has to multiplex itself 
so it knows quality deteriorates and can do something about it.

>>    I prefer exposing a much
>> smaller number of events so that multiplexing on the host side will be
>> rare (for example, if both guest and host are monitoring at the same
>> time, or to accomodate hardware constraints).  If the guest needs 1024
>> events, it can schedule them itself (and then it knows the measurement
>> is very inaccurate due to sampling)
>>      
> Guest os of linux does schedule them. By default, guest kernel enables
> X86_PMC_IDX_MAX (64) events on a specific vpcu at the same time. See
> function kvm_pmu_enable and kvm_add_event.
>
> Exposing is different from disable/enable. If we expose/hide events when
> enable/disable events, it consumes too much cpu resources as host kernel need to
> create/delete the events frequently.
>
> 1024 is just the upper limitations that host could _create_ perf_event for
> the guest os instance. If guest os is linux, most active events in host
> for this guest os is VCPU_NUM*64.
>    

I see.  So you create events in the host but restrict the number active 
at the same time.  This should work.

64 is way to much for a single vcpu but this can be tuned.

>>> As host kernel saves/accumulate data in perf_event->host_perf_shadow.counter,
>>> it doesn't matter to have one failure. next time when overflowing again, it will
>>> copy all data back to guest os.
>>>
>>>        
>> Next time we may fail too.  And next time as well.
>>      
> How to process the failure? Kill the guest os? :)
>    

Good question...

Failure can come from memory hotunplug of the perf region, anything else?

If that's the only cause we can kill the guest or raise an MCE.

>>>>
>>>>          
>>> It doesn't matter. There is only one potential race between host kernel and
>>> guest kernel. When guest vmexits to host, it wouldn't access data pointed by
>>> shadow->guest_event_addr. Above kvm_write_guest happens with the same vpcu.
>>> So we just need make sure guest os vcpu accesses guest_perf_shadow->counter.overflows
>>> atomically.
>>>
>>>        
>> Well, without per-vcpu events, you can't guarantee this.
>>
>> With per-vcpu events, I agree.
>>      
> Frankly, I used per-vcpu in the beginning, but move to per-kvm after checking
> every possible race issues.
>    

Okay.  I'll need to think about it.  I have a strong preference to 
per-vcpu since it is a lot simpler in the host, similar to real 
hardware, and inherently scalable.  So I need a lot of convincing to 
move to per-vm.

>> 1) IIUC exclude_user and exclude_kernel should just work.  They work by
>> counting only when the cpl matches, yes?  The hardware cpl is available
>> and valid in the guest.
>>      
> Good pointer! Let me do some experiments to make sure it does work.
>
>    

Note, that only works correctly, if we disable the counters on 
guest->host switch, otherwise we count hypervisor code as cpl 0.

>> 2) We should atomically enable/disable the hardware performance counter
>> during guest entry/exit, like during ordinary context switch, so that
>> the guest doesn't measure host code (for example, ip would be
>> meaningless).
>>      
> I once checked it. At least under the vcpu thread context after vmexit, host
> code execution is for the guest. It's reasonable to count this part. If the
> vcpu thread is scheduled out, host kernel disables all events binding to this vcpu
> thread. ip is meaningless if NMI happens in host code path, but host kernel would
> accumulate the overflow count into host_perf_shadow->counter.overflows. Next time
> when NMI happens in guest os, host kernel inject NMI guest kernel, so guest uses
> that pt_regs->ip.
>    

For a cycle counter it might make sense (guest sees it spends time in 
sensitive instructions that are trapped), but what about things like 
DTLB misses or cache references?  It will see large counters for these 
instructions but no way to improve them.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

