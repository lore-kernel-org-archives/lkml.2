Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab2AaExM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 23:53:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:45784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab2AaExK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 23:53:10 -0500
Date: Mon, 30 Jan 2012 20:54:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, arjanvandeven@gmail.com
Subject: smp: Start up non-boot CPUs asynchronously
Message-ID: <20120130205444.22f5e26a@infradead.org>
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

>From 3700e391ab2841a9f9241e4e31a6281aa59be5f1 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 30 Jan 2012 20:44:51 -0800
Subject: [PATCH] smp: Start up non-boot CPUs asynchronously

The starting of the "not first" CPUs actually takes a lot of boot time
of the kernel... upto "minutes" on some of the bigger SGI boxes.
Right now, this is a fully sequential operation with the rest of the kernel
boot.

This patch turns this bringup of the other cpus into an asynchronous operation,
saving significant kernel boot time (40% on my laptop!!). Basically
now CPUs get brought up in parallel to disk enumeration, graphic mode bringup
etc etc etc.

Note that the implementation in this patch still waits for all CPUs to
be brought up before starting userspace; I would love to remove that
restriction over time (technically that is simple), but that becomes
then a change in behavior... I'd like to see more discussion on that
being a good idea before I write that patch.

Second note: We add a small delay between the bring up of cpus, this is
needed to actually get a boot time improvement. If we bring up CPUs
straight back-to-back, we hog the cpu hotplug lock for write, and
that lock is used everywhere during initialization for read. By
adding a small delay, we allow those tasks to make progress.

CC: Milton Miller <miltonm@bga.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/smp.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index db197d6..b83d82e 100644
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
@@ -664,17 +666,45 @@ void __init setup_nr_cpu_ids(void)
 	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
 }
 
+void __init async_cpu_up(void *data, async_cookie_t cookie)
+{
+	unsigned long nr = (unsigned long) data;
+	/*
+	 * we can only up one cpu at a time, due to the hotplug lock;
+	 * it's better to wait for all earlier CPUs to be done before
+	 * us so that the bring up order is predictable.
+	 */
+	async_synchronize_cookie(cookie);
+	/*
+	 * wait a little bit of time between cpus, to allow
+	 * the kernel boot to not get stuck for a long time
+	 * on the hotplug lock. We wait longer for the first
+	 * CPU since many of the early kernel init code is
+	 * of the hotplug-lock using type.
+	 */
+	if (nr < 2)
+		msleep(100);
+	else
+		msleep(5);
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
