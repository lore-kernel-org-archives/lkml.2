Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab1I3MFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:05:43 -0400
Received: from mx.kernel.net.pl ([217.73.31.3]:37134 "EHLO an2.kernel.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758466Ab1I3MFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:05:39 -0400
From: Witold Krecicki <wpk@culm.net>
To: Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Witold Krecicki <wpk@culm.net>
Subject: [PATCH 1/6] cgroup: add cgroup.isolation_root flag entry to the cgroup filesystem
Date: Fri, 30 Sep 2011 13:36:20 +0200
Message-Id: <1317382585-12172-2-git-send-email-wpk@culm.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317382585-12172-1-git-send-email-wpk@culm.net>
References: <1317382585-12172-1-git-send-email-wpk@culm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds cgroup.isolation_root flag to cgroups.

Signed-off-by: Witold Krecicki <wpk@culm.net>
---
 include/linux/cgroup.h |    4 +++
 kernel/cgroup.c        |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index da7e4bc..ee51f79 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -158,6 +158,10 @@ enum {
 	 * Clone cgroup values when creating a new child cgroup
 	 */
 	CGRP_CLONE_CHILDREN,
+	/*
+	 * CGroup is an isolation root
+	 */
+	CGRP_ISOLATION_ROOT,
 };
 
 /* which pidlist file are we talking about? */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1d2b6ce..a4d002c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -251,6 +251,11 @@ static int clone_children(const struct cgroup *cgrp)
 	return test_bit(CGRP_CLONE_CHILDREN, &cgrp->flags);
 }
 
+static int isolation_root(const struct cgroup *cgrp)
+{
+	return test_bit(CGRP_ISOLATION_ROOT, &cgrp->flags);
+}
+
 /*
  * for_each_subsys() allows you to iterate on each subsystem attached to
  * an active hierarchy
@@ -394,6 +399,24 @@ static inline void put_css_set_taskexit(struct css_set *cg)
 }
 
 /*
+ * cgroup_get_isolation_root - gets the isolation root for cgroup
+ * @cgrp: cgroup for which we're looking for isolation root
+ *
+ * Returns isolated root cgroup or NULL if there's no isolation root
+ */
+static struct cgroup *cgroup_get_isolation_root(struct cgroup *cgrp)
+{
+	for (;;) {
+		if (!cgrp)
+			return NULL;
+		if (isolation_root(cgrp))
+			return cgrp;
+		cgrp = cgrp->parent;
+	}
+	return NULL;
+}
+
+/*
  * compare_css_sets - helper function for find_existing_css_set().
  * @cg: candidate css_set being tested
  * @old_cg: existing css_set for a task
@@ -3620,6 +3643,28 @@ static int cgroup_clone_children_write(struct cgroup *cgrp,
 	return 0;
 }
 
+
+static u64 cgroup_isolation_root_read(struct cgroup *cgrp,
+				    struct cftype *cft)
+{
+	return isolation_root(cgrp);
+}
+
+static int cgroup_isolation_root_write(struct cgroup *cgrp,
+				     struct cftype *cft,
+				     u64 val)
+{
+	if (cgrp->parent == NULL)
+		return -EBUSY;
+	if (atomic_read(&cgrp->count))
+		return -EBUSY;
+	if (val)
+		set_bit(CGRP_ISOLATION_ROOT, &cgrp->flags);
+	else
+		clear_bit(CGRP_ISOLATION_ROOT, &cgrp->flags);
+	return 0;
+}
+
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -3655,6 +3700,11 @@ static struct cftype files[] = {
 		.read_u64 = cgroup_clone_children_read,
 		.write_u64 = cgroup_clone_children_write,
 	},
+	{
+		.name = "cgroup.isolation_root",
+		.read_u64 = cgroup_isolation_root_read,
+		.write_u64 = cgroup_isolation_root_write,
+	},
 };
 
 static struct cftype cft_release_agent = {
-- 
1.7.4.1

