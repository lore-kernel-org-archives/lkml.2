Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1GJDWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 23:22:22 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:50353 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755219Ab1GJDWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 23:22:21 -0400
X-AuditID: 12074424-b7bc6ae000005a77-b1-4e191aebb440
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 0/8] x86-64 vDSO changes for 3.1
Date: Sat,  9 Jul 2011 23:22:07 -0400
Message-Id: <cover.1310267866.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsUixG6nrvtGStLPoOMms0XflaPsFhcbt7FY
	tK6dz25xedccNostl5pZLX5seMzqwObR/egTo8ettj/MHjtn3WX32LSqk83j3LU+Zo/Pm+QC
	2KK4bFJSczLLUov07RK4MnY/u8da8Ey5ouFiG2sDY6t0FyMnh4SAicSHt09YIWwxiQv31rN1
	MXJxCAnsY5Q48fk1K4SznlFi7d0TbCBVQgJPmSTeP3UCsdkEVCQ6lj5g6mLk4BAREJJYercO
	pJ5ZYBOjxK9NExlBaoQFjCUO/JrBDmKzCKhKtG6YzQZSzyugLzG50QNisZzEkcvPmSYw8ixg
	ZFjFKJuSW6Wbm5iZU5yarFucnJiXl1qka66Xm1mil5pSuokRHEwuKjsYmw8pHWIU4GBU4uH9
	WSzhJ8SaWFZcmXuIUZKDSUmUlxcYikJ8SfkplRmJxRnxRaU5qcWHGCU4mJVEeGs2AZXzpiRW
	VqUW5cOkpDlYlMR5S73/+woJpCeWpGanphakFsFkZTg4lCR4A0GGChalpqdWpGXmlCCkmTg4
	QYbzAA3nBKnhLS5IzC3OTIfIv2IUBzpTmJcLJMUDjHAkGQmga0V4pz8Huai4JBEhJdXA2F0w
	VWdfvOybrz/vHNSdv/icrualX/wzGJ7s4hXY/iX8q7Tuu41RnpdqDood5Qm73BJ3xrQy46De
	B/aWrD9bbMqYTwQ2vj3CYBe+4mJKWfqynZLVi3ZmrhJ5+u3flJ9pynJXM2epbTq99Oz+Jo+Y
	3IlnboVW7v1hNVeQx6Oi5YrXnKTsjFULfyixFGckGmoxFxUnAgADmr5IrQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series applies to the x86/vdso branch of the -tip tree.

The first patch cleans up the vsyscall emulation code.

After the vsyscall emulation patches, the only real executable code left
in the vsyscall page is vread_tsc and vread_hpet.  That code is only
called from the vDSO, so patches 2-6 move it into the vDSO.

vread_tsc() uses rdtsc_barrier(), which contains two alternatives.
Patches 2 and 3 make alternative patching work in the vDSO.  (This has a
slightly odd side effect that the vDSO image dumped from memory doesn't
quite match the debug version anymore, but it's hard to imagine that
causing problems.)

Patch 4 fixes an annoyance I found while writing this code.  If you
introduce an undefined symbol into the vDSO, you get an unhelpful error
message.  ld is smart enough to give a nice error if you ask it to.

Patch 5 cleans up the architecture-specific part of struct clocksource.
IA64 had its own ifdefed code in there, and the supposedly generic vread
pointer was only used by x86-64.  With the patch, each arch gets to set
up its own private part of struct clocksource.

Patch 6 is the meat.  It moves vread_tsc and vread_hpet into the vDSO
where they belong, and it's a net deletion of code because it removes a
bunch of magic needed to make regular functions accessible through the
vsyscall page.

With patches 1-6 applied, every single byte in the vsyscall
page is some sort of trap instruction.

Patches 7 and 8 are optional.  Patch 7 changes IA64 to use the new arch
gtod data.  It presumably should not go in through the x86 tree.  Patch
8 adds some vDSO documentation and a reference vDSO parser for user code
to use.  It's meant for projects that don't dynamically link to glibc
(e.g. Go) but still want to call the vDSO.  Someone who knows more about
ELF than I should take a look.

*** Note to IA64 people: I have not even compile-tested this on IA64. ***

Changes from v1:
 - Tidy up vDSO alternative patching (thanks, Borislav).
 - Fix really dumb bugs in the IA64 stuff.
 - Add the cleanup patch and the reference vDSO parser.
 - Split the main IA-64 patch out.

Andy Lutomirski (8):
  x86-64: Improve vsyscall emulation CS and RIP handling
  x86: Make alternative instruction pointers relative
  x86-64: Allow alternative patching in the vDSO
  x86-64: Add --no-undefined to vDSO build
  clocksource: Replace vread with generic arch data
  x86-64: Move vread_tsc and vread_hpet into the vDSO
  ia64: Replace clocksource.fsys_mmio with generic arch data
  Document the vDSO and add a reference parser

 Documentation/ABI/stable/vdso          |   27 ++++
 Documentation/vDSO/parse_vdso.c        |  256 ++++++++++++++++++++++++++++++++
 Documentation/vDSO/vdso_test.c         |  112 ++++++++++++++
 arch/ia64/include/asm/clocksource.h    |   12 ++
 arch/ia64/kernel/cyclone.c             |    2 +-
 arch/ia64/kernel/time.c                |    2 +-
 arch/ia64/sn/kernel/sn2/timer.c        |    2 +-
 arch/x86/include/asm/alternative-asm.h |    4 +-
 arch/x86/include/asm/alternative.h     |    8 +-
 arch/x86/include/asm/clocksource.h     |   20 +++
 arch/x86/include/asm/cpufeature.h      |    8 +-
 arch/x86/include/asm/tsc.h             |    4 -
 arch/x86/include/asm/vgtod.h           |    2 +-
 arch/x86/include/asm/vsyscall.h        |   16 --
 arch/x86/kernel/Makefile               |    7 +-
 arch/x86/kernel/alternative.c          |   23 ++--
 arch/x86/kernel/hpet.c                 |    9 +-
 arch/x86/kernel/tsc.c                  |    2 +-
 arch/x86/kernel/vmlinux.lds.S          |    3 -
 arch/x86/kernel/vread_tsc_64.c         |   36 -----
 arch/x86/kernel/vsyscall_64.c          |   61 +++++---
 arch/x86/lib/copy_page_64.S            |    9 +-
 arch/x86/lib/memmove_64.S              |   11 +-
 arch/x86/vdso/Makefile                 |    1 +
 arch/x86/vdso/vclock_gettime.c         |   52 ++++++-
 arch/x86/vdso/vma.c                    |   30 ++++
 drivers/char/hpet.c                    |    2 +-
 include/asm-generic/clocksource.h      |    4 +
 include/linux/clocksource.h            |   13 +-
 29 files changed, 589 insertions(+), 149 deletions(-)
 create mode 100644 Documentation/ABI/stable/vdso
 create mode 100644 Documentation/vDSO/parse_vdso.c
 create mode 100644 Documentation/vDSO/vdso_test.c
 create mode 100644 arch/ia64/include/asm/clocksource.h
 create mode 100644 arch/x86/include/asm/clocksource.h
 delete mode 100644 arch/x86/kernel/vread_tsc_64.c
 create mode 100644 include/asm-generic/clocksource.h

-- 
1.7.6

