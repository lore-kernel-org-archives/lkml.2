Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0JVIKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:10:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab0JVIKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:10:47 -0400
Message-ID: <4CC1473D.9070201@cn.fujitsu.com>
Date: Fri, 22 Oct 2010 16:11:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "akpm >> Andrew Morton" <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com
Subject: [PATCH 5/7] cgroups: Make freezer subsystem bindable
References: <4CC146A4.9090505@cn.fujitsu.com>
In-Reply-To: <4CC146A4.9090505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make it bindable, we need to thaw all processes when unbinding
the freezer subsystem from a cgroup hierarchy.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h  |    3 ++-
 kernel/cgroup.c         |   22 ++++++++++++++++++++--
 kernel/cgroup_freezer.c |   19 +++++++++++++++++--
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 49369ff..1e4e1df 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -478,7 +478,8 @@ struct cgroup_subsys {
 	int (*populate)(struct cgroup_subsys *ss,
 			struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
-	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
+	void (*bind)(struct cgroup_subsys *ss, struct cgroup *cgrp,
+		     bool unbind);
 
 	int subsys_id;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6364bb5..12c1f7c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1105,6 +1105,22 @@ static int hierarchy_populate_dir(struct cgroup *cgrp, void *data)
 	return 0;
 }
 
+static int hierarchy_subsys_bind(struct cgroup *cgrp, void *data)
+{
+	struct cgroup_subsys *ss = data;
+
+	ss->bind(ss, cgrp, false);
+	return 0;
+}
+
+static int hierarchy_subsys_unbind(struct cgroup *cgrp, void *data)
+{
+	struct cgroup_subsys *ss = data;;
+
+	ss->bind(ss, cgrp, true);
+	return 0;
+}
+
 /*
  * Call with cgroup_mutex held. Drops reference counts on modules, including
  * any duplicate ones that parse_cgroupfs_options took. If this function
@@ -1172,7 +1188,8 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			list_move(&ss->sibling, &root->subsys_list);
 			ss->root = root;
 			if (ss->bind)
-				ss->bind(ss, cgrp);
+				cgroup_walk_hierarchy(hierarchy_subsys_bind,
+						      ss, cgrp);
 			mutex_unlock(&ss->hierarchy_mutex);
 			/* refcount was already taken, and we're keeping it */
 		} else if (bit & removed_bits) {
@@ -1180,7 +1197,8 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			BUG_ON(ss == NULL);
 			mutex_lock(&ss->hierarchy_mutex);
 			if (ss->bind)
-				ss->bind(ss, dummytop);
+				cgroup_walk_hierarchy(hierarchy_subsys_unbind,
+						      ss, cgrp);
 			subsys[i]->root = &rootnode;
 			list_move(&ss->sibling, &rootnode.subsys_list);
 			mutex_unlock(&ss->hierarchy_mutex);
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index e7bebb7..de13ce4 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -383,6 +383,21 @@ static int freezer_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
 	return cgroup_add_files(cgroup, ss, files, ARRAY_SIZE(files));
 }
 
+/*
+ * Thaw all processes before unbinding the freezer subsysem from
+ * cgroup hierarchy.
+ * */
+static void freezer_bind(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			 bool unbind)
+{
+	struct freezer *freezer = cgroup_freezer(cgrp);
+
+	if (!unbind)
+		return;
+
+	unfreeze_cgroup(cgrp, freezer);
+}
+
 struct cgroup_subsys freezer_subsys = {
 	.name		= "freezer",
 	.create		= freezer_create,
@@ -390,7 +405,7 @@ struct cgroup_subsys freezer_subsys = {
 	.populate	= freezer_populate,
 	.subsys_id	= freezer_subsys_id,
 	.can_attach	= freezer_can_attach,
-	.attach		= NULL,
 	.fork		= freezer_fork,
-	.exit		= NULL,
+	.bind		= freezer_bind,
+	.can_bind	= 1,
 };
-- 
1.7.0.1

