Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2G3L7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 07:59:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48385 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2G3L7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 07:59:30 -0400
Date: Mon, 30 Jul 2012 04:57:19 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH v3 0/11] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120730115719.GA5742@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I do realize that we're in the middle of the merge window. But maybe
some of you will be bored enough to look into this; and no problem if
you don't feel like it -- I promise to send a brand new shiny v4 after
the merge window, so you won't miss a bit of this new cool stuff. :-)

In v3:

- Per Colin Cross suggestion, added a way to release a debug console for
  normal use.  This is done via 'disable_nmi' command (in the original
  FIQ debugger it was 'console' command). For this I added a new callback
  in the tty ops, and serial drivers have to provide a way to clear its
  interrupts. The patch 'tty/serial/kgdboc: Add and wire up clear_irqs
  callback' explains the concept in details.
- Made the debug entry prompt more shell-like;
- A new knocking mode '-1'. It disables the feature altogether, and thus
  makes it possible to hook KDB entry to a dedicated button.
- The code was rebased on 'v3.5 + kdb kiosk'[1] patches; and for
  convenience it is now available in the following repo:

  	git://git.infradead.org/users/cbou/linux-nmi-kdb.git master

Rationale for this patch set:

These patches introduce KGDB FIQ debugger support. The idea (and some
code, of course) comes from Google's FIQ debugger[2]. There are some
differences (mostly implementation details, feature-wise they're almost
equivalent, or can be made equivalent, if desired).

The FIQ debugger is a facility that can be used to debug situations
when the kernel stuck in uninterruptable sections, e.g. the kernel
infinitely loops or deadlocked in an interrupt or with interrupts
disabled. On some development boards there is even a special NMI
button, which is very useful for debugging weird kernel hangs.

And FIQ is basically an NMI, it has a higher priority than IRQs, and
upon IRQ exception FIQs are not disabled. It is still possible to
disable FIQs (as well as some "NMIs" on other architectures), but via
special means.

So, here FIQs and NMIs are synonyms, but in the code I use NMI term
for arch-independent code, and FIQs for ARM code.

A few years ago KDB wasn't yet ready for production, or even not
well-known, so originally Google implemented its own FIQ debugger
that included its own shell, ring-buffer, commands, dumping,
backtracing logic and whatnot. This is very much like PowerPC's xmon
(arch/powerpc/xmon), except that xmon was there for a decade, so it
even predates KDB.

Anyway, nowadays KGDB/KDB is the cross-platform debugger, and the
only feature that was missing is NMI handling. This is now fixed for
ARM.

There are a few differences comparing to the original (Google's) FIQ
debugger:

- Doing stuff in FIQ context is dangerous, as there we are not allowed
  to cause aborts or faults. In the original FIQ debugger there was a
  "signal" software-induced interrupt, upon exit from FIQ it would fire,
  and we would continue to execute "dangerous" commands from there.

  In KGDB/KDB we don't use signal interrupts. We can do easier:
  set up a breakpoint, continue, and you'll trap into KGDB again
  in a safe context.

  It works for most cases, but I can imagine cases when you can't
  set up a breakpoint. For these cases we'd better introduce a
  KDB command "exit_nmi", that will rise the SW IRQ, after which
  we're allowed to do anything.

- KGDB/KDB FIQ debugger shell is synchronous. In Google's version
  you could have a dedicated shell always running in the FIQ context,
  so when you type something on a serial line, you won't actually cause
  any debugging actions, FIQ would save the characters in its own
  buffer and continue execution normally. But when you hit return key
  after the command, then the command is executed.

  In KGDB/KDB FIQ debugger it is different. Once you enter KGDB, the
  kernel will stop until you instruct it to continue.

  This might look as a drastic change, but it is not. There is actually
  no difference whether you have sync or async shell, or at least I
  couldn't find any use-case where this would matter at all. Anyways,
  it is still possible to do async shell in KDB, just don't see any
  need for this.

- Original FIQ debugger used a custom FIQ vector handling code, w/
  a lot of logic in it. In this approach I'm using the fact that
  FIQs are basically IRQs, except that we there are a bit more
  registers banked, and we can actually trap from the IRQ context.

  But this all does not prevent us from using a simple jump-table
  based approach as used in the generic ARM entry code. So, here
  I just reuse the generic approach.

Note that I test the code on a modelled ARM machine (QEMU Versatile), so
there might be some issues on a real HW, but it works in QEMU tho. :-)

Assuming you have QEMU >= 1.1.0, you can easily play with the code
using ARM/versatile defconfig and command like this:

  qemu-system-arm -nographic -machine versatilepb \
  	-kernel linux/arch/arm/boot/zImage  \
  	-append "console=ttyAMA0 kgdboc=ttyAMA0 kgdb_fiq.enable=1"

Thanks,

--
 arch/arm/Kconfig                            |   19 +++
 arch/arm/common/vic.c                       |   28 +++++
 arch/arm/include/asm/hardware/vic.h         |    2 +
 arch/arm/include/asm/kgdb.h                 |    8 ++
 arch/arm/kernel/Makefile                    |    1 +
 arch/arm/kernel/entry-armv.S                |  169 +------------------------
 arch/arm/kernel/entry-header.S              |  176 ++++++++++++++++++++++++++-
 arch/arm/kernel/kgdb_fiq.c                  |  159 ++++++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq_entry.S            |   76 ++++++++++++
 arch/arm/mach-versatile/Makefile            |    1 +
 arch/arm/mach-versatile/include/mach/irqs.h |    1 +
 arch/arm/mach-versatile/kgdb_fiq.c          |   31 +++++
 drivers/tty/serial/amba-pl011.c             |   13 ++
 drivers/tty/serial/kgdboc.c                 |    9 ++
 drivers/tty/serial/serial_core.c            |   15 +++
 include/linux/kgdb.h                        |   14 +++
 include/linux/serial_core.h                 |    1 +
 include/linux/tty_driver.h                  |    1 +
 kernel/debug/debug_core.c                   |   13 +-
 kernel/debug/kdb/kdb_debugger.c             |    4 +
 kernel/debug/kdb/kdb_main.c                 |   20 +++
 21 files changed, 591 insertions(+), 170 deletions(-)

In v2:

- Per Colin Cross' suggestion, we should not enter the debugger on any
  received byte (this might be a problem when there's a noise on the
  serial line). So there is now an additional patch that implements
  "knocking" to the KDB (either via $3#33 command or return key, this
  is configurable);
- Reworked {enable,select}_fiq/is_fiq callbacks, now multi-mach kernels
  should not be a problem;
- For versatile machines there are run-time checks for proper UART port
  (kernel will scream aloud if out of range port is specified);
- Added some __init annotations;
- Since not every architecture defines FIQ_START, we can't just blindly
  select CONFIG_FIQ symbol. So ARCH_MIGHT_HAVE_FIQ introduced;
- Add !THUMB2_KERNEL dependency for KGDB_FIQ, we don't support Thumb2
  kernels;
- New patch that is used to get rid of LCcralign label in alignment_trap
  macro.

[1] https://lkml.org/lkml/2012/7/26/260
[2] Original Google's FIQ debugger, fiq_* files:
http://android.git.linaro.org/gitweb?p=kernel/common.git;a=tree;f=arch/arm/common;hb=refs/heads/android-3.4
And board support as an example of using it:
http://nv-tegra.nvidia.com/gitweb/?p=linux-2.6.git;a=commitdiff;h=461cb80c16e4e266ab6207a00767b59212148086

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
