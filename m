Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1EEVBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 17:01:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42534 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1EEVBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 17:01:19 -0400
Date: Thu, 5 May 2011 23:01:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, john stultz <johnstul@us.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] time: xtime_lock is held too long
Message-ID: <20110505210118.GI2925@one.firstfloor.org>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org> <m2oc3jxgtt.fsf@firstfloor.org> <1304564090.2943.36.camel@work-vm> <1304574244.32152.666.camel@edumazet-laptop> <1304576495.2943.40.camel@work-vm> <1304604284.3032.78.camel@edumazet-laptop> <alpine.LFD.2.02.1105051630390.3005@ionos> <1304608095.3032.95.camel@edumazet-laptop> <alpine.LFD.2.02.1105051750540.3005@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105051750540.3005@ionos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Another idea would be to prime cache lines to be dirtied in cpu cache
> > before taking locks, and better pack variables to reduce number of cache
> > lines.
> 
> Most variables are packed already in struct timekeeper, which should
> be pretty cache hot anyway, so I don't know whether we gain much.

There's actually some potential here. I got a moderate speedup in a
database benchmark with this patch recently. The biggest win
was in the timer interrupt.

All those variables are on separate cache lines.

(needs some cleanups, just for illustration)

-Andi

From: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] do prefetches for timer state in timer interrupt

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 76b96d7..2704267 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -856,6 +856,17 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+	extern struct timespec xtime;
+	extern struct timespec wall_to_monotonic;
+
+
+	/* Prefetch here to make the ktime_get later faster.
+ 	 * XXX move them all on the same cache line.
+ 	 */
+	prefetch(&xtime_lock);
+	prefetch(&xtime);
+	prefetch(&wall_to_monotonic);
+
 	/*
 	 * NOTE! We'd better ACK the irq immediately,
 	 * because timer handling can be slow.
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d27c756..0002e9e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -157,8 +157,8 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
  * - wall_to_monotonic is no longer the boot time, getboottime must be
  * used instead.
  */
-static struct timespec xtime __attribute__ ((aligned (16)));
-static struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
+struct timespec xtime __attribute__ ((aligned (16)));
+struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static struct timespec total_sleep_time;
 
 /*

