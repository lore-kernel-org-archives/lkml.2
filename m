Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab0DAVFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:05:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:45610 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab0DAVFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:05:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,350,1267430400"; 
   d="scan'208";a="261242289"
Subject: Re: [patch v2 1/2] sched: check for prev_cpu == this_cpu before
 calling wake_affine()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1270099940.6707.148.camel@marge.simson.net>
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
	 <1270031119.5003.93.camel@laptop>
	 <1270079265.7835.8.camel@sbs-t61.sc.intel.com>
	 <1270099940.6707.148.camel@marge.simson.net>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 01 Apr 2010 14:04:32 -0700
Message-Id: <1270155872.2762.310.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 22:32 -0700, Mike Galbraith wrote:
> On Wed, 2010-03-31 at 16:47 -0700, Suresh Siddha wrote:
> 
> > Issues in the current select_idle_sibling() logic in select_task_rq_fair()
> > in the context of a task wake-up:
> > 
> > a) Once we select the idle sibling, we use that domain (spanning the cpu that
> >    the task is currently woken-up and the idle sibling that we found) in our
> >    wake_affine() decisions. This domain is completely different from the
> >    domain(we are supposed to use) that spans the cpu that the task currently
> >    woken-up and the cpu where the task previously ran.
> 
> Why does that matter?  If we find an idle shared cache cpu before we hit
> the spanning domain, we don't use affine_sd other than maybe (unlikely)
> for updating group scheduler shares.

Ok. This is not a big issue with the new idle cpu change, as atleast we
don't endup calling wake_affine() with the wrong sd. I have never tried
to understand any code surrounded by CONFIG_FAIR_GROUP_SCHED so can't
comment if the using affine_sd for updating group scheduler shares is
correct or not. But please look below for the issues with selecting the
idle sibling right away.

> 
> > b) We do select_idle_sibling() check only for the cpu that the task is
> >    currently woken-up on. If select_task_rq_fair() selects the previously run
> >    cpu for waking the task, doing a select_idle_sibling() check
> >    for that cpu also helps and we don't do this currently.
> 
> True, but that costs too.  Those idle checks aren't cheap.

Just like the current code, my patch is doing the idle checks only once.
Current code is doing idle checks for the woken-up cpu and my code is
first selecting woken-up vs previously-ran and then doing idle sibling
checks . So don't expect to see much cost increase.

> 
> > c) In the scenarios where the cpu that the task is woken-up is busy but
> >    with its HT siblings are idle, we are selecting the task be woken-up
> >    on the idle HT sibling instead of a core that it previously ran
> >    and currently completely idle. i.e., we are not taking decisions based on
> >    wake_affine() but directly selecting an idle sibling that can cause
> >    an imbalance at the SMT/MC level which will be later corrected by the
> >    periodic load balancer.
> 
> Yes, the pressing decision for this one wakeup is can we wake to a
> shared cache and thus avoid cache misses.

Last level cache sharing is much more important than small L1 and mid
level caches. Also performance impact of keeping both the threads on a
core busy in the context of an idle core and then periodic balancer
coming in and correcting this is more costly.

> IMHO, the point of the affinity decision isn't instant perfect balance,
> it's cache affinity if at all possible without wrecking balance.

For not wrecking balance we should do the wake_balance() and based on
that decision, do the select_idle_sibling() for selecting an idle cpu in
that cache affinity. Current code in -tip is opposite of this.

> Load balancing moves tasks for optimal CPU utilization, tasks waking each
> other pull to a shared domain.. a tug-of-war that balances buddies over
> time.  
>
> wake_affine()'s job is only to say "no, leave it where it was for
> now".  I don't see any reason to ask wake_affine()'s opinion about an
> idle CPU.  We paid for idle shared cache knowledge.
> 
> We certainly wouldn't want to leave the wakee on it's previous CPU only
> because that CPU is idle, it would have to be idle and sharing cache.

Consider this scenario. Today we do balance on fork() and exec(). This
will cause the tasks to start far away. On systems like NHM-EP, tasks
will start on two different sockets/nodes(as each socket is a numa node)
and allocate their memory locally etc. Task A starting on Node-0 and
Task B starting on Node-1. Once task B sleeps and if Task A or something
else wakes up task B on Node-0, (with the recent change) just because
there is an idle HT sibling on node-0 we endup waking the task on
node-0. This is wrong. We should first atleast go through wake_affine()
and if wake_affine() says ok to move the task to node-0, then we can
look at the cache siblings for node-0 and select an appropriate cpu.

thanks,
suresh

