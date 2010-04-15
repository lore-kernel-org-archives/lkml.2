Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0DOFGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:06:35 -0400
Received: from ozlabs.org ([203.10.76.45]:55482 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab0DOFGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:06:34 -0400
From: Michael Neuling <mikey@neuling.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 5/5] sched: make fix_small_imbalance work with asymmetric packing
In-reply-to: <1271208670.2834.55.camel@sbs-t61.sc.intel.com>
References: <20100409062119.10AC5CBB6D@localhost.localdomain> <1271161769.4807.1283.camel@twins> <1271208670.2834.55.camel@sbs-t61.sc.intel.com>
Comments: In-reply-to Suresh Siddha <suresh.b.siddha@intel.com>
   message dated "Tue, 13 Apr 2010 18:31:10 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 15 Apr 2010 15:06:31 +1000
Message-ID: <10091.1271307991@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1271208670.2834.55.camel@sbs-t61.sc.intel.com> you wrote:
> On Tue, 2010-04-13 at 05:29 -0700, Peter Zijlstra wrote:
> > On Fri, 2010-04-09 at 16:21 +1000, Michael Neuling wrote:
> > > With the asymmetric packing infrastructure, fix_small_imbalance is
> > > causing idle higher threads to pull tasks off lower threads.  
> > > 
> > > This is being caused by an off-by-one error.  
> > > 
> > > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > > ---
> > > I'm not sure this is the right fix but without it, higher threads pull
> > > tasks off the lower threads, then the packing pulls it back down, etc
> > > etc and tasks bounce around constantly.
> > 
> > Would help if you expand upon the why/how it manages to get pulled up.
> > 
> > I can't immediately spot anything wrong with the patch, but then that
> > isn't my favourite piece of code either.. Suresh, any comments?
> > 
> 
> Sorry didn't pay much attention to this patchset. But based on the
> comments from Michael and looking at this patchset, it has SMT/MC
> implications. I will review and run some tests and get back in a day.
> 
> As far as this particular patch is concerned, original code is coming
> from Ingo's original CFS code commit (dd41f596) and the below hunk
> pretty much explains what the change is about.
> 
> -               if (max_load - this_load >= busiest_load_per_task * imbn) {
> +               if (max_load - this_load + SCHED_LOAD_SCALE_FUZZ >=
> +                                       busiest_load_per_task * imbn) {
> 
> So the below proposed change will probably break what the above
> mentioned commit was trying to achieve, which is: for fairness reasons
> we were bouncing the small extra load (between the max_load and
> this_load) around.

Actually, you can drop this patch.  

In the process of clarifying why it was needed for the changelog, I
discovered I don't actually need it.  

Sorry about that.

Mikey

> 
> > > ---
> > > 
> > >  kernel/sched_fair.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > Index: linux-2.6-ozlabs/kernel/sched_fair.c
> > > ===================================================================
> > > --- linux-2.6-ozlabs.orig/kernel/sched_fair.c
> > > +++ linux-2.6-ozlabs/kernel/sched_fair.c
> > > @@ -2652,7 +2652,7 @@ static inline void fix_small_imbalance(s
> > >  						 * SCHED_LOAD_SCALE;
> > >  	scaled_busy_load_per_task /= sds->busiest->cpu_power;
> > >  
> > > -	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
> > > +	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >
> > >  			(scaled_busy_load_per_task * imbn)) {
> > >  		*imbalance = sds->busiest_load_per_task;
> > >  		return;
> > 
> 
> thanks,
> suresh
> 
