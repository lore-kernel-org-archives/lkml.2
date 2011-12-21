Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab1LUL6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:58:49 -0500
Received: from david.siemens.de ([192.35.17.14]:18214 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab1LUL6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:58:47 -0500
Message-ID: <4EF1C9E9.50805@siemens.com>
Date: Wed, 21 Dec 2011 12:58:33 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86: Prevent exposing TSC deadline timer feature
 in the absence of in-kernel APIC
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com> <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com> <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com> <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com> <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com> <CA+55aFwZ02yUBbUjJYuXjZnKcQRHC7uT9T1dckZQNSaC6SdnvA@mail.gmail.com> <4EF1146D.208@siemens.com> <4EF1B081.3010109@siemens.com> <4EF1B423.8050707@siemens.com> <4EF1B67D.7010603@redhat.com> <4EF1B7C0.3080200@siemens.com> <4EF1B8A4.2050008@redhat.com> <4EF1C2DD.8070303@siemens.com> <4EF1C6C5.6080300@redhat.com>
In-Reply-To: <4EF1C6C5.6080300@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-21 12:45, Avi Kivity wrote:
> On 12/21/2011 01:28 PM, Jan Kiszka wrote:
>>>
>>> timer_mode_mask can just be slaved to the bit (as received by
>>> KVM_SET_CPUID); that's exactly kvm_update_cpuid()'s role.
>>
>> Like
> 
> Ugh, the facebook generation invades lkml.

I'm not on facebook. Does anyone sell shirts with that?

> 
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 230f713..89b02bf 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -27,7 +27,6 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm_cpuid_entry2 *best;
>>  	struct kvm_lapic *apic = vcpu->arch.apic;
>> -	u32 timer_mode_mask;
>>
>>  	best = kvm_find_cpuid_entry(vcpu, 1, 0);
>>  	if (!best)
>> @@ -40,15 +39,12 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
>>  			best->ecx |= bit(X86_FEATURE_OSXSAVE);
>>  	}
>>
>> -	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
>> -		best->function == 0x1) {
>> -		best->ecx |= bit(X86_FEATURE_TSC_DEADLINE_TIMER);
>> -		timer_mode_mask = 3 << 17;
>> -	} else
>> -		timer_mode_mask = 1 << 17;
>> -
>> -	if (apic)
>> -		apic->lapic_timer.timer_mode_mask = timer_mode_mask;
>> +	if (apic) {
>> +		if (best->ecx & bit(X86_FEATURE_TSC_DEADLINE_TIMER))
>> +			apic->lapic_timer.timer_mode_mask = 3 << 17;
>> +		else
>> +			apic->lapic_timer.timer_mode_mask = 1 << 17;
>> +	}
>>
>>  	kvm_pmu_cpuid_update(vcpu);
>>  }
>>
>>
>> + the KVM_CAP thing?
>>
> 
> +1

Ah, the adult crowd that trusts the other side.

OK, will see that I can cook up a proper patch later.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
