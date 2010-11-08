Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab0KHVNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:13:01 -0500
Received: from mga14.intel.com ([143.182.124.37]:59958 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab0KHVNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:13:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,170,1288594800"; 
   d="scan'208";a="346111000"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Darren Hart <dvhltc@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH V2] futex: add futex_q static initializer
Date: Mon,  8 Nov 2010 13:12:50 -0800
Message-Id: <1289250770-16533-1-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LFD.2.00.1011082037200.2900@localhost6.localdomain6>
References: <alpine.LFD.2.00.1011082037200.2900@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The futex_q struct has grown considerably over the last couple years. I
believe it now merits a static initializer to avoid uninitialized data
errors (having spent more time than I care to admit debugging an uninitialized
q.bitset in an experimental new op code).

With the key initializer built in, several of the FUTEX_KEY_INIT calls can
be removed.

V2: use a static variable instead of an init macro.
    use a C99 initializer and don't rely on variable ordering in the struct.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: John Kacur <jkacur@redhat.com>
---
 kernel/futex.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index fd3fbe1..1eea066 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -131,6 +131,12 @@ struct futex_q {
 	u32 bitset;
 };
 
+static struct futex_q futex_q_init = {
+	/* list gets initialized in queue_me()*/ 
+	.key = FUTEX_KEY_INIT,
+	.bitset = FUTEX_BITSET_MATCH_ANY
+};
+
 /*
  * Hash buckets are shared by all the futex_keys that hash to the same
  * location.  Each key may have multiple futex_q structures, one for each task
@@ -1751,7 +1757,6 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 	 * rare, but normal.
 	 */
 retry:
-	q->key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
 	if (unlikely(ret != 0))
 		return ret;
@@ -1792,16 +1797,12 @@ static int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct restart_block *restart;
 	struct futex_hash_bucket *hb;
-	struct futex_q q;
+	struct futex_q q = futex_q_init;
 	int ret;
 
 	if (!bitset)
 		return -EINVAL;
-
-	q.pi_state = NULL;
 	q.bitset = bitset;
-	q.rt_waiter = NULL;
-	q.requeue_pi_key = NULL;
 
 	if (abs_time) {
 		to = &timeout;
@@ -1892,7 +1893,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct futex_hash_bucket *hb;
-	struct futex_q q;
+	struct futex_q q = futex_q_init;
 	int res, ret;
 
 	if (refill_pi_state_cache())
@@ -1906,11 +1907,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
 		hrtimer_set_expires(&to->timer, *time);
 	}
 
-	q.pi_state = NULL;
-	q.rt_waiter = NULL;
-	q.requeue_pi_key = NULL;
 retry:
-	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
 	if (unlikely(ret != 0))
 		goto out;
@@ -2198,8 +2195,8 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	struct rt_mutex_waiter rt_waiter;
 	struct rt_mutex *pi_mutex = NULL;
 	struct futex_hash_bucket *hb;
-	union futex_key key2;
-	struct futex_q q;
+	union futex_key key2 = FUTEX_KEY_INIT;
+	struct futex_q q = futex_q_init;
 	int res, ret;
 
 	if (!bitset)
@@ -2222,12 +2219,10 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
-	key2 = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
-	q.pi_state = NULL;
 	q.bitset = bitset;
 	q.rt_waiter = &rt_waiter;
 	q.requeue_pi_key = &key2;
-- 
1.7.1

