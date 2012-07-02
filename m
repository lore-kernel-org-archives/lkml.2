Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2GBO3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab2GBO3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:29:31 -0400
Message-Id: <20120702142926.405632285@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 Jul 2012 10:29:27 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, aris@redhat.com, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>
Subject: [PATCH v3 2/3] cgroup: revise how we re-populate root directory
References: <20120702142925.795007114@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=cgroup2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

When remounting cgroupfs with some subsystems added to it and some
removed, cgroup will remove all the files in root directory and then
re-popluate it.

What I'm doing here is, only remove files which belong to subsystems that
are to be unbinded, and only create files for newly-added subsystems.
The purpose is to have all other files untouched.

This is a preparation for cgroup xattr support.

v3:
- refresh patches after recent refactoring

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 include/linux/cgroup.h |    3 +++
 kernel/cgroup.c        |   49 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 8 deletions(-)

--- linus-2.6.orig/include/linux/cgroup.h	2012-07-02 10:21:39.505647330 -0400
+++ linus-2.6/include/linux/cgroup.h	2012-07-02 10:21:58.055646941 -0400
@@ -306,6 +306,9 @@ 	 * If not 0, file mode is set to this v
 	 */
 	size_t max_write_len;
 
+	/* The subsystem this cgroup file belongs to */
+	struct cgroup_subsys *subsys;
+
 	/* CFTYPE_* flags */
 	unsigned int flags;
 
--- linus-2.6.orig/kernel/cgroup.c	2012-07-02 10:21:39.505647330 -0400
+++ linus-2.6/kernel/cgroup.c	2012-07-02 10:21:58.059646980 -0400
@@ -825,6 +825,7 @@ static int cgroup_mkdir(struct inode *di
 static struct dentry *cgroup_lookup(struct inode *, struct dentry *, struct nameidata *);
 static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry);
 static int cgroup_populate_dir(struct cgroup *cgrp);
+static int cgroup_repopulate_dir(struct cgroup *cgrp, unsigned long added_bits);
 static const struct inode_operations cgroup_dir_inode_operations;
 static const struct file_operations proc_cgroupstats_operations;
 
@@ -949,7 +950,8 @@ static void remove_dir(struct dentry *d)
 	dput(parent);
 }
 
-static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
+static int __cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft,
+			  bool remove_all, unsigned long removed_bits)
 {
 	struct cfent *cfe;
 
@@ -958,8 +960,13 @@ static int cgroup_rm_file(struct cgroup 
 
 	list_for_each_entry(cfe, &cgrp->files, node) {
 		struct dentry *d = cfe->dentry;
+		struct cftype *cft2 = cfe->type;
+
+		if (cft && cft2 != cft)
+			continue;
 
-		if (cft && cfe->type != cft)
+		if (!remove_all && cft2->subsys &&
+		    !test_bit(cft2->subsys->subsys_id, &removed_bits))
 			continue;
 
 		dget(d);
@@ -973,12 +980,19 @@ 		return 0;
 	return -ENOENT;
 }
 
-static void cgroup_clear_directory(struct dentry *dir)
+static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
+{
+	return __cgroup_rm_file(cgrp, cft, false, 0);
+}
+
+static void cgroup_clear_directory(struct dentry *dir, bool remove_all,
+				   unsigned long removed_bits)
 {
 	struct cgroup *cgrp = __d_cgrp(dir);
 
 	while (!list_empty(&cgrp->files))
-		cgroup_rm_file(cgrp, NULL);
+		if (__cgroup_rm_file(cgrp, NULL, remove_all, removed_bits))
+			break;
 }
 
 /*
@@ -988,7 +1002,7 @@ static void cgroup_d_remove_dir(struct d
 {
 	struct dentry *parent;
 
-	cgroup_clear_directory(dentry);
+	cgroup_clear_directory(dentry, true, 0);
 
 	parent = dentry->d_parent;
 	spin_lock(&parent->d_lock);
@@ -1353,6 +1367,7 @@ 	int ret = 0;
 	struct cgroupfs_root *root = sb->s_fs_info;
 	struct cgroup *cgrp = &root->top_cgroup;
 	struct cgroup_sb_opts opts;
+	unsigned long added_bits, removed_bits;
 
 	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
 	mutex_lock(&cgroup_mutex);
@@ -1368,6 +1383,9 @@ 	int ret = 0;
 		pr_warning("cgroup: option changes via remount are deprecated (pid=%d comm=%s)\n",
 			   task_tgid_nr(current), current->comm);
 
+	added_bits = opts.subsys_bits & ~root->subsys_bits;
+	removed_bits = root->subsys_bits & ~opts.subsys_bits;
+
 	/* Don't allow flags or name to change at remount */
 	if (opts.flags != root->flags ||
 	    (opts.name && strcmp(opts.name, root->name))) {
@@ -1383,8 +1401,9 @@ 	int ret = 0;
 	}
 
 	/* clear out any existing files and repopulate subsystem files */
-	cgroup_clear_directory(cgrp->dentry);
-	cgroup_populate_dir(cgrp);
+	cgroup_clear_directory(cgrp->dentry, false, removed_bits);
+	/* re-populate subsystem files */
+	cgroup_repopulate_dir(cgrp, added_bits);
 
 	if (opts.release_agent)
 		strcpy(root->release_agent_path, opts.release_agent);
@@ -2696,6 +2715,8 @@ static int cgroup_add_file(struct cgroup
 	umode_t mode;
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 
+	cft->subsys = subsys;
+
 	/* does @cft->flags tell us to skip creation on @cgrp? */
 	if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
 		return 0;
@@ -3858,7 +3879,7 @@ static struct cftype files[] = {
 	{ }	/* terminate */
 };
 
-static int cgroup_populate_dir(struct cgroup *cgrp)
+static int __cgroup_populate_dir(struct cgroup *cgrp, unsigned long added_bits)
 {
 	int err;
 	struct cgroup_subsys *ss;
@@ -3870,6 +3891,8 @@ 	if (err < 0)
 	/* process cftsets of each subsystem */
 	for_each_subsys(cgrp->root, ss) {
 		struct cftype_set *set;
+		if (!test_bit(ss->subsys_id, &added_bits))
+			continue;
 
 		list_for_each_entry(set, &ss->cftsets, node)
 			cgroup_addrm_files(cgrp, ss, set->cfts, true);
@@ -3890,6 +3913,16 @@ 	if (err < 0)
 	return 0;
 }
 
+static int cgroup_populate_dir(struct cgroup *cgrp)
+{
+	return __cgroup_populate_dir(cgrp, cgrp->root->subsys_bits);
+}
+
+static int cgroup_repopulate_dir(struct cgroup *cgrp, unsigned long added_bits)
+{
+	return __cgroup_populate_dir(cgrp, added_bits);
+}
+
 static void css_dput_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =

