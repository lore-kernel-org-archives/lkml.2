Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab2BBBEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:04:51 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:60419 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab2BBBEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:04:50 -0500
Date: Thu, 2 Feb 2012 11:34:09 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] Fix race in process_vm_rw_core
Message-ID: <20120202113409.76813670@Gantu.yeoh.info>
In-Reply-To: <20120201183836.1cf5fc52@Gantu.yeoh.info>
References: <20120130124406.1567af7a@Gantu.yeoh.info>
	<20120130150922.GA17643@redhat.com>
	<20120201162330.43d421d3@Gantu.yeoh.info>
	<CA+55aFxstU98L64xgoUiacsV0zwX5ioNv3cT5CH2rvBrUGaovw@mail.gmail.com>
	<20120201183836.1cf5fc52@Gantu.yeoh.info>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12020114-6102-0000-0000-000000C12790
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012 18:38:36 +1030
cyeoh@ozlabs.au.ibm.com wrote:

> On Tue, 31 Jan 2012 22:10:13 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Tue, Jan 31, 2012 at 9:53 PM, Christopher Yeoh
> > <cyeoh@au1.ibm.com> wrote:
> > > +       mm = mm_access(task, PTRACE_MODE_ATTACH);
> > > +       if (!mm || IS_ERR(mm)) {
> > > +               if (!mm)
> > > +                       rc = -EINVAL;
> > > +               else
> > > +                       rc = -EPERM;
> > >                goto put_task_struct;
> > 
> > Btw, do you really want to throw away the error code?
> > 
> > IOW, maybe it should be
> > 
> >    rc = IS_ERR(mm) ? PTR_ERR(mm) : -EINVAL;
> > 
> > or something? Instead of forcing the EPERM? And the -EINVAL might be
> > better off as an ESRCH? I dunno.
> 
> Yea, that probably makes more sense.
> 
> > Right now you turn all errors into EPERM, whether they were really
> > about permission problems or not. And that just makes be a bit
> > nervous. I wonder if we wouldn't be better off just returning EACCES
> > (and any possible future problem) than try so hard to always return
> > EPERM?
> > 
> > I dunno. I don't have any really *strong* opinion and I see why you
> > do it, but my gut feel is still that the error number change really
> > does seem a bit arbitrary.
> 
> I'm not super attached to returning EPERM instead of EACCES though I
> do think it would look at bit odd from a user of the syscall view. Is
> it too ugly to do:
> 
>     rc = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
>     if (rc == -EACCES)
>             rc = -EPERM;
> 
> That way we avoid the problem of overwriting EINTR and if there are
> changes in the future which return different error codes we won't
> override those.
> 

Here's an updated patch doing the above of mapping EACCES but only
EACCES to EPERM.

-- 
cyeoh@au.ibm.com
Signed-off-by: Chris Yeoh <yeohc@au1.ibm.com>
 fs/proc/base.c         |   20 --------------------
 include/linux/sched.h  |    6 ++++++
 kernel/fork.c          |   20 ++++++++++++++++++++
 mm/process_vm_access.c |   23 +++++++++--------------
 4 files changed, 35 insertions(+), 34 deletions(-)
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
index e920aa3..c20ff48 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -298,23 +298,18 @@ static ssize_t process_vm_rw_core(pid_t pid, const struct iovec *lvec,
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
+		rc = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
+		/*
+		 * Explicitly map EACCES to EPERM as EPERM is a more a
+		 * appropriate error code for process_vw_readv/writev
+		 */
+		if (rc == -EACCES)
+			rc = -EPERM;
 		goto put_task_struct;
 	}
 
-	atomic_inc(&mm->mm_users);
-	task_unlock(task);
-
 	for (i = 0; i < riovcnt && iov_l_curr_idx < liovcnt; i++) {
 		rc = process_vm_rw_single_vec(
 			(unsigned long)rvec[i].iov_base, rvec[i].iov_len,

