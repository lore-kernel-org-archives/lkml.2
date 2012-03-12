Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2CLMRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:17:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab2CLMR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:17:28 -0400
Date: Mon, 12 Mar 2012 13:17:26 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix idle ticks in cpu summary line of /proc/stat
Message-ID: <20120312121726.GA23608@tiehlicka.suse.cz>
References: <20120311182621.41674b39@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120311182621.41674b39@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 11-03-12 18:26:21, Martin Schwidefsky wrote:
> Git commit 09a1d34f8535ecf9 "nohz: Make idle/iowait counter update conditional"
> introduced a bug in regard to cpu hotplug. The effect is that the number
> of idle ticks in the cpu summary line in /proc/stat is still counting
> ticks for offline cpus. 
> 
> Reproduction is easy, just start a workload that keeps all cpus busy,
> switch off one or more cpus and then watch the idle field in top.
> On a dual-core with one cpu 100% busy and one offline cpu you will get
> something like this:
> 
> %Cpu(s): 48.7 us,  1.3 sy,  0.0 ni, 50.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> 
> The problem is that an offline cpu still has ts->idle_active == 1.
> To fix this get_cpu_idle_time_us and get_cpu_iowait_time_us
> should check for offline cpus.

Goot catch. But I think that the following fix should be better because
it doesn't change the semantic of the function. What do you think?
---
>From ccd68723637d7003124704a3329179a5947c54d2 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 12 Mar 2012 13:11:38 +0100
Subject: [PATCH] nohz: fix idle ticks in cpu summary line of /proc/stat

Git commit 09a1d34f8535ecf9 "nohz: Make idle/iowait counter update conditional"
introduced a bug in regard to cpu hotplug. The effect is that the number
of idle ticks in the cpu summary line in /proc/stat is still counting
ticks for offline cpus.

Reproduction is easy, just start a workload that keeps all cpus busy,
switch off one or more cpus and then watch the idle field in top.
On a dual-core with one cpu 100% busy and one offline cpu you will get
something like this:

%Cpu(s): 48.7 us,  1.3 sy,  0.0 ni, 50.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st

The problem is that an offline cpu still has ts->idle_active == 1.
To fix this get_cpu_idle_time_us and get_cpu_iowait_time_us
should check for offline cpus.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/time/tick-sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7656642..dec767f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -221,7 +221,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 		update_ts_time_stats(cpu, ts, now, last_update_time);
 		idle = ts->idle_sleeptime;
 	} else {
-		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+		if (cpu_online(cpu) && ts->idle_active && !nr_iowait_cpu(cpu)) {
 			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
 
 			idle = ktime_add(ts->idle_sleeptime, delta);
@@ -262,7 +262,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 		update_ts_time_stats(cpu, ts, now, last_update_time);
 		iowait = ts->iowait_sleeptime;
 	} else {
-		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
+		if (cpu_online(cpu) && ts->idle_active && nr_iowait_cpu(cpu) > 0) {
 			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
 
 			iowait = ktime_add(ts->iowait_sleeptime, delta);
-- 
1.7.9.1


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
