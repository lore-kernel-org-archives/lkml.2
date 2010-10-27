Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab0J0Vyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:54:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:48947 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422Ab0J0Vyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:54:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,248,1286175600"; 
   d="scan'208";a="851663695"
From: Darren Hart <dvhart@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Fleming <matt@console-pimps.org>, tglx@linutronix.de,
        peterz@infradead.org, mingo@elte.hu, eric.dumazet@gmail.com,
        jkacur@redhat.com, Darren Hart <dvhart@linux.intel.com>,
        Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 3/3] futex: add futex_q static initializer
Date: Wed, 27 Oct 2010 14:54:26 -0700
Message-Id: <1288216466-14309-4-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288216466-14309-1-git-send-email-dvhart@linux.intel.com>
References: <1288216466-14309-1-git-send-email-dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The futex_q struct has grown considerably over the last couple years. I
believe it now merits a static initializer to avoid uninitialized data
errors (having spent more time than I care to admit debugging an uninitialized
q.bitset in an experimental new op code).

With the key initializer built in, several of the FUTEX_KEY_INIT calls can
be removed.

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
index 8502498..4a10d44 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -131,6 +131,12 @@ struct futex_q {
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
@@ -1750,7 +1756,6 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, int flags,
 	 * rare, but normal.
 	 */
 retry:
-	q->key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
 	if (unlikely(ret != 0))
 		return ret;
@@ -1791,16 +1796,12 @@ static int futex_wait(u32 __user *uaddr, int flags, u32 val, ktime_t *abs_time,
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct restart_block *restart;
 	struct futex_hash_bucket *hb;
-	struct futex_q q;
+	struct futex_q q = FUTEX_Q_INIT;
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
@@ -1891,7 +1892,7 @@ static int futex_lock_pi(u32 __user *uaddr, int flags, int detect,
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct futex_hash_bucket *hb;
-	struct futex_q q;
+	struct futex_q q = FUTEX_Q_INIT;
 	int res, ret;
 
 	if (refill_pi_state_cache())
@@ -1905,11 +1906,7 @@ static int futex_lock_pi(u32 __user *uaddr, int flags, int detect,
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
@@ -2197,8 +2194,8 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int flags,
 	struct rt_mutex_waiter rt_waiter;
 	struct rt_mutex *pi_mutex = NULL;
 	struct futex_hash_bucket *hb;
-	union futex_key key2;
-	struct futex_q q;
+	union futex_key key2 = FUTEX_KEY_INIT;
+	struct futex_q q = FUTEX_Q_INIT;
 	int res, ret;
 
 	if (!bitset)
@@ -2221,12 +2218,10 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int flags,
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

