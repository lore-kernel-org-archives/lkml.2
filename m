Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0JLCpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 22:45:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57048 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0JLCpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 22:45:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Oct 2010 11:39:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
        yinghai@kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] improve footprint of kstat_irqs() for large system's
 /proc/stat
Message-Id: <20101012113958.058d68e3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101012113736.f34d1426.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100929122206.GA30317@sgi.com>
	<20100930140901.037f9dc7.kamezawa.hiroyu@jp.fujitsu.com>
	<20101004143414.GA4261@sgi.com>
	<20101005103650.7ebe64f0.kamezawa.hiroyu@jp.fujitsu.com>
	<20101005171907.23c75102.kamezawa.hiroyu@jp.fujitsu.com>
	<20101008163557.GA13859@sgi.com>
	<20101012090907.5dd1cf57.kamezawa.hiroyu@jp.fujitsu.com>
	<20101011172226.6162476c.akpm@linux-foundation.org>
	<20101012113736.f34d1426.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Problem: 'cat /proc/stat' takes too long in verrrry big system.

In /proc/stat, the number of per-IRQ event is shown by making a sum
each irq's events on all cpus. We can make use of kstat_irqs().
This patch replaces it, at first.

Here, performance of kstat_irqs() is a problem.
If !CONFIG_GENERIC_HARDIRQ, it's not very slow, but if CONFIG_GENERIC_HARDIRQ,
it's slow because the logic is not efficient.

If CONFIG_GENERIC_HARDIRQ, it does

	for_each_irq()
		for_each_cpu()
			- look up a radix tree
			- read desc->irq_stat[cpu]

This seems not efficient. This patch adds kstat_irqs() for
CONFIG_GENRIC_HARDIRQ and change the calculation as

	for_each_irq()
		look up radix tree
		for_each_cpu()
			- read desc->irq_stat[cpu]

This reduces cost of scanning.

A test on (4096cpusp, 256 nodes, 4592 irqs) host (by Jack Steiner)

%time cat /proc/stat > /dev/null

Before Patch:	 2.459 sec
After Patch :	  .561 sec


Tested-by: Jack Steiner <steiner@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/stat.c              |    9 ++-------
 include/linux/kernel_stat.h |    4 ++++
 kernel/irq/handle.c         |   16 ++++++++++++++++
 3 files changed, 22 insertions(+), 7 deletions(-)

Index: linux-2.6.36-rc7/fs/proc/stat.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/stat.c
+++ linux-2.6.36-rc7/fs/proc/stat.c
@@ -108,13 +108,8 @@ static int show_stat(struct seq_file *p,
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
 	/* sum again ? it could be updated? */
-	for_each_irq_nr(j) {
-		per_irq_sum = 0;
-		for_each_possible_cpu(i)
-			per_irq_sum += kstat_irqs_cpu(j, i);
-
-		seq_printf(p, " %u", per_irq_sum);
-	}
+	for_each_irq_nr(j)
+		seq_printf(p, " %u", kstat_irqs(j));
 
 	seq_printf(p,
 		"\nctxt %llu\n"
Index: linux-2.6.36-rc7/include/linux/kernel_stat.h
===================================================================
--- linux-2.6.36-rc7.orig/include/linux/kernel_stat.h
+++ linux-2.6.36-rc7/include/linux/kernel_stat.h
@@ -86,6 +86,7 @@ static inline unsigned int kstat_softirq
 /*
  * Number of interrupts per specific IRQ source, since bootup
  */
+#ifndef CONFIG_GENERIC_HARDIRQS
 static inline unsigned int kstat_irqs(unsigned int irq)
 {
 	unsigned int sum = 0;
@@ -96,6 +97,9 @@ static inline unsigned int kstat_irqs(un
 
 	return sum;
 }
+#else
+extern unsigned int kstat_irqs(unsigned int irq);
+#endif
 
 /*
  * Number of interrupts per cpu, since bootup
Index: linux-2.6.36-rc7/kernel/irq/handle.c
===================================================================
--- linux-2.6.36-rc7.orig/kernel/irq/handle.c
+++ linux-2.6.36-rc7/kernel/irq/handle.c
@@ -554,3 +554,19 @@ unsigned int kstat_irqs_cpu(unsigned int
 }
 EXPORT_SYMBOL(kstat_irqs_cpu);
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+unsigned int kstat_irqs(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	int cpu;
+	int sum = 0;
+
+	if (!desc)
+		return 0;
+
+	for_each_possible_cpu(cpu)
+		sum += desc->kstat_irqs[cpu];
+	return sum;
+}
+EXPORT_SYMBOL(kstat_irqs);
+#endif

