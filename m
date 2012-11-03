Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2KCIjL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 04:39:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33714 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2KCIi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 04:38:58 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 1/9] cgroup: add cgroup_subsys->post_create()
Date: Sat,  3 Nov 2012 01:38:27 -0700
Message-Id: <1351931915-1701-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351931915-1701-1-git-send-email-tj@kernel.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there's no way for a controller to find out whether a new
cgroup finished all ->create() allocatinos successfully and is
considered "live" by cgroup.

This becomes a problem later when we add generic descendants walking
to cgroup which can be used by controllers as controllers don't have a
synchronization point where it can synchronize against new cgroups
appearing in such walks.

This patch adds ->post_create().  It's called after all ->create()
succeeded and the cgroup is linked into the generic cgroup hierarchy.
This plays the counterpart of ->pre_destroy().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index fe876a7..b442122 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -438,6 +438,7 @@ int cgroup_taskset_size(struct cgroup_taskset *tset);
 
 struct cgroup_subsys {
 	struct cgroup_subsys_state *(*create)(struct cgroup *cgrp);
+	void (*post_create)(struct cgroup *cgrp);
 	void (*pre_destroy)(struct cgroup *cgrp);
 	void (*destroy)(struct cgroup *cgrp);
 	int (*can_attach)(struct cgroup *cgrp, struct cgroup_taskset *tset);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e3045ad..f05d992 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4060,10 +4060,15 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	if (err < 0)
 		goto err_remove;
 
-	/* each css holds a ref to the cgroup's dentry */
-	for_each_subsys(root, ss)
+	for_each_subsys(root, ss) {
+		/* each css holds a ref to the cgroup's dentry */
 		dget(dentry);
 
+		/* creation succeeded, notify subsystems */
+		if (ss->post_create)
+			ss->post_create(cgrp);
+	}
+
 	/* The cgroup directory was pre-locked for us */
 	BUG_ON(!mutex_is_locked(&cgrp->dentry->d_inode->i_mutex));
 
@@ -4281,6 +4286,9 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 
 	ss->active = 1;
 
+	if (ss->post_create)
+		ss->post_create(&ss->root->top_cgroup);
+
 	/* this function shouldn't be used with modular subsystems, since they
 	 * need to register a subsys_id, among other things */
 	BUG_ON(ss->module);
-- 
1.7.11.7

