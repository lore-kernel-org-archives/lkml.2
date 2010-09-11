Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab0IKIfK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 04:35:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52509 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab0IKIfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 04:35:07 -0400
Date: Sat, 11 Sep 2010 10:34:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20100911083457.GA6612@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      x86, tsc: Fix a preemption leak in restore_sched_clock_state()

Suresh Siddha (1):
      sched: Move sched_avg_update() to update_cpu_load()


 arch/x86/kernel/tsc.c |    2 +-
 kernel/sched.c        |    6 ++++++
 kernel/sched_fair.c   |    2 --
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d632934..26a863a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -655,7 +655,7 @@ void restore_sched_clock_state(void)
 
 	local_irq_save(flags);
 
-	get_cpu_var(cyc2ns_offset) = 0;
+	__get_cpu_var(cyc2ns_offset) = 0;
 	offset = cyc2ns_suspend - sched_clock();
 
 	for_each_possible_cpu(cpu)
diff --git a/kernel/sched.c b/kernel/sched.c
index 09b574e..ed09d4f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1294,6 +1294,10 @@ static void resched_task(struct task_struct *p)
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
 }
+
+static void sched_avg_update(struct rq *rq)
+{
+}
 #endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
@@ -3182,6 +3186,8 @@ static void update_cpu_load(struct rq *this_rq)
 
 		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
 	}
+
+	sched_avg_update(this_rq);
 }
 
 static void update_cpu_load_active(struct rq *this_rq)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ab661eb..f53ec75 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2268,8 +2268,6 @@ unsigned long scale_rt_power(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available;
 
-	sched_avg_update(rq);
-
 	total = sched_avg_period() + (rq->clock - rq->age_stamp);
 	available = total - rq->rt_avg;
 
