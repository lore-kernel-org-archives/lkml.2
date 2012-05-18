Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966061Ab2ERRkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:40:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33563 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965966Ab2ERRkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:40:20 -0400
Date: Fri, 18 May 2012 19:40:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] machine check recovery fix
Message-ID: <20120518174028.GB26005@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
References: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
 <CA+55aFxB6YSz-KEwVKtOesS7yrdvYw6sP3mfpuWBOheJVL6e+w@mail.gmail.com>
 <CA+8MBbK_xeN5HWnSvbDYwzZ+E0pSpbDte30RH2deo0r1OzYBGA@mail.gmail.com>
 <CA+55aFxvjBQ+nn2JEnrMeHrRq9O7-aost1ZYrQbOFySkU_piWg@mail.gmail.com>
 <CA+8MBbLw9ySj5VDjJJ04fW383=8AUhDfyvqdrPnAR7+-etGFqQ@mail.gmail.com>
 <CA+55aFygZYVpM7Agy+Vi+Majaa=7GLzeS8Mp9v3jiq-t+_=hLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFygZYVpM7Agy+Vi+Majaa=7GLzeS8Mp9v3jiq-t+_=hLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 08:33:44PM -0700, Linus Torvalds wrote:
> On Thu, May 17, 2012 at 7:37 PM, Tony Luck <tony.luck@intel.com> wrote:
> >
> > When we assign the severity for the error we check for kernel vs. user
> > space. If we took the machine check in kernel space it will get assigned
> > MCE_PANIC_SEVERITY severity ... and we won;t try to do any
> > recovery.  We only play the games with TIF_MCE_NOTIFY if we
> > see severity MCE_AR_SEVERITY ... which we will only do if the
> > machine check happened in user mode.
> 
> Ok, this code is a rats nest. I'm looking at mce_severity(), and I'm
> just going "that's unreadable, and totally not understandable".
> 
> And it's wrong.

Tell me about it. And it needs to be per-vendor.

> > So current recovery code only tries to deal with the user case.
> 
> Ugh. And it mixes up the EIPV bit checking both in "error_context()"
> _and_ in the logic in the "severities" array, both of which can check
> that bit in two different ways.
> 
> The code is crazy. It's an unreadable mess. Not surprising that it
> then also is buggy.
> 
> Who seriously thinks that you get a *more* reliable machine by
> executing code that seems to do these kinds of random things?
> 
> Looking at the code, I don't think it has been written by a human. I'm
> guessing here, but did somebody stare at some MCE document flow-chart
> while writing this? It feels like the way things happened was:
> 
>  - an engineer told a technical writer what he thought the flow should be
>  - a technical writer wrote a piece of document
>  - another unrelated engineer then took that document and tried to codify it
>  - nobody actually talked to each other and asked each other "does
> this make sense"

:-)

> Some of that code is clearly pure garbage. For example, if I as a user
> can trigger a machine check (say, I can make the CPU overheat by
> looping on all CPU's), I can fool that code to say that it happened
> IN_KERNEL by just making "ip" be zero. Which is quite trivially done
> even if I cannot mmap the virtual NULL address: just create a new code
> segment, put a "jmp 0" at the zero address, and jump to that. Voila -
> guaranteed zero ip.
> 
> Which then makes the MCE code say "oh, that must be kernel mode". For
> the great (NOT!) reason that some less than giften individual (see - I
> can avoid the word "moron" if I really try!) thought that "zero means
> not available". Even if zero is also a possible valid value!
> 
> That "is it in kernel mode" check also seems to not know about vm86
> mode. Let's hope those MCE's can never happen on an instruction in
> vm86 mode, because then the CS check is crap too.
> 
> In fact, it's *all* crap. Because it shouldn't check "m->cs" and
> "m->ip" at all, because what matters is not which instruction caused
> the MCE, but whether the *return* address is in kernel mode or not!
>
> Maybe the error that triggered the MCE happened in user mode, but
> asynchronously, so the return address is in kernel mode. So the whole
> "error_context()" thing is testing entirely the wrong thing.
>
> What we should worry about is whether RIPV is set, and we're returning
> to kernel mode or not. THAT is the case that the kernel cares about,
> because it cannot fix it up.

Ok, this is just nasty but you're right. When EIPV is set, the saved CS
and rIP point to the instruction that caused the MCE, otherwise not.

Maybe for the return-to-kernel-space case we need to decode instructions
in the #MC handler to know what happens, like kvm? Hmmm...

OTOH, this probably needs verification with CPU guys but shouldn't we
have raised the #MC before doing the context switch? What I'm saying is,
I don't think the #MC is raised across contexts (or raised as late as
when a %cr3 write happens) and getting an #MC in userspace should mean
some insn in userspace caused it, and getting an #MC in the NMI handler
would mean, some insn of the NMI handler caused it... Hmm, I hope I'm
making sense.

I'll ask around.

-- 
Regards/Gruss,
Boris.
