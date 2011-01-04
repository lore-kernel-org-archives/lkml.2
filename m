Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1ADQDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:03:00 -0500
Received: from ms01.sssup.it ([193.205.80.99]:40469 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751162Ab1ADQC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:02:59 -0500
Subject: [RFC][PATCH 3/3] sched: beautify access to some common fields.
From: Dario Faggioli <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Darren Hart <darren@dvhart.com>, oleg <oleg@redhat.com>,
        paulmck <paulmck@linux.vnet.ibm.com>, pjt@google.com,
        bharata@linux.vnet.ibm.co, lucas.de.marchi@gmail.com
In-Reply-To: <1294156524.6169.147.camel@Palantir>
References: <1294156524.6169.147.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TsuLOgXVzRrih1FUv8ur"
Date: Tue, 04 Jan 2011 17:02:35 +0100
Message-ID: <1294156955.6169.152.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TsuLOgXVzRrih1FUv8ur
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fields like on_rq or statistics are accessed quite frequently
from CFS within implementation, although they're no longer part of
sched_cfs_entity (they're in the general sched_entity).

This commit provides some macros that makes the code which
deals with them a bit less cumbersome.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 kernel/sched_fair.c |  111 ++++++++++++++++++++++++++---------------------=
----
 1 files changed, 56 insertions(+), 55 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e9b8260..0c3006e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -107,6 +107,11 @@ static inline struct sched_entity *se_of_cfs_se(struct=
 sched_cfs_entity *cfs_se)
 	return container_of(cfs_se, struct sched_entity, cfs);
 }
=20
+static inline int cfs_se_on_rq(struct sched_cfs_entity *cfs_se)
+{
+	return se_of_cfs_se(cfs_se)->on_rq;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
=20
 /* cpu runqueue to which this cfs_rq is attached */
@@ -455,6 +460,8 @@ static struct sched_cfs_entity *__pick_last_entity(stru=
ct cfs_rq *cfs_rq)
  * Scheduling class statistics methods:
  */
=20
+#define cfs_se_statistics(cfs_se)	((se_of_cfs_se(cfs_se))->statistics)
+
 #ifdef CONFIG_SCHED_DEBUG
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
@@ -521,8 +528,7 @@ static u64 __sched_period(unsigned long nr_running)
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs=
_se)
 {
-	struct sched_entity *se =3D se_of_cfs_se(cfs_se);
-	u64 slice =3D __sched_period(cfs_rq->nr_running + !se->on_rq);
+	u64 slice =3D __sched_period(cfs_rq->nr_running + !cfs_se_on_rq(cfs_se));
=20
 	for_each_sched_cfs_entity(cfs_se) {
 		struct load_weight *load;
@@ -531,7 +537,7 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sc=
hed_cfs_entity *cfs_se)
 		cfs_rq =3D cfs_rq_of(cfs_se);
 		load =3D &cfs_rq->load;
=20
-		if (unlikely(!se_of_cfs_se(cfs_se)->on_rq)) {
+		if (unlikely(!cfs_se_on_rq(cfs_se))) {
 			lw =3D cfs_rq->load;
=20
 			update_load_add(&lw, cfs_se->load.weight);
@@ -564,13 +570,12 @@ static inline void
 __update_curr(struct cfs_rq *cfs_rq, struct sched_cfs_entity *curr,
 	      unsigned long delta_exec)
 {
-	struct sched_entity *curr_se =3D se_of_cfs_se(curr);
 	unsigned long delta_exec_weighted;
=20
-	schedstat_set(curr_se->statistics.exec_max,
-		      max((u64)delta_exec, curr_se->statistics.exec_max));
+	schedstat_set(cfs_se_statistics(curr).exec_max,
+		      max((u64)delta_exec, cfs_se_statistics(curr).exec_max));
=20
-	curr_se->sum_exec_runtime +=3D delta_exec;
+	se_of_cfs_se(curr)->sum_exec_runtime +=3D delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
 	delta_exec_weighted =3D calc_delta_fair(delta_exec, curr);
=20
@@ -616,7 +621,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cf=
s_se)
 {
-	schedstat_set(se_of_cfs_se(cfs_se)->statistics.wait_start,
+	schedstat_set(cfs_se_statistics(cfs_se).wait_start,
 		      rq_of(cfs_rq)->clock);
 }
=20
@@ -637,20 +642,20 @@ update_stats_enqueue(struct cfs_rq *cfs_rq, struct sc=
hed_cfs_entity *cfs_se)
 static void
 update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_=
se)
 {
+	schedstat_set(cfs_se_statistics(cfs_se).wait_max,
+		      max(cfs_se_statistics(cfs_se).wait_max,
+		      rq_of(cfs_rq)->clock - cfs_se_statistics(cfs_se).wait_start));
+	schedstat_set(cfs_se_statistics(cfs_se).wait_count,
+		      cfs_se_statistics(cfs_se).wait_count+1);
+	schedstat_set(cfs_se_statistics(cfs_se).wait_sum,
+		      cfs_se_statistics(cfs_se).wait_sum +
+		      rq_of(cfs_rq)->clock - cfs_se_statistics(cfs_se).wait_start);
 #ifdef CONFIG_SCHEDSTATS
-	/* #ifdef-ing like this suppresses a gcc warning */
-	struct sched_entity *se =3D se_of_cfs_se(cfs_se);
-
-	schedstat_set(se->statistics.wait_max, max(se->statistics.wait_max,
-		      rq_of(cfs_rq)->clock - se->statistics.wait_start));
-	schedstat_set(se->statistics.wait_count, se->statistics.wait_count+1);
-	schedstat_set(se->statistics.wait_sum, se->statistics.wait_sum +
-		      rq_of(cfs_rq)->clock - se->statistics.wait_start);
 	if (cfs_entity_is_task(cfs_se)) {
 		trace_sched_stat_wait(cfs_task_of(cfs_se), rq_of(cfs_rq)->clock -
-				      se->statistics.wait_start);
+				      cfs_se_statistics(cfs_se).wait_start);
 	}
-	schedstat_set(se->statistics.wait_start, 0);
+	schedstat_set(cfs_se_statistics(cfs_se).wait_start, 0);
 #endif
 }
=20
@@ -787,9 +792,7 @@ static void reweight_entity(struct cfs_rq *cfs_rq,
 			    struct sched_cfs_entity *cfs_se,
 			    unsigned long weight)
 {
-	struct sched_entity *se =3D se_of_cfs_se(cfs_se);
-
-	if (se->on_rq) {
+	if (cfs_se_on_rq(cfs_se)) {
 		/* commit outstanding execution time */
 		if (cfs_rq->curr =3D=3D cfs_se)
 			update_curr(cfs_rq);
@@ -798,7 +801,7 @@ static void reweight_entity(struct cfs_rq *cfs_rq,
=20
 	update_load_set(&cfs_se->load, weight);
=20
-	if (se->on_rq)
+	if (cfs_se_on_rq(cfs_se))
 		account_entity_enqueue(cfs_rq, cfs_se);
 }
=20
@@ -860,44 +863,45 @@ enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_c=
fs_entity *cfs_se)
 {
 #ifdef CONFIG_SCHEDSTATS
 	struct task_struct *tsk =3D NULL;
-	struct sched_entity *se =3D se_of_cfs_se(cfs_se);
=20
 	if (cfs_entity_is_task(cfs_se))
 		tsk =3D cfs_task_of(cfs_se);
=20
-	if (se->statistics.sleep_start) {
-		u64 delta =3D rq_of(cfs_rq)->clock - se->statistics.sleep_start;
+	if (cfs_se_statistics(cfs_se).sleep_start) {
+		u64 delta =3D rq_of(cfs_rq)->clock -
+			    cfs_se_statistics(cfs_se).sleep_start;
=20
 		if ((s64)delta < 0)
 			delta =3D 0;
=20
-		if (unlikely(delta > se->statistics.sleep_max))
-			se->statistics.sleep_max =3D delta;
+		if (unlikely(delta > cfs_se_statistics(cfs_se).sleep_max))
+			cfs_se_statistics(cfs_se).sleep_max =3D delta;
=20
-		se->statistics.sleep_start =3D 0;
-		se->statistics.sum_sleep_runtime +=3D delta;
+		cfs_se_statistics(cfs_se).sleep_start =3D 0;
+		cfs_se_statistics(cfs_se).sum_sleep_runtime +=3D delta;
=20
 		if (tsk) {
 			account_scheduler_latency(tsk, delta >> 10, 1);
 			trace_sched_stat_sleep(tsk, delta);
 		}
 	}
-	if (se->statistics.block_start) {
-		u64 delta =3D rq_of(cfs_rq)->clock - se->statistics.block_start;
+	if (cfs_se_statistics(cfs_se).block_start) {
+		u64 delta =3D rq_of(cfs_rq)->clock -
+			    cfs_se_statistics(cfs_se).block_start;
=20
 		if ((s64)delta < 0)
 			delta =3D 0;
=20
-		if (unlikely(delta > se->statistics.block_max))
-			se->statistics.block_max =3D delta;
+		if (unlikely(delta > cfs_se_statistics(cfs_se).block_max))
+			cfs_se_statistics(cfs_se).block_max =3D delta;
=20
-		se->statistics.block_start =3D 0;
-		se->statistics.sum_sleep_runtime +=3D delta;
+		cfs_se_statistics(cfs_se).block_start =3D 0;
+		cfs_se_statistics(cfs_se).sum_sleep_runtime +=3D delta;
=20
 		if (tsk) {
 			if (tsk->in_iowait) {
-				se->statistics.iowait_sum +=3D delta;
-				se->statistics.iowait_count++;
+				cfs_se_statistics(cfs_se).iowait_sum +=3D delta;
+				cfs_se_statistics(cfs_se).iowait_count++;
 				trace_sched_stat_iowait(tsk, delta);
 			}
=20
@@ -1031,12 +1035,11 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_=
cfs_entity *cfs_se,
 #ifdef CONFIG_SCHEDSTATS
 		if (cfs_entity_is_task(cfs_se)) {
 			struct task_struct *tsk =3D cfs_task_of(cfs_se);
-			struct sched_entity *se =3D se_of_cfs_se(cfs_se);
=20
 			if (tsk->state & TASK_INTERRUPTIBLE)
-				se->statistics.sleep_start =3D rq_of(cfs_rq)->clock;
+				cfs_se_statistics(cfs_se).sleep_start =3D rq_of(cfs_rq)->clock;
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
-				se->statistics.block_start =3D rq_of(cfs_rq)->clock;
+				cfs_se_statistics(cfs_se).block_start =3D rq_of(cfs_rq)->clock;
 		}
 #endif
 	}
@@ -1104,10 +1107,8 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sch=
ed_cfs_entity *curr)
 static void
 set_next_entity(struct cfs_rq *cfs_rq, struct sched_cfs_entity *cfs_se)
 {
-	struct sched_entity *se =3D se_of_cfs_se(cfs_se);
-
 	/* 'current' is not kept within the tree. */
-	if (se->on_rq) {
+	if (cfs_se_on_rq(cfs_se)) {
 		/*
 		 * Any task has to be enqueued before it get to execute on
 		 * a CPU. So account for the time it spent waiting on the
@@ -1126,11 +1127,13 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched=
_cfs_entity *cfs_se)
 	 * when there are only lesser-weight tasks around):
 	 */
 	if (rq_of(cfs_rq)->load.weight >=3D 2*cfs_se->load.weight) {
-		se->statistics.slice_max =3D max(se->statistics.slice_max,
-			se->sum_exec_runtime - se->prev_sum_exec_runtime);
+		cfs_se_statistics(cfs_se).slice_max =3D max(cfs_se_statistics(cfs_se).sl=
ice_max,
+			se_of_cfs_se(cfs_se)->sum_exec_runtime -
+			se_of_cfs_se(cfs_se)->prev_sum_exec_runtime);
 	}
 #endif
-	se->prev_sum_exec_runtime =3D se->sum_exec_runtime;
+	se_of_cfs_se(cfs_se)->prev_sum_exec_runtime =3D
+				se_of_cfs_se(cfs_se)->sum_exec_runtime;
 }
=20
 static int wakeup_preempt_entity(struct sched_cfs_entity *curr,
@@ -1158,17 +1161,15 @@ static struct sched_cfs_entity *pick_next_entity(st=
ruct cfs_rq *cfs_rq)
 static void
 put_prev_entity(struct cfs_rq *cfs_rq, struct sched_cfs_entity *prev)
 {
-	struct sched_entity *prev_se =3D se_of_cfs_se(prev);
-
 	/*
 	 * If still on the runqueue then deactivate_task()
 	 * was not called and update_curr() has to be done:
 	 */
-	if (prev_se->on_rq)
+	if (cfs_se_on_rq(prev))
 		update_curr(cfs_rq);
=20
 	check_spread(cfs_rq, prev);
-	if (prev_se->on_rq) {
+	if (cfs_se_on_rq(prev)) {
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
@@ -1279,11 +1280,11 @@ static inline void hrtick_update(struct rq *rq)
 static void
 enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
-	struct cfs_rq *cfs_rq;
 	struct sched_cfs_entity *cfs_se =3D &p->se.cfs;
+	struct cfs_rq *cfs_rq;
=20
 	for_each_sched_cfs_entity(cfs_se) {
-		if (se_of_cfs_se(cfs_se)->on_rq)
+		if (cfs_se_on_rq(cfs_se))
 			break;
 		cfs_rq =3D cfs_rq_of(cfs_se);
 		enqueue_entity(cfs_rq, cfs_se, flags);
@@ -1505,7 +1506,7 @@ static int wake_affine(struct sched_domain *sd, struc=
t task_struct *p, int sync)
 	if (sync && balanced)
 		return 1;
=20
-	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
+	schedstat_inc(p, cfs_se_statistics(cfs_se).nr_wakeups_affine_attempts);
 	tl_per_task =3D cpu_avg_load_per_task(this_cpu);
=20
 	if (balanced ||
@@ -1517,7 +1518,7 @@ static int wake_affine(struct sched_domain *sd, struc=
t task_struct *p, int sync)
 		 * there is no bad imbalance.
 		 */
 		schedstat_inc(sd, ttwu_move_affine);
-		schedstat_inc(p, se.statistics.nr_wakeups_affine);
+		schedstat_inc(p, cfs_se_statistics(cfs_se).nr_wakeups_affine);
=20
 		return 1;
 	}
@@ -1902,7 +1903,7 @@ preempt:
 	 * Also, during early boot the idle thread is in the fair class,
 	 * for obvious reasons its a bad idea to schedule back to it.
 	 */
-	if (unlikely(!se_of_cfs_se(cfs_se)->on_rq || curr =3D=3D rq->idle))
+	if (unlikely(!cfs_se_on_rq(cfs_se) || curr =3D=3D rq->idle))
 		return;
=20
 	if (sched_feat(LAST_BUDDY) && scale && cfs_entity_is_task(cfs_se))
--=20
1.7.2.3

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-TsuLOgXVzRrih1FUv8ur
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0jRJsACgkQk4XaBE3IOsRV+gCeK0n6cHcFI3De8qkTPlGuRyB8
tRsAoKj2WJbcoS9+pgqs3jxIa6CKLdWk
=ijN6
-----END PGP SIGNATURE-----

--=-TsuLOgXVzRrih1FUv8ur--

