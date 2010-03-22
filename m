Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab0CVSm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:42:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab0CVSmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:42:55 -0400
Date: Mon, 22 Mar 2010 19:41:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/3] proc: get_nr_threads() doesn't need ->siglock any
	longer
Message-ID: <20100322184130.GA3957@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that task->signal can't go away get_nr_threads() doesn't need
->siglock to read signal->count.

Also, make it inline, move into sched.h, and convert 2 other proc
users of signal->count to use this (now trivial) helper.

Henceforth get_nr_threads() is the only valid user of signal->count,
we are ready to turn it into "int nr_threads" or, perhaps, kill it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    5 +++++
 fs/proc/array.c       |    4 ++--
 fs/proc/base.c        |   12 ------------
 3 files changed, 7 insertions(+), 14 deletions(-)

--- 34-rc1/include/linux/sched.h~PROC_1_GNT_DONT_USE_SIGLOCK	2010-03-22 16:35:43.000000000 +0100
+++ 34-rc1/include/linux/sched.h	2010-03-22 16:41:53.000000000 +0100
@@ -2148,6 +2148,11 @@ extern bool current_is_single_threaded(v
 #define while_each_thread(g, t) \
 	while ((t = next_thread(t)) != g)
 
+static inline int get_nr_threads(struct task_struct *tsk)
+{
+	return atomic_read(&tsk->signal->count);
+}
+
 /* de_thread depends on thread_group_leader not being a pid based check */
 #define thread_group_leader(p)	(p == p->group_leader)
 
--- 34-rc1/fs/proc/array.c~PROC_1_GNT_DONT_USE_SIGLOCK	2010-03-11 13:11:50.000000000 +0100
+++ 34-rc1/fs/proc/array.c	2010-03-22 17:04:44.000000000 +0100
@@ -269,7 +269,7 @@ static inline void task_sig(struct seq_f
 		shpending = p->signal->shared_pending.signal;
 		blocked = p->blocked;
 		collect_sigign_sigcatch(p, &ignored, &caught);
-		num_threads = atomic_read(&p->signal->count);
+		num_threads = get_nr_threads(p);
 		rcu_read_lock();  /* FIXME: is this correct? */
 		qsize = atomic_read(&__task_cred(p)->user->sigpending);
 		rcu_read_unlock();
@@ -412,7 +412,7 @@ static int do_task_stat(struct seq_file 
 			tty_nr = new_encode_dev(tty_devnum(sig->tty));
 		}
 
-		num_threads = atomic_read(&sig->count);
+		num_threads = get_nr_threads(task);
 		collect_sigign_sigcatch(task, &sigign, &sigcatch);
 
 		cmin_flt = sig->cmin_flt;
--- 34-rc1/fs/proc/base.c~PROC_1_GNT_DONT_USE_SIGLOCK	2010-03-22 16:35:43.000000000 +0100
+++ 34-rc1/fs/proc/base.c	2010-03-22 16:36:28.000000000 +0100
@@ -165,18 +165,6 @@ static int get_fs_path(struct task_struc
 	return result;
 }
 
-static int get_nr_threads(struct task_struct *tsk)
-{
-	unsigned long flags;
-	int count = 0;
-
-	if (lock_task_sighand(tsk, &flags)) {
-		count = atomic_read(&tsk->signal->count);
-		unlock_task_sighand(tsk, &flags);
-	}
-	return count;
-}
-
 static int proc_cwd_link(struct inode *inode, struct path *path)
 {
 	struct task_struct *task = get_proc_task(inode);

