Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab0H3RxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:53:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:51095 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab0H3RxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:53:17 -0400
Subject: Re: [RFC][PATCH 1/3] sched: Rewrite tg_shares_up
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>, Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
In-Reply-To: <20100830172031.GA17281@linux.vnet.ibm.com>
References: <20100828223025.054328145@chello.nl>
	 <20100828223546.952988054@chello.nl>
	 <20100830172031.GA17281@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 30 Aug 2010 19:53:06 +0200
Message-ID: <1283190786.1820.1249.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 22:50 +0530, Srivatsa Vaddagiri wrote:
> On Sun, Aug 29, 2010 at 12:30:26AM +0200, Peter Zijlstra wrote:
> > By tracking a per-cpu load-avg for each cfs_rq and folding it into a
> > global task_group load on each tick we can rework tg_shares_up to be
> > strictly per-cpu.
> 
> So tg->load_weight is supposed to represent more or less current task load
> across all cpus? I see only atomic_add() to it - which means it can only keep
> growing or remain constant - IOW capturing the historical load even since
> the task group was started? I was expecting it to reduce based on how a group 
> goes idle, otherwise 

It can add a negative value, I should probably have made the below use
long instead of unsigned long.

> > +static void update_cfs_shares(struct cfs_rq *cfs_rq)
> > +{
> > +	struct task_group *tg;
> > +	struct sched_entity *se;
> > +	unsigned long load_weight, load, shares;
> > +
> > +	if (!cfs_rq)
> > +		return;
> > +
> > +	tg = cfs_rq->tg;
> > +	se = tg->se[cpu_of(rq_of(cfs_rq))];
> > +	if (!se)
> > +		return;
> > +
> > +	load = cfs_rq->load.weight;
> > +
> > +	load_weight = atomic_read(&tg->load_weight);
> > +	load_weight -= cfs_rq->load_contribution;
> > +	load_weight += load;
> > +
> > +	shares = (tg->shares * load);
> > +	if (load_weight)
> > +		shares /= load_weight;
> 
> this seem incorrect? Even though we have corrected tg->load_weight to reflect
> current load on 'cfs_rq', tg->load_weight still captures historical load on
> other cpus and hence could be a large #, making the division inaccurate?

Well, without history you can get terribly inaccurate too. Suppose the
workload sleeps for 50ms then runs for 50ms with n tasks, each on its
own cpu. Without history you'll end up being off by n*load, with history
you'll be floating about the avg, giving a much more stable result.

The (tg->shares * cfs_rq->load) / tg->load < MIN_SHARES issues is not
something we can easily fix, there's only so much you can do with fixed
point math.

> Also I wonder how much of a hot spot tg->load_weight would become ..

We touch it once per tick, so pretty hot on large systems, then again,
the larger the system the less likely all cpus will run tasks from the
same cgroup.
