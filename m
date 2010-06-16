Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0FPIHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:07:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab0FPIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:07:15 -0400
Message-ID: <4C18877E.9070605@redhat.com>
Date: Wed, 16 Jun 2010 16:12:46 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 12/17] Add helper function get_kernel_ns
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-13-git-send-email-zamsden@redhat.com> <4C173CC3.8000506@redhat.com> <4C17EAA5.90009@redhat.com>
In-Reply-To: <4C17EAA5.90009@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> On 06/14/2010 10:41 PM, Avi Kivity wrote:
>   
>> On 06/15/2010 10:34 AM, Zachary Amsden wrote:
>>     
>>> Add a helper function for the multiple places this is used.  Note 
>>> that it
>>> must not be called in preemptible context, as that would mean the kernel
>>> could enter software suspend state, which would cause non-atomic 
>>> operation
>>> of the monotonic_to_bootbased computation.
>>>
>>> Open question: should the KVM_SET_CLOCK / KVM_GET_CLOCK ioctls use this
>>> as well?  Currently, they are not bootbased (but perhaps should be).
>>>
>>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>> ---
>>>   arch/x86/kvm/x86.c |   26 +++++++++++++-------------
>>>   1 files changed, 13 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 703ea43..15c7317 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -915,6 +915,16 @@ static void kvm_get_time_scale(uint32_t 
>>> scaled_khz, uint32_t base_khz,
>>>            __func__, base_khz, scaled_khz, shift, *pmultiplier);
>>>   }
>>>
>>> +static inline u64 get_kernel_ns(void)
>>> +{
>>> +    struct timespec ts;
>>> +
>>> +    WARN_ON(preemptible());
>>> +    ktime_get_ts(&ts);
>>> +    monotonic_to_bootbased(&ts);
>>> +    return timespec_to_ns(&ts);
>>> +}
>>> +
>>>   static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
>>>
>>>       
>> Isn't something like this a candidate for the time infrastructure?
>>
>>     
>
> Should it be?  It certainly seems reasonable.
>
>
> Also, should we be using it for the cases KVM_GET_CLOCK / 
> KVM_SET_CLOCK?  It seems global kvmclock_offset for the VM ignores the 
> bootbased conversion.
>
>   
Yes we should.
> Zach
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

