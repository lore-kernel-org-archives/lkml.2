Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab0GOBAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 21:00:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878Ab0GOBAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 21:00:46 -0400
Message-ID: <4C3E5DB4.6020000@redhat.com>
Date: Wed, 14 Jul 2010 15:00:36 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Glauber Costa <glommer@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix ordering constraints on crX read/writes
References: <4C3E363B.7060804@goop.org> <4C3E5637.4010300@redhat.com> <4C3E5C8C.8000800@goop.org>
In-Reply-To: <4C3E5C8C.8000800@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 02:55 PM, Jeremy Fitzhardinge wrote:
> On 07/14/2010 05:28 PM, Zachary Amsden wrote:
>    
>>      
>>>    static inline void native_write_cr2(unsigned long val)
>>>    {
>>> -    asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
>>> +    asm volatile("mov %1,%%cr2": "+m" (__force_order) : "r" (val) :
>>> "memory");
>>>    }
>>>
>>>        
>>
>> You don't need the memory clobber there.  Technically, this should
>> never be used, however.
>>      
> Yes.  I just did it for consistency.  Likewise, I didn't pore over the
> manuals to work out whether writes to any crX could really have memory
> side-effects.
>    

0,3,4 all can.

>>>    static inline unsigned long native_read_cr3(void)
>>>    {
>>>        unsigned long val;
>>> -    asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m"
>>> (__force_order));
>>> +    asm volatile("mov %%cr3,%0\n\t" : "=r" (val) : "m"
>>> (__force_order));
>>>        return val;
>>>    }
>>>
>>>    static inline void native_write_cr3(unsigned long val)
>>>    {
>>> -    asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
>>> +    asm volatile("mov %1,%%cr3": "+m" (__force_order) : "r" (val) :
>>> "memory");
>>>    }
>>>
>>>    static inline unsigned long native_read_cr4(void)
>>>    {
>>>        unsigned long val;
>>> -    asm volatile("mov %%cr4,%0\n\t" : "=r" (val), "=m"
>>> (__force_order));
>>> +    asm volatile("mov %%cr4,%0\n\t" : "=r" (val) : "m"
>>> (__force_order));
>>>        return val;
>>>    }
>>>
>>> @@ -271,7 +286,7 @@ static inline unsigned long
>>> native_read_cr4_safe(void)
>>>        asm volatile("1: mov %%cr4, %0\n"
>>>                 "2:\n"
>>>                 _ASM_EXTABLE(1b, 2b)
>>> -             : "=r" (val), "=m" (__force_order) : "0" (0));
>>> +             : "=r" (val) : "m" (__force_order), "0" (0));
>>>    #else
>>>        val = native_read_cr4();
>>>    #endif
>>> @@ -280,7 +295,7 @@ static inline unsigned long
>>> native_read_cr4_safe(void)
>>>
>>>    static inline void native_write_cr4(unsigned long val)
>>>    {
>>> -    asm volatile("mov %0,%%cr4": : "r" (val), "m" (__force_order));
>>> +    asm volatile("mov %1,%%cr4": "+m" (__force_order) : "r" (val) :
>>> "memory");
>>>    }
>>>
>>>    #ifdef CONFIG_X86_64
>>>
>>>
>>>
>>>        
>> Looks good.  I really hope __force_order gets pruned however.  Does it
>> actually?
>>      
> There's a couple of instances in my vmlinux.  I didn't try to track them
> back to specific .o files.  gcc tends to generate references by putting
> its address into a register and passing that into the asms.
>    

Can you make it extern so at least there's only one in the final bss?
