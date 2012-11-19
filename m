Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2KSPRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:17:54 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:52862 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab2KSPRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:17:06 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 07:12:40 -0800
Message-Id: <1353337961-12962-15-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19+4C7eLC2WGtf0p48WSRM+pVeFmnAYZkM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0048]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 15/16] proc: Fix the namespace inode permission checks.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Change the proc namespace files into symlinks so that
we won't cache the dentries for the namespace files
which can bypass the ptrace_may_access checks.

To support the symlinks create an additional namespace
inode with it's own set of operations distinct from the
proc pid inode and dentry methods as those no longer
make sense.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/inode.c      |    6 +-
 fs/proc/namespaces.c |  169 +++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 152 insertions(+), 23 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 3b22bbd..439ae688 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -31,6 +31,7 @@ static void proc_evict_inode(struct inode *inode)
 	struct proc_dir_entry *de;
 	struct ctl_table_header *head;
 	const struct proc_ns_operations *ns_ops;
+	void *ns;
 
 	truncate_inode_pages(&inode->i_data, 0);
 	clear_inode(inode);
@@ -49,8 +50,9 @@ static void proc_evict_inode(struct inode *inode)
 	}
 	/* Release any associated namespace */
 	ns_ops = PROC_I(inode)->ns_ops;
-	if (ns_ops && ns_ops->put)
-		ns_ops->put(PROC_I(inode)->ns);
+	ns = PROC_I(inode)->ns;
+	if (ns_ops && ns)
+		ns_ops->put(ns);
 }
 
 static struct kmem_cache * proc_inode_cachep;
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 030250c..7a6d8d6 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -38,6 +38,151 @@ static const struct file_operations ns_file_operations = {
 	.llseek		= no_llseek,
 };
 
+static const struct inode_operations ns_inode_operations = {
+	.setattr	= proc_setattr,
+};
+
+static int ns_delete_dentry(const struct dentry *dentry)
+{
+	/* Don't cache namespace inodes when not in use */
+	return 1;
+}
+
+static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	struct inode *inode = dentry->d_inode;
+	const struct proc_ns_operations *ns_ops = PROC_I(inode)->ns_ops;
+
+	return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
+		ns_ops->name, inode->i_ino);
+}
+
+const struct dentry_operations ns_dentry_operations =
+{
+	.d_delete	= ns_delete_dentry,
+	.d_dname	= ns_dname,
+};
+
+static struct dentry *proc_ns_get_dentry(struct super_block *sb,
+	struct task_struct *task, const struct proc_ns_operations *ns_ops)
+{
+	struct dentry *dentry, *result;
+	struct inode *inode;
+	struct proc_inode *ei;
+	struct qstr qname = { .name = "", };
+	void *ns;
+
+	ns = ns_ops->get(task);
+	if (!ns)
+		return ERR_PTR(-ENOENT);
+
+	dentry = d_alloc_pseudo(sb, &qname);
+	if (!dentry) {
+		ns_ops->put(ns);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	inode = new_inode(sb);
+	if (!inode) {
+		dput(dentry);
+		ns_ops->put(ns);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ei = PROC_I(inode);
+	inode->i_ino = get_next_ino();
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	inode->i_op = &ns_inode_operations;
+	inode->i_mode = S_IFREG | S_IRUGO;
+	inode->i_fop = &ns_file_operations;
+	ei->ns_ops = ns_ops;
+	ei->ns = ns;
+
+	d_set_d_op(dentry, &ns_dentry_operations);
+	result = d_instantiate_unique(dentry, inode);
+	if (result) {
+		dput(dentry);
+		dentry = result;
+	}
+
+	return dentry;
+}
+
+static void *proc_ns_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct proc_inode *ei = PROC_I(inode);
+	struct task_struct *task;
+	struct dentry *ns_dentry;
+	void *error = ERR_PTR(-EACCES);
+
+	task = get_proc_task(inode);
+	if (!task)
+		goto out;
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+		goto out_put_task;
+
+	ns_dentry = proc_ns_get_dentry(sb, task, ei->ns_ops);
+	if (IS_ERR(ns_dentry)) {
+		error = ERR_CAST(ns_dentry);
+		goto out_put_task;
+	}
+
+	dput(nd->path.dentry);
+	nd->path.dentry = ns_dentry;
+	error = NULL;
+
+out_put_task:
+	put_task_struct(task);
+out:
+	return error;
+}
+
+static int proc_ns_readlink(struct dentry *dentry, char __user *buffer, int buflen)
+{
+	struct inode *inode = dentry->d_inode;
+	struct proc_inode *ei = PROC_I(inode);
+	const struct proc_ns_operations *ns_ops = ei->ns_ops;
+	struct task_struct *task;
+	void *ns;
+	char name[50];
+	int len = -EACCES;
+
+	task = get_proc_task(inode);
+	if (!task)
+		goto out;
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+		goto out_put_task;
+
+	len = -ENOENT;
+	ns = ns_ops->get(task);
+	if (!ns)
+		goto out_put_task;
+
+	snprintf(name, sizeof(name), "%s", ns_ops->name);
+	len = strlen(name);
+
+	if (len > buflen)
+		len = buflen;
+	if (copy_to_user(buffer, ns_ops->name, len))
+		len = -EFAULT;
+
+	ns_ops->put(ns);
+out_put_task:
+	put_task_struct(task);
+out:
+	return len;
+}
+
+static const struct inode_operations proc_ns_link_inode_operations = {
+	.readlink	= proc_ns_readlink,
+	.follow_link	= proc_ns_follow_link,
+	.setattr	= proc_setattr,
+};
+
 static struct dentry *proc_ns_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
@@ -45,21 +190,15 @@ static struct dentry *proc_ns_instantiate(struct inode *dir,
 	struct inode *inode;
 	struct proc_inode *ei;
 	struct dentry *error = ERR_PTR(-ENOENT);
-	void *ns;
 
 	inode = proc_pid_make_inode(dir->i_sb, task);
 	if (!inode)
 		goto out;
 
-	ns = ns_ops->get(task);
-	if (!ns)
-		goto out_iput;
-
 	ei = PROC_I(inode);
-	inode->i_mode = S_IFREG|S_IRUSR;
-	inode->i_fop  = &ns_file_operations;
-	ei->ns_ops    = ns_ops;
-	ei->ns	      = ns;
+	inode->i_mode = S_IFLNK|S_IRWXUGO;
+	inode->i_op = &proc_ns_link_inode_operations;
+	ei->ns_ops = ns_ops;
 
 	d_set_d_op(dentry, &pid_dentry_operations);
 	d_add(dentry, inode);
@@ -68,9 +207,6 @@ static struct dentry *proc_ns_instantiate(struct inode *dir,
 		error = NULL;
 out:
 	return error;
-out_iput:
-	iput(inode);
-	goto out;
 }
 
 static int proc_ns_fill_cache(struct file *filp, void *dirent,
@@ -97,10 +233,6 @@ static int proc_ns_dir_readdir(struct file *filp, void *dirent,
 	if (!task)
 		goto out_no_task;
 
-	ret = -EPERM;
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		goto out;
-
 	ret = 0;
 	i = filp->f_pos;
 	switch (i) {
@@ -160,10 +292,6 @@ static struct dentry *proc_ns_dir_lookup(struct inode *dir,
 	if (!task)
 		goto out_no_task;
 
-	error = ERR_PTR(-EPERM);
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		goto out;
-
 	last = &ns_entries[ARRAY_SIZE(ns_entries)];
 	for (entry = ns_entries; entry < last; entry++) {
 		if (strlen((*entry)->name) != len)
@@ -171,7 +299,6 @@ static struct dentry *proc_ns_dir_lookup(struct inode *dir,
 		if (!memcmp(dentry->d_name.name, (*entry)->name, len))
 			break;
 	}
-	error = ERR_PTR(-ENOENT);
 	if (entry == last)
 		goto out;
 
-- 
1.7.5.4

