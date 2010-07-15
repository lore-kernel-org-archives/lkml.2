Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab0GOBaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 21:30:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58285 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab0GOBaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 21:30:07 -0400
X-User-Agent: K-9 Mail for Android
References: <4C3E363B.7060804@goop.org> <4C3E5637.4010300@redhat.com> <4C3E5C8C.8000800@goop.org>
In-Reply-To: <4C3E5C8C.8000800@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: fix ordering constraints on crX read/writes
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 14 Jul 2010 20:29:25 -0500
To: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zamsden@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <b6d9e574-daf5-4aaa-b76e-4a7e66d0fa97@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it will definitely NOT be pruned.  I'm going to file a gcc documentation request to see if any of this is actually needed, though.  There may also be a need for gcc to handle *inbound* general memory constraints.

"Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

>On 07/14/2010 05:28 PM, Zachary Amsden wrote:
>>
>>>   static inline void native_write_cr2(unsigned long val)
>>>   {
>>> -    asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
>>> +    asm volatile("mov %1,%%cr2": "+m" (__force_order) : "r" (val) :
>>> "memory");
>>>   }
>>>    
>>
>>
>> You don't need the memory clobber there.  Technically, this should
>> never be used, however.
>
>Yes.  I just did it for consistency.  Likewise, I didn't pore over the
>manuals to work out whether writes to any crX could really have memory
>side-effects.
>
>>>
>>>   static inline unsigned long native_read_cr3(void)
>>>   {
>>>       unsigned long val;
>>> -    asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m"
>>> (__force_order));
>>> +    asm volatile("mov %%cr3,%0\n\t" : "=r" (val) : "m"
>>> (__force_order));
>>>       return val;
>>>   }
>>>
>>>   static inline void native_write_cr3(unsigned long val)
>>>   {
>>> -    asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
>>> +    asm volatile("mov %1,%%cr3": "+m" (__force_order) : "r" (val) :
>>> "memory");
>>>   }
>>>
>>>   static inline unsigned long native_read_cr4(void)
>>>   {
>>>       unsigned long val;
>>> -    asm volatile("mov %%cr4,%0\n\t" : "=r" (val), "=m"
>>> (__force_order));
>>> +    asm volatile("mov %%cr4,%0\n\t" : "=r" (val) : "m"
>>> (__force_order));
>>>       return val;
>>>   }
>>>
>>> @@ -271,7 +286,7 @@ static inline unsigned long
>>> native_read_cr4_safe(void)
>>>       asm volatile("1: mov %%cr4, %0\n"
>>>                "2:\n"
>>>                _ASM_EXTABLE(1b, 2b)
>>> -             : "=r" (val), "=m" (__force_order) : "0" (0));
>>> +             : "=r" (val) : "m" (__force_order), "0" (0));
>>>   #else
>>>       val = native_read_cr4();
>>>   #endif
>>> @@ -280,7 +295,7 @@ static inline unsigned long
>>> native_read_cr4_safe(void)
>>>
>>>   static inline void native_write_cr4(unsigned long val)
>>>   {
>>> -    asm volatile("mov %0,%%cr4": : "r" (val), "m" (__force_order));
>>> +    asm volatile("mov %1,%%cr4": "+m" (__force_order) : "r" (val) :
>>> "memory");
>>>   }
>>>
>>>   #ifdef CONFIG_X86_64
>>>
>>>
>>>    
>>
>> Looks good.  I really hope __force_order gets pruned however.  Does it
>> actually?
>
>There's a couple of instances in my vmlinux.  I didn't try to track them
>back to specific .o files.  gcc tends to generate references by putting
>its address into a register and passing that into the asms.
>
>    J
>

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
