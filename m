Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab2CLPjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:39:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab2CLPjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:39:08 -0400
Date: Mon, 12 Mar 2012 16:39:06 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix idle ticks in cpu summary line of /proc/stat
Message-ID: <20120312153906.GE3994@tiehlicka.suse.cz>
References: <20120311182621.41674b39@de.ibm.com>
 <20120312121726.GA23608@tiehlicka.suse.cz>
 <20120312101739.26eb373e@de.ibm.com>
 <4F5E0CC1.6010102@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5E0CC1.6010102@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12-03-12 20:18:33, Srivatsa S. Bhat wrote:
> On 03/12/2012 07:47 PM, Martin Schwidefsky wrote:
> 
> > On Mon, 12 Mar 2012 13:17:26 +0100
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> >> Goot catch. But I think that the following fix should be better because
> >> it doesn't change the semantic of the function. What do you think?
> > ..
> >> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> >> index 7656642..dec767f 100644
> >> --- a/kernel/time/tick-sched.c
> >> +++ b/kernel/time/tick-sched.c
> >> @@ -221,7 +221,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
> >>  		update_ts_time_stats(cpu, ts, now, last_update_time);
> >>  		idle = ts->idle_sleeptime;
> >>  	} else {
> >> -		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
> >> +		if (cpu_online(cpu) && ts->idle_active && !nr_iowait_cpu(cpu)) {
> >>  			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> >>
> >>  			idle = ktime_add(ts->idle_sleeptime, delta);
> >> @@ -262,7 +262,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
> >>  		update_ts_time_stats(cpu, ts, now, last_update_time);
> >>  		iowait = ts->iowait_sleeptime;
> >>  	} else {
> >> -		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
> >> +		if (cpu_online(cpu) && ts->idle_active && nr_iowait_cpu(cpu) > 0) {
> >>  			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> >>
> >>  			iowait = ktime_add(ts->iowait_sleeptime, delta);
> > 
> > I would prefer an early exit from the functions. The target cpu is offline,
> > who guarantees that the "struct tick_sched" for the cpu contains anything
> > useful?

Hmm, the semantic is that the function either returns the sleeptime or
-1 if nohz is disabled. Bringing also online/offline into it seems
rather confusing. 
Maybe we shouldn't do the test layer up when we call the function
instead. This should be much cleaner IMO (it also reduced cpu_online
call from the governors call paths which might be a problem as well):

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 121f77c..d437258 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -24,7 +24,10 @@
 
 static u64 get_idle_time(int cpu)
 {
-	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
+	u64 idle, idle_time = -1ULL;
+	
+	if (cpu_online(cpu))
+		idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL) {
 		/* !NO_HZ so we can rely on cpustat.idle */
@@ -38,7 +41,10 @@ static u64 get_idle_time(int cpu)
 
 static u64 get_iowait_time(int cpu)
 {
-	u64 iowait, iowait_time = get_cpu_iowait_time_us(cpu, NULL);
+	u64 iowait, iowait_time = -1ULL;
+	
+	if (cpu_online(cpu))
+		iowait_time = get_cpu_iowait_time_us(cpu, NULL);
 
 	if (iowait_time == -1ULL)
 		/* !NO_HZ so we can rely on cpustat.iowait */

> 
> Also, what about the case where last_update_time is non-NULL?
> With Martin's patch update_ts_time_stats() won't be called for offline cpus,

This is a separate issue AFAIU. If there is a possibility that somebody
is calling it like that then it is a bug. I am not familiar with cpu
governors (non-NULL update users) but we shouldn't paper over any bug with
this /proc/stat fix.

> whereas with Michal's patch it will be called and hence the counters will get
> updated.. We don't want to update counters for offline cpus right?
> 
> Regards,
> Srivatsa S. Bhat
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
