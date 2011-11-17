Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1KQAsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 19:48:22 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39260 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1KQAsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 19:48:21 -0500
X-Originating-IP: 217.70.178.147
X-Originating-IP: 131.252.240.124
Date: Wed, 16 Nov 2011 16:48:07 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 2/9] rcu: Add rcutorture system-shutdown
 capability
Message-ID: <20111117004806.GA5201@leaf>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
 <1321388885-11211-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111115214615.GD31473@leaf>
 <20111116203226.GK2355@linux.vnet.ibm.com>
 <20111116221545.GA2325@leaf>
 <20111116224447.GO2355@linux.vnet.ibm.com>
 <20111116225856.GD2325@leaf>
 <20111116234358.GP2355@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116234358.GP2355@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 03:43:58PM -0800, Paul E. McKenney wrote:
> On Wed, Nov 16, 2011 at 02:58:56PM -0800, Josh Triplett wrote:
> > On Wed, Nov 16, 2011 at 02:44:47PM -0800, Paul E. McKenney wrote:
> > > On Wed, Nov 16, 2011 at 02:15:45PM -0800, Josh Triplett wrote:
> > > > On Wed, Nov 16, 2011 at 12:32:26PM -0800, Paul E. McKenney wrote:
> > > > > On Tue, Nov 15, 2011 at 01:46:15PM -0800, Josh Triplett wrote:
> > > > > > On Tue, Nov 15, 2011 at 12:27:58PM -0800, Paul E. McKenney wrote:
> > > > > > > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > > > > 
> > > > > > > Although it is easy to run rcutorture tests under KVM, there is currently
> > > > > > > no nice way to run such a test for a fixed time period, collect all of
> > > > > > > the rcutorture data, and then shut the system down cleanly.  This commit
> > > > > > > therefore adds an rcutorture module parameter named "shutdown_secs" that
> > > > > > > specified the run duration in seconds, after which rcutorture terminates
> > > > > > > the test and powers the system down.  The default value for "shutdown_secs"
> > > > > > > is zero, which disables shutdown.
> > > > > > > 
> > > > > > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > > 
> > > > > > >From your recent post on this, I thought you found a solution through
> > > > > > the init= parameter, which seems preferable.
> > > > > 
> > > > > For some things, the init= parameter does work great.  I do intend to
> > > > > use it when collecting event-tracing and debugfs data, for example.
> > > > > 
> > > > > However, there is still a need for RCU torture testing that will operate
> > > > > correctly regardless of how userspace is set up.  That, and there are
> > > > > quite a few different kernel test setup, each with their own peculiar
> > > > > capabilities and limitations.  So what happened was that before people
> > > > > suggested the init= approach, I implemented enough of the in-kernel
> > > > > approach to appreciate how much it simplifies life for the common case of
> > > > > "just torture-test RCU".  As in I should have done this long ago.
> > > > 
> > > > Seems like it would work just as easily to point init at a statically
> > > > linked C program which just sleeps for a fixed time and then shuts down.
> > > > However, given the special-purpose nature of rcutorture, I won't
> > > > complain that strongly.
> > > 
> > > I did consider a statically linked C program, but that can introduce the
> > > need for cross-compilation into situations that do not otherwise need it.
> > 
> > Wouldn't you need to cross-compile the kernel anyway in such situations?
> 
> Not necessarily, consider for example ABAT.  (IBM-specific test setup
> for those unfamiliar with it -- related to autotest.)

Which already handles compiling a kernel for you; ABAT just doesn't make
it as easy to compile userspace programs as it does for kernels. :)

> I suspect that the only way for you to be convinced is for you to write
> a script that takes your preferred approach for injecting a test into
> (say) a KVM instance.

Done and attached.

> Then compare that script to adding a few parameters to the boot line,
> namely: "rcutorture.stat_interval=15 rcutorture.shutdown_secs=3600
> rcutorture.rcutorture_runnable=1".  ;-)

I actually think stat_interval makes perfect sense, as does runnable.

> > > rcu_torture_shutdown(void *arg)
> > > {
> > > 	long delta;
> > > 	unsigned long jiffies_snap;
> > > 
> > > 	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
> > > 	jiffies_snap = ACCESS_ONCE(jiffies);
> > 
> > Why do you need to snapshot jiffies in this version but not in the
> > version you originally posted?
> 
> Because in the original, the maximum error was one second, which was
> not worth worrying about.

The original shouldn't have an error either.  If something incorrectly
caches jiffies, either version would sleep forever, not just for an
extra second.

> > > 	while (ULONG_CMP_LT(jiffies_snap, shutdown_time) &&
> > > 	       !kthread_should_stop()) {
> > > 		delta = shutdown_time - jiffies_snap;
> > > 		if (verbose)
> > > 			printk(KERN_ALERT "%s" TORTURE_FLAG
> > > 			       "rcu_torture_shutdown task: %lu "
> > > 			       "jiffies remaining\n",
> > > 			       torture_type, delta);
> > 
> > I suggested dropping this print entirely; under normal circumstances it
> > should never print.  It will only print if
> > schedule_timeout_interruptible wakes up spuriously.
> 
> OK, I can qualify with a firsttime local variable.

Oh, i see; it does print the very first time through.  In that case, you
could move the print out of the loop entirely, rather than using a
"first time" flag.

> > > 		schedule_timeout_interruptible(delta);
> > > 		jiffies_snap = ACCESS_ONCE(jiffies);
> > > 	}
> > 
> > Any reason this entire loop body couldn't just become
> > msleep_interruptible()?
> 
> Aha!!!  Because then it won't break out of the loop if someone does
> a rmmod of rcutorture.  Which will cause the rmmod to hang until
> the thing decides that it is time to shut down the system.  Which
> is why I need to do the sleep in smallish pieces -- I cannot sleep
> longer than I would be comfortable delaying the rmmod.
> 
> Which is why I think I need to revert back to the old version that
> did the schedule_timeout_interruptible(1).

Does kthread_stop not interrupt an interruptible kthread?  As far as I
can tell, rmmod of rcutorture currently finishes immediately, rather
than after all the one-second sleeps finish, which suggests that it
wakes up the threads in question.

- Josh Triplett
