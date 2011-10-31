Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486Ab1JaTFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:05:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49433 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934193Ab1JaTFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:05:52 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/17] freezer: don't distinguish nosig tasks on thaw
Date: Mon, 31 Oct 2011 12:05:18 -0700
Message-Id: <1320087928-32307-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in thawing nosig tasks before others.  There's no
ordering requirement between the two groups on thaw, which the staged
thawing can't guarantee anyway.  Simplify thaw_processes() by removing
the distinction and collapsing thaw_tasks() into thaw_processes().
This will help further updates to freezer.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/power/process.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 23822dc..9db048f 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -170,34 +170,28 @@ int freeze_kernel_threads(void)
 	return error;
 }
 
-static void thaw_tasks(bool nosig_only)
+void thaw_processes(void)
 {
 	struct task_struct *g, *p;
 
+	oom_killer_enable();
+
+	printk("Restarting tasks ... ");
+
+	thaw_workqueues();
+
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
 		if (!freezable(p))
 			continue;
 
-		if (nosig_only && should_send_signal(p))
-			continue;
-
 		if (cgroup_freezing_or_frozen(p))
 			continue;
 
 		__thaw_task(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
-}
-
-void thaw_processes(void)
-{
-	oom_killer_enable();
 
-	printk("Restarting tasks ... ");
-	thaw_workqueues();
-	thaw_tasks(true);
-	thaw_tasks(false);
 	schedule();
 	printk("done.\n");
 }
-- 
1.7.3.1

