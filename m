Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab1FJUOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:14:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:21809 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758081Ab1FJUO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:14:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,348,1304319600"; 
   d="scan'208";a="12148032"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: eric.dumazet@gmail.com, tglx@linutronix.de,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] posix-timers: move global timer id management to signal_struct
Date: Fri, 10 Jun 2011 13:13:07 -0700
Message-Id: <1307736788-25457-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307736788-25457-1-git-send-email-andi@firstfloor.org>
References: <1307736788-25457-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Move the global posix timer ids IDR to signal_struct. This removes
a minor global scalability bottleneck and also allows to finally limit
the number of process timers in a sane way (see next patch)

I put it into signal_struct following the other posix timer per process
structures.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/init_task.h |    2 ++
 include/linux/sched.h     |    3 +++
 kernel/fork.c             |    2 ++
 kernel/posix-timers.c     |   17 ++++++++++-------
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 580f70c..5c34aab 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -10,6 +10,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/securebits.h>
+#include <linux/idr.h>
 #include <net/net_namespace.h>
 
 #ifdef CONFIG_SMP
@@ -46,6 +47,7 @@ extern struct fs_struct init_fs;
 	},								\
 	.cred_guard_mutex =						\
 		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
+	.posix_timers_id = IDR_INIT(posix_timer_id),			\
 	INIT_THREADGROUP_FORK_LOCK(sig)					\
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a837b20..2f738ed 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -62,6 +62,7 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
+#include <linux/idr.h>
 
 #include <asm/system.h>
 #include <asm/page.h>
@@ -652,6 +653,8 @@ struct signal_struct {
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
 					 * (notably. ptrace) */
+
+	struct idr posix_timers_id;
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
diff --git a/kernel/fork.c b/kernel/fork.c
index 0276c30..90ee129 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -942,6 +942,8 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
 	INIT_LIST_HEAD(&sig->cpu_timers[2]);
+
+	idr_init(&sig->posix_timers_id);
 }
 
 static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index a6dcc10..7351e51 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -70,7 +70,6 @@
  * Lets keep our timers in a slab cache :-)
  */
 static struct kmem_cache *posix_timers_cache;
-static struct idr posix_timers_id;
 
 /*
  * we assume that the new SIGEV_THREAD_ID shares no bits with the other
@@ -281,7 +280,6 @@ static __init int init_posix_timers(void)
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
 					NULL);
-	idr_init(&posix_timers_id);
 	return 0;
 }
 
@@ -501,8 +499,10 @@ static void k_itimer_rcu_free(struct rcu_head *head)
 #define IT_ID_NOT_SET	0
 static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
-	if (it_id_set)
-		idr_remove(&posix_timers_id, tmr->it_id);
+	if (it_id_set) {
+		struct signal_struct *s = current->signal;
+		idr_remove(&s->posix_timers_id, tmr->it_id);
+	}
 	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
 	call_rcu(&tmr->it.rcu, k_itimer_rcu_free);
@@ -536,6 +536,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	int error, new_timer_id;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
+	struct signal_struct *s = current->signal;
 
 	if (!kc)
 		return -EINVAL;
@@ -548,11 +549,11 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 
 	spin_lock_init(&new_timer->it_lock);
  retry:
-	if (unlikely(!idr_pre_get(&posix_timers_id, GFP_KERNEL))) {
+	if (unlikely(!idr_pre_get(&s->posix_timers_id, GFP_KERNEL))) {
 		error = -EAGAIN;
 		goto out;
 	}
-	error = idr_get_new(&posix_timers_id, new_timer, &new_timer_id);
+	error = idr_get_new(&s->posix_timers_id, new_timer, &new_timer_id);
 	if (error) {
 		if (error == -EAGAIN)
 			goto retry;
@@ -631,9 +632,10 @@ out:
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
@@ -938,6 +940,7 @@ void exit_itimers(struct signal_struct *sig)
 		tmr = list_entry(sig->posix_timers.next, struct k_itimer, list);
 		itimer_delete(tmr);
 	}
+	idr_destroy(&sig->posix_timers_id);
 }
 
 SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
-- 
1.7.4.4

