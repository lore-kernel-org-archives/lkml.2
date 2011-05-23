Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1EWNdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:33:08 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:50118 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753790Ab1EWNdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:33:03 -0400
X-AuditID: 1209190f-b7c4dae0000007bd-d4-4dda6211cc88
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
Subject: [PATCH v5 4/8] x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0
Date: Mon, 23 May 2011 09:31:27 -0400
Message-Id: <d6d528d32c7a21618057cfc9005942a0fe5cb54a.1306156808.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsUixG6noiuYdMvXYNMvPYuLbRfZLPquHGW3
	OHLtO7vFxcZtLBZzzrewWOx7f5bN4vKuOWwWWy41s1ps3jSV2eJR31t2ix8bHrM6cHt0P/rE
	6HHlKYfHlpU3mTxutf1h9pi/8yOjx85Zd9k9Nq3qZPN4d+4cu8eJGb9ZPD5vkgvgiuKySUnN
	ySxLLdK3S+DK6HygVvBRsOLvghaWBsaDfF2MnBwSAiYSKzd0MULYYhIX7q1n62Lk4hAS2Mco
	8W71MlYIZwOjxPTvC1kgnGdMEqdunAZrYRNQkehY+oCpi5GDQ0RASGLp3TqQGmaBtcwS+7oX
	g8WFBcIl7i6tAClnEVCV6Ph8nxXE5hUIkmg+8Z8ZYrOCxJUr81hAbE4BA4n5u0+C2UIC+hKT
	ji7FKT6BUWABI8MqRtmU3Crd3MTMnOLUZN3i5MS8vNQiXRO93MwSvdSU0k2MoCjglOTfwfjt
	oNIhRgEORiUe3nWaN32FWBPLiitzDzFKcjApifK6xN/yFeJLyk+pzEgszogvKs1JLT7EKMHB
	rCTC26B9w1eINyWxsiq1KB8mJc3BoiTOO0tS3VdIID2xJDU7NbUgtQgmK8PBoSTBuygRaKhg
	UWp6akVaZk4JQpqJgxNkOA/Q8F6QGt7igsTc4sx0iPwpRl2Oqbd/H2AUYsnLz0uVEueNAykS
	ACnKKM2DmwNLXq8YxYHeEuadCFLFA0x8cJNeAS1hAloi8fcmyJKSRISUVAOj7aKsRmm+/42/
	jaruLEiYHLY7PmDu/NmfpwRLn9YSbdtmqOu9naND7dKh+c/yFRR+L7/gzjz7pwsvg3mk9iTH
	+bPPfOya8efr1yRXzfA/8TFlhmvuBhSFH/7PcNZe/d+v3Xu+1X3N9XB9/2Mzyw+Tc0vZVY0P
	ftVg0ds3oXKOe8Srqvy/NTmBSizFGYmGWsxFxYkACDTWIDkDAAA=
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
1.7.5.1

