Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab0CXRvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab0CXRvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:51:37 -0400
Date: Wed, 24 Mar 2010 18:49:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/1] proc: turn signal_struct->count into "int
	nr_threads"
Message-ID: <20100324174936.GA21534@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, just s/atomic_t count/int nr_threads/.

With the recent changes this counter has a single user, get_nr_threads()
And, none of its callers need the really accurate number of threads, not
to mention each caller obviously races with fork/exit. It is only used
to report this value to the user-space, except first_tid() uses it to
avoid the unnecessary while_each_thread() loop in the unlikely case.

It is a bit sad we need a word in struct signal_struct for this, perhaps
we can change get_nr_threads() to approximate the number of threads using
signal->live and kill ->nr_threads later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h     |    4 ++--
 include/linux/init_task.h |    2 +-
 kernel/exit.c             |    5 +----
 kernel/fork.c             |    8 ++++----
 4 files changed, 8 insertions(+), 11 deletions(-)

--- 34-rc1/include/linux/sched.h~14_S_COUNT_NR_THREADS	2010-03-24 17:35:30.000000000 +0100
+++ 34-rc1/include/linux/sched.h	2010-03-24 18:07:03.000000000 +0100
@@ -518,8 +518,8 @@ struct thread_group_cputimer {
  */
 struct signal_struct {
 	atomic_t		sigcnt;
-	atomic_t		count;
 	atomic_t		live;
+	int			nr_threads;
 
 	wait_queue_head_t	wait_chldexit;	/* for wait4() */
 
@@ -2150,7 +2150,7 @@ extern bool current_is_single_threaded(v
 
 static inline int get_nr_threads(struct task_struct *tsk)
 {
-	return atomic_read(&tsk->signal->count);
+	return tsk->signal->nr_threads;
 }
 
 /* de_thread depends on thread_group_leader not being a pid based check */
--- 34-rc1/include/linux/init_task.h~14_S_COUNT_NR_THREADS	2010-03-24 17:35:30.000000000 +0100
+++ 34-rc1/include/linux/init_task.h	2010-03-24 18:07:03.000000000 +0100
@@ -16,7 +16,7 @@ extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
 #define INIT_SIGNALS(sig) {						\
-	.count		= ATOMIC_INIT(1), 				\
+	.nr_threads	= 1, 						\
 	.wait_chldexit	= __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
 	.shared_pending	= { 						\
 		.list = LIST_HEAD_INIT(sig.shared_pending.list),	\
--- 34-rc1/kernel/exit.c~14_S_COUNT_NR_THREADS	2010-03-24 17:36:32.000000000 +0100
+++ 34-rc1/kernel/exit.c	2010-03-24 18:08:14.000000000 +0100
@@ -84,14 +84,10 @@ static void __exit_signal(struct task_st
 	struct sighand_struct *sighand;
 	struct tty_struct *uninitialized_var(tty);
 
-	BUG_ON(!sig);
-	BUG_ON(!atomic_read(&sig->count));
-
 	sighand = rcu_dereference_check(tsk->sighand,
 					rcu_read_lock_held() ||
 					lockdep_is_held(&tasklist_lock));
 	spin_lock(&sighand->siglock);
-	atomic_dec(&sig->count);
 
 	posix_cpu_timers_exit(tsk);
 	if (group_dead) {
@@ -131,6 +127,7 @@ static void __exit_signal(struct task_st
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	}
 
+	sig->nr_threads--;
 	__unhash_process(tsk, group_dead);
 
 	/*
--- 34-rc1/kernel/fork.c~14_S_COUNT_NR_THREADS	2010-03-24 17:35:30.000000000 +0100
+++ 34-rc1/kernel/fork.c	2010-03-24 18:07:03.000000000 +0100
@@ -881,9 +881,9 @@ static int copy_signal(unsigned long clo
 	if (!sig)
 		return -ENOMEM;
 
-	atomic_set(&sig->sigcnt, 1);
-	atomic_set(&sig->count, 1);
+	sig->nr_threads = 1;
 	atomic_set(&sig->live, 1);
+	atomic_set(&sig->sigcnt, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
 	if (clone_flags & CLONE_NEWPID)
 		sig->flags |= SIGNAL_UNKILLABLE;
@@ -1257,9 +1257,9 @@ static struct task_struct *copy_process(
 	}
 
 	if (clone_flags & CLONE_THREAD) {
-		atomic_inc(&current->signal->sigcnt);
-		atomic_inc(&current->signal->count);
+		current->signal->nr_threads++;
 		atomic_inc(&current->signal->live);
+		atomic_inc(&current->signal->sigcnt);
 		p->group_leader = current->group_leader;
 		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
 	}

