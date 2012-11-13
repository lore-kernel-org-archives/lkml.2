Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2KMDGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:06:11 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46691 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2KMDCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:02:15 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/17] cgroup: open-code cgroup_create_dir()
Date: Mon, 12 Nov 2012 19:01:30 -0800
Message-Id: <1352775704-9023-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352775704-9023-1-git-send-email-tj@kernel.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The operation order of cgroup creation is about to change and
cgroup_create_dir() is more of a hindrance than a proper abstraction.
Open-code it by moving the parent nlink adjustment next to self nlink
adjustment in cgroup_create_file() and the rest to cgroup_create().

This patch doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ed0e177..b042673 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2652,6 +2652,7 @@ static int cgroup_create_file(struct dentry *dentry, umode_t mode,
 
 		/* start off with i_nlink == 2 (for "." entry) */
 		inc_nlink(inode);
+		inc_nlink(dentry->d_parent->d_inode);
 
 		/* start with the directory inode held, so that we can
 		 * populate it without racing with another mkdir */
@@ -2666,30 +2667,6 @@ static int cgroup_create_file(struct dentry *dentry, umode_t mode,
 	return 0;
 }
 
-/*
- * cgroup_create_dir - create a directory for an object.
- * @cgrp: the cgroup we create the directory for. It must have a valid
- *        ->parent field. And we are going to fill its ->dentry field.
- * @dentry: dentry of the new cgroup
- * @mode: mode to set on new directory.
- */
-static int cgroup_create_dir(struct cgroup *cgrp, struct dentry *dentry,
-				umode_t mode)
-{
-	struct dentry *parent;
-	int error = 0;
-
-	parent = cgrp->parent->dentry;
-	error = cgroup_create_file(dentry, S_IFDIR | mode, cgrp->root->sb);
-	if (!error) {
-		dentry->d_fsdata = cgrp;
-		inc_nlink(parent->d_inode);
-		rcu_assign_pointer(cgrp->dentry, dentry);
-	}
-
-	return error;
-}
-
 /**
  * cgroup_file_mode - deduce file mode of a control file
  * @cft: the control file in question
@@ -4138,10 +4115,13 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
 	root->number_of_cgroups++;
 
-	err = cgroup_create_dir(cgrp, dentry, mode);
+	err = cgroup_create_file(dentry, S_IFDIR | mode, sb);
 	if (err < 0)
 		goto err_remove;
 
+	dentry->d_fsdata = cgrp;
+	rcu_assign_pointer(cgrp->dentry, dentry);
+
 	for_each_subsys(root, ss) {
 		/* each css holds a ref to the cgroup's dentry */
 		dget(dentry);
-- 
1.7.11.7

