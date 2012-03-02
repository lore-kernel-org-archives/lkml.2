Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab2CBO4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:56:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45553 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab2CBO4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:56:35 -0500
Date: Fri, 2 Mar 2012 06:55:47 -0800
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Message-ID: <tip-2e5b5b3a1b7768c89fbfeca18e75f8ee377e924c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4F45FBB7.5090607@ct.jp.nec.com>
References: <4F45FBB7.5090607@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Clean up parameter passing of proc_sched_autogroup_set_nice()
Git-Commit-ID: 2e5b5b3a1b7768c89fbfeca18e75f8ee377e924c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 02 Mar 2012 06:56:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e5b5b3a1b7768c89fbfeca18e75f8ee377e924c
Gitweb:     http://git.kernel.org/tip/2e5b5b3a1b7768c89fbfeca18e75f8ee377e924c
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Thu, 23 Feb 2012 17:41:27 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Mar 2012 12:23:49 +0100

sched: Clean up parameter passing of proc_sched_autogroup_set_nice()

Pass nice as a value to proc_sched_autogroup_set_nice().

No side effect is expected, and the variable err will be overwritten with
the return value.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4F45FBB7.5090607@ct.jp.nec.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/base.c            |    3 +--
 include/linux/sched.h     |    2 +-
 kernel/sched/auto_group.c |   12 ++++++------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index d4548dd..965d4bd 100644
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
index c628a91..c298fb9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2065,7 +2065,7 @@ extern void sched_autogroup_fork(struct signal_struct *sig);
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
