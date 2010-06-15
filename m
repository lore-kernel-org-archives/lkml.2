Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab0FOUcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:32:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab0FOUcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:32:41 -0400
Message-ID: <4C17E366.9060704@redhat.com>
Date: Tue, 15 Jun 2010 10:32:38 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: mtosatti@redhat.com, glommer@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] TSC reset compensation
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-17-git-send-email-zamsden@redhat.com> <4C173EF8.8090306@redhat.com>
In-Reply-To: <4C173EF8.8090306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 10:51 PM, Avi Kivity wrote:
> On 06/15/2010 10:34 AM, Zachary Amsden wrote:
>> Attempt to synchronize TSCs which are reset to the same value.  In the
>> case of a reliable hardware TSC, we can just re-use the same offset, but
>> on non-reliable hardware, we can get closer by adjusting the offset to
>> match the elapsed time.
>>
>
> Answers a question from earlier.
>
> I wonder about guests that might try to be clever an compensate for 
> the IPI round trip, so not writing the same value.  On the other hand, 
> really clever guests will synchronize though memory, not an IPI.

Really, really clever guests will use an NMI so as to block further NMIs 
and then synchronize through memory from the NMI handler.  Or an SMI, if 
they have enough understanding of the chipset to make it work.

>
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c |   34 ++++++++++++++++++++++++++++++++--
>>   1 files changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 8e836e9..cedb71f 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -937,14 +937,44 @@ static inline void 
>> kvm_request_guest_time_update(struct kvm_vcpu *v)
>>       set_bit(KVM_REQ_CLOCK_SYNC,&v->requests);
>>   }
>>
>> +static inline int kvm_tsc_reliable(void)
>> +{
>> +    return (boot_cpu_has(X86_FEATURE_CONSTANT_TSC)&&
>> +        boot_cpu_has(X86_FEATURE_NONSTOP_TSC)&&
>> +        !check_tsc_unstable());
>> +}
>> +
>>   void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>>   {
>>       struct kvm *kvm = vcpu->kvm;
>> -    u64 offset;
>> +    u64 offset, ns, elapsed;
>>
>>       spin_lock(&kvm->arch.tsc_write_lock);
>>       offset = data - native_read_tsc();
>> -    kvm->arch.last_tsc_nsec = get_kernel_ns();
>> +    ns = get_kernel_ns();
>> +    elapsed = ns - kvm->arch.last_tsc_nsec;
>> +
>> +    /*
>> +     * Special case: identical write to TSC within 5 seconds of
>> +     * another CPU is interpreted as an attempt to synchronize
>> +     * (the 5 seconds is to accomodate host load / swapping).
>> +     *
>> +     * In that case, for a reliable TSC, we can match TSC offsets,
>> +     * or make a best guest using kernel_ns value.
>> +     */
>> +    if (data == kvm->arch.last_tsc_write&&  elapsed<  5 * 
>> NSEC_PER_SEC) {
>
> 5e9 will overflow on i386.

Better make it 4 ;)

>
>> +        if (kvm_tsc_reliable()) {
>> +            offset = kvm->arch.last_tsc_offset;
>> +            pr_debug("kvm: matched tsc offset for %llu\n", data);
>> +        } else {
>> +            u64 tsc_delta = elapsed * __get_cpu_var(cpu_tsc_khz);
>> +            tsc_delta = tsc_delta / USEC_PER_SEC;
>> +            offset -= tsc_delta;
>> +            pr_debug("kvm: adjusted tsc offset by %llu\n", tsc_delta);
>> +        }
>> +        ns = kvm->arch.last_tsc_nsec;
>> +    }
>> +    kvm->arch.last_tsc_nsec = ns;
>
> Shouldn't we check that the older write was on a different vcpu?

I thought about it; the pattern isn't necessarily the same with every OS 
(or even every qemu-kvm binary), but at least on AMD hardware, we see 6 
writes of the TSC for a 2-VCPU VM.  Two are done from ioctls for each 
VCPU at creation and setup time.  The other two are triggered by the 
INIT and STARTUP IPI signals for each AP from the Linux bootup code.

So if we want to keep the APs in sync with the BSP, they must tolerate 
four resets in a row of the TSC on a single CPU.  We could eliminate the 
second setup_vcpu reset with refactoring and choose not to reset the TSC 
for SIPI signals, but for now this seems the simplest and best approach.
