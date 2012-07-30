Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2G3JdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:33:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab2G3JdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:33:13 -0400
Message-ID: <501654D3.7020504@redhat.com>
Date: Mon, 30 Jul 2012 12:33:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: paulmck@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: INFO: rcu_preempt detected stalls on CPUs/tasks on v3.6
References: <500ED719.2010002@gmail.com> <50112D3B.4020201@redhat.com> <50127B16.5040401@gmail.com> <50153138.4020304@redhat.com> <5015A5A8.7030601@gmail.com> <50161D5E.4030009@redhat.com> <50165046.9020705@gmail.com>
In-Reply-To: <50165046.9020705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 12:13 PM, Sasha Levin wrote:
>>>>>
>>>>> Yup, looks like it. kvm_stats is something like this:
>>>>>
>>>>>  kvm_entry                                142104033  939393
>>>>>  kvm_exit                                 142104004  939390
>>>>>  kvm_apic                                  84781115  582714
>>>>>  kvm_msr                                   84682085  582714
>>>>>  kvm_apic_accept_irq                       65219959  522263
>>>>>  kvm_inj_virq                              43173709  291385
>>>>>
>>>>> With everything else at 0 when it happens.
>>>>
>>>> Please run a trace and verify that the injected vector is indeed the
>>>> timer interrupt.
>>>
>>> Looks like it is.
>>>
>>>> Then work backwards to see the last place it is
>>>> programmed (APIC_TMICT/APIC_TDCR).
>>>
>>> This looks like what you're looking for:
>>>
>>> kvm_apic: apic_write APIC_TMICT = 0x3e

What about APIC_TMICT?  Might be configured just once on boot.

>>>
>>>
>>> Basically it's spinning on the following 4 lines of trace when it happens:
>>>
>>> 	16063.549189: kvm_apic: apic_write APIC_TMICT = 0x3e
>>> 	16063.549190: kvm_msr: msr_write 838 = 0x3e
>>> 	16063.549190: kvm_exit: reason EXTERNAL_INTERRUPT rip 0xffffffff8115de02 info 0 0
>>> 	16063.549190: kvm_entry: vcpu 2
>>>
>> 
>> What, no kvm_inj_virq?
>> 
>> Are you running with pveoi?  Try disabling it.

What's the answer to this question?

> 
> I must have looked at a block in the logfile which doesn't represent everything thats going on, sorry.
> 
> Here's a more complete picture:
> 
> 	vm-16567 [000] d..2 16063.549298: kvm_exit: reason PENDING_INTERRUPT rip 0xffffffff83625c80 info 0 0
> 	vm-16567 [000] ...1 16063.549299: kvm_inj_virq: irq 239
> 	vm-16567 [000] d..2 16063.549300: kvm_entry: vcpu 0
> 	vm-16567 [000] d..2 16063.549301: kvm_exit: reason MSR_WRITE rip 0xffffffff8109fef8 info 0 0
> 	vm-16567 [000] ...1 16063.549302: kvm_apic: apic_write APIC_EOI = 0x0
> 	vm-16567 [000] ...1 16063.549302: kvm_msr: msr_write 80b = 0x0
> 	vm-16567 [000] d..2 16063.549303: kvm_entry: vcpu 0
> 	vm-16567 [000] d..2 16063.549308: kvm_exit: reason MSR_WRITE rip 0xffffffff8109fef8 info 0 0
> 	vm-16567 [000] ...1 16063.549309: kvm_apic: apic_write APIC_TMICT = 0x3e
> 	vm-16567 [000] ...1 16063.549310: kvm_msr: msr_write 838 = 0x3e
> 	vm-16567 [000] d..2 16063.549311: kvm_entry: vcpu 0
> 	vm-16567 [000] d..2 16063.549312: kvm_exit: reason PENDING_INTERRUPT rip 0xffffffff83625c80 info 0 0

This must refer to a lower priority interrupt, since 239 hasn't been
injected yet.

> 	vm-16567 [000] ...1 16063.549314: kvm_apic_accept_irq: apicid 0 vec 239 (Fixed|edge)

And now conveniently the hrtimer fires and injects another interrupt.

> 	vm-16567 [000] ...1 16063.549315: kvm_inj_virq: irq 239
> 	vm-16567 [000] d..2 16063.549315: kvm_entry: vcpu 0
> 	vm-16567 [000] d..2 16063.549316: kvm_exit: reason MSR_WRITE rip 0xffffffff8109fef8 info 0 0
> 	vm-16567 [000] ...1 16063.549318: kvm_apic: apic_write APIC_EOI = 0x0
> 	vm-16567 [000] ...1 16063.549318: kvm_msr: msr_write 80b = 0x0

Please add hrtimer_start and hrtimer_expire_entry to your traced events.

-- 
error compiling committee.c: too many arguments to function


