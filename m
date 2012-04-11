Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2DKGBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:01:39 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38246 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab2DKGBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:01:37 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 5/6] proc: use task_access_lock() instead of ptrace_may_access()
Date: Wed, 11 Apr 2012 13:59:26 +0800
Message-Id: <1334123976-11681-5-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several places in fs/proc/base.c still use ptrace_may_access()
directly to check the permission, actually this just gets a snapshot of
the permission, nothing prevents the target task from raising the priviledges
itself, it is better to use task_access_lock() for these places, to hold
the priviledges.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 fs/proc/base.c |   74 +++++++++++++++++++++++++-------------------------------
 1 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f1d18fc..2dff86b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -253,6 +253,23 @@ static int proc_pid_auxv(struct task_struct *task, char *buffer)
 	return res;
 }
 
+static int task_access_lock(struct task_struct *task, unsigned int mode)
+
+{
+	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (err)
+		return err;
+	if (!ptrace_may_access(task, mode)) {
+		mutex_unlock(&task->signal->cred_guard_mutex);
+		return -EPERM;
+	}
+	return 0;
+}
+
+static void task_access_unlock(struct task_struct *task)
+{
+	mutex_unlock(&task->signal->cred_guard_mutex);
+}
 
 #ifdef CONFIG_KALLSYMS
 /*
@@ -264,35 +281,18 @@ static int proc_pid_wchan(struct task_struct *task, char *buffer)
 	unsigned long wchan;
 	char symname[KSYM_NAME_LEN];
 
+	if (task_access_lock(task, PTRACE_MODE_READ))
+		return 0;
 	wchan = get_wchan(task);
 
+	task_access_unlock(task);
 	if (lookup_symbol_name(wchan, symname) < 0)
-		if (!ptrace_may_access(task, PTRACE_MODE_READ))
-			return 0;
-		else
-			return sprintf(buffer, "%lu", wchan);
+		return sprintf(buffer, "%lu", wchan);
 	else
 		return sprintf(buffer, "%s", symname);
 }
 #endif /* CONFIG_KALLSYMS */
 
-static int task_access_lock(struct task_struct *task, unsigned int mode)
-{
-	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
-	if (err)
-		return err;
-	if (!ptrace_may_access(task, mode)) {
-		mutex_unlock(&task->signal->cred_guard_mutex);
-		return -EPERM;
-	}
-	return 0;
-}
-
-static void task_access_unlock(struct task_struct *task)
-{
-	mutex_unlock(&task->signal->cred_guard_mutex);
-}
-
 #ifdef CONFIG_STACKTRACE
 
 #define MAX_STACK_TRACE_DEPTH	64
@@ -512,23 +512,6 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
 /*                       Here the fs part begins                        */
 /************************************************************************/
 
-/* permission checks */
-static int proc_fd_access_allowed(struct inode *inode)
-{
-	struct task_struct *task;
-	int allowed = 0;
-	/* Allow access to a task's file descriptors if it is us or we
-	 * may use ptrace attach to the process and find out that
-	 * information.
-	 */
-	task = get_proc_task(inode);
-	if (task) {
-		allowed = ptrace_may_access(task, PTRACE_MODE_READ);
-		put_task_struct(task);
-	}
-	return allowed;
-}
-
 int proc_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	int error;
@@ -1425,17 +1408,21 @@ static int proc_exe_link(struct dentry *dentry, struct path *exe_path)
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
+	struct task_struct *task = get_proc_task(inode);
 	int error = -EACCES;
 
 	/* We don't need a base pointer in the /proc filesystem */
 	path_put(&nd->path);
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
-	if (!proc_fd_access_allowed(inode))
+	error = task_access_lock(task, PTRACE_MODE_READ);
+	if (error)
 		goto out;
 
 	error = PROC_I(inode)->op.proc_get_link(dentry, &nd->path);
+	task_access_unlock(task);
 out:
+	put_task_struct(task);
 	return ERR_PTR(error);
 }
 
@@ -1467,19 +1454,24 @@ static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int b
 {
 	int error = -EACCES;
 	struct inode *inode = dentry->d_inode;
+	struct task_struct *task = get_proc_task(inode);
 	struct path path;
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
-	if (!proc_fd_access_allowed(inode))
+	error = task_access_lock(task, PTRACE_MODE_READ);
+	if (error)
 		goto out;
 
 	error = PROC_I(inode)->op.proc_get_link(dentry, &path);
 	if (error)
-		goto out;
+		goto out_unlock;
 
 	error = do_proc_readlink(&path, buffer, buflen);
 	path_put(&path);
+out_unlock:
+	task_access_unlock(task);
 out:
+	put_task_struct(task);
 	return error;
 }
 
-- 
1.7.7.6

