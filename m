Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1BWMG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:06:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:56478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab1BWMG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:06:27 -0500
Date: Wed, 23 Feb 2011 12:06:03 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, yong.zhang0@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <1298383320.8036.5.camel@marge.simson.net>
References: <1298383320.8036.5.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, autogroup: Stop claiming ownership of the root task group
Message-ID: <tip-511f67a5997c4967c69a3961e2fc9f04d8d244ac@git.kernel.org>
Git-Commit-ID: 511f67a5997c4967c69a3961e2fc9f04d8d244ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:06:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  511f67a5997c4967c69a3961e2fc9f04d8d244ac
Gitweb:     http://git.kernel.org/tip/511f67a5997c4967c69a3961e2fc9f04d8d244ac
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 22 Feb 2011 15:02:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:34:03 +0100

sched, autogroup: Stop claiming ownership of the root task group

Disown it, and only display autogroup association if one exists.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1298383320.8036.5.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_autogroup.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 137a096..5946ac5 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -12,7 +12,6 @@ static atomic_t autogroup_seq_nr;
 static void __init autogroup_init(struct task_struct *init_task)
 {
 	autogroup_default.tg = &root_task_group;
-	root_task_group.autogroup = &autogroup_default;
 	kref_init(&autogroup_default.kref);
 	init_rwsem(&autogroup_default.lock);
 	init_task->signal->autogroup = &autogroup_default;
@@ -130,7 +129,7 @@ task_wants_autogroup(struct task_struct *p, struct task_group *tg)
 
 static inline bool task_group_is_autogroup(struct task_group *tg)
 {
-	return tg != &root_task_group && tg->autogroup;
+	return !!tg->autogroup;
 }
 
 static inline struct task_group *
@@ -251,10 +250,14 @@ void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 {
 	struct autogroup *ag = autogroup_task_get(p);
 
+	if (!task_group_is_autogroup(ag->tg))
+		goto out;
+
 	down_read(&ag->lock);
 	seq_printf(m, "/autogroup-%ld nice %d\n", ag->id, ag->nice);
 	up_read(&ag->lock);
 
+out:
 	autogroup_kref_put(ag);
 }
 #endif /* CONFIG_PROC_FS */
@@ -262,9 +265,7 @@ void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
 #ifdef CONFIG_SCHED_DEBUG
 static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
 {
-	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
-
-	if (!enabled || !tg->autogroup)
+	if (!task_group_is_autogroup(tg))
 		return 0;
 
 	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);
