Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab1EJOPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:15:52 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:42294 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932233Ab1EJOPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:15:48 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-17-4dc9489776c3
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 2/6] x86-64: Remove unnecessary barrier in vread_tsc
Date: Tue, 10 May 2011 10:15:04 -0400
Message-Id: <b5f2b5030b3871e923a8ec8e54e1548bfce87574.1305035945.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305035945.git.luto@mit.edu>
References: <cover.1305035945.git.luto@mit.edu>
In-Reply-To: <cover.1305035945.git.luto@mit.edu>
References: <cover.1305035945.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsUixCmqrDvd46SvwZY3BhYX2y6yWfRdOcpu
	ceTad3aLOedbWCz2vT/LZnF51xw2iy2Xmlkt1k59w2KxedNUZotHfW/ZLX5seMzqwO1x5SmH
	x5aVN5k8brX9YfaYv/Mjo8fOWXfZPTat6mTzeHfuHLvHiRm/WTw2n672+LxJLoArissmJTUn
	syy1SN8ugSvjfw9rwSaeiq3LlRsYf3F2MXJySAiYSHx90swIYYtJXLi3nq2LkYtDSGAfo8Sf
	B9+ZIZwNjBLLllxkh3CeMUls3djOBtLCJqAi0bH0AVMXIweHiICQxNK7dSBhZoHFzBJf7zuB
	2MIC7hLL9i0FK2ERUJVY1eABEuYVCJJ4f3YyE8RiBYkrV+axgNicAgYSbw//A5suJKAvsWjp
	MZziExgFFjAyrGKUTcmt0s1NzMwpTk3WLU5OzMtLLdI11svNLNFLTSndxAgOf0m+HYxfDyod
	YhTgYFTi4S1gPOErxJpYVlyZe4hRkoNJSZT3sstJXyG+pPyUyozE4oz4otKc1OJDjBIczEoi
	vPN+ApXzpiRWVqUW5cOkpDlYlMR5Z0qq+woJpCeWpGanphakFsFkZTg4lCR4n7oDDRUsSk1P
	rUjLzClBSDNxcIIM5wEafgikhre4IDG3ODMdIn+KUZdjelvzAUYhlrz8vFQpcd7PIEUCIEUZ
	pXlwc2Bp6xWjONBbwrxcwCQmxANMeXCTXgEtYQJaYr4B5IPikkSElFQDo1zBTHvNybsuapuz
	7Xnqt6Vyyuz4865v1FgbXu5+oX39qk66Ia/Z/JgZh5pDl8oUv06599U012fmJI2p1/KC/eLq
	91x/vnpbXNV5WwaRJ8WrVl687x2l3DDz5Zfcrv3C7UL78nTM0t93vn2SILLdTutl6kctvkn5
	h3T9whUNwyrv1TKGMJ9PVWIpzkg01GIuKk4EAChsm3E2AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RDTSC is completely unordered on modern Intel and AMD CPUs.  The
Intel manual says that lfence;rdtsc causes all previous instructions
to complete before the tsc is read, and the AMD manual says to use
mfence;rdtsc to do the same thing.

>From a decent amount of testing [1] this is enough to make rdtsc
be ordered with respect to subsequent loads across a wide variety
of CPUs.

On Sandy Bridge (i7-2600), this improves a loop of
clock_gettime(CLOCK_MONOTONIC) by more than 5 ns/iter.

[1] https://lkml.org/lkml/2011/4/18/350

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/tsc.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index bc46566..7cabdae 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -769,13 +769,14 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 	cycle_t ret;
 
 	/*
-	 * Surround the RDTSC by barriers, to make sure it's not
-	 * speculated to outside the seqlock critical section and
-	 * does not cause time warps:
+	 * Empirically, a fence (of type that depends on the CPU)
+	 * before rdtsc is enough to ensure that rdtsc is ordered
+	 * with respect to loads.  The various CPU manuals are unclear
+	 * as to whether rdtsc can be reordered with later loads,
+	 * but no one has ever seen it happen.
 	 */
 	rdtsc_barrier();
 	ret = (cycle_t)vget_cycles();
-	rdtsc_barrier();
 
 	return ret >= VVAR(vsyscall_gtod_data).clock.cycle_last ?
 		ret : VVAR(vsyscall_gtod_data).clock.cycle_last;
-- 
1.7.5.1

