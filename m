Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab1EJOQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:16:13 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:58450 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932554Ab1EJOQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:16:06 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-d5-4dc9486f8df6
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 4/6] x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0
Date: Tue, 10 May 2011 10:15:06 -0400
Message-Id: <ffe5d77a456da4ea69590c63cc633967498f3f91.1305035945.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305035945.git.luto@mit.edu>
References: <cover.1305035945.git.luto@mit.edu>
In-Reply-To: <cover.1305035945.git.luto@mit.edu>
References: <cover.1305035945.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsUixG6nrpvvcdLXoG+BksXFtotsFn1XjrJb
	HLn2nd1izvkWFot978+yWVzeNYfNYsulZlaLtVPfsFhs3jSV2eJR31t2ix8bHrM6cHtcecrh
	sWXlTSaPW21/mD3m7/zI6LFz1l12j02rOtk83p07x+5xYsZvFo/Np6s9Pm+SC+CK4rJJSc3J
	LEst0rdL4MrofKBW8FGw4u+CFpYGxoN8XYycHBICJhLn1x1ghrDFJC7cW8/WxcjFISSwj1Fi
	5oUpTBDOBkaJrrkTGSGcZ0wSTTcPs4O0sAmoSHQsfQBUxcEhIiAksfRuHUiYWWAxs8TX+04g
	trBAuETzvRssIDaLgKrEmb03mEBsXoEgiUvfn7NCbFaQuHJlHlgNp4CBxNvD/9hAbCEBfYlF
	S4/hFJ/AKLCAkWEVo2xKbpVubmJmTnFqsm5xcmJeXmqRrpFebmaJXmpK6SZGUAxwSvLuYHx3
	UOkQowAHoxIPr8T/475CrIllxZW5hxglOZiURHkvu5z0FeJLyk+pzEgszogvKs1JLT7EKMHB
	rCTCO+/nCV8h3pTEyqrUonyYlDQHi5I470xJdV8hgfTEktTs1NSC1CKYrAwHh5IE71N3oKGC
	RanpqRVpmTklCGkmDk6Q4TxAww+B1PAWFyTmFmemQ+RPMepyTG9rPsAoxJKXn5cqJc77GaRI
	AKQoozQPbg4sdb1iFAd6S5iXC5jIhHiAaQ9u0iugJUxAS8w3gHxQXJKIkJJqYFwmHm/zWnr6
	5KvvpYOn7d9r9tEwqv5E6041/4RgveXvjzPG/dwg96q0L0t5A4e9n0HcW+M5rWfZSu5UrVkl
	vvPgspP/yjpz4y88y41U0Dn2M2Dyz7trNYvFp/000Qy9rbXQ96tjlbNq34KXXL0nXni6uAYW
	qks8nb2Z7bbDsbn6W8qUZ73N+63EUpyRaKjFXFScCACXd3tKOAMAAA==
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

