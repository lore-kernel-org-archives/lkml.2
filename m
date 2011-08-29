Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1H2S2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:28:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60404 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1H2S2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:28:44 -0400
Date: Mon, 29 Aug 2011 20:28:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 13/32] nohz: Adaptive tick stop and restart on nohz cpuset
Message-ID: <20110829182836.GI9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-14-git-send-email-fweisbec@gmail.com>
 <1314631689.2816.91.camel@twins>
 <20110829180222.GG9748@somewhere.redhat.com>
 <1314641230.2816.129.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314641230.2816.129.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 08:07:10PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-29 at 20:02 +0200, Frederic Weisbecker wrote:
> > On Mon, Aug 29, 2011 at 05:28:09PM +0200, Peter Zijlstra wrote:
> > > On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > > > +bool cpuset_nohz_can_stop_tick(void)
> > > > +{
> > > > +       struct rq *rq;
> > > > +
> > > > +       rq = this_rq();
> > > > +
> > > > +       /* More than one running task need preemption */
> > > > +       if (rq->nr_running > 1)
> > > > +               return false;
> > > > +
> > > > +       return true;
> > > > +} 
> > > 
> > > int sched_needs_cpu(int cpu), seems the right name, matches the existing
> > > {rcu,printk,arch}_needs_cpu() functions.
> > 
> > tick_nohz_stop_sched_tick() already handles that by keeping a periodic
> > behaviour if one of these conditions are met.
> 
> What? tick_nohz_stop_sched_tick() most surely cannot access struct rq,
> so it cannot do the nr_running test.

I was talking about {rcu,printk,arch}_needs_cpu() functions.

> 
> > It has also the upside to restore the periodic behaviour if needed
> > from irq return if the tick was stopped.
> 
> Again, what?

If the tick is stopped then an irq fires and something calls printk() or call_rcu()
then on interrupt return, tick_nohz_stop_sched_tick() checks that
with {rcu,printk,arch}_needs_cpu() and restores a periodic behaviour
until nobody else needs the CPU.
