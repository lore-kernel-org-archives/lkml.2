Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3AHVHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:07:46 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46933 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab3AHVHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:07:45 -0500
Date: Tue, 8 Jan 2013 13:00:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 03/33] cputime: Generic on-demand virtual cputime
 accounting
Message-ID: <20130108210035.GS2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
 <1357610913-1080-4-git-send-email-fweisbec@gmail.com>
 <1357676771.5190.29.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357676771.5190.29.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010821-9360-0000-0000-00000EEC1793
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 03:26:11PM -0500, Steven Rostedt wrote:
> On Tue, 2013-01-08 at 03:08 +0100, Frederic Weisbecker wrote:
> 
> > diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> > index c952770..bd461ad 100644
> > --- a/kernel/context_tracking.c
> > +++ b/kernel/context_tracking.c
> > @@ -56,7 +56,7 @@ void user_enter(void)
> >  	local_irq_save(flags);
> >  	if (__this_cpu_read(context_tracking.active) &&
> >  	    __this_cpu_read(context_tracking.state) != IN_USER) {
> > -		__this_cpu_write(context_tracking.state, IN_USER);
> > +		vtime_user_enter(current);
> >  		/*
> >  		 * At this stage, only low level arch entry code remains and
> >  		 * then we'll run in userspace. We can assume there won't be
> > @@ -65,6 +65,7 @@ void user_enter(void)
> >  		 * on the tick.
> >  		 */
> >  		rcu_user_enter();
> 
> Hmm, the rcu_user_enter() can do quite a bit. Too bad we are accounting
> it as user time. I wonder if we could move the vtime_user_enter() below
> it. But then if vtime_user_enter() calls rcu_read_lock() it breaks.

If RCU_FAST_NO_HZ=y, the current mainline rcu_user_enter() can be a
bit expensive.  It is going on a diet for 3.9, however.

But there is a lower limit because the CPU moving to adaptive-tick user
mode must reliably inform other CPUs of this, which involves some
overhead due to memory-ordering issues.

							Thanx, Paul

> The notorious chicken vs egg ordeal!
> 
> -- Steve
> 
> > +		__this_cpu_write(context_tracking.state, IN_USER);
> >  	}
> >  	local_irq_restore(flags);
> >  }
> > @@ -90,12 +91,13 @@ void user_exit(void)
> >  
> >  	local_irq_save(flags);
> >  	if (__this_cpu_read(context_tracking.state) == IN_USER) {
> > -		__this_cpu_write(context_tracking.state, IN_KERNEL);
> >  		/*
> >  		 * We are going to run code that may use RCU. Inform
> >  		 * RCU core about that (ie: we may need the tick again).
> >  		 */
> >  		rcu_user_exit();
> > +		vtime_user_exit(current);
> > +		__this_cpu_write(context_tracking.state, IN_KERNEL);
> >  	}
> >  	local_irq_restore(flags);
> >  }
> 
> 

