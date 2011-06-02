Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1FBSs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:48:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64687 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1FBSs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:48:58 -0400
X-Authority-Analysis: v=1.1 cv=rr9DlE2fnT1UeYFJeFag6ks/js+bHNfqVlaSByoS2d4= c=1 sm=0 a=eihUWLuu4skA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=ckdDxq7zNo95QtTJwLwA:9 a=IzOghxPO5k-vUbgh_tsA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [GIT PULL] sched: Remove unlikely likelys (take two)
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gregory Haskins <ghaskins@novell.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Jun 2011 14:48:55 -0400
Message-ID: <1307040535.3667.23.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I noticed this pull request never made it into tip:

 https://lkml.org/lkml/2010/12/13/625

I tested it again by merging it into latest Linus's tree and running a
bunch of tests on it. The tests show that it still works (besides the
bugs it finds from the normal 3.0-rc release).

Please pull the latest unlikely/sched tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
unlikely/sched


Steven Rostedt (3):
      sched: Change pick_next_task_rt from unlikely to likely
      sched: Remove unlikely() from rt_policy() in sched.c
      sched: Remove unlikely() from ttwu_post_activation

Yong Zhang (1):
      sched: Cleanup pre_schedule_rt

----
 kernel/sched.c    |    4 ++--
 kernel/sched_rt.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..6d24b2e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -123,7 +123,7 @@
 
 static inline int rt_policy(int policy)
 {
-	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
+	if (policy == SCHED_FIFO || policy == SCHED_RR)
 		return 1;
 	return 0;
 }
@@ -2458,7 +2458,7 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
 
-	if (unlikely(rq->idle_stamp)) {
+	if (rq->idle_stamp) {
 		u64 delta = rq->clock - rq->idle_stamp;
 		u64 max = 2*sysctl_sched_migration_cost;
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bea7d79..c2266c4 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1062,7 +1062,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 
 	rt_rq = &rq->rt;
 
-	if (unlikely(!rt_rq->rt_nr_running))
+	if (!rt_rq->rt_nr_running)
 		return NULL;
 
 	if (rt_rq_throttled(rt_rq))
@@ -1474,7 +1474,7 @@ skip:
 static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
+	if (rq->rt.highest_prio.curr > prev->prio)
 		pull_rt_task(rq);
 }
 


