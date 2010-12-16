Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0LPKWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:22:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61614 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab0LPKWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:22:20 -0500
Message-ID: <4D09E897.7090406@cn.fujitsu.com>
Date: Thu, 16 Dec 2010 18:23:19 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] plist: pass the real plist_head to plist_del()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-16 18:22:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-16 18:22:15,
	Serialize complete at 2010-12-16 18:22:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches shrink the struct plist_head. After it is shrinked
plist_del() required a real plist_head passed into.

My tests did not cover all paths.

Subject: plist: pass the real plist_head to plist_del()


Some plist_del()s in kernel/futex.c are passed a faked plist_head.

It can work because current code does not require real plist_head
in plist_del(). But it is an undocumented usage, it is not good.

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/futex.c b/kernel/futex.c
index 6c683b3..6c4f67a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -158,6 +158,15 @@ static inline int match_futex(union futex_key *key1, union futex_key *key2)
 }
 
 /*
+ * find the bucket of a futex entry.
+ * the same as hash_futex(&q->key) but a little more effcient
+ */
+static struct futex_hash_bucket *futex_bucket(struct futex_q *q)
+{
+	return container_of(q->lock_ptr, struct futex_hash_bucket, lock);
+}
+
+/*
  * Take a reference to the resource addressed by a key.
  * Can be called while holding spinlocks.
  *
@@ -744,7 +753,7 @@ static void wake_futex(struct futex_q *q)
 	 */
 	get_task_struct(p);
 
-	plist_del(&q->list, &q->list.plist);
+	plist_del(&q->list, &futex_bucket(q)->chain);
 	/*
 	 * The waiting task can free the futex_q as soon as
 	 * q->lock_ptr = NULL is written, without taking any locks. A
@@ -1053,7 +1062,7 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 	q->key = *key;
 
 	WARN_ON(plist_node_empty(&q->list));
-	plist_del(&q->list, &q->list.plist);
+	plist_del(&q->list, &futex_bucket(q)->chain);
 
 	WARN_ON(!q->rt_waiter);
 	q->rt_waiter = NULL;
@@ -1457,7 +1466,7 @@ retry:
 			goto retry;
 		}
 		WARN_ON(plist_node_empty(&q->list));
-		plist_del(&q->list, &q->list.plist);
+		plist_del(&q->list, &futex_bucket(q)->chain);
 
 		BUG_ON(q->pi_state);
 
@@ -1478,7 +1487,7 @@ static void unqueue_me_pi(struct futex_q *q)
 	__releases(q->lock_ptr)
 {
 	WARN_ON(plist_node_empty(&q->list));
-	plist_del(&q->list, &q->list.plist);
+	plist_del(&q->list, &futex_bucket(q)->chain);
 
 	BUG_ON(!q->pi_state);
 	free_pi_state(q->pi_state);
@@ -2145,7 +2154,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * We were woken prior to requeue by a timeout or a signal.
 		 * Unqueue the futex_q and determine which it was.
 		 */
-		plist_del(&q->list, &q->list.plist);
+		plist_del(&q->list, &hb->chain);
 
 		/* Handle spurious wakeups gracefully */
 		ret = -EWOULDBLOCK;
