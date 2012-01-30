Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab2A3COJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:14:09 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:32955 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2A3COI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:14:08 -0500
Date: Mon, 30 Jan 2012 12:44:06 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] Fix race in process_vm_rw_core
Message-ID: <20120130124406.1567af7a@Gantu.yeoh.info>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12012916-1618-0000-0000-000000A85855
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Below is a patch which fixes the race in process_vm_core found by
Oleg (http://article.gmane.org/gmane.linux.kernel/1235667/).

This has been updated since I last sent it since the creation
of mm_access did almost exactly the same thing as parts of the
previous version of this patch did.

Regards,

Chris
-- 
cyeoh@au.ibm.com
Signed-off-by: Chris Yeoh <yeohc@au1.ibm.com>
Cc: stable@vger.kernel.org
 fs/proc/base.c         |    2 +-
 include/linux/sched.h  |    3 +++
 mm/process_vm_access.c |   20 ++++++--------------
 3 files changed, 10 insertions(+), 15 deletions(-)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9cde9edf..0635dc0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -198,7 +198,7 @@ static int proc_root_link(struct dentry *dentry, struct path *path)
 	return result;
 }
 
-static struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
+struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 {
 	struct mm_struct *mm;
 	int err;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4032ec1..e6268d1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2259,6 +2259,9 @@ static inline void mmdrop(struct mm_struct * mm)
 extern void mmput(struct mm_struct *);
 /* Grab a reference to a task's mm, if it is not already going away */
 extern struct mm_struct *get_task_mm(struct task_struct *task);
+/* Grab a reference to a task's mm, if it is not already going away
+   and ptrace_may_access with the mode parameter passed to it succeeds */
+struct mm_struct *mm_access(struct task_struct *task, unsigned int mode);
 /* Remove the current tasks stale references to the old mm_struct */
 extern void mm_release(struct task_struct *, struct mm_struct *);
 /* Allocate a new mm structure and copy contents from tsk->mm */
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

