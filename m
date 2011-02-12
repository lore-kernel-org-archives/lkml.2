Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab1BLBUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 20:20:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:22619 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab1BLBUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 20:20:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,459,1291622400"; 
   d="scan'208";a="656942302"
Subject: Re: [PATCH] sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Nick Piggin <npiggin@gmail.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
In-Reply-To: <1297266928.13327.216.camel@laptop>
References: <1296852688-1665-1-git-send-email-venki@google.com>
	 <1296854731-25039-1-git-send-email-venki@google.com>
	 <1297086642.13327.15.camel@laptop>
	 <AANLkTi=xo8bq6uTjYQ7yxJ69ATry1Xs3q0deE7UN9jPj@mail.gmail.com>
	 <1297108399.8221.35.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1297266928.13327.216.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 11 Feb 2011 17:20:16 -0800
Message-Id: <1297473616.2806.16.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 07:55 -0800, Peter Zijlstra wrote:
> On Mon, 2011-02-07 at 11:53 -0800, Suresh Siddha wrote:
> > 
> > Peter, to answer your question of why SMT is treated different to cores
> > sharing cache, performance improvements contributed by SMT is far less
> > compared to the cores and any wrong decisions in SMT load balancing
> > (especially in the presence of idle cores, packages) has a bigger
> > impact.
> > 
> > I think in the tbench case referred by Nick, idle HT siblings in a busy
> > package picked the load instead of the idle packages. And thus we
> > probably had to wait for active load balance to kick in to distribute
> > the load etc by which the damage would have been. Performance impact of
> > this condition wouldn't be as severe in the cores sharing last level
> > cache and other resources.
> > 
> > Also there are lot of changes in this area since 2005. So it would be
> > nice to revisit the tbench case and see if the logic of propagating busy
> > sibling status to the higher level load balances is still needed or not.
> > 
> > On the contrary, perhaps there might be some workloads which may benefit
> > in performance/latency if we completely do away with this less
> > aggressive SMT load balancing. 
> 
> Right, but our current capacity logic does exactly that and seems to
> work for more than 2 smt siblings (it does the whole asymmetric power7
> muck).
> 
> From a quick glance at the sched.c state at the time of Nick's patch,
> the capacity logic wasn't around then.

Yes Peter. We have lot more logic now which is trying to predict the
imbalance between the groups more accurately.

> 
> So I see no reason what so ever to keep this SMT exception.

I am also ok with removing this code. But as Venki mentioned earlier
(http://marc.info/?l=linux-kernel&m=129735866732171&w=2), we need to
make sure idle core gets priority instead of an idle smt-thread on a
busy core while pulling the load from the busiest socket.

I requested Venki to post these 2 patches of removing the propagation of
busy sibling status to an idle sibling and prioritizing the idle core
while pulling the load. I will request Alex and Tim to run their
performance workloads to make sure that this doesn't show any
regressions.

thanks,
suresh

