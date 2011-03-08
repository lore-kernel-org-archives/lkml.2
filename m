Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1CHXoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:44:18 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58980 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab1CHXoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:44:16 -0500
MIME-Version: 1.0
In-Reply-To: <1299626008.22236.47.camel@pasglop>
References: <4D6E8932.1010405@zytor.com> <alpine.LFD.2.00.1103022152420.2701@localhost6.localdomain6>
 <4D6EB07C.5040004@zytor.com> <alpine.LFD.2.00.1103022216180.2701@localhost6.localdomain6>
 <4D6ECBDB.6090307@zytor.com> <20110303083035.GB14854@elte.hu>
 <AANLkTik4aTN8+Ob_GVwF17v6pDNGg2DEZJubBazs2e3L@mail.gmail.com>
 <1299619716.22236.32.camel@pasglop> <AANLkTikAnb39XhR0hdZAzTKGJ-P1rH+ZxtD+Dea7-364@mail.gmail.com>
 <1299626008.22236.47.camel@pasglop>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Tue, 8 Mar 2011 18:43:54 -0500
Message-ID: <AANLkTi=A8DM+CHAYx+ud2y5-Mj6wPfv+zduJ_JekP-o_@mail.gmail.com>
Subject: Re: RFC: x86: kill binutils 2.16.x?
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Kumar Gala <kumar.gala@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 18:13, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2011-03-08 at 16:59 -0500, Kyle Moffett wrote:
>>
>> The problem is not with the kernel compile itself, but with the 2.12
>> "dssall" binutils test.  Basically, recent binutils treats e500 as
>> effectively a separate architecture that happens to share *most* of
>> the opcodes with regular PowerPC.
>
> This is bogus. Newer e500 don't have that SPE crap afaik and BookI and
> II of the architecture have been converged. In fact, Scott, don't newer
> FSL chips also support real lwsync ?

When I'm talking about "e500" I'm specifically referring to the SPE
stuff.  The "e500mc" cores are a whole different beast with a regular
FPU, but those have their own Kconfig option: "PPC_E500MC".

Actually, looking at it again, the "PPC_E500MC" depends on "E500", it
should select "PPC_FSL_BOOK3E" instead.  There are probably bugs
lurking here.

There really is fundamentally no good way to build a single system
image that supports both E500 (spe-based) and E500MC (classic FPU).
You can sort-of run classic FPU emulation on the E500, but the
performance is terrifyingly bad.

The naming confusion really is really bad too, IMO.

>>  Any opcode which is not understood
>> by the e500 chip is either convert to an equivalent opcode which is
>> understood (IE: lwsync => sync), or failed with an error.  This means
>> that the kernel compile aborts early telling me to upgrade to a newer
>> version of binutils.
>
> This is more bogosity in binutils. lwsync is designed to fallback as
> sync if not supported in -HW-, binutils shouldn't silently swallow it.
>
> Or is it that FSL failed on the original e500 and make lwsync actually
> trap ?

Yeah... for some reason FreeScale made the "lwsync" operation trap on
e500 (again, only talking about "e500" with SPE, not "e500mc").

Unfortunately it's used frequently enough that there's a very
noticeable performance gain (~5% for some programs) by substituting it
in binutils, so that's what happens.


>> This was *critical* for getting an actual Debian distribution
>> bootstrapped on the e500 cores, because so much software assumes
>> PowerPC == altivec (ffmpeg), hardcodes 'asm("lwsync")' for memory
>> barriers (80+ packages in Debian), or includes hand-coded
>> floating-point ASM instructions (libffi).  Noisy build errors are
>> better than silent runtime failures any day of the week.
>>
>> At the very least that test needs to be turned off if
>> CONFIG_ALTIVEC=n, because the kernel builds and runs fine otherwise.
>
> I think the right thing is to keep that as e500-legacy or something,
> because afaik, newer e500's don't have most of these issues and could be
> treated as "normal" powerpc again.

There is a separate "-me500mc" option for GAS that does the right
thing, but the kernel currently does not seem to use it.

arch/powerpc/Makefile has this:
    cpu-as-$(CONFIG_4xx) += -Wa,-m405
    cpu-as-$(CONFIG_6xx) += -Wa,-maltivec
    cpu-as-$(CONFIG_POWER4) += -Wa,-maltivec
    cpu-as-$(CONFIG_E500) += -Wa,-me500
    cpu-as-$(CONFIG_E200) += -Wa,-me200

As it is, I strongly suspect that the kernel is broken for
CONFIG_E500MC with current development releases of binutils.

The real "solution" is that "e500" needs to be treated as an almost
entirely different architecture from "all other powerpc (including
e500mc)".  Userspace is only ABI-compatible if you use "-msoft-float"
on both sides.

I've been dealing with it for a while now, it really is a fiasco all around...

After a month of wrestling with the official Debian "powerpc" port we
gave up and created a new port "powerpcspe" specifically for the
"e500" SPE-based chips.  Then we tripped over 3 relatively major GCC
bugs which had been lurking since e500 support was initially added.

See http://wiki.debian.org/PowerPCSPEPort for a very out-of-date
status on that whole thing.

Cheers,
Kyle Moffett
