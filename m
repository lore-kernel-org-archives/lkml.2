Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0FQG0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:26:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33139 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab0FQG0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hz3/8BAJ42mqbKxIj7zlFPHFG24MKaNuJgYj/Kcx3hUXA3kR6rffvphgN83CuMSrKl
         f9y94zL8yIK/b8drqEuOXagVksXZX/bIyd4uXXszP3nqr34a/u5hiAJLovFEJpsWtQXq
         POckkcukkAvn88Zso6DRgEWBQ6ja5OAE1Xzcc=
Date: Thu, 17 Jun 2010 09:29:50 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cpuidle: avoid using smp_processor_id() in preemptible
 code (nr_iowait_cpu) v4
Message-ID: <20100617062950.GA3979@swordfish>
References: <20100614140941.GA3581@swordfish.minsk.epam.com>
 <20100614073853.6fa2f91f@infradead.org>
 <20100614145439.GA3448@swordfish.minsk.epam.com>
 <20100614080154.7d6a71fc@infradead.org>
 <20100614151735.GB3448@swordfish.minsk.epam.com>
 <20100614204021.52c50cdc@infradead.org>
 <20100615061927.GA3312@swordfish>
 <20100615072435.5a47d850@infradead.org>
 <20100615145029.GB3967@swordfish.minsk.epam.com>
 <20100615080808.6286448b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615080808.6286448b@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix
   
 BUG: using smp_processor_id() in preemptible [00000000] code: s2disk/3392
 caller is nr_iowait_cpu+0xe/0x1e
 Pid: 3392, comm: s2disk Not tainted 2.6.35-rc3-dbg-00106-ga75e02b #2
 Call Trace:
 [<c1184c55>] debug_smp_processor_id+0xa5/0xbc
 [<c10282a5>] nr_iowait_cpu+0xe/0x1e
 [<c104ab7c>] update_ts_time_stats+0x32/0x6c
 [<c104ac73>] get_cpu_idle_time_us+0x36/0x58
 [<c124229b>] get_cpu_idle_time+0x12/0x74   
 [<c1242963>] cpufreq_governor_dbs+0xc3/0x2dc
 [<c1240437>] __cpufreq_governor+0x51/0x85   
 [<c1241190>] __cpufreq_set_policy+0x10c/0x13d
 [<c12413d3>] cpufreq_add_dev_interface+0x212/0x233
 [<c1241b1e>] ? handle_update+0x0/0xd
 [<c1241a18>] cpufreq_add_dev+0x34b/0x35a
 [<c103c973>] ? schedule_delayed_work_on+0x11/0x13
 [<c12c14db>] cpufreq_cpu_callback+0x59/0x63
 [<c1042f39>] notifier_call_chain+0x26/0x48 
 [<c1042f7d>] __raw_notifier_call_chain+0xe/0x10
 [<c102efb9>] __cpu_notify+0x15/0x29
 [<c102efda>] cpu_notify+0xd/0xf
 [<c12bfb30>] _cpu_up+0xaf/0xd2 
 [<c12b3ad4>] enable_nonboot_cpus+0x3d/0x94
 [<c1055eef>] hibernation_snapshot+0x104/0x1a2
 [<c1058b49>] snapshot_ioctl+0x24b/0x53e
 [<c1028ad1>] ? sub_preempt_count+0x7c/0x89
 [<c10ab91d>] vfs_ioctl+0x2e/0x8c
 [<c10588fe>] ? snapshot_ioctl+0x0/0x53e
 [<c10ac2c7>] do_vfs_ioctl+0x42f/0x45a  
 [<c10a0ba5>] ? fsnotify_modify+0x4f/0x5a
 [<c11e9dc3>] ? tty_write+0x0/0x1d0
 [<c10a12d6>] ? vfs_write+0xa2/0xda
 [<c10ac333>] sys_ioctl+0x41/0x62  
 [<c10027d3>] sysenter_do_call+0x12/0x2d

The initial fix was to use get_cpu/put_cpu in nr_iowait_cpu.  However,
Arjan stated that "the bug is that it needs to be nr_iowait_cpu(int cpu)".

This patch introduces nr_iowait_cpu(int cpu) and changes to its callers.

Arjan also pointed out that we can't use get_cpu/put_cpu in update_ts_time_stats
since we "pick the current cpu, rather than the one denoted by ts" in that case.
To match given *ts and cpu denoted by *ts we use new field in the struct tick_sched: int cpu.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 52ff8aa..4871ed5 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -137,14 +137,17 @@ static inline int which_bucket(unsigned int duration)
 {
 	int bucket = 0;
 
+	int cpu = get_cpu();
 	/*
 	 * We keep two groups of stats; one with no
 	 * IO pending, one without.
 	 * This allows us to calculate
 	 * E(duration)|iowait
 	 */
-	if (nr_iowait_cpu())
+	if (nr_iowait_cpu(cpu))
 		bucket = BUCKETS/2;
+	
+	put_cpu();
 
 	if (duration < 10)
 		return bucket;
@@ -169,14 +172,17 @@ static inline int which_bucket(unsigned int duration)
 static inline int performance_multiplier(void)
 {
 	int mult = 1;
-
+	int cpu = get_cpu();
+	
 	/* for higher loadavg, we are more reluctant */
 
 	mult += 2 * get_loadavg();
 
 	/* for IO wait tasks (per cpu!) we add 5x each */
-	mult += 10 * nr_iowait_cpu();
+	mult += 10 * nr_iowait_cpu(cpu);
 
+	put_cpu();
+	
 	return mult;
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f118809..747fcae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -139,7 +139,7 @@ extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
-extern unsigned long nr_iowait_cpu(void);
+extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b232ccc..db14691 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -51,6 +51,7 @@ struct tick_sched {
 	unsigned long			check_clocks;
 	enum tick_nohz_mode		nohz_mode;
 	ktime_t				idle_tick;
+	int				cpu;
 	int				inidle;
 	int				tick_stopped;
 	unsigned long			idle_jiffies;
diff --git a/kernel/sched.c b/kernel/sched.c
index f8b8996..f61b48e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2864,9 +2864,9 @@ unsigned long nr_iowait(void)
 	return sum;
 }
 
-unsigned long nr_iowait_cpu(void)
+unsigned long nr_iowait_cpu(int cpu)
 {
-	struct rq *this = this_rq();
+	struct rq *this = cpu_rq(cpu);
 	return atomic_read(&this->nr_iowait);
 }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1d7b9bc..1907037 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -38,6 +38,9 @@ static ktime_t last_jiffies_update;
 
 struct tick_sched *tick_get_tick_sched(int cpu)
 {
+	/*FIXME: Arjan van de Ven:
+	 can we do this bit once, when the ts structure gets initialized?*/
+	per_cpu(tick_cpu_sched, cpu).cpu = cpu;
 	return &per_cpu(tick_cpu_sched, cpu);
 }
 
@@ -137,7 +140,7 @@ __setup("nohz=", setup_tick_nohz);
 static void tick_nohz_update_jiffies(ktime_t now)
 {
 	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 	unsigned long flags;
 
 	cpumask_clear_cpu(cpu, nohz_cpu_mask);
@@ -161,7 +164,7 @@ update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		if (nr_iowait_cpu() > 0)
+		if (nr_iowait_cpu(ts->cpu) > 0)
 			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
 		ts->idle_entrytime = now;
 	}
@@ -173,7 +176,7 @@ update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
 
 static void tick_nohz_stop_idle(int cpu, ktime_t now)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 
 	update_ts_time_stats(ts, now, NULL);
 	ts->idle_active = 0;
@@ -211,7 +214,7 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
  */
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 
 	if (!tick_nohz_enabled)
 		return -1;
@@ -237,7 +240,7 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
  */
 u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 
 	if (!tick_nohz_enabled)
 		return -1;
@@ -267,7 +270,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
-	ts = &per_cpu(tick_cpu_sched, cpu);
+	ts = tick_get_tick_sched(cpu);
 
 	/*
 	 * Call to tick_nohz_start_idle stops the last_update_time from being
@@ -508,7 +511,7 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 void tick_nohz_restart_sched_tick(void)
 {
 	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	unsigned long ticks;
 #endif
@@ -671,7 +674,7 @@ static void tick_nohz_kick_tick(int cpu, ktime_t now)
 #if 0
 	/* Switch back to 2.6.27 behaviour */
 
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 	ktime_t delta;
 
 	/*
@@ -688,7 +691,7 @@ static void tick_nohz_kick_tick(int cpu, ktime_t now)
 
 static inline void tick_check_nohz(int cpu)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 	ktime_t now;
 
 	if (!ts->idle_active && !ts->tick_stopped)
@@ -818,7 +821,7 @@ void tick_setup_sched_timer(void)
 #if defined CONFIG_NO_HZ || defined CONFIG_HIGH_RES_TIMERS
 void tick_cancel_sched_timer(int cpu)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 
 # ifdef CONFIG_HIGH_RES_TIMERS
 	if (ts->sched_timer.base)


