Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0IRTJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:09:38 -0400
Received: from kroah.org ([198.145.64.141]:51822 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0IRTCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:21 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:01 2010
Message-Id: <20100918190001.903367538@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [106/123] sched: More generic WAKE_AFFINE vs select_idle_sibling()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-more-generic-wake_affine-vs-select_idle_sibling.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit fe3bcfe1f6c1fc4ea7706ac2d05e579fd9092682 upstream

Instead of only considering SD_WAKE_AFFINE | SD_PREFER_SIBLING
domains also allow all SD_PREFER_SIBLING domains below a
SD_WAKE_AFFINE domain to change the affinity target.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091112145610.909723612@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_fair.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1398,20 +1398,16 @@ select_idle_sibling(struct task_struct *
 	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
 	 * always a better target than the current cpu.
 	 */
-	if (target == cpu) {
-		if (!cpu_rq(prev_cpu)->cfs.nr_running)
-			target = prev_cpu;
-	}
+	if (target == cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
+		return prev_cpu;
 
 	/*
 	 * Otherwise, iterate the domain and find an elegible idle cpu.
 	 */
-	if (target == -1 || target == cpu) {
-		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
-			if (!cpu_rq(i)->cfs.nr_running) {
-				target = i;
-				break;
-			}
+	for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+		if (!cpu_rq(i)->cfs.nr_running) {
+			target = i;
+			break;
 		}
 	}
 
@@ -1475,7 +1471,12 @@ select_task_rq_fair(struct rq *rq, struc
 				want_sd = 0;
 		}
 
-		if (want_affine && (tmp->flags & SD_WAKE_AFFINE)) {
+		/*
+		 * While iterating the domains looking for a spanning
+		 * WAKE_AFFINE domain, adjust the affine target to any idle cpu
+		 * in cache sharing domains along the way.
+		 */
+		if (want_affine) {
 			int target = -1;
 
 			/*
@@ -1488,17 +1489,15 @@ select_task_rq_fair(struct rq *rq, struc
 			/*
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
-			 *
-			 * XXX: should we possibly do this outside of
-			 * WAKE_AFFINE, in case the shared cache domain is
-			 * smaller than the WAKE_AFFINE domain?
 			 */
 			if (tmp->flags & SD_PREFER_SIBLING)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {
-				affine_sd = tmp;
-				want_affine = 0;
+				if (tmp->flags & SD_WAKE_AFFINE) {
+					affine_sd = tmp;
+					want_affine = 0;
+				}
 				cpu = target;
 			}
 		}


