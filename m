Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab2IJU0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:26:40 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39563 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab2IJU0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:26:38 -0400
Date: Mon, 10 Sep 2012 22:26:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: Re: [PATCH tip/core/rcu 11/26] rcu: Exit RCU extended QS on user
 preemption
Message-ID: <20120910202611.GB19268@somewhere>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346950959.18408.47.camel@twins>
 <1346951591.18408.48.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346951591.18408.48.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 07:13:11PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-06 at 19:02 +0200, Peter Zijlstra wrote:
> > On Thu, 2012-08-30 at 14:05 -0700, Paul E. McKenney wrote:
> > > From: Frederic Weisbecker <fweisbec@gmail.com>
> > > 
> > > When exceptions or irq are about to resume userspace, if
> > > the task needs to be rescheduled, the arch low level code
> > > calls schedule() directly.
> > > 
> > > At that time we may be in extended quiescent state from RCU
> > > POV: the exception is not anymore protected inside
> > > rcu_user_exit() - rcu_user_enter() and the irq has called
> > > rcu_irq_exit() already.
> > > 
> > > Create a new API schedule_user() that calls schedule() inside
> > > rcu_user_exit()-rcu_user_enter() in order to protect it. Archs
> > > will need to rely on it now to implement user preemption safely.
> > 
> > > ---
> > >  kernel/sched/core.c |    7 +++++++
> > >  1 files changed, 7 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > index 0bd599b..e841dfc 100644
> > > --- a/kernel/sched/core.c
> > > +++ b/kernel/sched/core.c
> > > @@ -3463,6 +3463,13 @@ asmlinkage void __sched schedule(void)
> > >  }
> > >  EXPORT_SYMBOL(schedule);
> > >  
> > > +asmlinkage void __sched schedule_user(void)
> > > +{
> > > +	rcu_user_exit();
> > > +	schedule();
> > > +	rcu_user_enter();
> > > +}
> > 
> > 
> > OK, so colour me unconvinced.. why are we doing this?
> > 
> > Typically when we call schedule nr_running != 1 (we need current to be
> > running and a possible target to switch to).
> > 
> > So I'd prefer to simply have schedule() disable all this adaptive tick
> > nonsense and leave it at that.
> 
> In fact, the only way to get here is through ttwu(), which would have
> done the nr_running increment and should have disabled all this adaptive
> stuff.
> 
> So again,.. why?

Ok, indeed if the ttwu happened locally or even remotely through an IPI, the
tick engine would stop the tick and exit that RCU extended quiescent state
before we reach that place.

I just want to be sure I'm covering every case. There are some places
around that call set_need_resched() even if no task is waiting for the CPU
(RCU is such an example). In this case the nohz engine won't exit the RCU
user mode before schedule().

Another example: a CPU does a remote wake up so it does set_need_resched()
and sends the IPI. The target CPU could see the TIF_RESCHED before resuming
userspace and call schedule_user() -> schedule() while the IPI has not
yet arrived. In this case we need that rcu_user_exit() before schedule might
make any use of RCU.

Also when the task returns from schedule(), if it's alone in the runqueue,
the rcu_user_enter() that follows can be helpful to stop the tick and
enter our RCU quiescent state.

Also I'm considering this RCU user extended quiescent state as a standalone
feature for now. Indeed the only user of it is the adaptive tickless thing.
But I'm treating that RCU part independantly for now so that it makes it
easier to merge, piecewise.

When the adaptive tickless stuff arrives, these rcu_user...() APIs will
be replaced by some user_enter() / user_exit() hooks that will all be
driven by the nohz subsystem. When we get there the rcu_user_enter()
rcu_user_exit() won't be unconditional anymore.
