Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab0HXBOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 21:14:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab0HXBOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 21:14:44 -0400
Message-ID: <4C731CF8.2050105@redhat.com>
Date: Mon, 23 Aug 2010 15:14:32 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 33/35] Indicate reliable TSC in kvmclock
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-34-git-send-email-zamsden@redhat.com> <20100820174527.GH2937@mothafucka.localdomain>
In-Reply-To: <20100820174527.GH2937@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 07:45 AM, Glauber Costa wrote:
> On Thu, Aug 19, 2010 at 10:07:47PM -1000, Zachary Amsden wrote:
>    
>> When no platform bugs have been detected, no TSC warps have been
>> detected, and the hardware guarantees to us TSC does not change
>> rate or stop with P-state or C-state changes, we can consider it reliable.
>>
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c |   10 +++++++++-
>>   1 files changed, 9 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 86f182a..a7fa24e 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -55,6 +55,7 @@
>>   #include<asm/mce.h>
>>   #include<asm/i387.h>
>>   #include<asm/xcr.h>
>> +#include<asm/pvclock-abi.h>
>>
>>   #define MAX_IO_MSRS 256
>>   #define CR0_RESERVED_BITS						\
>> @@ -900,6 +901,13 @@ static void kvm_get_time_scale(uint32_t scaled_khz, uint32_t base_khz,
>>   static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
>>   unsigned long max_tsc_khz;
>>
>> +static inline int kvm_tsc_reliable(void)
>> +{
>> +	return (boot_cpu_has(X86_FEATURE_CONSTANT_TSC)&&
>> +		boot_cpu_has(X86_FEATURE_NONSTOP_TSC)&&
>> +		!check_tsc_unstable());
>> +}
>> +
>>   static inline u64 nsec_to_cycles(struct kvm *kvm, u64 nsec)
>>   {
>>   	return pvclock_scale_delta(nsec, kvm->arch.virtual_tsc_mult,
>> @@ -1151,7 +1159,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>>   	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
>>   	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
>>   	vcpu->last_kernel_ns = kernel_ns;
>> -	vcpu->hv_clock.flags = 0;
>> +	vcpu->hv_clock.flags = kvm_tsc_reliable() ? PVCLOCK_TSC_STABLE_BIT : 0;
>>      
> This is not enough.
>
> We still can have bugs arriving from the difference in resolution between the underlying
> clock and the tsc. What we're doing here, is to pass a reliable flag, to a non-reliable
> guest tsc. We can only trust the guest kvmclock to be tsc-stable if the host is using
> tsc clocksource as well.
>    

Is there actually an exported API to determine if clocksource is running 
on TSC and get notified when it switches?

> Since the stable bit have to be read from the guest at every clock read, we can just
> use it, and drop it if the host changes its clocksource.
>    

I know we've discussed this a bit, but with patch 16/35, Fix a possible 
backwards warp of kvmclock, I don't think you can see the backwards 
movement in an "incorrect" way within the guest.

Backwards jump for each processor must be eliminated, which is what that 
patch does.

It still allows the possibility of SMP differences, due to the 
calibration error, you may have one CPU which is slightly advanced.  You 
may in fact get a kvmclock value which is less than the previously read 
(on another CPU) kvmclock value in such a case.  The question is - is 
this calibration error of sufficient magnitude to be significant at all?

Note that even with a perfectly calibrated TSC on a stable system 
already, with no atomic lock, kvmclock already has this error built into 
it; the TSC reads of multiple processors will not be serialized with 
each other and "backwards" values can be observed globally (but not 
locally).  So the question really is, how big is the error relative to 
the TSC rate, and is it significant enough to matter.

Obviously that changes for different host clocks, and in principle I 
agree with you; it could very well be significant.  However, we have no 
clear API from clocksource to use effectively for this (indeed, in some 
cases, with jiffies clock, it isn't even clear what the API should do).

We could use more 'magic' trickery to keep kvmclock values aligned, 
matching the system_time and tsc_timestamp when setting up SMP kvmclocks 
on a host which has 'stable TSC'.

> An alternative for the reliable tsc case, would be to just maintain our own parallel
> tsc-based clock. But to be honest, I don't like this solution very much. It adds
> complexity, and I kinda believe that if the sysadmin had the work to go there
> and switch clocksources, he probably has a reason for that.
>    

I originally went down that route, and it got ugly, ugly, ugly.

In any case, you are right, this patch needs to be held for further 
discussion.

Zach
