Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab2ERDeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:34:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61408 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab2ERDeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:34:06 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbLw9ySj5VDjJJ04fW383=8AUhDfyvqdrPnAR7+-etGFqQ@mail.gmail.com>
References: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
 <CA+55aFxB6YSz-KEwVKtOesS7yrdvYw6sP3mfpuWBOheJVL6e+w@mail.gmail.com>
 <CA+8MBbK_xeN5HWnSvbDYwzZ+E0pSpbDte30RH2deo0r1OzYBGA@mail.gmail.com>
 <CA+55aFxvjBQ+nn2JEnrMeHrRq9O7-aost1ZYrQbOFySkU_piWg@mail.gmail.com> <CA+8MBbLw9ySj5VDjJJ04fW383=8AUhDfyvqdrPnAR7+-etGFqQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 May 2012 20:33:44 -0700
X-Google-Sender-Auth: SEhwXYw4In_ZH23DeO3Q0wNinI0
Message-ID: <CA+55aFygZYVpM7Agy+Vi+Majaa=7GLzeS8Mp9v3jiq-t+_=hLQ@mail.gmail.com>
Subject: Re: [git pull] machine check recovery fix
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 7:37 PM, Tony Luck <tony.luck@intel.com> wrote:
>
> When we assign the severity for the error we check for kernel vs. user
> space. If we took the machine check in kernel space it will get assigned
> MCE_PANIC_SEVERITY severity ... and we won;t try to do any
> recovery.  We only play the games with TIF_MCE_NOTIFY if we
> see severity MCE_AR_SEVERITY ... which we will only do if the
> machine check happened in user mode.

Ok, this code is a rats nest. I'm looking at mce_severity(), and I'm
just going "that's unreadable, and totally not understandable".

And it's wrong.

> So current recovery code only tries to deal with the user case.

Ugh. And it mixes up the EIPV bit checking both in "error_context()"
_and_ in the logic in the "severities" array, both of which can check
that bit in two different ways.

The code is crazy. It's an unreadable mess. Not surprising that it
then also is buggy.

Who seriously thinks that you get a *more* reliable machine by
executing code that seems to do these kinds of random things?

Looking at the code, I don't think it has been written by a human. I'm
guessing here, but did somebody stare at some MCE document flow-chart
while writing this? It feels like the way things happened was:

 - an engineer told a technical writer what he thought the flow should be
 - a technical writer wrote a piece of document
 - another unrelated engineer then took that document and tried to codify it
 - nobody actually talked to each other and asked each other "does
this make sense"

Some of that code is clearly pure garbage. For example, if I as a user
can trigger a machine check (say, I can make the CPU overheat by
looping on all CPU's), I can fool that code to say that it happened
IN_KERNEL by just making "ip" be zero. Which is quite trivially done
even if I cannot mmap the virtual NULL address: just create a new code
segment, put a "jmp 0" at the zero address, and jump to that. Voila -
guaranteed zero ip.

Which then makes the MCE code say "oh, that must be kernel mode". For
the great (NOT!) reason that some less than giften individual (see - I
can avoid the word "moron" if I really try!) thought that "zero means
not available". Even if zero is also a possible valid value!

That "is it in kernel mode" check also seems to not know about vm86
mode. Let's hope those MCE's can never happen on an instruction in
vm86 mode, because then the CS check is crap too.

In fact, it's *all* crap. Because it shouldn't check "m->cs" and
"m->ip" at all, because what matters is not which instruction caused
the MCE, but whether the *return* address is in kernel mode or not!
Maybe the error that triggered the MCE happened in user mode, but
asynchronously, so the return address is in kernel mode. So the whole
"error_context()" thing is testing entirely the wrong thing.

What we should worry about is whether RIPV is set, and we're returning
to kernel mode or not. THAT is the case that the kernel cares about,
because it cannot fix it up.

So I'm looking at mce-severity.c, and I think the problems there go
*much* deeper than your little patch.

There's two totally independent bugs in just *one* line of code in the
error_context() function.

                         Linus
