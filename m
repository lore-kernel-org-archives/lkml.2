Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0IWDP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:15:56 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44311 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0IWDPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:15:54 -0400
Date: Wed, 22 Sep 2010 20:15:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent] rcu: rcu_read_lock_bh_held():
 disabling irqs also disables bh
Message-ID: <20100923031550.GA2523@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100923003220.GA21822@linux.vnet.ibm.com>
 <4C9AAEA3.2020209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9AAEA3.2020209@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 09:34:27AM +0800, Lai Jiangshan wrote:
> On 09/23/2010 08:32 AM, Paul E. McKenney wrote:
> > rcu_dereference_bh() doesnt know yet about hard irq being disabled, so
> > lockdep can trigger in netpoll_rx() after commit f0f9deae9e7c4 (netpoll:
> > Disable IRQ around RCU dereference in netpoll_rx)
> > 
> > Reported-by: Miles Lane <miles.lane@gmail.com>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Tested-by: Miles Lane <miles.lane@gmail.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  include/linux/rcupdate.h |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 9fbc54a..0dcc00e 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -454,7 +454,8 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
> >   * Makes rcu_dereference_check() do the dirty work.
> >   */
> >  #define rcu_dereference_bh(p) \
> > -		rcu_dereference_check(p, rcu_read_lock_bh_held())
> > +		rcu_dereference_check(p, rcu_read_lock_bh_held() || \
> > +					 irqs_disabled())
> >  
> >  /**
> >   * rcu_dereference_sched - fetch RCU-protected pointer, checking for RCU-sched
> 
> In -rt, rcu_read_lock_bh() is preemptible, but all RCU Implementation,
> PREEMPT_RCU, TREE_PREEMPT_RCU, TINY_PREEMPT_RCU, do not guarantee
> hard-irq/irq-disabled contexts are preeemptible-rcu-read-site critical regions,
> so it(disabling irqs also disables bh) is not true in -rt I think,
> To make the codes be still safe in the future(-rt), I strongly recommend to
> use rcu_read_lock_bh() as needed even irq disabled.

We have been going back and forth on exactly how bh and irq
should interact.  The -rt case is indeed more interesting because
local_bh_disable() is a no-op when CONFIG_PREEMPT_HARDIRQS, but the
above patch is targeted only to mainline.  Either way, the current
implementations refuse to end a grace period until all CPUs have spent
some time with irqs enabled.  I don't want to export that guarantee, but
it might be OK for internal RCU use, including for rcu_dereference_bh().

Within mainline, one might make rcu_read_lock_bh() do something like:

	if (!irqs_disabled())
		local_bh_disable();

with corresponding changes for rcu_read_unlock_bh(), or, alternatively
have a separate API for use when the caller might have irqs disabled.

However, there is still a bit of contention about exactly how
rcu_read_lock_bh() should be handled if the caller might have irqs
disabled.  In the past, all calls to rcu_read_lock_bh() have had
irqs enabled, so this is a new situation.  Some would prefer that
rcu_read_lock_bh() require that irqs be enabled, for example.

I am sure that we will figure something out.  ;-)

> Current, preempt_disable()/rcu_read_lock_sched() do not guarantee that
> they implies rcu_read_lock() either.

Quite true!!!

> But in future, the rcu may give these guarantees, it's a plan of mine.

Back in PREEMPT_RCU days, I did put together patches for similar changes,
but did not push them.  Such guarantees are promises, and promises are
often easier to make in the here and now than to keep in the longer term.

							Thanx, Paul
