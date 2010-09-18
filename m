Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab0IRTJH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:09:07 -0400
Received: from kroah.org ([198.145.64.141]:51837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab0IRTCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:22 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:02 2010
Message-Id: <20100918190002.076296165@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [108/123] sched: Fix select_idle_sibling()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-fix-select_idle_sibling.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

commit 8b911acdf08477c059d1c36c21113ab1696c612b upstream

Don't bother with selection when the current cpu is idle.  Recent load
balancing changes also make it no longer necessary to check wake_affine()
success before returning the selected sibling, so we now always use it.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301369.6785.36.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_fair.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1432,7 +1432,7 @@ select_task_rq_fair(struct rq *rq, struc
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
-	int want_affine = 0;
+	int want_affine = 0, cpu_idle = !current->pid;
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
@@ -1490,13 +1490,15 @@ select_task_rq_fair(struct rq *rq, struc
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
@@ -1512,6 +1514,7 @@ select_task_rq_fair(struct rq *rq, struc
 			sd = tmp;
 	}
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	if (sched_feat(LB_SHARES_UPDATE)) {
 		/*
 		 * Pick the largest domain to update shares over
@@ -1528,9 +1531,12 @@ select_task_rq_fair(struct rq *rq, struc
 			spin_lock(&rq->lock);
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


