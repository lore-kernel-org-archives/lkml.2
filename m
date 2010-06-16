Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357Ab0FPRsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:48:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab0FPRsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:48:09 -0400
Subject: Re: [RFC][PATCH 3/8] perf: register pmu implementations
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100616170354.GA5530@nowhere>
References: <20100616160027.590430763@chello.nl>
	 <20100616160238.241599593@chello.nl>  <20100616170354.GA5530@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 19:48:00 +0200
Message-ID: <1276710480.1745.608.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 19:03 +0200, Frederic Weisbecker wrote:

> > +static struct pmu perf_breakpoint = {
> > +	.event_init	= hw_breakpoint_event_init,
> 
> 
> 
> Should be bp_perf_event_init?

Ah, yes, like said, the compiler didn't get near yet..

> 
> > +	.enable		= arch_install_hw_breakpoint,
> > +	.disable	= arch_uninstall_hw_breakpoint,
> > +	.read		= hw_breakpoint_pmu_read,
> > +};
> <snip>
> > +static int perf_swevent_int(struct perf_event *event)
> > +{
> > +	if (event->attr.type != PERF_TYPE_SOFTWARE)
> > +		return -ENOENT
> 
> 
> perf_swevent_init() ?

copy/paste gone wild..

> > +void perf_pmu_unregister(struct pmu *pmu)
> > +{
> > +	spin_lock(&pmus_lock);
> > +	list_del_rcu(&pmu->entry);
> > +	spin_unlock(&pmus_lock);
> > +
> > +	synchronize_srcu(&pmus_srcu);
> > +}

> Who needs this?

Nobody yet.. 

> > +
> > +struct pmu *perf_init_event(struct perf_event *event)
> > +{
> > +	struct pmu *pmu;
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
> 
> 
> 
> This could use a simple mutex instead of a spinlock + srcu_sync on
> writer and srcu on reader.

Right, that spinlock needs to be a mutex for sure, a later patch adds an
allocation under it.

But even with a mutex we need srcu_sync in there to sync against the
readers.

> That doesn't matter much that said. What I don't understand is
> why we need to synchronize the writers. Walking the list with
> list_*_rcu() looks justified once we support boot events, but
> until then...

Well, the typical unregister user would be a module, if you unregister
and then dealloc the struct pmu by unloading the module a reader might
still see a reference to it if you don't srcu_sync it.
