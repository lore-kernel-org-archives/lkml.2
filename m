Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0INXkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:40:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab0INXkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:40:45 -0400
Message-ID: <4C9007F2.9020205@redhat.com>
Date: Tue, 14 Sep 2010 13:40:34 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-11-git-send-email-zamsden@redhat.com> <4C8F3C03.50306@siemens.com> <4C8F3FF3.9080803@redhat.com> <4C8F5125.5060505@siemens.com> <4C8FCDE2.3000202@redhat.com> <4C8FF690.7030107@web.de>
In-Reply-To: <4C8FF690.7030107@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 12:26 PM, Jan Kiszka wrote:
> Am 14.09.2010 21:32, Zachary Amsden wrote:
>    
>> On 09/14/2010 12:40 AM, Jan Kiszka wrote:
>>      
>>> Am 14.09.2010 11:27, Avi Kivity wrote:
>>>
>>>        
>>>>     On 09/14/2010 11:10 AM, Jan Kiszka wrote:
>>>>
>>>>          
>>>>> Am 20.08.2010 10:07, Zachary Amsden wrote:
>>>>>
>>>>>            
>>>>>> When CPUs with unstable TSCs enter deep C-state, TSC may stop
>>>>>> running.  This causes us to require resynchronization.  Since
>>>>>> we can't tell when this may potentially happen, we assume the
>>>>>> worst by forcing re-compensation for it at every point the VCPU
>>>>>> task is descheduled.
>>>>>>
>>>>>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>>>>> ---
>>>>>>     arch/x86/kvm/x86.c |    2 +-
>>>>>>     1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>>> index 7fc4a55..52b6c21 100644
>>>>>> --- a/arch/x86/kvm/x86.c
>>>>>> +++ b/arch/x86/kvm/x86.c
>>>>>> @@ -1866,7 +1866,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
>>>>>> *vcpu, int cpu)
>>>>>>         }
>>>>>>
>>>>>>         kvm_x86_ops->vcpu_load(vcpu, cpu);
>>>>>> -    if (unlikely(vcpu->cpu != cpu)) {
>>>>>> +    if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
>>>>>>             /* Make sure TSC doesn't go backwards */
>>>>>>             s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>>>>>>                     native_read_tsc() - vcpu->arch.last_host_tsc;
>>>>>>
>>>>>>              
>>>>> For yet unknown reason, this commit breaks Linux guests here if they
>>>>> are
>>>>> started with only a single VCPU. They hang during boot, obviously no
>>>>> longer receiving interrupts.
>>>>>
>>>>> I'm using kvm-kmod against a 2.6.34 host kernel, so this may be a side
>>>>> effect of the wrapping, though I cannot imagine how.
>>>>>
>>>>> Anyone any ideas?
>>>>>
>>>>>
>>>>>
>>>>>            
>>>> Most likely, time went backwards, and some 'future - past' calculation
>>>> resulted in a negative sleep value which was then interpreted as
>>>> unsigned and resulted in a 2342525634 year sleep.
>>>>
>>>>          
>>> Looks like that's the case on first glance at the apic state.
>>>
>>>        
>> This compensation effectively nulls the delta between current and last TSC:
>>
>>          if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
>>                  /* Make sure TSC doesn't go backwards */
>>                  s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>>                                  native_read_tsc() -
>> vcpu->arch.last_host_tsc;
>>                  if (tsc_delta<  0)
>>                          mark_tsc_unstable("KVM discovered backwards TSC");
>>                  if (check_tsc_unstable())
>>                          kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
>>                  kvm_migrate_timers(vcpu);
>>                  vcpu->cpu = cpu;
>>
>> If TSC has advanced quite a bit due to a TSC jump during sleep(*), it
>> will adjust the offset backwards to compensate; similarly, if it has
>> gone backwards, it will advance the offset.
>>
>> In neither case should the visible TSC go backwards, assuming
>> last_host_tsc is recorded properly, and so kvmclock should be similarly
>> unaffected.
>>
>> Perhaps the guest is more intelligent than we hope, and is comparing two
>> different clocks: kvmclock or TSC with the rate of PIT interrupts.  This
>> could result in negative arithmetic begin interpreted as unsigned.  Are
>> you using PIT interrupt reinjection on this guest or passing
>> -no-kvm-pit-reinjection?
>>
>>      
>>>
>>>        
>>>> Does your guest use kvmclock, tsc, or some other time source?
>>>>
>>>>          
>>> A kernel that has kvmclock support even hangs in SMP mode. The others
>>> pick hpet or acpi_pm. TSC is considered unstable.
>>>
>>>        
>> SMP mode here has always and will always be unreliable.  Are you running
>> on an Intel or AMD CPU?  The origin of this code comes from a workaround
>> for (*) in vendor-specific code, and perhaps it is inappropriate for both.
>>      
> I'm on a fairly new Intel i7 (M 620). And I accidentally rebooted my box
> a few hours ago. Well, the issue is gone now...
>
> So I looked into the system logs and found this:
>
> [18446744053.434939] PM: resume of devices complete after 4379.595 msecs
> [18446744053.457133] PM: Finishing wakeup.
> [18446744053.457135] Restarting tasks ...
> [    0.000999] Marking TSC unstable due to KVM discovered backwards TSC
> [270103.974668] done.
>
>  From that point on the box was on hpet, including the time I did the
> failing tests this morning. The kvm-kmod version loaded at this point
> was based on kvm.git df549cfc.
>
> But my /proc/cpuinfo claims "constant_tsc", and Linux is generally happy
> with using it as clock source. Does this tell you anything?
>    

Yes, quite a bit.

It's possible that marking the TSC unstable with an actively running VM 
causes a boundary condition that I had not accounted for.  It's also 
possible that the clocksource switch triggered some bad behavior.

This suggests two debugging techniques: I can manually switch the 
clocksource, and I can also load a module which does nothing other than 
mark the TSC unstable.  Failing that, we can investigate PM suspend / 
resume for possible issues.

I'll try this on my Intel boxes to see what happens.
