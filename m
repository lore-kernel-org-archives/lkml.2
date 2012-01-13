Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab2AMLbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 06:31:18 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49492 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2AMLbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 06:31:17 -0500
Date: Fri, 13 Jan 2012 22:00:28 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix race in process_vm_rw_core
Message-ID: <20120113220028.4ba7cead@Gantu.yeoh.info>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12011301-1618-0000-0000-0000008887D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Below is a patch which fixes the race in process_vm_core found by
Oleg (http://article.gmane.org/gmane.linux.kernel/1235667/).
It consolidates some code with mm_for_maps since what they do is almost
identical.

Oleg - I've kept the breakout of ptrace_may_attach and get_task_mm to
preserve only having to take the task lock once. I see some performance
difference with a microbenchmark but haven't had a chance to test with
some HPC benchmarks yet so for the moment I'd like to leave it in. At
this stage I think its more important to get the race fixed and I'm at
Linux.conf.au all next week. I'll send a patch out for the 
rw_copy_check_uvector cleanup after I get back from LCA.

Regards,

Chris
-- 
cyeoh@au.ibm.com
Signed-off-by: Chris Yeoh <yeohc@au1.ibm.com>
Cc: stable@vger.kernel.org
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
index da4a6a1..9688fb0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -644,6 +644,37 @@ struct mm_struct *get_task_mm(struct task_struct *task)
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
+	if (__ptrace_may_access(task, mode)) {
+		mm = ERR_PTR(-EACCES);
+		goto out;
+	}
+
+	mm = task->mm;
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
+EXPORT_SYMBOL_GPL(get_check_task_mm);
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

