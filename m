Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab1DGCEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:04:54 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:45323 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757107Ab1DGCEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:04:52 -0400
X-AuditID: 1209190f-b7cf3ae0000046b8-b1-4d9d1bbe4116
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [RFT/PATCH v2 4/6] x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0
Date: Wed,  6 Apr 2011 22:04:01 -0400
Message-Id: <e210b8eea527894eaf3aec8c30c8d2747e87a524.1302137785.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1302137785.git.luto@mit.edu>
References: <cover.1302137785.git.luto@mit.edu>
In-Reply-To: <cover.1302137785.git.luto@mit.edu>
References: <cover.1302137785.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsUixG6nortPeq6vwYE1xhZ9V46yWxy59p3d
	4vKuOWwWWy41s1ps3jSV2eLHhsesDmwet9r+MHvM3/mR0WPnrLvsHptWdbJ5vDt3jt3j8ya5
	ALYoLpuU1JzMstQifbsEroxLT3gL3gtWnHl7hqmBcT9fFyMnh4SAicS9/9eZIWwxiQv31rOB
	2EIC+xglNi6J7GLkArLXM0o8WfOJBcJ5yiRxZ/pDJpAqNgEViY6lD4BsDg4RASGJpXfrQGqY
	BbYzSmxY3s4CUiMsEC2x+vN8sHoWAVWJhVe+MoLYvAJBEtOmNQNtYwfaLCfRHAgS5RQwkLj4
	5T8rxA36EpN7vzHiEp/AKLCAkWEVo2xKbpVubmJmTnFqsm5xcmJeXmqRrolebmaJXmpK6SZG
	UKBySvLvYPx2UOkQowAHoxIPb0znHF8h1sSy4srcQ4ySHExKorydEnN9hfiS8lMqMxKLM+KL
	SnNSiw8xSnAwK4nwKgkB5XhTEiurUovyYVLSHCxK4ryzJNV9hQTSE0tSs1NTC1KLYLIyHBxK
	ErwJwIgUEixKTU+tSMvMKUFIM3FwggznARo+QRxkeHFBYm5xZjpE/hSjLsf/LYf2MQqx5OXn
	pUqJ86aBDBIAKcoozYObA0swrxjFgd4S5u0DqeIBJie4Sa+AljABLVl4bg7IkpJEhJRUA+MS
	Dc5T9xw1MlZf057j9Hoz47UDsulpK6fsETKudt5QclUt+fiUzq/H/3+/+9HVM4Gr4eiR69+N
	S51idi/4V3sgQP7g0TKXhn3ph7YZXV6ouJjh8fRuz6e5y2N8OqSyeGe9aitO+N6c9mGK4yEF
	0RdnvE6dyovxqLrFx6nLKLvO5ZKEAsdHjTQlluKMREMt5qLiRACCABtMCwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vclock_gettime's do_monotonic helper can't ever generate a negative
nsec value, so it doesn't need to check whether it's negative.  In
the CLOCK_MONOTONIC_COARSE case, ns can't ever exceed 2e9-1, so we
can avoid the loop entirely.  This saves a single easily-predicted
branch.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/vclock_gettime.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 0b873d4..28b2c00 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -55,22 +55,6 @@ notrace static noinline int do_realtime(struct timespec *ts)
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
@@ -81,7 +65,17 @@ notrace static noinline int do_monotonic(struct timespec *ts)
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
 
@@ -106,7 +100,17 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
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

