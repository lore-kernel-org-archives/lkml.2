Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab2KTIa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:30:28 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46901 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2KTIaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:30:25 -0500
From: Tejun Heo <tj@kernel.org>
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] netcls_cgroup: move config inheritance to ->css_online() and remove .broken_hierarchy marking
Date: Tue, 20 Nov 2012 00:30:05 -0800
Message-Id: <1353400211-5182-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353400211-5182-1-git-send-email-tj@kernel.org>
References: <1353400211-5182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that we'll have to live with attributes which are
inherited at cgroup creation time but not affected by further updates
to the parent afterwards - such attributes are already in wide use
e.g. for cpuset.

So, there's nothing to do for netcls_cgroup for hierarchy support.
Its current behavior - inherit only during creation - is good enough.

Move config inheriting from ->css_alloc() to ->css_online() for
consistency, which doesn't change behavior at all, and remove
.broken_hierarchy marking.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 net/sched/cls_cgroup.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 8cdc18e..31f06b6 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -41,11 +41,15 @@ static struct cgroup_subsys_state *cgrp_css_alloc(struct cgroup *cgrp)
 	cs = kzalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
+	return &cs->css;
+}
 
+static int cgrp_css_online(struct cgroup *cgrp)
+{
 	if (cgrp->parent)
-		cs->classid = cgrp_cls_state(cgrp->parent)->classid;
-
-	return &cs->css;
+		cgrp_cls_state(cgrp)->classid =
+			cgrp_cls_state(cgrp->parent)->classid;
+	return 0;
 }
 
 static void cgrp_css_free(struct cgroup *cgrp)
@@ -76,19 +80,11 @@ static struct cftype ss_files[] = {
 struct cgroup_subsys net_cls_subsys = {
 	.name		= "net_cls",
 	.css_alloc	= cgrp_css_alloc,
+	.css_online	= cgrp_css_online,
 	.css_free	= cgrp_css_free,
 	.subsys_id	= net_cls_subsys_id,
 	.base_cftypes	= ss_files,
 	.module		= THIS_MODULE,
-
-	/*
-	 * While net_cls cgroup has the rudimentary hierarchy support of
-	 * inheriting the parent's classid on cgroup creation, it doesn't
-	 * properly propagates config changes in ancestors to their
-	 * descendents.  A child should follow the parent's configuration
-	 * but be allowed to override it.  Fix it and remove the following.
-	 */
-	.broken_hierarchy = true,
 };
 
 struct cls_cgroup_head {
-- 
1.7.11.7

