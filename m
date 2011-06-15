Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab1FOUE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:04:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53961 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1FOUEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:04:53 -0400
Date: Wed, 15 Jun 2011 22:04:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110615200448.GA7123@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-urgent-for-linus

 Thanks,

	Ingo

------------------>
Hillf Danton (1):
      sched: Fix need_resched() when checking peempt

Steven Rostedt (1):
      sched: Check if lowest_mask is initialized in find_lowest_rq()


 kernel/sched_rt.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 88725c9..10d0182 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1096,7 +1096,7 @@ static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int flag
 	 * to move current somewhere else, making room for our non-migratable
 	 * task.
 	 */
-	if (p->prio == rq->curr->prio && !need_resched())
+	if (p->prio == rq->curr->prio && !test_tsk_need_resched(rq->curr))
 		check_preempt_equal_prio(rq, p);
 #endif
 }
@@ -1239,6 +1239,10 @@ static int find_lowest_rq(struct task_struct *task)
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
 
+	/* Make sure the mask is initialized first */
+	if (unlikely(!lowest_mask))
+		return -1;
+
 	if (task->rt.nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
 
