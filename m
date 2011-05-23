Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab1EWNcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:32:46 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:65163 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098Ab1EWNcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:32:45 -0400
X-AuditID: 12074422-b7b0eae000007f48-a7-4dda620a484a
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 0/8] vDSO time changes for 2.6.40
Date: Mon, 23 May 2011 09:31:23 -0400
Message-Id: <cover.1306156808.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsUixCmqrMuVdMvXYM0Vc4uLbRfZLPquHGW3
	OHLtO7vFxcZtLBZzzrewWOx7f5bN4vKuOWwWWy41s1ps3jSV2eJR31t2ix8bHrM6cHt0P/rE
	6HHlKYfHlpU3mTxutf1h9pi/8yOjx85Zd9k9Nq3qZPN4d+4cu8eJGb9ZPD5vkgvgiuKySUnN
	ySxLLdK3S+DKePFvNWPBJvWKizP2MDUwNsl3MXJySAiYSFz4fZkZwhaTuHBvPVsXIxeHkMA+
	Roljnw+wQzgbGCXmv5vIBOE8Y5K4cOU+I0gLm4CKRMfSB0AJDg4RASGJpXfrQGqYBdYyS+zr
	XswEUiMMtOLG/iYWEJtFQFViwesHbCA2r4C+xJG1j5ggVitIXLkyj2UCI88CRoZVjLIpuVW6
	uYmZOcWpybrFyYl5ealFuqZ6uZkleqkppZsYQYHK7qK0g/HnQaVDjAIcjEo8vIs0b/oKsSaW
	FVfmHmKU5GBSEuV1ib/lK8SXlJ9SmZFYnBFfVJqTWnyIUYKDWUmEt0H7hq8Qb0piZVVqUT5M
	SpqDRUmcd46kuq+QQHpiSWp2ampBahFMVoaDQ0mCNy0RaKhgUWp6akVaZk4JQpqJgxNkOA/Q
	8F6QGt7igsTc4sx0iPwpRmOOzgc/DjByTL39+wCjEEtefl6qlDhvHEipAEhpRmke3DRYsnnF
	KA70nDBvAEgVDzBRwc17BbSKCWiVxN+bIKtKEhFSUg2MC30lDl7/ZhV+qPNX2TGjM6+02QRX
	r3jt8n5v7rH9x95uSty09fUxuVnWe+8kbL9bzhvQKJrOs96h15d3etUu3p//OS3mPXj/84Gg
	7NNbu7xP8vf33pinGC3styxEp8hO+tzGGUq6VbmX/wVob5af/rtZacmd37Nrn0sKXv7z3DnR
	RcI1NYj3txJLcUaioRZzUXEiAO7FJ0MRAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch 8/8 is brand-new and optional.  If anyone objects to it,
 please just drop it for 2.6.40 and I'll fix it for 2.6.41.]

This series speeds up vclock_gettime(CLOCK_MONOTONIC) on by almost 30%
(tested on Sandy Bridge).  It also adds time() to the vDSO so that we
can deprecate the vsyscall entry points later on.  These patches are
intended for 2.6.40, and if I'm feeling really ambitious I'll try to
shave a few more ns off for 2.6.41.  (There are lots more optimization
opportunities in there.)

x86-64: Clean up vdso/kernel shared variables

Because vsyscall_gtod_data's address isn't known until load time,
the code contains unnecessary address calculations.  The code is
also rather complicated.  Clean it up and use addresses that are
known at compile time.

x86-64: Remove unnecessary barrier in vread_tsc

A fair amount of testing on lots of machines has failed to find a
single example in which the barrier *after* rdtsc is needed. So
remove it.  (The manuals give no real justification for it, and
rdtsc has no dependencies so there's no sensible reason for a CPU to
delay it.)

x86-64: Don't generate cmov in vread_tsc

GCC likes to generate a cmov on a branch that's almost completely
predictable.  Force it to generate a real branch instead.

x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0

vset_normalize_timespec was more general than necessary.  Open-code
the appropriate normalization loops.  This is a big win for
CLOCK_MONOTONIC_COARSE.

x86-64: Move vread_tsc into a new file with sensible options

This way vread_tsc doesn't have a frame pointer, with saves about
0.3ns.  I guess that the CPU's stack frame optimizations aren't quite
as good as I thought.

x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO

We're building the vDSO with optimizations disabled that were meant
for kernel code.  Override that, except for -fno-omit-frame-pointers,
which might make userspace debugging harder.

x86-64: Add time to vDSO
x86-64: Optimize vDSO time()

These aren't strictly related, but they depend on the vvar cleanup.
They will allow us to deprecate all of the vsyscall entries.

Changes from v4:
 - Rebase to 2.6.39.
 - Add a missing Signed-off-by.
 - Add time() to vDSO.
 - Add optional patch 8/8 to optimize vDSO time() as an extra
   incentive to use it over the old time() vsyscall.

Changes from v3:
 - Put jiffies and vgetcpu_mode into the same cacheline.  I folded it
   into the vsyscall cleanup patch because it's literally just changing
   a number.  (In theory one more cacheline could be saved by putting
   jiffies and vgetcpu_mode at the end of gtod_data, but that would be
   annoying to maintain and would, I think, have little benefit.
 - Don't turn off frame pointers in vDSO code.

Changes from v2:
 - Just remove the second barrier instead of hacking it.  Tests
   still pass.

Changes from v1:
 - Redo the vsyscall_gtod_data address patch to make the code
   cleaner instead of uglier and to make it work for all the
   vsyscall variables.
 - Improve the comments for clarity and formatting.
 - Fix up the changelog for the nsec < 0 tweak (the normalization
   code can't be inline because the two callers are different).
 - Move vread_tsc into its own file, removing a GCC version
   dependence and making it more maintainable.

Andy Lutomirski (8):
  x86-64: Clean up vdso/kernel shared variables
  x86-64: Remove unnecessary barrier in vread_tsc
  x86-64: Don't generate cmov in vread_tsc
  x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0
  x86-64: Move vread_tsc into a new file with sensible options
  x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO
  x86-64: Add time to vDSO
  x86-64: Optimize vDSO time()

 arch/x86/include/asm/tsc.h      |    4 ++
 arch/x86/include/asm/vdso.h     |   14 -------
 arch/x86/include/asm/vgtod.h    |    2 -
 arch/x86/include/asm/vsyscall.h |   12 +-----
 arch/x86/include/asm/vvar.h     |   52 +++++++++++++++++++++++++++
 arch/x86/kernel/Makefile        |    8 +++--
 arch/x86/kernel/time.c          |    2 +-
 arch/x86/kernel/tsc.c           |   19 ----------
 arch/x86/kernel/vmlinux.lds.S   |   34 ++++++------------
 arch/x86/kernel/vread_tsc_64.c  |   36 +++++++++++++++++++
 arch/x86/kernel/vsyscall_64.c   |   46 ++++++++++--------------
 arch/x86/vdso/Makefile          |   17 ++++++++-
 arch/x86/vdso/vclock_gettime.c  |   74 ++++++++++++++++++++++++++++-----------
 arch/x86/vdso/vdso.lds.S        |    9 +----
 arch/x86/vdso/vextern.h         |   16 --------
 arch/x86/vdso/vgetcpu.c         |    3 +-
 arch/x86/vdso/vma.c             |   27 --------------
 arch/x86/vdso/vvar.c            |   12 ------
 18 files changed, 202 insertions(+), 185 deletions(-)
 create mode 100644 arch/x86/include/asm/vvar.h
 create mode 100644 arch/x86/kernel/vread_tsc_64.c
 delete mode 100644 arch/x86/vdso/vextern.h
 delete mode 100644 arch/x86/vdso/vvar.c

-- 
1.7.5.1

