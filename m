Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0KMUAB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 15:00:01 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:41413 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab0KMT76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 14:59:58 -0500
Message-ID: <4CDEEE33.3050106@free.fr>
Date: Sat, 13 Nov 2010 20:59:47 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Kees Cook <kees.cook@canonical.com>, Siarhei Liakh <sliakh.lkml@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Security] proactive defense: using read-only memory, RO/NX modules
References: <20101107193520.GO5327@outflux.net> <20101108061324.GA30540@elte.hu> <20101108214228.GQ5876@outflux.net> <20101110090415.GC8370@elte.hu>
In-Reply-To: <20101110090415.GC8370@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar a écrit :
> * Kees Cook <kees.cook@canonical.com> wrote:
> 
>> Hi,
>>
>> On Mon, Nov 08, 2010 at 07:13:24AM +0100, Ingo Molnar wrote:
>>> * Kees Cook <kees.cook@canonical.com> wrote:
>>>> While Dan Rosenberg is working to make things harder to locate potential targets 
>>>> in the kernel through fixing kernel address leaks[1], I'd like to approach a 
>>>> related proactive security measure: enforcing read-only memory for things that 
>>>> would make good targets.
>>> Nice! IMHO we need more of that. (If the readonly section gets big enough in 
>>> practice we could perhaps even mark it large-page in the future. It could serve as 
>>> an allocator to module code as well - that would probably be a speedup even for 
>>> modules.)
>> Well, I can try to extract and send what PaX does, but it seems relatively
>> incompatible with the existing system that uses set_kernel_text_rw() and
>> friends.
>>
>>>> - Modules need to be correctly marked RO/NX. This patch exists[3], but is
>>>>   not in mainline. It needs to be in mainline.
>>> [...]
>>>> [3] http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=65187d24fa3ef60f691f847c792e8eaca7e19251
>>> The reason the RO/NX patch from Siarhei Liakh is not upstream yet is rather mundane: 
>>> it introduced regressions - it caused boot crashes on one of my testboxes.
>>>
>>> But there is no fundamental reason why it shouldnt be upstream. We can push it 
>>> upstream if the crashes are resolved and if it gets an Ack from Rusty or Linus 
>>> for the module bits.
>> Oh, well, yes, that's a good reason. :) Where was this covered? I'd like to help 
>> get it reproduced and ironed out.
> 
> Matthieu Castet seems to have dusted off those patches and submitted two of them in 
> this mail:
> 
>   Subject: [RFC] reworked NX protection for kernel data
> 
> Matthieu, are you still interested in this topic?
Of course, but I was disapointed that my mail got no reply and no testing.

The last version was "[PATCH 2/3 V8] [tip:x86/mm] NX protection for kernel data"


> 
> The original, broken patches were these -tip commits:
> 
>  1e858c081af5: x86, mm: RO/NX protection for loadable kernel modules
>  18c60ddc9eff: x86, mm: NX protection for kernel data
>  c226a2feba21: x86, mm: Set first MB as RW+NX
>  b29d530510d4: x86, mm: Correcting improper large page preservation
> 
> I reported one of the crashes in:
> 
>   Subject: Re: [tip:x86/mm] x86, mm: Set first MB as RW+NX
> 
> on lkml.
> 
My patches should fix the bug.
I merged "NX protection for kernel data" and "Set first MB as RW+NX" :
This patch expands functionality of CONFIG_DEBUG_RODATA to set main
   (static) kernel data area as NX.
   The following steps are taken to achieve this:
   1. Linker script is adjusted so .text always starts and ends on a page bound
   2. Linker script is adjusted so .rodata always start and
   end on a page boundary
   3. NX is set for all pages from _etext through _end in mark_rodata_ro.
   4. free_init_pages() sets released memory NX in arch/x86/mm/init.c
   5. bios rom is set to x when pcibios is used. 

The cause of the crash was because we try to make bios NX. But after some thought,
I made the bios NX only if pcibios isn't used. That should be the case for system supporting 
NX (X86 or pci mmconfig). This avoid relying on old bios specification.


If you want I can repost things or port it to new kernel.


Matthieu
