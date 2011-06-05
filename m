Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1FESEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:04:34 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:56886 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754451Ab1FESCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:02:45 -0400
X-AuditID: 1209190c-b7c65ae00000117c-71-4debc4cb6dd5
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 0/9] Remove syscall instructions at fixed addresses
Date: Sun,  5 Jun 2011 13:50:16 -0400
Message-Id: <cover.1307292171.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsUixG6nonv6yGtfg9VfdCzmrF/DZtF35Si7
	xZFr39ktZl3jtfi84R+bxdlDEhYHfj1ls3h/dTubxeVdc9gsdty5wmbxpPk6o8WWS82sFo/X
	PGe2+DBxA5vF5k1TmS0e9b1lt7j0/gOLxY8Nj1kdhDy+t/axeBw7c5jR41bbH2aP+Ts/Mnos
	6fjB7rFz1l12j80rtDz+vzzC5jHxzQ1Gj02rOtk83p07x+5xYsZvFo/jZ5w9Pm+S8zi0/Q1b
	AH8Ul01Kak5mWWqRvl0CV8bLxROZClapVtz/tYa5gXGPTBcjJ4eEgInEhTOvmSBsMYkL99az
	dTFycQgJ7GOUWP9zCROEs55RYvufKywQzlMmiTt3FzGDtLAJqEh0LH0AVMXBISKgL3H1MyNI
	DbPAfFaJTae7WUDiwgJuEldPxYOUswioShy50MYKYvMClc/bshusREJAQeL8qvwJjDwLGBlW
	Mcqm5Fbp5iZm5hSnJusWJyfm5aUW6Rrq5WaW6KWmlG5iBMUFpyTPDsY3B5UOMQpwMCrx8O5d
	89pXiDWxrLgy9xCjJAeTkijvgsNAIb6k/JTKjMTijPii0pzU4kOMEhzMSiK8dSKvfIV4UxIr
	q1KL8mFS0hwsSuK8MyTVfYUE0hNLUrNTUwtSi2CyMhwcShK8GsD4FxIsSk1PrUjLzClBSDNx
	cIIM5wEabg5Sw1tckJhbnJkOkT/FaMyx/8Srg4wcW0+8PcgoxJKXn5cqJc77CuRGAZDSjNI8
	uGmw1PaKURzoOWFeTpCBPMC0CDfvFdAqJqBVx51A/iguSURISTUwpitH6zDNt9Rumjq//v75
	dd55DLyCfzs+fEpcw7/v+pI5TxZYfV7vx/1RYv47k5r4Y7/WdMTLvDwamRhteOsy++b33isW
	TuY5+aHdZnlXZmmj0oKX+qFfq2c3TJFj2VPeuahH1DB5bbGpylPlVEVPpzOND9++vfJZMSyl
	wDrxgENFwYkFd34/UGIpzkg01GIuKk4EABwJU8JIAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 is just a bugfix from the last vdso series.
The bug should be harmless but it's pretty dumb.  This is almost
certainly 3.0 material.

Patch 2 adds documentation for entry_64.S.  A lot of the magic in there is far from obvious.

Patches 3, 4, and 5 remove a bunch of syscall instructions in kernel space
at fixed addresses that user code can execute.  Several are data that isn't marked NX.  Patch 2 makes vvars NX and
5/10 makes the HPET NX.

The time() vsyscall contains an explicit syscall fallback.  Patch 3/10
removes it.

At this point, there is only one explicit syscall left in the vsyscall
page: the fallback case for vgettimeofday.  The rest of the series is to
remove it and most of the remaining vsyscall code.

Patch 6 is pure cleanup.  venosys (one of the four vsyscalls) has been
broken for years, so patch 6 removes it.

Patch 7 pads the empty parts of the vsyscall page with 0xcc.  0xcc is an
explicit trap.

Patch 8 removes the code implementing the vsyscalls and replaces it with
magic int 0xcc incantations.  These incantations are specifically
designed so that jumping into them at funny offsets will either work
fine or generate some kind of fault.  This is a significant performance
penalty (~220ns here) for all vsyscall users, but there aren't many
left.  Because current glibc still uses the time vsyscall (although it's
fixed in glibc's git), the option CONFIG_UNSAFE_VSYSCALLS (default y)
will leave time() alone.

This patch is also nice because it removes a bunch of duplicated code
from vsyscall_64.s.

With CONFIG_UNSAFE_VSYSCALLS=y, I can boot Fedora 15 into GNOME and run
Firefox without a single warning about emulated vsyscalls.

Patch 9/10 randomizes the int 0xcc incantation at bootup.  It is pretty
much worthless for security (there are only three choices for the random
number and it's easy to figure out which one is in use) but it prevents
overly clever userspace programs from thinking that the incantation is
ABI.  One instrumentation tool author offered to hard-code special
handling for int 0xcc; I want to discourage this approach.

Patch 10/10 adds CONFIG_UNSAFE_VSYSCALLS to
feature-removal-schedule.txt.  Removing it won't break anything but it
will slow some older code down.

Changed from v4:
 - Remove int 0xcc randomization.
 - Make .vvar one section instead of three (and fix a typo in EMIT_VVAR).
 - Add a missing #ifdef CONFIG_X86_64.
 - Update feature removal changelog to clarify that CONFIG_UNSAFE_VSYSCALLS
   is new.

Changes from v3:
 - Rebased onto tip/master (1a0c84d)

Changes from v2:
 - Reordered the patches.
 - Removed the option to leave gettimeofday and getcpu as native code.
 - Clean up the int 0xcc handler and registration.
 - sched_getcpu works now (thanks, Borislav, for catching my blatant arithmetic error).
 - Numerous small fixes from review comments.
 - Abandon my plan to spread turbostat to the masses.

Changes from v1:
 - Patches 6-10 are new.
 - The int 0xcc code is much prettier and has lots of bugs fixed.
 - I've decided to let everyone compile turbostat on their own :)


Andy Lutomirski (9):
  x86-64: Fix alignment of jiffies variable
  x86-64: Document some of entry_64.S
  x86-64: Give vvars their own page
  x86-64: Remove kernel.vsyscall64 sysctl
  x86-64: Map the HPET NX
  x86-64: Remove vsyscall number 3 (venosys)
  x86-64: Fill unused parts of the vsyscall page with 0xcc
  x86-64: Emulate legacy vsyscalls
  x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule

 Documentation/feature-removal-schedule.txt |    9 +
 Documentation/x86/entry_64.txt             |   98 ++++++++++
 arch/x86/Kconfig                           |   17 ++
 arch/x86/include/asm/fixmap.h              |    1 +
 arch/x86/include/asm/irq_vectors.h         |    6 +-
 arch/x86/include/asm/pgtable_types.h       |    6 +-
 arch/x86/include/asm/traps.h               |    4 +
 arch/x86/include/asm/vgtod.h               |    1 -
 arch/x86/include/asm/vsyscall.h            |    6 +
 arch/x86/include/asm/vvar.h                |   24 +--
 arch/x86/kernel/Makefile                   |    1 +
 arch/x86/kernel/entry_64.S                 |    4 +
 arch/x86/kernel/hpet.c                     |    2 +-
 arch/x86/kernel/traps.c                    |    6 +
 arch/x86/kernel/vmlinux.lds.S              |   48 +++---
 arch/x86/kernel/vsyscall_64.c              |  289 +++++++++++++++-------------
 arch/x86/kernel/vsyscall_emu_64.S          |   42 ++++
 arch/x86/vdso/vclock_gettime.c             |   55 ++----
 18 files changed, 407 insertions(+), 212 deletions(-)
 create mode 100644 Documentation/x86/entry_64.txt
 create mode 100644 arch/x86/kernel/vsyscall_emu_64.S

-- 
1.7.5.2

