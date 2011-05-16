Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab1EPQE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:04:27 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:60262 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756299Ab1EPQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:04:26 -0400
X-AuditID: 12074422-b7b0eae000007f48-ff-4dd14b13c8b8
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
Subject: [PATCH v4 3/6] x86-64: Don't generate cmov in vread_tsc
Date: Mon, 16 May 2011 12:01:00 -0400
Message-Id: <39640551c99b74497be4928e256849d95bd80390.1305560561.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305560561.git.luto@mit.edu>
References: <cover.1305560561.git.luto@mit.edu>
In-Reply-To: <cover.1305560561.git.luto@mit.edu>
References: <cover.1305560561.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsUixCmqrSvifdHXYN9ffouLbRfZLPquHGW3
	OHLtO7vFxcZtLBZzzrewWOx7f5bN4vKuOWwWWy41s1ps3jSV2eJR31t2ix8bHrM6cHt0P/rE
	6HHlKYfHlpU3mTxutf1h9pi/8yOjx85Zd9k9Nq3qZPN4d+4cu8eJGb9ZPD5vkgvgiuKySUnN
	ySxLLdK3S+DK6Dr3i71gMU/F+6ZN7A2MHzi7GDk4JARMJBa+AjI5gUwxiQv31rN1MXJxCAns
	Y5To3XWMBcLZwChxZsY+RgjnGZPE6WsrWUFa2ARUJDqWPmACmSQiICSx9G4dSA2zwFpmiX3d
	i5lAaoQFHCQO/fgDZrMIqEqsmtDCDlLPKxAkMeOEPsRmBYkrV+axgNicAgYS2w9vYQaxhQT0
	JbrW/GfEJT6BUWABI8MqRtmU3Crd3MTMnOLUZN3i5MS8vNQiXVO93MwSvdSU0k2MoChgd1Ha
	wfjzoNIhRgEORiUe3j9OF32FWBPLiitzDzFKcjApifIauAKF+JLyUyozEosz4otKc1KLDzFK
	cDArifCeqb/gK8SbklhZlVqUD5OS5mBREuedI6nuKySQnliSmp2aWpBaBJOV4eBQkuBV9gIa
	KliUmp5akZaZU4KQZuLgBBnOAzTcE6SGt7ggMbc4Mx0if4pRl+Pzo0MHGIVY8vLzUqXEef1B
	igRAijJK8+DmwJLXK0ZxoLeEeWtBqniAiQ9u0iugJUxAS1adAvmguCQRISXVwBi6Z0ZwwAMJ
	ruJ108vqfm+8m+CWndK4TPzD7purytxnOp4KnZi7SLKgaZ/P/WCBp8t/C0z+fMYvJCAktdxi
	TnvWxOqghj23C6qOW5/4Hc6THSqe53QuJ8OA3zToq3D21ZsbPy2+Z8Wl7xEmfWTrJI1sl9tb
	q58l7ZqdPPtNtz4D4wXB4A2yHEosxRmJhlrMRcWJAFERsno5AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vread_tsc checks whether rdtsc returns something less than
cycle_last, which is an extremely predictable branch.  GCC likes
to generate a cmov anyway, which is several cycles slower than
a predicted branch.  This saves a couple of nanoseconds.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/tsc.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 7cabdae..db4c6e6 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -767,6 +767,7 @@ static cycle_t read_tsc(struct clocksource *cs)
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret;
+	u64 last;
 
 	/*
 	 * Empirically, a fence (of type that depends on the CPU)
@@ -778,8 +779,21 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 	rdtsc_barrier();
 	ret = (cycle_t)vget_cycles();
 
-	return ret >= VVAR(vsyscall_gtod_data).clock.cycle_last ?
-		ret : VVAR(vsyscall_gtod_data).clock.cycle_last;
+	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
+
+	if (likely(ret >= last))
+		return ret;
+
+	/*
+	 * GCC likes to generate cmov here, but this branch is extremely
+	 * predictable (it's just a funciton of time and the likely is
+	 * very likely) and there's a data dependence, so force GCC
+	 * to generate a branch instead.  I don't barrier() because
+	 * we don't actually need a barrier, and if this function
+	 * ever gets inlined it will generate worse code.
+	 */
+	asm volatile ("");
+	return last;
 }
 #endif
 
-- 
1.7.5.1

