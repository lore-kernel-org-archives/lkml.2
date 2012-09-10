Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab2IJUbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:31:32 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41665 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2IJUba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:31:30 -0400
Date: Mon, 10 Sep 2012 22:31:21 +0200
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
Subject: Re: [PATCH tip/core/rcu 10/26] rcu: Exit RCU extended QS on kernel
 preemption after irq/exception
Message-ID: <20120910203103.GC19268@somewhere>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-10-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346950364.18408.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346950364.18408.38.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 06:52:44PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 14:05 -0700, Paul E. McKenney wrote:
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > When an exception or an irq exits, and we are going to resume into
> > interrupted kernel code, the low level architecture code calls
> > preempt_schedule_irq() if there is a need to reschedule.
> > 
> > If the interrupt/exception occured between a call to rcu_user_enter()
> > (from syscall exit, exception exit, do_notify_resume exit, ...) and
> > a real resume to userspace (iret,...), preempt_schedule_irq() can be
> > called whereas RCU thinks we are in userspace. But preempt_schedule_irq()
> > is going to run kernel code and may be some RCU read side critical
> > section. We must exit the userspace extended quiescent state before
> > we call it.
> > 
> > To solve this, just call rcu_user_exit() in the beginning of
> > preempt_schedule_irq().
> 
> > ---
> >  kernel/sched/core.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 07c6d9a..0bd599b 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -3564,6 +3564,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
> >  	/* Catch callers which need to be fixed */
> >  	BUG_ON(ti->preempt_count || !irqs_disabled());
> >  
> > +	rcu_user_exit();
> >  	do {
> >  		add_preempt_count(PREEMPT_ACTIVE);
> >  		local_irq_enable();
> 
> But in this case you want to restart the tick as well, are we going to
> add a nohz_user_exit() like call as well, or do we have something that
> does both?

Yeah this will soon become user_exit() and that hook will rely on the
nohz engine and RCU APIs accordingly.

For now I'm only focusing on the RCU user mode. In this patchset it
does the RCU user mode unconditionally. I'm just doing this to integrate
the things incrementally.

First RCU, then we turn that into some generic user hooks, then we handle
the cputime with a generic vtime, then we integrate the nohz engine which
drives the user_hooks such that we stop/restart the tick and RCU user
mode accordingly.
