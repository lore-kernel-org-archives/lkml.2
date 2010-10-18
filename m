Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0JRMcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:32:41 -0400
Received: from canuck.infradead.org ([134.117.69.58]:39769 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab0JRMck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:32:40 -0400
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Chase Douglas <chase.douglas@canonical.com>, Ingo Molnar <mingo@elte.hu>,
        tmhikaru@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1287140902.29097.1455.camel@twins>
References: <20101014145813.GA2185@brouette>
	 <1287140902.29097.1455.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 14:32:20 +0200
Message-ID: <1287405140.29097.1577.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 13:08 +0200, Peter Zijlstra wrote:
> On Thu, 2010-10-14 at 16:58 +0200, Damien Wyart wrote:
> 
> > - the commit 74f5187ac873042f502227701ed1727e7c5fbfa9 isolated by Tim
> >   seems to be the culprit;
> 
> Right, so I think I figured out what's happening.
> 
> We're folding sucessive idles of the same cpu into the total idle
> number, which is inflating things.
> 
> +/*
> + * For NO_HZ we delay the active fold to the next LOAD_FREQ update.
> + *
> + * When making the ILB scale, we should try to pull this in as well.
> + */
> +static atomic_long_t calc_load_tasks_idle;
> +
> +static void calc_load_account_idle(struct rq *this_rq)
> +{
> +       long delta;
> +
> +       delta = calc_load_fold_active(this_rq);
> +       if (delta)
> +               atomic_long_add(delta, &calc_load_tasks_idle);
> +}
> +
> +static long calc_load_fold_idle(void)
> +{
> +       long delta = 0;
> +
> +       /*
> +        * Its got a race, we don't care...
> +        */
> +       if (atomic_long_read(&calc_load_tasks_idle))
> +               delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
> +
> +       return delta;
> +}
> 
> 
> If you look at that and imagine CPU1 going idle with 1 task blocked,
> then waking up due to unblocking, then going idle with that same task
> block, etc.. all before we fold_idle on an active cpu, then we can count
> that one task many times over.
> 
OK, I came up with the below, but its not quite working, load continues
to decrease even though I've got a make -j64 running..

Thomas, Chase, any clue?

---
 kernel/sched.c          |   31 +++++++++++++++++++++++++------
 kernel/sched_idletask.c |    1 +
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3312c64..a56446b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -521,6 +521,10 @@ struct rq {
 	/* calc_load related fields */
 	unsigned long calc_load_update;
 	long calc_load_active;
+#ifdef CONFIG_NO_HZ
+	long calc_load_idle;
+	int calc_load_seq;
+#endif
 
 #ifdef CONFIG_SCHED_HRTICK
 #ifdef CONFIG_SMP
@@ -1817,6 +1821,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 #endif
 
 static void calc_load_account_idle(struct rq *this_rq);
+static void calc_load_account_nonidle(struct rq *this_rq);
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
 static void update_cpu_load(struct rq *this_rq);
@@ -2978,14 +2983,25 @@ static long calc_load_fold_active(struct rq *this_rq)
  * When making the ILB scale, we should try to pull this in as well.
  */
 static atomic_long_t calc_load_tasks_idle;
+static atomic_t calc_load_seq;
 
 static void calc_load_account_idle(struct rq *this_rq)
 {
-	long delta;
+	long idle;
 
-	delta = calc_load_fold_active(this_rq);
-	if (delta)
-		atomic_long_add(delta, &calc_load_tasks_idle);
+	idle = calc_load_fold_active(this_rq);
+	this_rq->calc_load_idle = idle;
+
+	if (idle) {
+		this_rq->calc_load_seq = atomic_read(&calc_load_seq);
+		atomic_long_add(idle, &calc_load_tasks_idle);
+	}
+}
+
+static void calc_load_account_nonidle(struct rq *this_rq)
+{
+	if (atomic_read(&calc_load_seq) == this_rq->calc_load_seq)
+		atomic_long_sub(this_rq->calc_load_idle, &calc_load_tasks_idle);
 }
 
 static long calc_load_fold_idle(void)
@@ -2993,10 +3009,13 @@ static long calc_load_fold_idle(void)
 	long delta = 0;
 
 	/*
-	 * Its got a race, we don't care...
+	 * Its got races, we don't care... its only statistics after all.
 	 */
-	if (atomic_long_read(&calc_load_tasks_idle))
+	if (atomic_long_read(&calc_load_tasks_idle)) {
 		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
+		if (delta)
+			atomic_inc(&calc_load_seq);
+	}
 
 	return delta;
 }
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

