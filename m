Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab2LCSco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:32:44 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53991 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2LCScm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:32:42 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] Make task directories in /proc pollable
Date: Mon,  3 Dec 2012 10:32:28 -0800
Message-Id: <1840e47fc4113af16989a4250d98bed62a9bce53.1354559528.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been a requested feature for a long time [1][2].

/proc/<pid> and /proc/<tgid>/task/<pid> will show POLLIN | POLLRDNORM
when the <pid> is dead and POLLIN | POLLRDNORM | POLLERR when <pid> is
dead and reaped.

The ability to tell whether the task exists given an fd isn't new -- readdir
can do it.  The ability to distinguish live and zombie tasks by fd may
have minor security implications.

It's conceivable, although unlikely, that some existing software expects
directories in /proc to always have POLLIN set.  The benefit of using POLLIN
instead of something like POLLPRI is feature detection -- checking /proc/self
for POLLIN will reliably detect this feature.

[1] http://lwn.net/Articles/462177/
[2] http://0pointer.de/blog/projects/plumbers-wishlist-3.html

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/proc/base.c            | 26 ++++++++++++++++++++++++++
 include/linux/init_task.h |  2 ++
 include/linux/sched.h     |  3 +++
 kernel/exit.c             |  3 +++
 kernel/fork.c             |  4 ++++
 5 files changed, 38 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3c231ad..ebab7ec 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2737,9 +2737,34 @@ static int proc_tgid_base_readdir(struct file * filp,
 				   tgid_base_stuff,ARRAY_SIZE(tgid_base_stuff));
 }
 
+static unsigned int proc_task_base_poll(struct file *filp,
+					struct poll_table_struct *wait)
+{
+	struct task_struct *task;
+	int retval;
+
+	task = get_proc_task(filp->f_path.dentry->d_inode);
+	if (!task)
+		return POLLIN | POLLRDNORM | POLLERR;
+
+	read_lock(&tasklist_lock);
+	poll_wait(filp, &task->detach_wqh, wait);
+	if (task_is_dead(task)) {
+		retval = POLLIN | POLLRDNORM;
+	} else {
+		retval = 0;
+		poll_wait(filp, &task->exit_wqh, wait);
+	}
+	read_unlock(&tasklist_lock);
+
+	put_task_struct(task);
+	return retval;
+}
+
 static const struct file_operations proc_tgid_base_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_tgid_base_readdir,
+	.poll		= proc_task_base_poll,
 	.llseek		= default_llseek,
 };
 
@@ -3110,6 +3135,7 @@ static struct dentry *proc_tid_base_lookup(struct inode *dir, struct dentry *den
 static const struct file_operations proc_tid_base_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_tid_base_readdir,
+	.poll		= proc_task_base_poll,
 	.llseek		= default_llseek,
 };
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6d087c5..093379e 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -202,6 +202,8 @@ extern struct task_group root_task_group;
 		[PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),		\
 	},								\
 	.thread_group	= LIST_HEAD_INIT(tsk.thread_group),		\
+	.exit_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(tsk.exit_wqh),	\
+	.detach_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(tsk.detach_wqh),\
 	INIT_IDS							\
 	INIT_PERF_EVENTS(tsk)						\
 	INIT_TRACE_IRQFLAGS						\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..6034a37 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1548,6 +1548,9 @@ struct task_struct {
 #ifdef CONFIG_UPROBES
 	struct uprobe_task *utask;
 #endif
+
+	/* These are woken with tasklist_lock held. */
+	wait_queue_head_t exit_wqh, detach_wqh;
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/exit.c b/kernel/exit.c
index 346616c..01c584b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -212,6 +212,7 @@ repeat:
 			leader->exit_state = EXIT_DEAD;
 	}
 
+	wake_up_all(&p->detach_wqh);
 	write_unlock_irq(&tasklist_lock);
 	release_thread(p);
 	call_rcu(&p->rcu, delayed_put_task_struct);
@@ -775,6 +776,8 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	/* mt-exec, de_thread() is waiting for group leader */
 	if (unlikely(tsk->signal->notify_count < 0))
 		wake_up_process(tsk->signal->group_exit_task);
+
+	wake_up_all(&tsk->exit_wqh);
 	write_unlock_irq(&tasklist_lock);
 
 	/* If the process is dead, release it - nobody will wait for it */
diff --git a/kernel/fork.c b/kernel/fork.c
index 8b20ab7..356b32c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -235,6 +235,8 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(!tsk->exit_state);
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
+	WARN_ON(waitqueue_active(&tsk->exit_wqh));
+	WARN_ON(waitqueue_active(&tsk->detach_wqh));
 
 	security_task_free(tsk);
 	exit_creds(tsk);
@@ -1285,6 +1287,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->memcg_batch.do_batch = 0;
 	p->memcg_batch.memcg = NULL;
 #endif
+	init_waitqueue_head(&p->exit_wqh);
+	init_waitqueue_head(&p->detach_wqh);
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p);
-- 
1.7.11.7

