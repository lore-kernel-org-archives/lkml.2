Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab1HVJ4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:56:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab1HVJ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:56:16 -0400
Date: Mon, 22 Aug 2011 11:56:13 +0200
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, cpufreq@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] nohz: do not update idle/iowait counters from
 get_cpu_{idle,iowait}_time_us if not asked
Message-ID: <20110822095613.GA25658@tiehlicka.suse.cz>
References: <20110802170249.GA23698@tiehlicka.suse.cz>
 <cover.1312544541.git.mhocko@suse.cz>
 <9314d03604802205b02524ebda1e534547042dfa.1312544541.git.mhocko@suse.cz>
 <20110805142349.GE12657@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805142349.GE12657@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 05-08-11 16:23:49, Michal Hocko wrote:
> On Thu 04-08-11 17:20:32, Michal Hocko wrote:
> > show_stat handler of the /proc/stat file relies on kstat_cpu(cpu)
> > statistics when priting information about idle and iowait times.
> > This is OK if we are not using tickless kernel (CONFIG_NO_HZ) because
> > counters are updated periodically.
> > With NO_HZ things got more tricky because we are not doing idle/iowait
> > accounting while we are tickless so the value might get outdated.
> > Users of /proc/stat will notice that by unchanged idle/iowait values
> > which is then interpreted as 0% idle/iowait time. From the user space
> > POV this is an unexpected behavior and a change of the interface.
> > 
> > Let's fix this by using get_cpu_{idle,iowait}_time_us which accounts the
> > total idle/iowait time since boot and it doesn't rely on sampling or any
> > other periodic activity. Fall back to the previous behavior if NO_HZ is
> > disabled or not configured.
> 
> I forgot to mention that this might be racy because we are updating
> those per-cpu values without having preemption disabled or any other
> locking which would be necessary as governors iterate over all CPUs.
> Governors do not have to care about that because they are singletons. 
> Introducing locks doesn't look like an option but I was thinking
> about adding __get_cpu_{idle,iowait}_time_us which wouldn't call
> update_ts_timestat and calculate the result instead.
> I can add a patch which does that but I wanted to hear about general
> approach first.

I guess we do not need a separate __get_cpu_{idle,iowait}_time_us
variant and rather reuse last_update_time parameter to determine whether
to update counters or not.

AFAICS we can still race with IRQ in update path (governors):
irq_enter
  tick_check_idle
    tick_check_nohz
      tick_nohz_stop_idle
but this is a separate issue IMO.
--- 
>From 46b3c7735b23180299c6a85089571574f28527a2 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 22 Aug 2011 11:35:27 +0200
Subject: [PATCH] nohz: do not update idle/iowait counters from
 get_cpu_{idle,iowait}_time_us if not asked

get_cpu_{idle,iowait}_time_us update idle/iowait counters
unconditionally if the given CPU is in the idle loop. This doesn't work
well outside of CPU governors which are singletons so nobody (except for
IRQ) can race with them.
We will need to use both functions from /proc/stat handler to properly
handle nohz idle/iowait times.
Let's update those counters only if the given last_update_time parameter
is non-NULL which means that the caller is interested in updating.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/time/tick-sched.c |   37 +++++++++++++++++++++++++++++++------
 1 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7ab44bc..5bcff38 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -198,7 +198,8 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 /**
  * get_cpu_idle_time_us - get the total idle time of a cpu
  * @cpu: CPU number to query
- * @last_update_time: variable to store update time in
+ * @last_update_time: variable to store update time in. Do not update
+ * counters if NULL.
  *
  * Return the cummulative idle time (since boot) for a given
  * CPU, in microseconds.
@@ -211,20 +212,33 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, idle;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
-	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
+	now = ktime_get();
+	if (last_update_time) {
+		update_ts_time_stats(cpu, ts, now, last_update_time);
+		idle = ts->idle_sleeptime;
+	} else {
+		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+			idle = ktime_add(ts->idle_sleeptime, delta);
+		} else
+			idle = ts->idle_sleeptime;
+	}
+
+	return ktime_to_us(idle);
 
-	return ktime_to_us(ts->idle_sleeptime);
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
 /**
  * get_cpu_iowait_time_us - get the total iowait time of a cpu
  * @cpu: CPU number to query
- * @last_update_time: variable to store update time in
+ * @last_update_time: variable to store update time in. Do not update
+ * counters if NULL.
  *
  * Return the cummulative iowait time (since boot) for a given
  * CPU, in microseconds.
@@ -237,13 +251,24 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now, iowait;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
-	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
+	now = ktime_get();
+	if (last_update_time) {
+		update_ts_time_stats(cpu, ts, now, last_update_time);
+		iowait = ts->iowait_sleeptime;
+	} else {
+		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
+			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
+			iowait = ktime_add(ts->iowait_sleeptime, delta);
+		} else
+			iowait = ts->iowait_sleeptime;
+	}
 
-	return ktime_to_us(ts->iowait_sleeptime);
+	return ktime_to_us(iowait);
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
-- 
1.7.5.4


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
