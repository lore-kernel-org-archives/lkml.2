Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab0JEAEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:04:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23970 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab0JEAD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kPuZ5JP9eOFbS+C4ronbuf+Dq+JKnw25hkaMimOEO6wXMqdIcFil4bFecLM18VHdm3
         18ZF0WkzPtepvaANOL3g==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 5/8] x86: Add IRQ_TIME_ACCOUNTING in x86 -v4
Date: Mon,  4 Oct 2010 17:03:20 -0700
Message-Id: <1286237003-12406-6-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286237003-12406-1-git-send-email-venki@google.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds IRQ_TIME_ACCOUNTING option on x86 and runtime enables it
when TSC is enabled.

This change just enables fine grained irq time accounting, isn't used yet.
Following patches use it for different purposes.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/Kconfig                    |   11 +++++++++++
 arch/x86/kernel/tsc.c               |    8 ++++++++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8dd7248..ed05a4a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2435,6 +2435,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			disables clocksource verification at runtime.
 			Used to enable high-resolution timer mode on older
 			hardware, and in virtualized environment.
+			[x86] noirqtime: Do not use TSC to do irq accounting.
+			Used to run time disable IRQ_TIME_ACCOUNTING on any
+			platforms where RDTSC is slow and this accounting
+			can add overhead.
 
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..f4c70c2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -795,6 +795,17 @@ config SCHED_MC
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
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 26a863a..a1c2cd7 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -104,10 +104,14 @@ int __init notsc_setup(char *str)
 
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
 
@@ -801,6 +805,7 @@ void mark_tsc_unstable(char *reason)
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
 		sched_clock_stable = 0;
+		disable_sched_clock_irqtime();
 		printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
@@ -987,6 +992,9 @@ void __init tsc_init(void)
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
+	if (!no_sched_irq_time)
+		enable_sched_clock_irqtime();
+
 	lpj = ((u64)tsc_khz * 1000);
 	do_div(lpj, HZ);
 	lpj_fine = lpj;
-- 
1.7.1

