Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab0FPWgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 18:36:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0FPWgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 18:36:21 -0400
Message-ID: <4C1951E1.70301@redhat.com>
Date: Wed, 16 Jun 2010 12:36:17 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] TSC reset compensation
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-17-git-send-email-zamsden@redhat.com> <20100616135211.GL19104@mothafucka.localdomain>
In-Reply-To: <20100616135211.GL19104@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 03:52 AM, Glauber Costa wrote:
> On Mon, Jun 14, 2010 at 09:34:18PM -1000, Zachary Amsden wrote:
>    
>> Attempt to synchronize TSCs which are reset to the same value.  In the
>> case of a reliable hardware TSC, we can just re-use the same offset, but
>> on non-reliable hardware, we can get closer by adjusting the offset to
>> match the elapsed time.
>>
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c |   34 ++++++++++++++++++++++++++++++++--
>>   1 files changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 8e836e9..cedb71f 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -937,14 +937,44 @@ static inline void kvm_request_guest_time_update(struct kvm_vcpu *v)
>>   	set_bit(KVM_REQ_CLOCK_SYNC,&v->requests);
>>   }
>>
>> +static inline int kvm_tsc_reliable(void)
>> +{
>> +	return (boot_cpu_has(X86_FEATURE_CONSTANT_TSC)&&
>> +		boot_cpu_has(X86_FEATURE_NONSTOP_TSC)&&
>> +		!check_tsc_unstable());
>> +}
>> +
>>      
> why can't we re-use vmware TSC_RELIABLE flag?
>    

It's only set for VMware.  Basically, it means "you are running in a 
VMware hypervisor, TSC is reliable".  Which KVM won't ever be, at least, 
not in production use, so it doesn't make that sort of sense here.  
Besides, a system with a reliable TSC can become a system without  a 
reliable TSC : CPU hotplug will always guarantee this.

We could, however, have the guest set the TSC_RELIABLE flag for itself 
if KVM somehow makes that promise (currently, it does not).

Zach
