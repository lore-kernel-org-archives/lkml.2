Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0FOQJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:09:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43726 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab0FOQJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O0HBWRmpVdK3c2W03R8sMHKAfrthrm3RqnCcAoBQGD2caUaa7V2IoTMIpxUM8YRgB8
         0NsBSzztPMEobBkcoM6kDvvVL3NDsARXMsEtycOXanOd/yuoCaq59qNbxRN3MZpWRCvu
         Z7CmKpHflDaqFx+aTxNsSM7/rwKigOyl1Kwuo=
Date: Tue, 15 Jun 2010 19:13:03 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avoid using smp_processor_id() in preemptible code
 (nr_iowait_cpu)
Message-ID: <20100615161303.GA4102@swordfish.minsk.epam.com>
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


I've changed struct tick_sched to match passed *ts and cpu. Also changed "&per_cpu(tick_cpu_sched, cpu)"
call to "struct tick_sched *tick_get_tick_sched(int cpu)" which we already have.

But I don't really like this part:
struct tick_sched *tick_get_tick_sched(int cpu)
{
	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
	ts->cpu = cpu;
	^^^^^^^^^^^^^
	return ts;
}

Please kindly review.

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
index 1d7b9bc..5105345 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -38,7 +38,9 @@ static ktime_t last_jiffies_update;
 
 struct tick_sched *tick_get_tick_sched(int cpu)
 {
-	return &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ts->cpu = cpu;
+	return ts;
 }
 
 /*
@@ -137,7 +139,7 @@ __setup("nohz=", setup_tick_nohz);
 static void tick_nohz_update_jiffies(ktime_t now)
 {
 	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = tick_get_tick_sched(cpu);
 	unsigned long flags;
 
 	cpumask_clear_cpu(cpu, nohz_cpu_mask);
@@ -159,9 +161,10 @@ update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
 	ktime_t delta;
 
 	if (ts->idle_active) {
+		int cpu = ts->cpu;
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		if (nr_iowait_cpu() > 0)
+		if (nr_iowait_cpu(cpu) > 0)
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

