Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab1HWWUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:20:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44641 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1HWWUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:20:11 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] cgroup: subsys->attach_task() should be called after migration
Date: Wed, 24 Aug 2011 00:19:55 +0200
Message-Id: <1314138000-2049-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314138000-2049-1-git-send-email-tj@kernel.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_attach_task() calls subsys->attach_task() after
cgroup_task_migrate(); however, cgroup_attach_proc() calls it before
migration.  This actually affects some of the users.  Update
cgroup_attach_proc() such that ->attach_task() is called after
migration.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1d2b6ce..a606fa2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2135,14 +2135,16 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		oldcgrp = task_cgroup_from_root(tsk, root);
 		if (cgrp == oldcgrp)
 			continue;
+
+		/* if the thread is PF_EXITING, it can just get skipped. */
+		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
+		BUG_ON(retval != 0 && retval != -ESRCH);
+
 		/* attach each task to each subsystem */
 		for_each_subsys(root, ss) {
 			if (ss->attach_task)
 				ss->attach_task(cgrp, tsk);
 		}
-		/* if the thread is PF_EXITING, it can just get skipped. */
-		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
-		BUG_ON(retval != 0 && retval != -ESRCH);
 	}
 	/* nothing is sensitive to fork() after this point. */
 
-- 
1.7.6

