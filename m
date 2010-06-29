Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab0F2PDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:03:04 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38606 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab0F2PDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xN8I4Lt9swNwKe8hDG/tCFE4wDjXgXw9f4H/rVlIbWf2I+OaUTuyWTSU9Y4BWrTrTY
         S3/60psxAa0ieoeNVOn7wAGehcCsYEVZvJRlMWTYaZL3IOHiweInFpArIpdOTCsX6Csx
         0dXNYsE+pgXw14n4zDXvZbPh4ocUf5YNHODAw=
Date: Tue, 29 Jun 2010 17:03:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/11] perf: Default PMU ops
Message-ID: <20100629150305.GG5318@nowhere>
References: <20100624142804.431553874@chello.nl> <20100624143406.993794468@chello.nl> <20100629145806.GE5318@nowhere> <1277823591.1868.43.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277823591.1868.43.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 04:59:51PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-06-29 at 16:58 +0200, Frederic Weisbecker wrote:
> > On Thu, Jun 24, 2010 at 04:28:13PM +0200, Peter Zijlstra wrote:
> > > Provide default implementations for the pmu txn methods, this allows
> > > us to remove some conditional code.
> > > 
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > ---
> > >  kernel/perf_event.c |   48 ++++++++++++++++++++++++++++++++++++------------
> > >  1 file changed, 36 insertions(+), 12 deletions(-)
> > > 
> > > Index: linux-2.6/kernel/perf_event.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/perf_event.c
> > > +++ linux-2.6/kernel/perf_event.c
> > > @@ -656,21 +656,14 @@ group_sched_in(struct perf_event *group_
> > >  {
> > >  	struct perf_event *event, *partial_group = NULL;
> > >  	struct pmu *pmu = group_event->pmu;
> > > -	bool txn = false;
> > >  
> > >  	if (group_event->state == PERF_EVENT_STATE_OFF)
> > >  		return 0;
> > >  
> > > -	/* Check if group transaction availabe */
> > > -	if (pmu->start_txn)
> > > -		txn = true;
> > > -
> > > -	if (txn)
> > > -		pmu->start_txn(pmu);
> > > +	pmu->start_txn(pmu);
> > >  
> > >  	if (event_sched_in(group_event, cpuctx, ctx)) {
> > > -		if (txn)
> > > -			pmu->cancel_txn(pmu);
> > > +		pmu->cancel_txn(pmu);
> > >  		return -EAGAIN;
> > >  	}
> > >  
> > > @@ -684,7 +677,7 @@ group_sched_in(struct perf_event *group_
> > >  		}
> > >  	}
> > >  
> > > -	if (!txn || !pmu->commit_txn(pmu))
> > > +	if (!pmu->commit_txn(pmu))
> > >  		return 0;
> > >  
> > >  group_error:
> > > @@ -699,8 +692,7 @@ group_error:
> > >  	}
> > >  	event_sched_out(group_event, cpuctx, ctx);
> > >  
> > > -	if (txn)
> > > -		pmu->cancel_txn(pmu);
> > > +	pmu->cancel_txn(pmu);
> > >  
> > >  	return -EAGAIN;
> > >  }
> > > @@ -4755,6 +4747,26 @@ static struct list_head pmus;
> > >  static DEFINE_MUTEX(pmus_lock);
> > >  static struct srcu_struct pmus_srcu;
> > >  
> > > +static void perf_pmu_nop(struct pmu *pmu)
> > > +{
> > > +}
> > > +
> > > +static void perf_pmu_start_txn(struct pmu *pmu)
> > > +{
> > > +	perf_pmu_disable(pmu);
> > > +}
> > > +
> > > +static int perf_pmu_commit_txn(struct pmu *pmu)
> > > +{
> > > +	perf_pmu_enable(pmu);
> > > +	return 0;
> > > +}
> > > +
> > > +static void perf_pmu_cancel_txn(struct pmu *pmu)
> > > +{
> > > +	perf_pmu_enable(pmu);
> > > +}
> > 
> > 
> > So why do you need perf_pmu_*able wrappers now that you brings stubs
> > if none is provided?
> > 
> > Actually, one problem is that it makes calling two indirect nops
> > for software events.
> > 
> > Should the txn things really map to the enable/disable ops is the
> > off-case? Probably better let pmu implementations deal with that.
> > If they didn't provide txn implementations, it means they don't need it,
> > hence it should directly map to a nop.
> > 
> 
> You mean, if (!pmu->start_txn && pmu->pmu_enable) { /* install defaults
> */ } ?


Not really. pmu_*able and txn are there for different purposes.
A pmu implementation may want to provide enable/disable things
but not require any txn. Or one may just not need any of those,
like software events.

It should simply map to a nop if nothing is provided.

