Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab0J2Gkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:40:45 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:22217 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752520Ab0J2Gkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:40:39 -0400
Subject: [RFC][PATCH 17/22] sched: add signaling overrunning -deadline
 tasks.
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333128.8661.137.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6HDrJI3ckwMLPY4BJKyk"
Date: Fri, 29 Oct 2010 08:40:28 +0200
Message-ID: <1288334428.8661.158.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6HDrJI3ckwMLPY4BJKyk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Add to the scheduler the capability of notifying when -deadline tasks
overrun their maximum runtime and/or overcome their scheduling
deadline.

Runtime overruns might be quite common, e.g., due to coarse granularity
execution time accounting resolution or wrong assignment of tasks'
parameters (especially runtime). However, since the scheduler enforces
bandwidth isolation among tasks, this is not at all a threat to other
tasks' schedulability. For this reason, it is not common that a task
wants to be notified about that. Moreover, if we are using the
SCHED_DEADLINE policy with sporadic tasks, or to limit the bandwidth
of not periodic nor sporadic ones, runtime overruns are very likely
to occur at each and every instance, and again they should not be
considered a problem.

On the other hand, a deadline miss in any task means that, even if we
are trying at our best to keep each task isolated and to avoid
reciprocal interference among them, something went very, very bad,
and one task did not manage in consuming its runtime by its deadline.
This is something that should happen only on an oversubscribed
system, and thus being notified when it occurs could be very useful.

The user can specify the signal(s) he wants to be sent to his task
during sched_setscheduler_ex(), raising two specific flags in the
sched_flags field of struct sched_param_ex:
 * SF_SIG_RORUN (if he wants to be signaled on runtime overrun),
 * SF_SIG_DMISS (if he wants to be signaled on deadline misses).

This patch:
 - adds the logic needed to send SIGXCPU signal to a -deadline task
   in case its actual runtime becomes negative;
 - adds the logic needed to send SIGXCPU signal to a -deadline task
   in case it is still being scheduled while its absolute deadline
   passes.

This all happens in the POSIX cpu-timers code, we need to take
t->sighand->siglock, and it can't be done within the scheduler,
under task_rq(t)->lock.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h     |   14 ++++++++++-
 kernel/posix-cpu-timers.c |   55 +++++++++++++++++++++++++++++++++++++++++=
++++
 kernel/sched_debug.c      |    2 +
 kernel/sched_dl.c         |    8 +++++-
 4 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b6f0635..b729f83 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -163,8 +163,19 @@ struct sched_param_ex {
  *              of the highest priority scheduling class. In case it
  *              it sched_deadline, the task also ignore runtime and
  *              bandwidth limitations.
+ *
+ * These flags here below are meant to be used by userspace tasks to affec=
t
+ * the scheduler behaviour and/or specifying that they want to be informed
+ * of the occurrence of some events.
+ *
+ *  @SF_SIG_RORUN       tells us the task wants to be notified whenever
+ *                      a runtime overrun occurs;
+ *  @SF_SIG_DMISS       tells us the task wants to be notified whenever
+ *                      a scheduling deadline is missed.
  */
 #define SF_HEAD		1
+#define SF_SIG_RORUN	2
+#define SF_SIG_DMISS	4
=20
 struct exec_domain;
 struct futex_pi_state;
@@ -1243,9 +1254,10 @@ struct sched_rt_entity {
 };
=20
 struct sched_stats_dl {
-#ifdef CONFIG_SCHEDSTATS
+	int			dmiss, rorun;
 	u64			last_dmiss;
 	u64			last_rorun;
+#ifdef CONFIG_SCHEDSTATS
 	u64			dmiss_max;
 	u64			rorun_max;
 #endif
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 6842eeb..610b8b1 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -901,6 +901,37 @@ void posix_cpu_timer_get(struct k_itimer *timer, struc=
t itimerspec *itp)
 }
=20
 /*
+ * Inform a -deadline task that it is overrunning its runtime or
+ * (much worse) missing a deadline. This is done by sending the task
+ * SIGXCPU, with some additional information to let it discover
+ * what actually happened.
+ *
+ * The nature of the violation is coded in si_errno, while an attempt
+ * to let the task know *how big* the violation is is done through
+ * si_value. Unfortunately, only an int field is available there,
+ * thus what reported might be inaccurate.
+ */
+static inline void __dl_signal(struct task_struct *tsk, int which)
+{
+	struct siginfo info;
+	long long amount =3D which =3D=3D SF_SIG_DMISS ? tsk->dl.stats.last_dmiss=
 :
+			   tsk->dl.stats.last_rorun;
+
+	info.si_signo =3D SIGXCPU;
+	info.si_errno =3D which;
+	info.si_code =3D SI_KERNEL;
+	info.si_pid =3D 0;
+	info.si_uid =3D 0;
+	info.si_value.sival_int =3D (int)amount;
+
+	/* Correctly take the locks on task's sighand */
+	__group_send_sig_info(SIGXCPU, &info, tsk);
+	/* Log what happened to dmesg */
+	printk(KERN_INFO "SCHED_DEADLINE: 0x%4x by %Ld [ns] in %d (%s)\n",
+	       which, amount, task_pid_nr(tsk), tsk->comm);
+}
+
+/*
  * Check for any per-thread CPU timers that have fired and move them off
  * the tsk->cpu_timers[N] list onto the firing list.  Here we update the
  * tsk->it_*_expires values to reflect the remaining thread CPU timers.
@@ -958,6 +989,25 @@ static void check_thread_timers(struct task_struct *ts=
k,
 	}
=20
 	/*
+	 * if the userspace asked for that, we notify about (scheduling)
+	 * deadline misses and runtime overruns via sending SIGXCPU to
+	 * "faulting" task.
+	 *
+	 * Note that (hopefully small) runtime overruns are very likely
+	 * to occur, mainly due to accounting resolution, while missing a
+	 * scheduling deadline should be very rare, and only happen on
+	 * an oversubscribed systems.
+	 *
+	 */
+	if (unlikely(dl_task(tsk))) {
+		if ((tsk->dl.flags & SF_SIG_DMISS) && tsk->dl.stats.dmiss)
+			__dl_signal(tsk, SF_SIG_DMISS);
+		if ((tsk->dl.flags & SF_SIG_RORUN) && tsk->dl.stats.rorun)
+			__dl_signal(tsk, SF_SIG_RORUN);
+		tsk->dl.stats.dmiss =3D tsk->dl.stats.rorun =3D 0;
+	}
+
+	/*
 	 * Check for the special case thread timers.
 	 */
 	soft =3D ACCESS_ONCE(sig->rlim[RLIMIT_RTTIME].rlim_cur);
@@ -1272,6 +1322,11 @@ static inline int fastpath_timer_check(struct task_s=
truct *tsk)
 {
 	struct signal_struct *sig;
=20
+	if (unlikely(dl_task(tsk) &&
+	    (((tsk->dl.flags & SF_SIG_DMISS) && tsk->dl.stats.dmiss) ||
+	     ((tsk->dl.flags & SF_SIG_RORUN) && tsk->dl.stats.rorun))))
+		return 1;
+
 	if (!task_cputime_zero(&tsk->cputime_expires)) {
 		struct task_cputime task_sample =3D {
 			.utime =3D tsk->utime,
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 9bec524..4949a21 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -468,8 +468,10 @@ void proc_sched_show_task(struct task_struct *p, struc=
t seq_file *m)
 	P(se.statistics.nr_wakeups_passive);
 	P(se.statistics.nr_wakeups_idle);
 	if (dl_task(p)) {
+		P(dl.stats.dmiss);
 		PN(dl.stats.last_dmiss);
 		PN(dl.stats.dmiss_max);
+		P(dl.stats.rorun);
 		PN(dl.stats.last_rorun);
 		PN(dl.stats.rorun_max);
 		PN(dl.stats.tot_rtime);
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index cc87949..eff183a 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -491,14 +491,18 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_d=
l_entity *dl_se)
 	if (dmiss) {
 		u64 damount =3D rq->clock - dl_se->deadline;
=20
-		schedstat_set(dl_se->stats.last_dmiss, damount);
+		dl_se->stats.dmiss =3D 1;
+		dl_se->stats.last_dmiss =3D damount;
+
 		schedstat_set(dl_se->stats.dmiss_max,
 			      max(dl_se->stats.dmiss_max, damount));
 	}
 	if (rorun) {
 		u64 ramount =3D -dl_se->runtime;
=20
-		schedstat_set(dl_se->stats.last_rorun, ramount);
+		dl_se->stats.rorun =3D 1;
+		dl_se->stats.last_rorun =3D ramount;
+
 		schedstat_set(dl_se->stats.rorun_max,
 			      max(dl_se->stats.rorun_max, ramount));
 	}
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-6HDrJI3ckwMLPY4BJKyk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKbFwACgkQk4XaBE3IOsQcDACfTIcCMkqN93+1JZuJh1x25mx3
eLUAoINBlqMzWB+Yq6TbCdydsfR+wapi
=2KeR
-----END PGP SIGNATURE-----

--=-6HDrJI3ckwMLPY4BJKyk--

