Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab0LUJxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 04:53:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64061 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933683Ab0LUJxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:53:39 -0500
Message-ID: <4D107979.2020405@cn.fujitsu.com>
Date: Tue, 21 Dec 2010 17:55:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/4 V2 ] futex,plist: pass the real head of the priority list
 to plist_del()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-21 17:53:30,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-21 17:53:32,
	Serialize complete at 2010-12-21 17:53:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some plist_del()s in kernel/futex.c are passed a faked head of the
priority list.

It can work because current code does not require the real head
in plist_del(). The code of plist_del() just uses the head for checking,
so it will not cause bad result even when we use a faked head.

But it is an undocumented usage:

/**
 * plist_del - Remove a @node from plist.
 *
 * @node:	&struct plist_node pointer - entry to be removed
 * @head:	&struct plist_head pointer - list head
 */

The document said that @head is "list head" the head of the priority list.

In futex code, several places use "plist_del(&q->list, &q->list.plist);",
they passes faked head, we fix them all.

Thank to Darren Hart for many suggests.

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/futex.c b/kernel/futex.c
index 3019b92..d901f40 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -740,6 +740,23 @@ retry:
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
+	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)))
+		return;
+
+	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
+	plist_del(&q->list, &hb->chain);
+}
+
 /*
  * The hash bucket lock must be held when this is called.
  * Afterwards, the futex_q must not be accessed.
@@ -757,7 +774,7 @@ static void wake_futex(struct futex_q *q)
 	 */
 	get_task_struct(p);
 
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 	/*
 	 * The waiting task can free the futex_q as soon as
 	 * q->lock_ptr = NULL is written, without taking any locks. A
@@ -1067,7 +1084,7 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 	q->key = *key;
 
 	WARN_ON(plist_node_empty(&q->list));
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 
 	WARN_ON(!q->rt_waiter);
 	q->rt_waiter = NULL;
@@ -1471,7 +1488,7 @@ retry:
 			goto retry;
 		}
 		WARN_ON(plist_node_empty(&q->list));
-		plist_del(&q->list, &q->list.plist);
+		__unqueue_futex(q);
 
 		BUG_ON(q->pi_state);
 
@@ -1492,7 +1509,7 @@ static void unqueue_me_pi(struct futex_q *q)
 	__releases(q->lock_ptr)
 {
 	WARN_ON(plist_node_empty(&q->list));
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 
 	BUG_ON(!q->pi_state);
 	free_pi_state(q->pi_state);
@@ -2133,7 +2150,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * We were woken prior to requeue by a timeout or a signal.
 		 * Unqueue the futex_q and determine which it was.
 		 */
-		plist_del(&q->list, &q->list.plist);
+		plist_del(&q->list, &hb->chain);
 
 		/* Handle spurious wakeups gracefully */
 		ret = -EWOULDBLOCK;
