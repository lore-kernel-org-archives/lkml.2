Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1GGRIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:08:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab1GGRIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:08:52 -0400
Message-ID: <4E15E7E5.6020909@redhat.com>
Date: Thu, 07 Jul 2011 14:07:49 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v5 4/9] KVM-HV: KVM Steal time implementation
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-5-git-send-email-glommer@redhat.com> <20110707105113.GA3986@amt.cnet>
In-Reply-To: <20110707105113.GA3986@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 07:51 AM, Marcelo Tosatti wrote:
> On Mon, Jul 04, 2011 at 11:32:23AM -0400, Glauber Costa wrote:
>> To implement steal time, we need the hypervisor to pass the guest
>> information about how much time was spent running other processes
>> outside the VM, while the vcpu had meaningful work to do - halt
>> time does not count.
>>
>> This information is acquired through the run_delay field of
>> delayacct/schedstats infrastructure, that counts time spent in a
>> runqueue but not running.
>>
>> Steal time is a per-cpu information, so the traditional MSR-based
>> infrastructure is used. A new msr, KVM_MSR_STEAL_TIME, holds the
>> memory area address containing information about steal time
>>
>> This patch contains the hypervisor part of the steal time infrasructure,
>> and can be backported independently of the guest portion.
>>
>> Signed-off-by: Glauber Costa<glommer@redhat.com>
>> CC: Rik van Riel<riel@redhat.com>
>> CC: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
>> CC: Peter Zijlstra<peterz@infradead.org>
>> CC: Avi Kivity<avi@redhat.com>
>> CC: Anthony Liguori<aliguori@us.ibm.com>
>> CC: Eric B Munson<emunson@mgebm.net>
>> ---
>>   arch/x86/include/asm/kvm_host.h |    8 +++++
>>   arch/x86/include/asm/kvm_para.h |    4 +++
>>   arch/x86/kvm/Kconfig            |    1 +
>>   arch/x86/kvm/x86.c              |   56 ++++++++++++++++++++++++++++++++++++--
>>   4 files changed, 66 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index da6bbee..9ba354d 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -389,6 +389,14 @@ struct kvm_vcpu_arch {
>>   	unsigned int hw_tsc_khz;
>>   	unsigned int time_offset;
>>   	struct page *time_page;
>> +
>> +	struct {
>> +		u64 msr_val;
>> +		u64 last_steal;
>> +		struct gfn_to_hva_cache stime;
>> +		struct kvm_steal_time steal;
>> +	} st;
>> +
>>   	u64 last_guest_tsc;
>>   	u64 last_kernel_ns;
>>   	u64 last_tsc_nsec;
>> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
>> index 65f8bb9..c484ba8 100644
>> --- a/arch/x86/include/asm/kvm_para.h
>> +++ b/arch/x86/include/asm/kvm_para.h
>> @@ -45,6 +45,10 @@ struct kvm_steal_time {
>>   	__u32 pad[12];
>>   };
>>
>> +#define KVM_STEAL_ALIGNMENT_BITS 5
>> +#define KVM_STEAL_VALID_BITS ((-1ULL<<  (KVM_STEAL_ALIGNMENT_BITS + 1)))
>> +#define KVM_STEAL_RESERVED_MASK (((1<<  KVM_STEAL_ALIGNMENT_BITS) - 1 )<<  1)
>> +
>>   #define KVM_MAX_MMU_OP_BATCH           32
>>
>>   #define KVM_ASYNC_PF_ENABLED			(1<<  0)
>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>> index 50f6364..99c3f05 100644
>> --- a/arch/x86/kvm/Kconfig
>> +++ b/arch/x86/kvm/Kconfig
>> @@ -31,6 +31,7 @@ config KVM
>>   	select KVM_ASYNC_PF
>>   	select USER_RETURN_NOTIFIER
>>   	select KVM_MMIO
>> +	select TASK_DELAY_ACCT
>>   	---help---
>>   	  Support hosting fully virtualized guest machines using hardware
>>   	  virtualization extensions.  You will need a fairly recent
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 7167717..237bcdc 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -808,12 +808,12 @@ EXPORT_SYMBOL_GPL(kvm_get_dr);
>>    * kvm-specific. Those are put in the beginning of the list.
>>    */
>>
>> -#define KVM_SAVE_MSRS_BEGIN	8
>> +#define KVM_SAVE_MSRS_BEGIN	9
>>   static u32 msrs_to_save[] = {
>>   	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
>>   	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
>>   	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
>> -	HV_X64_MSR_APIC_ASSIST_PAGE, MSR_KVM_ASYNC_PF_EN,
>> +	HV_X64_MSR_APIC_ASSIST_PAGE, MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
>>   	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
>>   	MSR_STAR,
>>   #ifdef CONFIG_X86_64
>> @@ -1491,6 +1491,27 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
>>   	}
>>   }
>>
>> +static void record_steal_time(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 delta;
>> +
>> +	if (!(vcpu->arch.st.msr_val&  KVM_MSR_ENABLED))
>> +		return;
>> +
>> +	if (unlikely(kvm_read_guest_cached(vcpu->kvm,&vcpu->arch.st.stime,
>> +		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time))))
>> +		return;
>
> The guest memory page is not pinned, sleeping via
> __copy_from_user/to_user is not allowed in vcpu_load context. Either pin
> it or use atomic acessors.

I do recognize the problem.
Avi, what's your take here?

>> +	case MSR_KVM_STEAL_TIME:
>> +		vcpu->arch.st.msr_val = data;
>> +
>> +		if (!(data&  KVM_MSR_ENABLED)) {
>> +			break;
>> +		}
>
> On failure below this point, msr_val should be cleared of KVM_MSR_ENABLED?
No, msr_val has to hold whatever the guest wrote into it.
We should probably use an independent variable here to indicate that we 
failed to activate it.

>
>> +
>> +		if (unlikely(!sched_info_on()))
>> +			break;
>> +
>> +		if (data&  KVM_STEAL_RESERVED_MASK)
>> +			return 1;
>> +
>> +		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,&vcpu->arch.st.stime,
>> +							data&  KVM_STEAL_VALID_BITS))
>> +			return 1;
>> +
>> +		vcpu->arch.st.last_steal = current->sched_info.run_delay;
>> +
>> +		record_steal_time(vcpu);
>> +		break;
>> +

