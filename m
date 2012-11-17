Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2KQDbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:31:40 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47794 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2KQDbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:31:13 -0500
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] netcls_cgroup: introduce cgroup_cls_state->is_local
Date: Fri, 16 Nov 2012 19:31:01 -0800
Message-Id: <1353123062-23193-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353123062-23193-1-git-send-email-tj@kernel.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cs->is_local will be used to indicate whether the cgroup has its own
configuration or inherited from the parent.  It's set when classid is
configured by writing a positive value to cgroup file
"net_cls.classid" and cleared when a negative value is written.

is_local is visible to userland via cgroup file "net_cls.is_local" so
that userland can know whether a cgroup has its config or not.

This patch doesn't yet change hierarchy behavior.  The next patch will
use is_local to implement proper hierarchy.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/net/cls_cgroup.h |  1 +
 net/sched/cls_cgroup.c   | 23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index b6a6eeb..5759d98 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -22,6 +22,7 @@ struct cgroup_cls_state
 {
 	struct cgroup_subsys_state css;
 	u32 classid;
+	bool is_local;	/* class id is explicitly configured for this cgroup */
 };
 
 extern void sock_update_classid(struct sock *sk);
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 80a80c4..6e3ef64 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -70,19 +70,36 @@ static u64 read_classid(struct cgroup *cgrp, struct cftype *cft)
 	return cgrp_cls_state(cgrp)->classid;
 }
 
-static int write_classid(struct cgroup *cgrp, struct cftype *cft, u64 value)
+static int write_classid(struct cgroup *cgrp, struct cftype *cft,
+			 const char *buf)
 {
+	struct cgroup_cls_state *cs = cgrp_cls_state(cgrp);
+	s64 v;
+
+	if (sscanf(buf, "%lld", &v) != 1)
+		return -EINVAL;
+
 	mutex_lock(&netcls_mutex);
-	cgrp_cls_state(cgrp)->classid = (u32) value;
+	cs->classid = clamp_val(v, 0, UINT_MAX);
+	cs->is_local = v >= 0;
 	mutex_unlock(&netcls_mutex);
 	return 0;
 }
 
+static u64 read_is_local(struct cgroup *cgrp, struct cftype *cft)
+{
+	return cgrp_cls_state(cgrp)->is_local;
+}
+
 static struct cftype ss_files[] = {
 	{
 		.name = "classid",
 		.read_u64 = read_classid,
-		.write_u64 = write_classid,
+		.write_string = write_classid,
+	},
+	{
+		.name = "is_local",
+		.read_u64 = read_is_local,
 	},
 	{ }	/* terminate */
 };
-- 
1.7.11.7

