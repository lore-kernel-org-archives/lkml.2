Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2K1Sd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:33:59 -0500
Received: from mail-we0-f202.google.com ([74.125.82.202]:33026 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2K1Sd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:33:57 -0500
From: Greg Thelen <gthelen@google.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] cgroup: avoid creating degenerate allcg_list
Date: Wed, 28 Nov 2012 10:26:32 -0800
Message-Id: <1354127192-22153-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch init_cgroup_root() created a degenerate list by
first inserting a element into allcg_list and then initializing the
inserted list element.  The initialization reset the element's
prev/next fields forming a degenerate list where allcg_list pointed to
element, but element pointed to itself.  This problem was introduced
in 2243076ad128 "cgroup: initialize cgrp->allcg_node in
init_cgroup_housekeeping()".  CONFIG_DEBUG_LIST reported a list_add
corruption in cgroup_mkdir() running next-20121127 (ce2931a).

This patch fixes the problem by performing element initialization
before insertion.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 01d5342..ece60d4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1394,6 +1394,7 @@ static void init_cgroup_root(struct cgroupfs_root *root)
 {
 	struct cgroup *cgrp = &root->top_cgroup;
 
+	init_cgroup_housekeeping(cgrp);
 	INIT_LIST_HEAD(&root->subsys_list);
 	INIT_LIST_HEAD(&root->root_list);
 	INIT_LIST_HEAD(&root->allcg_list);
@@ -1401,7 +1402,6 @@ static void init_cgroup_root(struct cgroupfs_root *root)
 	cgrp->root = root;
 	cgrp->top_cgroup = cgrp;
 	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
-	init_cgroup_housekeeping(cgrp);
 }
 
 static bool init_root_id(struct cgroupfs_root *root)
-- 
1.7.7.3

