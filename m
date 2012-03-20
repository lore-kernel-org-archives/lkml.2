Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2CTSGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:06:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64121 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2CTSGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:06:40 -0400
Date: Tue, 20 Mar 2012 11:06:35 -0700
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com
Subject: [PATCH UPDATED 09/10] cgroup: introduce struct cfent
Message-ID: <20120320180635.GA20832@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
 <1331940963-15756-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331940963-15756-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds cfent (cgroup file entry) which is the association
between a cgroup and a file.  This is in-cgroup representation of
files under a cgroup directory.  This simplifies walking walking
cgroup files and thus cgroup_clear_directory(), which is now
implemented in two parts - cgroup_rm_file() and a loop around it.

cgroup_rm_file() will be used to implement cftype removal and cfent is
scheduled to serve cgroup specific per-file data (e.g. for sysfs-like
"sever" semantics).

v2: - cfe was freed from cgroup_rm_file() which led to use-after-free
      if the file had openers at the time of removal.  Moved to
      cgroup_diput().

    - cgroup_clear_directory() triggered WARN_ON_ONCE() if d_subdirs
      wasn't empty after removing all files.  This triggered
      spuriously if some files were open during directory clearing.
      Removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>
---
Glauber, we may have positive child dentries for open files so your
fix isn't enough.  I just removed the WARN_ON_ONCE().

Thanks.

 include/linux/cgroup.h |    1 
 kernel/cgroup.c        |  107 +++++++++++++++++++++++++++++++++----------------
 2 files changed, 74 insertions(+), 34 deletions(-)

Index: work/include/linux/cgroup.h
===================================================================
--- work.orig/include/linux/cgroup.h
+++ work/include/linux/cgroup.h
@@ -175,6 +175,7 @@ struct cgroup {
 	 */
 	struct list_head sibling;	/* my parent's children */
 	struct list_head children;	/* my children */
+	struct list_head files;		/* my files */
 
 	struct cgroup *parent;		/* my parent */
 	struct dentry __rcu *dentry;	/* cgroup fs entry, RCU protected */
Index: work/kernel/cgroup.c
===================================================================
--- work.orig/kernel/cgroup.c
+++ work/kernel/cgroup.c
@@ -158,6 +158,15 @@ struct cftype_set {
 };
 
 /*
+ * cgroupfs file entry, pointed to from leaf dentry->d_fsdata.
+ */
+struct cfent {
+	struct list_head		node;
+	struct dentry			*dentry;
+	struct cftype			*type;
+};
+
+/*
  * CSS ID -- ID per subsys's Cgroup Subsys State(CSS). used only when
  * cgroup_subsys->use_id != 0.
  */
@@ -297,11 +306,16 @@ static inline struct cgroup *__d_cgrp(st
 	return dentry->d_fsdata;
 }
 
-static inline struct cftype *__d_cft(struct dentry *dentry)
+static inline struct cfent *__d_cfe(struct dentry *dentry)
 {
 	return dentry->d_fsdata;
 }
 
+static inline struct cftype *__d_cft(struct dentry *dentry)
+{
+	return __d_cfe(dentry)->type;
+}
+
 /* the list of cgroups eligible for automatic release. Protected by
  * release_list_lock */
 static LIST_HEAD(release_list);
@@ -887,6 +901,12 @@ static void cgroup_diput(struct dentry *
 		BUG_ON(!list_empty(&cgrp->pidlists));
 
 		kfree_rcu(cgrp, rcu_head);
+	} else {
+		struct cfent *cfe = __d_cfe(dentry);
+
+		WARN_ONCE(!list_empty(&cfe->node),
+			  "cfe still linked for %s\n", cfe->type->name);
+		kfree(cfe);
 	}
 	iput(inode);
 }
@@ -905,34 +925,36 @@ static void remove_dir(struct dentry *d)
 	dput(parent);
 }
 
-static void cgroup_clear_directory(struct dentry *dentry)
+static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 {
-	struct list_head *node;
+	struct cfent *cfe;
+
+	lockdep_assert_held(&cgrp->dentry->d_inode->i_mutex);
+	lockdep_assert_held(&cgroup_mutex);
+
+	list_for_each_entry(cfe, &cgrp->files, node) {
+		struct dentry *d = cfe->dentry;
 
-	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
-	spin_lock(&dentry->d_lock);
-	node = dentry->d_subdirs.next;
-	while (node != &dentry->d_subdirs) {
-		struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
-
-		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
-		list_del_init(node);
-		if (d->d_inode) {
-			/* This should never be called on a cgroup
-			 * directory with child cgroups */
-			BUG_ON(d->d_inode->i_mode & S_IFDIR);
-			dget_dlock(d);
-			spin_unlock(&d->d_lock);
-			spin_unlock(&dentry->d_lock);
-			d_delete(d);
-			simple_unlink(dentry->d_inode, d);
-			dput(d);
-			spin_lock(&dentry->d_lock);
-		} else
-			spin_unlock(&d->d_lock);
-		node = dentry->d_subdirs.next;
+		if (cft && cfe->type != cft)
+			continue;
+
+		dget(d);
+		d_delete(d);
+		simple_unlink(d->d_inode, d);
+		list_del_init(&cfe->node);
+		dput(d);
+
+		return 0;
 	}
-	spin_unlock(&dentry->d_lock);
+	return -ENOENT;
+}
+
+static void cgroup_clear_directory(struct dentry *dir)
+{
+	struct cgroup *cgrp = __d_cgrp(dir);
+
+	while (!list_empty(&cgrp->files))
+		cgroup_rm_file(cgrp, NULL);
 }
 
 /*
@@ -1362,6 +1384,7 @@ static void init_cgroup_housekeeping(str
 {
 	INIT_LIST_HEAD(&cgrp->sibling);
 	INIT_LIST_HEAD(&cgrp->children);
+	INIT_LIST_HEAD(&cgrp->files);
 	INIT_LIST_HEAD(&cgrp->css_sets);
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
@@ -2633,7 +2656,9 @@ static int cgroup_add_file(struct cgroup
 			   const struct cftype *cft)
 {
 	struct dentry *dir = cgrp->dentry;
+	struct cgroup *parent = __d_cgrp(dir);
 	struct dentry *dentry;
+	struct cfent *cfe;
 	int error;
 	umode_t mode;
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
@@ -2649,17 +2674,31 @@ static int cgroup_add_file(struct cgroup
 		strcat(name, ".");
 	}
 	strcat(name, cft->name);
+
 	BUG_ON(!mutex_is_locked(&dir->d_inode->i_mutex));
+
+	cfe = kzalloc(sizeof(*cfe), GFP_KERNEL);
+	if (!cfe)
+		return -ENOMEM;
+
 	dentry = lookup_one_len(name, dir, strlen(name));
-	if (!IS_ERR(dentry)) {
-		mode = cgroup_file_mode(cft);
-		error = cgroup_create_file(dentry, mode | S_IFREG,
-						cgrp->root->sb);
-		if (!error)
-			dentry->d_fsdata = (void *)cft;
-		dput(dentry);
-	} else
+	if (IS_ERR(dentry)) {
 		error = PTR_ERR(dentry);
+		goto out;
+	}
+
+	mode = cgroup_file_mode(cft);
+	error = cgroup_create_file(dentry, mode | S_IFREG, cgrp->root->sb);
+	if (!error) {
+		cfe->type = (void *)cft;
+		cfe->dentry = dentry;
+		dentry->d_fsdata = cfe;
+		list_add_tail(&cfe->node, &parent->files);
+		cfe = NULL;
+	}
+	dput(dentry);
+out:
+	kfree(cfe);
 	return error;
 }
 
