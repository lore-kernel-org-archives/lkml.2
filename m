Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905Ab0G1ECP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 00:02:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:34457 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0G1ECM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 00:02:12 -0400
Date: Tue, 27 Jul 2010 21:02:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org
Subject: [patch] Remove the per cpu tick skew
Message-ID: <20100727210210.58d3118c@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following patch is a win for power management on x86....
... but since this touches generic code.. are there any 
other architectures that would be negatively affected by this?



Subject: [patch] Remove the per cpu tick skew

Historically, Linux has tried to make the regular timer tick on the various
CPUs not happen at the same time, to avoid contention on xtime_lock.

Nowadays, with the tickless kernel, this contention no longer happens
since time keeping and updating are done differently. In addition,
this skew is actually hurting power consumption in a measurable
way on many-core systems.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

--- linux.trees.git/kernel/time/tick-sched.c~	2010-07-16 09:40:50.000000000 -0400
+++ linux.trees.git/kernel/time/tick-sched.c	2010-07-26 11:18:51.138003329 -0400
@@ -780,7 +780,6 @@
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now = ktime_get();
-	u64 offset;
 
 	/*
 	 * Emulate tick processing via per-CPU hrtimers:
@@ -790,10 +789,6 @@
 
 	/* Get the next period (per cpu) */
 	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
-	offset = ktime_to_ns(tick_period) >> 1;
-	do_div(offset, num_possible_cpus());
-	offset *= smp_processor_id();
-	hrtimer_add_expires_ns(&ts->sched_timer, offset);
 
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
