Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1LTVU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 16:20:29 -0500
Received: from forward18.mail.yandex.net ([95.108.253.143]:46554 "EHLO
	forward18.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1LTVUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 16:20:22 -0500
X-Greylist: delayed 634 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Dec 2011 16:20:21 EST
X-Yandex-Spam: 1
From: Tkhai Kirill <tkhai@yandex.ru>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <203221324412916@web157.yandex.ru>
References: <1322774765.8386.2.camel@hp> <20111220174433.GA2018@redhat.com> <203221324412916@web157.yandex.ru>
Subject: Re: [PATCH]sched_rt.c: Avoid unnecessary dequeue and enqueue of pushable tasks in set_cpus_allowed_rt()
MIME-Version: 1.0
Message-Id: <324931324415384@web36.yandex.ru>
Date: Wed, 21 Dec 2011 01:09:44 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, right patch

21.12.2011, 00:28, "Tkhai Kirill" <tkhai@yandex.ru>:
> 20.12.2011, 21:44, "Oleg Nesterov" <oleg@redhat.com>:
>
>> šOn 12/02, Kirill Tkhai wrote:
>>> ššMigration status depends on a difference of weight from 0 and 1. If
>>> ššweight > 1 (<= 1) and old weight <= 1 (> 1) then task becomes pushable
>>> šš(not pushable). We are not insterested in exact values of it, is it 3 or
>>> šš4, for example.
>>>
>>> ššNow if we are changing affinity from a set of 3 cpus to a set of 4, the
>>> šštask will be dequeued and enqueued sequentially without important
>>> ššdifference in comparison with initial state. The only difference is in
>>> ššinternal representation of plist queue of pushable tasks and the fact
>>> ššthat the task may won't be the first in a sequence of the same priority
>>> šštasks. But it seems to me it gives nothing.
>> šLooks reasonable, although I can't say I really understand this code.
>> šAdd Gregory.
>>> ššSigned-off-by: Tkhai Kirill <tkhai@yandex.ru>
>>>
>>> šš--- kernel/sched_rt.c.orig 2011-12-02 00:29:11.970243145 +0400
>>> šš+++ kernel/sched_rt.c 2011-12-02 00:37:43.622846606 +0400
>> šplease use -p1
>
> Sorry, this time I'm sending "git diffed" output.
>
>>> šš@@ -1572,43 +1572,37 @@ static void set_cpus_allowed_rt(struct t
>>> šššššššššššššššššššššššššššššššššššconst struct cpumask *new_mask)
>>> ššš{
>>> šššššššššššint weight = cpumask_weight(new_mask);
>>> šš+ struct rq *rq;
>>>
>>> šššššššššššBUG_ON(!rt_task(p));
>>>
>>> ššššššššššš/*
>>> šš- * Update the migration status of the RQ if we have an RT task
>>> šš- * which is running AND changing its weight value.
>>> šš+ * Just exit if it's not necessary to change migration status
>>> šššššššššššš*/
>>> šš- if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
>>> šš- struct rq *rq = task_rq(p);
>>> šš+ if ((p->rt.nr_cpus_allowed <= 1 && weight <= 1)
>>> šš+ || (p->rt.nr_cpus_allowed > 1 && weight > 1))
>>> šš+ return;
>> šSubjective, but may be
>>
>> šššššššššif ((p->rt.nr_cpus_allowed > 1) != (weight > 1))
>> šššššššššššššššššreturn;
>>
>> šlooks more understandable?
>
> Yes, thanks.
>
> ---
>
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 3640ebb..4467f4d 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1774,43 +1774,36 @@ static void set_cpus_allowed_rt(struct task_struct *p,
> šššššššššššššššššššššššššššššššššconst struct cpumask *new_mask)
> š{
> šššššššššint weight = cpumask_weight(new_mask);
> + struct rq *rq;
>
> šššššššššBUG_ON(!rt_task(p));
>
> ššššššššš/*
> - * Update the migration status of the RQ if we have an RT task
> - * which is running AND changing its weight value.
> + * Just exit if it's not necessary to change migration status
> šššššššššš*/
> - if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
> - struct rq *rq = task_rq(p);
> -
> - if (!task_current(rq, p)) {
> - /*
> - * Make sure we dequeue this task from the pushable list
> - * before going further. šIt will either remain off of
> - * the list because we are no longer pushable, or it
> - * will be requeued.
> - */
> - if (p->rt.nr_cpus_allowed > 1)
> - dequeue_pushable_task(rq, p);
> -
> - /*
> - * Requeue if our weight is changing and still > 1
> - */
> - if (weight > 1)
> - enqueue_pushable_task(rq, p);
> + if ((p->rt.nr_cpus_allowed > 1) != (weight > 1))
> + return;
>
> - }
> + if (!p->on_rq)
> + return;
>
> - if ((p->rt.nr_cpus_allowed <= 1) && (weight > 1)) {
> - rq->rt.rt_nr_migratory++;
> - } else if ((p->rt.nr_cpus_allowed > 1) && (weight <= 1)) {
> - BUG_ON(!rq->rt.rt_nr_migratory);
> - rq->rt.rt_nr_migratory--;
> - }
> + rq = task_rq(p);
>
> - update_rt_migration(&rq->rt);
> + /*
> + * Several cpus were allowed but now it's not so OR vice versa
> + */
> + if (weight <= 1) {
> + if (!task_current(rq, p))
> + dequeue_pushable_task(rq, p);
> + BUG_ON(!rq->rt.rt_nr_migratory);
> + rq->rt.rt_nr_migratory--;
> + } else {
> + if (!task_current(rq, p))
> + enqueue_pushable_task(rq, p);
> + rq->rt.rt_nr_migratory++;
> ššššššššš}
> +
> + update_rt_migration(&rq->rt);
> š}
>
> š/* Assumes rq->lock is held */

---

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 3640ebb..bf48343 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1774,43 +1774,36 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 				const struct cpumask *new_mask)
 {
 	int weight = cpumask_weight(new_mask);
+	struct rq *rq;
 
 	BUG_ON(!rt_task(p));
 
 	/*
-	 * Update the migration status of the RQ if we have an RT task
-	 * which is running AND changing its weight value.
+	 * Just exit if it's not necessary to change migration status
 	 */
-	if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
-		struct rq *rq = task_rq(p);
-
-		if (!task_current(rq, p)) {
-			/*
-			 * Make sure we dequeue this task from the pushable list
-			 * before going further.  It will either remain off of
-			 * the list because we are no longer pushable, or it
-			 * will be requeued.
-			 */
-			if (p->rt.nr_cpus_allowed > 1)
-				dequeue_pushable_task(rq, p);
-
-			/*
-			 * Requeue if our weight is changing and still > 1
-			 */
-			if (weight > 1)
-				enqueue_pushable_task(rq, p);
+	if ((p->rt.nr_cpus_allowed > 1) == (weight > 1))
+		return;
 
-		}
+	if (!p->on_rq)
+		return;
 
-		if ((p->rt.nr_cpus_allowed <= 1) && (weight > 1)) {
-			rq->rt.rt_nr_migratory++;
-		} else if ((p->rt.nr_cpus_allowed > 1) && (weight <= 1)) {
-			BUG_ON(!rq->rt.rt_nr_migratory);
-			rq->rt.rt_nr_migratory--;
-		}
+	rq = task_rq(p);
 
-		update_rt_migration(&rq->rt);
+	/*
+	 * Several cpus were allowed but now it's not so OR vice versa
+	 */
+	if (weight <= 1) {
+		if (!task_current(rq, p))
+			dequeue_pushable_task(rq, p);
+		BUG_ON(!rq->rt.rt_nr_migratory);
+		rq->rt.rt_nr_migratory--;
+	} else {
+		if (!task_current(rq, p))
+			enqueue_pushable_task(rq, p);
+		rq->rt.rt_nr_migratory++;
 	}
+
+	update_rt_migration(&rq->rt);
 }
 
 /* Assumes rq->lock is held */
