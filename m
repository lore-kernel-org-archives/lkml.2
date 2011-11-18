Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab1KRA2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 19:28:06 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54438 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab1KRA2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 19:28:04 -0500
Date: Thu, 17 Nov 2011 16:27:48 -0800
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
Message-ID: <20111118002747.GH2429@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1321388885-11211-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111115214615.GD31473@leaf>
 <20111116203226.GK2355@linux.vnet.ibm.com>
 <20111116221545.GA2325@leaf>
 <20111116224447.GO2355@linux.vnet.ibm.com>
 <20111116225856.GD2325@leaf>
 <20111116234358.GP2355@linux.vnet.ibm.com>
 <20111117004923.GB5201@leaf>
 <20111117014056.GS2355@linux.vnet.ibm.com>
 <20111117235733.GF1865@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117235733.GF1865@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111800-7182-0000-0000-00000036B6FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 03:57:33PM -0800, Josh Triplett wrote:
> On Wed, Nov 16, 2011 at 05:40:57PM -0800, Paul E. McKenney wrote:
> > On Wed, Nov 16, 2011 at 04:49:23PM -0800, Josh Triplett wrote:
> > > On Wed, Nov 16, 2011 at 03:43:58PM -0800, Paul E. McKenney wrote:
> > > > I suspect that the only way for you to be convinced is for you to write
> > > > a script that takes your preferred approach for injecting a test into
> > > > (say) a KVM instance.
> > > 
> > > Done and attached.
> > 
> > Cute trick!
> > 
> > The scripting has to also include getting the test duration into the .c
> > file and building it, but that isn't too big of a deal.  Give or take
> > cross-compilation of the sleep-shutdown.c program, that is...  :-/
> 
> :)
> 
> > However, this approach does cause the rcutorture success/failure message
> > to be lost.  One possible way around this would be to put rcutorture.ko
> > into your initrd, then make the program insmod it, sleep, rmmod it,
> > and then shut down.  But unless I am missing something basic (which is
> > quite possible), just doing the shutdown inside rcutorture is simpler
> > at that point.
> 
> When you build rcutorture into the kernel, the module's exit function
> will never get called at all.  If you want to see the final summary, you
> might want to build in a mechanism for rcutorture to quiesce even when
> built in, and then arrange to run that via a shutdown notifier.  That
> seems like the right way around: you shut down the system, and the
> built-in rcutorture notices and gives a final summary.
> 
> Alternatively, similar to your addition of rcutorture.stat_interval to
> periodically write out a summary, you might consider having rcutorture
> periodically quiesce and write out a PASS/FAIL.

Except that I need my test-analysis scripts to be able to easily
distinguish between a shutdown that rcutorture was OK with and a "rogue"
shutdown that terminated the test prematurely.

> > However, the thought of improving boot speed by confining the kernel to
> > a very simple initrd does sound attractive.
> 
> Definitely.  I frequently use an initrd rather than creating an entire
> filesystem, and the result runs very quickly.  It also proves easier to
> build than a block device.

Faster to build, as well.  ;-)

However, I am not convinced that initrd is generally applicable.  I have
seen kernels that get annoyed if the userspace doesn't take action within
a given period of time.  Such a kernel would not like being handed an
initrd sandbox.

> > Interesting behavior.  I forgot that the bzImage that I had lying around
> > already had an initrd built into it.  The kernel seemed to start up on
> > the built-in initrd, complete with serial output.  Then powered off after
> > about 30 seconds (I did s/3600/30/ in your sleep-shutdown.c), rather than
> > the 120 I had specified to rcutorture (preventing any success/failure
> > message from rcutorture as well).  Two initrds executing in parallel?
> > Hmmm...
> 
> Huh.  Odd.  But no, initramfses don't execute in parallel, or in series
> for that matter.  The kernel will extract its built-in initramfs to the
> "rootfs" tmpfs filesystem, then extract any externally-supplied
> initramfs on top of that, and then run /init in the rootfs filesystem.
> So, the /init from sleep-shutdown would overwrite any /init from your
> built-in initramfs, and most likely nothing else from your built-in
> initramfs had any effect at all.

Quite possibly.

> > FWIW, I used the following command:
> > 
> > kvm -kernel linux-2.6/arch/x86/boot/bzImage -initrd /tmp/sleep-shutdown/sleep-shutdown -serial file:/home/kvm/linux-2.6/console.log -nographic -smp 2 -m 512 -append "noapic selinux=0 console=ttyS0 initcall_debug debug rcutorture.stat_interval=15 rcutorture.shutdown_secs=120 rcutorture.rcutorture_runnable=1"
> 
> Looks reasonable, other than that you don't need
> rcutorture.shutdown_secs if you use sleep-shutdown.  Also, as far as I
> know you shouldn't need noapic with KVM; if you do then you should
> report a KVM bug.  (Or does that represent a scenario or code path you
> wanted to test RCU under?)

Right -- I was setting both to different values in order to make sure
I could tell which was having effect.  In this case, the sleep-shutdown
deadline arrived soonest, so it won.

The "noapic" seemed to be necessary in my initial attempts to test RCU
under qemu -- perhaps not needed for kvm?

> > Thoughts?  (Other than that I should re-build the kernel with
> > CONFIG_INITRAMFS_SOURCE="", which I will try.)
> > 
> > Just so you know, my next step is to make rcutorture orchestrate the
> > CPU-hotplug operations, if rcutorture is told to do so and if the kernel
> > is configured to support this.
> 
> And that really seems easier than just running a simple script from an
> initrd?

Yes, easier and less fragile, especially with respect to automatically
analyzing the test results.

> On Wed, Nov 16, 2011 at 05:40:57PM -0800, Paul E. McKenney wrote:
> > On Wed, Nov 16, 2011 at 04:49:23PM -0800, Josh Triplett wrote:
> > > On Wed, Nov 16, 2011 at 03:43:58PM -0800, Paul E. McKenney wrote:
> > > > On Wed, Nov 16, 2011 at 02:58:56PM -0800, Josh Triplett wrote:
> > > > > On Wed, Nov 16, 2011 at 02:44:47PM -0800, Paul E. McKenney wrote:
> > > > > > rcu_torture_shutdown(void *arg)
> > > > > > {
> > > > > > 	long delta;
> > > > > > 	unsigned long jiffies_snap;
> > > > > > 
> > > > > > 	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
> > > > > > 	jiffies_snap = ACCESS_ONCE(jiffies);
> > > > > 
> > > > > Why do you need to snapshot jiffies in this version but not in the
> > > > > version you originally posted?
> > > > 
> > > > Because in the original, the maximum error was one second, which was
> > > > not worth worrying about.
> > > 
> > > The original shouldn't have an error either.  If something incorrectly
> > > caches jiffies, either version would sleep forever, not just for an
> > > extra second.
> > 
> > If it cached it from one iteration of the loop to the next, agreed.
> > But the new version of the code introduces other possible ways for the
> > compiler to confuse the issue.
> 
> At least in theory, the compiler can't cache the value of jiffies at
> all, since jiffies uses "volatile".  The CPU potentially could, but we
> don't normally expect CPUs to hold onto old cached values indefinitely;
> we tend to count on updates to eventually propagate.

OK, I missed the "volatile" on jiffies.  Bad cscope day, I guess.

> > > > > > 	while (ULONG_CMP_LT(jiffies_snap, shutdown_time) &&
> > > > > > 	       !kthread_should_stop()) {
> > > > > > 		delta = shutdown_time - jiffies_snap;
> > > > > > 		if (verbose)
> > > > > > 			printk(KERN_ALERT "%s" TORTURE_FLAG
> > > > > > 			       "rcu_torture_shutdown task: %lu "
> > > > > > 			       "jiffies remaining\n",
> > > > > > 			       torture_type, delta);
> > > > > 
> > > > > I suggested dropping this print entirely; under normal circumstances it
> > > > > should never print.  It will only print if
> > > > > schedule_timeout_interruptible wakes up spuriously.
> > > > 
> > > > OK, I can qualify with a firsttime local variable.
> > > 
> > > Oh, i see; it does print the very first time through.  In that case, you
> > > could move the print out of the loop entirely, rather than using a
> > > "first time" flag.
> > 
> > I could, but that would prevent me from seeing cases where there are
> > multiple passes through the loop.
> 
> ...which should never happen unless something signals that thread,
> right?  (And normally, that signal will occur as part of kthread_stop,
> which would terminate the loop as well.)

Exactly.  It should never happen, so if I am worried enough about what
rcutorture is doing to specify "verbose" (which I rarely do), then I
want to see it.

> > > > > > 		schedule_timeout_interruptible(delta);
> > > > > > 		jiffies_snap = ACCESS_ONCE(jiffies);
> > > > > > 	}
> > > > > 
> > > > > Any reason this entire loop body couldn't just become
> > > > > msleep_interruptible()?
> > > > 
> > > > Aha!!!  Because then it won't break out of the loop if someone does
> > > > a rmmod of rcutorture.  Which will cause the rmmod to hang until
> > > > the thing decides that it is time to shut down the system.  Which
> > > > is why I need to do the sleep in smallish pieces -- I cannot sleep
> > > > longer than I would be comfortable delaying the rmmod.
> > > > 
> > > > Which is why I think I need to revert back to the old version that
> > > > did the schedule_timeout_interruptible(1).
> > > 
> > > Does kthread_stop not interrupt an interruptible kthread?  As far as I
> > > can tell, rmmod of rcutorture currently finishes immediately, rather
> > > than after all the one-second sleeps finish, which suggests that it
> > > wakes up the threads in question.
> > 
> > OK, it might well.  But even if kthread_stop() does interrupt an
> > interruptible kthread, I still need to avoid msleep_interruptible(),
> > right?
> 
> I don't see any reason you need to avoid it.  As far as I can tell,
> msleep_interruptible should do *exactly* what you want, including
> allowing interruptions by kthread_stop.  You just need something like
> this:
> 
> unsigned int timeout = ...;
> while (timeout && !kthread_should_stop())
>     timeout = msleep_interruptible(timeout);

Color me confused.  Here is msleep_interruptible():

	unsigned long msleep_interruptible(unsigned int msecs)
	{
		unsigned long timeout = msecs_to_jiffies(msecs) + 1;

		while (timeout && !signal_pending(current))
			timeout = schedule_timeout_interruptible(timeout);
		return jiffies_to_msecs(timeout);
	}

And here is signal_pending():

	static inline int signal_pending(struct task_struct *p)
	{
		return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
	}

And finally, here is kthread_stop():

	int kthread_stop(struct task_struct *k)
	{
		struct kthread *kthread;
		int ret;

		trace_sched_kthread_stop(k);
		get_task_struct(k);

		kthread = to_kthread(k);
		barrier(); /* it might have exited */
		if (k->vfork_done != NULL) {
			kthread->should_stop = 1;
			wake_up_process(k);
			wait_for_completion(&kthread->exited);
		}
		ret = k->exit_code;

		put_task_struct(k);
		trace_sched_kthread_stop_ret(ret);

		return ret;
	}

I don't see how kthread_stop() is doing anything to kick
msleep_interruptible() out of its loop.  What am I missing?

							Thanx, Paul

