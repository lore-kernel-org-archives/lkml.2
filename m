Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab0FQUbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:31:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508Ab0FQUbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:31:01 -0400
Message-ID: <4C1A8600.9010101@redhat.com>
Date: Thu, 17 Jun 2010 10:30:56 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] Unify vendor TSC logic
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-4-git-send-email-zamsden@redhat.com> <4C1886E2.2060509@redhat.com> <4C191B0C.9010504@redhat.com> <4C19D9BB.5030407@redhat.com>
In-Reply-To: <4C19D9BB.5030407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 10:15 PM, Jason Wang wrote:
> Zachary Amsden wrote:
>    
>> On 06/15/2010 10:10 PM, Jason Wang wrote:
>>
>>      
>>> Zachary Amsden wrote:
>>>
>>>
>>>        
>>>> Move the TSC control logic from the vendor backends into x86.c
>>>> by adding adjust_tsc_offset to x86 ops.  Now all TSC decisions
>>>> can be done in one place.
>>>>
>>>> Also, rename some variable in the VCPU structure to more accurately
>>>> reflect their actual content.
>>>>
>>>> VMX backend would record last observed TSC very late (possibly in an
>>>> IPI to clear the VMCS from a remote CPU), now it is done earlier.
>>>>
>>>> Note this is still not yet perfect.  We adjust TSC in both
>>>> directions when the TSC is unstable, resulting in desynchronized
>>>> TSCs for SMP guests.  A better choice would be to compensate based
>>>> on a master reference clock.
>>>>
>>>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>>> ---
>>>>    arch/x86/include/asm/kvm_host.h |    5 +++--
>>>>    arch/x86/kvm/svm.c              |   25 +++++++++++--------------
>>>>    arch/x86/kvm/vmx.c              |   20 ++++++++------------
>>>>    arch/x86/kvm/x86.c              |   16 +++++++++++-----
>>>>    4 files changed, 33 insertions(+), 33 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>> index 91631b8..94f6ce8 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -253,7 +253,6 @@ struct kvm_mmu {
>>>>    };
>>>>
>>>>    struct kvm_vcpu_arch {
>>>> -	u64 host_tsc;
>>>>    	/*
>>>>    	 * rip and regs accesses must go through
>>>>    	 * kvm_{register,rip}_{read,write} functions.
>>>> @@ -334,9 +333,10 @@ struct kvm_vcpu_arch {
>>>>
>>>>    	gpa_t time;
>>>>    	struct pvclock_vcpu_time_info hv_clock;
>>>> -	unsigned int hv_clock_tsc_khz;
>>>> +	unsigned int hw_tsc_khz;
>>>>    	unsigned int time_offset;
>>>>    	struct page *time_page;
>>>> +	u64 last_host_tsc;
>>>>
>>>>    	bool nmi_pending;
>>>>    	bool nmi_injected;
>>>> @@ -530,6 +530,7 @@ struct kvm_x86_ops {
>>>>    	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>>>>    	int (*get_lpage_level)(void);
>>>>    	bool (*rdtscp_supported)(void);
>>>> +	void (*adjust_tsc_offset)(struct kvm_vcpu *vcpu, s64 adjustment);
>>>>
>>>>    	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
>>>>
>>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>>> index 09b2145..ee2cf30 100644
>>>> --- a/arch/x86/kvm/svm.c
>>>> +++ b/arch/x86/kvm/svm.c
>>>> @@ -948,18 +948,6 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>>>    	int i;
>>>>
>>>>    	if (unlikely(cpu != vcpu->cpu)) {
>>>> -		u64 delta;
>>>> -
>>>> -		if (check_tsc_unstable()) {
>>>> -			/*
>>>> -			 * Make sure that the guest sees a monotonically
>>>> -			 * increasing TSC.
>>>> -			 */
>>>> -			delta = vcpu->arch.host_tsc - native_read_tsc();
>>>> -			svm->vmcb->control.tsc_offset += delta;
>>>> -			if (is_nested(svm))
>>>> -				svm->nested.hsave->control.tsc_offset += delta;
>>>> -		}
>>>>    		svm->asid_generation = 0;
>>>>    	}
>>>>
>>>> @@ -975,8 +963,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
>>>>    	++vcpu->stat.host_state_reload;
>>>>    	for (i = 0; i<   NR_HOST_SAVE_USER_MSRS; i++)
>>>>    		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
>>>> -
>>>> -	vcpu->arch.host_tsc = native_read_tsc();
>>>>    }
>>>>
>>>>    static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
>>>> @@ -3422,6 +3408,15 @@ static bool svm_rdtscp_supported(void)
>>>>    	return false;
>>>>    }
>>>>
>>>> +static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
>>>> +{
>>>> +	struct vcpu_svm *svm = to_svm(vcpu);
>>>> +
>>>> +	svm->vmcb->control.tsc_offset += adjustment;
>>>> +	if (is_nested(svm))
>>>> +		svm->nested.hsave->control.tsc_offset += adjustment;
>>>> +}
>>>> +
>>>>    static void svm_fpu_deactivate(struct kvm_vcpu *vcpu)
>>>>    {
>>>>    	struct vcpu_svm *svm = to_svm(vcpu);
>>>> @@ -3506,6 +3501,8 @@ static struct kvm_x86_ops svm_x86_ops = {
>>>>    	.rdtscp_supported = svm_rdtscp_supported,
>>>>
>>>>    	.set_supported_cpuid = svm_set_supported_cpuid,
>>>> +
>>>> +	.adjust_tsc_offset = svm_adjust_tsc_offset,
>>>>    };
>>>>
>>>>    static int __init svm_init(void)
>>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>>>> index a657e08..a993e67 100644
>>>> --- a/arch/x86/kvm/vmx.c
>>>> +++ b/arch/x86/kvm/vmx.c
>>>> @@ -498,7 +498,6 @@ static void __vcpu_clear(void *arg)
>>>>    		vmcs_clear(vmx->vmcs);
>>>>    	if (per_cpu(current_vmcs, cpu) == vmx->vmcs)
>>>>    		per_cpu(current_vmcs, cpu) = NULL;
>>>> -	rdtscll(vmx->vcpu.arch.host_tsc);
>>>>    	list_del(&vmx->local_vcpus_link);
>>>>    	vmx->vcpu.cpu = -1;
>>>>    	vmx->launched = 0;
>>>> @@ -881,7 +880,6 @@ static void vmx_load_host_state(struct vcpu_vmx *vmx)
>>>>    static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>>>    {
>>>>    	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>>> -	u64 tsc_this, delta, new_offset;
>>>>    	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
>>>>
>>>>    	if (!vmm_exclusive)
>>>> @@ -914,16 +912,6 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>>>
>>>>    		rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
>>>>    		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
>>>> -
>>>> -		/*
>>>> -		 * Make sure the time stamp counter is monotonous.
>>>> -		 */
>>>> -		rdtscll(tsc_this);
>>>> -		if (tsc_this<   vcpu->arch.host_tsc) {
>>>> -			delta = vcpu->arch.host_tsc - tsc_this;
>>>> -			new_offset = vmcs_read64(TSC_OFFSET) + delta;
>>>> -			vmcs_write64(TSC_OFFSET, new_offset);
>>>> -		}
>>>>    	}
>>>>    }
>>>>
>>>> @@ -1153,6 +1141,12 @@ static void guest_write_tsc(u64 guest_tsc, u64 host_tsc)
>>>>    	vmcs_write64(TSC_OFFSET, guest_tsc - host_tsc);
>>>>    }
>>>>
>>>> +static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
>>>> +{
>>>> +	u64 offset = vmcs_read64(TSC_OFFSET);
>>>> +	vmcs_write64(TSC_OFFSET, offset + adjustment);
>>>> +}
>>>> +
>>>>    /*
>>>>     * Reads an msr value (of 'msr_index') into 'pdata'.
>>>>     * Returns 0 on success, non-0 otherwise.
>>>> @@ -4340,6 +4334,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
>>>>    	.rdtscp_supported = vmx_rdtscp_supported,
>>>>
>>>>    	.set_supported_cpuid = vmx_set_supported_cpuid,
>>>> +
>>>> +	.adjust_tsc_offset = vmx_adjust_tsc_offset,
>>>>    };
>>>>
>>>>    static int __init vmx_init(void)
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index 0a102d3..c8289d0 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -929,9 +929,9 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
>>>>    		return 1;
>>>>    	}
>>>>
>>>> -	if (unlikely(vcpu->hv_clock_tsc_khz != this_tsc_khz)) {
>>>> +	if (unlikely(vcpu->hw_tsc_khz != this_tsc_khz)) {
>>>>    		kvm_set_time_scale(this_tsc_khz,&vcpu->hv_clock);
>>>> -		vcpu->hv_clock_tsc_khz = this_tsc_khz;
>>>> +		vcpu->hw_tsc_khz = this_tsc_khz;
>>>>    	}
>>>>
>>>>    	/* Keep irq disabled to prevent changes to the clock */
>>>> @@ -1805,18 +1805,24 @@ out:
>>>>
>>>>    void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>>>    {
>>>> +	kvm_x86_ops->vcpu_load(vcpu, cpu);
>>>>    	if (unlikely(vcpu->cpu != cpu)) {
>>>> +		/* Make sure TSC doesn't go backwards */
>>>> +		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>>>> +				native_read_tsc() - vcpu->arch.last_host_tsc;
>>>> +		if (tsc_delta<   0 || check_tsc_unstable())
>>>>
>>>>
>>>>
>>>>          
>>> It's better to do the adjustment also when tsc_delta>   0
>>>
>>>
>>>        
>> No, that causes time to stop.
>>
>>      
> You have done the compensation in PATCH  5. And another big question is
>    

Consider a scheduling diagram of what happens if you always compensate 
for local TSC for an SMP VM:

        VCPU1             VCPU2
       ------------------ -------------------
        on pcpu0,tsc=0     on pcup1,tsc=9000

        off,tsc=2
        idle

                           off,tsc=9005
        on pcpu1,tsc=9006  on pcpu0,tsc=6

        off,tsc=9008       off,tsc=8
       ------------------ -------------------
VTSC:    5                 8

At the end, virtual TSC is desynchronized, even though both hardware 
TSCs are running in sync.

This is 100% wrong to do if TSC is stable and in sync.  With unstable 
TSC, the best you can do is compensate for local TSC AND account for 
elapsed time (the idle time above which causes VCPU1 to lose cycles).  
You will still have error because the clock used to time elapsed time is 
sampled from a different source, but there isn't much you can do about 
it.  If you knew the TSC delta, then you could avoid multiplying 
compensation errors over time, but most of the time, you don't even have 
a guarantee the TSC will stay running at the same rate and in the same 
periods of time, so the delta is changing.

> why did you choose to drop the IPI based method which have done the
> compensation like PATCH 5? And more accurate value could be got through
> measuring the RTT of IPI.
>    

You could measure the delta at every potential discontinuity with an 
IPI, but it's way too heavy a hammer to use.  If your TSC stops in C1 
idle state, you have to resynchronize after every halt with a round of 
IPIs to the master?  Might as well constantly hit it on the head with a 
frying pan.  You're better off just disabling C1 idle (or the passive 
idle loop entirely).  Also, the locking is horrendously complicated.

Given all this cost and complexity, you'd want some positive result.

However, it still doesn't solve the problem above; there's going to be 
error and a potentially observed backwards clock across SMP VCPUs 
because even the IPI based measurement isn't perfect.  The only way to 
solve that is trap all the reads of the TSC.

So it doesn't seem a good design choice to make things more complex and 
costly in the common case to get a slightly better, but still broken 
solution in the outlying case.

Zach
