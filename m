Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1H2Xj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:39:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:2432 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab1H2XjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:39:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,298,1312182000"; 
   d="scan'208";a="46249551"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, eric.dumazet@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] posix-timers: move global timer id management to signal_struct v2
Date: Mon, 29 Aug 2011 16:39:14 -0700
Message-Id: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/init_task.h |    3 +++
 include/linux/sched.h     |    4 ++++
 kernel/fork.c             |    2 ++
 kernel/posix-timers.c     |   23 ++++++++++++-----------
 4 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index d14e058..564248d 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -10,6 +10,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/securebits.h>
+#include <linux/idr.h>
 #include <net/net_namespace.h>
 
 #ifdef CONFIG_SMP
@@ -37,6 +38,7 @@ extern struct fs_struct init_fs;
 		.list = LIST_HEAD_INIT(sig.shared_pending.list),	\
 		.signal =  {{0}}},					\
 	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
+	.idr_lock	 = __SPIN_LOCK_UNLOCKED(idr_lock),		\
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
 	.cputimer	= { 						\
@@ -46,6 +48,7 @@ extern struct fs_struct init_fs;
 	},								\
 	.cred_guard_mutex =						\
 		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
+	.posix_timers_id = IDR_INIT(posix_timer_id),			\
 	INIT_THREADGROUP_FORK_LOCK(sig)					\
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..87fa2fc 100644
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
+	spinlock_t idr_lock;		/* Protect posix_timers_id writes */
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
diff --git a/kernel/fork.c b/kernel/fork.c
index 8e6b6f4..1054cfd 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -943,6 +943,8 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
 	INIT_LIST_HEAD(&sig->cpu_timers[2]);
+
+	idr_init(&sig->posix_timers_id);
 }
 
 static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4556182..4193cf7 100644
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
 
@@ -503,10 +500,11 @@ static void k_itimer_rcu_free(struct rcu_head *head)
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
 	if (it_id_set) {
+		struct signal_struct *s = current->signal;
 		unsigned long flags;
-		spin_lock_irqsave(&idr_lock, flags);
-		idr_remove(&posix_timers_id, tmr->it_id);
-		spin_unlock_irqrestore(&idr_lock, flags);
+		spin_lock_irqsave(&s->idr_lock, flags);
+		idr_remove(&s->posix_timers_id, tmr->it_id);
+		spin_unlock_irqrestore(&s->idr_lock, flags);
 	}
 	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
@@ -541,6 +539,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	int error, new_timer_id;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
+	struct signal_struct *s = current->signal;
 
 	if (!kc)
 		return -EINVAL;
@@ -553,13 +552,13 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 
 	spin_lock_init(&new_timer->it_lock);
  retry:
-	if (unlikely(!idr_pre_get(&posix_timers_id, GFP_KERNEL))) {
+	if (unlikely(!idr_pre_get(&s->posix_timers_id, GFP_KERNEL))) {
 		error = -EAGAIN;
 		goto out;
 	}
-	spin_lock_irq(&idr_lock);
-	error = idr_get_new(&posix_timers_id, new_timer, &new_timer_id);
-	spin_unlock_irq(&idr_lock);
+	spin_lock_irq(&s->idr_lock);
+	error = idr_get_new(&s->posix_timers_id, new_timer, &new_timer_id);
+	spin_unlock_irq(&s->idr_lock);
 	if (error) {
 		if (error == -EAGAIN)
 			goto retry;
@@ -638,9 +637,10 @@ out:
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
@@ -945,6 +945,7 @@ void exit_itimers(struct signal_struct *sig)
 		tmr = list_entry(sig->posix_timers.next, struct k_itimer, list);
 		itimer_delete(tmr);
 	}
+	idr_destroy(&sig->posix_timers_id);
 }
 
 SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
-- 
1.7.4.4

