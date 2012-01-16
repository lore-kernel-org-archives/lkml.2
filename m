Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2APIEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:04:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64572 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab2APIEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:04:09 -0500
Message-ID: <4F13DA90.2000603@cn.fujitsu.com>
Date: Mon, 16 Jan 2012 16:06:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 1/2] cgroup: revise how we re-populate root directory
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-16 16:03:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-16 16:03:03,
	Serialize complete at 2012-01-16 16:03:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When remounting cgroupfs with some subsystems added to it and some
removed, cgroup will remove all the files in root directory and then
re-popluate it.

What I'm doing here is, only remove files which belong to subsystems that
are to be unbound, and only create files for newly-added subsystems.
The purpose is to have all other files untouched.

This is a preparation for cgroup xattr support.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |   11 +++---
 kernel/cgroup.c        |   92 +++++++++++++++++++++++++++++++----------------
 2 files changed, 67 insertions(+), 36 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e9b6021..13db9e8 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -327,6 +327,9 @@ struct cftype {
 	 */
 	size_t max_write_len;
 
+	/* The subsystem this cgroup file belongs to */
+	struct cgroup_subsys *subsys;
+
 	int (*open)(struct inode *inode, struct file *file);
 	ssize_t (*read)(struct cgroup *cgrp, struct cftype *cft,
 			struct file *file,
@@ -419,16 +422,14 @@ struct cgroup_scanner {
  * called by subsystems from within a populate() method
  */
 int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
-		       const struct cftype *cft);
+		    struct cftype *cft);
 
 /*
  * Add a set of new files to the given cgroup directory. Should
  * only be called by subsystems from within a populate() method
  */
-int cgroup_add_files(struct cgroup *cgrp,
-			struct cgroup_subsys *subsys,
-			const struct cftype cft[],
-			int count);
+int cgroup_add_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
+		     struct cftype cft[], int count);
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5d3b53..c4ed6fe 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -781,6 +781,8 @@ static int cgroup_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode);
 static struct dentry *cgroup_lookup(struct inode *, struct dentry *, struct nameidata *);
 static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry);
 static int cgroup_populate_dir(struct cgroup *cgrp);
+static int cgroup_repopulate_dir(struct cgroup *cgrp, unsigned long added_bits,
+				 unsigned long removed_bits);
 static const struct inode_operations cgroup_dir_inode_operations;
 static const struct file_operations proc_cgroupstats_operations;
 
@@ -882,34 +884,44 @@ static void remove_dir(struct dentry *d)
 	dput(parent);
 }
 
-static void cgroup_clear_directory(struct dentry *dentry)
+static void cgroup_clear_directory(struct dentry *dentry, bool remove_all,
+				   unsigned long removed_bits)
 {
-	struct list_head *node;
+	LIST_HEAD(head);
+	struct dentry *d, *node;
 
 	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
+
 	spin_lock(&dentry->d_lock);
-	node = dentry->d_subdirs.next;
-	while (node != &dentry->d_subdirs) {
-		struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
+	list_for_each_entry_safe(d, node, &dentry->d_subdirs, d_u.d_child) {
+		struct cftype *cft = d->d_fsdata;
+
+		if (!remove_all && cft->subsys &&
+		    !test_bit(cft->subsys->subsys_id, &removed_bits))
+			continue;
 
 		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
-		list_del_init(node);
+		list_move(&d->d_u.d_child, &head);
 		if (d->d_inode) {
 			/* This should never be called on a cgroup
 			 * directory with child cgroups */
 			BUG_ON(d->d_inode->i_mode & S_IFDIR);
 			dget_dlock(d);
-			spin_unlock(&d->d_lock);
-			spin_unlock(&dentry->d_lock);
+		}
+		spin_unlock(&d->d_lock);
+	}
+	spin_unlock(&dentry->d_lock);
+
+	list_for_each_entry_safe(d, node, &head, d_u.d_child) {
+		spin_lock(&d->d_lock);
+		list_del_init(&d->d_u.d_child);
+		spin_unlock(&d->d_lock);
+		if (d->d_inode) {
 			d_delete(d);
 			simple_unlink(dentry->d_inode, d);
 			dput(d);
-			spin_lock(&dentry->d_lock);
-		} else
-			spin_unlock(&d->d_lock);
-		node = dentry->d_subdirs.next;
+		}
 	}
-	spin_unlock(&dentry->d_lock);
 }
 
 /*
@@ -919,7 +931,7 @@ static void cgroup_d_remove_dir(struct dentry *dentry)
 {
 	struct dentry *parent;
 
-	cgroup_clear_directory(dentry);
+	cgroup_clear_directory(dentry, true, 0);
 
 	parent = dentry->d_parent;
 	spin_lock(&parent->d_lock);
@@ -1284,6 +1296,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	struct cgroupfs_root *root = sb->s_fs_info;
 	struct cgroup *cgrp = &root->top_cgroup;
 	struct cgroup_sb_opts opts;
+	unsigned long added_bits, removed_bits;
 
 	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
 	mutex_lock(&cgroup_mutex);
@@ -1294,6 +1307,9 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	if (ret)
 		goto out_unlock;
 
+	added_bits = opts.subsys_bits & ~root->subsys_bits;
+	removed_bits = root->subsys_bits & ~opts.subsys_bits;
+
 	/* Don't allow flags or name to change at remount */
 	if (opts.flags != root->flags ||
 	    (opts.name && strcmp(opts.name, root->name))) {
@@ -1308,8 +1324,8 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 		goto out_unlock;
 	}
 
-	/* (re)populate subsystem files */
-	cgroup_populate_dir(cgrp);
+	/* re-populate subsystem files */
+	cgroup_repopulate_dir(cgrp, added_bits, removed_bits);
 
 	if (opts.release_agent)
 		strcpy(root->release_agent_path, opts.release_agent);
@@ -2710,16 +2726,17 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 	return mode;
 }
 
-int cgroup_add_file(struct cgroup *cgrp,
-		       struct cgroup_subsys *subsys,
-		       const struct cftype *cft)
+int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
+		    struct cftype *cft)
 {
 	struct dentry *dir = cgrp->dentry;
 	struct dentry *dentry;
 	int error;
 	umode_t mode;
-
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
+
+	cft->subsys = subsys;
+
 	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
 		strcpy(name, subsys->name);
 		strcat(name, ".");
@@ -2740,10 +2757,8 @@ int cgroup_add_file(struct cgroup *cgrp,
 }
 EXPORT_SYMBOL_GPL(cgroup_add_file);
 
-int cgroup_add_files(struct cgroup *cgrp,
-			struct cgroup_subsys *subsys,
-			const struct cftype cft[],
-			int count)
+int cgroup_add_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
+		     struct cftype cft[], int count)
 {
 	int i, err;
 	for (i = 0; i < count; i++) {
@@ -3703,26 +3718,27 @@ static struct cftype cft_release_agent = {
 	.max_write_len = PATH_MAX,
 };
 
-static int cgroup_populate_dir(struct cgroup *cgrp)
+static int __cgroup_populate_dir(struct cgroup *cgrp, unsigned long added_bits)
 {
 	int err;
 	struct cgroup_subsys *ss;
 
-	/* First clear out any existing files */
-	cgroup_clear_directory(cgrp->dentry);
-
 	err = cgroup_add_files(cgrp, NULL, files, ARRAY_SIZE(files));
 	if (err < 0)
 		return err;
 
 	if (cgrp == cgrp->top_cgroup) {
-		if ((err = cgroup_add_file(cgrp, NULL, &cft_release_agent)) < 0)
+		err = cgroup_add_file(cgrp, NULL, &cft_release_agent);
+		if (err < 0)
 			return err;
 	}
 
 	for_each_subsys(cgrp->root, ss) {
-		if (ss->populate && (err = ss->populate(ss, cgrp)) < 0)
-			return err;
+		if (test_bit(ss->subsys_id, &added_bits) && ss->populate) {
+			err = ss->populate(ss, cgrp);
+			if (err < 0)
+				return err;
+		}
 	}
 	/* This cgroup is ready now */
 	for_each_subsys(cgrp->root, ss) {
@@ -3739,6 +3755,20 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 	return 0;
 }
 
+static int cgroup_populate_dir(struct cgroup *cgrp)
+{
+	return __cgroup_populate_dir(cgrp, cgrp->root->subsys_bits);
+}
+
+static int cgroup_repopulate_dir(struct cgroup *cgrp, unsigned long added_bits,
+				 unsigned long removed_bits)
+{
+	/* First clear out files */
+	cgroup_clear_directory(cgrp->dentry, false, removed_bits);
+
+	return __cgroup_populate_dir(cgrp, added_bits);
+}
+
 static void init_cgroup_css(struct cgroup_subsys_state *css,
 			       struct cgroup_subsys *ss,
 			       struct cgroup *cgrp)
-- 
1.7.3.1
