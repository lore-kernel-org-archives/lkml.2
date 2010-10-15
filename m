Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0JOLIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 07:08:42 -0400
Received: from canuck.infradead.org ([134.117.69.58]:42412 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0JOLIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 07:08:40 -0400
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Chase Douglas <chase.douglas@canonical.com>, Ingo Molnar <mingo@elte.hu>,
        tmhikaru@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101014145813.GA2185@brouette>
References: <20101014145813.GA2185@brouette>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 13:08:22 +0200
Message-ID: <1287140902.29097.1455.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 16:58 +0200, Damien Wyart wrote:

> - the commit 74f5187ac873042f502227701ed1727e7c5fbfa9 isolated by Tim
>   seems to be the culprit;

Right, so I think I figured out what's happening.

We're folding sucessive idles of the same cpu into the total idle
number, which is inflating things.

+/*
+ * For NO_HZ we delay the active fold to the next LOAD_FREQ update.
+ *
+ * When making the ILB scale, we should try to pull this in as well.
+ */
+static atomic_long_t calc_load_tasks_idle;
+
+static void calc_load_account_idle(struct rq *this_rq)
+{
+       long delta;
+
+       delta = calc_load_fold_active(this_rq);
+       if (delta)
+               atomic_long_add(delta, &calc_load_tasks_idle);
+}
+
+static long calc_load_fold_idle(void)
+{
+       long delta = 0;
+
+       /*
+        * Its got a race, we don't care...
+        */
+       if (atomic_long_read(&calc_load_tasks_idle))
+               delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
+
+       return delta;
+}


If you look at that and imagine CPU1 going idle with 1 task blocked,
then waking up due to unblocking, then going idle with that same task
block, etc.. all before we fold_idle on an active cpu, then we can count
that one task many times over.


I haven't come up with a sane patch yet, hackery below, but that does
let my 24-cpu system idle into load 0.0x instead of the constant 1.x it
had before.


Beware, utter hackery below.. lots of races not sure it matters but it
ain't pretty..

Anybody got a bright idea here?

---
 kernel/sched.c          |   32 ++++++++++++++++++++++++++++++--
 kernel/sched_idletask.c |    1 +
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 91c19db..ac4512d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -521,6 +521,9 @@ struct rq {
 	/* calc_load related fields */
 	unsigned long calc_load_update;
 	long calc_load_active;
+#ifdef CONFIG_NO_HZ
+	long calc_load_inactive;
+#endif
 
 #ifdef CONFIG_SCHED_HRTICK
 #ifdef CONFIG_SMP
@@ -1817,6 +1820,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 #endif
 
 static void calc_load_account_idle(struct rq *this_rq);
+static void calc_load_account_nonidle(struct rq *this_rq);
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
 static void update_cpu_load(struct rq *this_rq);
@@ -2978,14 +2982,33 @@ static long calc_load_fold_active(struct rq *this_rq)
  * When making the ILB scale, we should try to pull this in as well.
  */
 static atomic_long_t calc_load_tasks_idle;
+static cpumask_var_t calc_load_mask;
 
 static void calc_load_account_idle(struct rq *this_rq)
 {
 	long delta;
 
 	delta = calc_load_fold_active(this_rq);
-	if (delta)
+	this_rq->calc_load_inactive = delta;
+
+	if (delta) {
 		atomic_long_add(delta, &calc_load_tasks_idle);
+		cpumask_set_cpu(cpu_of(this_rq), calc_load_mask);
+	}
+
+	trace_printk("idle start: %d %Ld %Ld\n", cpu_of(this_rq), delta, 
+			atomic_long_read(&calc_load_tasks_idle));
+}
+
+static void calc_load_account_nonidle(struct rq *this_rq)
+{
+	if (cpumask_test_and_clear_cpu(cpu_of(this_rq), calc_load_mask)) {
+		atomic_long_sub(this_rq->calc_load_inactive, &calc_load_tasks_idle);
+		trace_printk("idle end: %d %Ld %Ld\n", cpu_of(this_rq),
+				this_rq->calc_load_inactive,
+				atomic_long_read(&calc_load_tasks_idle));
+	} else
+		trace_printk("idle end: %d\n", cpu_of(this_rq));
 }
 
 static long calc_load_fold_idle(void)
@@ -2995,8 +3018,12 @@ static long calc_load_fold_idle(void)
 	/*
 	 * Its got a race, we don't care...
 	 */
-	if (atomic_long_read(&calc_load_tasks_idle))
+	if (atomic_long_read(&calc_load_tasks_idle)) {
 		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
+		cpumask_clear(calc_load_mask);
+	}
+
+	trace_printk("idle fold: %d %Ld\n", smp_processor_id(), delta);
 
 	return delta;
 }
@@ -7935,6 +7962,7 @@ void __init sched_init(void)
 	atomic_set(&nohz.load_balancer, nr_cpu_ids);
 	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
 	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
+	zalloc_cpumask_var(&calc_load_mask, GFP_NOWAIT);
 #endif
 	/* May be allocated at isolcpus cmdline parse time */
 	if (cpu_isolated_map == NULL)
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 9fa0f402..a7fa1aa 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -42,6 +42,7 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	calc_load_account_nonidle(rq);
 }
 
 static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)

