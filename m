Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab2EWPXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:23:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597Ab2EWPXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:23:47 -0400
Message-ID: <1337786613.18720.5.camel@marge.simpson.net>
Subject: [PATCH v3] clockevents: Per cpu tick skew boot option
From: Mike Galbraith <mgalbraith@suse.de>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 23 May 2012 17:23:33 +0200
In-Reply-To: <20120510181607.GA14329@linux.vnet.ibm.com>
References: <1336309127.7351.13.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1205072115000.6271@ionos>
	 <1336447221.7364.2.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1205081143510.6271@ionos>
	 <1336472458.21924.78.camel@marge.simpson.net>
	 <20120510181607.GA14329@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 11:16 -0700, Paul E. McKenney wrote:

> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2426,6 +2426,15 @@ bytes respectively. Such letter suffixes
> > 
> >  	sched_debug	[KNL] Enables verbose scheduler debug messages.
> > 
> > +	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
> > +			xtime_lock contention on larger systems, and/or RCU lock
> > +			contention on all systems with CONFIG_MAXSMP set.
> 
> Suggest instead:
> 
> 			contention on systems with large CONFIG_RCU_FANOUT
> 			values.
> 
> > +			Format: { "0" | "1" }
> > +			0 -- disable. (may be 1 via CONFIG_CMDLINE="skew_tick=1"
> 
> Suggest simply:
> 
> 			0 -- disable (default for typical kernel builds).
> 
> With these changes:
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Hunted down round-tuit.

clockevents: Per cpu tick skew boot option

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
- Contrary to the above, all systems do encounter contention on
  xtime_lock and RCU structure locks when the tick is synchronized.

- Large systems and moderate sized RT systems suffer intolerable
  jitter with the tick synchronized.

- Fully utilized systems reap no power saving benefit, but do
  suffer from synchronized tick lock contention.

- 0209f649 rcu: limit rcu_node leaf-level fanout
  This patch was born to combat lock contention which testing showed
  to have been _induced by_ skew removal.  Skew the tick, contention
  disappeared virtually completely.  Measured latency on 48 core box
  was >330us.  Revert, amd restore skew, it dropped back to ~70us.
  We absorbed a 400% latency increase to combat induced contention.

Let the user decide whether power consumption or jitter is the
more important consideration for their machines.

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

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
+			contention on systems with large CONFIG_RCU_FANOUT values.
+			Format: { "0" | "1" }
+			0 -- disable (default for typical kernel builds).
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


