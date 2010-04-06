Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0DFUq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:46:26 -0400
Received: from isilmar.linta.de ([213.133.102.198]:38909 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756353Ab0DFUqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:46:19 -0400
Date: Tue, 6 Apr 2010 22:45:37 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100406204537.GA4324@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Dmitry Torokhov <dtor@mail.ru>
References: <20100404233702.GA24102@linux.vnet.ibm.com>
 <20100404204725.GC2644@linux.vnet.ibm.com>
 <20100405210340.GA4638@comet.dominikbrodowski.net>
 <20100405213852.GI2525@linux.vnet.ibm.com>
 <20100405221123.GA1903@isilmar.linta.de>
 <20100405223130.GM2525@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405223130.GM2525@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 03:31:30PM -0700, Paul E. McKenney wrote:
> > > 5) powertop and hrtimer_start_range_ns (tick_sched_timer) on a SMP kernel
> > > booted with "nosmp":
> > > 
> > > Wakeups-from-idle per second :  9.9     interval: 15.0s
> > > ...
> > >   48.5% (  9.4)     <kernel core> : hrtimer_start (tick_sched_timer) 
> > >   26.1% (  5.1)     <kernel core> : cursor_timer_handler
> > >   (cursor_timer_handle
> > >   20.6% (  4.0)     <kernel core> : usb_hcd_poll_rh_status (rh_timer_func) 
> > >    1.0% (  0.2)     <kernel core> : arm_supers_timer
> > >   (sync_supers_timer_fn) 
> > >    0.7% (  0.1)       <interrupt> : ata_piix 
> > >    ...
> > > 
> > > Accoding to http://www.linuxpowertop.org , the count in the brackets is
> > > how
> > > many wakeups per seconds were caused by one source. Adding all _except_
> > >   48.5% (  9.4)     <kernel core> : hrtimer_start (tick_sched_timer)
> > > up leads to the 9.9.
> 
> OK, so you further instrumented the hrtimer_sched_timer (or was it
> tick_sched_timer?) to find the number that you were attributing to
> rcu_needs_cpu()?

That's what I did -- to tick_nohz_stop_sched_tick(), to see why the
tick_sched_timer did not get stopped. Or why powertop thinks it did not
get stopped...

Patch below (works only for 1 or 2 CPUs) for all interested parties, 
_NOT_ intended for submission, though ;)

0x0001: CPU #1
0x0002: inidle
0x0004: not inidle
0x0008: INACTIVE
0x0010: need_resched
0x0020: softirq
0x0040: rcu_needs_
0x0080: printk_needs_
0x0100: arch_needs_
0x0200: off-by-one 
0x0400: skip
0x0800: loadbalance:
0x1000: cancel timer (SUCCESS)
0x2000: timer was already in the past
0x4000: hrtimer_start() (SUCCESS)
0x8000: stop_tick (SUCCESS)

Fixing USB-autosuspend and disabling the fbcon cursor, I'm down to
~0.9 wakeups-per-second booting with "nosmp".

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f992762..6ba7bae 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -210,19 +210,35 @@ void tick_nohz_stop_sched_tick(int inidle)
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
 	int cpu;
+	static int testrun_counter = 0;
+	int testrun = 0;
+	u64 debugdata = 0;
+
+	testrun_counter++;
+
+	if ((testrun_counter % 123) == 0)
+		testrun = 1;
 
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
+	debugdata = cpu;
+
+	if (inidle)
+		debugdata |= 0x2;
+
+
 	/*
 	 * Call to tick_nohz_start_idle stops the last_update_time from being
 	 * updated. Thus, it must not be called in the event we are called from
 	 * irq_exit() with the prior state different than idle.
 	 */
-	if (!inidle && !ts->inidle)
+	if (!inidle && !ts->inidle) {
+		debugdata |= 0x4;
 		goto end;
+	}
 
 	/*
 	 * Set ts->inidle unconditionally. Even if the system did not
@@ -245,11 +261,15 @@ void tick_nohz_stop_sched_tick(int inidle)
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 	}
 
-	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
+	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE)) {
+		debugdata |= 0x8;		
 		goto end;
+	}
 
-	if (need_resched())
+	if (need_resched()) {
+		debugdata |= 0x10;
 		goto end;
+	}
 
 	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
 		static int ratelimit;
@@ -259,6 +279,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 			       (unsigned int) local_softirq_pending());
 			ratelimit++;
 		}
+		debugdata |= 0x20;
 		goto end;
 	}
 
@@ -275,6 +296,12 @@ void tick_nohz_stop_sched_tick(int inidle)
 	    arch_needs_cpu(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
+		if (rcu_needs_cpu(cpu))
+			debugdata |= 0x40;
+		if (printk_needs_cpu(cpu))
+			debugdata |= 0x80;
+		if (arch_needs_cpu(cpu))
+			debugdata |= 0x100;
 	} else {
 		/* Get the next timer wheel timer */
 		next_jiffies = get_next_timer_interrupt(last_jiffies);
@@ -284,8 +311,10 @@ void tick_nohz_stop_sched_tick(int inidle)
 	 * Do not stop the tick, if we are only one off
 	 * or if the cpu is required for rcu
 	 */
-	if (!ts->tick_stopped && delta_jiffies == 1)
+	if (!ts->tick_stopped && delta_jiffies == 1) {
+		debugdata |= 0x200;
 		goto out;
+	}
 
 	/* Schedule the tick, if we are at least one jiffie off */
 	if ((long)delta_jiffies >= 1) {
@@ -341,8 +370,10 @@ void tick_nohz_stop_sched_tick(int inidle)
 			cpumask_set_cpu(cpu, nohz_cpu_mask);
 
 		/* Skip reprogram of event if its not changed */
-		if (ts->tick_stopped && ktime_equal(expires, dev->next_event))
+		if (ts->tick_stopped && ktime_equal(expires, dev->next_event)) {
+			debugdata |= 0x400;
 			goto out;
+		}
 
 		/*
 		 * nohz_stop_sched_tick can be called several times before
@@ -357,8 +388,10 @@ void tick_nohz_stop_sched_tick(int inidle)
 				 * sched tick not stopped!
 				 */
 				cpumask_clear_cpu(cpu, nohz_cpu_mask);
+				debugdata |= 0x800;
 				goto out;
 			}
+			debugdata |= 0x8000;
 
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
@@ -375,7 +408,8 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 * If the expiration time == KTIME_MAX, then
 		 * in this case we simply stop the tick timer.
 		 */
-		 if (unlikely(expires.tv64 == KTIME_MAX)) {
+		if (unlikely(expires.tv64 == KTIME_MAX)) {
+			debugdata |= 0x1000;
 			if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
 				hrtimer_cancel(&ts->sched_timer);
 			goto out;
@@ -384,9 +418,13 @@ void tick_nohz_stop_sched_tick(int inidle)
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
 			hrtimer_start(&ts->sched_timer, expires,
 				      HRTIMER_MODE_ABS_PINNED);
+			debugdata |= 0x2000;
 			/* Check, if the timer was already in the past */
-			if (hrtimer_active(&ts->sched_timer))
+			if (hrtimer_active(&ts->sched_timer)) {
+				debugdata &= ~(0x2000);
+				debugdata |= 0x4000;
 				goto out;
+			}
 		} else if (!tick_program_event(expires, 0))
 				goto out;
 		/*
@@ -403,6 +441,8 @@ out:
 	ts->last_jiffies = last_jiffies;
 	ts->sleep_length = ktime_sub(dev->next_event, now);
 end:
+	if (testrun)
+		printk(KERN_DEBUG "0x%0llx\n", debugdata);
 	local_irq_restore(flags);
 }
 
