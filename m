Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2KPTUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:20:35 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33865 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2KPTUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:20:33 -0500
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, srivatsa.bhat@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] cgroup: add cgroup->id
Date: Fri, 16 Nov 2012 11:20:17 -0800
Message-Id: <1353093624-22608-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353093624-22608-1-git-send-email-tj@kernel.org>
References: <1353093624-22608-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of generic cgroup hierarchy iterators, css_id is
being phased out.  It was unnecessarily complex, id'ing the wrong
thing (cgroups need IDs, not CSSes) and has other oddities like not
being available at ->css_alloc().

This patch adds cgroup->id, which is a simple per-hierarchy
ida-allocated ID which is assigned before ->css_alloc() and released
after ->css_free().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  2 ++
 kernel/cgroup.c        | 15 ++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d5fc8a7..b512469 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -159,6 +159,8 @@ struct cgroup {
 	 */
 	atomic_t count;
 
+	int id;				/* ida allocated in-hierarchy ID */
+
 	/*
 	 * We link our 'sibling' struct into our parent's 'children'.
 	 * Our children link their 'sibling' into our 'children'.
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 99d5e69..0b25dcb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -138,6 +138,9 @@ struct cgroupfs_root {
 	/* Hierarchy-specific flags */
 	unsigned long flags;
 
+	/* IDs for cgroups in this hierarchy */
+	struct ida cgroup_ida;
+
 	/* The path to use for release notifications. */
 	char release_agent_path[PATH_MAX];
 
@@ -890,6 +893,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 
 		simple_xattrs_free(&cgrp->xattrs);
 
+		ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
 		kfree(cgrp);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
@@ -1465,6 +1469,7 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
 
 	root->subsys_mask = opts->subsys_mask;
 	root->flags = opts->flags;
+	ida_init(&root->cgroup_ida);
 	if (opts->release_agent)
 		strcpy(root->release_agent_path, opts->release_agent);
 	if (opts->name)
@@ -1483,6 +1488,7 @@ static void cgroup_drop_root(struct cgroupfs_root *root)
 	spin_lock(&hierarchy_id_lock);
 	ida_remove(&hierarchy_ida, root->hierarchy_id);
 	spin_unlock(&hierarchy_id_lock);
+	ida_destroy(&root->cgroup_ida);
 	kfree(root);
 }
 
@@ -4093,10 +4099,15 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	struct cgroup_subsys *ss;
 	struct super_block *sb = root->sb;
 
+	/* allocate the cgroup and its ID, 0 is reserved for the root */
 	cgrp = kzalloc(sizeof(*cgrp), GFP_KERNEL);
 	if (!cgrp)
 		return -ENOMEM;
 
+	cgrp->id = ida_simple_get(&root->cgroup_ida, 1, 0, GFP_KERNEL);
+	if (cgrp->id < 0)
+		goto err_free_cgrp;
+
 	/*
 	 * Only live parents can have children.  Note that the liveliness
 	 * check isn't strictly necessary because cgroup_mkdir() and
@@ -4106,7 +4117,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	 */
 	if (!cgroup_lock_live_group(parent)) {
 		err = -ENODEV;
-		goto err_free_cgrp;
+		goto err_free_id;
 	}
 
 	/* Grab a reference on the superblock so the hierarchy doesn't
@@ -4198,6 +4209,8 @@ err_free_all:
 	mutex_unlock(&cgroup_mutex);
 	/* Release the reference count that we took on the superblock */
 	deactivate_super(sb);
+err_free_id:
+	ida_simple_remove(&root->cgroup_ida, cgrp->id);
 err_free_cgrp:
 	kfree(cgrp);
 	return err;
-- 
1.7.11.7

