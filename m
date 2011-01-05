Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1AEXGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:06:21 -0500
Received: from kroah.org ([198.145.64.141]:50704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab1AEXGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:17 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:24 2011
Message-Id: <20110105230324.195449133@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [08/49] nohz: Fix get_next_timer_interrupt() vs cpu hotplug
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit dbd87b5af055a0cc9bba17795c9a2b0d17795389 upstream.

This fixes a bug as seen on 2.6.32 based kernels where timers got
enqueued on offline cpus.

If a cpu goes offline it might still have pending timers. These will
be migrated during CPU_DEAD handling after the cpu is offline.
However while the cpu is going offline it will schedule the idle task
which will then call tick_nohz_stop_sched_tick().

That function in turn will call get_next_timer_intterupt() to figure
out if the tick of the cpu can be stopped or not. If it turns out that
the next tick is just one jiffy off (delta_jiffies == 1)
tick_nohz_stop_sched_tick() incorrectly assumes that the tick should
not stop and takes an early exit and thus it won't update the load
balancer cpu.

Just afterwards the cpu will be killed and the load balancer cpu could
be the offline cpu.

On 2.6.32 based kernel get_nohz_load_balancer() gets called to decide
on which cpu a timer should be enqueued (see __mod_timer()). Which
leads to the possibility that timers get enqueued on an offline cpu.
These will never expire and can cause a system hang.

This has been observed 2.6.32 kernels. On current kernels
__mod_timer() uses get_nohz_timer_target() which doesn't have that
problem. However there might be other problems because of the too
early exit tick_nohz_stop_sched_tick() in case a cpu goes offline.

The easiest and probably safest fix seems to be to let
get_next_timer_interrupt() just lie and let it say there isn't any
pending timer if the current cpu is offline.

I also thought of moving migrate_[hr]timers() from CPU_DEAD to
CPU_DYING, but seeing that there already have been fixes at least in
the hrtimer code in this area I'm afraid that this could add new
subtle bugs.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101201091109.GA8984@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/timer.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1173,6 +1173,12 @@ unsigned long get_next_timer_interrupt(u
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


