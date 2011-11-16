Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1KPXo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 18:44:56 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35447 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab1KPXoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 18:44:54 -0500
Date: Wed, 16 Nov 2011 15:43:58 -0800
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
Message-ID: <20111116234358.GP2355@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111115202736.GA11030@linux.vnet.ibm.com>
 <1321388885-11211-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111115214615.GD31473@leaf>
 <20111116203226.GK2355@linux.vnet.ibm.com>
 <20111116221545.GA2325@leaf>
 <20111116224447.GO2355@linux.vnet.ibm.com>
 <20111116225856.GD2325@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116225856.GD2325@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111623-5806-0000-0000-000007C2037B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 02:58:56PM -0800, Josh Triplett wrote:
> On Wed, Nov 16, 2011 at 02:44:47PM -0800, Paul E. McKenney wrote:
> > On Wed, Nov 16, 2011 at 02:15:45PM -0800, Josh Triplett wrote:
> > > On Wed, Nov 16, 2011 at 12:32:26PM -0800, Paul E. McKenney wrote:
> > > > On Tue, Nov 15, 2011 at 01:46:15PM -0800, Josh Triplett wrote:
> > > > > On Tue, Nov 15, 2011 at 12:27:58PM -0800, Paul E. McKenney wrote:
> > > > > > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > > > 
> > > > > > Although it is easy to run rcutorture tests under KVM, there is currently
> > > > > > no nice way to run such a test for a fixed time period, collect all of
> > > > > > the rcutorture data, and then shut the system down cleanly.  This commit
> > > > > > therefore adds an rcutorture module parameter named "shutdown_secs" that
> > > > > > specified the run duration in seconds, after which rcutorture terminates
> > > > > > the test and powers the system down.  The default value for "shutdown_secs"
> > > > > > is zero, which disables shutdown.
> > > > > > 
> > > > > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > 
> > > > > >From your recent post on this, I thought you found a solution through
> > > > > the init= parameter, which seems preferable.
> > > > 
> > > > For some things, the init= parameter does work great.  I do intend to
> > > > use it when collecting event-tracing and debugfs data, for example.
> > > > 
> > > > However, there is still a need for RCU torture testing that will operate
> > > > correctly regardless of how userspace is set up.  That, and there are
> > > > quite a few different kernel test setup, each with their own peculiar
> > > > capabilities and limitations.  So what happened was that before people
> > > > suggested the init= approach, I implemented enough of the in-kernel
> > > > approach to appreciate how much it simplifies life for the common case of
> > > > "just torture-test RCU".  As in I should have done this long ago.
> > > 
> > > Seems like it would work just as easily to point init at a statically
> > > linked C program which just sleeps for a fixed time and then shuts down.
> > > However, given the special-purpose nature of rcutorture, I won't
> > > complain that strongly.
> > 
> > I did consider a statically linked C program, but that can introduce the
> > need for cross-compilation into situations that do not otherwise need it.
> 
> Wouldn't you need to cross-compile the kernel anyway in such situations?

Not necessarily, consider for example ABAT.  (IBM-specific test setup
for those unfamiliar with it -- related to autotest.)

I suspect that the only way for you to be convinced is for you to write
a script that takes your preferred approach for injecting a test into
(say) a KVM instance.

Then compare that script to adding a few parameters to the boot line,
namely: "rcutorture.stat_interval=15 rcutorture.shutdown_secs=3600
rcutorture.rcutorture_runnable=1".  ;-)

Using the parameters allows me to not care about the filesystem type, any
need to fsck, instruction set, the distro, and even the type of userspace.
Highly recommended!

> > > > > > +static int
> > > > > > +rcu_torture_shutdown(void *arg)
> > > > > > +{
> > > > > > +	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
> > > > > > +	while (ULONG_CMP_LT(jiffies, shutdown_time) &&
> > > > > > +	       !kthread_should_stop()) {
> > > > > > +		if (verbose)
> > > > > > +			printk(KERN_ALERT "%s" TORTURE_FLAG
> > > > > > +			       "rcu_torture_shutdown task: %lu "
> > > > > > +			       "jiffies remaining\n",
> > > > > > +			       torture_type, shutdown_time - jiffies);
> > > > > > +		schedule_timeout_interruptible(HZ);
> > > > > > +	}
> > > > > 
> > > > > Any particular reason to wake up once a second here?  If !verbose, this could just
> > > > > sleep until shutdown time.  (And does the verbose output really help
> > > > > here, given printk timestamps?)
> > > > 
> > > > It actually did help me find a bug where it was failing to shut down.
> > > > I could use different code paths, but that would defeat the debugging.
> > > > 
> > > > So I increased the sleep time to 30 seconds.  Fair enough?
> > > 
> > > Well, now that you've debugged rcutorture's shutdown routine, would it
> > > suffice to have a printk when you actually go to shut down, without
> > > waking up for previous printks when not shutting down yet?
> > > 
> > > (The poll time doesn't really matter, and sleeping for 30 seconds before
> > > checking the time means you might overshoot by up to 30 seconds.  I'd
> > > like to avoid polling to begin with when you know exactly how long you
> > > need to sleep.)
> > 
> > Indeed, good points!  But please see below for what this function turns
> > into when taking that approach.
> 
> See below for responses; that version seems like an improvement, though
> it could still improve further.
> 
> > rcu_torture_shutdown(void *arg)
> > {
> > 	long delta;
> > 	unsigned long jiffies_snap;
> > 
> > 	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
> > 	jiffies_snap = ACCESS_ONCE(jiffies);
> 
> Why do you need to snapshot jiffies in this version but not in the
> version you originally posted?

Because in the original, the maximum error was one second, which was
not worth worrying about.

> > 	while (ULONG_CMP_LT(jiffies_snap, shutdown_time) &&
> > 	       !kthread_should_stop()) {
> > 		delta = shutdown_time - jiffies_snap;
> > 		if (verbose)
> > 			printk(KERN_ALERT "%s" TORTURE_FLAG
> > 			       "rcu_torture_shutdown task: %lu "
> > 			       "jiffies remaining\n",
> > 			       torture_type, delta);
> 
> I suggested dropping this print entirely; under normal circumstances it
> should never print.  It will only print if
> schedule_timeout_interruptible wakes up spuriously.

OK, I can qualify with a firsttime local variable.

> > 		schedule_timeout_interruptible(delta);
> > 		jiffies_snap = ACCESS_ONCE(jiffies);
> > 	}
> 
> Any reason this entire loop body couldn't just become
> msleep_interruptible()?

Aha!!!  Because then it won't break out of the loop if someone does
a rmmod of rcutorture.  Which will cause the rmmod to hang until
the thing decides that it is time to shut down the system.  Which
is why I need to do the sleep in smallish pieces -- I cannot sleep
longer than I would be comfortable delaying the rmmod.

Which is why I think I need to revert back to the old version that
did the schedule_timeout_interruptible(1).

> > 	if (ULONG_CMP_LT(jiffies_snap, shutdown_time)) {
> > 		VERBOSE_PRINTK_STRING("rcu_torture_shutdown task stopping");
> > 		return 0;
> > 	}
> 
> Writing this as "if (kthread_should_stop())" seems clearer.

I don't have any real preference here, but as long as I need to
back out the earlier changes, I might as well make this one.  ;-)

							Thanx, Paul

