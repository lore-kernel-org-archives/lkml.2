Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945974Ab2CPXgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:36:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45251 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162072Ab2CPXgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:24 -0400
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] cgroup: remove cgroup_add_file[s]()
Date: Fri, 16 Mar 2012 16:36:00 -0700
Message-Id: <1331940963-15756-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331940963-15756-1-git-send-email-tj@kernel.org>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No controller is using cgroup_add_files[s]().  Unexport them, and
convert cgroup_add_files() to handle NULL entry terminated array
instead of taking count explicitly and continue creation on failure
for internal use.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |   16 ---------------
 kernel/cgroup.c        |   51 ++++++++++++++++++-----------------------------
 2 files changed, 20 insertions(+), 47 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a78a6a8..05ddf59 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -413,22 +413,6 @@ struct cgroup_scanner {
 	void *data;
 };
 
-/*
- * Add a new file to the given cgroup directory. Should only be
- * called by subsystems from within a populate() method
- */
-int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
-		       const struct cftype *cft);
-
-/*
- * Add a set of new files to the given cgroup directory. Should
- * only be called by subsystems from within a populate() method
- */
-int cgroup_add_files(struct cgroup *cgrp,
-			struct cgroup_subsys *subsys,
-			const struct cftype cft[],
-			int count);
-
 int cgroup_add_cftypes(struct cgroup_subsys *ss, const struct cftype *cfts);
 
 int cgroup_is_removed(const struct cgroup *cgrp);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 20fdff9..33383cb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2629,9 +2629,8 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 	return mode;
 }
 
-int cgroup_add_file(struct cgroup *cgrp,
-		       struct cgroup_subsys *subsys,
-		       const struct cftype *cft)
+static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
+			   const struct cftype *cft)
 {
 	struct dentry *dir = cgrp->dentry;
 	struct dentry *dentry;
@@ -2663,22 +2662,23 @@ int cgroup_add_file(struct cgroup *cgrp,
 		error = PTR_ERR(dentry);
 	return error;
 }
-EXPORT_SYMBOL_GPL(cgroup_add_file);
 
-int cgroup_add_files(struct cgroup *cgrp,
-			struct cgroup_subsys *subsys,
-			const struct cftype cft[],
-			int count)
+static int cgroup_add_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
+			    const struct cftype cfts[])
 {
-	int i, err;
-	for (i = 0; i < count; i++) {
-		err = cgroup_add_file(cgrp, subsys, &cft[i]);
-		if (err)
-			return err;
+	const struct cftype *cft;
+	int err, ret = 0;
+
+	for (cft = cfts; cft->name[0] != '\0'; cft++) {
+		err = cgroup_add_file(cgrp, subsys, cft);
+		if (err) {
+			pr_warning("cgroup_add_files: failed to create %s, err=%d\n",
+				   cft->name, err);
+			ret = err;
+		}
 	}
-	return 0;
+	return ret;
 }
-EXPORT_SYMBOL_GPL(cgroup_add_files);
 
 static DEFINE_MUTEX(cgroup_cft_mutex);
 
@@ -2702,10 +2702,6 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 {
 	LIST_HEAD(pending);
 	struct cgroup *cgrp, *n;
-	int count = 0;
-
-	while (cfts[count].name[0] != '\0')
-		count++;
 
 	/* %NULL @cfts indicates abort and don't bother if @ss isn't attached */
 	if (cfts && ss->root != &rootnode) {
@@ -2727,7 +2723,7 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
 		if (!cgroup_is_removed(cgrp))
-			cgroup_add_files(cgrp, ss, cfts, count);
+			cgroup_add_files(cgrp, ss, cfts);
 		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&inode->i_mutex);
 
@@ -3755,6 +3751,7 @@ static struct cftype files[] = {
 		.write_string = cgroup_release_agent_write,
 		.max_write_len = PATH_MAX,
 	},
+	{ }	/* terminate */
 };
 
 static int cgroup_populate_dir(struct cgroup *cgrp)
@@ -3762,7 +3759,7 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 	int err;
 	struct cgroup_subsys *ss;
 
-	err = cgroup_add_files(cgrp, NULL, files, ARRAY_SIZE(files));
+	err = cgroup_add_files(cgrp, NULL, files);
 	if (err < 0)
 		return err;
 
@@ -3773,16 +3770,8 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 		if (ss->populate && (err = ss->populate(ss, cgrp)) < 0)
 			return err;
 
-		list_for_each_entry(set, &ss->cftsets, node) {
-			const struct cftype *cft;
-
-			for (cft = set->cfts; cft->name[0] != '\0'; cft++) {
-				err = cgroup_add_file(cgrp, ss, cft);
-				if (err)
-					pr_warning("cgroup_populate_dir: failed to create %s, err=%d\n",
-						   cft->name, err);
-			}
-		}
+		list_for_each_entry(set, &ss->cftsets, node)
+			cgroup_add_files(cgrp, ss, set->cfts);
 	}
 
 	/* This cgroup is ready now */
-- 
1.7.7.3

