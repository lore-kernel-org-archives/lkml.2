Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab1CLDTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 22:19:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1CLDTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 22:19:22 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=YyQfyex7IYMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=U07H2Egmfcm3NIXDJVoA:9 a=jwQ_QClbMe7bWboJE_kA:7 a=JsoqyYm3PNDWi_Rhp-aRV_R-1aQA:4 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110312031919.227627970@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 11 Mar 2011 22:14:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 1/4] futex,plist: Pass the real head of the priority list to plist_del()
References: <20110312031435.890203189@goodmis.org>
Content-Disposition: inline; filename=0001-futex-plist-Pass-the-real-head-of-the-priority-list-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Some plist_del()s in kernel/futex.c are passed a faked head of the
priority list.

It does not fail because the current code does not require the real head
in plist_del(). The current code of plist_del() just uses the head for checking,
so it will not cause a bad result even when we use a faked head.

But it is undocumented usage:

/**
 * plist_del - Remove a @node from plist.
 *
 * @node:	&struct plist_node pointer - entry to be removed
 * @head:	&struct plist_head pointer - list head
 */

The document says that the @head is the "list head" head of the priority list.

In futex code, several places use "plist_del(&q->list, &q->list.plist);",
they pass a fake head. We need to fix them all.

Thanks to Darren Hart for many suggestions.

Acked-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4D11984A.5030203@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/futex.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index b766d28..6feeea4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -775,6 +775,24 @@ retry:
 	return ret;
 }
 
+/**
+ * __unqueue_futex() - Remove the futex_q from its futex_hash_bucket
+ * @q:	The futex_q to unqueue
+ *
+ * The q->lock_ptr must not be NULL and must be held by the caller.
+ */
+static void __unqueue_futex(struct futex_q *q)
+{
+	struct futex_hash_bucket *hb;
+
+	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
+			|| plist_node_empty(&q->list)))
+		return;
+
+	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
+	plist_del(&q->list, &hb->chain);
+}
+
 /*
  * The hash bucket lock must be held when this is called.
  * Afterwards, the futex_q must not be accessed.
@@ -792,7 +810,7 @@ static void wake_futex(struct futex_q *q)
 	 */
 	get_task_struct(p);
 
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 	/*
 	 * The waiting task can free the futex_q as soon as
 	 * q->lock_ptr = NULL is written, without taking any locks. A
@@ -1100,8 +1118,7 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 	get_futex_key_refs(key);
 	q->key = *key;
 
-	WARN_ON(plist_node_empty(&q->list));
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 
 	WARN_ON(!q->rt_waiter);
 	q->rt_waiter = NULL;
@@ -1504,8 +1521,7 @@ retry:
 			spin_unlock(lock_ptr);
 			goto retry;
 		}
-		WARN_ON(plist_node_empty(&q->list));
-		plist_del(&q->list, &q->list.plist);
+		__unqueue_futex(q);
 
 		BUG_ON(q->pi_state);
 
@@ -1525,8 +1541,7 @@ retry:
 static void unqueue_me_pi(struct futex_q *q)
 	__releases(q->lock_ptr)
 {
-	WARN_ON(plist_node_empty(&q->list));
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 
 	BUG_ON(!q->pi_state);
 	free_pi_state(q->pi_state);
@@ -2167,7 +2182,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * We were woken prior to requeue by a timeout or a signal.
 		 * Unqueue the futex_q and determine which it was.
 		 */
-		plist_del(&q->list, &q->list.plist);
+		plist_del(&q->list, &hb->chain);
 
 		/* Handle spurious wakeups gracefully */
 		ret = -EWOULDBLOCK;
-- 
1.7.2.3


