Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2CEPgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:36:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab2CEPgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:36:16 -0500
Date: Mon, 5 Mar 2012 16:28:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] turn mm->exe_file into mm->exe_path
Message-ID: <20120305152850.GA12427@redhat.com>
References: <20120305152826.GA12419@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305152826.GA12419@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn mm->exe_file into mm->exe_path and fix the compilation errors.
We only need this member to get the path, additional reference to
bprm->file makes no sense.

The patch doesn't rename added_exe_file_vma/removed_exe_file_vma
and mm->num_exe_file_vmas, and perhaps we can remove them later.

Also remove the stale comment in include/linux/mm.h.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c                |   20 ++++++++++----------
 fs/proc/base.c           |   17 ++++++++---------
 include/linux/mm.h       |    5 ++---
 include/linux/mm_types.h |    2 +-
 kernel/fork.c            |   41 +++++++++++++++++++++--------------------
 5 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 92ce83a..cf16922 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1098,7 +1098,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 	if (retval)
 		goto out;
 
-	set_mm_exe_file(bprm->mm, bprm->file);
+	set_mm_exe_path(bprm->mm, &bprm->file->f_path);
 
 	filename_to_taskname(bprm->tcomm, bprm->filename, sizeof(bprm->tcomm));
 	/*
@@ -1671,14 +1671,14 @@ static void cn_escape(char *str)
 			*str = '!';
 }
 
-static int cn_print_exe_file(struct core_name *cn)
+static int cn_print_exe_path(struct core_name *cn)
 {
-	struct file *exe_file;
+	struct path *exe_path;
 	char *pathbuf, *path;
 	int ret;
 
-	exe_file = get_mm_exe_file(current->mm);
-	if (!exe_file) {
+	exe_path = get_mm_exe_path(current->mm);
+	if (!exe_path) {
 		char *commstart = cn->corename + cn->used;
 		ret = cn_printf(cn, "%s (path unknown)", current->comm);
 		cn_escape(commstart);
@@ -1688,10 +1688,10 @@ static int cn_print_exe_file(struct core_name *cn)
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
 	if (!pathbuf) {
 		ret = -ENOMEM;
-		goto put_exe_file;
+		goto put_exe_path;
 	}
 
-	path = d_path(&exe_file->f_path, pathbuf, PATH_MAX);
+	path = d_path(exe_path, pathbuf, PATH_MAX);
 	if (IS_ERR(path)) {
 		ret = PTR_ERR(path);
 		goto free_buf;
@@ -1703,8 +1703,8 @@ static int cn_print_exe_file(struct core_name *cn)
 
 free_buf:
 	kfree(pathbuf);
-put_exe_file:
-	fput(exe_file);
+put_exe_path:
+	path_put(exe_path);
 	return ret;
 }
 
@@ -1786,7 +1786,7 @@ static int format_corename(struct core_name *cn, long signr)
 				break;
 			}
 			case 'E':
-				err = cn_print_exe_file(cn);
+				err = cn_print_exe_path(cn);
 				break;
 			/* core limit size */
 			case 'c':
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d4548dd..0d7dbd6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1401,11 +1401,11 @@ static const struct file_operations proc_pid_set_comm_operations = {
 	.release	= single_release,
 };
 
-static int proc_exe_link(struct dentry *dentry, struct path *exe_path)
+static int proc_exe_link(struct dentry *dentry, struct path *path)
 {
 	struct task_struct *task;
 	struct mm_struct *mm;
-	struct file *exe_file;
+	struct path *exe_path;
 
 	task = get_proc_task(dentry->d_inode);
 	if (!task)
@@ -1414,15 +1414,14 @@ static int proc_exe_link(struct dentry *dentry, struct path *exe_path)
 	put_task_struct(task);
 	if (!mm)
 		return -ENOENT;
-	exe_file = get_mm_exe_file(mm);
+	exe_path = get_mm_exe_path(mm);
 	mmput(mm);
-	if (exe_file) {
-		*exe_path = exe_file->f_path;
-		path_get(&exe_file->f_path);
-		fput(exe_file);
-		return 0;
-	} else
+
+	if (!exe_path)
 		return -ENOENT;
+
+	*path = *exe_path;
+	return 0;
 }
 
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 17b27cd..d18fe93 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1375,11 +1375,10 @@ extern void exit_mmap(struct mm_struct *);
 extern int mm_take_all_locks(struct mm_struct *mm);
 extern void mm_drop_all_locks(struct mm_struct *mm);
 
-/* From fs/proc/base.c. callers must _not_ hold the mm's exe_file_lock */
 extern void added_exe_file_vma(struct mm_struct *mm);
 extern void removed_exe_file_vma(struct mm_struct *mm);
-extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
-extern struct file *get_mm_exe_file(struct mm_struct *mm);
+extern void set_mm_exe_path(struct mm_struct *mm, struct path *exe_path);
+extern struct path *get_mm_exe_path(struct mm_struct *mm);
 
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
 extern int install_special_mapping(struct mm_struct *mm,
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3cc3062..e734984 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -377,7 +377,7 @@ struct mm_struct {
 #endif
 
 	/* store ref to file /proc/<pid>/exe symlink points to */
-	struct file *exe_file;
+	struct path *exe_path;
 	unsigned long num_exe_file_vmas;
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
diff --git a/kernel/fork.c b/kernel/fork.c
index b77fd55..5e3aa50 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -556,7 +556,7 @@ void mmput(struct mm_struct *mm)
 		ksm_exit(mm);
 		khugepaged_exit(mm); /* must run before exit_mmap */
 		exit_mmap(mm);
-		set_mm_exe_file(mm, NULL);
+		set_mm_exe_path(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {
 			spin_lock(&mmlist_lock);
 			list_del(&mm->mmlist);
@@ -583,42 +583,43 @@ void added_exe_file_vma(struct mm_struct *mm)
 void removed_exe_file_vma(struct mm_struct *mm)
 {
 	mm->num_exe_file_vmas--;
-	if ((mm->num_exe_file_vmas == 0) && mm->exe_file) {
-		fput(mm->exe_file);
-		mm->exe_file = NULL;
+	if ((mm->num_exe_file_vmas == 0) && mm->exe_path) {
+		path_put(mm->exe_path);
+		mm->exe_path = NULL;
 	}
 
 }
 
-void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file)
+void set_mm_exe_path(struct mm_struct *mm, struct path *exe_path)
 {
-	if (new_exe_file)
-		get_file(new_exe_file);
-	if (mm->exe_file)
-		fput(mm->exe_file);
-	mm->exe_file = new_exe_file;
+	if (mm->exe_path)
+		path_put(mm->exe_path);
+	mm->exe_path = exe_path;
+	if (mm->exe_path)
+		path_get(mm->exe_path);
 	mm->num_exe_file_vmas = 0;
 }
 
-struct file *get_mm_exe_file(struct mm_struct *mm)
+struct path *get_mm_exe_path(struct mm_struct *mm)
 {
-	struct file *exe_file;
+	struct path *exe_path;
 
 	/* We need mmap_sem to protect against races with removal of
 	 * VM_EXECUTABLE vmas */
 	down_read(&mm->mmap_sem);
-	exe_file = mm->exe_file;
-	if (exe_file)
-		get_file(exe_file);
+	exe_path = mm->exe_path;
+	if (exe_path)
+		path_get(exe_path);
 	up_read(&mm->mmap_sem);
-	return exe_file;
+
+	return exe_path;
 }
 
-static void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm)
+static void dup_mm_exe_path(struct mm_struct *oldmm, struct mm_struct *newmm)
 {
-	/* It's safe to write the exe_file pointer without exe_file_lock because
+	/* It's safe to write the exe_path pointer without mmap_sem because
 	 * this is called during fork when the task is not yet in /proc */
-	newmm->exe_file = get_mm_exe_file(oldmm);
+	newmm->exe_path = get_mm_exe_path(oldmm);
 }
 
 /**
@@ -763,7 +764,7 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
 	if (init_new_context(tsk, mm))
 		goto fail_nocontext;
 
-	dup_mm_exe_file(oldmm, mm);
+	dup_mm_exe_path(oldmm, mm);
 
 	err = dup_mmap(mm, oldmm);
 	if (err)
-- 
1.5.5.1


