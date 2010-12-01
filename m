Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab0LAJLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:11:15 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:34200 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0LAJLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:11:12 -0500
Date: Wed, 1 Dec 2010 10:11:09 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>, stable@kernel.org
Subject: Re: [patch 3/3] nohz/s390: fix arch_needs_cpu() return value on
 offline cpus
Message-ID: <20101201091109.GA8984@osiris.boeblingen.de.ibm.com>
References: <20101126120057.879397696@de.ibm.com>
 <20101126120235.738301376@de.ibm.com>
 <1290773647.2145.140.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290773647.2145.140.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 01:14:07PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-11-26 at 13:01 +0100, Heiko Carstens wrote:
> > plain text document attachment (003_arch_needs_cpu.diff)
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > This fixes the same problem as described in the patch "nohz: fix
> > printk_needs_cpu() return value on offline cpus" for the arch_needs_cpu()
> > primitive.
> > This specific bug was indrocuded with 3c5d92a0 "nohz: Introduce arch_needs_cpu".
> > 
> > In this case a cpu hotplug notifier is used to fix the issue in order to keep
> > the normal/fast path small. All we need to do is to clear the condition that
> > makes arch_needs_cpu() return 1 since it is just a performance improvement which
> > is supposed to keep the local tick running for a short period if a cpu goes
> > idle. Nothing special needs to be done except for clearing the condition.
> > 
> > Cc: stable@kernel.org
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> OK, and s390 seems to be the only architecture making use of that
> interface.
> 
> Did you audit all the other *_needs_cpu() interfaces for this same
> problem?

Yes I did, but guess what.. get_next_timer_interrupt() bites us as well *sigh*.

Here is yet another nohz vs cpu hotplug patch which should also go into
stable.


Subject: [PATCH] nohz: fix get_next_timer_interrupt() vs cpu hotplug

From: Heiko Carstens <heiko.carstens@de.ibm.com>

This fixes a bug as seen on 2.6.32 based kernels where timers got enqueued
on offline cpus.

If a cpu goes offline it might still have pending timers. These will be
migrated during CPU_DEAD handling after the cpu is offline.
However while the cpu is going offline it will schedule the idle task
which will then call tick_nohz_stop_sched_tick().
That function in turn will call get_next_timer_intterupt() to figure out
if the tick of the cpu can be stopped or not. If it turns out that the
next tick is just one jiffy off (delta_jiffies == 1)
tick_nohz_stop_sched_tick() incorrectly assumes that the tick should not
stop and takes an early exit and thus it won't update the load balancer
cpu.
Just afterwards the cpu will be killed and the load balancer cpu could
be the offline cpu.
On 2.6.32 based kernel get_nohz_load_balancer() gets called to decide on
which cpu a timer should be enqueued (see __mod_timer()). Which leads
to the possibility that timers get enqueued on an offline cpu. These will
never expire and can cause a system hang.

This has been observed 2.6.32 kernels. On current kernels __mod_timer() uses
get_nohz_timer_target() which doesn't have that problem. However there might
be other problems because of the too early exit tick_nohz_stop_sched_tick()
in case a cpu goes offline.

The easiest and probably safest fix seems to be to let
get_next_timer_interrupt() just lie and let it say there isn't any pending
timer if the current cpu is offline.
I also thought of moving migrate_[hr]timers() from CPU_DEAD to CPU_DYING,
but seeing that there already have been fixes at least in the hrtimer code
in this area I'm afraid that this could add new subtle bugs.

Cc: stable@kernel.org
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 kernel/timer.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/timer.c b/kernel/timer.c
index 68a9ae7..f95277f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1252,6 +1252,12 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 	struct tvec_base *base = __get_cpu_var(tvec_bases);
 	unsigned long expires;
 
+	/*
+	 * Pretend that there is no timer pending if the cpu is offline.
+	 * Possible pending timers will be migrated later to an active cpu.
+	 */
+	if (cpu_is_offline(smp_processor_id()))
+		return now + NEXT_TIMER_MAX_DELTA;
 	spin_lock(&base->lock);
 	if (time_before_eq(base->next_timer, base->timer_jiffies))
 		base->next_timer = __next_timer_interrupt(base);
