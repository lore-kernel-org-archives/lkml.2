Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab1ADVud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:50:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab1ADVuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:50:32 -0500
Message-ID: <4D239624.3010905@redhat.com>
Date: Tue, 04 Jan 2011 11:50:28 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM Clock Synchronization 4/4] Add master clock for KVM clock
References: <1293601100-32109-1-git-send-email-zamsden@redhat.com> <1293601100-32109-5-git-send-email-zamsden@redhat.com> <20110104182030.GA3220@amt.cnet>
In-Reply-To: <20110104182030.GA3220@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 08:20 AM, Marcelo Tosatti wrote:
> On Tue, Dec 28, 2010 at 07:38:20PM -1000, Zachary Amsden wrote:
>    
>> On systems with synchronized TSCs, we still have VCPU individual
>> KVM clocks, each with their own computed offset.  As this all happens
>> at different times, the computed KVM clock offset can vary, causing a
>> globally visible backwards clock.  Currently this is protected against
>> by using an atomic compare to ensure it does not happen.
>>
>> This change should remove that requirement.
>>
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |    1 +
>>   arch/x86/kvm/x86.c              |   42 ++++++++++++++++++++++++++++++++++++++-
>>   2 files changed, 42 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 8d829b8..ff651b7 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -445,6 +445,7 @@ struct kvm_arch {
>>   	unsigned long irq_sources_bitmap;
>>   	s64 kvmclock_offset;
>>   	spinlock_t clock_lock;
>> +	struct pvclock_vcpu_time_info master_clock;
>>   	u64 last_tsc_nsec;
>>   	u64 last_tsc_offset;
>>   	u64 last_tsc_write;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 59d5999..a339e50 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1116,6 +1116,38 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>>   		return 0;
>>
>>   	/*
>> +	 * If there is a stable TSC, we use a master reference clock for
>> +	 * the KVM clock; otherwise, individual computations for each VCPU
>> +	 * would exhibit slight drift relative to each other, which could
>> +	 * cause global time to go backwards.
>> +	 *
>> +	 * If the master clock has no TSC timestamp, that means we must
>> +	 * recompute the clock as either some real time has elapsed during
>> +	 * a suspend cycle, or we are measuring the clock for the first time
>> +	 * during VM creation (or following a migration).  Since master clock
>> +	 * changes should happen only at rare occasions, so we can ignore
>> +	 * the precautions below.
>> +	 */
>> +	if (!check_tsc_unstable()) {
>> +		struct pvclock_vcpu_time_info *master =
>> +						&v->kvm->arch.master_clock;
>> +		if (vcpu->hv_clock.version != master->version) {
>> +			spin_lock(&v->kvm->arch.clock_lock);
>> +			WARN_ON(master->version<  vcpu->hv_clock.version);
>> +			if (!master->tsc_timestamp) {
>> +				pr_debug("KVM: computing new master clock\n");
>> +				update_pvclock(v, master, tsc_timestamp,
>> +						kernel_ns, tsc_khz);
>> +			}
>> +			memcpy(&vcpu->hv_clock, master, sizeof(*master));
>> +			spin_unlock(&v->kvm->arch.clock_lock);
>> +			update_user_kvmclock(v,&vcpu->hv_clock);
>> +		} else
>> +			pr_debug("ignoring spurious KVM clock update");
>> +		return 0;
>> +	}
>>      
> This assumes guest TSC is synchronized across vcpus... Is this always
> true?
>    

By the kernel definition of stable TSC, yes.

> Also, for stable TSC hosts, kvmclock update is performed only on VM
> creation / host resume these days... Can you describe the problem in
> more detail?
>    

The problem is that even if it is done only once, all the VCPUs perform 
the kvmclock update at different times, so they measure different 
kernel_ns values and hardware TSC values.  There will be a spread of 
measurement there, which is only +/- a few hundred cycles, but since 
there is a difference, the global view of kvm clock across multiple 
VCPUs can go backwards.

Zach
