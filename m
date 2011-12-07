Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1LGEKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 23:10:11 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:32818 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1LGEKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 23:10:10 -0500
Date: Wed, 7 Dec 2011 15:09:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Glauber Costa <glommer@parallels.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: linux-next: manual merge of the tip tree with the cputime tree
Message-Id: <20111207150956.52d41fd8580de3b66abd5d2d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Dec_2011_15_09_56_+1100_1yGplJCjE2ekCAGW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Dec_2011_15_09_56_+1100_1yGplJCjE2ekCAGW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got conflicts in
kernel/sched/core.c, fs/proc/uptime.c, fs/proc/stat.c,
drivers/cpufreq/cpufreq_conservative.c,
drivers/cpufreq/cpufreq_ondemand.c and drivers/macintosh/rack-meter.c
between commit c5927fe412bf ("[S390] cputime: add sparse checking and
cleanup") from the cputime tree and commit 3292beb340c7
("sched/accounting: Change cpustat fields to an array") from the tip tree.

I fixed it up (I hope - see below) and can carry the fix as necessary.  (I
used the tip version of fs/proc/uptime.c, fs/proc/stat.c and
drivers/macintosh/rack-meter.c).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sched/core.c
index 18cad44,3c5b21e..0000000
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@@ -2166,7 -935,7 +935,7 @@@ static int irqtime_account_hi_update(vo
 =20
  	local_irq_save(flags);
  	latest_ns =3D this_cpu_read(cpu_hardirq_time);
- 	if (nsecs_to_cputime64(latest_ns) > cpustat->irq)
 -	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat[CPUTIME_IRQ]))
++	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_IRQ])
  		ret =3D 1;
  	local_irq_restore(flags);
  	return ret;
@@@ -2181,7 -950,7 +950,7 @@@ static int irqtime_account_si_update(vo
 =20
  	local_irq_save(flags);
  	latest_ns =3D this_cpu_read(cpu_softirq_time);
- 	if (nsecs_to_cputime64(latest_ns) > cpustat->softirq)
 -	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat[CPUTIME_SOFTIRQ]=
))
++	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_SOFTIRQ])
  		ret =3D 1;
  	local_irq_restore(flags);
  	return ret;
@@@ -3867,20 -2633,18 +2633,18 @@@ static inline void task_group_account_f
  void account_user_time(struct task_struct *p, cputime_t cputime,
  		       cputime_t cputime_scaled)
  {
- 	struct cpu_usage_stat *cpustat =3D &kstat_this_cpu.cpustat;
+ 	int index;
 =20
  	/* Add user time to process. */
 -	p->utime =3D cputime_add(p->utime, cputime);
 -	p->utimescaled =3D cputime_add(p->utimescaled, cputime_scaled);
 +	p->utime +=3D cputime;
 +	p->utimescaled +=3D cputime_scaled;
  	account_group_user_time(p, cputime);
 =20
+ 	index =3D (TASK_NICE(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
+=20
  	/* Add user time to cpustat. */
- 	if (TASK_NICE(p) > 0)
- 		cpustat->nice +=3D (__force cputime64_t) cputime;
- 	else
- 		cpustat->user +=3D (__force cputime64_t) cputime;
 -	task_group_account_field(p, index, cputime);
++	task_group_account_field(p, index, (__force cputime64_t) cputime);
 =20
- 	cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
  	/* Account for user time used */
  	acct_update_integrals(p);
  }
@@@ -3894,21 -2658,24 +2658,21 @@@
  static void account_guest_time(struct task_struct *p, cputime_t cputime,
  			       cputime_t cputime_scaled)
  {
- 	struct cpu_usage_stat *cpustat =3D &kstat_this_cpu.cpustat;
 -	u64 tmp;
+ 	u64 *cpustat =3D kcpustat_this_cpu->cpustat;
 =20
 -	tmp =3D cputime_to_cputime64(cputime);
 -
  	/* Add guest time to process. */
 -	p->utime =3D cputime_add(p->utime, cputime);
 -	p->utimescaled =3D cputime_add(p->utimescaled, cputime_scaled);
 +	p->utime +=3D cputime;
 +	p->utimescaled +=3D cputime_scaled;
  	account_group_user_time(p, cputime);
 -	p->gtime =3D cputime_add(p->gtime, cputime);
 +	p->gtime +=3D cputime;
 =20
  	/* Add guest time to cpustat. */
  	if (TASK_NICE(p) > 0) {
- 		cpustat->nice +=3D (__force cputime64_t) cputime;
- 		cpustat->guest_nice +=3D (__force cputime64_t) cputime;
 -		cpustat[CPUTIME_NICE] +=3D tmp;
 -		cpustat[CPUTIME_GUEST_NICE] +=3D tmp;
++		cpustat[CPUTIME_NICE] +=3D (__force cputime64_t) cputime;
++		cpustat[CPUTIME_GUEST_NICE] +=3D (__force cputime64_t) cputime;
  	} else {
- 		cpustat->user +=3D (__force cputime64_t) cputime;
- 		cpustat->guest +=3D (__force cputime64_t) cputime;
 -		cpustat[CPUTIME_USER] +=3D tmp;
 -		cpustat[CPUTIME_GUEST] +=3D tmp;
++		cpustat[CPUTIME_USER] +=3D (__force cputime64_t) cputime;
++		cpustat[CPUTIME_GUEST] +=3D (__force cputime64_t) cputime;
  	}
  }
 =20
@@@ -3921,16 -2688,15 +2685,15 @@@
   */
  static inline
  void __account_system_time(struct task_struct *p, cputime_t cputime,
- 			cputime_t cputime_scaled, cputime64_t *target_cputime64)
+ 			cputime_t cputime_scaled, int index)
  {
  	/* Add system time to process. */
 -	p->stime =3D cputime_add(p->stime, cputime);
 -	p->stimescaled =3D cputime_add(p->stimescaled, cputime_scaled);
 +	p->stime +=3D cputime;
 +	p->stimescaled +=3D cputime_scaled;
  	account_group_system_time(p, cputime);
 =20
  	/* Add system time to cpustat. */
- 	*target_cputime64 +=3D (__force cputime64_t) cputime;
- 	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
 -	task_group_account_field(p, index, cputime);
++	task_group_account_field(p, index, (__force cputime64_t) cputime);
 =20
  	/* Account for system time used */
  	acct_update_integrals(p);
@@@ -3970,9 -2735,10 +2732,9 @@@ void account_system_time(struct task_st
   */
  void account_steal_time(cputime_t cputime)
  {
- 	struct cpu_usage_stat *cpustat =3D &kstat_this_cpu.cpustat;
+ 	u64 *cpustat =3D kcpustat_this_cpu->cpustat;
 -	u64 cputime64 =3D cputime_to_cputime64(cputime);
 =20
- 	cpustat->steal +=3D (__force cputime64_t) cputime;
 -	cpustat[CPUTIME_STEAL] +=3D cputime64;
++	cpustat[CPUTIME_STEAL] +=3D (__force cputime64_t) cputime;
  }
 =20
  /*
@@@ -3981,13 -2747,14 +2743,13 @@@
   */
  void account_idle_time(cputime_t cputime)
  {
- 	struct cpu_usage_stat *cpustat =3D &kstat_this_cpu.cpustat;
+ 	u64 *cpustat =3D kcpustat_this_cpu->cpustat;
  	struct rq *rq =3D this_rq();
 =20
  	if (atomic_read(&rq->nr_iowait) > 0)
- 		cpustat->iowait +=3D (__force cputime64_t) cputime;
 -		cpustat[CPUTIME_IOWAIT] +=3D cputime64;
++		cpustat[CPUTIME_IOWAIT] +=3D (__force cputime64_t) cputime;
  	else
- 		cpustat->idle +=3D (__force cputime64_t) cputime;
 -		cpustat[CPUTIME_IDLE] +=3D cputime64;
++		cpustat[CPUTIME_IDLE] +=3D (__force cputime64_t) cputime;
  }
 =20
  static __always_inline bool steal_account_process_tick(void)
@@@ -4037,15 -2804,16 +2799,15 @@@ static void irqtime_account_process_tic
  						struct rq *rq)
  {
  	cputime_t one_jiffy_scaled =3D cputime_to_scaled(cputime_one_jiffy);
- 	struct cpu_usage_stat *cpustat =3D &kstat_this_cpu.cpustat;
 -	u64 tmp =3D cputime_to_cputime64(cputime_one_jiffy);
+ 	u64 *cpustat =3D kcpustat_this_cpu->cpustat;
 =20
  	if (steal_account_process_tick())
  		return;
 =20
  	if (irqtime_account_hi_update()) {
- 		cpustat->irq +=3D (__force cputime64_t) cputime_one_jiffy;
 -		cpustat[CPUTIME_IRQ] +=3D tmp;
++		cpustat[CPUTIME_IRQ] +=3D (__force cputime64_t) cputime_one_jiffy;
  	} else if (irqtime_account_si_update()) {
- 		cpustat->softirq +=3D (__force cputime64_t) cputime_one_jiffy;
 -		cpustat[CPUTIME_SOFTIRQ] +=3D tmp;
++		cpustat[CPUTIME_SOFTIRQ] +=3D (__force cputime64_t) cputime_one_jiffy;
  	} else if (this_cpu_ksoftirqd() =3D=3D p) {
  		/*
  		 * ksoftirqd time do not get accounted in cpu_softirq_time.
diff --cc drivers/cpufreq/cpufreq_conservative.c
index 7f31a03,118bff7..0000000
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@@ -95,26 -95,26 +95,26 @@@ static struct dbs_tuners=20
  	.freq_step =3D 5,
  };
 =20
- static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
- 							cputime64_t *wall)
+ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
  {
- 	cputime64_t idle_time;
+ 	u64 idle_time;
  	cputime64_t cur_wall_time;
- 	cputime64_t busy_time;
+ 	u64 busy_time;
 =20
  	cur_wall_time =3D jiffies64_to_cputime64(get_jiffies_64());
- 	busy_time  =3D kstat_cpu(cpu).cpustat.user;
- 	busy_time +=3D kstat_cpu(cpu).cpustat.system;
- 	busy_time +=3D kstat_cpu(cpu).cpustat.irq;
- 	busy_time +=3D kstat_cpu(cpu).cpustat.softirq;
- 	busy_time +=3D kstat_cpu(cpu).cpustat.steal;
- 	busy_time +=3D kstat_cpu(cpu).cpustat.nice;
+ 	busy_time =3D kcpustat_cpu(cpu).cpustat[CPUTIME_USER] +
+ 		    kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
+=20
+ 	busy_time +=3D kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
+ 	busy_time +=3D kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
+ 	busy_time +=3D kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
+ 	busy_time +=3D kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
 =20
 -	idle_time =3D cputime64_sub(cur_wall_time, busy_time);
 +	idle_time =3D cur_wall_time - busy_time;
  	if (wall)
- 		*wall =3D (cputime64_t)jiffies_to_usecs(cur_wall_time);
+ 		*wall =3D jiffies_to_usecs(cur_wall_time);
 =20
- 	return (cputime64_t)jiffies_to_usecs(idle_time);
+ 	return jiffies_to_usecs(idle_time);
  }
 =20
  static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t=
 *wall)
diff --cc drivers/cpufreq/cpufreq_ondemand.c
index 07cffe2,f3d327c..0000000
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@@ -119,26 -119,26 +119,26 @@@ static struct dbs_tuners=20
  	.powersave_bias =3D 0,
  };
 =20
- static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
- 							cputime64_t *wall)
+ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
  {
- 	cputime64_t idle_time;
+ 	u64 idle_time;
  	cputime64_t cur_wall_time;
- 	cputime64_t busy_time;
+ 	u64 busy_time;
 =20
  	cur_wall_time =3D jiffies64_to_cputime64(get_jiffies_64());
- 	busy_time  =3D kstat_cpu(cpu).cpustat.user;
- 	busy_time +=3D kstat_cpu(cpu).cpustat.system;
- 	busy_time +=3D kstat_cpu(cpu).cpustat.irq;
- 	busy_time +=3D kstat_cpu(cpu).cpustat.softirq;
- 	busy_time +=3D kstat_cpu(cpu).cpustat.steal;
- 	busy_time +=3D kstat_cpu(cpu).cpustat.nice;
+ 	busy_time =3D kcpustat_cpu(cpu).cpustat[CPUTIME_USER] +
+ 		    kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
+=20
+ 	busy_time +=3D kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
+ 	busy_time +=3D kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
+ 	busy_time +=3D kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
+ 	busy_time +=3D kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
 =20
 -	idle_time =3D cputime64_sub(cur_wall_time, busy_time);
 +	idle_time =3D cur_wall_time - busy_time;
  	if (wall)
- 		*wall =3D (cputime64_t)jiffies_to_usecs(cur_wall_time);
+ 		*wall =3D jiffies_to_usecs(cur_wall_time);
 =20
- 	return (cputime64_t)jiffies_to_usecs(idle_time);
+ 	return jiffies_to_usecs(idle_time);
  }
 =20
  static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t=
 *wall)

--Signature=_Wed__7_Dec_2011_15_09_56_+1100_1yGplJCjE2ekCAGW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3ucUAAoJEECxmPOUX5FEFVEQAJL0+64IyFrr9OnwT0gHzkcI
e+OALmqR5SwkQYV813vaCU5l+fQC5lWmz0FiI4SC8p6GRtO28Fhr1/Y8ft8kNEx+
7iFqXJd4QJcVK06OfB+lghqR7P5dW6A8TN+T4TqJ4RVnSoD9Mcd9fjPtYvBkY+7j
RQX6Qvdb8IBYc+YzYNwI5PLsoy7NQWpVABVFTavAW6ABm5hLOvHuu8cAVZ1OfbFw
xIIJuMatg1/0U55Mx5AUyszYjg5XUyRSunmqbIdJRlJCbFBDBzqcGWgVJhf8ms4U
B914HYh7CtYwywlOGHlSaonK7XXHj1SkGssIUcoAuEIgq45T/0tfnRcSXJvSEage
Slv7wkY0IgK3cYK67pFhraqg7QfP1NQg/f2UWIeLwtBzxat/Ii6/Wf8/nGwrkLyk
v44HGthDrtoExPKm8TwbHpPQOj4ZbTprhMTrax7moLdAqSjZcUx+vyPHrAusWwS7
ljua1AK+KfYCN0BKyEg9+Z9vxkbRFBrhMqVNl7VcY7ipd5RlHB7nv2ECqrRiT2av
l7jOmvRmChdDqWguHKXW1J1cGBlGFu0NkEEBemXiXStCkMSU30yZ/jmHMD1ZnSCw
HG8RFsNGVqxr2yxRbjFR+NMzfRA7u4A+GxkCqh9ZS5epEH9hrKWI0BRRCebAMvch
3dLO9O5fKfRtDH+7rKr/
=EA2H
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Dec_2011_15_09_56_+1100_1yGplJCjE2ekCAGW--
