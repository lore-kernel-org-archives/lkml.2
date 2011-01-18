Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1ARIS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 03:18:29 -0500
Received: from mgw-da01.ext.nokia.com ([147.243.128.24]:46668 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1ARIS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 03:18:28 -0500
Subject: Re: Bug in scheduler when using rt_mutex
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, "Onkalo Samu.P" <samu.p.onkalo@nokia.com>
In-Reply-To: <1295280032.30950.128.camel@laptop>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Tue, 18 Jan 2011 10:23:32 +0200
Message-ID: <1295339012.11678.35.camel@kolo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 17:00 +0100, ext Peter Zijlstra wrote:
> On Mon, 2011-01-17 at 16:42 +0200, Onkalo Samu wrote:
> > 
> > Failure case:
> > - user process locks rt_mutex
> > - and goes to sleep (wait_for_completion etc.)
> > - user process is dequeued to sleep state
> > -> vruntime is not updated in dequeue_entity
> > 
> 
> Does the below (completely untested) patch help?

Unfortunately no. User process is still stucked.
It is stucked for about the time equal to min_vruntime.

Background of the rt_mutex in i2c-core:

http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg01631.html

In phones the touch screen controller can be connected to I2C which makes it very timing sensitive.

The patch below shows what goes wrong and at least it corrects the case 
what I can see.

Idea is to reset vruntime to min_runtime when the task goes back from rt to cfs queue.

-Samu

---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   12 +++++++++---
 kernel/sched_fair.c   |    8 ++++++++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..1c7f873 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1049,6 +1049,7 @@ struct sched_domain;
 #define ENQUEUE_WAKEUP		1
 #define ENQUEUE_WAKING		2
 #define ENQUEUE_HEAD		4
+#define ENQUEUE_FROM_RTMUTEX    8
 
 #define DEQUEUE_SLEEP		1
 
diff --git a/kernel/sched.c b/kernel/sched.c
index ea3e5ef..4724e25 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4544,6 +4544,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 {
 	unsigned long flags;
 	int oldprio, on_rq, running;
+	int enqueue_flags = 0;
 	struct rq *rq;
 	const struct sched_class *prev_class;
 
@@ -4561,17 +4562,22 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	if (rt_prio(prio))
+	if (rt_prio(prio)) {
 		p->sched_class = &rt_sched_class;
-	else
+	} else {
 		p->sched_class = &fair_sched_class;
+		if (p->sched_class != prev_class)
+			enqueue_flags = ENQUEUE_FROM_RTMUTEX;
+	}
 
 	p->prio = prio;
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
+
+		enqueue_task(rq, p, (oldprio < prio ? ENQUEUE_HEAD : 0) |
+			enqueue_flags);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c62ebae..ff670b4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -941,6 +941,14 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 static void
 enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
+
+	/*
+	 * vruntime may be incorrect if coming from rt to non rt priority.
+	 * Reset vruntime so that it has some valid value. WAKE* flags are not
+	 * set in this case.
+	 */
+	if (unlikely(flags & ENQUEUE_FROM_RTMUTEX))
+		se->vruntime = 0;
 	/*
 	 * Update the normalized vruntime before updating min_vruntime
 	 * through callig update_curr().
-- 


> 
> ---
>  kernel/sched.c      |    6 +++++-
>  kernel/sched_fair.c |   11 +++++++++++
>  2 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index a0eb094..be09581 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8108,8 +8108,10 @@ EXPORT_SYMBOL(__might_sleep);
>  #ifdef CONFIG_MAGIC_SYSRQ
>  static void normalize_task(struct rq *rq, struct task_struct *p)
>  {
> +	struct sched_class *prev_class = p->sched_class;
> +	int old_prio = p->prio;
>  	int on_rq;
> -
> +       
>  	on_rq = p->se.on_rq;
>  	if (on_rq)
>  		deactivate_task(rq, p, 0);
> @@ -8118,6 +8120,8 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
>  		activate_task(rq, p, 0);
>  		resched_task(rq->curr);
>  	}
> +
> +	check_class_changed(rq, p, prev_class, old_prio, task_current(rq, p));
>  }
>  
>  void normalize_rt_tasks(void)
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index c62ebae..0a27b00 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -4072,6 +4072,17 @@ static void prio_changed_fair(struct rq *rq, struct task_struct *p,
>  static void switched_to_fair(struct rq *rq, struct task_struct *p,
>  			     int running)
>  {
> +	struct sched_entity *se = &p->se;
> +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +
> +	if (se->on_rq && cfs_rq->curr != se)
> +		__dequeue_entity(cfs_rq, se);
> +
> +	place_entity(cfs_rq, se, 0);
> +
> +	if (se->on_rq && cfs_rq->curr != se)
> +		__enqueue_entity(cfs_rq, se);
> +
>  	/*
>  	 * We were most likely switched from sched_rt, so
>  	 * kick off the schedule if running, otherwise just see
> 


