Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2AaQXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:23:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:54195 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab2AaQXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:23:33 -0500
Date: Tue, 31 Jan 2012 08:24:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Andrew Morton <akpm@linux-foundation.org>, arjanvandeven@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: smp: Start up non-boot CPUs asynchronously
Message-ID: <20120131082439.575978c0@infradead.org>
In-Reply-To: <20120131161207.GA18357@elte.hu>
References: <20120130205444.22f5e26a@infradead.org>
	<20120131125232.GD4408@elte.hu>
	<20120131054155.371e8307@infradead.org>
	<20120131143130.GF13676@elte.hu>
	<20120131072216.1ce78e50@infradead.org>
	<20120131161207.GA18357@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 17:12:07 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> > it's not really a performance problem as it is an obvious "we 
> > have a ton of back-to-back writers on a read-write lock that 
> > we have quite a few readers for". Unless the writers back off 
> > a little, the readers are going to get starved.
> 
> I didn't think I'd ever quote Bush, but my reaction to that is: 
> 'Bring it on!' ;-)

You ask and you shall receive....
In this patch are "No New Taxis"

I do have a request: do run with this patch, and make a bootchart.pl
of the result, and you'll see what I meant....


>From ee65be59057c920042747d46dc174c5a5a56c744 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 30 Jan 2012 20:44:51 -0800
Subject: [PATCH] smp: Start up non-boot CPUs asynchronously

The starting of the "not first" CPUs actually takes a lot of boot time
of the kernel... upto "minutes" on some of the bigger SGI boxes.
Right now, this is a fully sequential operation with the rest of the kernel
boot.

This patch turns this bringup of the other cpus into an asynchronous operation.
With some other changes (not in this patch) this can save significant kernel
boot time (upto 40% on my laptop!!).
Basically now CPUs could get brought up in parallel to disk enumeration, graphic
mode bringup etc etc etc.

Note that the implementation in this patch still waits for all CPUs to
be brought up before starting userspace; I would love to remove that
restriction over time (technically that is simple), but that becomes
then a change in behavior... I'd like to see more discussion on that
being a good idea before I write that patch.

Second note on version 2 of the patch:
This patch does currently not save any boot time, due to a situation
where the cpu hotplug lock gets taken for write by the cpu bringup code,
which starves out readers of this lock throughout the kernel.
Ingo specifically requested this behavior to expose this lock problem.

CC: Milton Miller <miltonm@bga.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/smp.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index db197d6..ea48418 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -12,6 +12,8 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/async.h>
+#include <linux/delay.h>
 
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 static struct {
@@ -664,17 +666,34 @@ void __init setup_nr_cpu_ids(void)
 	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
 }
 
+void __init async_cpu_up(void *data, async_cookie_t cookie)
+{
+	unsigned long nr = (unsigned long) data;
+	/*
+	 * we can only up one cpu at a time, as enforced by the hotplug
+	 * lock; it's better to wait for all earlier CPUs to be done before
+	 * we bring up ours, so that the bring up order is predictable.
+	 */
+	async_synchronize_cookie(cookie);
+	cpu_up(nr);
+}
+
 /* Called by boot processor to activate the rest. */
 void __init smp_init(void)
 {
 	unsigned int cpu;
 
 	/* FIXME: This should be done in userspace --RR */
+
+	/*
+	 * But until we do this in userspace, we're going to do this
+	 * in parallel to the rest of the kernel boot up.-- Arjan
+	 */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
 			break;
 		if (!cpu_online(cpu))
-			cpu_up(cpu);
+			async_schedule(async_cpu_up, (void *) cpu);
 	}
 
 	/* Any cleanup work */
-- 
1.7.6.4



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
