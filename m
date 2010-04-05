Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab0DEUYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:24:38 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60931 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab0DEUYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:24:30 -0400
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
Subject: [PATCH 2/6] futex: add futex_q static initializer
Date: Mon,  5 Apr 2010 13:23:55 -0700
Message-Id: <1270499039-23728-3-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The futex_q struct has grown considerably over the last year or so. I
believe it now merits a static initializer to avoid uninitialized data
errors (having just spent more time than I care to admit debugging
an uninitialized q.bitset in an experimental new op code).

I originally planned on following the __THING_INITIALIZER/DECLARE_THING
method, but since we already had FUTEX_KEY_INIT, and I personally prefer
that method, I went that route.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 kernel/futex.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index ed08cfd..2ae18cd 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -130,6 +130,12 @@ struct futex_q {
 	u32 bitset;
 };
 
+#define FUTEX_Q_INIT \
+	{ /* list gets initialized in queue_me()*/ \
+	  .task = NULL, NULL, FUTEX_KEY_INIT \
+	, NULL, NULL, NULL, FUTEX_BITSET_MATCH_ANY }
+
+
 /*
  * Hash buckets are shared by all the futex_keys that hash to the same
  * location.  Each key may have multiple futex_q structures, one for each task
@@ -1799,16 +1805,13 @@ static int futex_wait(u32 __user *uaddr, int flags, u32 val, ktime_t *abs_time,
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct restart_block *restart;
 	struct futex_hash_bucket *hb;
-	struct futex_q q;
+	struct futex_q q = FUTEX_Q_INIT;
 	int ret;
 
 	if (!bitset)
 		return -EINVAL;
 
-	q.pi_state = NULL;
 	q.bitset = bitset;
-	q.rt_waiter = NULL;
-	q.requeue_pi_key = NULL;
 
 	if (abs_time) {
 		to = &timeout;
@@ -1899,7 +1902,7 @@ static int futex_lock_pi(u32 __user *uaddr, int flags, int detect,
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct futex_hash_bucket *hb;
-	struct futex_q q;
+	struct futex_q q = FUTEX_Q_INIT;
 	int res, ret;
 
 	if (refill_pi_state_cache())
@@ -1913,9 +1916,6 @@ static int futex_lock_pi(u32 __user *uaddr, int flags, int detect,
 		hrtimer_set_expires(&to->timer, *time);
 	}
 
-	q.pi_state = NULL;
-	q.rt_waiter = NULL;
-	q.requeue_pi_key = NULL;
 retry:
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
@@ -2206,7 +2206,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int flags,
 	struct rt_mutex *pi_mutex = NULL;
 	struct futex_hash_bucket *hb;
 	union futex_key key2;
-	struct futex_q q;
+	struct futex_q q = FUTEX_Q_INIT;
 	int res, ret;
 
 	if (!bitset)
@@ -2234,7 +2234,6 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int flags,
 	if (unlikely(ret != 0))
 		goto out;
 
-	q.pi_state = NULL;
 	q.bitset = bitset;
 	q.rt_waiter = &rt_waiter;
 	q.requeue_pi_key = &key2;
-- 
1.6.3.3

