Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab1BXLOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 06:14:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:36495 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab1BXLOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 06:14:37 -0500
Subject: Re: [CFS Bandwidth Control v4 4/7] sched: unthrottle cfs_rq(s) who
 ran out of quota at period refresh
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110224070405.GA2816@in.ibm.com>
References: <20110216031831.571628191@google.com>
	 <20110216031841.161743484@google.com> <1298467932.2217.764.camel@twins>
	 <20110224070405.GA2816@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Feb 2011 12:14:03 +0100
Message-ID: <1298546043.2428.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 12:34 +0530, Bharata B Rao wrote:
> On Wed, Feb 23, 2011 at 02:32:12PM +0100, Peter Zijlstra wrote:
> > On Tue, 2011-02-15 at 19:18 -0800, Paul Turner wrote:
> > 
> > > +static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
> > > +{
> > > +	struct rq *rq = rq_of(cfs_rq);
> > > +	struct sched_entity *se;
> > > +
> > > +	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
> > > +
> > > +	update_rq_clock(rq);
> > > +	/* (Try to) avoid maintaining share statistics for idle time */
> > > +	cfs_rq->load_stamp = cfs_rq->load_last = rq->clock_task;
> > 
> > Ok, so here you try to compensate for some of the weirdness from the
> > previous patch.. wouldn't it be much saner to fully consider the
> > throttled things dequeued for the load calculation etc.?
> > 
> > > +
> > > +	cfs_rq->throttled = 0;
> > > +	for_each_sched_entity(se) {
> > > +		if (se->on_rq)
> > > +			break;
> > > +
> > > +		cfs_rq = cfs_rq_of(se);
> > > +		enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
> > > +		if (cfs_rq_throttled(cfs_rq))
> > > +			break;
> > 
> > That's just weird, it was throttled, you enqueued it but find it
> > throttled.
> 
> se got enqueued to cfs_rq, but we find that cfs_rq is throttled and hence
> refrain from enqueueing cfs_rq futher.
> 
> So essentially enqueing to a throttled cfs_rq is allowed, but a throttled 
> group entitiy can't be enqueued further.

Argh, so this is about the total trainwreck you have for hierarchy
semantics (which you've basically inherited from the RT bits I guess,
which are similarly broken).

Do you want to support per-cgroup throttle periods? If so we need to sit
down and work this out, if not the above should not be possible because
each cgroup can basically run from the same refresh timer and everybody
will get throttled at the same time.


