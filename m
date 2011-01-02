Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1ABHXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:35271 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1ABHXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 093/260] sched: Fix select_idle_sibling()
Date: Sun,  2 Jan 2011 02:16:29 -0500
Message-Id: <1293952756-15010-94-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:52.0211 (UTC) FILETIME=[BA20DA30:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

commit 8b911acdf08477c059d1c36c21113ab1696c612b upstream.

Don't bother with selection when the current cpu is idle.  Recent load
balancing changes also make it no longer necessary to check wake_affine()
success before returning the selected sibling, so we now always use it.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301369.6785.36.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched_fair.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 94993ac..ae4d842 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1454,7 +1454,7 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
-	int want_affine = 0;
+	int want_affine = 0, cpu_idle = !current->pid;
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
@@ -1512,13 +1512,15 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_SHARE_PKG_RESOURCES)
+			if (!cpu_idle && tmp->flags & SD_SHARE_PKG_RESOURCES)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {
 				if (tmp->flags & SD_WAKE_AFFINE) {
 					affine_sd = tmp;
 					want_affine = 0;
+					if (target != cpu)
+						cpu_idle = 1;
 				}
 				cpu = target;
 			}
@@ -1534,6 +1536,7 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 			sd = tmp;
 	}
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	if (sched_feat(LB_SHARES_UPDATE)) {
 		/*
 		 * Pick the largest domain to update shares over
@@ -1550,9 +1553,12 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 			raw_spin_lock(&rq->lock);
 		}
 	}
+#endif
 
-	if (affine_sd && wake_affine(affine_sd, p, sync))
-		return cpu;
+	if (affine_sd) {
+		if (cpu_idle || cpu == prev_cpu || wake_affine(affine_sd, p, sync))
+			return cpu;
+	}
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
-- 
1.7.3.3

