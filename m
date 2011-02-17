Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1BQCyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:54:12 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:47627 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1BQCyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:54:09 -0500
Date: Thu, 17 Feb 2011 08:24:26 +0530
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
Subject: Re: [CFS Bandwidth Control v4 1/7] sched: introduce primitives to
 account for CFS bandwidth tracking
Message-ID: <20110217025426.GA2775@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <20110216031840.878320737@google.com>
 <20110216165216.GC3415@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216165216.GC3415@balbir.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 10:22:16PM +0530, Balbir Singh wrote:
> * Paul Turner <pjt@google.com> [2011-02-15 19:18:32]:
> 
> > In this patch we introduce the notion of CFS bandwidth, to account for the
> > realities of SMP this is partitioned into globally unassigned bandwidth, and
> > locally claimed bandwidth:
> > - The global bandwidth is per task_group, it represents a pool of unclaimed
> >   bandwidth that cfs_rq's can allocate from.  It uses the new cfs_bandwidth
> >   structure.
> > - The local bandwidth is tracked per-cfs_rq, this represents allotments from
> >   the global pool
> >   bandwidth assigned to a task_group, this is tracked using the
> >   new cfs_bandwidth structure.
> > 
> > Bandwidth is managed via cgroupfs via two new files in the cpu subsystem:
> > - cpu.cfs_period_us : the bandwidth period in usecs
> > - cpu.cfs_quota_us : the cpu bandwidth (in usecs) that this tg will be allowed
> >   to consume over period above.
> > 
> > A per-cfs_bandwidth timer is also introduced to handle future refresh at
> > period expiration.  There's some minor refactoring here so that
> > start_bandwidth_timer() functionality can be shared
> > 
> > Signed-off-by: Paul Turner <pjt@google.com>
> > Signed-off-by: Nikhil Rao <ncrao@google.com>
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > ---
> 
> Looks good, minor nits below
> 
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Thanks Balbir.

> > +
> > +static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
> > +{
> > +	struct cfs_bandwidth *cfs_b =
> > +		container_of(timer, struct cfs_bandwidth, period_timer);
> > +	ktime_t now;
> > +	int overrun;
> > +	int idle = 0;
> > +
> > +	for (;;) {
> > +		now = hrtimer_cb_get_time(timer);
> > +		overrun = hrtimer_forward(timer, now, cfs_b->period);
> > +
> > +		if (!overrun)
> > +			break;
> > +
> > +		idle = do_sched_cfs_period_timer(cfs_b, overrun);
> 
> This patch just sets up to return do_sched_cfs_period_timer to return
> 1. I am afraid I don't understand why this function is introduced
> here.

Answered this during last post: http://lkml.org/lkml/2010/10/14/31

> > +
> > +	mutex_lock(&mutex);
> > +	raw_spin_lock_irq(&tg->cfs_bandwidth.lock);
> > +	tg->cfs_bandwidth.period = ns_to_ktime(period);
> > +	tg->cfs_bandwidth.runtime = tg->cfs_bandwidth.quota = quota;
> > +	raw_spin_unlock_irq(&tg->cfs_bandwidth.lock);
> > +
> > +	for_each_possible_cpu(i) {
> 
> Why for each possible cpu - to avoid hotplug handling?

Touched upon this during last post: https://lkml.org/lkml/2010/12/6/49

Regards,
Bharata.
