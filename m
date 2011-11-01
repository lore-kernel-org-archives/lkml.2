Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1KAXq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:46:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38653 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab1KAXqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:46:53 -0400
From: Tejun Heo <tj@kernel.org>
To: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/10] cgroup: subsys->attach_task() should be called after migration
Date: Tue,  1 Nov 2011 16:46:28 -0700
Message-Id: <1320191193-8110-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320191193-8110-1-git-send-email-tj@kernel.org>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_attach_task() calls subsys->attach_task() after
cgroup_task_migrate(); however, cgroup_attach_proc() calls it before
migration.  This actually affects some of the users.  Update
cgroup_attach_proc() such that ->attach_task() is called after
migration.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@Jp.fujitsu.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 83e10f9..3679fb6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2152,13 +2152,15 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		oldcgrp = task_cgroup_from_root(tsk, root);
 		if (cgrp == oldcgrp)
 			continue;
+
+		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
+		BUG_ON(retval != 0);
+
 		/* attach each task to each subsystem */
 		for_each_subsys(root, ss) {
 			if (ss->attach_task)
 				ss->attach_task(cgrp, tsk);
 		}
-		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
-		BUG_ON(retval != 0);
 	}
 	/* nothing is sensitive to fork() after this point. */
 
-- 
1.7.3.1

