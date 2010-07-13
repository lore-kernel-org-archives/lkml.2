Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab0GMVPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:15:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab0GMVPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:15:42 -0400
Message-ID: <4C3CD77B.9050108@redhat.com>
Date: Tue, 13 Jul 2010 11:15:39 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/18] Robust TSC compensation
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-10-git-send-email-zamsden@redhat.com> <20100713203418.GA903@amt.cnet>
In-Reply-To: <20100713203418.GA903@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 10:34 AM, Marcelo Tosatti wrote:
> On Mon, Jul 12, 2010 at 04:25:29PM -1000, Zachary Amsden wrote:
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
>> index 79c4608..51d3f3e 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -926,21 +926,27 @@ void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>>   	struct kvm *kvm = vcpu->kvm;
>>   	u64 offset, ns, elapsed;
>>   	struct timespec ts;
>> +	s64 sdiff;
>>
>>   	spin_lock(&kvm->arch.tsc_write_lock);
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
>>   			offset = kvm->arch.last_tsc_offset;
>>   			pr_debug("kvm: matched tsc offset for %llu\n", data);
>>      
> What prevents a vcpu from seeing its TSC go backwards, in case the first
> write in the 5 second window is smaller than the victim vcpu's last
> visible TSC value ?
>    

Nothing, unfortunately.  However, the TSC would already have to be out 
of sync in order for the problem to occur.  It can never happen in 
normal circumstances on a stable hardware TSC except in one case; 
migration.  During the CPU state transfer phase of migration, however, 
all the VCPUs should already be stopped, so the maximum TSC that can be 
observed by any CPU is bounded.

The problem, of course is that the TSC write will latch the first TSC to 
be written, which, if you stop in order, and start in order, will be the 
lowest TSC; so later VCPUs can observe a negative TSC drift (timing is 
additionally complicated by the VCPU teardown / create time).

There are a couple solutions; some of which are ugly and some of which 
are very ugly.

1) Make some global state available about whether the VM is running or 
not, use the global TSC lock and record the last TSC when the VM is 
stopped.  Return this TSC from any reads when the VM is stopped.  I'm 
not sure the kernel model is equipped to do this properly; in theory, 
userspace could stop and start running VCPUs using the ioctls whenever 
it feels like and requires no protocol to do so.

2) Make userspace deal with it; when starting up a VM, read the VCPU 
state for all VCPUs in first, then take the maximum TSC and set all TSCs 
to this value before starting the VCPUs.  I'm not sure the userspace 
model is equipped to do this properly, it could start running earlier 
CPUs before reading later CPU states...

3) Drop passthrough TSC altogether and switch to trap / emulate TSC.

4) Pray to a deity of your choice.

Of course, none of these solutions work for a guest which deliberately 
runs with desynchronized TSCs, but we needn't really be concerned with 
that, no guest does it on purpose.
