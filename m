Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1CLK6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 05:58:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:43856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1CLK6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 05:58:14 -0500
Date: Sat, 12 Mar 2011 10:57:50 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, dvhart@linux.intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, rostedt@goodmis.org, tglx@linutronix.de,
        laijs@cn.fujitsu.com
In-Reply-To: <4D11984A.5030203@cn.fujitsu.com>
References: <4D11984A.5030203@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/futexes] futex,plist: Pass the real head of the priority list to plist_del()
Message-ID: <tip-2e12978a9f7a7abd54e8eb9ce70a7718767b8b2c@git.kernel.org>
Git-Commit-ID: 2e12978a9f7a7abd54e8eb9ce70a7718767b8b2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 12 Mar 2011 10:57:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e12978a9f7a7abd54e8eb9ce70a7718767b8b2c
Gitweb:     http://git.kernel.org/tip/2e12978a9f7a7abd54e8eb9ce70a7718767b8b2c
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 22 Dec 2010 14:18:50 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 11 Mar 2011 15:09:52 -0500

futex,plist: Pass the real head of the priority list to plist_del()

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
