Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0LWRsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:48:54 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:54580 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab0LWRsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:48:53 -0500
References: <153445735.411361293110429680.JavaMail.root@zimbra-corp-1-b8>
In-Reply-To: <153445735.411361293110429680.JavaMail.root@zimbra-corp-1-b8>
Mime-Version: 1.0 (iPhone Mail 8C148)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=utf-8
Message-Id: <41A13AA7-7CC7-4AA7-858A-ED00DAF24BEB@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "sodaville@linutronix.de" <sodaville@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Florian Fainelli <ffainelli@freebox.fr>
X-Mailer: iPhone Mail (8C148)
From: Yinghai <yinghai@kernel.org>
Subject: Re: [PATCH] x86/trampoline: fallback to fixed trampoline address if no e820 map is provided
Date: Thu, 23 Dec 2010 09:46:38 -0800
To: Florian Fainelli <ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you check if you can add ce4100 own memory_setup() and install it into x86_init.resources.memory_setup in x86_ce4100_early_setup?

Thanks

On Dec 23, 2010, at 5:20 AM, Florian Fainelli <ffainelli@freebox.fr> wrote:

> 
> ----- "Yinghai" <yinghai@kernel.org> a écrit :
> 
>> On Dec 23, 2010, at 1:57 AM, Florian Fainelli <ffainelli@freebox.fr>
>> wrote:
>> 
>>> On Tuesday 14 December 2010 22:19:39 Florian Fainelli wrote:
>>>> From: Florian Fainelli <ffainelli@freebox.fr>
>>>> 
>>>> Since 893f38d1 (x86: Use find_e820() instead of hard coded
>> trampoline
>>>> address), the trampoline base address should be provided by the
>> BIOS as an
>>>> e820 area. Some minimalistic BIOSes (like CEFDK on CE4100) may not
>> provide
>>>> any e820 area, still we should fallback to a fixed trampoline base
>> address
>>>> for SMP to work correctly.
>> 
>> No e820 memmap ?
> 
> Yes, the BIOS is only doing the very minimal setup to get a kernel in real-mode booting.
> 
>> 
>> Not sure how does it work
>> 
>> Do you have boot log with debug ?
> 
> I would need to produce one for you, give me a couple days to be in sync.
> 
>> 
>> Also recent kernel is using memblock already for finding free area.
>> 
>> Thanks
>> 
>> 
>> 
>>>> 
>>>> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
>>>> Cc: sodaville@linutronix.de
>>>> Cc: Ingo Molnar <mingo@elte.hu>
>>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>>> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
>>> 
>>> Ingo, Yinghai, anything wrong with that patch? Thank you.
>>> 
>>>> ---
>>>> diff --git a/arch/x86/include/asm/trampoline.h
>>>> b/arch/x86/include/asm/trampoline.h index f4500fb..908b395 100644
>>>> --- a/arch/x86/include/asm/trampoline.h
>>>> +++ b/arch/x86/include/asm/trampoline.h
>>>> @@ -16,6 +16,7 @@ extern unsigned long initial_code;
>>>> extern unsigned long initial_gs;
>>>> 
>>>> #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data,
>>>> PAGE_SIZE) +#define TRAMPOLINE_BASE 0x6000
>>>> 
>>>> extern unsigned long setup_trampoline(void);
>>>> extern void __init reserve_trampoline_memory(void);
>>>> diff --git a/arch/x86/kernel/trampoline.c
>> b/arch/x86/kernel/trampoline.c
>>>> index f1488a3..d025aae 100644
>>>> --- a/arch/x86/kernel/trampoline.c
>>>> +++ b/arch/x86/kernel/trampoline.c
>>>> @@ -21,8 +21,11 @@ void __init reserve_trampoline_memory(void)
>>>> 
>>>>   /* Has to be in very low memory so we can execute real-mode AP
>> code. */
>>>>   mem = find_e820_area(0, 1<<20, TRAMPOLINE_SIZE, PAGE_SIZE);
>>>> -    if (mem == -1L)
>>>> -        panic("Cannot allocate trampoline\n");
>>>> +    if (mem == -1L) {
>>>> +        printk(KERN_INFO "BIOS did not provide e820 area for
>> trampoline"
>>>> +                " ,using static trampoline address\n");
>>>> +        mem = TRAMPOLINE_BASE;
>>>> +    }
>>>> 
>>>>   trampoline_base = __va(mem);
>>>>   reserve_early(mem, mem + TRAMPOLINE_SIZE, "TRAMPOLINE");
