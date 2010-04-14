Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0DNBcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 21:32:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:35249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab0DNBcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 21:32:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,201,1270450800"; 
   d="scan'208";a="557698941"
Subject: Re: [PATCH 5/5] sched: make fix_small_imbalance work with
 asymmetric packing
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1271161769.4807.1283.camel@twins>
References: <20100409062119.10AC5CBB6D@localhost.localdomain>
	 <1271161769.4807.1283.camel@twins>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 13 Apr 2010 18:31:10 -0700
Message-Id: <1271208670.2834.55.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 05:29 -0700, Peter Zijlstra wrote:
> On Fri, 2010-04-09 at 16:21 +1000, Michael Neuling wrote:
> > With the asymmetric packing infrastructure, fix_small_imbalance is
> > causing idle higher threads to pull tasks off lower threads.  
> > 
> > This is being caused by an off-by-one error.  
> > 
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > ---
> > I'm not sure this is the right fix but without it, higher threads pull
> > tasks off the lower threads, then the packing pulls it back down, etc
> > etc and tasks bounce around constantly.
> 
> Would help if you expand upon the why/how it manages to get pulled up.
> 
> I can't immediately spot anything wrong with the patch, but then that
> isn't my favourite piece of code either.. Suresh, any comments?
> 

Sorry didn't pay much attention to this patchset. But based on the
comments from Michael and looking at this patchset, it has SMT/MC
implications. I will review and run some tests and get back in a day.

As far as this particular patch is concerned, original code is coming
from Ingo's original CFS code commit (dd41f596) and the below hunk
pretty much explains what the change is about.

-               if (max_load - this_load >= busiest_load_per_task * imbn) {
+               if (max_load - this_load + SCHED_LOAD_SCALE_FUZZ >=
+                                       busiest_load_per_task * imbn) {

So the below proposed change will probably break what the above
mentioned commit was trying to achieve, which is: for fairness reasons
we were bouncing the small extra load (between the max_load and
this_load) around.

> > ---
> > 
> >  kernel/sched_fair.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6-ozlabs/kernel/sched_fair.c
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/kernel/sched_fair.c
> > +++ linux-2.6-ozlabs/kernel/sched_fair.c
> > @@ -2652,7 +2652,7 @@ static inline void fix_small_imbalance(s
> >  						 * SCHED_LOAD_SCALE;
> >  	scaled_busy_load_per_task /= sds->busiest->cpu_power;
> >  
> > -	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
> > +	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >
> >  			(scaled_busy_load_per_task * imbn)) {
> >  		*imbalance = sds->busiest_load_per_task;
> >  		return;
> 

thanks,
suresh

