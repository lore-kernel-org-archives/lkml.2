Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0LWN0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:26:23 -0500
Received: from zmc.proxad.net ([212.27.53.206]:50833 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab0LWN0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:26:22 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2010 08:26:21 EST
X-Spam-Flag: NO
X-Spam-Score: -0.872
Date: Thu, 23 Dec 2010 14:20:29 +0100 (CET)
From: Florian Fainelli <ffainelli@freebox.fr>
Reply-To: Florian Fainelli <ffainelli@freebox.fr>
To: Yinghai <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.brandewie@gmail.com>,
        sodaville@linutronix.de, Ingo Molnar <mingo@elte.hu>,
        Florian Fainelli <ffainelli@freebox.fr>
Message-ID: <153445735.411361293110429680.JavaMail.root@zimbra-corp-1-b8>
In-Reply-To: <7A03AE18-9737-41D6-8EF5-6C6C29C1BF0D@kernel.org>
Subject: Re: [PATCH] x86/trampoline: fallback to fixed trampoline address if
 no e820 map is provided
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [213.228.1.121]
X-Mailer: Zimbra 6.0.1_GA_1816.UBUNTU8_64 (ZimbraWebClient - FF3.0 (Linux)/6.0.1_GA_1816.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Yinghai" <yinghai@kernel.org> a écrit :

> On Dec 23, 2010, at 1:57 AM, Florian Fainelli <ffainelli@freebox.fr>
> wrote:
> 
> > On Tuesday 14 December 2010 22:19:39 Florian Fainelli wrote:
> >> From: Florian Fainelli <ffainelli@freebox.fr>
> >> 
> >> Since 893f38d1 (x86: Use find_e820() instead of hard coded
> trampoline
> >> address), the trampoline base address should be provided by the
> BIOS as an
> >> e820 area. Some minimalistic BIOSes (like CEFDK on CE4100) may not
> provide
> >> any e820 area, still we should fallback to a fixed trampoline base
> address
> >> for SMP to work correctly.
> 
> No e820 memmap ?

Yes, the BIOS is only doing the very minimal setup to get a kernel in real-mode booting.

> 
> Not sure how does it work
> 
> Do you have boot log with debug ?

I would need to produce one for you, give me a couple days to be in sync.

> 
> Also recent kernel is using memblock already for finding free area.
> 
> Thanks
> 
> 
> 
> >> 
> >> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> >> Cc: sodaville@linutronix.de
> >> Cc: Ingo Molnar <mingo@elte.hu>
> >> Cc: Yinghai Lu <yinghai@kernel.org>
> >> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
> > 
> > Ingo, Yinghai, anything wrong with that patch? Thank you.
> > 
> >> ---
> >> diff --git a/arch/x86/include/asm/trampoline.h
> >> b/arch/x86/include/asm/trampoline.h index f4500fb..908b395 100644
> >> --- a/arch/x86/include/asm/trampoline.h
> >> +++ b/arch/x86/include/asm/trampoline.h
> >> @@ -16,6 +16,7 @@ extern unsigned long initial_code;
> >> extern unsigned long initial_gs;
> >> 
> >> #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data,
> >> PAGE_SIZE) +#define TRAMPOLINE_BASE 0x6000
> >> 
> >> extern unsigned long setup_trampoline(void);
> >> extern void __init reserve_trampoline_memory(void);
> >> diff --git a/arch/x86/kernel/trampoline.c
> b/arch/x86/kernel/trampoline.c
> >> index f1488a3..d025aae 100644
> >> --- a/arch/x86/kernel/trampoline.c
> >> +++ b/arch/x86/kernel/trampoline.c
> >> @@ -21,8 +21,11 @@ void __init reserve_trampoline_memory(void)
> >> 
> >>    /* Has to be in very low memory so we can execute real-mode AP
> code. */
> >>    mem = find_e820_area(0, 1<<20, TRAMPOLINE_SIZE, PAGE_SIZE);
> >> -    if (mem == -1L)
> >> -        panic("Cannot allocate trampoline\n");
> >> +    if (mem == -1L) {
> >> +        printk(KERN_INFO "BIOS did not provide e820 area for
> trampoline"
> >> +                " ,using static trampoline address\n");
> >> +        mem = TRAMPOLINE_BASE;
> >> +    }
> >> 
> >>    trampoline_base = __va(mem);
> >>    reserve_early(mem, mem + TRAMPOLINE_SIZE, "TRAMPOLINE");
