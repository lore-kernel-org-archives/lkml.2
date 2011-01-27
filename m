Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab1A0RbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 12:31:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41167 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab1A0RbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 12:31:23 -0500
Date: Thu, 27 Jan 2011 18:31:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110127173105.GA32752@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Paul Turner (3):
      sched: Fix sign under-flows in wake_affine
      sched: Fix/remove redundant cfs_rq checks
      sched: Use rq->clock_task instead of rq->clock for correctly maintaining load averages


 kernel/sched_fair.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3547699..0c26e2d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -722,10 +722,10 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 	u64 now, delta;
 	unsigned long load = cfs_rq->load.weight;
 
-	if (!cfs_rq)
+	if (cfs_rq->tg == &root_task_group)
 		return;
 
-	now = rq_of(cfs_rq)->clock;
+	now = rq_of(cfs_rq)->clock_task;
 	delta = now - cfs_rq->load_stamp;
 
 	/* truncate load history at 4 idle periods */
@@ -830,9 +830,6 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 	struct sched_entity *se;
 	long shares;
 
-	if (!cfs_rq)
-		return;
-
 	tg = cfs_rq->tg;
 	se = tg->se[cpu_of(rq_of(cfs_rq))];
 	if (!se)
@@ -1432,7 +1429,7 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
-	unsigned long this_load, load;
+	s64 this_load, load;
 	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
 	struct task_group *tg;
@@ -1471,8 +1468,8 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * Otherwise check if either cpus are near enough in load to allow this
 	 * task to be woken on this_cpu.
 	 */
-	if (this_load) {
-		unsigned long this_eff_load, prev_eff_load;
+	if (this_load > 0) {
+		s64 this_eff_load, prev_eff_load;
 
 		this_eff_load = 100;
 		this_eff_load *= power_of(prev_cpu);
