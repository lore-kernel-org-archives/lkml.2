Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0LFJDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:03:18 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:33852 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0LFJDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:03:15 -0500
Date: Mon, 6 Dec 2010 14:32:57 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
Subject: Re: [PATCH v3 1/7] sched: introduce primitives to account for CFS
	bandwidth tracking
Message-ID: <20101206090257.GC3704@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com> <20101012075023.GB9893@in.ibm.com> <20101013130018.GC3914@balbir.in.ibm.com> <1287042737.29097.153.camel@twins> <20101014123834.GB13048@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014123834.GB13048@balbir.in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 06:08:34PM +0530, Balbir Singh wrote:
> * Peter Zijlstra <peterz@infradead.org> [2010-10-14 09:52:17]:
> 
> > On Wed, 2010-10-13 at 18:30 +0530, Balbir Singh wrote:
> > > > +static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
> > > > +{
> > > > +	int i;
> > > > +	static DEFINE_MUTEX(mutex);
> > > > +
> > > > +	if (tg == &init_task_group)
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (!period)
> > > > +		return -EINVAL;
> > > > +
> > > > +	/*
> > > > +	 * Ensure we have at least one tick of bandwidth every period.  This is
> > > > +	 * to prevent reaching a state of large arrears when throttled via
> > > > +	 * entity_tick() resulting in prolonged exit starvation.
> > > > +	 */
> > > > +	if (NS_TO_JIFFIES(quota) < 1)
> > > > +		return -EINVAL;
> > > 
> > > I hope we document this in the Documentation :)
> > 
> > /me went and looked up arrears in a dictionary and wonders why 'debt'
> > wasn't good enough.
> > > > +
> > > > +	mutex_lock(&mutex);
> > > > +	raw_spin_lock_irq(&tg->cfs_bandwidth.lock);
> > > > +	tg->cfs_bandwidth.period = ns_to_ktime(period);
> > > > +	tg->cfs_bandwidth.runtime = tg->cfs_bandwidth.quota = quota;
> > > > +	raw_spin_unlock_irq(&tg->cfs_bandwidth.lock);
> > > > +
> > > > +	for_each_possible_cpu(i) {
> > > 
> > > Why not for_each_online_cpu()?
> > 
> > Probably could be cured with a hotplug handler, but then you need to
> > track more state iirc.
> >
> 
> What more state? If a CPU is offline, we never get to it, do we? I
> think we need to do just an init and destroy - no?

Here we essentially initialize tg->cfs_rq[cpu]->quota_used{assigned}
for all CPUs. Given that we don't destroy tg->cfs_rq[cpu] and tg->se->[cpu]
when a CPU goes offline, is it really worth to have a notifier to just
initialize quota_used and quota_assigned when a CPU comes online ?

Regards,
Bharata.

> 
> > > > +		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
> > > > +		struct rq *rq = rq_of(cfs_rq);
> > > > +
> > > > +		raw_spin_lock_irq(&rq->lock);
> > > > +		init_cfs_rq_quota(cfs_rq);
> > > > +		raw_spin_unlock_irq(&rq->lock);
> > > > +	}
> > > > +	mutex_unlock(&mutex);
> > > > +
> > > > +	return 0;
> > > > +}
> > 
> 
> -- 
> 	Three Cheers,
> 	Balbir
