Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab1H2Rej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:34:39 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42909 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab1H2Ree (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:34:34 -0400
Date: Mon, 29 Aug 2011 19:34:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/32] nohz: Move ts->idle_calls into strict idle logic
Message-ID: <20110829173426.GE9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-10-git-send-email-fweisbec@gmail.com>
 <1314629267.2816.82.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314629267.2816.82.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:47:47PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > +static bool tick_nohz_can_stop_tick(int cpu, struct tick_sched *ts)
> > +{
> > +       /*
> > +        * If this cpu is offline and it is the one which updates
> > +        * jiffies, then give up the assignment and let it be taken by
> > +        * the cpu which runs the tick timer next. If we don't drop
> > +        * this here the jiffies might be stale and do_timer() never
> > +        * invoked.
> > +        */
> > +       if (unlikely(!cpu_online(cpu))) {
> > +               if (cpu == tick_do_timer_cpu)
> > +                       tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> > +       }
> > +
> > +       if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
> > +               return false;
> > +
> > +       if (need_resched())
> > +               return false;
> > +
> > +       if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
> > +               static int ratelimit;
> > +
> > +               if (ratelimit < 10) {
> > +                       printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
> > +                              (unsigned int) local_softirq_pending());
> > +                       ratelimit++;
> > +               }
> > +               return false;
> > +       }
> > +
> > +       return true;
> > +} 
> 
> Why aren't rcu_needs_cpu(), printk_needs_cpu() and arch_needs_cpu() not
> in there?
> 
> That are typical 'can we go sleep now?' functions.

Because when one of these functions are positive, the ts->next_jiffies and
ts->last_jiffies stats are updated. Not with the above.
Also I start to think the above checks are only useful in the idle case.

We still want tick_nohz_stop_sched_tick() to have the *needs_cpu() checks
so that they can restore a HZ periodic behaviour on interrupt return if
needed.

That said I wonder if some of the above conditions should restore a periodic
behaviour on interrupt return...
