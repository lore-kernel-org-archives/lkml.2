Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab1LFJya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:54:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab1LFJy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:54:28 -0500
Date: Tue, 6 Dec 2011 01:54:13 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-69e1e811dcc436a6b129dbef273ad9ec22d095ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111202010832.555984323@sbsiddha-desk.sc.intel.com>
References: <20111202010832.555984323@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, nohz: Track nr_busy_cpus in the sched_group_power
Git-Commit-ID: 69e1e811dcc436a6b129dbef273ad9ec22d095ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:54:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69e1e811dcc436a6b129dbef273ad9ec22d095ce
Gitweb:     http://git.kernel.org/tip/69e1e811dcc436a6b129dbef273ad9ec22d095ce
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 1 Dec 2011 17:07:33 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 09:06:32 +0100

sched, nohz: Track nr_busy_cpus in the sched_group_power

Introduce nr_busy_cpus in the struct sched_group_power [Not in sched_group
because sched groups are duplicated for the SD_OVERLAP scheduler domain]
and for each cpu that enters and exits idle, this parameter will
be updated in each scheduler group of the scheduler domain that this cpu
belongs to.

To avoid the frequent update of this state as the cpu enters
and exits idle, the update of the stat during idle exit is
delayed to the first timer tick that happens after the cpu becomes busy.
This is done using NOHZ_IDLE flag in the struct rq's nohz_flags.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20111202010832.555984323@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h    |    6 ++++++
 kernel/sched/core.c      |    1 +
 kernel/sched/fair.c      |   31 +++++++++++++++++++++++++++++++
 kernel/sched/sched.h     |    1 +
 kernel/time/tick-sched.c |    9 +++++++++
 5 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8db17b7..295666c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -273,9 +273,11 @@ extern int runqueue_is_locked(int cpu);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void select_nohz_load_balancer(int stop_tick);
+extern void set_cpu_sd_state_idle(void);
 extern int get_nohz_timer_target(void);
 #else
 static inline void select_nohz_load_balancer(int stop_tick) { }
+static inline void set_cpu_sd_state_idle(void);
 #endif
 
 /*
@@ -901,6 +903,10 @@ struct sched_group_power {
 	 * single CPU.
 	 */
 	unsigned int power, power_orig;
+	/*
+	 * Number of busy cpus in this group.
+	 */
+	atomic_t nr_busy_cpus;
 };
 
 struct sched_group {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f1da77..699ff14 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6024,6 +6024,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 		return;
 
 	update_group_power(sd, cpu);
+	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
 }
 
 int __weak arch_sd_sibling_asym_packing(void)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 50c06b0..e050563 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4901,6 +4901,36 @@ static void nohz_balancer_kick(int cpu)
 	return;
 }
 
+static inline void set_cpu_sd_state_busy(void)
+{
+	struct sched_domain *sd;
+	int cpu = smp_processor_id();
+
+	if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
+		return;
+	clear_bit(NOHZ_IDLE, nohz_flags(cpu));
+
+	rcu_read_lock();
+	for_each_domain(cpu, sd)
+		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+	rcu_read_unlock();
+}
+
+void set_cpu_sd_state_idle(void)
+{
+	struct sched_domain *sd;
+	int cpu = smp_processor_id();
+
+	if (test_bit(NOHZ_IDLE, nohz_flags(cpu)))
+		return;
+	set_bit(NOHZ_IDLE, nohz_flags(cpu));
+
+	rcu_read_lock();
+	for_each_domain(cpu, sd)
+		atomic_dec(&sd->groups->sgp->nr_busy_cpus);
+	rcu_read_unlock();
+}
+
 /*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
@@ -5135,6 +5165,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	* We may be recently in ticked or tickless idle mode. At the first
 	* busy tick after returning from idle, we will update the busy stats.
 	*/
+	set_cpu_sd_state_busy();
 	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu))))
 		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cf7d026..91810f0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1069,6 +1069,7 @@ extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
 enum rq_nohz_flag_bits {
 	NOHZ_TICK_STOPPED,
 	NOHZ_BALANCE_KICK,
+	NOHZ_IDLE,
 };
 
 #define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4042064..31cc061 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -297,6 +297,15 @@ void tick_nohz_stop_sched_tick(int inidle)
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
 	/*
+ 	 * Update the idle state in the scheduler domain hierarchy
+ 	 * when tick_nohz_stop_sched_tick() is called from the idle loop.
+ 	 * State will be updated to busy during the first busy tick after
+ 	 * exiting idle.
+ 	 */
+	if (inidle)
+		set_cpu_sd_state_idle();
+
+	/*
 	 * Call to tick_nohz_start_idle stops the last_update_time from being
 	 * updated. Thus, it must not be called in the event we are called from
 	 * irq_exit() with the prior state different than idle.
