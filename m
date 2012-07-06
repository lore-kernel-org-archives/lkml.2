Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab2GFACQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 20:02:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45462 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2GFACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 20:02:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120705231034.GA16931@lizard>
References: <20120705231034.GA16931@lizard>
Date: Thu, 5 Jul 2012 17:02:12 -0700
X-Google-Sender-Auth: 9rqrRJxxmEqMb-HNMhODToTBxCY
Message-ID: <CAMbhsRTeWgWyf2gcjr_TSr99Z6wL8bLmMGPYsTsVXoL-+A2Cyg@mail.gmail.com>
Subject: Re: [PATCH 0/6] KGDB/KDB FIQ (NMI) debugger
From: Colin Cross <ccross@android.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 4:10 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
>
> Hi all,
>
> These patches introduce KGDB FIQ debugger support. The idea (and some
> code, of course) comes from Google's FIQ debugger[1]. There are some
> differences (mostly implementation details, feature-wise they're almost
> equivalent, or can be made equivalent, if desired).

I haven't looked at this in detail yet, but the concept it sounds
pretty nice.  One difference I would like to highlight is that the FIQ
debugger is designed to be limited enough to leave enabled on
production devices, and is often the only debugging feature available
on just-before-production devices when trying to nail those last few
pesky bugs.  KGDB can obviously only be enabled on development
devices, although perhaps a more limited KDB could be left enabled.

> The FIQ debugger is a facility that can be used to debug situations
> when the kernel stuck in uninterruptable sections, e.g. the kernel
> infinitely loops or deadlocked in an interrupt or with interrupts
> disabled. On some development boards there is even a special NMI
> button, which is very useful for debugging weird kernel hangs.
>
> And FIQ is basically an NMI, it has a higher priority than IRQs, and
> upon IRQ exception FIQs are not disabled. It is still possible to
> disable FIQs (as well as some "NMIs" on other architectures), but via
> special means.
>
> So, here FIQs and NMIs are synonyms, but in the code I use NMI term
> for arch-independent code, and FIQs for ARM code.

Unfortunately, FIQs have been repurposed as secure interrupts on every
ARM SoC that supports TrustZone, which is basically all of the latest
generation, as well as a few of the previous generation.  When an FIQ
arrives, the cpu traps into the secure mode, generally running a
separate secure OS written by a 3rd party vendor.  We've tried to get
some SoC secure implementations to drop out of secure mode and into
the FIQ exception vector for specific irqs, with the registers set up
to allow the FIQ handler to return back to the original execution
point, but it's been successful.  It's a tricky problem, because
non-secure can't enable/disable FIQs, so they have to be enabled when
secure jumps to the FIQ exception vector, which then causes reentrancy
issues.

An alternate solution could be to standardize a secure FIQ handler
interface, where the secure side could drop into the kernel with the
registers already saved somewhere, and then the kernel would trap back
into secure mode when the handler finished to allow the secure
interrupt to be re-enabled.  Obviously not part of this patch set, but
until something like that exists, this isn't going to get used on
today's SoCs.

> A few years ago KDB wasn't yet ready for production, or even not
> well-known, so originally Google implemented its own FIQ debugger
> that included its own shell, ring-buffer, commands, dumping,
> backtracing logic and whatnot. This is very much like PowerPC's xmon
> (arch/powerpc/xmon), except that xmon was there for a decade, so it
> even predates KDB.
>
> Anyway, nowadays KGDB/KDB is the cross-platform debugger, and the
> only feature that was missing is NMI handling. This is now fixed for
> ARM.
>
> There a few differences comparing to the original (Google's) FIQ
> debugger:
>
> - Doing stuff in FIQ context is dangerous, as there we are not allowed
>   to cause aborts or faults. In the original FIQ debugger there was a
>   "signal" software-induced interrupt, upon exit from FIQ it would fire,
>   and we would continue to execute "dangerous" commands from there.
>
>   In KGDB/KDB we don't use signal interrupts. We can do easier:
>   set up a breakpoint, continue, and you'll trap into KGDB again
>   in a safe context.

I like this, much better than generating an interrupt (which may not
even be possible on some platforms).

>   It works for most cases, but I can imagine cases when you can't
>   set up a breakpoint. For these cases we'd better introduce a
>   KDB command "exit_nmi", that will rise the SW IRQ, after which
>   we're allowed to do anything.
>
> - KGDB/KDB FIQ debugger shell is synchronous. In Google's version
>   you could have a dedicated shell always running in the FIQ context,
>   so when you type something on a serial line, you won't actually cause
>   any debugging actions, FIQ would save the characters in its own
>   buffer and continue execution normally. But when you hit return key
>   after the command, then the command is executed.
>
>   In KGDB/KDB FIQ debugger it is different. When you start any activity
>   on the FIQ-enabled serial console, you'll enter KGDB and kernel will
>   stop until you instruct it to continue.
>
>   This might look as a drastic change, but it is not. There is actually
>   no difference whether you have sync or async shell, or at least I
>   couldn't find any use-case where this would matter at all. Anyways,
>   it is still possible to do async shell in KDB, just don't see any
>   need for this.

I think it could be an issue if KDB stopped execution whenever it
received any character.  Serial ports are often noisy, especially when
muxed over another port (we often use serial over the headset
connector).  Noise on the async command line just causes characters
that are ignored, on a command line that blocked execution noise would
be catastrophic.

> - Original FIQ debugger used a custom FIQ vector handling code, w/
>   a lot of logic in it. In this approach I'm using the fact that
>   FIQs are basically IRQs, except that we there are a bit more
>   registers banked, and we can actually trap from the IRQ context.
>
>   But this all does not prevent us from using a simple jump-table
>   based approach as used in the generic ARM entry code. So, here
>   I just reuse the generic approach.
>
> Note that I testing the code on a modelled ARM machine (QEMU Versatile),
> so there might be some issues on a real HW, but it works in QEMU tho. :-)
>
> Assuming you have QEMU >= 1.1.0, you can easily play with the code
> using ARM/versatile defconfig and command like this:
>
>   qemu-system-arm -nographic -machine versatilepb \
>         -kernel linux/arch/arm/boot/zImage  \
>         -append "console=ttyAMA0 kgdboc=ttyAMA0 kgdb_fiq.enable=1"
>
> TODO:
>
> 1. alignment_trap macro uses local label, so we have to put the label
>    into each file that use the macro. We can get rid of the label;
> 2. Need per-machine kgdb_arch_enable_nmi(), probably will introduce
>    a pointer to a func;
> 3. Since console interrupt is actually is overtaken by NMI handler, we
>    should make serial/uart drivers stop using TX interrupts. This my
>    homework to think how to do it better. Currently, we would just
>    better not use console= and kgdboc= on the same tty (but it still
>    works, just might cause troubles if you hit TX interrupt);

One of the nice features in FIQ debugger is the "console" command,
which causes all incoming serial characters to get passed to a console
device provided by the FIQ debugger, and characters from the console
to go out the serial port (when it is enabled).  That way you can
still have the console when you want it, but only one driver talking
to the hardware.

> 4. Address any comments. :-)
>
> Thanks!
>
