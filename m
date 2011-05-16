Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab1EPQB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:01:58 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:43580 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756423Ab1EPQB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:01:57 -0400
X-AuditID: 1209190c-b7c65ae00000117c-9e-4dd14a7b0ade
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
Subject: [PATCH v4 4/6] x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever see nsec < 0
Date: Mon, 16 May 2011 12:01:01 -0400
Message-Id: <f5bc7b6fa77be570a58d38c7e78bc710d6814933.1305560561.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305560561.git.luto@mit.edu>
References: <cover.1305560561.git.luto@mit.edu>
In-Reply-To: <cover.1305560561.git.luto@mit.edu>
References: <cover.1305560561.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsUixG6nrlvtddHX4HKLocXFtotsFn1XjrJb
	HLn2nd3iYuM2Fos551tYLPa9P8tmcXnXHDaLLZeaWS02b5rKbPGo7y27xY8Nj1kduD26H31i
	9LjylMNjy8qbTB632v4we8zf+ZHRY+esu+wem1Z1snm8O3eO3ePEjN8sHp83yQVwRXHZpKTm
	ZJalFunbJXBldD5QK/goWPF3QQtLA+NBvi5GTg4JAROJbYtOskDYYhIX7q1nA7GFBPYxStze
	HQlhb2CUWP9QvIuRC8h+xiTRtGgLWBGbgIpEx9IHTF2MHBwiAkISS+/WgdQwC6xlltjXvZgJ
	pEZYIFziQNcndhCbRUBVYvOszWDLeAWCJL5d2AW1WEHiypV5YDangIHE9sNbmCEW60t0rfnP
	iEt8AqPAAkaGVYyyKblVurmJmTnFqcm6xcmJeXmpRbqGermZJXqpKaWbGEExwCnJs4PxzUGl
	Q4wCHIxKPLxhrhd9hVgTy4orcw8xSnIwKYnyGoCE+JLyUyozEosz4otKc1KLDzFKcDArifCe
	qb/gK8SbklhZlVqUD5OS5mBREuedIanuKySQnliSmp2aWpBaBJOV4eBQkuBd7Qk0VLAoNT21
	Ii0zpwQhzcTBCTKcB2j4BZAa3uKCxNzizHSI/ClGXY7Pjw4dYBRiycvPS5US590BUiQAUpRR
	mgc3B5a6XjGKA70lzHsMpIoHmPbgJr0CWsIEtGTVKZAPiksSEVJSDYw8T5wWRtbUBx9Zfv/8
	zV/7n3TPVF2VsXvxw/0n3GQ/f+7ayOD47+jk8P339LNufjNiWns9aeHr6hatTdanP3bYJt/+
	0/lXsmwzz/nU6IqrhdNc/7w6XxLis+hr+unH+45mOE4OOqJQPuGttNSrjmlxKxd6LwvZ7PTx
	ZirfRt6Jqr0mq8p/pesvVGIpzkg01GIuKk4EAMFttww4AwAA
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

