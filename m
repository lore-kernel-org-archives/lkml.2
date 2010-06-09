Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab0FIJmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:42:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab0FIJmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:42:01 -0400
Message-ID: <4C0F61D3.9000402@redhat.com>
Date: Wed, 09 Jun 2010 12:41:39 +0300
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
       tim.c.chen@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] para virt interface of perf to support kvm guest os statistics
 collection in guest os
References: <1276054214.2096.383.camel@ymzhang.sh.intel.com>	 <4C0F51DD.3080200@redhat.com> <1276075280.2096.427.camel@ymzhang.sh.intel.com>
In-Reply-To: <1276075280.2096.427.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 12:21 PM, Zhang, Yanmin wrote:
>
>> One thing that's missing is documentation of the guest/host ABI.  It
>> will be a requirement for inclusion, but it will also be a great help
>> for review, so please provide it ASAP.
>>      
> I will add such document. It will includes:
> 1) Data struct perf_event definition. Guest os and host os have to share the same
> data structure as host kernel will sync data (counte/overflows and others if needed)
> changes back to guest os.
> 2) A list of all hypercalls
> 3) Guest need have NMI handler which checks all guest events.
>    

Thanks.  It may be easier to have just the documentation for the first 
few iterations so we can converge on a good interface, then update the 
code to match the interface.

>> Disabling the watchdog is unfortunate.  Why is it necessary?
>>      
> perf always uses NMI, so we disable the nmi_watchdog when a perf_event is
> set up in case they might have impact.
>    

Ok.  Is that the case for the hardware pmus as well?  If so it might be 
done in common code.

>>> +
>>> +static int kvm_pmu_enable(struct perf_event *event)
>>> +{
>>> +	int ret;
>>> +	unsigned long addr = __pa(event);
>>> +
>>> +	if (kvm_add_event(event))
>>> +		return -1;
>>> +
>>> +	ret = kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_ENABLE,
>>> +	 		addr, (unsigned long) event->shadow);
>>>
>>>        
>> This is suspicious.  Passing virtual addresses to the host is always
>> problematic.  Or event->shadow only used as an opaque cookie?
>>      
> I use perf_event->shadow at both host and guest side.
> 1) At host side, perf_event->shadow points to an area including the page
> mapping information about guest perf_event. Host kernel uses it to sync data
> changes back to guest;
> 2) At guest side, perf_event->shadow save the virtual address of host
> perf_event at host side. At guest side,
> kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_OPEN, ...) return the virtual address.
> Guest os shouldn't use it but using it to pass it back to host kernel in following
> hypercalls. It might be a security issue for host kernel. Originally, I planed guest
> os not to use perf_event->shadow. Host kernel maintains a per-vcpu event-related
> list whose key is addr of guest perf_event. But considering the vcpu thread migration
> on logical cpu, such list needs lock and implementation becomes a little complicated.
>
> I will double-check the list method as the security issue is there.
>    

Besides the other concern, you cannot live migrate a host virtual 
address, since it changes from host to host.  It's better to use a 
guest-chosen bounded small integer.

>> Need to detect the kvm pmu via its own cpuid bit.
>>      
> Ok. I will add a feature, KVM_FEATURE_PARA_PERF, something like
> bit KVM_FEATURE_CLOCKSOURCE.
>    

Don't forget Documentation/kvm/cpuid.txt.
>> Ok, so event->shadow is never dereferenced.  In that case better not
>> make it a pointer at all, keep it unsigned long.
>>      
> Host kernel also uses it.
>    

I see.  So put it in a union.  Or perhaps not even in a union - what if 
a kvm guest is also acting as a kvm host?


>    
>>      
>>> +
>>> +static void kvm_sync_event_to_guest(struct perf_event *event, int overflows)
>>> +{
>>> +	struct hw_perf_event *hwc =&event->hw;
>>> +	struct kvmperf_event *kvmevent;
>>> +	int offset, len, data_len, copied, page_offset;
>>> +	struct page *event_page;
>>> +	void *shared_kaddr;
>>> +
>>> +	kvmevent = event->shadow;
>>> +	offset = kvmevent->event_offset;
>>> +
>>> +	/* Copy perf_event->count firstly */
>>> +	offset += offsetof(struct perf_event, count);
>>> +	if (offset<   PAGE_SIZE) {
>>> +		event_page = kvmevent->event_page;
>>> +		page_offset = offset;
>>> +	} else {
>>> +		event_page = kvmevent->event_page2;
>>> +		page_offset = offset - PAGE_SIZE;
>>> +	}
>>> +	shared_kaddr = kmap_atomic(event_page, KM_USER0);
>>> +	*((atomic64_t *)(shared_kaddr + page_offset)) = event->count;
>>>
>>>        
>> This copy will not be atomic on 32-bit hosts.
>>      
> Right. But it shouldn't be a problem as vcpu thread stops when vmexit to
> host to process events. In addition, only current cpu in guest accesses
> perf_events linked to current cpu.
>    

Ok.  These restrictions should be documented.

>>      
>>> +}
>>> +
>>>
>>> +static struct perf_event *
>>> +kvm_pv_perf_op_open(struct kvm_vcpu *vcpu, gpa_t addr)
>>> +{
>>> +	int ret;
>>> +	struct perf_event *event;
>>> +	struct perf_event *host_event = NULL;
>>> +	struct kvmperf_event *shadow = NULL;
>>> +
>>> +	event = kzalloc(sizeof(*event), GFP_KERNEL);
>>> +	if (!event)
>>> +		goto out;
>>> +
>>> +	shadow = kzalloc(sizeof(*shadow), GFP_KERNEL);
>>> +	if (!shadow)
>>> +		goto out;
>>> +
>>> +	shadow->event_page = gfn_to_page(vcpu->kvm, addr>>   PAGE_SHIFT);
>>> +	shadow->event_offset = addr&   ~PAGE_MASK;
>>>
>>>        
>> Might truncate on 32-bit hosts.  PAGE_MASK is 32-bit while addr is 64 bit.
>>      
> Above codes just run at host side. Is it possible that host kernel is 32 bit and
> guest kernel is 64bits?

No, guest bitness always <= host bitness.  But gpa_t is 64-bit even on 
32-bit host/guest, so you can't use PAGE_MASK on that.

>>> +
>>> +	ret = kvm_read_guest(vcpu->kvm, addr, event, sizeof(*event));
>>> +	if (ret)
>>> +		goto out;
>>>
>>>        
>> I assume this is to check existence?
>>      
> Here calling kvm_read_guest is to get a copy of guest perf_event as it has
> perf_event.attr. Host need the attr to create host perf_event.
>
>    
>>    It doesn't work well with memory
>> hotplug.  In general it's preferred to use
>> kvm_read_guest()/kvm_write_guest() instead of gfn_to_page() during
>> initialization to prevent pinning and allow for hotplug.
>>      
> That's an issue. But host kernel couldn't go to sleep when processing event
> overflows under NMI context.
>    

You can set a bit in vcpu->requests and schedule the copying there.  
vcpu->requests is always checked before guest entry.


>
>> It may be better to have the guest create an id to the host, and the
>> host can simply look up the id in a table:
>>      
> Perhaps the address of guest perf_event is the best id.
>    

That will need to be looked up in a hash table.  A small id is best 
because it can be easily looked up by both guest and host.


-- 
error compiling committee.c: too many arguments to function

