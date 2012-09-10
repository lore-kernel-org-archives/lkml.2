Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab2IJEKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 00:10:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2IJEKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 00:10:39 -0400
Date: Sun, 9 Sep 2012 21:08:04 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: [PATCH v5 0/14] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120910040802.GA1261@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There wasn't much feedback on v4, the only comment was from Brian
Swetland concerning async console (I explained how we deal with it).

It would be really great if the core functionality could make it into
v3.7.  Which raises the question: if the patches are OK, who should take
them?  They touch 3 subsystems: KGDB, TTY and ARM.

Taking the patches via -mm or TTY trees would be the easiest way as this
way we'll avoid having to deal with conflicts (see changelog*).  But
merging via ARM or KDB will also work.

Russell, Jason, naively presuming that the ARM & KDB patches are OK,
would you be willing to ack ARM/KDB patches?  Or, in case if it goes via
KDB or ARM tree, we'll need acks from Greg and Alan on tty patches...

Anyways, here goes the shiny v5:

- *I took two amba-pl1011 patches from Greg's tty tree. This is needed
  to ease Stephen Rothwell's life in case if this goes into -next via
  non-tty or non-mm tree.

  The problem is that we now touch the same lines as tty tree, and
  conflicts are not trivial. But by taking the two patches and rebasing
  my work on top, we turn the conflicts into trivial ones.

- There were some concerns that '$3#33' might be not lengthy enough
  (i.e., it's a bit shorter than '\nreboot\n').  Reading 2GB of
  /dev/urandom couldn't find $3#33 sequence, but I made the magic phrase
  configurable via kgdb_nmi.magic kernel command line option, just in
  case.

These patches can be found in the following repo:

	git://git.infradead.org/users/cbou/linux-nmi-kdb.git master

Boilerplate:

These patches introduce KGDB FIQ debugger support. The idea (and some
code, of course) comes from Google's FIQ debugger[2]. There are some
differences (mostly implementation details, feature-wise they're almost
equivalent, or can be made equivalent, if desired).

The FIQ debugger is a facility that can be used to debug situations when
the kernel stuck in uninterruptable sections, e.g. the kernel infinitely
loops or deadlocked in an interrupt or with interrupts disabled. On some
development boards there is even a special NMI button, which is very
useful for debugging weird kernel hangs.

And FIQ is basically an NMI, it has a higher priority than IRQs, and
upon IRQ exception FIQs are not disabled. It is still possible to
disable FIQs (as well as some "NMIs" on other architectures), but via
special means.

So, here FIQs and NMIs are synonyms, but in the code I use NMI term for
arch-independent code, and FIQs for ARM code.

A few years ago KDB wasn't yet ready for production, or even not
well-known, so originally Google implemented its own FIQ debugger that
included its own shell, ring-buffer, commands, dumping, backtracing
logic and whatnot. This is very much like PowerPC's xmon
(arch/powerpc/xmon), except that xmon was there for a decade, so it even
predates KDB.

Anyway, nowadays KGDB/KDB is the cross-platform debugger, and the only
feature that was missing is NMI handling. This is now fixed for ARM.

There are a few differences comparing to the original (Google's) FIQ
debugger:

- Doing stuff in FIQ context is dangerous, as there we are not allowed
  to cause aborts or faults. In the original FIQ debugger there was a
  "signal" software-induced interrupt, upon exit from FIQ it would fire,
  and we would continue to execute "dangerous" commands from there.

  In KGDB/KDB we don't use signal interrupts. We can do easier: set up a
  breakpoint, continue, and you'll trap into KGDB again in a safe
  context.

  It works for most cases, but I can imagine cases when you can't set up
  a breakpoint. For these cases we'd better introduce a KDB command
  "exit_nmi", that will rise the SW IRQ, after which we're allowed to do
  anything.

- KGDB/KDB FIQ debugger shell is synchronous. In Google's version you
  could have a dedicated shell always running in the FIQ context, so
  when you type something on a serial line, you won't actually cause any
  debugging actions, FIQ would save the characters in its own buffer and
  continue execution normally. But when you hit return key after the
  command, then the command is executed.

  In KGDB/KDB FIQ debugger it is different. Once you enter KGDB, the
  kernel will stop until you instruct it to continue.

  This might look as a drastic change, but it is not. There is actually
  no difference whether you have sync or async shell, or at least I
  couldn't find any use-case where this would matter at all. Anyways, it
  is still possible to do async shell in KDB, just don't see any need
  for this.

- Original FIQ debugger used a custom FIQ vector handling code, w/ a lot
  of logic in it. In this approach I'm using the fact that FIQs are
  basically IRQs, except that we there are a bit more registers banked,
  and we can actually trap from the IRQ context.

  But this all does not prevent us from using a simple jump-table based
  approach as used in the generic ARM entry code. So, here I just reuse
  the generic approach.

Note that I test the code on a modelled ARM machine (QEMU Versatile), so
there might be some issues on a real HW, but it works in QEMU tho. :-)

Assuming you have QEMU >= 1.1.0, you can easily play with the code using
ARM/versatile defconfig and command like this:

  qemu-system-arm -nographic -machine versatilepb -kernel
  linux/arch/arm/boot/zImage -append "console=ttyAMA0 kgdboc=ttyAMA0
  kgdb_fiq.enable=1"

Thanks,

--
 arch/arm/Kconfig                    |  19 ++
 arch/arm/common/vic.c               |  28 +++
 arch/arm/include/asm/hardware/vic.h |   2 +
 arch/arm/include/asm/kgdb.h         |   8 +
 arch/arm/kernel/Makefile            |   1 +
 arch/arm/kernel/entry-armv.S        | 167 +-------------
 arch/arm/kernel/entry-header.S      | 170 +++++++++++++++
 arch/arm/kernel/kgdb_fiq.c          |  99 +++++++++
 arch/arm/kernel/kgdb_fiq_entry.S    |  87 ++++++++
 arch/arm/mach-versatile/Makefile    |   1 +
 arch/arm/mach-versatile/kgdb_fiq.c  |  31 +++
 drivers/tty/serial/Kconfig          |  19 ++
 drivers/tty/serial/Makefile         |   1 +
 drivers/tty/serial/amba-pl010.c     |  15 +-
 drivers/tty/serial/amba-pl011.c     | 106 +++++----
 drivers/tty/serial/kgdb_nmi.c       | 352 ++++++++++++++++++++++++++++++
 drivers/tty/serial/kgdboc.c         |  16 ++
 drivers/tty/serial/serial_core.c    |  30 +++
 include/linux/kdb.h                 |  29 +--
 include/linux/kgdb.h                |  34 +++
 include/linux/serial_core.h         |   2 +
 include/linux/tty_driver.h          |   1 +
 kernel/debug/debug_core.c           |  36 ++-
 kernel/debug/kdb/kdb_main.c         |  29 +++
 24 files changed, 1051 insertions(+), 232 deletions(-)

In v4:

- Implemented kgdb_nmi serial driver, it provides 'nmi_console' KDB
  command. With the driver we can use our debugger port as a normal
  console, except that we can always get back to the debugger using the
  magic sequence.  Note that I still somewhat reluctant to introduce
  software-raised interrupts, as they're arch-specific and not always
  possible.  So today the driver uses a tasklet, it should be pretty
  cheap: we're checking for the input on timer interrupts, but we don't
  cause needless wakeups. The pro of this is that it works everywhere
  (but arches still have an option to optimize things, of course);
- Two new patches added to propagate init_poll() callbacks from tty to
  uart drivers. As a side-effect, a long-standing bug fixed in
  amba-pl1011 driver;
- Dropped patch 'Get rid of .LCcralign local label';
- Some more fixes in SVC return path. Now it seems rock-solid;

In v3:

- Per Colin Cross suggestion, added a way to release a debug console for
  normal use.  This is done via 'disable_nmi' command (in the original
  FIQ debugger it was 'console' command). For this I added a new
  callback in the tty ops, and serial drivers have to provide a way to
  clear its interrupts. The patch 'tty/serial/kgdboc: Add and wire up
  clear_irqs callback' explains the concept in details.
- Made the debug entry prompt more shell-like;
- A new knocking mode '-1'. It disables the feature altogether, and thus
  makes it possible to hook KDB entry to a dedicated button.
- The code was rebased on 'v3.5 + kdb kiosk'[1] patches;

In v2:

- Per Colin Cross' suggestion, we should not enter the debugger on any
  received byte (this might be a problem when there's a noise on the
  serial line). So there is now an additional patch that implements
  "knocking" to the KDB (either via $3#33 command or return key, this is
  configurable);
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
