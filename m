Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562Ab2JaTqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 15:46:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36498 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760313Ab2JaTou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 15:44:50 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in cgroup_create()
Date: Wed, 31 Oct 2012 12:44:05 -0700
Message-Id: <1351712650-23709-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351712650-23709-1-git-send-email-tj@kernel.org>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes cgroup_create() fail if @parent is marked removed.
This is to prepare for further updates to cgroup_rmdir() path.

Note that this change isn't strictly necessary.  cgroup can only be
created via mkdir and the removed marking and dentry removal happen
without releasing cgroup_mutex, so cgroup_create() can never race with
cgroup_rmdir().  Even after the scheduled updates to cgroup_rmdir(),
cgroup_mkdir() and cgroup_rmdir() are synchronized by i_mutex
rendering the added liveliness check unnecessary.

Do it anyway such that locking is contained inside cgroup proper and
we don't get nasty surprises if we ever grow another caller of
cgroup_create().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/cgroup.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c194f9e..f22e3cd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3927,6 +3927,18 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	if (!cgrp)
 		return -ENOMEM;
 
+	/*
+	 * Only live parents can have children.  Note that the liveliness
+	 * check isn't strictly necessary because cgroup_mkdir() and
+	 * cgroup_rmdir() are fully synchronized by i_mutex; however, do it
+	 * anyway so that locking is contained inside cgroup proper and we
+	 * don't get nasty surprises if we ever grow another caller.
+	 */
+	if (!cgroup_lock_live_group(parent)) {
+		err = -ENODEV;
+		goto err_free;
+	}
+
 	/* Grab a reference on the superblock so the hierarchy doesn't
 	 * get deleted on unmount if there are child cgroups.  This
 	 * can be done outside cgroup_mutex, since the sb can't
@@ -3934,8 +3946,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	 * fs */
 	atomic_inc(&sb->s_active);
 
-	mutex_lock(&cgroup_mutex);
-
 	init_cgroup_housekeeping(cgrp);
 
 	cgrp->parent = parent;
@@ -4006,7 +4016,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	/* Release the reference count that we took on the superblock */
 	deactivate_super(sb);
-
+err_free:
 	kfree(cgrp);
 	return err;
 }
-- 
1.7.11.7

