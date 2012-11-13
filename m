Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab2KMDEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:04:06 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65334 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab2KMDCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:02:31 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/17] cgroup: separate out cgroup_destroy_locked()
Date: Mon, 12 Nov 2012 19:01:38 -0800
Message-Id: <1352775704-9023-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352775704-9023-1-git-send-email-tj@kernel.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out cgroup_destroy_locked() from cgroup_destroy().  This will
be later used in cgroup_create() failure path.

While at it, add lockdep asserts on i_mutex and cgroup_mutex, and move
@d and @parent assignments to their declarations.

This patch doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c5368c0..afc47d6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -242,6 +242,8 @@ static DEFINE_SPINLOCK(hierarchy_id_lock);
  */
 static int need_forkexit_callback __read_mostly;
 
+static int cgroup_destroy_locked(struct cgroup *cgrp);
+
 #ifdef CONFIG_PROVE_LOCKING
 int cgroup_lock_is_held(void)
 {
@@ -4209,22 +4211,20 @@ static int cgroup_has_css_refs(struct cgroup *cgrp)
 	return 0;
 }
 
-static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
+static int cgroup_destroy_locked(struct cgroup *cgrp)
+	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
-	struct cgroup *cgrp = dentry->d_fsdata;
-	struct dentry *d;
-	struct cgroup *parent;
+	struct dentry *d = cgrp->dentry;
+	struct cgroup *parent = cgrp->parent;
 	DEFINE_WAIT(wait);
 	struct cgroup_event *event, *tmp;
 	struct cgroup_subsys *ss;
 
-	/* the vfs holds both inode->i_mutex already */
-	mutex_lock(&cgroup_mutex);
-	parent = cgrp->parent;
-	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
-		mutex_unlock(&cgroup_mutex);
+	lockdep_assert_held(&d->d_inode->i_mutex);
+	lockdep_assert_held(&cgroup_mutex);
+
+	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children))
 		return -EBUSY;
-	}
 
 	/*
 	 * Block new css_tryget() by deactivating refcnt and mark @cgrp
@@ -4243,7 +4243,9 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	/*
 	 * Tell subsystems to initate destruction.  pre_destroy() should be
 	 * called with cgroup_mutex unlocked.  See 3fa59dfbc3 ("cgroup: fix
-	 * potential deadlock in pre_destroy") for details.
+	 * potential deadlock in pre_destroy") for details.  This temporary
+	 * unlocking should go away once cgroup_mutex is unexported from
+	 * controllers.
 	 */
 	mutex_unlock(&cgroup_mutex);
 	for_each_subsys(cgrp->root, ss)
@@ -4268,11 +4270,9 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 
 	/* delete this cgroup from parent->children */
 	list_del_rcu(&cgrp->sibling);
-
 	list_del_init(&cgrp->allcg_node);
 
-	d = dget(cgrp->dentry);
-
+	dget(d);
 	cgroup_d_remove_dir(d);
 	dput(d);
 
@@ -4293,10 +4293,20 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	}
 	spin_unlock(&cgrp->event_list_lock);
 
-	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
 
+static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
+{
+	int ret;
+
+	mutex_lock(&cgroup_mutex);
+	ret = cgroup_destroy_locked(dentry->d_fsdata);
+	mutex_unlock(&cgroup_mutex);
+
+	return ret;
+}
+
 static void __init_or_module cgroup_init_cftsets(struct cgroup_subsys *ss)
 {
 	INIT_LIST_HEAD(&ss->cftsets);
-- 
1.7.11.7

