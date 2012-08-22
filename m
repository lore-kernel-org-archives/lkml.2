Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab2HVRfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:35:55 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33141 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2HVRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:35:51 -0400
Date: Wed, 22 Aug 2012 19:35:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>,
        "3.2.x.." <stable@kernel.org>
Subject: Re: [PATCH 01/10] alpha: Add missing RCU idle APIs on idle loop
Message-ID: <20120822173542.GD13674@somewhere>
References: <1345652628-15060-1-git-send-email-fweisbec@gmail.com>
 <1345652628-15060-2-git-send-email-fweisbec@gmail.com>
 <20120822171930.GE2447@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822171930.GE2447@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 10:19:30AM -0700, Paul E. McKenney wrote:
> On Wed, Aug 22, 2012 at 06:23:39PM +0200, Frederic Weisbecker wrote:
> > In the old times, the whole idle task was considered
> > as an RCU quiescent state. But as RCU became more and
> > more successful overtime, some RCU read side critical
> > section have been added even in the code of some
> > architectures idle tasks, for tracing for example.
> > 
> > So nowadays, rcu_idle_enter() and rcu_idle_exit() must
> > be called by the architecture to tell RCU about the part
> > in the idle loop that doesn't make use of rcu read side
> > critical sections, typically the part that puts the CPU
> > in low power mode.
> > 
> > This is necessary for RCU to find the quiescent states in
> > idle in order to complete grace periods.
> > 
> > Add this missing pair of calls in the Alpha's idle loop.
> > 
> > Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Richard Henderson <rth@twiddle.net>
> > Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> > Cc: Matt Turner <mattst88@gmail.com>
> > Cc: alpha <linux-alpha@vger.kernel.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: 3.2.x.. <stable@kernel.org>
> > ---
> >  arch/alpha/kernel/process.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
> > index 153d3fc..2ebf7b5 100644
> > --- a/arch/alpha/kernel/process.c
> > +++ b/arch/alpha/kernel/process.c
> > @@ -28,6 +28,7 @@
> >  #include <linux/tty.h>
> >  #include <linux/console.h>
> >  #include <linux/slab.h>
> > +#include <linux/rcupdate.h>
> > 
> >  #include <asm/reg.h>
> >  #include <asm/uaccess.h>
> > @@ -50,13 +51,16 @@ cpu_idle(void)
> >  {
> >  	set_thread_flag(TIF_POLLING_NRFLAG);
> > 
> > +	preempt_disable();
> 
> I don't understand the above preempt_disable() not having a matching
> preempt_enable() at exit, but the rest of the patches in this series
> look good to me.

The current code is preemptable, at least it appears so because it calls
schedule() directly. And if I call rcu_idle_enter() in a preemptable section,
I'm in trouble because I'll schedule while in extended QS.

Thus I need to disable preemption here at least until I call rcu_idle_exit().

Now this is an endless loop so there is no need to re-enable
preemption after the loop. And schedule_preempt_disabled()
takes care of enabling preemption before schedule() and redisabling
it afterward.


> 
> 							Thanx, Paul
> 
> >  	while (1) {
> >  		/* FIXME -- EV6 and LCA45 know how to power down
> >  		   the CPU.  */
> > 
> > +		rcu_idle_enter();
> >  		while (!need_resched())
> >  			cpu_relax();
> > -		schedule();
> > +		rcu_idle_exit();
> > +		schedule_preempt_disabled();
> >  	}
> >  }
> > 
> > -- 
> > 1.7.5.4
> > 
> 
