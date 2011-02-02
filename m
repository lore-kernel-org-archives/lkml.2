Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1BBLZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:25:34 -0500
Received: from www.tglx.de ([62.245.132.106]:53675 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab1BBLZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:25:33 -0500
Date: Wed, 2 Feb 2011 12:25:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 28/28] posix clocks: Introduce dynamic clocks
In-Reply-To: <alpine.LFD.2.00.1102021134520.31804@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1102021222240.31804@localhost6.localdomain6>
References: <20110201134320.688829863@linutronix.de> <20110201134420.164172635@linutronix.de> <1296596987.3336.83.camel@work-vm> <20110202075058.GA2747@riccoc20.at.omicron.at> <alpine.LFD.2.00.1102021134520.31804@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, Thomas Gleixner wrote:

> On Wed, 2 Feb 2011, Richard Cochran wrote:
> 
> > On Tue, Feb 01, 2011 at 01:49:47PM -0800, john stultz wrote:
> > > I sort of worry about the naming collision with the term posix-clock, as
> > > this is just one type of posix clock (I suspect most folks think of a
> > > posix clock as the clockid passed to the existing posix api).
> > > 
> > > Could we maybe use posix-dynclock or posix-fdclock or something? I know
> > > its already been changed from clkdev, so sorry for being finicky here
> > > and not catching this earlier.
> > 
> > A rose by any other name...
> > 
> > I agree that naming (even internal APIs) is important and have no
> > objection to changing the name. I did spend a bit of time considering
> > various alternatives, and now I'm out of ideas.
> > 
> > So, please do change the name if you have a better one.
> 
> We have a clear distinction between posix-timers and those new
> posix-clocks. Adding some artificial "fd", "dyn" or whatever will not
> make it much better.

There is only one function visible outside of posix-timers.c which
uses the posix_clock namespace: register_posix_clock(). That needs to
be cleaned up. See patch below.

Thanks,

	tglx

Subject: posix-timers: Cleanup namespace
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 02 Feb 2011 12:10:09 +0100

Rename register_posix_clock() to posix_timers_register_clock(). That's
what the function really does. As a side effect this cleans up the
posix_clock namespace for the upcoming dynamic posix_clock
infrastructure.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/mmtimer.c       |    2 +-
 include/linux/posix-timers.h |    2 +-
 kernel/posix-cpu-timers.c    |    4 ++--
 kernel/posix-timers.c        |   15 ++++++++-------
 4 files changed, 12 insertions(+), 11 deletions(-)

Index: linux-2.6-tip/drivers/char/mmtimer.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/mmtimer.c
+++ linux-2.6-tip/drivers/char/mmtimer.c
@@ -840,7 +840,7 @@ static int __init mmtimer_init(void)
 	}
 
 	sgi_clock_period = NSEC_PER_SEC / sn_rtc_cycles_per_second;
-	register_posix_clock(CLOCK_SGI_CYCLE, &sgi_clock);
+	posix_timers_register_clock(CLOCK_SGI_CYCLE, &sgi_clock);
 
 	printk(KERN_INFO "%s: v%s, %ld MHz\n", MMTIMER_DESC, MMTIMER_VERSION,
 	       sn_rtc_cycles_per_second/(unsigned long)1E6);
Index: linux-2.6-tip/include/linux/posix-timers.h
===================================================================
--- linux-2.6-tip.orig/include/linux/posix-timers.h
+++ linux-2.6-tip/include/linux/posix-timers.h
@@ -101,7 +101,7 @@ struct k_clock {
 
 extern struct k_clock clock_posix_cpu;
 
-void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
+void posix_timers_register_clock(const clockid_t clock_id, struct k_clock *new_clock);
 
 /* function to call to trigger timer event */
 int posix_timer_event(struct k_itimer *timr, int si_private);
Index: linux-2.6-tip/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-cpu-timers.c
+++ linux-2.6-tip/kernel/posix-cpu-timers.c
@@ -1618,8 +1618,8 @@ static __init int init_posix_cpu_timers(
 	};
 	struct timespec ts;
 
-	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
-	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
+	posix_timers_register_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
+	posix_timers_register_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
 
 	cputime_to_timespec(cputime_one_jiffy, &ts);
 	onecputick = ts.tv_nsec;
Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -253,11 +253,11 @@ static __init int init_posix_timers(void
 		.clock_get	= posix_get_monotonic_coarse,
 	};
 
-	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
-	register_posix_clock(CLOCK_MONOTONIC, &clock_monotonic);
-	register_posix_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
-	register_posix_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
-	register_posix_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
+	posix_timers_register_clock(CLOCK_REALTIME, &clock_realtime);
+	posix_timers_register_clock(CLOCK_MONOTONIC, &clock_monotonic);
+	posix_timers_register_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
+	posix_timers_register_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
+	posix_timers_register_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
@@ -433,7 +433,8 @@ static struct pid *good_sigevent(sigeven
 	return task_pid(rtn);
 }
 
-void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock)
+void posix_timers_register_clock(const clockid_t clock_id,
+				 struct k_clock *new_clock)
 {
 	if ((unsigned) clock_id >= MAX_CLOCKS) {
 		printk(KERN_WARNING "POSIX clock register failed for clock_id %d\n",
@@ -454,7 +455,7 @@ void register_posix_clock(const clockid_
 
 	posix_clocks[clock_id] = *new_clock;
 }
-EXPORT_SYMBOL_GPL(register_posix_clock);
+EXPORT_SYMBOL_GPL(posix_timers_register_clock);
 
 static struct k_itimer * alloc_posix_timer(void)
 {


