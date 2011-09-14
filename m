Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab1INNkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:40:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46870 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab1INNkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:40:00 -0400
Message-Id: <20110914133750.831707072@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 14 Sep 2011 15:30:36 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/3] futex: Reduce hash bucket lock contention
References: <20110914133034.687048806@chello.nl>
Content-Disposition: inline; filename=futex-wake-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the brand spanking new wake_list to delay the futex wakeups until
after we've released the hash bucket locks. This avoids the newly
woken tasks from immediately getting stuck on the hb lock.

This is esp. painful on -rt, where the hb lock is preemptible.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/futex.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -823,7 +823,7 @@ static void __unqueue_futex(struct futex
  * The hash bucket lock must be held when this is called.
  * Afterwards, the futex_q must not be accessed.
  */
-static void wake_futex(struct futex_q *q)
+static void wake_futex(struct wake_list_head *wake_list, struct futex_q *q)
 {
 	struct task_struct *p = q->task;
 
@@ -834,7 +834,7 @@ static void wake_futex(struct futex_q *q
 	 * struct. Prevent this by holding a reference on p across the
 	 * wake up.
 	 */
-	get_task_struct(p);
+	wake_list_add(wake_list, p);
 
 	__unqueue_futex(q);
 	/*
@@ -845,9 +845,6 @@ static void wake_futex(struct futex_q *q
 	 */
 	smp_wmb();
 	q->lock_ptr = NULL;
-
-	wake_up_state(p, TASK_NORMAL);
-	put_task_struct(p);
 }
 
 static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
@@ -964,6 +961,7 @@ futex_wake(u32 __user *uaddr, unsigned i
 	struct futex_q *this, *next;
 	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
+	WAKE_LIST(wake_list);
 	int ret;
 
 	if (!bitset)
@@ -988,7 +986,7 @@ futex_wake(u32 __user *uaddr, unsigned i
 			if (!(this->bitset & bitset))
 				continue;
 
-			wake_futex(this);
+			wake_futex(&wake_list, this);
 			if (++ret >= nr_wake)
 				break;
 		}
@@ -996,6 +994,8 @@ futex_wake(u32 __user *uaddr, unsigned i
 
 	spin_unlock(&hb->lock);
 	put_futex_key(&key);
+
+	wake_up_list(&wake_list, TASK_NORMAL);
 out:
 	return ret;
 }
@@ -1012,6 +1012,7 @@ futex_wake_op(u32 __user *uaddr1, unsign
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head;
 	struct futex_q *this, *next;
+	WAKE_LIST(wake_list);
 	int ret, op_ret;
 
 retry:
@@ -1062,7 +1063,7 @@ futex_wake_op(u32 __user *uaddr1, unsign
 
 	plist_for_each_entry_safe(this, next, head, list) {
 		if (match_futex (&this->key, &key1)) {
-			wake_futex(this);
+			wake_futex(&wake_list, this);
 			if (++ret >= nr_wake)
 				break;
 		}
@@ -1074,7 +1075,7 @@ futex_wake_op(u32 __user *uaddr1, unsign
 		op_ret = 0;
 		plist_for_each_entry_safe(this, next, head, list) {
 			if (match_futex (&this->key, &key2)) {
-				wake_futex(this);
+				wake_futex(&wake_list, this);
 				if (++op_ret >= nr_wake2)
 					break;
 			}
@@ -1087,6 +1088,8 @@ futex_wake_op(u32 __user *uaddr1, unsign
 	put_futex_key(&key2);
 out_put_key1:
 	put_futex_key(&key1);
+
+	wake_up_list(&wake_list, TASK_NORMAL);
 out:
 	return ret;
 }
@@ -1239,6 +1242,7 @@ static int futex_requeue(u32 __user *uad
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head1;
 	struct futex_q *this, *next;
+	WAKE_LIST(wake_list);
 	u32 curval2;
 
 	if (requeue_pi) {
@@ -1384,7 +1388,7 @@ static int futex_requeue(u32 __user *uad
 		 * woken by futex_unlock_pi().
 		 */
 		if (++task_count <= nr_wake && !requeue_pi) {
-			wake_futex(this);
+			wake_futex(&wake_list, this);
 			continue;
 		}
 
@@ -1437,6 +1441,7 @@ static int futex_requeue(u32 __user *uad
 	put_futex_key(&key2);
 out_put_key1:
 	put_futex_key(&key1);
+	wake_up_list(&wake_list, TASK_NORMAL);
 out:
 	if (pi_state != NULL)
 		free_pi_state(pi_state);


