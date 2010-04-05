Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0DEUZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:25:04 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36823 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab0DEUYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:24:49 -0400
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
Subject: [PATCH 3/6] futex: refactor futex_lock_pi_atomic
Date: Mon,  5 Apr 2010 13:23:56 -0700
Message-Id: <1270499039-23728-4-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for FUTEX_LOCK by refactoring futex_lock_pi_atomic() into
lock_futex_atomic() and lock_pi_futex_atomic(). The name change is meant to
reflect the naming convention in futex.c that futex_*() functions map directly
to futex op codes and the others are internal helper functions.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>

===================================================================
---
 kernel/futex.c |   79 +++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 2ae18cd..8c1bb16 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -625,30 +625,23 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 }
 
 /**
- * futex_lock_pi_atomic() - Atomic work required to acquire a pi aware futex
- * @uaddr:		the pi futex user address
- * @hb:			the pi futex hash bucket
- * @key:		the futex key associated with uaddr and hb
- * @ps:			the pi_state pointer where we store the result of the
- *			lookup
- * @task:		the task to perform the atomic lock work for.  This will
- *			be "current" except in the case of requeue pi.
- * @set_waiters:	force setting the FUTEX_WAITERS bit (1) or not (0)
+ * lock_futex_atomic() - Try to acquire the futex lock atomically
+ * @uaddr:       user address of the futex
+ * @task:        the task to perform the atomic lock work for.
+ * @set_waiters: force setting the FUTEX_WAITERS bit (1) or not (0)
+ *
+ * The hb->lock shall be held by the caller.
  *
  * Returns:
  *  0 - ready to wait
  *  1 - acquired the lock
  * <0 - error
- *
- * The hb->lock and futex_key refs shall be held by the caller.
  */
-static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
-				union futex_key *key,
-				struct futex_pi_state **ps,
-				struct task_struct *task, int set_waiters)
+static int lock_futex_atomic(u32 __user *uaddr, struct task_struct *task,
+                             int set_waiters)
 {
-	int lock_taken, ret, ownerdied = 0;
 	u32 uval, newval, curval;
+	int lock_taken, ret;
 
 retry:
 	ret = lock_taken = 0;
@@ -695,10 +688,10 @@ retry:
 	 *
 	 * This is safe as we are protected by the hash bucket lock !
 	 */
-	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
+	if (unlikely((curval & FUTEX_OWNER_DIED) ||
+	             !(curval & FUTEX_TID_MASK))) {
 		/* Keep the OWNER_DIED bit */
 		newval = (curval & ~FUTEX_TID_MASK) | task_pid_vnr(task);
-		ownerdied = 0;
 		lock_taken = 1;
 	}
 
@@ -715,10 +708,46 @@ retry:
 	if (unlikely(lock_taken))
 		return 1;
 
+	return ret;
+}
+
+/**
+ * lock_pi_futex_atomic() - Atomic work required to acquire a pi aware futex
+ * @uaddr:		the pi futex user address
+ * @hb:			the pi futex hash bucket
+ * @key:		the futex key associated with uaddr and hb
+ * @ps:			the pi_state pointer where we store the result of the
+ *			lookup
+ * @task:		the task to perform the atomic lock work for.  This will
+ *			be "current" except in the case of requeue pi.
+ * @set_waiters:	force setting the FUTEX_WAITERS bit (1) or not (0)
+ *
+ * Returns:
+ *  0 - ready to wait
+ *  1 - acquired the lock
+ * <0 - error
+ *
+ * The hb->lock and futex_key refs shall be held by the caller.
+ */
+static int lock_pi_futex_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
+				union futex_key *key,
+				struct futex_pi_state **ps,
+				struct task_struct *task, int set_waiters)
+{
+	u32 uval;
+	int ret;
+
+retry:
+	ret = lock_futex_atomic(uaddr, task, set_waiters);
+	if (ret)
+		return ret;
+
 	/*
 	 * We dont have the lock. Look up the PI state (or create it if
 	 * we are the first waiter):
 	 */
+	if (get_futex_value_locked(&uval, uaddr))
+		return -EFAULT;
 	ret = lookup_pi_state(uval, hb, key, ps);
 
 	if (unlikely(ret)) {
@@ -729,7 +758,7 @@ retry:
 			 * OWNER_DIED bit is set to figure out whether
 			 * this is a robust futex or not.
 			 */
-			if (get_futex_value_locked(&curval, uaddr))
+			if (get_futex_value_locked(&uval, uaddr))
 				return -EFAULT;
 
 			/*
@@ -737,10 +766,8 @@ retry:
 			 * futex. The code above will take the futex
 			 * and return happy.
 			 */
-			if (curval & FUTEX_OWNER_DIED) {
-				ownerdied = 1;
+			if (uval & FUTEX_OWNER_DIED)
 				goto retry;
-			}
 		default:
 			break;
 		}
@@ -1100,7 +1127,7 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
  *
  * Try and get the lock on behalf of the top waiter if we can do it atomically.
  * Wake the top waiter if we succeed.  If the caller specified set_waiters,
- * then direct futex_lock_pi_atomic() to force setting the FUTEX_WAITERS bit.
+ * then direct lock_pi_futex_atomic() to force setting the FUTEX_WAITERS bit.
  * hb1 and hb2 must be held by the caller.
  *
  * Returns:
@@ -1124,7 +1151,7 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 	/*
 	 * Find the top_waiter and determine if there are additional waiters.
 	 * If the caller intends to requeue more than 1 waiter to pifutex,
-	 * force futex_lock_pi_atomic() to set the FUTEX_WAITERS bit now,
+	 * force lock_pi_futex_atomic() to set the FUTEX_WAITERS bit now,
 	 * as we have means to handle the possible fault.  If not, don't set
 	 * the bit unecessarily as it will force the subsequent unlock to enter
 	 * the kernel.
@@ -1144,7 +1171,7 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 	 * the contended case or if set_waiters is 1.  The pi_state is returned
 	 * in ps in contended cases.
 	 */
-	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
+	ret = lock_pi_futex_atomic(pifutex, hb2, key2, ps, top_waiter->task,
 				   set_waiters);
 	if (ret == 1)
 		requeue_pi_wake_futex(top_waiter, key2, hb2);
@@ -1925,7 +1952,7 @@ retry:
 retry_private:
 	hb = queue_lock(&q);
 
-	ret = futex_lock_pi_atomic(uaddr, hb, &q.key, &q.pi_state, current, 0);
+	ret = lock_pi_futex_atomic(uaddr, hb, &q.key, &q.pi_state, current, 0);
 	if (unlikely(ret)) {
 		switch (ret) {
 		case 1:
-- 
1.6.3.3

