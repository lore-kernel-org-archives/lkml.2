Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2APC5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 21:57:52 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:53129 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2APC5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 21:57:51 -0500
Date: Mon, 16 Jan 2012 13:56:55 +1100
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix race in process_vm_rw_core
Message-ID: <20120116135655.1a31e13c@rockpopper>
In-Reply-To: <20120114175829.GA32638@redhat.com>
References: <20120113220028.4ba7cead@Gantu.yeoh.info>
	<20120113160442.GA20137@redhat.com>
	<20120114095633.139119b2@Gantu.yeoh.info>
	<20120114175829.GA32638@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12011516-6102-0000-0000-000000A528D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jan 2012 18:58:29 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/14, Christopher Yeoh wrote:
> >
> > On Fri, 13 Jan 2012 17:04:42 +0100
> > Oleg Nesterov <oleg@redhat.com> wrote:
> > > On 01/13, Christopher Yeoh wrote:
> > > > ...
> > > > +struct mm_struct *get_check_task_mm(struct task_struct *task,
> > > > unsigned int mode) +{
> > > > +	struct mm_struct *mm;
> > > > +	int err;
> > > > +
> > > > +	err =
> > > > mutex_lock_killable(&task->signal->cred_guard_mutex);
> > > > +	if (err)
> > > > +		return ERR_PTR(err);
> > > > +
> > > > +	task_lock(task);
> > > > +	if (__ptrace_may_access(task, mode)) {
> > > > +		mm = ERR_PTR(-EACCES);
> > > > +		goto out;
> > > > +	}
> > >
> > > Probably you should check "mm != current->mm" before
> > > __ptrace_may_access(), otherwise this changes the rules for,
> > > say, /proc/pid/maps.
> >
> > __ptrace_may_access has a check for task == current already -
> > Is that sufficient?
> >
> > 	/* Don't let security modules deny introspection */
> > 	if (task == current)
> > 		return 0;
> 
> I don't think this is sufficient in the multithreaded or CLONE_VM
> case, task_cred/etc is per-thread.
> 
> It is not that I think that this "current->mm != mm" check is
> important, in fact personally I think it shouldn't exist.
> 
> But we shouldn't add the subtle and not documented behavioural
> change, and obviously process_vm_rw() has no security problems if mm
> == current->mm.
> 

Ok, updated patch below:

- adds the "current->mm != mm" check
- removes EXPORT_SYMBOL_GPL for get_check_task_mm

 fs/proc/base.c         |   17 +----------------
 include/linux/sched.h  |    4 ++++
 kernel/fork.c          |   30 ++++++++++++++++++++++++++++++
 mm/process_vm_access.c |   20 ++++++--------------
 4 files changed, 41 insertions(+), 30 deletions(-)
Signed-off-by: Chris Yeoh <yeohc@au1.ibm.com>
Cc: stable@vger.kernel.org
---
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 851ba3d..094d650 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -254,22 +254,7 @@ static struct mm_struct *check_mem_permission(struct task_struct *task)
 
 struct mm_struct *mm_for_maps(struct task_struct *task)
 {
-	struct mm_struct *mm;
-	int err;
-
-	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
-	if (err)
-		return ERR_PTR(err);
-
-	mm = get_task_mm(task);
-	if (mm && mm != current->mm &&
-			!ptrace_may_access(task, PTRACE_MODE_READ)) {
-		mmput(mm);
-		mm = ERR_PTR(-EACCES);
-	}
-	mutex_unlock(&task->signal->cred_guard_mutex);
-
-	return mm;
+	return get_check_task_mm(task, PTRACE_MODE_READ);
 }
 
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c4f3e9..8a64cae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2235,6 +2235,10 @@ static inline void mmdrop(struct mm_struct * mm)
 extern void mmput(struct mm_struct *);
 /* Grab a reference to a task's mm, if it is not already going away */
 extern struct mm_struct *get_task_mm(struct task_struct *task);
+/* Grab a reference to a task's mm, if it is not already going away
+   and ptrace_may_access with the mode parameter passed to it succeeds */
+extern struct mm_struct *get_check_task_mm(struct task_struct *task,
+					   unsigned int mode);
 /* Remove the current tasks stale references to the old mm_struct */
 extern void mm_release(struct task_struct *, struct mm_struct *);
 /* Allocate a new mm structure and copy contents from tsk->mm */
diff --git a/kernel/fork.c b/kernel/fork.c
index da4a6a1..b6c193a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -644,6 +644,36 @@ struct mm_struct *get_task_mm(struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(get_task_mm);
 
+struct mm_struct *get_check_task_mm(struct task_struct *task, unsigned int mode)
+{
+	struct mm_struct *mm;
+	int err;
+
+	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (err)
+		return ERR_PTR(err);
+
+	task_lock(task);
+	mm = task->mm;
+	if (mm != current->mm && __ptrace_may_access(task, mode)) {
+		mm = ERR_PTR(-EACCES);
+		goto out;
+	}
+
+	if (mm) {
+		if (task->flags & PF_KTHREAD)
+			mm = NULL;
+		else
+			atomic_inc(&mm->mm_users);
+	}
+
+out:
+	task_unlock(task);
+	mutex_unlock(&task->signal->cred_guard_mutex);
+
+	return mm;
+}
+
 /* Please note the differences between mmput and mm_release.
  * mmput is called whenever we stop holding onto a mm_struct,
  * error success whatever.
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index e920aa3..aa8009d 100644
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
+	mm = get_check_task_mm(task, PTRACE_MODE_ATTACH);
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

