Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0JVXDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:03:54 -0400
Received: from smtp-out.google.com ([74.125.121.35]:11347 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab0JVXDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:03:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SPGhpMSwsNLBRimQd7WJ+iVpkgBYlCqzCidACx3C9Ju/8ehZpLrK38HC44XItc4kUl
         LFZn9VMbezE1Z4K/y9FA==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Date: Fri, 22 Oct 2010 16:03:42 -0700
Message-Id: <1287788622-25860-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry about the subjectless earlier mail)

I started making small changes to the code, but none of the change helped much.
I think the problem with the current code is that, even though idle CPUs
update load, the fold only happens when one of the CPU is busy
and we end up taking its load into global load.

So, I tried to simplify things and doing the updates directly from idle loop.
This is only a test patch, and eventually we need to hook it off somewhere
else, instead of idle loop and also this is expected work only as x86_64
right now.

Peter: Do you think something like this will work? loadavg went
quite on two of my test systems after this change (4 cpu and 24 cpu).

Thanks,
Venki


---
 arch/x86/kernel/process_64.c |    2 +
 kernel/sched.c               |   67 +++++++++++------------------------------
 kernel/sched_idletask.c      |    1 -
 3 files changed, 20 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3d9ea53..aaa8025 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -101,6 +101,7 @@ static inline void play_dead(void)
 }
 #endif
 
+void idle_load_update(void);
 /*
  * The idle thread. There's no useful work to be
  * done, so just try to conserve power and have a
@@ -140,6 +141,7 @@ void cpu_idle(void)
 			stop_critical_timings();
 			pm_idle();
 			start_critical_timings();
+			idle_load_update();
 
 			trace_power_end(smp_processor_id());
 
diff --git a/kernel/sched.c b/kernel/sched.c
index dc85ceb..6d589c1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1819,7 +1819,6 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 }
 #endif
 
-static void calc_load_account_idle(struct rq *this_rq);
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
 static void update_cpu_load(struct rq *this_rq);
@@ -2959,11 +2958,12 @@ static unsigned long calc_load_update;
 unsigned long avenrun[3];
 EXPORT_SYMBOL(avenrun);
 
-static long calc_load_fold_active(struct rq *this_rq)
+static long calc_load_fold(struct rq *this_rq, int idle)
 {
-	long nr_active, delta = 0;
+	long nr_active = 0, delta = 0;
 
-	nr_active = this_rq->nr_running;
+	if (!idle)
+		nr_active = this_rq->nr_running;
 	nr_active += (long) this_rq->nr_uninterruptible;
 
 	if (nr_active != this_rq->calc_load_active) {
@@ -2974,46 +2974,6 @@ static long calc_load_fold_active(struct rq *this_rq)
 	return delta;
 }
 
-#ifdef CONFIG_NO_HZ
-/*
- * For NO_HZ we delay the active fold to the next LOAD_FREQ update.
- *
- * When making the ILB scale, we should try to pull this in as well.
- */
-static atomic_long_t calc_load_tasks_idle;
-
-static void calc_load_account_idle(struct rq *this_rq)
-{
-	long delta;
-
-	delta = calc_load_fold_active(this_rq);
-	if (delta)
-		atomic_long_add(delta, &calc_load_tasks_idle);
-}
-
-static long calc_load_fold_idle(void)
-{
-	long delta = 0;
-
-	/*
-	 * Its got a race, we don't care...
-	 */
-	if (atomic_long_read(&calc_load_tasks_idle))
-		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
-
-	return delta;
-}
-#else
-static void calc_load_account_idle(struct rq *this_rq)
-{
-}
-
-static inline long calc_load_fold_idle(void)
-{
-	return 0;
-}
-#endif
-
 /**
  * get_avenrun - get the load average array
  * @loads:	pointer to dest load array
@@ -3043,7 +3003,7 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
  */
 void calc_global_load(void)
 {
-	unsigned long upd = calc_load_update + 10;
+	unsigned long upd = calc_load_update + LOAD_FREQ/2;
 	long active;
 
 	if (time_before(jiffies, upd))
@@ -3063,21 +3023,30 @@ void calc_global_load(void)
  * Called from update_cpu_load() to periodically update this CPU's
  * active count.
  */
-static void calc_load_account_active(struct rq *this_rq)
+static void calc_load_account(struct rq *this_rq, int idle)
 {
 	long delta;
 
 	if (time_before(jiffies, this_rq->calc_load_update))
 		return;
 
-	delta  = calc_load_fold_active(this_rq);
-	delta += calc_load_fold_idle();
+	delta  = calc_load_fold(this_rq, idle);
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
 
 	this_rq->calc_load_update += LOAD_FREQ;
 }
 
+void idle_load_update(void)
+{
+	struct rq *rq = this_rq();
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	calc_load_account(rq, 1);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+}
+
 /*
  * The exact cpuload at various idx values, calculated at every tick would be
  * load = (2^idx - 1) / 2^idx * load + 1 / 2^idx * cur_load
@@ -3194,7 +3163,7 @@ static void update_cpu_load_active(struct rq *this_rq)
 {
 	update_cpu_load(this_rq);
 
-	calc_load_account_active(this_rq);
+	calc_load_account(this_rq, 0);
 }
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 9fa0f40..6ca191f 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -23,7 +23,6 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
-	calc_load_account_idle(rq);
 	return rq->idle;
 }
 
-- 
1.7.1

