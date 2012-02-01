Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2BAFxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 00:53:43 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39292 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab2BAFxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 00:53:41 -0500
Date: Wed, 1 Feb 2012 16:23:30 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] Fix race in process_vm_rw_core
Message-ID: <20120201162330.43d421d3@Gantu.yeoh.info>
In-Reply-To: <20120130150922.GA17643@redhat.com>
References: <20120130124406.1567af7a@Gantu.yeoh.info>
	<20120130150922.GA17643@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12013119-9264-0000-0000-000000BD1B65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 16:09:22 +0100
Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/30, Christopher Yeoh wrote:
> >
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -198,7 +198,7 @@ static int proc_root_link(struct dentry
> > *dentry, struct path *path) return result;
> >  }
> >
> > -static struct mm_struct *mm_access(struct task_struct *task,
> > unsigned int mode) +struct mm_struct *mm_access(struct task_struct
> > *task, unsigned int mode)
> 
> This is not enough, we should move it outside of fs/proc/, otherwise
> the kernel can't be compiled without CONFIG_PROC.
> 

Updated patch below. Have moved mm_access to kernel/fork.c

This patch fixes the race in process_vm_rw_core found by Oleg 
(http://article.gmane.org/gmane.linux.kernel/1235667/) which can occur 
between __ptrace_may_access on the target task and if that task
is executing through execve at the same time.

Chris
-- 
cyeoh@au.ibm.com
 fs/proc/base.c         |   20 --------------------
 include/linux/sched.h  |    6 ++++++
 kernel/fork.c          |   20 ++++++++++++++++++++
 mm/process_vm_access.c |   20 ++++++--------------
 4 files changed, 32 insertions(+), 34 deletions(-)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9cde9edf..2773412 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -198,26 +198,6 @@ static int proc_root_link(struct dentry *dentry, struct path *path)
 	return result;
 }
 
-static struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
-{
-	struct mm_struct *mm;
-	int err;
-
-	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
-	if (err)
-		return ERR_PTR(err);
-
-	mm = get_task_mm(task);
-	if (mm && mm != current->mm &&
-			!ptrace_may_access(task, mode)) {
-		mmput(mm);
-		mm = ERR_PTR(-EACCES);
-	}
-	mutex_unlock(&task->signal->cred_guard_mutex);
-
-	return mm;
-}
-
 struct mm_struct *mm_for_maps(struct task_struct *task)
 {
 	return mm_access(task, PTRACE_MODE_READ);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2234985..7d379a6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2259,6 +2259,12 @@ static inline void mmdrop(struct mm_struct * mm)
 extern void mmput(struct mm_struct *);
 /* Grab a reference to a task's mm, if it is not already going away */
 extern struct mm_struct *get_task_mm(struct task_struct *task);
+/*
+ * Grab a reference to a task's mm, if it is not already going away
+ * and ptrace_may_access with the mode parameter passed to it
+ * succeeds.
+ */
+extern struct mm_struct *mm_access(struct task_struct *task, unsigned int mode);
 /* Remove the current tasks stale references to the old mm_struct */
 extern void mm_release(struct task_struct *, struct mm_struct *);
 /* Allocate a new mm structure and copy contents from tsk->mm */
diff --git a/kernel/fork.c b/kernel/fork.c
index 051f090..1b2ef3c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -647,6 +647,26 @@ struct mm_struct *get_task_mm(struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(get_task_mm);
 
+struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
+{
+	struct mm_struct *mm;
+	int err;
+
+	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (err)
+		return ERR_PTR(err);
+
+	mm = get_task_mm(task);
+	if (mm && mm != current->mm &&
+			!ptrace_may_access(task, mode)) {
+		mmput(mm);
+		mm = ERR_PTR(-EACCES);
+	}
+	mutex_unlock(&task->signal->cred_guard_mutex);
+
+	return mm;
+}
+
 /* Please note the differences between mmput and mm_release.
  * mmput is called whenever we stop holding onto a mm_struct,
  * error success whatever.
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index e920aa3..82b6824 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -298,23 +298,15 @@ static ssize_t process_vm_rw_core(pid_t pid, const struct iovec *lvec,
 		goto free_proc_pages;
 	}
 
-	task_lock(task);
-	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
-		task_unlock(task);
-		rc = -EPERM;
-		goto put_task_struct;
-	}
-	mm = task->mm;
-
-	if (!mm || (task->flags & PF_KTHREAD)) {
-		task_unlock(task);
-		rc = -EINVAL;
+	mm = mm_access(task, PTRACE_MODE_ATTACH);
+	if (!mm || IS_ERR(mm)) {
+		if (!mm)
+			rc = -EINVAL;
+		else
+			rc = -EPERM;
 		goto put_task_struct;
 	}
 
-	atomic_inc(&mm->mm_users);
-	task_unlock(task);
-
 	for (i = 0; i < riovcnt && iov_l_curr_idx < liovcnt; i++) {
 		rc = process_vm_rw_single_vec(
 			(unsigned long)rvec[i].iov_base, rvec[i].iov_len,

