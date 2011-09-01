Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab1IAITQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:19:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab1IAITL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:19:11 -0400
Message-ID: <4E5F3FF7.8010805@redhat.com>
Date: Thu, 01 Sep 2011 10:19:03 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Red Hat/3.1.12-1.el6_1 Lightning/1.0b2 Thunderbird/3.1.12
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH] xen: x86_32: do not enable iterrupts when returning from
 exception in interrupt context
References: <20110829194633.GB16530@dumpdata.com> <1314834438-3181-1-git-send-email-imammedo@redhat.com> <4E5EB794.7050909@goop.org>
In-Reply-To: <4E5EB794.7050909@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 12:37 AM, Jeremy Fitzhardinge wrote:
> On 08/31/2011 04:47 PM, Igor Mammedov wrote:
>> If vmalloc page_fault happens inside of interrupt handler with interrupts
>> disabled then on exit path from exception handler when there is no pending
>> interrupts, the following code (arch/x86/xen/xen-asm_32.S:112):
>>
>> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
>> 	sete XEN_vcpu_info_mask(%eax)
>>
>> will enable interrupts even if they has been previously disabled according to
>> eflags from the bounce frame (arch/x86/xen/xen-asm_32.S:99)
>>
>> 	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
>> 	setz XEN_vcpu_info_mask(%eax)
>>
>> Solution is in setting XEN_vcpu_info_mask only when it should be set
>> according to
>> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
>> but not clearing it if there isn't any pending events.
>
> Wow, that's a great find.  I guess it shows how rarely we end up doing
> an exception return with interrupts disabled, since that's been there
> since, erm, 2.6.23?
>
> But this could definitely explain some bugs where interrupts became
> unexpectedly re-enabled.  Were you tracking one down when you found this?
>
>> Signed-off-by: Igor Mammedov<imammedo@redhat.com>
>> ---
>>   arch/x86/xen/xen-asm_32.S |    6 +++++-
>>   1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
>> index 22a2093..313dca7 100644
>> --- a/arch/x86/xen/xen-asm_32.S
>> +++ b/arch/x86/xen/xen-asm_32.S
>> @@ -113,10 +113,14 @@ xen_iret_start_crit:
>>
>>   	/*
>>   	 * If there's something pending, mask events again so we can
>> -	 * jump back into xen_hypervisor_callback
>> +	 * jump back into xen_hypervisor_callback. Otherwise do not
>> +	 * touch XEN_vcpu_info_mask.
>>   	 */
>> +	jne ignore_vcpu_info_mask
>>   	sete XEN_vcpu_info_mask(%eax)
>>
>> +ignore_vcpu_info_mask:
>> +
>
> This should be:
>
> 	jne 1f
> 	movb $1, XEN_vcpu_info_mask(%eax)
>
> 1:	popl %eax
>
>
> There's no point in using sete if we're already using a conditional jump
> to avoid the write, and it's better to use local labels for little
> control flow changes like this.
>
> Thanks,
>
       J
Jeremy,

Thanks for review, I'll re-post it soon.
