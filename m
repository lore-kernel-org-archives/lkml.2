Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab1CJIBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:01:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36873 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1CJIBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:01:21 -0500
Date: Thu, 10 Mar 2011 09:01:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fix
Message-ID: <20110310080108.GA16458@elte.hu>
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

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Balbir Singh (1):
      sched: Fix sched rt group scheduling when hierachy is enabled


 kernel/sched_rt.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index ad62677..01f75a5 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -210,11 +210,12 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
-	int this_cpu = smp_processor_id();
 	struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
 	struct sched_rt_entity *rt_se;
 
-	rt_se = rt_rq->tg->rt_se[this_cpu];
+	int cpu = cpu_of(rq_of_rt_rq(rt_rq));
+
+	rt_se = rt_rq->tg->rt_se[cpu];
 
 	if (rt_rq->rt_nr_running) {
 		if (rt_se && !on_rt_rq(rt_se))
@@ -226,10 +227,10 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 
 static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
-	int this_cpu = smp_processor_id();
 	struct sched_rt_entity *rt_se;
+	int cpu = cpu_of(rq_of_rt_rq(rt_rq));
 
-	rt_se = rt_rq->tg->rt_se[this_cpu];
+	rt_se = rt_rq->tg->rt_se[cpu];
 
 	if (rt_se && on_rt_rq(rt_se))
 		dequeue_rt_entity(rt_se);
@@ -565,8 +566,11 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;
 			raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		} else if (rt_rq->rt_nr_running)
+		} else if (rt_rq->rt_nr_running) {
 			idle = 0;
+			if (!rt_rq_throttled(rt_rq))
+				enqueue = 1;
+		}
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);
