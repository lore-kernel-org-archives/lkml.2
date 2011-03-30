Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545Ab1C3Vrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:47:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:23361 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964838Ab1C3VHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237026"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: venki@google.com, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, efault@gmx.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [102/275] x86: Add IRQ_TIME_ACCOUNTING
Message-Id: <20110330210541.0D54C3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Commit: e82b8e4ea4f3dffe6e7939f90e78da675fcc450e upstream

This patch adds IRQ_TIME_ACCOUNTING option on x86 and runtime enables it
when TSC is enabled.

This change just enables fine grained irq time accounting, isn't used yet.
Following patches use it for different purposes.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1286237003-12406-6-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/Kconfig                    |   11 +++++++++++
 arch/x86/kernel/tsc.c               |    8 ++++++++
 3 files changed, 23 insertions(+)

Index: linux-2.6.35.y/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.35.y.orig/Documentation/kernel-parameters.txt	2011-03-29 22:51:28.997981183 -0700
+++ linux-2.6.35.y/Documentation/kernel-parameters.txt	2011-03-29 23:03:00.294292640 -0700
@@ -2672,6 +2672,10 @@
 			disables clocksource verification at runtime.
 			Used to enable high-resolution timer mode on older
 			hardware, and in virtualized environment.
+			[x86] noirqtime: Do not use TSC to do irq accounting.
+			Used to run time disable IRQ_TIME_ACCOUNTING on any
+			platforms where RDTSC is slow and this accounting
+			can add overhead.
 
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
Index: linux-2.6.35.y/arch/x86/Kconfig
===================================================================
--- linux-2.6.35.y.orig/arch/x86/Kconfig	2011-03-29 22:51:28.997981183 -0700
+++ linux-2.6.35.y/arch/x86/Kconfig	2011-03-29 23:03:00.295292615 -0700
@@ -797,6 +797,17 @@
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config IRQ_TIME_ACCOUNTING
+	bool "Fine granularity task level IRQ time accounting"
+	default n
+	---help---
+	  Select this option to enable fine granularity task irq time
+	  accounting. This is done by reading a timestamp on each
+	  transitions between softirq and hardirq state, so there can be a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
Index: linux-2.6.35.y/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/tsc.c	2011-03-29 22:51:28.997981183 -0700
+++ linux-2.6.35.y/arch/x86/kernel/tsc.c	2011-03-29 23:03:00.297292563 -0700
@@ -104,10 +104,14 @@
 
 __setup("notsc", notsc_setup);
 
+static int no_sched_irq_time;
+
 static int __init tsc_setup(char *str)
 {
 	if (!strcmp(str, "reliable"))
 		tsc_clocksource_reliable = 1;
+	if (!strncmp(str, "noirqtime", 9))
+		no_sched_irq_time = 1;
 	return 1;
 }
 
@@ -802,6 +806,7 @@
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
 		sched_clock_stable = 0;
+		disable_sched_clock_irqtime();
 		printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
@@ -990,6 +995,9 @@
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
+	if (!no_sched_irq_time)
+		enable_sched_clock_irqtime();
+
 	lpj = ((u64)tsc_khz * 1000);
 	do_div(lpj, HZ);
 	lpj_fine = lpj;
