Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2KQDbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:31:14 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37838 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab2KQDbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:31:11 -0500
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] netcls_cgroup: introduce netcls_mutex
Date: Fri, 16 Nov 2012 19:31:00 -0800
Message-Id: <1353123062-23193-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353123062-23193-1-git-send-email-tj@kernel.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce netcls_mutex to synchronize modifications to
cgroup_cls_state.  New cgrp now inherits classid from ->css_online()
and write_classid() updates classid while holdin netcls_mutex.

As write_classid() doesn't propagate new configuration downwards, this
currently doesn't make any userland-visible difference, but will help
implementing proper hierarchy support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 net/sched/cls_cgroup.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 8cdc18e..80a80c4 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -17,11 +17,14 @@
 #include <linux/skbuff.h>
 #include <linux/cgroup.h>
 #include <linux/rcupdate.h>
+#include <linux/mutex.h>
 #include <net/rtnetlink.h>
 #include <net/pkt_cls.h>
 #include <net/sock.h>
 #include <net/cls_cgroup.h>
 
+static DEFINE_MUTEX(netcls_mutex);
+
 static inline struct cgroup_cls_state *cgrp_cls_state(struct cgroup *cgrp)
 {
 	return container_of(cgroup_subsys_state(cgrp, net_cls_subsys_id),
@@ -42,12 +45,21 @@ static struct cgroup_subsys_state *cgrp_css_alloc(struct cgroup *cgrp)
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
 
-	if (cgrp->parent)
-		cs->classid = cgrp_cls_state(cgrp->parent)->classid;
-
 	return &cs->css;
 }
 
+/* @cgrp coming online, inherit the parent's classid */
+static int cgrp_css_online(struct cgroup *cgrp)
+{
+	if (!cgrp->parent)
+		return 0;
+
+	mutex_lock(&netcls_mutex);
+	cgrp_cls_state(cgrp)->classid = cgrp_cls_state(cgrp->parent)->classid;
+	mutex_unlock(&netcls_mutex);
+	return 0;
+}
+
 static void cgrp_css_free(struct cgroup *cgrp)
 {
 	kfree(cgrp_cls_state(cgrp));
@@ -60,7 +72,9 @@ static u64 read_classid(struct cgroup *cgrp, struct cftype *cft)
 
 static int write_classid(struct cgroup *cgrp, struct cftype *cft, u64 value)
 {
+	mutex_lock(&netcls_mutex);
 	cgrp_cls_state(cgrp)->classid = (u32) value;
+	mutex_unlock(&netcls_mutex);
 	return 0;
 }
 
@@ -76,6 +90,7 @@ static struct cftype ss_files[] = {
 struct cgroup_subsys net_cls_subsys = {
 	.name		= "net_cls",
 	.css_alloc	= cgrp_css_alloc,
+	.css_online	= cgrp_css_online,
 	.css_free	= cgrp_css_free,
 	.subsys_id	= net_cls_subsys_id,
 	.base_cftypes	= ss_files,
-- 
1.7.11.7

