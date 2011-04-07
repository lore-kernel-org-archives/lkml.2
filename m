Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab1DGCEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:04:31 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:64878 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665Ab1DGCE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:04:29 -0400
X-AuditID: 12074425-b7c8cae00000429f-a2-4d9d1bb55531
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [RFT/PATCH v2 0/6] Micro-optimize vclock_gettime
Date: Wed,  6 Apr 2011 22:03:57 -0400
Message-Id: <cover.1302137785.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsUixG6nrrtVeq6vwbor0hZ9V46yWxy59p3d
	4vKuOWwWWy41s1ps3jSV2eLHhsesDmwet9r+MHvM3/mR0WPnrLvsHptWdbJ5vDt3jt3j8ya5
	ALYoLpuU1JzMstQifbsErowp36azFTxUrnh5VK2BcY9MFyMnh4SAicTTD9vZIWwxiQv31rN1
	MXJxCAnsY5TYf7aFGcJZzyhxclsfO4TzlEnizvqrLCAtbAIqEh1LHzB1MXJwiAgISSy9WwdS
	wyywnVFiw/J2sBphAUuJ/3e2s4HYLAKqEpN/vAFbxyugLzF/6hwgmx1otZxEc+AERp4FjAyr
	GGVTcqt0cxMzc4pTk3WLkxPz8lKLdC30cjNL9FJTSjcxgkPJRXUH44RDSocYBTgYlXh4Qzvn
	+AqxJpYVV+YeYpTkYFIS5e2UmOsrxJeUn1KZkVicEV9UmpNafIhRgoNZSYRXSQgox5uSWFmV
	WpQPk5LmYFES550vqe4rJJCeWJKanZpakFoEk5Xh4FCS4E0AxoyQYFFqempFWmZOCUKaiYMT
	ZDgP0PAJ4iDDiwsSc4sz0yHypxiNOfb079/HyPF/y6F9jEIsefl5qVLivGkg4wRASjNK8+Cm
	wdLBK0ZxoOeEeQNBqniAqQRu3iugVUxAqxaemwOyqiQRISXVwJinkdqmFtNYo7q+fwJvYoTH
	/kC3rDlJhfzy/8srZ7RcPB638kMJ6xR/N9GLG8+Gzkhp3R757Hd3Mn+5XnaR7x8jxcXzvmhc
	XaC8XqZ5QvU/xv1uF3cHfn81M2bGmV8ss29OfLvJd+UZo4TNd4JfXy1YbKBv2X4pvez+nFlN
	Tycol/Gmzy9aXqTEUpyRaKjFXFScCADzDjSf4gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series speeds up vclock_gettime(CLOCK_MONOTONIC) on by almost 30%
(tested on Sandy Bridge).

I'm hoping someone can test this with Ingo's time-warp-test, which
you can get here:

http://people.redhat.com/mingo/time-warp-test/time-warp-test.c

You'll need to change TEST_CLOCK to 1.  I'm especially interested
in Core 2, Pentium D, Westmere, or AMD systems with usable TSCs.
(I've already tested on Sandy Bridge and Bloomfield (Xeon W3520)).

The changes and timings (fastest of 20 trials of 100M iters on Sandy
Bridge) are:

CLOCK_MONOTONIC: 22.09ns -> 15.66ns
CLOCK_REALTIME_COARSE: 4.23ns -> 3.44ns
CLOCK_MONOTONIC_COARSE: 5.65ns -> 4.23ns

x86-64: Clean up vdso/kernel shared variables

Because vsyscall_gtod_data's address isn't known until load time, the
code contains unnecessary address calculations.  The code is also
rather complicated.  Clean it up and use addresses that are known at
compile time.

x86-64: Optimize vread_tsc's barriers

This replaces lfence;rdtsc;lfence with a faster sequence with similar
ordering guarantees.

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

Changes from v1:
 - Redo the vsyscall_gtod_data address patch to make the code
   cleaner instead of uglier and to make it work for all the
   vsyscall variables.
 - Improve the comments for clarity and formatting.
 - Fix up the changelog for the nsec < 0 tweak (the normalization
   code can't be inline because the two callers are different).
 - Move vread_tsc into its own file, removing a GCC version
   dependence and making it more maintainable.

Ingo, I looked at moving vread_tsc into a .S file, but I think
it would be less maintainable for a few reasons:
 - rdtsc_barrier() would need an assembly version.  It uses
   alternatives.
 - The code needs access to the VVAR magic, which would need an
   assembly-callable version.  (This woudn't be so bad, but
   it's more code.)
 - It needs to know the offset of cycles_last.  This would
   involve adding an extra asm offset.
 - I don't think it's that bad in C, and the code it generates
   looks good.

Andy Lutomirski (6):
  x86-64: Clean up vdso/kernel shared variables
  x86-64: Optimize vread_tsc's barriers
  x86-64: Don't generate cmov in vread_tsc
  x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0
  x86-64: Move vread_tsc into a new file with sensible options
  x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO

 arch/x86/include/asm/tsc.h      |    4 +++
 arch/x86/include/asm/vdso.h     |   14 ----------
 arch/x86/include/asm/vgtod.h    |    2 -
 arch/x86/include/asm/vsyscall.h |   12 +-------
 arch/x86/include/asm/vvar.h     |   52 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/Makefile        |    8 +++--
 arch/x86/kernel/time.c          |    2 +-
 arch/x86/kernel/tsc.c           |   19 -------------
 arch/x86/kernel/vmlinux.lds.S   |   34 ++++++++----------------
 arch/x86/kernel/vread_tsc_64.c  |   55 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/vsyscall_64.c   |   46 ++++++++++++++------------------
 arch/x86/vdso/Makefile          |   17 ++++++++++-
 arch/x86/vdso/vclock_gettime.c  |   43 ++++++++++++++++--------------
 arch/x86/vdso/vdso.lds.S        |    7 -----
 arch/x86/vdso/vextern.h         |   16 -----------
 arch/x86/vdso/vgetcpu.c         |    3 +-
 arch/x86/vdso/vma.c             |   27 -------------------
 arch/x86/vdso/vvar.c            |   12 --------
 18 files changed, 189 insertions(+), 184 deletions(-)
 create mode 100644 arch/x86/include/asm/vvar.h
 create mode 100644 arch/x86/kernel/vread_tsc_64.c
 delete mode 100644 arch/x86/vdso/vextern.h
 delete mode 100644 arch/x86/vdso/vvar.c

-- 
1.7.4

