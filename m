Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2G3Mmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:42:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40850 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab2G3Mmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:42:43 -0400
Message-ID: <50168162.4010508@gmail.com>
Date: Mon, 30 Jul 2012 14:43:14 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: paulmck@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: INFO: rcu_preempt detected stalls on CPUs/tasks on v3.6
References: <500ED719.2010002@gmail.com> <50112D3B.4020201@redhat.com> <50127B16.5040401@gmail.com> <50153138.4020304@redhat.com> <5015A5A8.7030601@gmail.com> <50161D5E.4030009@redhat.com> <50165046.9020705@gmail.com> <501654D3.7020504@redhat.com>
In-Reply-To: <501654D3.7020504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 11:33 AM, Avi Kivity wrote:
> On 07/30/2012 12:13 PM, Sasha Levin wrote:
>>>>>>
>>>>>> Yup, looks like it. kvm_stats is something like this:
>>>>>>
>>>>>>  kvm_entry                                142104033  939393
>>>>>>  kvm_exit                                 142104004  939390
>>>>>>  kvm_apic                                  84781115  582714
>>>>>>  kvm_msr                                   84682085  582714
>>>>>>  kvm_apic_accept_irq                       65219959  522263
>>>>>>  kvm_inj_virq                              43173709  291385
>>>>>>
>>>>>> With everything else at 0 when it happens.
>>>>>
>>>>> Please run a trace and verify that the injected vector is indeed the
>>>>> timer interrupt.
>>>>
>>>> Looks like it is.
>>>>
>>>>> Then work backwards to see the last place it is
>>>>> programmed (APIC_TMICT/APIC_TDCR).
>>>>
>>>> This looks like what you're looking for:
>>>>
>>>> kvm_apic: apic_write APIC_TMICT = 0x3e
> 
> What about APIC_TMICT?  Might be configured just once on boot.

Did you mean APIC_TDCR?

I'm seeing both in the trace logs, but it's APIC_TMICT thats shown when the hang occurs.

              vm-19727 [002] ...1 66669.010699: kvm_apic: apic_read APIC_TDCR = 0x0
              vm-19727 [002] ...1 66669.010699: kvm_msr: msr_read 83e = 0x0
              vm-19727 [002] d..2 66669.010699: kvm_entry: vcpu 0
              vm-19727 [002] d..2 66669.010700: kvm_exit: reason MSR_WRITE rip 0xffffffff810a06a8 info 0 0
              vm-19727 [002] ...1 66669.010701: kvm_apic: apic_write APIC_TDCR = 0x3
              vm-19727 [002] ...1 66669.010701: kvm_msr: msr_write 83e = 0x3
              vm-19727 [002] d..2 66669.010701: kvm_entry: vcpu 0

>>>>
>>>>
>>>> Basically it's spinning on the following 4 lines of trace when it happens:
>>>>
>>>> 	16063.549189: kvm_apic: apic_write APIC_TMICT = 0x3e
>>>> 	16063.549190: kvm_msr: msr_write 838 = 0x3e
>>>> 	16063.549190: kvm_exit: reason EXTERNAL_INTERRUPT rip 0xffffffff8115de02 info 0 0
>>>> 	16063.549190: kvm_entry: vcpu 2
>>>>
>>>
>>> What, no kvm_inj_virq?
>>>
>>> Are you running with pveoi?  Try disabling it.
> 
> What's the answer to this question?

The host is running 3.5, so that shouldn't be enabled.

>>
>> I must have looked at a block in the logfile which doesn't represent everything thats going on, sorry.
>>
>> Here's a more complete picture:
>>
>> 	vm-16567 [000] d..2 16063.549298: kvm_exit: reason PENDING_INTERRUPT rip 0xffffffff83625c80 info 0 0
>> 	vm-16567 [000] ...1 16063.549299: kvm_inj_virq: irq 239
>> 	vm-16567 [000] d..2 16063.549300: kvm_entry: vcpu 0
>> 	vm-16567 [000] d..2 16063.549301: kvm_exit: reason MSR_WRITE rip 0xffffffff8109fef8 info 0 0
>> 	vm-16567 [000] ...1 16063.549302: kvm_apic: apic_write APIC_EOI = 0x0
>> 	vm-16567 [000] ...1 16063.549302: kvm_msr: msr_write 80b = 0x0
>> 	vm-16567 [000] d..2 16063.549303: kvm_entry: vcpu 0
>> 	vm-16567 [000] d..2 16063.549308: kvm_exit: reason MSR_WRITE rip 0xffffffff8109fef8 info 0 0
>> 	vm-16567 [000] ...1 16063.549309: kvm_apic: apic_write APIC_TMICT = 0x3e
>> 	vm-16567 [000] ...1 16063.549310: kvm_msr: msr_write 838 = 0x3e
>> 	vm-16567 [000] d..2 16063.549311: kvm_entry: vcpu 0
>> 	vm-16567 [000] d..2 16063.549312: kvm_exit: reason PENDING_INTERRUPT rip 0xffffffff83625c80 info 0 0
> 
> This must refer to a lower priority interrupt, since 239 hasn't been
> injected yet.
> 
>> 	vm-16567 [000] ...1 16063.549314: kvm_apic_accept_irq: apicid 0 vec 239 (Fixed|edge)
> 
> And now conveniently the hrtimer fires and injects another interrupt.
> 
>> 	vm-16567 [000] ...1 16063.549315: kvm_inj_virq: irq 239
>> 	vm-16567 [000] d..2 16063.549315: kvm_entry: vcpu 0
>> 	vm-16567 [000] d..2 16063.549316: kvm_exit: reason MSR_WRITE rip 0xffffffff8109fef8 info 0 0
>> 	vm-16567 [000] ...1 16063.549318: kvm_apic: apic_write APIC_EOI = 0x0
>> 	vm-16567 [000] ...1 16063.549318: kvm_msr: msr_write 80b = 0x0
> 
> Please add hrtimer_start and hrtimer_expire_entry to your traced events.
> 

A bigger log with those two enabled:

             vm-19730 [003] ...1 66730.739585: kvm_apic: apic_write APIC_TMICT = 0x3e
              vm-19716 [000] d..3 66730.739586: hrtimer_start: hrtimer=ffff880133cc3f78 function=posix_timer_fn expires=66882054763626 softexpires=66882054763626
              vm-19730 [003] d..2 66730.739586: hrtimer_start: hrtimer=ffff88011e00d3d0 function=kvm_timer_fn expires=66882053774813 softexpires=66882053774813
              vm-19730 [003] ...1 66730.739586: kvm_msr: msr_write 838 = 0x3e
              vm-19730 [003] d..2 66730.739587: kvm_entry: vcpu 3
              vm-19730 [003] d..2 66730.739589: kvm_exit: reason PENDING_INTERRUPT rip 0xffffffff8115c684 info 0 0
              vm-19729 [001] d..2 66730.739590: kvm_exit: reason MSR_WRITE rip 0xffffffff810a06a8 info 0 0
              vm-19730 [003] d.h2 66730.739590: hrtimer_expire_entry: hrtimer=ffff88011e00d3d0 function=kvm_timer_fn now=66882053778032
              vm-19729 [001] ...1 66730.739591: kvm_apic: apic_write APIC_TMICT = 0x3e
              vm-19730 [003] ...1 66730.739591: kvm_apic_accept_irq: apicid 3 vec 239 (Fixed|edge) (coalesced)
              vm-19729 [001] d..2 66730.739591: hrtimer_start: hrtimer=ffff88020d208490 function=kvm_timer_fn expires=66882053780380 softexpires=66882053780380
              vm-19730 [003] ...1 66730.739592: kvm_inj_virq: irq 239
              vm-19729 [001] ...1 66730.739592: kvm_msr: msr_write 838 = 0x3e
              vm-19730 [003] d..2 66730.739593: kvm_entry: vcpu 3
              vm-19729 [001] d..2 66730.739593: kvm_entry: vcpu 2
              vm-19730 [003] d..2 66730.739594: kvm_exit: reason MSR_WRITE rip 0xffffffff810a06a8 info 0 0
              vm-19729 [001] d..2 66730.739594: kvm_exit: reason EXTERNAL_INTERRUPT rip 0xffffffff83601f61 info 0 0
              vm-19730 [003] ...1 66730.739595: kvm_apic: apic_write APIC_EOI = 0x0
              vm-19730 [003] ...1 66730.739595: kvm_msr: msr_write 80b = 0x0
              vm-19729 [001] d.h2 66730.739596: hrtimer_expire_entry: hrtimer=ffff88020d208490 function=kvm_timer_fn now=66882053783462
              vm-19730 [003] ...1 66730.739596: kvm_apic_accept_irq: apicid 3 vec 239 (Fixed|edge)
              vm-19729 [001] ...1 66730.739597: kvm_apic_accept_irq: apicid 2 vec 239 (Fixed|edge) (coalesced)
              vm-19730 [003] d..2 66730.739597: kvm_entry: vcpu 3
              vm-19729 [001] d..2 66730.739597: kvm_entry: vcpu 2
              vm-19729 [001] d..2 66730.739598: kvm_exit: reason PENDING_INTERRUPT rip 0xffffffff8115c684 info 0 0
              vm-19729 [001] ...1 66730.739599: kvm_apic_accept_irq: apicid 2 vec 239 (Fixed|edge) (coalesced)
              vm-19729 [001] ...1 66730.739600: kvm_inj_virq: irq 239
              vm-19729 [001] d..2 66730.739600: kvm_entry: vcpu 2
              vm-19729 [001] d..2 66730.739601: kvm_exit: reason MSR_WRITE rip 0xffffffff810a06a8 info 0 0
              vm-19729 [001] ...1 66730.739602: kvm_apic: apic_write APIC_EOI = 0x0
              vm-19729 [001] ...1 66730.739602: kvm_msr: msr_write 80b = 0x0
              vm-19730 [003] d..2 66730.739603: kvm_exit: reason MSR_WRITE rip 0xffffffff810a06a8 info 0 0
              vm-19729 [001] ...1 66730.739603: kvm_apic_accept_irq: apicid 2 vec 239 (Fixed|edge)
              vm-19730 [003] ...1 66730.739604: kvm_apic: apic_write APIC_TMICT = 0x3e
              vm-19729 [001] d..2 66730.739604: kvm_entry: vcpu 2
              vm-19730 [003] d..2 66730.739604: hrtimer_start: hrtimer=ffff88011e00d3d0 function=kvm_timer_fn expires=66882053793430 softexpires=66882053793430
              vm-19730 [003] ...1 66730.739605: kvm_msr: msr_write 838 = 0x3e
              vm-19730 [003] d..2 66730.739606: kvm_entry: vcpu 3
              vm-19730 [003] d..2 66730.739607: kvm_exit: reason PENDING_INTERRUPT rip 0xffffffff8115c684 info 0 0
              vm-19729 [001] d..2 66730.739608: kvm_exit: reason EXTERNAL_INTERRUPT rip 0xffffffff8115f2a1 info 0 0
              vm-19730 [003] d.h2 66730.739608: hrtimer_expire_entry: hrtimer=ffff88011e00d3d0 function=kvm_timer_fn now=66882053796355
              vm-19729 [001] ...1 66730.739609: kvm_userspace_exit: reason restart (4)
              vm-19730 [003] ...1 66730.739610: kvm_apic_accept_irq: apicid 3 vec 239 (Fixed|edge) (coalesced)
              vm-19730 [003] ...1 66730.739611: kvm_userspace_exit: reason restart (4)
              vm-19716 [000] ...1 66730.739612: kvm_set_irq: gsi 4 level 1 source 0
              vm-19716 [000] ...2 66730.739614: kvm_pic_set_irq: chip 0 pin 4 (edge)
