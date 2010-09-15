Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab0IOEHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 00:07:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab0IOEHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 00:07:48 -0400
Message-ID: <4C904685.9090402@redhat.com>
Date: Tue, 14 Sep 2010 18:07:33 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-11-git-send-email-zamsden@redhat.com> <4C8F3C03.50306@siemens.com>
In-Reply-To: <4C8F3C03.50306@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 11:10 PM, Jan Kiszka wrote:
> Am 20.08.2010 10:07, Zachary Amsden wrote:
>    
>> When CPUs with unstable TSCs enter deep C-state, TSC may stop
>> running.  This causes us to require resynchronization.  Since
>> we can't tell when this may potentially happen, we assume the
>> worst by forcing re-compensation for it at every point the VCPU
>> task is descheduled.
>>
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 7fc4a55..52b6c21 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1866,7 +1866,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>   	}
>>
>>   	kvm_x86_ops->vcpu_load(vcpu, cpu);
>> -	if (unlikely(vcpu->cpu != cpu)) {
>> +	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
>>   		/* Make sure TSC doesn't go backwards */
>>   		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>>   				native_read_tsc() - vcpu->arch.last_host_tsc;
>>      
> For yet unknown reason, this commit breaks Linux guests here if they are
> started with only a single VCPU. They hang during boot, obviously no
> longer receiving interrupts.
>
> I'm using kvm-kmod against a 2.6.34 host kernel, so this may be a side
> effect of the wrapping, though I cannot imagine how.
>
> Anyone any ideas?
>    

Question: how did you come to the knowledge that this is the commit 
which breaks things?  I'm assuming you bisected, in which case a 
transition from stable -> unstable would have only happened once.  This 
also means the PM suspend event which you observed only happened once, 
so obviously if you bisected successfully, there is a bug which doesn't 
involved the PM transition or the stable -> unstable transition.

Your host TSC must have desynchronized during the PM transition, and 
this change compensates the TSC on an unstable host to effectively show 
run time, not real time.  Perhaps the lack of catchup code (to catch 
back up to real time) is triggering the bug.

In any case, I'll proceed with the forcing of unstable TSC and HPET 
clocksource and see what happens.

Zach
