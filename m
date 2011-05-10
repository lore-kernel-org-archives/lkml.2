Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab1EJOPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:15:30 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:55139 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755566Ab1EJOP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:15:29 -0400
X-AuditID: 1209190f-b7c4dae0000007bd-82-4dc94882ec7e
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 0/6] Micro-optimize vclock_gettime
Date: Tue, 10 May 2011 10:15:02 -0400
Message-Id: <cover.1305035945.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsUixCmqrdvkcdLXYMt6ZYuLbRfZLPquHGW3
	OHLtO7vFnPMtLBb73p9ls7i8aw6bxZZLzawWa6e+YbHYvGkqs8WjvrfsFj82PGZ14Pa48pTD
	Y8vKm0wet9r+MHvM3/mR0WPnrLvsHptWdbJ5vDt3jt3jxIzfLB6bT1d7fN4kF8AVxWWTkpqT
	WZZapG+XwJUx82dCQZ98xc7dq1kaGG9LdDFyckgImEicnHKQGcIWk7hwbz0biC0ksI9Rontm
	WRcjF5C9gVHizYfPLBCJZ0wSv1qFQWw2ARWJjqUPmLoYOThEBIQklt6tAwkzCyxmlvh63wnE
	FhYwlTjdsZkdxGYRUJU4OOcbmM0roC/R/OERO8ReBYkrV+axTGDkWcDIsIpRNiW3Sjc3MTOn
	ODVZtzg5MS8vtUjXRC83s0QvNaV0EyM4PCX5dzB+O6h0iFGAg1GJh7ec8YSvEGtiWXFl7iFG
	SQ4mJVHeyy4nfYX4kvJTKjMSizPii0pzUosPMUpwMCuJ8M77CVTOm5JYWZValA+TkuZgURLn
	nSWp7iskkJ5YkpqdmlqQWgSTleHgUJLgfeoONFSwKDU9tSItM6cEIc3EwQkynAdo+CGQGt7i
	gsTc4sx0iPwpRmOOLd0NBxg5prc1H2AUYsnLz0uVEuf9DFIqAFKaUZoHNw2WYl4xigM9J8zL
	BUw4QjzA9AQ37xXQKiagVeYbQP4oLklESEk1MNrkJkuc2G98toj5sa/fh8f/63Tvbkk8rJhw
	bU2BG+cK3QttUpyVf18/sbed8J378pFLq78VcmyZled9b17hwdWhtTms65rLf3yKYFkerbpy
	efFF/+nPj1xsEu1UdxWXMWs6Kthv+GTiu6xuRZ87n/m5Nj3Vf5t17QD/dblnV/7POrVHtq36
	V78SS3FGoqEWc1FxIgDjuCL0DAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series speeds up vclock_gettime(CLOCK_MONOTONIC) on by almost
30% (tested on Sandy Bridge).  These patches are intended for
2.6.40, and if I'm feeling really ambitious I'll try to shave a few
more ns off for 2.6.41.  (There are lots more optimization
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

Andy Lutomirski (6):
  x86-64: Clean up vdso/kernel shared variables
  x86-64: Remove unnecessary barrier in vread_tsc
  x86-64: Don't generate cmov in vread_tsc
  x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0
  x86-64: Move vread_tsc into a new file with sensible options
  x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO

 arch/x86/include/asm/tsc.h      |    4 +++
 arch/x86/include/asm/vdso.h     |   14 ----------
 arch/x86/include/asm/vgtod.h    |    2 -
 arch/x86/include/asm/vsyscall.h |   12 +-------
 arch/x86/include/asm/vvar.h     |   52 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/Makefile        |    8 +++--
 arch/x86/kernel/time.c          |    2 +-
 arch/x86/kernel/tsc.c           |   19 --------------
 arch/x86/kernel/vmlinux.lds.S   |   34 ++++++++-----------------
 arch/x86/kernel/vread_tsc_64.c  |   36 +++++++++++++++++++++++++++
 arch/x86/kernel/vsyscall_64.c   |   46 +++++++++++++++-------------------
 arch/x86/vdso/Makefile          |   17 +++++++++++-
 arch/x86/vdso/vclock_gettime.c  |   43 +++++++++++++++++---------------
 arch/x86/vdso/vdso.lds.S        |    7 -----
 arch/x86/vdso/vextern.h         |   16 ------------
 arch/x86/vdso/vgetcpu.c         |    3 +-
 arch/x86/vdso/vma.c             |   27 --------------------
 arch/x86/vdso/vvar.c            |   12 ---------
 18 files changed, 170 insertions(+), 184 deletions(-)
 create mode 100644 arch/x86/include/asm/vvar.h
 create mode 100644 arch/x86/kernel/vread_tsc_64.c
 delete mode 100644 arch/x86/vdso/vextern.h
 delete mode 100644 arch/x86/vdso/vvar.c

-- 
1.7.5.1

