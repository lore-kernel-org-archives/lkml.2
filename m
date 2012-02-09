Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2BICCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:02:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab2BICCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:02:02 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=5DsW7jjuvNMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=ybivv0icvZh4HuPIrq4A:9 a=PCF-_MiwaViNxfIZ4gsA:7 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120209020200.518106959@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 08 Feb 2012 20:59:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 7/8] futex: Fix bug on when a requeued RT task times out
References: <20120209015926.851312665@goodmis.org>
Content-Disposition: inline; filename=0007-futex-Fix-bug-on-when-a-requeued-RT-task-times-out.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Requeue with timeout causes a bug with PREEMPT_RT_FULL.

The bug comes from a timed out condition.


	TASK 1				TASK 2
	------				------
    futex_wait_requeue_pi()
	futex_wait_queue_me()
	<timed out>

					double_lock_hb();

	raw_spin_lock(pi_lock);
	if (current->pi_blocked_on) {
	} else {
	    current->pi_blocked_on = PI_WAKE_INPROGRESS;
	    run_spin_unlock(pi_lock);
	    spin_lock(hb->lock); <-- blocked!


					plist_for_each_entry_safe(this) {
					    rt_mutex_start_proxy_lock();
						task_blocks_on_rt_mutex();
						BUG_ON(task->pi_blocked_on)!!!!

The BUG_ON() actually has a check for PI_WAKE_INPROGRESS, but the
problem is that, after TASK 1 sets PI_WAKE_INPROGRESS, it then tries to
grab the hb->lock, which it fails to do so. As the hb->lock is a mutex,
it will block and set the "pi_blocked_on" to the hb->lock.

When TASK 2 goes to requeue it, the check for PI_WAKE_INPROGESS fails
because the task1's pi_blocked_on is no longer set to that, but instead,
set to the hb->lock.

The fix:

When calling rt_mutex_start_proxy_lock() a check is made to see
if the proxy tasks pi_blocked_on is set. If so, exit out early.
Otherwise set it to a new flag PI_REQUEUE_INPROGRESS, which notifies
the proxy task that it is being requeued, and will handle things
appropriately.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/rtmutex.c        |   32 +++++++++++++++++++++++++++++++-
 kernel/rtmutex_common.h |    1 +
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 15eaf30..789744a 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -75,7 +75,8 @@ static void fixup_rt_mutex_waiters(struct rt_mutex *lock)
 
 static int rt_mutex_real_waiter(struct rt_mutex_waiter *waiter)
 {
-	return waiter && waiter != PI_WAKEUP_INPROGRESS;
+	return waiter && waiter != PI_WAKEUP_INPROGRESS &&
+		waiter != PI_REQUEUE_INPROGRESS;
 }
 
 /*
@@ -1345,6 +1346,35 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 		return 1;
 	}
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+	/*
+	 * In PREEMPT_RT there's an added race.
+	 * If the task, that we are about to requeue, times out,
+	 * it can set the PI_WAKEUP_INPROGRESS. This tells the requeue
+	 * to skip this task. But right after the task sets
+	 * its pi_blocked_on to PI_WAKEUP_INPROGRESS it can then
+	 * block on the spin_lock(&hb->lock), which in RT is an rtmutex.
+	 * This will replace the PI_WAKEUP_INPROGRESS with the actual
+	 * lock that it blocks on. We *must not* place this task
+	 * on this proxy lock in that case.
+	 *
+	 * To prevent this race, we first take the task's pi_lock
+	 * and check if it has updated its pi_blocked_on. If it has,
+	 * we assume that it woke up and we return -EAGAIN.
+	 * Otherwise, we set the task's pi_blocked_on to
+	 * PI_REQUEUE_INPROGRESS, so that if the task is waking up
+	 * it will know that we are in the process of requeuing it.
+	 */
+	raw_spin_lock(&task->pi_lock);
+	if (task->pi_blocked_on) {
+		raw_spin_unlock(&task->pi_lock);
+		raw_spin_unlock(&lock->wait_lock);
+		return -EAGAIN;
+	}
+	task->pi_blocked_on = PI_REQUEUE_INPROGRESS;
+	raw_spin_unlock(&task->pi_lock);
+#endif
+
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
 
 	if (ret && !rt_mutex_owner(lock)) {
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index a688a29..6ec3dc1 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -105,6 +105,7 @@ static inline struct task_struct *rt_mutex_owner(struct rt_mutex *lock)
  * PI-futex support (proxy locking functions, etc.):
  */
 #define PI_WAKEUP_INPROGRESS	((struct rt_mutex_waiter *) 1)
+#define PI_REQUEUE_INPROGRESS	((struct rt_mutex_waiter *) 2)
 
 extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
 extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
-- 
1.7.8.3


