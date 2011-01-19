Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1ASTEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:04:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:36548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab1ASTEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:04:46 -0500
Date: Wed, 19 Jan 2011 19:04:06 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, peterz@infradead.org,
        vmiklos@frugalware.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, efault@gmx.de,
        vmiklos@frugalware.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1293206353.29444.205.camel@laptop>
References: <1293206353.29444.205.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched, cgroup: Use exit hook to avoid use-after-free crash
Message-ID: <tip-068c5cc5ac7414a8e9eb7856b4bf3cc4d4744267@git.kernel.org>
Git-Commit-ID: 068c5cc5ac7414a8e9eb7856b4bf3cc4d4744267
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 Jan 2011 19:04:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  068c5cc5ac7414a8e9eb7856b4bf3cc4d4744267
Gitweb:     http://git.kernel.org/tip/068c5cc5ac7414a8e9eb7856b4bf3cc4d4744267
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 19 Jan 2011 12:26:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Jan 2011 12:51:32 +0100

sched, cgroup: Use exit hook to avoid use-after-free crash

By not notifying the controller of the on-exit move back to
init_css_set, we fail to move the task out of the previous
cgroup's cfs_rq. This leads to an opportunity for a
cgroup-destroy to come in and free the cgroup (there are no
active tasks left in it after all) to which the not-quite dead
task is still enqueued.

Reported-by: Miklos Vajna <vmiklos@frugalware.org>
Fixed-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1293206353.29444.205.camel@laptop>
---
 kernel/sched.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0a169a8..fa5272a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -606,6 +606,9 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct task_group *tg;
 	struct cgroup_subsys_state *css;
 
+	if (p->flags & PF_EXITING)
+		return &root_task_group;
+
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
 			lockdep_is_held(&task_rq(p)->lock));
 	tg = container_of(css, struct task_group, css);
@@ -8880,6 +8883,20 @@ cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	}
 }
 
+static void
+cpu_cgroup_exit(struct cgroup_subsys *ss, struct task_struct *task)
+{
+	/*
+	 * cgroup_exit() is called in the copy_process() failure path.
+	 * Ignore this case since the task hasn't ran yet, this avoids
+	 * trying to poke a half freed task state from generic code.
+	 */
+	if (!(task->flags & PF_EXITING))
+		return;
+
+	sched_move_task(task);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static int cpu_shares_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
@@ -8952,6 +8969,7 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 	.destroy	= cpu_cgroup_destroy,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
+	.exit		= cpu_cgroup_exit,
 	.populate	= cpu_cgroup_populate,
 	.subsys_id	= cpu_cgroup_subsys_id,
 	.early_init	= 1,
