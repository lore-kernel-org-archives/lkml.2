Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1BGTxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:53:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:42596 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab1BGTxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:53:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,438,1291622400"; 
   d="scan'208";a="655258927"
Subject: Re: [PATCH] sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Nick Piggin <npiggin@gmail.com>
In-Reply-To: <AANLkTi=xo8bq6uTjYQ7yxJ69ATry1Xs3q0deE7UN9jPj@mail.gmail.com>
References: <1296852688-1665-1-git-send-email-venki@google.com>
	 <1296854731-25039-1-git-send-email-venki@google.com>
	 <1297086642.13327.15.camel@laptop>
	 <AANLkTi=xo8bq6uTjYQ7yxJ69ATry1Xs3q0deE7UN9jPj@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 07 Feb 2011 11:53:19 -0800
Message-Id: <1297108399.8221.35.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 10:21 -0800, Venkatesh Pallipadi wrote: 
> On Mon, Feb 7, 2011 at 5:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Why is SMT treaded differently from say a shared cache? In both cases we
> > want to spread the load as wide as possible to provide as much of the
> > resources to the few runnable tasks.
> >
> 
> IIRC, the reason for the whole sd_idle part was to have less aggressive
> load balance when one SMT sibling is busy and other is idle, in order not
> to take CPU cycles away from the busy sibling.
> Suresh will know the exact reasoning behind this and which CPUs and
> which workload this helped..

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5969fe06

Original code came from Nick in 2005.

        [PATCH] sched: HT optimisation
        
        If an idle sibling of an HT queue encounters a busy sibling, then make
        higher level load balancing of the non-idle variety.
        
        Performance of multiprocessor HT systems with low numbers of tasks
        (generally < number of virtual CPUs) can be significantly worse than the
        exact same workloads when running in non-HT mode.  The reason is largely
        due to poor scheduling behaviour.
        
        This patch improves the situation, making the performance gap far less
        significant on one problematic test case (tbench).
        

Peter, to answer your question of why SMT is treated different to cores
sharing cache, performance improvements contributed by SMT is far less
compared to the cores and any wrong decisions in SMT load balancing
(especially in the presence of idle cores, packages) has a bigger
impact.

I think in the tbench case referred by Nick, idle HT siblings in a busy
package picked the load instead of the idle packages. And thus we
probably had to wait for active load balance to kick in to distribute
the load etc by which the damage would have been. Performance impact of
this condition wouldn't be as severe in the cores sharing last level
cache and other resources.

Also there are lot of changes in this area since 2005. So it would be
nice to revisit the tbench case and see if the logic of propagating busy
sibling status to the higher level load balances is still needed or not.

On the contrary, perhaps there might be some workloads which may benefit
in performance/latency if we completely do away with this less
aggressive SMT load balancing.

Venki, as you are looking into the fixes in this area, can you run your
workloads (aswell as tbench) and compare the logic with your fixes vs
removing this logic ?

thanks,
suresh

