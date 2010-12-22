Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0LVGRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 01:17:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61470 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab0LVGRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 01:17:17 -0500
Message-ID: <4D11984A.5030203@cn.fujitsu.com>
Date: Wed, 22 Dec 2010 14:18:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/4 V3 ] futex,plist: pass the real head of the priority list
 to plist_del()
References: <4D107979.2020405@cn.fujitsu.com> <4D10FC40.6070808@linux.intel.com>
In-Reply-To: <4D10FC40.6070808@linux.intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-22 14:17:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-22 14:17:08,
	Serialize complete at 2010-12-22 14:17:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2010 03:13 AM, Darren Hart wrote:
> On 12/21/2010 01:55 AM, Lai Jiangshan wrote:
> 
> Hi Lai,
> 
> Looks about ready to me, only a couple of more nitpics from me.
> 

Fixed, thanks.

Subject: [PATCH 1/4 V3 ] futex,plist: pass the real head of the priority list to plist_del()

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

The document said that @head is "list head" the head of the priority list.

In futex code, several places use "plist_del(&q->list, &q->list.plist);",
they passes faked head, we fix them all.

Thanks to Darren Hart for many suggestions.

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/futex.c b/kernel/futex.c
index 3019b92..d4f7252 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -740,6 +740,24 @@ retry:
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
@@ -757,7 +775,7 @@ static void wake_futex(struct futex_q *q)
 	 */
 	get_task_struct(p);
 
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 	/*
 	 * The waiting task can free the futex_q as soon as
 	 * q->lock_ptr = NULL is written, without taking any locks. A
@@ -1066,8 +1084,7 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 	get_futex_key_refs(key);
 	q->key = *key;
 
-	WARN_ON(plist_node_empty(&q->list));
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 
 	WARN_ON(!q->rt_waiter);
 	q->rt_waiter = NULL;
@@ -1470,8 +1487,7 @@ retry:
 			spin_unlock(lock_ptr);
 			goto retry;
 		}
-		WARN_ON(plist_node_empty(&q->list));
-		plist_del(&q->list, &q->list.plist);
+		__unqueue_futex(q);
 
 		BUG_ON(q->pi_state);
 
@@ -1491,8 +1507,7 @@ retry:
 static void unqueue_me_pi(struct futex_q *q)
 	__releases(q->lock_ptr)
 {
-	WARN_ON(plist_node_empty(&q->list));
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 
 	BUG_ON(!q->pi_state);
 	free_pi_state(q->pi_state);
@@ -2133,7 +2148,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * We were woken prior to requeue by a timeout or a signal.
 		 * Unqueue the futex_q and determine which it was.
 		 */
-		plist_del(&q->list, &q->list.plist);
+		plist_del(&q->list, &hb->chain);
 
 		/* Handle spurious wakeups gracefully */
 		ret = -EWOULDBLOCK;
