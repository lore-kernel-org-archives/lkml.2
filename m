Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1ISVsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:48:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:4105 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab1ISVsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="50047162"
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] posix-timers: move global timer id management to signal_struct v4
Date: Mon, 19 Sep 2011 14:48:44 -0700
Message-Id: <1316468925-16754-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Move the global posix timer ids IDR to signal_struct. This removes
a minor global scalability bottleneck and also allows to finally limit
the number of process timers in a sane way (see next patch)

I put it into signal_struct following the other posix timer per process
structures.

v2: Now with locking again (thanks Eric)
v3: Fix the locking too (Eric Dumazet)
v4: Use a mutex. Get rid of retry loop.
idr_pre_get() is still there to avoid major surgery in lib/idr.c.
Random gleixnerfication
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/init_task.h |    4 ++++
 include/linux/sched.h     |    4 ++++
 kernel/fork.c             |    3 +++
 kernel/posix-timers.c     |   32 ++++++++++++++------------------
 4 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index d14e058..d84569d 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -10,6 +10,8 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/securebits.h>
+#include <linux/idr.h>
+
 #include <net/net_namespace.h>
 
 #ifdef CONFIG_SMP
@@ -46,6 +48,8 @@ extern struct fs_struct init_fs;
 	},								\
 	.cred_guard_mutex =						\
 		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
+	.posix_timers_id = IDR_INIT(posix_timer_id),			\
+	.idr_lock	 = __MUTEX_INITIALIZER(init_signals.idr_lock),  \
 	INIT_THREADGROUP_FORK_LOCK(sig)					\
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..2d0b39f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -62,6 +62,7 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
+#include <linux/idr.h>
 
 #include <asm/system.h>
 #include <asm/page.h>
@@ -652,6 +653,9 @@ struct signal_struct {
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
 					 * (notably. ptrace) */
+
+	struct idr posix_timers_id;
+	struct mutex idr_lock;		/* Protect posix_timers_id writes */
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
diff --git a/kernel/fork.c b/kernel/fork.c
index 8e6b6f4..6693fc0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -943,6 +943,9 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
 	INIT_LIST_HEAD(&sig->cpu_timers[2]);
+
+	idr_init(&sig->posix_timers_id);
+	mutex_init(&sig->idr_lock);
 }
 
 static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4556182..f832021 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -70,8 +70,6 @@
  * Lets keep our timers in a slab cache :-)
  */
 static struct kmem_cache *posix_timers_cache;
-static struct idr posix_timers_id;
-static DEFINE_SPINLOCK(idr_lock);
 
 /*
  * we assume that the new SIGEV_THREAD_ID shares no bits with the other
@@ -282,7 +280,6 @@ static __init int init_posix_timers(void)
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
 					NULL);
-	idr_init(&posix_timers_id);
 	return 0;
 }
 
@@ -503,10 +500,10 @@ static void k_itimer_rcu_free(struct rcu_head *head)
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
 	if (it_id_set) {
-		unsigned long flags;
-		spin_lock_irqsave(&idr_lock, flags);
-		idr_remove(&posix_timers_id, tmr->it_id);
-		spin_unlock_irqrestore(&idr_lock, flags);
+		struct signal_struct *s = current->signal;
+		mutex_lock(&s->idr_lock);
+		idr_remove(&s->posix_timers_id, tmr->it_id);
+		mutex_unlock(&s->idr_lock);
 	}
 	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
@@ -541,6 +538,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	int error, new_timer_id;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
+	struct signal_struct *sig = current->signal;
 
 	if (!kc)
 		return -EINVAL;
@@ -552,17 +550,13 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		return -EAGAIN;
 
 	spin_lock_init(&new_timer->it_lock);
- retry:
-	if (unlikely(!idr_pre_get(&posix_timers_id, GFP_KERNEL))) {
-		error = -EAGAIN;
-		goto out;
-	}
-	spin_lock_irq(&idr_lock);
-	error = idr_get_new(&posix_timers_id, new_timer, &new_timer_id);
-	spin_unlock_irq(&idr_lock);
+	mutex_lock(&sig->idr_lock);
+	error = -EAGAIN;
+	if (idr_pre_get(&sig->posix_timers_id, GFP_KERNEL))
+		error = idr_get_new(&sig->posix_timers_id, new_timer, 
+				    &new_timer_id);
+	mutex_unlock(&sig->idr_lock);
 	if (error) {
-		if (error == -EAGAIN)
-			goto retry;
 		/*
 		 * Weird looking, but we return EAGAIN if the IDR is
 		 * full (proper POSIX return value for this)
@@ -638,9 +632,10 @@ out:
 static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
+	struct signal_struct *s = current->signal;
 
 	rcu_read_lock();
-	timr = idr_find(&posix_timers_id, (int)timer_id);
+	timr = idr_find(&s->posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock_irqsave(&timr->it_lock, *flags);
 		if (timr->it_signal == current->signal) {
@@ -945,6 +940,7 @@ void exit_itimers(struct signal_struct *sig)
 		tmr = list_entry(sig->posix_timers.next, struct k_itimer, list);
 		itimer_delete(tmr);
 	}
+	idr_destroy(&sig->posix_timers_id);
 }
 
 SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
-- 
1.7.4.4

