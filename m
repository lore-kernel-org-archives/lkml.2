Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab0HZARU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 20:17:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0HZARS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 20:17:18 -0400
Message-ID: <4C75B283.6070607@redhat.com>
Date: Wed, 25 Aug 2010 14:17:07 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 25/35] Add clock catchup mode
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-26-git-send-email-zamsden@redhat.com> <20100825172718.GA28380@amt.cnet> <4C758194.5060203@redhat.com> <20100825220134.GA3322@amt.cnet>
In-Reply-To: <20100825220134.GA3322@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 12:01 PM, Marcelo Tosatti wrote:
> On Wed, Aug 25, 2010 at 10:48:20AM -1000, Zachary Amsden wrote:
>    
>> On 08/25/2010 07:27 AM, Marcelo Tosatti wrote:
>>      
>>> On Thu, Aug 19, 2010 at 10:07:39PM -1000, Zachary Amsden wrote:
>>>        
>>>> Make the clock update handler handle generic clock synchronization,
>>>> not just KVM clock.  We add a catchup mode which keeps passthrough
>>>> TSC in line with absolute guest TSC.
>>>>
>>>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>>> ---
>>>>   arch/x86/include/asm/kvm_host.h |    1 +
>>>>   arch/x86/kvm/x86.c              |   55 ++++++++++++++++++++++++++------------
>>>>   2 files changed, 38 insertions(+), 18 deletions(-)
>>>>
>>>>   	kvm_x86_ops->vcpu_load(vcpu, cpu);
>>>> -	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
>>>> +	if (unlikely(vcpu->cpu != cpu) || vcpu->arch.tsc_rebase) {
>>>>   		/* Make sure TSC doesn't go backwards */
>>>>   		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>>>>   				native_read_tsc() - vcpu->arch.last_host_tsc;
>>>>   		if (tsc_delta<   0)
>>>>   			mark_tsc_unstable("KVM discovered backwards TSC");
>>>> -		if (check_tsc_unstable())
>>>> +		if (check_tsc_unstable()) {
>>>>   			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
>>>> -		kvm_migrate_timers(vcpu);
>>>> +			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>>>> +		}
>>>> +		if (vcpu->cpu != cpu)
>>>> +			kvm_migrate_timers(vcpu);
>>>>   		vcpu->cpu = cpu;
>>>> +		vcpu->arch.tsc_rebase = 0;
>>>>   	}
>>>>   }
>>>>
>>>> @@ -1947,6 +1961,12 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>>>   	kvm_x86_ops->vcpu_put(vcpu);
>>>>   	kvm_put_guest_fpu(vcpu);
>>>>   	vcpu->arch.last_host_tsc = native_read_tsc();
>>>> +
>>>> +	/* For unstable TSC, force compensation and catchup on next CPU */
>>>> +	if (check_tsc_unstable()) {
>>>> +		vcpu->arch.tsc_rebase = 1;
>>>> +		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>>>> +	}
>>>>          
>>> The mix between catchup,trap versus stable,unstable TSC is confusing and
>>> difficult to grasp. Can you please introduce all the infrastructure
>>> first, then control usage of them in centralized places? Examples:
>>>
>>> +static void kvm_update_tsc_trapping(struct kvm *kvm)
>>> +{
>>> +       int trap, i;
>>> +       struct kvm_vcpu *vcpu;
>>> +
>>> +       trap = check_tsc_unstable()&&   atomic_read(&kvm->online_vcpus)>   1;
>>> +       kvm_for_each_vcpu(i, vcpu, kvm)
>>> +               kvm_x86_ops->set_tsc_trap(vcpu, trap&&   !vcpu->arch.time_page);
>>> +}
>>>
>>> +       /* For unstable TSC, force compensation and catchup on next CPU */
>>> +       if (check_tsc_unstable()) {
>>> +               vcpu->arch.tsc_rebase = 1;
>>> +               kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>>> +       }
>>>
>>>
>>> kvm_guest_time_update is becoming very confusing too. I understand this
>>> is due to the many cases its dealing with, but please make it as simple
>>> as possible.
>>>        
>> I tried to comment as best as I could.  I think the whole
>> "kvm_update_tsc_trapping" thing is probably a poor design choice.
>> It works, but it's thoroughly unintelligible right now without
>> spending some days figuring out why.
>>
>> I'll rework the tail series of patches to try to make them more clear.
>>
>>      
>>> +       /*
>>> +        * If we are trapping and no longer need to, use catchup to
>>> +        * ensure passthrough TSC will not be less than trapped TSC
>>> +        */
>>> +       if (vcpu->tsc_mode == TSC_MODE_PASSTHROUGH&&   vcpu->tsc_trapping&&
>>> +           ((this_tsc_khz<= v->kvm->arch.virtual_tsc_khz || kvmclock))) {
>>> +               catchup = 1;
>>>
>>> What, TSC trapping with kvmclock enabled?
>>>        
>> Transitioning to use of kvmclock after a cold boot means we may have
>> been trapping and now we will not be.
>>
>>      
>>> For both catchup and trapping the resolution of the host clock is
>>> important, as Glauber commented for kvmclock. Can you comment on the
>>> problems that arrive from a low res clock for both modes?
>>>
>>> Similarly for catchup mode, the effect of exit frequency. No need for
>>> any guarantees?
>>>        
>> The scheduler will do something to get an IRQ at whatever resolution
>> it uses for it's timeslice.  That guarantees an exit per timeslice,
>> so we'll never be behind by more than one slice while scheduling.
>> While not scheduling, we're dormant anyway, waiting on either an IRQ
>> or shared memory variable change.  Local timers could end up behind
>> when dormant.
>>
>> We may need a hack to accelerate firing of timers in such a case, or
>> perhaps bounds on when to use catchup mode and when to not.
>>      
> What about emulating rdtsc with low res clock?
>
> "The RDTSC instruction reads the time-stamp counter and is guaranteed to
> return a monotonically increasing unique value whenever executed, except
> for a 64-bit counter wraparound."
>    

Technically, that may not be quite correct.

<digression into weeds>

The RDTSC instruction will return a monotonically increasing unique 
value, but the execution and retirement of the instruction are 
unserialized.  So technically, two simultaneous RDTSC could be issued to 
multiple execution units, and they may either return the same values, or 
the earlier one may stall and complete after the latter.

rdtsc
mov %eax, %ebx
mov %edx, %ecx
rdtsc
cmp %edx, %ecx
jb fail
cmp %ebx, %eax
jae fail
jmp good
fail:
int3
good:
ret

If execution of RDTSC is restricted to a single issue unit, this can 
never fail.  If it can be issued simultaneously in multiple units, it 
can fail because register renaming may end up sorting the instruction 
stream and removing dependencies so it can be executed as:

     UNIT 1                              UNIT 2
rdtsc                                 rdtsc
mov %eax, %ebx              (store to local %edx, %eax)
mov %edx, %ecx              cmp %ebx, local %eax
                                         (commit local %edx, %eax to 
global register)
cmp %edx, %ecx
jb fail
                                          jae fail

Both failure modes can be observed if this is indeed the case.  I'm not 
aware that anything is specifically done to maintain the serialization 
internally, and as the architecture actually specifically states that 
RDTSC is unserialized, I doubt anything to prevent this situation is done.

</digression into weeds>

However, that's not the pertinent issue.  If the clock is very low res, 
we don't present a higher granularity TSC to the guest.

While there are things that can be done to ensure that (add 1 for each 
read, estimate with TSC..), they have problems of their own and in 
generally will make things very messy.

Given the above digression, I'm not sure that any code written to run 
with such guarantees is actually sound.

It is plausible, however, someone does

count of some value / (TSC2 - TSC1)

and ends up with a divide by zero.  So it may be better to bump the 
counter by at least one for each call.
