Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965130Ab2CUWTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:19:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42808 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964971Ab2CUWSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:18:14 -0400
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/12] cgroup: implement cgroup_rm_cftypes()
Date: Wed, 21 Mar 2012 15:17:45 -0700
Message-Id: <1332368265-21586-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332368265-21586-1-git-send-email-tj@kernel.org>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement cgroup_rm_cftypes() which removes an array of cftypes from a
subsystem.  It can be called whether the target subsys is attached or
not.  cgroup core will remove the specified file from all existing
cgroups.

This will be used to improve sub-subsys modularity and will be helpful
for unified hierarchy.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |   54 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index bfe5470..7e523e2 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -406,6 +406,7 @@ struct cgroup_scanner {
 };
 
 int cgroup_add_cftypes(struct cgroup_subsys *ss, const struct cftype *cfts);
+int cgroup_rm_cftypes(struct cgroup_subsys *ss, const struct cftype *cfts);
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 67daea9..e87c4c4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2692,17 +2692,20 @@ out:
 	return error;
 }
 
-static int cgroup_add_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
-			    const struct cftype cfts[])
+static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
+			      const struct cftype cfts[], bool is_add)
 {
 	const struct cftype *cft;
 	int err, ret = 0;
 
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
-		err = cgroup_add_file(cgrp, subsys, cft);
+		if (is_add)
+			err = cgroup_add_file(cgrp, subsys, cft);
+		else
+			err = cgroup_rm_file(cgrp, cft);
 		if (err) {
-			pr_warning("cgroup_add_files: failed to create %s, err=%d\n",
-				   cft->name, err);
+			pr_warning("cgroup_addrm_files: failed to %s %s, err=%d\n",
+				   is_add ? "add" : "remove", cft->name, err);
 			ret = err;
 		}
 	}
@@ -2726,7 +2729,7 @@ static void cgroup_cfts_prepare(void)
 }
 
 static void cgroup_cfts_commit(struct cgroup_subsys *ss,
-			       const struct cftype *cfts)
+			       const struct cftype *cfts, bool is_add)
 	__releases(&cgroup_mutex) __releases(&cgroup_cft_mutex)
 {
 	LIST_HEAD(pending);
@@ -2752,7 +2755,7 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
 		if (!cgroup_is_removed(cgrp))
-			cgroup_add_files(cgrp, ss, cfts);
+			cgroup_addrm_files(cgrp, ss, cfts, is_add);
 		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&inode->i_mutex);
 
@@ -2788,13 +2791,44 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, const struct cftype *cfts)
 	cgroup_cfts_prepare();
 	set->cfts = cfts;
 	list_add_tail(&set->node, &ss->cftsets);
-	cgroup_cfts_commit(ss, cfts);
+	cgroup_cfts_commit(ss, cfts, true);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cgroup_add_cftypes);
 
 /**
+ * cgroup_rm_cftypes - remove an array of cftypes from a subsystem
+ * @ss: target cgroup subsystem
+ * @cfts: zero-length name terminated array of cftypes
+ *
+ * Unregister @cfts from @ss.  Files described by @cfts are removed from
+ * all existing cgroups to which @ss is attached and all future cgroups
+ * won't have them either.  This function can be called anytime whether @ss
+ * is attached or not.
+ *
+ * Returns 0 on successful unregistration, -ENOENT if @cfts is not
+ * registered with @ss.
+ */
+int cgroup_rm_cftypes(struct cgroup_subsys *ss, const struct cftype *cfts)
+{
+	struct cftype_set *set;
+
+	cgroup_cfts_prepare();
+
+	list_for_each_entry(set, &ss->cftsets, node) {
+		if (set->cfts == cfts) {
+			list_del_init(&set->node);
+			cgroup_cfts_commit(ss, cfts, false);
+			return 0;
+		}
+	}
+
+	cgroup_cfts_commit(ss, NULL, false);
+	return -ENOENT;
+}
+
+/**
  * cgroup_task_count - count the number of tasks in a cgroup.
  * @cgrp: the cgroup in question
  *
@@ -3786,7 +3820,7 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 	int err;
 	struct cgroup_subsys *ss;
 
-	err = cgroup_add_files(cgrp, NULL, files);
+	err = cgroup_addrm_files(cgrp, NULL, files, true);
 	if (err < 0)
 		return err;
 
@@ -3798,7 +3832,7 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 			return err;
 
 		list_for_each_entry(set, &ss->cftsets, node)
-			cgroup_add_files(cgrp, ss, set->cfts);
+			cgroup_addrm_files(cgrp, ss, set->cfts, true);
 	}
 
 	/* This cgroup is ready now */
-- 
1.7.7.3

