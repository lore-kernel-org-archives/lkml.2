Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab1FGTcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:32:54 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:47479 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755094Ab1FGTcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:32:53 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-5a-4dee7ca0c16c
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 0/5] Remove remaining executable code from x86-64 vsyscall page
Date: Tue,  7 Jun 2011 15:32:37 -0400
Message-Id: <cover.1307474707.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsUixG6norug5p2vwYQuNou+K0fZLS7vmsNm
	seVSM6vFjw2PWR1YPG61/WH22DnrLrvHplWdbB6fN8kFsERx2aSk5mSWpRbp2yVwZaz7/Yq9
	4Ll0RfPGhWwNjC9Fuhg5OSQETCTuvFjPBmGLSVy4B2JzcQgJ7GOUuNp+AMpZzyhx6fZfKOcQ
	k8SylauZQFrYBFQkOpY+ALI5OEQEhCSW3q0DCTMLpEnMvf6LBSQsLOAvcfq0E4jJIqAq0XOd
	EaSCV0BfYlrvUWaQsISAgsT5VfkTGHkWMDKsYpRNya3SzU3MzClOTdYtTk7My0st0jXSy80s
	0UtNKd3ECAoQTkneHYzvDiodYhTgYFTi4U0PeecrxJpYVlyZe4hRkoNJSZR3FjC8hPiS8lMq
	MxKLM+KLSnNSiw8xSnAwK4nwzrj+1leINyWxsiq1KB8mJc3BoiTOO1NS3VdIID2xJDU7NbUg
	tQgmK8PBoSTBmwoyVLAoNT21Ii0zpwQhzcTBCTKcB2g42GLe4oLE3OLMdIj8KUZdjq0n3h5k
	FGLJy89LlRLnLQcpEgApyijNg5sDi+xXjOJAbwnzJoJU8QCTAtykV0BLmICWnD4L8kFxSSJC
	SqqB0U62MKTtWOP2ztITR4XuZ9V8mfbSsr+KZ8f62E87D7zZ8TPMpv6I9myOxzc8Gpb7J0W5
	l4WfSPC7HmZ87KS176l7fzSSmJOZl39NyL8a+KW3cMkk56Zv215nRGta6S6vv6YgqdLvNO3Q
	m2+t3Wclmw/+dDq1+sD6DxOnCR1cILP7g/OsrW9lopRYijMSDbWYi4oTAVNsFxLHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the vsyscall emulation patches, the only real executable code left
in the vsyscall page is vread_tsc and vread_hpet.  That code is only
called from the vDSO, so move it into the vDSO.

The first four patches prepare to move the code.

vread_tsc() uses rdtsc_barrier(), which contains two alternatives.
Patch 1 and 2 make alternative patching work in the vDSO.  (This has a
slightly odd side effect that the vDSO image dumped from memory doesn't
quite match the debug version anymore, but it's hard to imagine that
causing problems.)

Patch 3 fixes an annoyance I found while writing this code.  If you
introduce an undefined symbol into the vDSO, you get an unhelpful error
message.  ld is smart enough to give a nice error if you ask it to.

Patch 4 cleans up the architecture-specific part of struct clocksource.
IA64 had its own ifdefed code in there, and the supposedly generic vread
pointer was only used by x86-64.  With the patch, each arch gets to set
up its own private part of struct clocksource.

*** Note to IA64 people: I have not even compile-tested this on IA64. ***

Patch 5 is the meat.  It moves vread_tsc and vread_hpet into the vDSO
where they belong, and it's a net deletion of code because it removes a
bunch of magic needed to make regular functions accessible through the
vsyscall page.

With all of these patches applied, every single byte in the vsyscall
page is some sort of trap instruction.

This series applies to the x86/vdso branch of the -tip tree.

Andy Lutomirski (5):
  x86: Make alternative instruction pointers relative
  x86-64: Allow alternative patching in the vDSO
  x86-64: Add --no-undefined to vDSO build
  clocksource: Replace vread and fsys_mmio with generic arch data
  x86-64: Move vread_tsc and vread_hpet into the vDSO

 arch/ia64/include/asm/clocksource.h    |   16 ++++++++++
 arch/ia64/kernel/cyclone.c             |    2 +-
 arch/ia64/kernel/time.c                |    2 +-
 arch/ia64/sn/kernel/sn2/timer.c        |    2 +-
 arch/x86/include/asm/alternative-asm.h |    4 +-
 arch/x86/include/asm/alternative.h     |    8 ++--
 arch/x86/include/asm/clocksource.h     |   20 ++++++++++++
 arch/x86/include/asm/cpufeature.h      |    8 ++--
 arch/x86/include/asm/tsc.h             |    4 --
 arch/x86/include/asm/vgtod.h           |    2 +-
 arch/x86/include/asm/vsyscall.h        |    4 --
 arch/x86/kernel/Makefile               |    7 +----
 arch/x86/kernel/alternative.c          |   23 ++++++--------
 arch/x86/kernel/hpet.c                 |    9 +-----
 arch/x86/kernel/tsc.c                  |    2 +-
 arch/x86/kernel/vmlinux.lds.S          |    3 --
 arch/x86/kernel/vread_tsc_64.c         |   36 ----------------------
 arch/x86/kernel/vsyscall_64.c          |    2 +-
 arch/x86/lib/copy_page_64.S            |    9 ++----
 arch/x86/lib/memmove_64.S              |   11 +++----
 arch/x86/vdso/Makefile                 |    1 +
 arch/x86/vdso/vclock_gettime.c         |   52 ++++++++++++++++++++++++++++----
 arch/x86/vdso/vma.c                    |   32 +++++++++++++++++++
 drivers/char/hpet.c                    |    2 +-
 include/asm-generic/clocksource.h      |    4 ++
 include/linux/clocksource.h            |   13 ++++----
 26 files changed, 162 insertions(+), 116 deletions(-)
 create mode 100644 arch/ia64/include/asm/clocksource.h
 create mode 100644 arch/x86/include/asm/clocksource.h
 delete mode 100644 arch/x86/kernel/vread_tsc_64.c
 create mode 100644 include/asm-generic/clocksource.h

-- 
1.7.5.2

