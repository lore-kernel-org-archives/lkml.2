Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0GIWeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:34:01 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59856 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab0GIWd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:33:58 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       linux-rt-users@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 3/4] futex: free_pi_state outside of hb->lock sections
Date: Fri,  9 Jul 2010 15:32:59 -0700
Message-Id: <1278714780-788-4-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_pi_state() calls kfree() and might sleep. To prepare for raw hb->locks,
get the calls to free_pi_state() out of the hb->lock() sections.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/futex.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a6cec32..b217972 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -114,7 +114,7 @@ struct futex_q {
 	struct plist_node list;
 
 	struct task_struct *task;
-	spinlock_t *lock_ptr;
+	raw_spinlock_t *lock_ptr;
 	union futex_key key;
 	struct futex_pi_state *pi_state;
 	struct rt_mutex_waiter *rt_waiter;
@@ -487,7 +487,7 @@ void exit_pi_state_list(struct task_struct *curr)
 		 * task still owns the PI-state:
 		 */
 		if (head->next != next) {
-			spin_unlock(&hb->lock);
+			raw_spin_unlock(&hb->lock);
 			continue;
 		}
 
@@ -1339,7 +1339,6 @@ retry_private:
 			} else if (ret) {
 				/* -EDEADLK */
 				this->pi_state = NULL;
-				free_pi_state(pi_state);
 				goto out_unlock;
 			}
 		}
@@ -1437,7 +1436,7 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
  */
 static int unqueue_me(struct futex_q *q)
 {
-	spinlock_t *lock_ptr;
+	raw_spinlock_t *lock_ptr;
 	int ret = 0;
 
 	/* In the common case we don't take the spinlock, which is nice. */
@@ -1483,16 +1482,19 @@ retry:
  */
 static void unqueue_me_pi(struct futex_q *q)
 {
+	struct futex_pi_state *pi_state = NULL;
+
 	WARN_ON(plist_node_empty(&q->list));
 	plist_del(&q->list, &q->list.plist);
 
 	BUG_ON(!q->pi_state);
-	free_pi_state(q->pi_state);
+	pi_state = q->pi_state;
 	q->pi_state = NULL;
 
 	spin_unlock(q->lock_ptr);
-
 	drop_futex_key_refs(&q->key);
+
+	free_pi_state(pi_state);
 }
 
 /*
-- 
1.7.0.4

