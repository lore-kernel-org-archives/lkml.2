Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1LATuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:50:50 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47609 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab1LATut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:50:49 -0500
Message-ID: <4ED7DA85.5080504@linux.vnet.ibm.com>
Date: Fri, 02 Dec 2011 01:20:29 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Xen <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC V3 2/4] kvm hypervisor : Add a hypercall to KVM hypervisor
 to support pv-ticketlocks
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com> <20111130085959.23386.69166.sendpatchset@oc5400248562.ibm.com> <4ED760F1.6080804@redhat.com>
In-Reply-To: <4ED760F1.6080804@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11120119-2674-0000-0000-000002804B68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CCing Jeremy's new email ID ]
Hi Avi,
Thanks for review and inputs.

On 12/01/2011 04:41 PM, Avi Kivity wrote:
> On 11/30/2011 10:59 AM, Raghavendra K T wrote:
>
> The hypercall needs to be documented in
> Documentation/virtual/kvm/hypercalls.txt.
>

Yes, Sure 'll document.  hypercalls.txt is a new file right?. also I 
have to document APIs in Documentation/virtual/kvm/api.txt.

> Have you tested it on AMD machines?  There are some differences in the
> hypercall infrastructure there.

Yes. 'll test on AMD machine and update on that.

>
>>   /* This indicates that the new set of kvmclock msrs
>>    * are available. The use of 0x11 and 0x12 is deprecated
>>    */
>>   #define KVM_FEATURE_CLOCKSOURCE2        3
>>   #define KVM_FEATURE_ASYNC_PF		4
>>   #define KVM_FEATURE_STEAL_TIME		5
>> +#define KVM_FEATURE_KICK_VCPU		6
>
> Documentation/virtual/kvm/cpuid.txt.

Yes. 'll do that.

>
>>
>>   /* The last 8 bits are used to indicate how to interpret the flags field
>>    * in pvclock structure. If no bits are set, all flags are ignored.
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c38efd7..6e1c8b4 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2103,6 +2103,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>>   	case KVM_CAP_XSAVE:
>>   	case KVM_CAP_ASYNC_PF:
>>   	case KVM_CAP_GET_TSC_KHZ:
>> +	case KVM_CAP_KICK_VCPU:
>
> This is redundant with the feature bit?  In general, KVM_CAP is for the
> host API, while KVM_FEATURE is for the guest API.
>

No its not. I have to check the flow again. I understood that this 
completes the guest querying, that checks for KVM_FEATURE availability.
Did I miss something? I need a little deep dive though.

>>
>> +/*
>> + * kvm_pv_kick_cpu_op:  Kick a vcpu.
>> + *
>> + * @cpu - vcpu to be kicked.
>> + */
>> +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int cpu)
>> +{
>> +	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);
>
> There is no guarantee that guest cpu numbers match host vcpu numbers.
> Use APIC IDs, and kvm_apic_match_dest().

Okay. I have to dig more on this.

>
>> +	struct kvm_mp_state mp_state;
>> +
>> +	mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
>> +	if (vcpu) {
>> +		vcpu->kicked = 1;
>> +		/* Ensure kicked is always set before wakeup */
>> +		barrier();
>> +	}
>> +	kvm_arch_vcpu_ioctl_set_mpstate(vcpu,&mp_state);
>
> This must only be called from the vcpu thread.

Hmm. Okay. 'll check this.

>
>> +	kvm_vcpu_kick(vcpu);
>> +}
>> +
>>
>>   	struct kvm_vcpu_arch arch;
>> +
>> +	/*
>> +	 * blocked vcpu wakes up by checking this flag set by unlocker.
>> +	 */
>> +	int kicked;
>>
>
> Write only variable.

Yes 'll remove comments.

>
> An alternative approach is to use an MSR protocol like x2apic ICR.
>

'll explore on this too.

