Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0JTOOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:14:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:52087 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab0JTOOl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:14:41 -0400
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Chase Douglas <chase.douglas@canonical.com>, Ingo Molnar <mingo@elte.hu>,
        tmhikaru@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
In-Reply-To: <1287582208.3488.20.camel@twins>
References: <20100929070153.GA2200@brouette>
	 <20101014145813.GA2185@brouette>  <20101020132732.GA30024@brouette>
	 <1287581440.3488.16.camel@twins>  <1287582208.3488.20.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Oct 2010 16:14:33 +0200
Message-ID: <1287584073.3488.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 15:43 +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-20 at 15:30 +0200, Peter Zijlstra wrote:
> > On Wed, 2010-10-20 at 15:27 +0200, Damien Wyart wrote:
> > > 
> > > Should'nt we enlarge the list of CC, because for now, responsivity has
> > > been close to 0 and it seems we will get a 2.6.36 with buggy load avg
> > > calculation. Even if it is only statistics, many supervision tools rely
> > > on the load avg, so for production environments, this is not a good
> > > thing. 
> > 
> > It already contains all the folks who know the code I'm afraid.. :/
> > 
> > I've been playing with it a bit more today, but haven't actually managed
> > to make it better, just differently worse..
> 
> Ah, I just remembered Venki recently poked at this code too, maybe he's
> got a bright idea..
> 
> Venki, there are cpu-load issues, the reported issue is that idle load
> is too high, and I think I can see that happening with the current code
> (due to 74f5187ac8).
> 
> The flaw I can see in that commit is that we can go idle multiple times
> during the LOAD_FREQ window, which will basically inflate the idle
> contribution.
> 
> All attempts from me to fix that so far have resulted in curious
> results..
> 
> Would you have a moment to also look at this?

Just for reference this is my latest patch.. I figured that since its
NOHZ related it should actually be keyed of off the nohz code, not going
idle.


---
 include/linux/sched.h    |    8 ++++++++
 kernel/sched.c           |   28 +++++++++++++++++++++-------
 kernel/sched_idletask.c  |    1 -
 kernel/time/tick-sched.c |    2 ++
 4 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0383601..5311ef4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -145,6 +145,14 @@ extern unsigned long this_cpu_load(void);
 
 extern void calc_global_load(void);
 
+#ifdef CONFIG_NO_HZ
+extern void calc_load_account_idle(void);
+extern void calc_load_account_nonidle(void);
+#else
+static inline void calc_load_account_idle(void) { }
+static inline void calc_load_account_nonidle(void) { }
+#endif
+
 extern unsigned long get_parent_ip(unsigned long addr);
 
 struct seq_file;
diff --git a/kernel/sched.c b/kernel/sched.c
index abf8440..79a29e6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -526,6 +526,10 @@ struct rq {
 	/* calc_load related fields */
 	unsigned long calc_load_update;
 	long calc_load_active;
+#ifdef CONFIG_NO_HZ
+	long calc_load_inactive;
+	int calc_load_seq;
+#endif
 
 #ifdef CONFIG_SCHED_HRTICK
 #ifdef CONFIG_SMP
@@ -1833,7 +1837,6 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 }
 #endif
 
-static void calc_load_account_idle(struct rq *this_rq);
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
 static void update_cpu_load(struct rq *this_rq);
@@ -3111,16 +3114,29 @@ static long calc_load_fold_active(struct rq *this_rq)
  * When making the ILB scale, we should try to pull this in as well.
  */
 static atomic_long_t calc_load_tasks_idle;
+static atomic_t calc_load_seq;
 
-static void calc_load_account_idle(struct rq *this_rq)
+void calc_load_account_idle(void)
 {
+	struct rq *this_rq = this_rq();
 	long delta;
 
 	delta = calc_load_fold_active(this_rq);
+	this_rq->calc_load_inactive = delta;
+	this_rq->calc_load_seq = atomic_read(&calc_load_seq);
+
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks_idle);
 }
 
+void calc_load_account_nonidle(void)
+{
+	struct rq *this_rq = this_rq();
+
+	if (atomic_read(&calc_load_seq) == this_rq->calc_load_seq)
+		atomic_long_add(this_rq->calc_load_inactive, &calc_load_tasks_idle);
+}
+
 static long calc_load_fold_idle(void)
 {
 	long delta = 0;
@@ -3128,16 +3144,14 @@ static long calc_load_fold_idle(void)
 	/*
 	 * Its got a race, we don't care...
 	 */
-	if (atomic_long_read(&calc_load_tasks_idle))
+	if (atomic_long_read(&calc_load_tasks_idle)) {
+		atomic_inc(&calc_load_seq);
 		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
+	}
 
 	return delta;
 }
 #else
-static void calc_load_account_idle(struct rq *this_rq)
-{
-}
-
 static inline long calc_load_fold_idle(void)
 {
 	return 0;
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 9fa0f402..6ca191f 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -23,7 +23,6 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
-	calc_load_account_idle(rq);
 	return rq->idle;
 }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..808abd7 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -411,6 +411,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
 			rcu_enter_nohz();
+			calc_load_account_idle();
 		}
 
 		ts->idle_sleeps++;
@@ -520,6 +521,7 @@ void tick_nohz_restart_sched_tick(void)
 
 	ts->inidle = 0;
 
+	calc_load_account_nonidle();
 	rcu_exit_nohz();
 
 	/* Update jiffies first */

