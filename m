Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1LGAso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:48:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab1LGAsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:48:42 -0500
Date: Tue, 6 Dec 2011 16:48:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: remove superfluous debug output
Message-Id: <20111206164840.b634b1d1.akpm@linux-foundation.org>
In-Reply-To: <20111205113545.GA5831@albatros>
References: <201111220034.pAM0YHCC015781@wpaz9.hot.corp.google.com>
	<20111125152601.GA2783@p183.telecom.by>
	<20111205113545.GA5831@albatros>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011 15:35:45 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  fs/proc/root.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 73af7b2..ce07707 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -53,8 +53,6 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
>  	substring_t args[MAX_OPT_ARGS];
>  	int option;
>  
> -	pr_debug("proc: options = %s\n", options);
> -
>  	if (!options)
>  		return 1;

So it turns out that this patch is a fix against the pending
procfs-add-hidepid=-and-gid=-mount-options.patch.  Please tell people
this sort of thing to prevent confusion.

Also, I have a note here that Alexey has issues with
procfs-add-hidepid=-and-gid=-mount-options.patch (it is reproduced
below) - he suggests that it is using incorrect types.  Where do we
stand with that?




From: Vasiliy Kulikov <segooon@gmail.com>
Subject: procfs: add hidepid= and gid= mount options

Add support for mount options to restrict access to /proc/PID/
directories.  The default backward-compatible "relaxed" behaviour is left
untouched.

The first mount option is called "hidepid" and its value defines how much
info about processes we want to be available for non-owners:

hidepid=0 (default) means the old behavior - anybody may read all
world-readable /proc/PID/* files.

hidepid=1 means users may not access any /proc/<pid>/ directories, but
their own.  Sensitive files like cmdline, sched*, status are now protected
against other users.  As permission checking done in proc_pid_permission()
and files' permissions are left untouched, programs expecting specific
files' modes are not confused.

hidepid=2 means hidepid=1 plus all /proc/PID/ will be invisible to other
users.  It doesn't mean that it hides whether a process exists (it can be
learned by other means, e.g.  by kill -0 $PID), but it hides process' euid
and egid.  It compicates intruder's task of gathering info about running
processes, whether some daemon runs with elevated privileges, whether
another user runs some sensitive program, whether other users run any
program at all, etc.

gid=XXX defines a group that will be able to gather all processes' info
(as in hidepid=0 mode).  This group should be used instead of putting
nonroot user in sudoers file or something.  However, untrusted users (like
daemons, etc.) which are not supposed to monitor the tasks in the whole
system should not be added to the group.

hidepid=1 or higher is designed to restrict access to procfs files, which
might reveal some sensitive private information like precise keystrokes
timings:

http://www.openwall.com/lists/oss-security/2011/11/05/3

hidepid=1/2 doesn't break monitoring userspace tools.  ps, top, pgrep, and
conky gracefully handle EPERM/ENOENT and behave as if the current user is
the only user running processes.  pstree shows the process subtree which
contains "pstree" process.

Note: the patch doesn't deal with setuid/setgid issues of keeping
preopened descriptors of procfs files (like
https://lkml.org/lkml/2011/2/7/368).  We rely on that the leaked
information like the scheduling counters of setuid apps doesn't threaten
anybody's privacy - only the user started the setuid program may read the
counters.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>
Cc: Theodore Tso <tytso@MIT.EDU>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   39 ++++++++++++++++
 fs/proc/base.c                     |   64 ++++++++++++++++++++++++++-
 fs/proc/inode.c                    |    8 +++
 fs/proc/root.c                     |   19 +++++++-
 include/linux/pid_namespace.h      |    2 
 5 files changed, 130 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~procfs-add-hidepid=-and-gid=-mount-options fs/proc/base.c
--- a/fs/proc/base.c~procfs-add-hidepid=-and-gid=-mount-options
+++ a/fs/proc/base.c
@@ -630,6 +630,45 @@ int proc_setattr(struct dentry *dentry, 
 	return 0;
 }
 
+/*
+ * May current process learn task's sched/cmdline info (for hide_pid_min=1)
+ * or euid/egid (for hide_pid_min=2)?
+ */
+static bool has_pid_permissions(struct pid_namespace *pid,
+				 struct task_struct *task,
+				 int hide_pid_min)
+{
+	if (pid->hide_pid < hide_pid_min)
+		return true;
+	if (in_group_p(pid->pid_gid))
+		return true;
+	return ptrace_may_access(task, PTRACE_MODE_READ);
+}
+
+
+static int proc_pid_permission(struct inode *inode, int mask)
+{
+	struct pid_namespace *pid = inode->i_sb->s_fs_info;
+	struct task_struct *task = get_proc_task(inode);
+
+	if (!has_pid_permissions(pid, task, 1)) {
+		if (pid->hide_pid == 2) {
+			/*
+			 * Let's make getdents(), stat(), and open()
+			 * consistent with each other.  If a process
+			 * may not stat() a file, it shouldn't be seen
+			 * in procfs at all.
+			 */
+			return -ENOENT;
+		}
+
+		return -EPERM;
+	}
+	return generic_permission(inode, mask);
+}
+
+
+
 static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
 };
@@ -1726,6 +1765,7 @@ int pid_getattr(struct vfsmount *mnt, st
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task;
 	const struct cred *cred;
+	struct pid_namespace *pid = dentry->d_sb->s_fs_info;
 
 	generic_fillattr(inode, stat);
 
@@ -1734,6 +1774,14 @@ int pid_getattr(struct vfsmount *mnt, st
 	stat->gid = 0;
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
+		if (!has_pid_permissions(pid, task, 2)) {
+			rcu_read_unlock();
+			/*
+			 * This doesn't prevent learning whether PID exists,
+			 * it only makes getattr() consistent with readdir().
+			 */
+			return -ENOENT;
+		}
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
 			cred = __task_cred(task);
@@ -3224,6 +3272,7 @@ static const struct inode_operations pro
 	.lookup		= proc_tgid_base_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
@@ -3427,6 +3476,12 @@ static int proc_pid_fill_cache(struct fi
 				proc_pid_instantiate, iter.task, NULL);
 }
 
+static int fake_filldir(void *buf, const char *name, int namelen,
+			loff_t offset, u64 ino, unsigned d_type)
+{
+	return 0;
+}
+
 /* for the /proc/ directory itself, after non-process stuff has been done */
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
@@ -3434,6 +3489,7 @@ int proc_pid_readdir(struct file * filp,
 	struct task_struct *reaper;
 	struct tgid_iter iter;
 	struct pid_namespace *ns;
+	filldir_t __filldir;
 
 	if (filp->f_pos >= PID_MAX_LIMIT + TGID_OFFSET)
 		goto out_no_task;
@@ -3455,8 +3511,13 @@ int proc_pid_readdir(struct file * filp,
 	for (iter = next_tgid(ns, iter);
 	     iter.task;
 	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
+		if (has_pid_permissions(ns, iter.task, 2))
+			__filldir = filldir;
+		else
+			__filldir = fake_filldir;
+
 		filp->f_pos = iter.tgid + TGID_OFFSET;
-		if (proc_pid_fill_cache(filp, dirent, filldir, iter) < 0) {
+		if (proc_pid_fill_cache(filp, dirent, __filldir, iter) < 0) {
 			put_task_struct(iter.task);
 			goto out;
 		}
@@ -3791,6 +3852,7 @@ static const struct inode_operations pro
 	.lookup		= proc_task_lookup,
 	.getattr	= proc_task_getattr,
 	.setattr	= proc_setattr,
+	.permission	= proc_pid_permission,
 };
 
 static const struct file_operations proc_task_operations = {
diff -puN fs/proc/inode.c~procfs-add-hidepid=-and-gid=-mount-options fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-add-hidepid=-and-gid=-mount-options
+++ a/fs/proc/inode.c
@@ -109,6 +109,14 @@ void __init proc_init_inodecache(void)
 
 static int proc_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
+	struct super_block *sb = vfs->mnt_sb;
+	struct pid_namespace *pid = sb->s_fs_info;
+
+	if (pid->pid_gid)
+		seq_printf(seq, ",gid=%lu", (unsigned long)pid->pid_gid);
+	if (pid->hide_pid != 0)
+		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
+
 	return 0;
 }
 
diff -puN fs/proc/root.c~procfs-add-hidepid=-and-gid=-mount-options fs/proc/root.c
--- a/fs/proc/root.c~procfs-add-hidepid=-and-gid=-mount-options
+++ a/fs/proc/root.c
@@ -38,10 +38,12 @@ static int proc_set_super(struct super_b
 }
 
 enum {
-	Opt_err,
+	Opt_gid, Opt_hidepid, Opt_err,
 };
 
 static const match_table_t tokens = {
+	{Opt_hidepid, "hidepid=%u"},
+	{Opt_gid, "gid=%u"},
 	{Opt_err, NULL},
 };
 
@@ -49,6 +51,7 @@ static int proc_parse_options(char *opti
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
+	int option;
 
 	pr_debug("proc: options = %s\n", options);
 
@@ -63,6 +66,20 @@ static int proc_parse_options(char *opti
 		args[0].to = args[0].from = 0;
 		token = match_token(p, tokens, args);
 		switch (token) {
+		case Opt_gid:
+			if (match_int(&args[0], &option))
+				return 0;
+			pid->pid_gid = option;
+			break;
+		case Opt_hidepid:
+			if (match_int(&args[0], &option))
+				return 0;
+			if (option < 0 || option > 2) {
+				pr_err("proc: hidepid value must be between 0 and 2.\n");
+				return 0;
+			}
+			pid->hide_pid = option;
+			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
 			       "or missing value\n", p);
diff -puN include/linux/pid_namespace.h~procfs-add-hidepid=-and-gid=-mount-options include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~procfs-add-hidepid=-and-gid=-mount-options
+++ a/include/linux/pid_namespace.h
@@ -30,6 +30,8 @@ struct pid_namespace {
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct bsd_acct_struct *bacct;
 #endif
+	gid_t pid_gid;
+	int hide_pid;
 };
 
 extern struct pid_namespace init_pid_ns;
diff -puN Documentation/filesystems/proc.txt~procfs-add-hidepid=-and-gid=-mount-options Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-add-hidepid=-and-gid=-mount-options
+++ a/Documentation/filesystems/proc.txt
@@ -41,6 +41,8 @@ Table of Contents
   3.5	/proc/<pid>/mountinfo - Information about mounts
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
 
+  4	Configuring procfs
+  4.1	Mount options
 
 ------------------------------------------------------------------------------
 Preface
@@ -1542,3 +1544,40 @@ a task to set its own or one of its thre
 is limited in size compared to the cmdline value, so writing anything longer
 then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
 comm value.
+
+
+------------------------------------------------------------------------------
+Configuring procfs
+------------------------------------------------------------------------------
+
+4.1	Mount options
+---------------------
+
+The following mount options are supported:
+
+	hidepid=	Set /proc/<pid>/ access mode.
+	gid=		Set the group authorized to learn processes information.
+
+hidepid=0 means classic mode - everybody may access all /proc/<pid>/ directories
+(default).
+
+hidepid=1 means users may not access any /proc/<pid>/ directories but their
+own.  Sensitive files like cmdline, sched*, status are now protected against
+other users.  This makes it impossible to learn whether any user runs
+specific program (given the program doesn't reveal itself by its behaviour).
+As an additional bonus, as /proc/<pid>/cmdline is unaccessible for other users,
+poorly written programs passing sensitive information via program arguments are
+now protected against local eavesdroppers.
+
+hidepid=2 means hidepid=1 plus all /proc/<pid>/ will be fully invisible to other
+users.  It doesn't mean that it hides a fact whether a process with a specific
+pid value exists (it can be learned by other means, e.g. by "kill -0 $PID"),
+but it hides process' uid and gid, which may be learned by stat()'ing
+/proc/<pid>/ otherwise.  It greatly complicates an intruder's task of gathering
+information about running processes, whether some daemon runs with elevated
+privileges, whether other user runs some sensitive program, whether other users
+run any program at all, etc.
+
+gid= defines a group authorized to learn processes information otherwise
+prohibited by hidepid=.  If you use some daemon like identd which needs to learn
+information about processes information, just add identd to this group.
_

