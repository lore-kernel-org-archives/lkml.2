Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab0DEUZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:25:26 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34919 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab0DEUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:24:39 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 6/6] futex: Add aggressive adaptive spinning argument to FUTEX_LOCK
Date: Mon,  5 Apr 2010 13:23:59 -0700
Message-Id: <1270499039-23728-7-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aggresive adaptive spinning (aas) allows for more than spinner in the
adaptive loop at a given time. In some scenarios this yields better
results than the default single spinner mode.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 kernel/futex.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index af61dcd..ddbd158 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2462,6 +2462,9 @@ static int trylock_futex_adaptive(u32 __user *uaddr, ktime_t *timeout)
  * @flags:  futex flags (FLAGS_SHARED, FLAGS_CLOCKRT, FLAGS_ADAPTIVE, etc.)
  * @detect: detect deadlock (1) or not (0)
  * @time:   absolute timeout
+ * @aas:    aggressive adaptive spinning (1) allow multiple spinners (0) allow
+ *          only one spinner. Only valid in conjunction with the FLAGS_ADAPTIVE
+ *          flag.
  *
  * futex_(un)lock() define a futex value policy and implement a full mutex. The
  * futex value stores the owner's TID or'd with FUTEX_WAITERS and/or
@@ -2476,12 +2479,14 @@ static int trylock_futex_adaptive(u32 __user *uaddr, ktime_t *timeout)
  *  0 - On success
  * <0 - On error
  */
-static int futex_lock(u32 __user *uaddr, int flags, int detect, ktime_t *time)
+static int futex_lock(u32 __user *uaddr, int flags, int detect, ktime_t *time,
+                      int aas)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
-	struct futex_hash_bucket *hb;
 	struct futex_q q = FUTEX_Q_INIT;
+	struct futex_hash_bucket *hb;
 	int ret = 0;
+	u32 uval;
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -2497,6 +2502,14 @@ static int futex_lock(u32 __user *uaddr, int flags, int detect, ktime_t *time)
 retry:
 #ifdef CONFIG_SMP
 	if (flags & FLAGS_ADAPTIVE) {
+		if (!aas) {
+			ret = get_user(uval, uaddr);
+			if (ret)
+				goto out;
+			if (uval & FUTEX_WAITERS)
+				goto skip_adaptive;
+		}
+
 		preempt_disable();
 		ret = trylock_futex_adaptive(uaddr, time);
 		preempt_enable();
@@ -2512,6 +2525,8 @@ retry:
 			goto out;
 	}
 #endif
+
+skip_adaptive:
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
 	if (unlikely(ret != 0))
@@ -2852,7 +2867,7 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		flags |= FLAGS_ADAPTIVE;
 	case FUTEX_LOCK:
 		if (futex_cmpxchg_enabled)
-			ret = futex_lock(uaddr, flags, val, timeout);
+			ret = futex_lock(uaddr, flags, val, timeout, val3);
 		break;
 	default:
 		ret = -ENOSYS;
-- 
1.6.3.3

