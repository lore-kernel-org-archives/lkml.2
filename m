Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0F1PQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:16:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:32772 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab0F1PQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:16:52 -0400
Subject: Re: [RFC][PATCH 05/11] perf: register pmu implementations
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100628132101.GB5668@nowhere>
References: <20100624142804.431553874@chello.nl>
	 <20100624143406.764162308@chello.nl>  <20100628132101.GB5668@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Jun 2010 17:16:37 +0200
Message-ID: <1277738197.3561.132.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 15:21 +0200, Frederic Weisbecker wrote:
> On Thu, Jun 24, 2010 at 04:28:09PM +0200, Peter Zijlstra wrote:
> > +	if (bp->attr.type != PERF_TYPE_BREAKPOINT)
> > +		return -ENOENT;
> > +
> > +	err = register_perf_hw_breakpoint(bp);
> > +	if (err)
> > +		return err;
> > +
> > +	bp->destroy = bp_perf_event_destroy;

> Seems it would make sense to also have destroy in the pmu, it's the same
> along every events in the same class right?
> 
> But this can be for later.

Ah, indeed.

> > +static LIST_HEAD(pmus);
> > +static DEFINE_MUTEX(pmus_lock);
> > +static struct srcu_struct pmus_srcu;
> > +
> > +int perf_pmu_register(struct pmu *pmu)
> > +{
> > +	mutex_lock(&pmus_lock);
> > +	list_add_rcu(&pmu->entry, &pmus);
> > +	mutex_unlock(&pmus_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +void perf_pmu_unregister(struct pmu *pmu)
> > +{
> > +	mutex_lock(&pmus_lock);
> > +	list_del_rcu(&pmu->entry);
> > +	mutex_unlock(&pmus_lock);
> >  
> > -			atomic_inc(&perf_swevent_enabled[event_id]);
> > -			event->destroy = sw_perf_event_destroy;
> > +	synchronize_srcu(&pmus_srcu);
> > +}
> > +
> > +struct pmu *perf_init_event(struct perf_event *event)
> > +{
> > +	struct pmu *pmu = NULL;
> > +	int idx;
> > +
> > +	idx = srcu_read_lock(&pmus_srcu);
> > +	list_for_each_entry_rcu(pmu, &pmus, entry) {
> > +		int ret = pmu->event_init(event);
> > +		if (!ret)
> > +			break;
> > +		if (ret != -ENOENT) {
> > +			pmu = ERR_PTR(ret);
> > +			break;
> >  		}
> > -		pmu = &perf_ops_generic;
> > -		break;
> >  	}
> > +	srcu_read_unlock(&pmus_srcu, idx);
> >  
> >  	return pmu;
> >  }
> 
> 
> 
> I'm still not sure why all this locking is needed. We don't even
> support pmus in modules.
> 
> Is there something coming soon that will use this?
> I remember something about KVM.

Possibly, not sure. We could put the unregister thing in a later patch,
but I wanted to make sure it was sanely possibly and its only a few
lines of code.

> And who will have to use srcu? It seems the event fastpath would
> be concerned, right? Will that have an impact on the performances?

Only event creation like above (perf_init_event) will have to use SRCU,
so not really a hot path.

> > @@ -5743,15 +5742,15 @@ perf_cpu_notify(struct notifier_block *s
> >  {
> >  	unsigned int cpu = (long)hcpu;
> >  
> > -	switch (action) {
> > +	switch (action & ~CPU_TASKS_FROZEN) {
> >  
> >  	case CPU_UP_PREPARE:
> > -	case CPU_UP_PREPARE_FROZEN:
> > +	case CPU_DOWN_FAILED:
> >  		perf_event_init_cpu(cpu);
> >  		break;
> >  
> > +	case CPU_UP_CANCELED:
> >  	case CPU_DOWN_PREPARE:
> > -	case CPU_DOWN_PREPARE_FROZEN:
> >  		perf_event_exit_cpu(cpu);
> >  		break;
> 
> 
> 
> That doesn't seem to be related to this patch initial topic.

Ah indeed, that needs to go live in its own patch.

