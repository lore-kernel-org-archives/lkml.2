Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2EHKVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:21:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab2EHKVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:21:01 -0400
Message-ID: <1336472458.21924.78.camel@marge.simpson.net>
Subject: Re: [PATCH] clockevents: Per cpu tick skew boot option
From: Mike Galbraith <mgalbraith@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 08 May 2012 12:20:58 +0200
In-Reply-To: <alpine.LFD.2.02.1205081143510.6271@ionos>
References: <1336309127.7351.13.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1205072115000.6271@ionos>
	 <1336447221.7364.2.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1205081143510.6271@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 11:44 +0200, Thomas Gleixner wrote: 
> On Tue, 8 May 2012, Mike Galbraith wrote:
> 
> > On Mon, 2012-05-07 at 21:17 +0200, Thomas Gleixner wrote: 
> > > On Sun, 6 May 2012, Mike Galbraith wrote:
> > > >  
> > > > +	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
> > > > +			xtime_lock contention on larger systems.  Note: increases
> > > > +			power consumption, and should only be enabled if running
> > > > +			jitter sensitive (HPC/RT) workloads.
> > > > +
> > > 
> > > The "=" is wrong as skew_tick should not take parameters. It's
> > > disabled by default. So "skew_tick" simply enables it, right ?
> > 
> > Unless as I have RT set up, it's turned on by default, so '=' lets the
> > user turn it back off.
> 
> Then the doc should say what's the parameter after the "+" is :)

I only put anything there because boss said "Document", I was hiding it
along with fugly but damn useful <koff> HPC/RT cpuset patch ;-)

Let the user decide whether power consumption or jitter is the
more important consideration for their machines.

Quoting removal commit af5ab277ded04bd9bc6b048c5a2f0e7d70ef0867
Historically, Linux has tried to make the regular timer tick on the
various CPUs not happen at the same time, to avoid contention on
xtime_lock.
    
Nowadays, with the tickless kernel, this contention no longer happens
since time keeping and updating are done differently. In addition,
this skew is actually hurting power consumption in a measurable way on
many-core systems.
End quote

Problems:

- Contrary to the above, systems do encounter contention on both
  xtime_lock and RCU structure locks when the tick is synchronized.
  
- Moderate sized RT systems suffer intolerable jitter due to the tick
  being synchronized.

- SGI reports the same for their large systems.

- Fully utilized systems reap no power saving benefit from skew removal,
  but do suffer from resulting induced lock contention.

- 0209f649 rcu: limit rcu_node leaf-level fanout
  This patch was born to combat lock contention which testing showed
  to have been _induced by_ skew removal.  Skew the tick, contention
  disappeared virtually completely.

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>

---
 Documentation/kernel-parameters.txt |    9 +++++++++
 kernel/time/tick-sched.c            |   19 +++++++++++++++++++
 2 files changed, 28 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2426,6 +2426,15 @@ bytes respectively. Such letter suffixes
 
 	sched_debug	[KNL] Enables verbose scheduler debug messages.
 
+	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
+			xtime_lock contention on larger systems, and/or RCU lock
+			contention on all systems with CONFIG_MAXSMP set.
+			Format: { "0" | "1" }
+			0 -- disable. (may be 1 via CONFIG_CMDLINE="skew_tick=1"
+			1 -- enable.
+			Note: increases power consumption, thus should only be
+			enabled if running jitter sensitive (HPC/RT) workloads.
+
 	security=	[SECURITY] Choose a security module to enable at boot.
 			If this boot parameter is not specified, only the first
 			security module asking for security registration will be
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -814,6 +814,8 @@ static enum hrtimer_restart tick_sched_t
 	return HRTIMER_RESTART;
 }
 
+static int sched_skew_tick;
+
 /**
  * tick_setup_sched_timer - setup the tick emulation timer
  */
@@ -831,6 +833,14 @@ void tick_setup_sched_timer(void)
 	/* Get the next period (per cpu) */
 	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
 
+	/* Offset the tick to avert xtime_lock contention. */
+	if (sched_skew_tick) {
+		u64 offset = ktime_to_ns(tick_period) >> 1;
+		do_div(offset, num_possible_cpus());
+		offset *= smp_processor_id();
+		hrtimer_add_expires_ns(&ts->sched_timer, offset);
+	}
+
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
 		hrtimer_start_expires(&ts->sched_timer,
@@ -910,3 +920,12 @@ int tick_check_oneshot_change(int allow_
 	tick_nohz_switch_to_nohz();
 	return 0;
 }
+
+static int __init skew_tick(char *str)
+{
+	get_option(&str, &sched_skew_tick);
+
+	return 0;
+}
+early_param("skew_tick", skew_tick);
+


