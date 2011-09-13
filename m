Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab1IMVZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:25:31 -0400
Received: from mail-ew0-f52.google.com ([209.85.215.52]:54541 "EHLO
	mail-ew0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab1IMVYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:24:53 -0400
Message-Id: <20110913212447.682271914@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Sep 2011 01:14:00 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org
Cc: Kirill Shutemov <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Nathan Lynch <ntl@pobox.com>, Zan Lynx <zlynx@acm.org>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Tejun Heo <tj@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [patch 1/2] fs, proc: Make proc_get_link to use dentry instead of inode
References: <20110913211359.674453213@openvz.org>
Content-Disposition: inline; filename=fs-proc-switch-to-dentry
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares the ground for the next "map_files"
patch which needs a name of a link file to analyse.

So instead of squashing this change into one big
patch the separate one is done.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Tejun Heo <tj@kernel.org>
CC: Vasiliy Kulikov <segoon@openwall.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/base.c          |   20 ++++++++++----------
 include/linux/proc_fs.h |    2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -165,9 +165,9 @@ static int get_task_root(struct task_str
 	return result;
 }
 
-static int proc_cwd_link(struct inode *inode, struct path *path)
+static int proc_cwd_link(struct dentry *dentry, struct path *path)
 {
-	struct task_struct *task = get_proc_task(inode);
+	struct task_struct *task = get_proc_task(dentry->d_inode);
 	int result = -ENOENT;
 
 	if (task) {
@@ -182,9 +182,9 @@ static int proc_cwd_link(struct inode *i
 	return result;
 }
 
-static int proc_root_link(struct inode *inode, struct path *path)
+static int proc_root_link(struct dentry *dentry, struct path *path)
 {
-	struct task_struct *task = get_proc_task(inode);
+	struct task_struct *task = get_proc_task(dentry->d_inode);
 	int result = -ENOENT;
 
 	if (task) {
@@ -1580,13 +1580,13 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
-static int proc_exe_link(struct inode *inode, struct path *exe_path)
+static int proc_exe_link(struct dentry *dentry, struct path *exe_path)
 {
 	struct task_struct *task;
 	struct mm_struct *mm;
 	struct file *exe_file;
 
-	task = get_proc_task(inode);
+	task = get_proc_task(dentry->d_inode);
 	if (!task)
 		return -ENOENT;
 	mm = get_task_mm(task);
@@ -1616,7 +1616,7 @@ static void *proc_pid_follow_link(struct
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path);
+	error = PROC_I(inode)->op.proc_get_link(dentry, &nd->path);
 out:
 	return ERR_PTR(error);
 }
@@ -1655,7 +1655,7 @@ static int proc_pid_readlink(struct dent
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &path);
+	error = PROC_I(inode)->op.proc_get_link(dentry, &path);
 	if (error)
 		goto out;
 
@@ -1947,9 +1947,9 @@ static int proc_fd_info(struct inode *in
 	return -ENOENT;
 }
 
-static int proc_fd_link(struct inode *inode, struct path *path)
+static int proc_fd_link(struct dentry *dentry, struct path *path)
 {
-	return proc_fd_info(inode, path, NULL);
+	return proc_fd_info(dentry->d_inode, path, NULL);
 }
 
 static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
Index: linux-2.6.git/include/linux/proc_fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/proc_fs.h
+++ linux-2.6.git/include/linux/proc_fs.h
@@ -253,7 +253,7 @@ extern const struct proc_ns_operations u
 extern const struct proc_ns_operations ipcns_operations;
 
 union proc_op {
-	int (*proc_get_link)(struct inode *, struct path *);
+	int (*proc_get_link)(struct dentry *, struct path *);
 	int (*proc_read)(struct task_struct *task, char *page);
 	int (*proc_show)(struct seq_file *m,
 		struct pid_namespace *ns, struct pid *pid,

