Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1AYKd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:33:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52927 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1AYKdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:33:55 -0500
Subject: Re: [PATCH 01/18] move do_timer() from kernel/timer.c into
 kernel/time/timekeeping.c
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>, Torben Hohn <torbenh@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
        yong.zhang0@gmail.com
In-Reply-To: <1295946514.28776.476.camel@laptop>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
	 <1295651224-29823-2-git-send-email-torbenh@gmx.de>
	 <1295901169.4845.29.camel@work-vm>
	 <alpine.LFD.2.00.1101242254420.31804@localhost6.localdomain6>
	 <1295907672.2274.44.camel@twins>
	 <alpine.LFD.2.00.1101242344090.31804@localhost6.localdomain6>
	 <1295946514.28776.476.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 11:34:37 +0100
Message-ID: <1295951677.28776.489.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 10:08 +0100, Peter Zijlstra wrote:
> On Mon, 2011-01-24 at 23:44 +0100, Thomas Gleixner wrote:
> > On Mon, 24 Jan 2011, Peter Zijlstra wrote:
> > 
> > > On Mon, 2011-01-24 at 23:10 +0100, Thomas Gleixner wrote:
> > > > The call to calc_global_load() is there for hysterical raisins and we
> > > > really should get rid of it sooner than later. I'm quite sure that it
> > > > could be run from a timer callback as well. Peter ?
> > > 
> > > calc_global_load() wants to be called on just one cpu, do we have a
> > > better place for that?
> > 
> > Well, we can call it from a timer from a single CPU.
> 
> Right that would work I guess.

Something like the (completely untested) below would do I guess:

---
Subject: sched: Move the calc_global_load() call into the scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Jan 25 11:30:35 CET 2011

Remove the calc_global_load() call from the timekeeping code and make
it local to the scheduler.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/sched.h |    2 --
 kernel/sched.c        |   22 ++++++++++++++++------
 kernel/timer.c        |    1 -
 3 files changed, 16 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -142,8 +142,6 @@ extern unsigned long nr_iowait_cpu(int c
 extern unsigned long this_cpu_load(void);
 
 
-extern void calc_global_load(unsigned long ticks);
-
 extern unsigned long get_parent_ip(unsigned long addr);
 
 struct seq_file;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3192,7 +3192,7 @@ calc_load_n(unsigned long load, unsigned
  * Once we've updated the global active value, we need to apply the exponential
  * weights adjusted to the number of cycles missed.
  */
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 	long delta, active, n;
 
@@ -3209,11 +3209,13 @@ static void calc_global_nohz(unsigned lo
 	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
 
+
 	/*
 	 * If we were idle for multiple load cycles, apply them.
 	 */
-	if (ticks >= LOAD_FREQ) {
-		n = ticks / LOAD_FREQ;
+	delta = jiffies - calc_load_update - 10;
+	if (delta >= LOAD_FREQ) {
+		n = delta / LOAD_FREQ;
 
 		active = atomic_long_read(&calc_load_tasks);
 		active = active > 0 ? active * FIXED_1 : 0;
@@ -3246,7 +3248,7 @@ static inline long calc_load_fold_idle(v
 	return 0;
 }
 
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 }
 #endif
@@ -3266,15 +3268,20 @@ void get_avenrun(unsigned long *loads, u
 	loads[2] = (avenrun[2] + offset) << shift;
 }
 
+static void calc_global_load(unsigned long __data);
+
+static struct timer_list global_load_timer =
+	TIMER_DEFERRED_INITIALIZER(calc_global_load, 0, 0);
+
 /*
  * calc_load - update the avenrun load estimates 10 ticks after the
  * CPUs have updated calc_load_tasks.
  */
-void calc_global_load(unsigned long ticks)
+static void calc_global_load(unsigned long __data)
 {
 	long active;
 
-	calc_global_nohz(ticks);
+	calc_global_nohz();
 
 	if (time_before(jiffies, calc_load_update + 10))
 		return;
@@ -3287,6 +3294,7 @@ void calc_global_load(unsigned long tick
 	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
 
 	calc_load_update += LOAD_FREQ;
+	mod_timer(&global_load_timer, calc_load_update + 10);
 }
 
 /*
@@ -8172,6 +8180,8 @@ void __init sched_init(void)
 	init_idle(current, smp_processor_id());
 
 	calc_load_update = jiffies + LOAD_FREQ;
+	global_load_timer.slack = 0;
+	mod_timer(&global_load_timer, calc_load_update + 10);
 
 	/*
 	 * During early bootup we pretend to be a normal task:
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1303,7 +1303,6 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_wall_time();
-	calc_global_load(ticks);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM

