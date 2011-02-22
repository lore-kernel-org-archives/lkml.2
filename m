Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1BVENS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 23:13:18 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38736 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab1BVENR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 23:13:17 -0500
Date: Tue, 22 Feb 2011 09:43:33 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Subject: Re: [CFS Bandwidth Control v4 5/7] sched: add exports tracking cfs
 bandwidth control statistics
Message-ID: <20110222041332.GA2753@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <20110216031841.258879435@google.com>
 <20110222031420.GI10342@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222031420.GI10342@balbir.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 08:44:20AM +0530, Balbir Singh wrote:
> * Paul Turner <pjt@google.com> [2011-02-15 19:18:36]:
> 
> > From: Nikhil Rao <ncrao@google.com>
> > 
> > This change introduces statistics exports for the cpu sub-system, these are
> > added through the use of a stat file similar to that exported by other
> > subsystems.
> > 
> > The following exports are included:
> > 
> > nr_periods:	number of periods in which execution occurred
> > nr_throttled:	the number of periods above in which execution was throttle
> > throttled_time:	cumulative wall-time that any cpus have been throttled for
> > this group
> > 
> > Signed-off-by: Paul Turner <pjt@google.com>
> > Signed-off-by: Nikhil Rao <ncrao@google.com>
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > ---
> >  kernel/sched.c      |   26 ++++++++++++++++++++++++++
> >  kernel/sched_fair.c |   16 +++++++++++++++-
> >  2 files changed, 41 insertions(+), 1 deletion(-)
> > 
> > Index: tip/kernel/sched.c
> > ===================================================================
> > --- tip.orig/kernel/sched.c
> > +++ tip/kernel/sched.c
> > @@ -254,6 +254,11 @@ struct cfs_bandwidth {
> >  	ktime_t			period;
> >  	u64			runtime, quota;
> >  	struct hrtimer		period_timer;
> > +
> > +	/* throttle statistics */
> > +	u64			nr_periods;
> > +	u64			nr_throttled;
> > +	u64			throttled_time;
> >  };
> >  #endif
> > 
> > @@ -389,6 +394,7 @@ struct cfs_rq {
> >  #ifdef CONFIG_CFS_BANDWIDTH
> >  	u64 quota_assigned, quota_used;
> >  	int throttled;
> > +	u64 throttled_timestamp;
> >  #endif
> >  #endif
> >  };
> > @@ -426,6 +432,10 @@ void init_cfs_bandwidth(struct cfs_bandw
> > 
> >  	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> >  	cfs_b->period_timer.function = sched_cfs_period_timer;
> > +
> > +	cfs_b->nr_periods = 0;
> > +	cfs_b->nr_throttled = 0;
> > +	cfs_b->throttled_time = 0;
> >  }
> > 
> >  static
> > @@ -9332,6 +9342,18 @@ static int cpu_cfs_period_write_u64(stru
> >  	return tg_set_cfs_period(cgroup_tg(cgrp), cfs_period_us);
> >  }
> > 
> > +static int cpu_stats_show(struct cgroup *cgrp, struct cftype *cft,
> > +		struct cgroup_map_cb *cb)
> > +{
> > +	struct task_group *tg = cgroup_tg(cgrp);
> > +	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
> > +
> > +	cb->fill(cb, "nr_periods", cfs_b->nr_periods);
> > +	cb->fill(cb, "nr_throttled", cfs_b->nr_throttled);
> > +	cb->fill(cb, "throttled_time", cfs_b->throttled_time);
> > +
> > +	return 0;
> > +}
> >  #endif /* CONFIG_CFS_BANDWIDTH */
> >  #endif /* CONFIG_FAIR_GROUP_SCHED */
> > 
> > @@ -9378,6 +9400,10 @@ static struct cftype cpu_files[] = {
> >  		.read_u64 = cpu_cfs_period_read_u64,
> >  		.write_u64 = cpu_cfs_period_write_u64,
> >  	},
> > +	{
> > +		.name = "stat",
> > +		.read_map = cpu_stats_show,
> > +	},
> >  #endif
> >  #ifdef CONFIG_RT_GROUP_SCHED
> >  	{
> > Index: tip/kernel/sched_fair.c
> > ===================================================================
> > --- tip.orig/kernel/sched_fair.c
> > +++ tip/kernel/sched_fair.c
> > @@ -1519,17 +1519,25 @@ static void throttle_cfs_rq(struct cfs_r
> > 
> >  out_throttled:
> >  	cfs_rq->throttled = 1;
> > +	cfs_rq->throttled_timestamp = rq_of(cfs_rq)->clock;
> >  	update_cfs_rq_load_contribution(cfs_rq, 1);
> >  }
> > 
> >  static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
> >  {
> >  	struct rq *rq = rq_of(cfs_rq);
> > +	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
> >  	struct sched_entity *se;
> > 
> >  	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
> > 
> >  	update_rq_clock(rq);
> > +	/* update stats */
> > +	raw_spin_lock(&cfs_b->lock);
> > +	cfs_b->throttled_time += (rq->clock - cfs_rq->throttled_timestamp);
> > +	raw_spin_unlock(&cfs_b->lock);
> > +	cfs_rq->throttled_timestamp = 0;
> > +
> >  	/* (Try to) avoid maintaining share statistics for idle time */
> >  	cfs_rq->load_stamp = cfs_rq->load_last = rq->clock_task;
> > 
> > @@ -1571,7 +1579,7 @@ static void account_cfs_rq_quota(struct 
> > 
> >  static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
> >  {
> > -	int i, idle = 1;
> > +	int i, idle = 1, num_throttled = 0;
> >  	u64 delta;
> >  	const struct cpumask *span;
> > 
> > @@ -1593,6 +1601,7 @@ static int do_sched_cfs_period_timer(str
> > 
> >  		if (!cfs_rq_throttled(cfs_rq))
> >  			continue;
> > +		num_throttled++;
> > 
> >  		delta = tg_request_cfs_quota(cfs_rq->tg);
> > 
> > @@ -1608,6 +1617,11 @@ static int do_sched_cfs_period_timer(str
> >  		}
> >  	}
> > 
> > +	/* update throttled stats */
> > +	cfs_b->nr_periods++;
> > +	if (num_throttled)
> > +		cfs_b->nr_throttled++;
> > +
> >  	return idle;
> >  }
> >
> 
> Should we consider integrating this in cpuacct, it would be difficult
> if we spill over stats between controllers. 

Given that cpuacct controller can be mounted independently, I am not sure
if we should integrate these stats. These stats come from cpu controller.

I initially had similar stats as part of /proc/sched_debug since there
are a bunch of other group specific stats (including rt throttle stats)
in /proc/sched_debug.

Regards,
Bharata.
