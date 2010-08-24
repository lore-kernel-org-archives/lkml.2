Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0HXBBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 21:01:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab0HXBBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 21:01:39 -0400
Message-ID: <4C7319E0.906@redhat.com>
Date: Mon, 23 Aug 2010 15:01:20 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 12/35] Robust TSC compensation
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-13-git-send-email-zamsden@redhat.com> <20100820174044.GG2937@mothafucka.localdomain>
In-Reply-To: <20100820174044.GG2937@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 07:40 AM, Glauber Costa wrote:
> On Thu, Aug 19, 2010 at 10:07:26PM -1000, Zachary Amsden wrote:
>    
>> Make the match of TSC find TSC writes that are close to each other
>> instead of perfectly identical; this allows the compensator to also
>> work in migration / suspend scenarios.
>>
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c |   14 ++++++++++----
>>   1 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 52680f6..0f3e5fb 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -928,21 +928,27 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>>   	struct kvm *kvm = vcpu->kvm;
>>   	u64 offset, ns, elapsed;
>>   	unsigned long flags;
>> +	s64 sdiff;
>>
>>   	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
>>   	offset = data - native_read_tsc();
>>   	ns = get_kernel_ns();
>>   	elapsed = ns - kvm->arch.last_tsc_nsec;
>> +	sdiff = data - kvm->arch.last_tsc_write;
>> +	if (sdiff<  0)
>> +		sdiff = -sdiff;
>>
>>   	/*
>> -	 * Special case: identical write to TSC within 5 seconds of
>> +	 * Special case: close write to TSC within 5 seconds of
>>   	 * another CPU is interpreted as an attempt to synchronize
>> -	 * (the 5 seconds is to accomodate host load / swapping).
>> +	 * The 5 seconds is to accomodate host load / swapping as
>> +	 * well as any reset of TSC during the boot process.
>>   	 *
>>   	 * In that case, for a reliable TSC, we can match TSC offsets,
>> -	 * or make a best guest using kernel_ns value.
>> +	 * or make a best guest using elapsed value.
>>   	 */
>> -	if (data == kvm->arch.last_tsc_write&&  elapsed<  5ULL * NSEC_PER_SEC) {
>> +	if (sdiff<  nsec_to_cycles(5ULL * NSEC_PER_SEC)&&
>> +	    elapsed<  5ULL * NSEC_PER_SEC) {
>>   		if (!check_tsc_unstable()) {
>>      
> Isn't 5 way too long for this case?
>
>
>    

It was actually too short for a while, and I didn't realize why until I 
discovered on SVM, the APs were getting the TSC reset after the startup IPI.

In any case, the value is certainly up for debate.  I chose a large 
number because who knows how badly things can get off in the case of 
host overcommit / swapping.

Zach
