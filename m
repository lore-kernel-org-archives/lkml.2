Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1GYOdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:33:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1GYOdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:33:15 -0400
Date: Mon, 25 Jul 2011 16:33:13 +0200
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Have we changed /proc/stat idle statistics by NOHZ kernel?
Message-ID: <20110725143313.GE9445@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
we have a customer reporting that /proc/stat doesn't provide correct
results about idle time if the machine is idle.
The issue is caused by the fact that tickles kernel doesn't update
kstat_cpu(i).cpustat.idle while it is tickles. Tools that parse this
file interpret the unchanged value as 0% idle since the last time.
While I personally do not think that measuring the idle machine is
that important one could say that the semantic of the file has changed
with NOHZ which is not good as we are trying to keep this interface
stable.
One way to fix this is to consider the current status of idle in
show_stat. The very primitive attempt of that can be seen bellow (on
top of the current Linus tree). I know it has several issue it just
illustrates what I am trying to say.  It will not work if jiffies
overflow while the CPU was tickles and it also misses locking and
handling !NOHZ configuration.

I have also noticed we have get_cpu_idle_time_us which should do
something similar. Should it be used instead or it is more intrusive?

Btw. is this considered to be a problem at all?

Thanks
---
>From 015b5535a0cf9b75357afabd9e1d5d17558ed985 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 25 Jul 2011 16:16:26 +0200
Subject: [PATCH] proc: consider time when ticks are off when reporting idle
 time

---
 fs/proc/stat.c           |    3 +++
 kernel/time/tick-sched.c |   20 ++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 9758b65..970ec81 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -21,6 +21,8 @@
 #define arch_idle_time(cpu) 0
 #endif
 
+cputime64_t nohz_idle_shift(int cpu);
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
@@ -44,6 +46,7 @@ static int show_stat(struct seq_file *p, void *v)
 		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
 		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
 		idle = cputime64_add(idle, arch_idle_time(i));
+		idle = cputime64_add(idle, nohz_idle_shift(i));
 		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
 		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..57d11fa 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -194,6 +194,26 @@ static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 	return now;
 }
 
+cputime64_t nohz_idle_shift(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	cputime64_t notick_idle = 0;
+
+	if (ts->idle_active && time_after(ts->next_jiffies, jiffies)) {
+		/*
+		 * we are idle and not ticking due to NOHZ so the
+		 * kernel doesn't account for the idle. Let's use
+		 * last_jiffies. We are screwed when jiffies overflow
+		 * of course but what else we can do?
+		 */
+		notick_idle = cputime64_add(notick_idle,
+				jiffies_to_cputime(
+					jiffies - ts->last_jiffies));
+	}
+
+	return notick_idle;
+}
+
 /**
  * get_cpu_idle_time_us - get the total idle time of a cpu
  * @cpu: CPU number to query
-- 
1.7.5.4


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
