Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2KMDCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:02:30 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36312 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab2KMDCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:02:21 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/17] cgroup: remove duplicate RCU free on struct cgroup
Date: Mon, 12 Nov 2012 19:01:33 -0800
Message-Id: <1352775704-9023-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352775704-9023-1-git-send-email-tj@kernel.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct cgroup is made RCU-safe by synchronize_rcu() in cgroup_diput().
There is no reason to use RCU safe kfree on it after it.  Remove
cgroup->rcu_head and use kfree() instead of kfree_rcu() in
cgroup_diput().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 3 ---
 kernel/cgroup.c        | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d605857..9dcbfa1 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -196,9 +196,6 @@ struct cgroup {
 	struct list_head pidlists;
 	struct mutex pidlist_mutex;
 
-	/* For RCU-protected deletion */
-	struct rcu_head rcu_head;
-
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 278752e..a91e7ad 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -893,7 +893,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 
 		simple_xattrs_free(&cgrp->xattrs);
 
-		kfree_rcu(cgrp, rcu_head);
+		kfree(cgrp);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
 		struct cgroup *cgrp = dentry->d_parent->d_fsdata;
-- 
1.7.11.7

