Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0IRTJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:09:53 -0400
Received: from kroah.org ([198.145.64.141]:51816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab0IRTCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:20 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:01 2010
Message-Id: <20100918190001.817905520@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [105/123] sched: Cleanup select_task_rq_fair()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-cleanup-select_task_rq_fair.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit a50bde5130f65733142b32975616427d0ea50856 upstream

Clean up the new affine to idle sibling bits while trying to
grok them. Should not have any function differences.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091112145610.832503781@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_fair.c |   73 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 22 deletions(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1384,6 +1384,41 @@ find_idlest_cpu(struct sched_group *grou
 }
 
 /*
+ * Try and locate an idle CPU in the sched_domain.
+ */
+static int
+select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
+{
+	int cpu = smp_processor_id();
+	int prev_cpu = task_cpu(p);
+	int i;
+
+	/*
+	 * If this domain spans both cpu and prev_cpu (see the SD_WAKE_AFFINE
+	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
+	 * always a better target than the current cpu.
+	 */
+	if (target == cpu) {
+		if (!cpu_rq(prev_cpu)->cfs.nr_running)
+			target = prev_cpu;
+	}
+
+	/*
+	 * Otherwise, iterate the domain and find an elegible idle cpu.
+	 */
+	if (target == -1 || target == cpu) {
+		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+			if (!cpu_rq(i)->cfs.nr_running) {
+				target = i;
+				break;
+			}
+		}
+	}
+
+	return target;
+}
+
+/*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
  * SD_BALANCE_EXEC.
@@ -1441,36 +1476,30 @@ select_task_rq_fair(struct rq *rq, struc
 		}
 
 		if (want_affine && (tmp->flags & SD_WAKE_AFFINE)) {
-			int candidate = -1, i;
+			int target = -1;
 
+			/*
+			 * If both cpu and prev_cpu are part of this domain,
+			 * cpu is a valid SD_WAKE_AFFINE target.
+			 */
 			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp)))
-				candidate = cpu;
+				target = cpu;
 
 			/*
-			 * Check for an idle shared cache.
+			 * If there's an idle sibling in this domain, make that
+			 * the wake_affine target instead of the current cpu.
+			 *
+			 * XXX: should we possibly do this outside of
+			 * WAKE_AFFINE, in case the shared cache domain is
+			 * smaller than the WAKE_AFFINE domain?
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING) {
-				if (candidate == cpu) {
-					if (!cpu_rq(prev_cpu)->cfs.nr_running)
-						candidate = prev_cpu;
-				}
-
-				if (candidate == -1 || candidate == cpu) {
-					for_each_cpu(i, sched_domain_span(tmp)) {
-						if (!cpumask_test_cpu(i, &p->cpus_allowed))
-							continue;
-						if (!cpu_rq(i)->cfs.nr_running) {
-							candidate = i;
-							break;
-						}
-					}
-				}
-			}
+			if (tmp->flags & SD_PREFER_SIBLING)
+				target = select_idle_sibling(p, tmp, target);
 
-			if (candidate >= 0) {
+			if (target >= 0) {
 				affine_sd = tmp;
 				want_affine = 0;
-				cpu = candidate;
+				cpu = target;
 			}
 		}
 


