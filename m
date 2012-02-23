Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab2BWImx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:42:53 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60729 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab2BWImw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:42:52 -0500
Message-ID: <4F45FBB7.5090607@ct.jp.nec.com>
Date: Thu, 23 Feb 2012 17:41:27 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH] Pass nice as a value to proc_sched_autogroup_set_nice()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

No side effect is expected, and the variable err will be overwritten with
return value.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 fs/proc/base.c            |    3 +--
 include/linux/sched.h     |    2 +-
 kernel/sched/auto_group.c |   12 ++++++------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index db6ab4b..d449c02 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1310,8 +1310,7 @@ sched_autogroup_write(struct file *file, const char __user *buf,
 	if (!p)
 		return -ESRCH;
 
-	err = nice;
-	err = proc_sched_autogroup_set_nice(p, &err);
+	err = proc_sched_autogroup_set_nice(p, nice);
 	if (err)
 		count = err;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4fb1d62..ee882cb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2064,7 +2064,7 @@ extern void sched_autogroup_fork(struct signal_struct *sig);
 extern void sched_autogroup_exit(struct signal_struct *sig);
 #ifdef CONFIG_PROC_FS
 extern void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m);
-extern int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice);
+extern int proc_sched_autogroup_set_nice(struct task_struct *p, int nice);
 #endif
 #else
 static inline void sched_autogroup_create_attach(struct task_struct *p) { }
diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index e8a1f83..0984a21 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -195,20 +195,20 @@ __setup("noautogroup", setup_autogroup);
 
 #ifdef CONFIG_PROC_FS
 
-int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
+int proc_sched_autogroup_set_nice(struct task_struct *p, int nice)
 {
 	static unsigned long next = INITIAL_JIFFIES;
 	struct autogroup *ag;
 	int err;
 
-	if (*nice < -20 || *nice > 19)
+	if (nice < -20 || nice > 19)
 		return -EINVAL;
 
-	err = security_task_setnice(current, *nice);
+	err = security_task_setnice(current, nice);
 	if (err)
 		return err;
 
-	if (*nice < 0 && !can_nice(current, *nice))
+	if (nice < 0 && !can_nice(current, nice))
 		return -EPERM;
 
 	/* this is a heavy operation taking global locks.. */
@@ -219,9 +219,9 @@ int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
 	ag = autogroup_task_get(p);
 
 	down_write(&ag->lock);
-	err = sched_group_set_shares(ag->tg, prio_to_weight[*nice + 20]);
+	err = sched_group_set_shares(ag->tg, prio_to_weight[nice + 20]);
 	if (!err)
-		ag->nice = *nice;
+		ag->nice = nice;
 	up_write(&ag->lock);
 
 	autogroup_kref_put(ag);
-- 
1.7.7.6

