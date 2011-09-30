Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab1I3MFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:05:38 -0400
Received: from mx.kernel.net.pl ([217.73.31.3]:36672 "EHLO an2.kernel.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758466Ab1I3MFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:05:36 -0400
From: Witold Krecicki <wpk@culm.net>
To: Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Witold Krecicki <wpk@culm.net>
Subject: [PATCH 4/6] cgroup: disallow task from leaving cgroup isolated root
Date: Fri, 30 Sep 2011 13:36:23 +0200
Message-Id: <1317382585-12172-5-git-send-email-wpk@culm.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317382585-12172-1-git-send-email-wpk@culm.net>
References: <1317382585-12172-1-git-send-email-wpk@culm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it impossible for a task to exit cgroup isolated
root environment.

Signed-off-by: Witold Krecicki <wpk@culm.net>
---
 kernel/cgroup.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f9b4bdf..c3fee33 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1850,13 +1850,17 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
 	int retval;
 	struct cgroup_subsys *ss, *failed_ss = NULL;
-	struct cgroup *oldcgrp;
+	struct cgroup *oldcgrp, *isol_root;
 	struct cgroupfs_root *root = cgrp->root;
 
 	/* Nothing to do if the task is already in that cgroup */
 	oldcgrp = task_cgroup_from_root(tsk, root);
 	if (cgrp == oldcgrp)
 		return 0;
+	/* We need to check if the new cgrp is inside the isolation root */
+	isol_root = cgroup_get_isolation_root(oldcgrp);
+	if (isol_root && !cgroup_is_descendant(cgrp, isol_root))
+		return -EBUSY;
 
 	for_each_subsys(root, ss) {
 		if (ss->can_attach) {
-- 
1.7.4.1

