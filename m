Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1LAA7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:59:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:9609 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab1LAA7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:59:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,274,1320652800"; 
   d="scan'208";a="42719638"
Subject: Re: [patch 3/6] sched, nohz: sched group, domain aware nohz idle
 load balancing
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Wed, 30 Nov 2011 17:03:34 -0800
In-Reply-To: <1322559859.2921.190.camel@twins>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230553.995756330@sbsiddha-desk.sc.intel.com>
	 <1322135263.2921.12.camel@twins>
	 <1322524316.21329.64.camel@sbsiddha-desk.sc.intel.com>
	 <1322559859.2921.190.camel@twins>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1322701415.21329.77.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 01:44 -0800, Peter Zijlstra wrote:
> On Mon, 2011-11-28 at 15:51 -0800, Suresh Siddha wrote:
> > On Thu, 2011-11-24 at 03:47 -0800, Peter Zijlstra wrote:
> > > On Fri, 2011-11-18 at 15:03 -0800, Suresh Siddha wrote:
> > > > +       for_each_domain(cpu, sd) {
> > > > +               struct sched_group *sg = sd->groups;
> > > > +               struct sched_group_power *sgp = sg->sgp;
> > > > +               int nr_busy = atomic_read(&sgp->nr_busy_cpus);
> > > > +
> > > > +               if (nr_busy > 1 && (nr_busy * SCHED_LOAD_SCALE > sgp->power))
> > > > +                       goto need_kick;
> > > 
> > > This looks wrong, its basically always true for a box with HT.
> > 
> > In the presence of two busy HT siblings, we need to do the idle load
> > balance to figure out if the load from the busy core can be migrated to
> > any other idle core/sibling in the platform. And at this point, we
> > already know there are idle cpu's in the platform.
> 
> might have to, this nr_busy doesn't mean its actually busy, just that
> its not nohz, it might very well be idle.

correct. But we can change that.

We can track nr_busy_cpus separately and can be updated when ever the rq
goes into idle and during the first busy tick after idle. Whereas the
nohz.idle_cpus_mask can be updated only during tickless entry.

> > I will modify the above check to:
> > 
> > if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
> > 	goto need_kick;
> > 
> > This way, if there is a SMT/MC domain with more than one busy cpu in the
> > group, then we will request for the idle load balancing.
> 
> Potentially 1 more than 1 busy, right? And we do the balancing just in
> case there are indeed busy cpus.
> 
> I think its useful to mention that somewhere near, that this nr_busy
> measure we use is an upper bound on actual busy.

The above should cover this.

I will send the updated version shortly.

thanks,
suresh

