Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1H2SAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:00:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45427 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1H2SAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:00:32 -0400
Subject: Re: [PATCH 09/32] nohz: Move ts->idle_calls into strict idle logic
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 19:59:49 +0200
In-Reply-To: <20110829173426.GE9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-10-git-send-email-fweisbec@gmail.com>
	 <1314629267.2816.82.camel@twins>
	 <20110829173426.GE9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314640789.2816.122.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 19:34 +0200, Frederic Weisbecker wrote:
> On Mon, Aug 29, 2011 at 04:47:47PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > > +static bool tick_nohz_can_stop_tick(int cpu, struct tick_sched *ts)
> > > +{
> > > +       /*
> > > +        * If this cpu is offline and it is the one which updates
> > > +        * jiffies, then give up the assignment and let it be taken by
> > > +        * the cpu which runs the tick timer next. If we don't drop
> > > +        * this here the jiffies might be stale and do_timer() never
> > > +        * invoked.
> > > +        */
> > > +       if (unlikely(!cpu_online(cpu))) {
> > > +               if (cpu == tick_do_timer_cpu)
> > > +                       tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> > > +       }
> > > +
> > > +       if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
> > > +               return false;
> > > +
> > > +       if (need_resched())
> > > +               return false;
> > > +
> > > +       if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
> > > +               static int ratelimit;
> > > +
> > > +               if (ratelimit < 10) {
> > > +                       printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
> > > +                              (unsigned int) local_softirq_pending());
> > > +                       ratelimit++;
> > > +               }
> > > +               return false;
> > > +       }
> > > +
> > > +       return true;
> > > +} 
> > 
> > Why aren't rcu_needs_cpu(), printk_needs_cpu() and arch_needs_cpu() not
> > in there?
> > 
> > That are typical 'can we go sleep now?' functions.
> 
> Because when one of these functions are positive, the ts->next_jiffies and
> ts->last_jiffies stats are updated. Not with the above.
> Also I start to think the above checks are only useful in the idle case.

Then call it tick_nohz_can_stop_tick_idle() or so, and create
tick_nohz_can_stop_tick() to deal with all stuff.

> We still want tick_nohz_stop_sched_tick() to have the *needs_cpu() checks
> so that they can restore a HZ periodic behaviour on interrupt return if
> needed.

Well, no, on interrupt return you shouldn't do anything. If you've
stopped the tick it stays stopped until you do something that needs it,
then that action will re-enable it.

> That said I wonder if some of the above conditions should restore a periodic
> behaviour on interrupt return...

I would expect the tick not to be stopped when tick_nohz_can_stop_tick()
returns false. If it returns true, then I expect anything that needs it
to re-enable it.

