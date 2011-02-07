Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1BGPPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:15:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab1BGPPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:15:49 -0500
Message-ID: <4D500C9F.2080501@redhat.com>
Date: Mon, 07 Feb 2011 10:15:43 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Convert tsc_write_lock to raw_spinlock
References: <4D4BCB97.6000900@siemens.com> <4D4C698A.4010201@redhat.com> <4D4FD8EE.6040009@siemens.com> <4D4FFD97.6010805@redhat.com> <4D5008F0.5060200@siemens.com>
In-Reply-To: <4D5008F0.5060200@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 10:00 AM, Jan Kiszka wrote:
> On 2011-02-07 15:11, Zachary Amsden wrote:
>    
>> On 02/07/2011 06:35 AM, Jan Kiszka wrote:
>>      
>>> On 2011-02-04 22:03, Zachary Amsden wrote:
>>>
>>>        
>>>> On 02/04/2011 04:49 AM, Jan Kiszka wrote:
>>>>
>>>>          
>>>>> Code under this lock requires non-preemptibility. Ensure this also over
>>>>> -rt by converting it to raw spinlock.
>>>>>
>>>>>
>>>>>            
>>>> Oh dear, I had forgotten about that.  I believe kvm_lock might have the
>>>> same assumption in a few places regarding clock.
>>>>
>>>>          
>>> I only found a problematic section in kvmclock_cpufreq_notifier. Didn't
>>> see this during my tests as I have CPUFREQ disabled in my .config.
>>>
>>> We may need something like this as converting kvm_lock would likely be
>>> overkill:
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 36f54fb..971ee0d 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -4530,7 +4530,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
>>>    	struct cpufreq_freqs *freq = data;
>>>    	struct kvm *kvm;
>>>    	struct kvm_vcpu *vcpu;
>>> -	int i, send_ipi = 0;
>>> +	int i, me, send_ipi = 0;
>>>
>>>    	/*
>>>    	 * We allow guests to temporarily run on slowing clocks,
>>> @@ -4583,9 +4583,11 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
>>>    		kvm_for_each_vcpu(i, vcpu, kvm) {
>>>    			if (vcpu->cpu != freq->cpu)
>>>    				continue;
>>> +			me = get_cpu();
>>>    			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>>> -			if (vcpu->cpu != smp_processor_id())
>>> +			if (vcpu->cpu != me)
>>>    				send_ipi = 1;
>>> +			put_cpu();
>>>    		}
>>>    	}
>>>    	spin_unlock(&kvm_lock);
>>>
>>> Jan
>>>
>>>
>>>        
>> That looks like a good solution, and I do believe that is the only place
>> the lock is used in that fashion - please add a comment though in the
>> giant comment block above that preemption protection is needed for RT.
>> Also, gcc should catch this, but moving the me variable into the
>> kvm_for_each_vcpu loop should allow for better register allocation.
>>
>> The only other thing I can think of is that RT lock preemption may break
>> some of the CPU initialization semantics enforced by kvm_lock if you
>> happen to get a hotplug event just as the module is loading.  That
>> should be rare, but if it is indeed a bug, it would be nice to fix, it
>> would be a panic for sure not to initialize VMX.
>>      
> Hmm, is a cpu hotplug notifier allowed to run sleepy code? Can't
> imagine. So we already have a strong reason to convert kvm_lock to a
> raw_spinlock which obsoletes the above workaround.
>    

I don't know as it is allowed to sleep, it doesn't call any sleeping 
functions to my knowledge.  What worries me in the RT case is that the 
spinlock acquired for hardware_enable might be preempted and run on 
another CPU, which obviously isn't what you want.

Zach
