Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1C1PHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:07:36 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:64602 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753347Ab1C1PHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:07:34 -0400
X-AuditID: 12074423-b7b8eae000003d4f-66-4d90a43bd77f
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 4/6] x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0
Date: Mon, 28 Mar 2011 11:06:44 -0400
Message-Id: <75824c7636ab74a71598080867c927d313c8ab66.1301324270.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsUixG6nomu9ZIKvwY5lshZ9V46yW7Sunc9u
	cXnXHDaLzZumMlv82PCY1YHVY+esu+wem1Z1snm8O3eO3ePctT5mj8+b5AJYo7hsUlJzMstS
	i/TtErgylu18xV7QKVixeOYtpgbGN7xdjJwcEgImEl/ON7FD2GISF+6tZ+ti5OIQEtjHKPG8
	YT4zhLOBUeLLKZAqEOcZk8TFyfvYQFrYBFQkOpY+YOpi5OAQERCSWHq3DqSGWWASo8TLGb3s
	IHFhgRCJbfMtQMpZBFQlDnzcCraNVyBI4vHiL0Ct7ECb5SSaA0GinAIGEp2nr7KANAoJ6Et8
	PGePQ3gCo8ACRoZVjLIpuVW6uYmZOcWpybrFyYl5ealFumZ6uZkleqkppZsYwSHporyD8c9B
	pUOMAhyMSjy8wVH9vkKsiWXFlbmHGCU5mJREeZ8tmuArxJeUn1KZkVicEV9UmpNafIhRgoNZ
	SYT3UCNQjjclsbIqtSgfJiXNwaIkzjtXUt1XSCA9sSQ1OzW1ILUIJivDwaEkwbtwMVCjYFFq
	empFWmZOCUKaiYMTZDgP0PAkkBre4oLE3OLMdIj8KUZFKXHexSAJAZBERmkeXC8sZbxiFAd6
	RZh3EkgVDzDdwHW/AhrMBDQ4UAlscEkiQkqqgbFT+EHwU5drih+7asJ4Dxs2e27rmM26+udE
	fe2S98qe/424ygSmz1I8fSdl+0sh09W7nDT12cUuFSaV7pr0rtrd1/DfD4/oMz5+858rrb6o
	crd67eGjzu/2+q/QqN9yR+7PDd/t7TmXvk3y5q3d+XVrSvmkkjPl+58zaKm8jLuifIlzVtKX
	VTeVWIozEg21mIuKEwEF1Ja+9AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vclock_gettime's do_monotonic helper can't ever generate a negative
nsec value, so it doesn't need to check whether it's negative.  This
saves a single easily-predicted branch.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/vclock_gettime.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index ee55754..67d54bb 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -56,22 +56,6 @@ notrace static noinline int do_realtime(struct timespec *ts)
 	return 0;
 }
 
-/* Copy of the version in kernel/time.c which we cannot directly access */
-notrace static void
-vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
-{
-	while (nsec >= NSEC_PER_SEC) {
-		nsec -= NSEC_PER_SEC;
-		++sec;
-	}
-	while (nsec < 0) {
-		nsec += NSEC_PER_SEC;
-		--sec;
-	}
-	ts->tv_sec = sec;
-	ts->tv_nsec = nsec;
-}
-
 notrace static noinline int do_monotonic(struct timespec *ts)
 {
 	unsigned long seq, ns, secs;
@@ -82,7 +66,17 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 		secs += gtod->wall_to_monotonic.tv_sec;
 		ns += gtod->wall_to_monotonic.tv_nsec;
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
-	vset_normalized_timespec(ts, secs, ns);
+
+	/* wall_time_nsec, vgetns(), and wall_to_monotonic.tv_nsec
+	 * are all guaranteed to be nonnegative.
+	 */
+	while (ns >= NSEC_PER_SEC) {
+		ns -= NSEC_PER_SEC;
+		++secs;
+	}
+	ts->tv_sec = secs;
+	ts->tv_nsec = ns;
+
 	return 0;
 }
 
@@ -107,7 +101,17 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
 		secs += gtod->wall_to_monotonic.tv_sec;
 		ns += gtod->wall_to_monotonic.tv_nsec;
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
-	vset_normalized_timespec(ts, secs, ns);
+
+	/* wall_time_nsec and wall_to_monotonic.tv_nsec are
+	 * guaranteed to be between 0 and NSEC_PER_SEC.
+	 */
+	if (ns >= NSEC_PER_SEC) {
+		ns -= NSEC_PER_SEC;
+		++secs;
+	}
+	ts->tv_sec = secs;
+	ts->tv_nsec = ns;
+
 	return 0;
 }
 
-- 
1.7.4

