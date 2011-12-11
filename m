Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1LKOuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 09:50:52 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:9913 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab1LKOus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 09:50:48 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: jbottomley@parallels.com, cgroups@vger.kernel.org, bsingharora@gmail.com,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 2/3] make clone_children a flag
Date: Sun, 11 Dec 2011 15:45:37 +0100
Message-Id: <1323614738-7405-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323614738-7405-1-git-send-email-glommer@parallels.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to have a flags field, and then a separate
bool field just to indicate if the clone_children flag is set.
Make it a flag

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/cgroup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e4b9d3c..fa405ee 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -231,6 +231,7 @@ inline int cgroup_is_removed(const struct cgroup *cgrp)
 /* bits in struct cgroupfs_root flags field */
 enum {
 	ROOT_NOPREFIX, /* mounted subsystems have no named prefix */
+	ROOT_CLONE_CHILDREN, /* mounted subsystems starts with clone_children */
 };
 
 static int cgroup_is_releasable(const struct cgroup *cgrp)
@@ -1062,7 +1063,6 @@ struct cgroup_sb_opts {
 	unsigned long subsys_bits;
 	unsigned long flags;
 	char *release_agent;
-	bool clone_children;
 	char *name;
 	/* User explicitly requested empty subsystem */
 	bool none;
@@ -1113,7 +1113,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			continue;
 		}
 		if (!strcmp(token, "clone_children")) {
-			opts->clone_children = true;
+			set_bit(ROOT_CLONE_CHILDREN, &opts->flags);
 			continue;
 		}
 		if (!strncmp(token, "release_agent=", 14)) {
@@ -1400,7 +1400,7 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
 		strcpy(root->release_agent_path, opts->release_agent);
 	if (opts->name)
 		strcpy(root->name, opts->name);
-	if (opts->clone_children)
+	if (test_bit(ROOT_CLONE_CHILDREN, &opts->flags))
 		set_bit(CGRP_CLONE_CHILDREN, &root->top_cgroup.flags);
 	return root;
 }
-- 
1.7.6.4

