Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0CSSmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab0CSSmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:42:38 -0400
Date: Fri, 19 Mar 2010 19:40:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] make task_struct->signal immutable/refcountable
Message-ID: <20100319184017.GA512@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a lot of problems with accessing task_struct->signal, it can
"disappear" at any moment. Even current can't use its ->signal safely
after exit_notify(). ->siglock helps, but it is not convenient, not
always possible, and sometimes it makes sense to use task->signal even
after this task has already dead.

This patch adds the reference counter, sigcnt, into signal_struct. This
reference is owned by task_struct and it is dropped in __put_task_struct().
Perhaps it makes sense to export get/put_signal_struct() later, but
currently I don't see the immediate reason.

Rename __cleanup_signal() to free_signal_struct() and unexport it. With
the previous changes it does nothing except kmem_cache_free().

Change __exit_signal() to not clear/free ->signal, it will be freed when
the last reference to any thread in the thread group goes away.

Note:
	- when the last thead exits signal->tty can point to nowhere, see
	  the next patch.

	- with or without this patch signal_struct->count should go away,
	  or at least it should be "int nr_threads" for fs/proc. This will
	  be addressed later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    2 +-
 kernel/exit.c         |    3 ---
 kernel/fork.c         |   23 ++++++++++++++++-------
 3 files changed, 17 insertions(+), 11 deletions(-)

--- 34-rc1/include/linux/sched.h~8_IMMUTABLE_SIGNALL	2010-03-17 19:20:11.000000000 +0100
+++ 34-rc1/include/linux/sched.h	2010-03-19 17:32:44.000000000 +0100
@@ -518,6 +518,7 @@ struct thread_group_cputimer {
  * the locking of signal_struct.
  */
 struct signal_struct {
+	atomic_t		sigcnt;
 	atomic_t		count;
 	atomic_t		live;
 
@@ -2100,7 +2101,6 @@ extern void flush_thread(void);
 extern void exit_thread(void);
 
 extern void exit_files(struct task_struct *);
-extern void __cleanup_signal(struct signal_struct *);
 extern void __cleanup_sighand(struct sighand_struct *);
 
 extern void exit_itimers(struct signal_struct *);
--- 34-rc1/kernel/exit.c~8_IMMUTABLE_SIGNALL	2010-03-18 22:46:41.000000000 +0100
+++ 34-rc1/kernel/exit.c	2010-03-19 17:25:36.000000000 +0100
@@ -135,8 +135,6 @@ static void __exit_signal(struct task_st
 	 * doing sigqueue_free() if we have SIGQUEUE_PREALLOC signals.
 	 */
 	flush_sigqueue(&tsk->pending);
-
-	tsk->signal = NULL;
 	tsk->sighand = NULL;
 	spin_unlock(&sighand->siglock);
 
@@ -151,7 +149,6 @@ static void __exit_signal(struct task_st
 		 */
 		task_rq_unlock_wait(tsk);
 		tty_kref_put(sig->tty);
-		__cleanup_signal(sig);
 	}
 }
 
--- 34-rc1/kernel/fork.c~8_IMMUTABLE_SIGNALL	2010-03-18 22:45:14.000000000 +0100
+++ 34-rc1/kernel/fork.c	2010-03-19 17:51:51.000000000 +0100
@@ -158,6 +158,18 @@ void free_task(struct task_struct *tsk)
 }
 EXPORT_SYMBOL(free_task);
 
+static inline void free_signal_struct(struct signal_struct *sig)
+{
+	thread_group_cputime_free(sig);
+	kmem_cache_free(signal_cachep, sig);
+}
+
+static inline void put_signal_struct(struct signal_struct *sig)
+{
+	if (atomic_dec_and_test(&sig->sigcnt))
+		free_signal_struct(sig);
+}
+
 void __put_task_struct(struct task_struct *tsk)
 {
 	WARN_ON(!tsk->exit_state);
@@ -166,6 +178,7 @@ void __put_task_struct(struct task_struc
 
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
+	put_signal_struct(tsk->signal);
 
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
@@ -868,6 +881,7 @@ static int copy_signal(unsigned long clo
 	if (!sig)
 		return -ENOMEM;
 
+	atomic_set(&sig->sigcnt, 1);
 	atomic_set(&sig->count, 1);
 	atomic_set(&sig->live, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
@@ -893,12 +907,6 @@ static int copy_signal(unsigned long clo
 	return 0;
 }
 
-void __cleanup_signal(struct signal_struct *sig)
-{
-	thread_group_cputime_free(sig);
-	kmem_cache_free(signal_cachep, sig);
-}
-
 static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long new_flags = p->flags;
@@ -1249,6 +1257,7 @@ static struct task_struct *copy_process(
 	}
 
 	if (clone_flags & CLONE_THREAD) {
+		atomic_inc(&current->signal->sigcnt);
 		atomic_inc(&current->signal->count);
 		atomic_inc(&current->signal->live);
 		p->group_leader = current->group_leader;
@@ -1295,7 +1304,7 @@ bad_fork_cleanup_mm:
 		mmput(p->mm);
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
-		__cleanup_signal(p->signal);
+		free_signal_struct(p->signal);
 bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:

