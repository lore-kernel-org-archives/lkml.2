Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0IUTqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:46:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35807 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab0IUTqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:46:22 -0400
Date: Tue, 21 Sep 2010 21:46:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20100921194613.GA21470@elte.hu>
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
	[score: 0.0095]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Stanislaw Gruszka (1):
      sched: Fix user time incorrectly accounted as system time on 32-bit

Suresh Siddha (1):
      sched: Fix nohz balance kick


 kernel/sched.c      |    8 ++++----
 kernel/sched_fair.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ed09d4f..dc85ceb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3513,9 +3513,9 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
-		u64 temp;
+		u64 temp = rtime;
 
-		temp = (u64)(rtime * utime);
+		temp *= utime;
 		do_div(temp, total);
 		utime = (cputime_t)temp;
 	} else
@@ -3546,9 +3546,9 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
 
 	if (total) {
-		u64 temp;
+		u64 temp = rtime;
 
-		temp = (u64)(rtime * cputime.utime);
+		temp *= cputime.utime;
 		do_div(temp, total);
 		utime = (cputime_t)temp;
 	} else
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a171138..db3f674 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3630,7 +3630,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	if (time_before(now, nohz.next_balance))
 		return 0;
 
-	if (!rq->nr_running)
+	if (rq->idle_at_tick)
 		return 0;
 
 	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
