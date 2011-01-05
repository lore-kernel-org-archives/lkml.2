Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab1AEEnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 23:43:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab1AEEnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 23:43:13 -0500
Message-ID: <4D23F6DE.7090505@redhat.com>
Date: Tue, 04 Jan 2011 18:43:10 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM Clock Synchronization 2/4] Keep TSC synchronized across
 host suspend
References: <1293601100-32109-1-git-send-email-zamsden@redhat.com> <1293601100-32109-3-git-send-email-zamsden@redhat.com> <20110104153652.GB31340@amt.cnet>
In-Reply-To: <20110104153652.GB31340@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 05:36 AM, Marcelo Tosatti wrote:
> On Tue, Dec 28, 2010 at 07:38:18PM -1000, Zachary Amsden wrote:
>    
>> During a host suspend, TSC may go backwards, which KVM interprets
>> as an unstable TSC.  Technically, KVM should not be marking the
>> TSC unstable, which causes the TSC clocksource to go bad, but
>> should be adjusting the TSC offsets in such a case.
>>
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |    1 +
>>   arch/x86/kvm/x86.c              |   66 +++++++++++++++++++++++++++++++++++---
>>   2 files changed, 61 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 9e6fe39..63a82b0 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -386,6 +386,7 @@ struct kvm_vcpu_arch {
>>   	u64 last_kernel_ns;
>>   	u64 last_tsc_nsec;
>>   	u64 last_tsc_write;
>> +	u64 tsc_offset_adjustment;
>>   	bool tsc_catchup;
>>
>>   	bool nmi_pending;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index b9118f4..b509c01 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2042,12 +2042,20 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>   	}
>>
>>   	kvm_x86_ops->vcpu_load(vcpu, cpu);
>> +
>> +	/* Apply any externally detected TSC adjustments (due to suspend) */
>> +	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
>> +		kvm_x86_ops->adjust_tsc_offset(vcpu,
>> +			vcpu->arch.tsc_offset_adjustment);
>> +		vcpu->arch.tsc_offset_adjustment = 0;
>> +		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>> +	}
>>   	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
>>   		/* Make sure TSC doesn't go backwards */
>>   		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>>   				native_read_tsc() - vcpu->arch.last_host_tsc;
>>   		if (tsc_delta<  0)
>> -			mark_tsc_unstable("KVM discovered backwards TSC");
>> +			WARN_ON(!check_tsc_unstable());
>>   		if (check_tsc_unstable()) {
>>   			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
>>   			vcpu->arch.tsc_catchup = 1;
>> @@ -5778,14 +5786,60 @@ int kvm_arch_hardware_enable(void *garbage)
>>   {
>>   	struct kvm *kvm;
>>   	struct kvm_vcpu *vcpu;
>> -	int i;
>> +	int i, ret;
>> +	u64 local_tsc;
>> +	u64 max_tsc = 0;
>> +	bool stable, backwards_tsc = false;
>>
>>   	kvm_shared_msr_cpu_online();
>> -	list_for_each_entry(kvm,&vm_list, vm_list)
>> -		kvm_for_each_vcpu(i, vcpu, kvm)
>> -			if (vcpu->cpu == smp_processor_id())
>> +	local_tsc = native_read_tsc();
>> +	stable = !check_tsc_unstable();
>> +	ret = kvm_x86_ops->hardware_enable(garbage);
>> +	if (ret)
>> +		return ret;
>> +
>> +	list_for_each_entry(kvm,&vm_list, vm_list) {
>> +		kvm_for_each_vcpu(i, vcpu, kvm) {
>> +			if (!stable&&  vcpu->cpu == smp_processor_id())
>>   				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>> -	return kvm_x86_ops->hardware_enable(garbage);
>> +			if (stable&&  vcpu->arch.last_host_tsc>  local_tsc) {
>> +				backwards_tsc = true;
>> +				if (vcpu->arch.last_host_tsc>  max_tsc)
>> +					max_tsc = vcpu->arch.last_host_tsc;
>> +			}
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Sometimes, reliable TSCs go backwards.  This happens
>> +	 * on platforms that reset TSC during suspend or hibernate
>> +	 * actions, but maintain synchronization.  We must compensate.
>> +	 * Unfortunately, we can't bring the TSCs fully up to date
>> +	 * with real time.  The reason is that we aren't yet far
>> +	 * enough into CPU bringup that we know how much real time
>> +	 * has actually elapsed; our helper function, get_kernel_ns()
>> +	 * will be using boot variables that haven't been updated yet.
>> +	 * We simply find the maximum observed TSC above, then record
>> +	 * the adjustment to TSC in each VCPU.  When the VCPU later
>> +	 * gets loaded, the adjustment will be applied.  Note that we
>> +	 * accumulate adjustments, in case multiple suspend cycles
>> +	 * happen before the VCPU gets a chance to run again.
>> +	 *
>> +	 * Note that unreliable TSCs will be compensated already by
>> +	 * the logic in vcpu_load, which sets the TSC to catchup mode.
>> +	 * This will catchup all VCPUs to real time, but cannot
>> +	 * guarantee synchronization.
>> +	 */
>> +	if (backwards_tsc) {
>> +		u64 delta_cyc = max_tsc - local_tsc;
>> +		list_for_each_entry(kvm,&vm_list, vm_list)
>> +			kvm_for_each_vcpu(i, vcpu, kvm) {
>> +				vcpu->arch.tsc_offset_adjustment += delta_cyc;
>> +				vcpu->arch.last_host_tsc = 0;
>> +			}
>> +	}
>> +
>> +	return 0;
>>   }
>>      
> Wouldnt it be simpler to use cyc2ns_offset (or something equivalent)? In
> any case, you forgot to compare smp_processor_id.
>    

I don't think so, as here, we're already dealing in units of cycles, and 
we don't want to just fix the kvmclock, we want to make sure the TSC 
also does not go backwards.

And we deliberately do not check smp_processor_id.  The reasoning is - 
if the TSC has gone backwards, but we have a stable TSC, it means all 
TSCs have gone backwards together, and so should all be adjusted 
equally.  Note that backwards_tsc is only set if TSC is marked as stable.

Zach
