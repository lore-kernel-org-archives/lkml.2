Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab0JUHJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:09:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36300 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab0JUHJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:09:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 21 Oct 2010 16:03:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        steiner@sgi.com, yinghai@kernel.org, mingo@elte.hu
Subject: [PATCH v2 2/2] try to fix /proc/stat scalability of irq sum of all
 cpu
Message-Id: <20101021160343.b7a0f60e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101021160134.d4c99943.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101021160134.d4c99943.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In /proc/stat, the number of per-IRQ event is shown by making a sum
each irq's events on all cpus. But we can make use of kstat_irqs().

kstat_irqs() do the same calculation, If !CONFIG_GENERIC_HARDIRQ,
it's not a big cost. (Both of the number of cpus and irqs are small.)

If a system is very big and CONFIG_GENERIC_HARDIRQ, it does

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

This reduces cost.

A test on (4096cpusp, 256 nodes, 4592 irqs) host (by Jack Steiner)

%time cat /proc/stat > /dev/null

Before Patch:	 2.459 sec
After Patch :	  .561 sec

Changelog:
 - rebased onto mmotm-1020 (kernel/irq/handle.c is modified)

Tested-by: Jack Steiner <steiner@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/stat.c              |    9 ++-------
 include/linux/kernel_stat.h |    4 ++++
 kernel/irq/irqdesc.c        |   16 ++++++++++++++++
 3 files changed, 22 insertions(+), 7 deletions(-)

Index: mmotm-1020/fs/proc/stat.c
===================================================================
--- mmotm-1020.orig/fs/proc/stat.c
+++ mmotm-1020/fs/proc/stat.c
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
Index: mmotm-1020/include/linux/kernel_stat.h
===================================================================
--- mmotm-1020.orig/include/linux/kernel_stat.h
+++ mmotm-1020/include/linux/kernel_stat.h
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
Index: mmotm-1020/kernel/irq/irqdesc.c
===================================================================
--- mmotm-1020.orig/kernel/irq/irqdesc.c
+++ mmotm-1020/kernel/irq/irqdesc.c
@@ -393,3 +393,19 @@ unsigned int kstat_irqs_cpu(unsigned int
 	struct irq_desc *desc = irq_to_desc(irq);
 	return desc ? desc->kstat_irqs[cpu] : 0;
 }
+
+#ifdef CONFIG_GENERIC_HARDIRQS
+unsigned int  kstat_irqs(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	int cpu;
+	int sum = 0;
+
+	if (!desc)
+		return 0;
+	for_each_possible_cpu(cpu)
+		sum += desc->kstat_irqs[cpu];
+	return sum;
+}
+EXPORT_SYMBOL_GPL(kstat_irqs);
+#endif /*CONFIG_GENERIC_HARDIRQS*/

