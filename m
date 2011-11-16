Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1KPUiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 15:38:20 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57021 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1KPUiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 15:38:19 -0500
Date: Wed, 16 Nov 2011 12:32:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 2/9] rcu: Add rcutorture system-shutdown
 capability
Message-ID: <20111116203226.GK2355@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111115202736.GA11030@linux.vnet.ibm.com>
 <1321388885-11211-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111115214615.GD31473@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115214615.GD31473@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111620-1976-0000-0000-000004590D7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:46:15PM -0800, Josh Triplett wrote:
> On Tue, Nov 15, 2011 at 12:27:58PM -0800, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > Although it is easy to run rcutorture tests under KVM, there is currently
> > no nice way to run such a test for a fixed time period, collect all of
> > the rcutorture data, and then shut the system down cleanly.  This commit
> > therefore adds an rcutorture module parameter named "shutdown_secs" that
> > specified the run duration in seconds, after which rcutorture terminates
> > the test and powers the system down.  The default value for "shutdown_secs"
> > is zero, which disables shutdown.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> >From your recent post on this, I thought you found a solution through
> the init= parameter, which seems preferable.

For some things, the init= parameter does work great.  I do intend to
use it when collecting event-tracing and debugfs data, for example.

However, there is still a need for RCU torture testing that will operate
correctly regardless of how userspace is set up.  That, and there are
quite a few different kernel test setup, each with their own peculiar
capabilities and limitations.  So what happened was that before people
suggested the init= approach, I implemented enough of the in-kernel
approach to appreciate how much it simplifies life for the common case of
"just torture-test RCU".  As in I should have done this long ago.

I will therefore be taking both approaches.  There will be at least one
more patch pushing what is now script into rcutorture.c.

> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -61,9 +61,10 @@ static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
> >  static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
> >  static int stutter = 5;		/* Start/stop testing interval (in sec) */
> >  static int irqreader = 1;	/* RCU readers from irq (timers). */
> > -static int fqs_duration = 0;	/* Duration of bursts (us), 0 to disable. */
> > -static int fqs_holdoff = 0;	/* Hold time within burst (us). */
> > +static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
> > +static int fqs_holdoff;		/* Hold time within burst (us). */
> 
> Looks like these lines picked up unrelated whitespace changes in this
> commit.

Turns out that my initial patch added another variable that I explicitly
initialized to zero.  Of course, checkpatch yelled at me about this, so
I figured I should fix the other nearby occurrences of this while I was
at it.  Doesn't really seem to me to be worth a separate patch, though.

> > @@ -1305,6 +1313,37 @@ static int rcutorture_booster_init(int cpu)
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Cause the rcutorture test to "stutter", starting and stopping all
> > + * threads periodically.
> > + */
> 
> This comment looks like a copy-paste error.

Or maybe a copy-paste stutter.  ;-)

Good eyes, fixed!

> > +static int
> > +rcu_torture_shutdown(void *arg)
> > +{
> > +	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
> > +	while (ULONG_CMP_LT(jiffies, shutdown_time) &&
> > +	       !kthread_should_stop()) {
> > +		if (verbose)
> > +			printk(KERN_ALERT "%s" TORTURE_FLAG
> > +			       "rcu_torture_shutdown task: %lu "
> > +			       "jiffies remaining\n",
> > +			       torture_type, shutdown_time - jiffies);
> > +		schedule_timeout_interruptible(HZ);
> > +	}
> 
> Any particular reason to wake up once a second here?  If !verbose, this could just
> sleep until shutdown time.  (And does the verbose output really help
> here, given printk timestamps?)

It actually did help me find a bug where it was failing to shut down.
I could use different code paths, but that would defeat the debugging.

So I increased the sleep time to 30 seconds.  Fair enough?

> > +	if (ULONG_CMP_LT(jiffies, shutdown_time)) {
> > +		VERBOSE_PRINTK_STRING("rcu_torture_shutdown task stopping");
> > +		return 0;
> > +	}
> > +
> > +	/* OK, shut down the system. */
> > +
> > +	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task shutting down system");
> > +	shutdown_task = NULL;	/* Avoid self-kill deadlock. */
> 
> Not that it matters much here, but won't this cause a leak?

Only if we are shutting down.  And the alternative is a deadlock
where this task invokes kthread_stop() on itself.  ;-)

> > +	rcu_torture_cleanup();	/* Get the success/failure message. */
> > +	kernel_power_off();	/* Shut down the system. */
> > +	return 0;
> > +}
> 
> Huh.  I would have expected kernel_power_off to use noreturn, making the
> return 0 unnecessary here; however, apparently it doesn't.

Indeed, gcc yelled at me, so I added the "return 0".  ;-)

							Thanx, Paul

