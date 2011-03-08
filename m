Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab1CHV72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:59:28 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57583 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1CHV70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:59:26 -0500
MIME-Version: 1.0
In-Reply-To: <1299619716.22236.32.camel@pasglop>
References: <4D6E8932.1010405@zytor.com> <alpine.LFD.2.00.1103022152420.2701@localhost6.localdomain6>
 <4D6EB07C.5040004@zytor.com> <alpine.LFD.2.00.1103022216180.2701@localhost6.localdomain6>
 <4D6ECBDB.6090307@zytor.com> <20110303083035.GB14854@elte.hu>
 <AANLkTik4aTN8+Ob_GVwF17v6pDNGg2DEZJubBazs2e3L@mail.gmail.com> <1299619716.22236.32.camel@pasglop>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Tue, 8 Mar 2011 16:59:05 -0500
Message-ID: <AANLkTikAnb39XhR0hdZAzTKGJ-P1rH+ZxtD+Dea7-364@mail.gmail.com>
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

On Tue, Mar 8, 2011 at 16:28, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2011-03-08 at 14:57 -0500, Kyle Moffett wrote:
>> Specifically the e500 doesn't have a normal PowerPC FPU, it has a
>> custom FPU built using extended integer registers instead, and it
>> happens to borrow the AltiVec opcode range to do it.
>>
>> When trying to port Debian to the platform we were getting SIGILL's
>> all over the place until binutils got updated to reject all of the
>> unsupported opcodes on this particular platform.  Now of course we get
>> build errors, but that's a lot easier to debug and fix. :-D
>>
>> Basically, binutils no longer supports "-many" (because too many
>> opcodes conflict), and the test itself would fail anyways (because
>> "dssall" is not valid on "any" PowerPC).
>
> Note that this freescale "SPE" fiasco is just that ... a fiasco :-) I
> don't think there's that many cases of opcode overlap outside of it.

I absolutely agree on the "fiasco" part, although I'm pretty sure that
there's a large number of incompatible ARM variants (even 16-bit vs.
32-bit opcodes).  Unfortunately there's a lot of shipped hardware to
be supported and maintained...


> Now regarding the kernel, the best is probably for nasty cases like that
> to use hand coded opcodes (see ppc-opcodes.h) and stick to a more
> "generic" setting for binutils, since it should be possible to build
> kernels that support multiple types of BookE CPUs with different
> floating point units.

The problem is not with the kernel compile itself, but with the 2.12
"dssall" binutils test.  Basically, recent binutils treats e500 as
effectively a separate architecture that happens to share *most* of
the opcodes with regular PowerPC.  Any opcode which is not understood
by the e500 chip is either convert to an equivalent opcode which is
understood (IE: lwsync => sync), or failed with an error.  This means
that the kernel compile aborts early telling me to upgrade to a newer
version of binutils.

This was *critical* for getting an actual Debian distribution
bootstrapped on the e500 cores, because so much software assumes
PowerPC == altivec (ffmpeg), hardcodes 'asm("lwsync")' for memory
barriers (80+ packages in Debian), or includes hand-coded
floating-point ASM instructions (libffi).  Noisy build errors are
better than silent runtime failures any day of the week.

At the very least that test needs to be turned off if
CONFIG_ALTIVEC=n, because the kernel builds and runs fine otherwise.

Cheers,
Kyle Moffett
