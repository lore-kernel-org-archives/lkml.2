Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936532Ab0GSUj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 16:39:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936513Ab0GSUj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 16:39:56 -0400
Message-ID: <4C44B819.2030203@redhat.com>
Date: Mon, 19 Jul 2010 10:39:53 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/18] Robust TSC compensation
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-10-git-send-email-zamsden@redhat.com> <4C431546.9030906@redhat.com>
In-Reply-To: <4C431546.9030906@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2010 04:52 AM, Avi Kivity wrote:
> On 07/13/2010 05:25 AM, Zachary Amsden wrote:
>> Make the match of TSC find TSC writes that are close to each other
>> instead of perfectly identical; this allows the compensator to also
>> work in migration / suspend scenarios.
>>
>
> What scenario exactly?

After migration, qemu will write back MSRs, including TSC to the VCPUs.  
They won't have exactly matching values, because they get read out at 
different times (actually, because the TSC for the VCPUs never stops, 
they can have wildly different times if there was some host overload / 
swap / suspend event).

When restarting the CPUs, qemu will try to write back the TSC and then 
we end up desynchronizing the system.

It's an ugly problem, and this is an ugly solution.

Better would be to "stop" the VCPUs (requires some kernel 
synchronization to determine TSC stop point), or to simply take the 
maximum TSC in qemu and write that to all of the CPUs (this assumes the 
guest wants to have TSCs in sync at all).

Both methods have to assume small deltas in TSC are unintentional 
effects in order to correctly resynchronize.

>
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -926,21 +926,27 @@ void guest_write_tsc(struct kvm_vcpu *vcpu, u64 
>> data)
>>       struct kvm *kvm = vcpu->kvm;
>>       u64 offset, ns, elapsed;
>>       struct timespec ts;
>> +    s64 sdiff;
>>
>>       spin_lock(&kvm->arch.tsc_write_lock);
>>       offset = data - native_read_tsc();
>>       ns = get_kernel_ns();
>>       elapsed = ns - kvm->arch.last_tsc_nsec;
>> +    sdiff = data - kvm->arch.last_tsc_write;
>> +    if (sdiff<  0)
>> +        sdiff = -sdiff;
>>
>>       /*
>> -     * Special case: identical write to TSC within 5 seconds of
>> +     * Special case: close write to TSC within 5 seconds of
>>        * another CPU is interpreted as an attempt to synchronize
>> -     * (the 5 seconds is to accomodate host load / swapping).
>> +     * The 5 seconds is to accomodate host load / swapping as
>> +     * well as any reset of TSC during the boot process.
>>        *
>>        * In that case, for a reliable TSC, we can match TSC offsets,
>> -     * or make a best guest using kernel_ns value.
>> +     * or make a best guest using elapsed value.
>>        */
>> -    if (data == kvm->arch.last_tsc_write&&  elapsed<  5ULL * 
>> NSEC_PER_SEC) {
>> +    if (sdiff<  nsec_to_cycles(5ULL * NSEC_PER_SEC)&&
>> +        elapsed<  5ULL * NSEC_PER_SEC) {
>>           if (!check_tsc_unstable()) {
>>               offset = kvm->arch.last_tsc_offset;
>>               pr_debug("kvm: matched tsc offset for %llu\n", data);
>
> Don't we have to adjust offset to the required different between tsc?  
> Or do we assume, that if the guest wrote close enough values, it is 
> trying to cleverly compensate for IPI latency?
>

No, we have to assume that any small (small being defined as < 5 second) 
difference is unintentional.  It's not perfect and is certainly error 
prone (without one of the two assists from qemu that I mention above).

I think qemu should probably take the maximum TSC and apply it to all VCPUs.

Zach
