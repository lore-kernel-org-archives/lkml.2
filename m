Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161229Ab2KNTsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:48:42 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:51254 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab2KNTsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:48:40 -0500
Date: Wed, 14 Nov 2012 11:48:35 -0800
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com
Subject: [PATCH v2 04/17] cgroup: create directory before linking while
 creating a new cgroup
Message-ID: <20121114194835.GJ21185@mtj.dyndns.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
 <1352775704-9023-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352775704-9023-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While creating a new cgroup, cgroup_create() links the newly allocated
cgroup into various places before trying to create its directory.
Because cgroup life-cycle is tied to the vfs objects, this makes it
impossible to use cgroup_rmdir() for rolling back creation - the
removal logic depends on having full vfs objects.

This patch moves directory creation above linking and collect linking
operations to one place.  This allows directory creation failure to
share error exit path with css allocation failures and any failure
sites afterwards (to be added later) can use cgroup_rmdir() logic to
undo creation.

Note that this also makes the memory barriers around cgroup->dentry,
which currently is misleadingly using RCU operations, unnecessary.
This will be handled in the next patch.

While at it, locking BUG_ON() on i_mutex is converted to
lockdep_assert_held().

v2: Patch originally removed %NULL dentry check in cgroup_path();
    however, Li pointed out that this patch doesn't make it
    unnecessary as ->create() may call cgroup_path().  Drop the
    change for now.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4112,15 +4112,22 @@ static long cgroup_create(struct cgroup
 		}
 	}
 
-	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
-	root->number_of_cgroups++;
-
+	/*
+	 * Create directory.  cgroup_create_file() returns with the new
+	 * directory locked on success so that it can be populated without
+	 * dropping cgroup_mutex.
+	 */
 	err = cgroup_create_file(dentry, S_IFDIR | mode, sb);
 	if (err < 0)
-		goto err_remove;
+		goto err_destroy;
+	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
+	/* allocation complete, commit to creation */
 	dentry->d_fsdata = cgrp;
 	rcu_assign_pointer(cgrp->dentry, dentry);
+	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
+	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
+	root->number_of_cgroups++;
 
 	for_each_subsys(root, ss) {
 		/* each css holds a ref to the cgroup's dentry */
@@ -4131,11 +4138,6 @@ static long cgroup_create(struct cgroup
 			ss->post_create(cgrp);
 	}
 
-	/* The cgroup directory was pre-locked for us */
-	BUG_ON(!mutex_is_locked(&cgrp->dentry->d_inode->i_mutex));
-
-	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
-
 	err = cgroup_populate_dir(cgrp, true, root->subsys_mask);
 	/* If err < 0, we have a half-filled directory - oh well ;) */
 
@@ -4144,20 +4146,12 @@ static long cgroup_create(struct cgroup
 
 	return 0;
 
- err_remove:
-
-	list_del_rcu(&cgrp->sibling);
-	root->number_of_cgroups--;
-
- err_destroy:
-
+err_destroy:
 	for_each_subsys(root, ss) {
 		if (cgrp->subsys[ss->subsys_id])
 			ss->destroy(cgrp);
 	}
-
 	mutex_unlock(&cgroup_mutex);
-
 	/* Release the reference count that we took on the superblock */
 	deactivate_super(sb);
 err_free:
