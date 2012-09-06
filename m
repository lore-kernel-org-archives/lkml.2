Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2IFRUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:20:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47375 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab2IFRUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:20:06 -0400
Message-ID: <1346951591.18408.48.camel@twins>
Subject: Re: [PATCH tip/core/rcu 11/26] rcu: Exit RCU extended QS on user
 preemption
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Date: Thu, 06 Sep 2012 19:13:11 +0200
In-Reply-To: <1346950959.18408.47.camel@twins>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
	 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346360743-3628-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346950959.18408.47.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 19:02 +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 14:05 -0700, Paul E. McKenney wrote:
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > When exceptions or irq are about to resume userspace, if
> > the task needs to be rescheduled, the arch low level code
> > calls schedule() directly.
> > 
> > At that time we may be in extended quiescent state from RCU
> > POV: the exception is not anymore protected inside
> > rcu_user_exit() - rcu_user_enter() and the irq has called
> > rcu_irq_exit() already.
> > 
> > Create a new API schedule_user() that calls schedule() inside
> > rcu_user_exit()-rcu_user_enter() in order to protect it. Archs
> > will need to rely on it now to implement user preemption safely.
> 
> > ---
> >  kernel/sched/core.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 0bd599b..e841dfc 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -3463,6 +3463,13 @@ asmlinkage void __sched schedule(void)
> >  }
> >  EXPORT_SYMBOL(schedule);
> >  
> > +asmlinkage void __sched schedule_user(void)
> > +{
> > +	rcu_user_exit();
> > +	schedule();
> > +	rcu_user_enter();
> > +}
> 
> 
> OK, so colour me unconvinced.. why are we doing this?
> 
> Typically when we call schedule nr_running != 1 (we need current to be
> running and a possible target to switch to).
> 
> So I'd prefer to simply have schedule() disable all this adaptive tick
> nonsense and leave it at that.

In fact, the only way to get here is through ttwu(), which would have
done the nr_running increment and should have disabled all this adaptive
stuff.

So again,.. why?
