Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353Ab2CUWSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:18:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65325 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab2CUWRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:17:54 -0400
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/12] cgroup: build list of all cgroups under a given cgroupfs_root
Date: Wed, 21 Mar 2012 15:17:35 -0700
Message-Id: <1332368265-21586-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332368265-21586-1-git-send-email-tj@kernel.org>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build a list of all cgroups anchored at cgroupfs_root->allcg_list and
going through cgroup->allcg_node.  The list is protected by
cgroup_mutex and will be used to improve cgroup file handling.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |    2 ++
 kernel/cgroup.c        |   10 ++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 501adb1..908f26f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -191,6 +191,8 @@ struct cgroup {
 	 */
 	struct list_head css_sets;
 
+	struct list_head allcg_node;	/* cgroupfs_root->allcg_list */
+
 	/*
 	 * Linked list running through all cgroups that can
 	 * potentially be reaped by the release agent. Protected by
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2e2f93b..fceee52 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -127,6 +127,9 @@ struct cgroupfs_root {
 	/* A list running through the active hierarchies */
 	struct list_head root_list;
 
+	/* All cgroups on this root, cgroup_mutex protected */
+	struct list_head allcg_list;
+
 	/* Hierarchy-specific flags */
 	unsigned long flags;
 
@@ -1350,11 +1353,14 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 static void init_cgroup_root(struct cgroupfs_root *root)
 {
 	struct cgroup *cgrp = &root->top_cgroup;
+
 	INIT_LIST_HEAD(&root->subsys_list);
 	INIT_LIST_HEAD(&root->root_list);
+	INIT_LIST_HEAD(&root->allcg_list);
 	root->number_of_cgroups = 1;
 	cgrp->root = root;
 	cgrp->top_cgroup = cgrp;
+	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
 	init_cgroup_housekeeping(cgrp);
 }
 
@@ -3794,6 +3800,8 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	/* The cgroup directory was pre-locked for us */
 	BUG_ON(!mutex_is_locked(&cgrp->dentry->d_inode->i_mutex));
 
+	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
+
 	err = cgroup_populate_dir(cgrp);
 	/* If err < 0, we have a half-filled directory - oh well ;) */
 
@@ -4002,6 +4010,8 @@ again:
 	list_del_init(&cgrp->sibling);
 	cgroup_unlock_hierarchy(cgrp->root);
 
+	list_del_init(&cgrp->allcg_node);
+
 	d = dget(cgrp->dentry);
 
 	cgroup_d_remove_dir(d);
-- 
1.7.7.3

