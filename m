Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab2JPSp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:45:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44477 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2JPSp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:45:58 -0400
Date: Tue, 16 Oct 2012 11:34:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: peterz@infradead.org, acme@ghostprotocols.net, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 1/2] perf, cpu hotplug: Run CPU_STARTING notifiers
 with irqs disabled
Message-ID: <20121016183431.GF2385@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121016075809.3572.47848.stgit@srivatsabhat.in.ibm.com>
 <20121016163140.GA2385@linux.vnet.ibm.com>
 <507D8D3B.5000506@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507D8D3B.5000506@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101618-2876-0000-0000-000001176346
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 10:07:15PM +0530, Srivatsa S. Bhat wrote:
> On 10/16/2012 10:01 PM, Paul E. McKenney wrote:
> > On Tue, Oct 16, 2012 at 01:28:10PM +0530, Srivatsa S. Bhat wrote:
> >> The CPU_STARTING notifiers are supposed to be run with irqs disabled. But the
> >> perf_cpu_notifier() macro invokes them without doing that. Fix it.
> > 
> > Color me confused...
> 
> Hehe, I believe the context provided by diff tricked you ;-)
> The function I am referring to is perf_cpu_notifier(), not
> perf_event_task_tick() :-)

It did indeed fool me!  And indeed, checking the code did indeed show
that the name of interest if perf_cpu_notifier().

When using the correct name, I do indeed find places where it is
called with interrupts enabled.  So...

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Regards,
> Srivatsa S. Bhat
> 
> >  Isn't perf_event_task_tick() invoked only
> > from scheduler_tick(), which always has interrupts disabled?
> > 
> > Or are you needing to invoke it from somewhere else?
> > 
> > 							Thanx, Paul
> > 
> >> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> >> ---
> >>
> >>  include/linux/perf_event.h |    3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> >> index 2e90235..0647805 100644
> >> --- a/include/linux/perf_event.h
> >> +++ b/include/linux/perf_event.h
> >> @@ -803,10 +803,13 @@ static inline void perf_event_task_tick(void)				{ }
> >>  do {									\
> >>  	static struct notifier_block fn##_nb __cpuinitdata =		\
> >>  		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
> >> +	unsigned long flags;						\
> >>  	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
> >>  		(void *)(unsigned long)smp_processor_id());		\
> >> +	local_irq_save(flags);						\
> >>  	fn(&fn##_nb, (unsigned long)CPU_STARTING,			\
> >>  		(void *)(unsigned long)smp_processor_id());		\
> >> +	local_irq_restore(flags);					\
> >>  	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
> >>  		(void *)(unsigned long)smp_processor_id());		\
> >>  	register_cpu_notifier(&fn##_nb);				\
> >>
> 

