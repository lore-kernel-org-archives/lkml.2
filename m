Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1KQBlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 20:41:11 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47962 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab1KQBlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 20:41:08 -0500
Date: Wed, 16 Nov 2011 17:40:57 -0800
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
Message-ID: <20111117014056.GS2355@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111115202736.GA11030@linux.vnet.ibm.com>
 <1321388885-11211-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111115214615.GD31473@leaf>
 <20111116203226.GK2355@linux.vnet.ibm.com>
 <20111116221545.GA2325@leaf>
 <20111116224447.GO2355@linux.vnet.ibm.com>
 <20111116225856.GD2325@leaf>
 <20111116234358.GP2355@linux.vnet.ibm.com>
 <20111117004923.GB5201@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117004923.GB5201@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111701-7182-0000-0000-00000034D231
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 04:49:23PM -0800, Josh Triplett wrote:
> [Resending with attachment this time.]
> 
> On Wed, Nov 16, 2011 at 03:43:58PM -0800, Paul E. McKenney wrote:
> > On Wed, Nov 16, 2011 at 02:58:56PM -0800, Josh Triplett wrote:
> > > On Wed, Nov 16, 2011 at 02:44:47PM -0800, Paul E. McKenney wrote:
> > > > On Wed, Nov 16, 2011 at 02:15:45PM -0800, Josh Triplett wrote:
> > > > > On Wed, Nov 16, 2011 at 12:32:26PM -0800, Paul E. McKenney wrote:
> > > > > > On Tue, Nov 15, 2011 at 01:46:15PM -0800, Josh Triplett wrote:
> > > > > > > On Tue, Nov 15, 2011 at 12:27:58PM -0800, Paul E. McKenney wrote:
> > > > > > > > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > > > > > 
> > > > > > > > Although it is easy to run rcutorture tests under KVM, there is currently
> > > > > > > > no nice way to run such a test for a fixed time period, collect all of
> > > > > > > > the rcutorture data, and then shut the system down cleanly.  This commit
> > > > > > > > therefore adds an rcutorture module parameter named "shutdown_secs" that
> > > > > > > > specified the run duration in seconds, after which rcutorture terminates
> > > > > > > > the test and powers the system down.  The default value for "shutdown_secs"
> > > > > > > > is zero, which disables shutdown.
> > > > > > > > 
> > > > > > > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > > > 
> > > > > > > >From your recent post on this, I thought you found a solution through
> > > > > > > the init= parameter, which seems preferable.
> > > > > > 
> > > > > > For some things, the init= parameter does work great.  I do intend to
> > > > > > use it when collecting event-tracing and debugfs data, for example.
> > > > > > 
> > > > > > However, there is still a need for RCU torture testing that will operate
> > > > > > correctly regardless of how userspace is set up.  That, and there are
> > > > > > quite a few different kernel test setup, each with their own peculiar
> > > > > > capabilities and limitations.  So what happened was that before people
> > > > > > suggested the init= approach, I implemented enough of the in-kernel
> > > > > > approach to appreciate how much it simplifies life for the common case of
> > > > > > "just torture-test RCU".  As in I should have done this long ago.
> > > > > 
> > > > > Seems like it would work just as easily to point init at a statically
> > > > > linked C program which just sleeps for a fixed time and then shuts down.
> > > > > However, given the special-purpose nature of rcutorture, I won't
> > > > > complain that strongly.
> > > > 
> > > > I did consider a statically linked C program, but that can introduce the
> > > > need for cross-compilation into situations that do not otherwise need it.
> > > 
> > > Wouldn't you need to cross-compile the kernel anyway in such situations?
> > 
> > Not necessarily, consider for example ABAT.  (IBM-specific test setup
> > for those unfamiliar with it -- related to autotest.)
> 
> Which already handles compiling a kernel for you; ABAT just doesn't make
> it as easy to compile userspace programs as it does for kernels. :)

Exactly!  ;-)

Between ABAT, its intended replacement, KVM, and who knows what all else,
the thought of having rcutorture control the test duration via system
shutdown is becoming increasingly attractive...

> > I suspect that the only way for you to be convinced is for you to write
> > a script that takes your preferred approach for injecting a test into
> > (say) a KVM instance.
> 
> Done and attached.

Cute trick!

The scripting has to also include getting the test duration into the .c
file and building it, but that isn't too big of a deal.  Give or take
cross-compilation of the sleep-shutdown.c program, that is...  :-/

However, this approach does cause the rcutorture success/failure message
to be lost.  One possible way around this would be to put rcutorture.ko
into your initrd, then make the program insmod it, sleep, rmmod it,
and then shut down.  But unless I am missing something basic (which is
quite possible), just doing the shutdown inside rcutorture is simpler
at that point.

However, the thought of improving boot speed by confining the kernel to
a very simple initrd does sound attractive.

Interesting behavior.  I forgot that the bzImage that I had lying around
already had an initrd built into it.  The kernel seemed to start up on
the built-in initrd, complete with serial output.  Then powered off after
about 30 seconds (I did s/3600/30/ in your sleep-shutdown.c), rather than
the 120 I had specified to rcutorture (preventing any success/failure
message from rcutorture as well).  Two initrds executing in parallel?
Hmmm...

FWIW, I used the following command:

kvm -kernel linux-2.6/arch/x86/boot/bzImage -initrd /tmp/sleep-shutdown/sleep-shutdown -serial file:/home/kvm/linux-2.6/console.log -nographic -smp 2 -m 512 -append "noapic selinux=0 console=ttyS0 initcall_debug debug rcutorture.stat_interval=15 rcutorture.shutdown_secs=120 rcutorture.rcutorture_runnable=1"

Thoughts?  (Other than that I should re-build the kernel with
CONFIG_INITRAMFS_SOURCE="", which I will try.)

Just so you know, my next step is to make rcutorture orchestrate the
CPU-hotplug operations, if rcutorture is told to do so and if the kernel
is configured to support this.

> > Then compare that script to adding a few parameters to the boot line,
> > namely: "rcutorture.stat_interval=15 rcutorture.shutdown_secs=3600
> > rcutorture.rcutorture_runnable=1".  ;-)
> 
> I actually think stat_interval makes perfect sense, as does runnable.

Indeed, from what I can see, it is hard to have module parameters without
also having the corresponding kernel boot parameters when that module
is built directly into the kernel.  ;-)

> > > > rcu_torture_shutdown(void *arg)
> > > > {
> > > > 	long delta;
> > > > 	unsigned long jiffies_snap;
> > > > 
> > > > 	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
> > > > 	jiffies_snap = ACCESS_ONCE(jiffies);
> > > 
> > > Why do you need to snapshot jiffies in this version but not in the
> > > version you originally posted?
> > 
> > Because in the original, the maximum error was one second, which was
> > not worth worrying about.
> 
> The original shouldn't have an error either.  If something incorrectly
> caches jiffies, either version would sleep forever, not just for an
> extra second.

If it cached it from one iteration of the loop to the next, agreed.
But the new version of the code introduces other possible ways for the
compiler to confuse the issue.

> > > > 	while (ULONG_CMP_LT(jiffies_snap, shutdown_time) &&
> > > > 	       !kthread_should_stop()) {
> > > > 		delta = shutdown_time - jiffies_snap;
> > > > 		if (verbose)
> > > > 			printk(KERN_ALERT "%s" TORTURE_FLAG
> > > > 			       "rcu_torture_shutdown task: %lu "
> > > > 			       "jiffies remaining\n",
> > > > 			       torture_type, delta);
> > > 
> > > I suggested dropping this print entirely; under normal circumstances it
> > > should never print.  It will only print if
> > > schedule_timeout_interruptible wakes up spuriously.
> > 
> > OK, I can qualify with a firsttime local variable.
> 
> Oh, i see; it does print the very first time through.  In that case, you
> could move the print out of the loop entirely, rather than using a
> "first time" flag.

I could, but that would prevent me from seeing cases where there are
multiple passes through the loop.

> > > > 		schedule_timeout_interruptible(delta);
> > > > 		jiffies_snap = ACCESS_ONCE(jiffies);
> > > > 	}
> > > 
> > > Any reason this entire loop body couldn't just become
> > > msleep_interruptible()?
> > 
> > Aha!!!  Because then it won't break out of the loop if someone does
> > a rmmod of rcutorture.  Which will cause the rmmod to hang until
> > the thing decides that it is time to shut down the system.  Which
> > is why I need to do the sleep in smallish pieces -- I cannot sleep
> > longer than I would be comfortable delaying the rmmod.
> > 
> > Which is why I think I need to revert back to the old version that
> > did the schedule_timeout_interruptible(1).
> 
> Does kthread_stop not interrupt an interruptible kthread?  As far as I
> can tell, rmmod of rcutorture currently finishes immediately, rather
> than after all the one-second sleeps finish, which suggests that it
> wakes up the threads in question.

OK, it might well.  But even if kthread_stop() does interrupt an
interruptible kthread, I still need to avoid msleep_interruptible(),
right?

							Thanx, Paul

