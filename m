Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0JUHHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:07:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36222 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab0JUHHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:07:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 21 Oct 2010 16:01:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, steiner@sgi.com,
        yinghai@kernel.org, mingo@elte.hu
Subject: [PATCH v2 1/2] try to fix /proc/stat scalability of irq num per cpu
Message-Id: <20101021160134.d4c99943.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Posting an updated version against mmotm because I noticed rebase is necessary.
(kernel/irq/handle.c is modified.)
I'll post this again after merge window.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

/proc/stat shows the total number of all interrupts to each cpu. But when
the number of IRQs are very large, it take very long time and 'cat /proc/stat'
takes more than 10 secs. This is because sum of all irq events are counted
when /proc/stat is read. This patch adds "sum of all irq" counter percpu
and reduce read costs.

The cost of reading /proc/stat is important because it's used by major
applications as 'top', 'ps', 'w', etc....

A test on a mechin (4096cpu, 256 nodes, 4592 irqs) shows

 %time cat /proc/stat > /dev/null
 Before Patch:  12.627 sec
 After  Patch:  2.459 sec

Tested-by: Jack Steiner <steiner@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/stat.c              |    4 +---
 include/linux/kernel_stat.h |   14 ++++++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

Index: mmotm-1020/fs/proc/stat.c
===================================================================
--- mmotm-1020.orig/fs/proc/stat.c
+++ mmotm-1020/fs/proc/stat.c
@@ -52,9 +52,7 @@ static int show_stat(struct seq_file *p,
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 		guest_nice = cputime64_add(guest_nice,
 			kstat_cpu(i).cpustat.guest_nice);
-		for_each_irq_nr(j) {
-			sum += kstat_irqs_cpu(j, i);
-		}
+		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
Index: mmotm-1020/include/linux/kernel_stat.h
===================================================================
--- mmotm-1020.orig/include/linux/kernel_stat.h
+++ mmotm-1020/include/linux/kernel_stat.h
@@ -33,6 +33,7 @@ struct kernel_stat {
 #ifndef CONFIG_GENERIC_HARDIRQS
        unsigned int irqs[NR_IRQS];
 #endif
+	unsigned long irqs_sum;
 	unsigned int softirqs[NR_SOFTIRQS];
 };
 
@@ -54,6 +55,7 @@ static inline void kstat_incr_irqs_this_
 					    struct irq_desc *desc)
 {
 	kstat_this_cpu.irqs[irq]++;
+	kstat_this_cpu.irqs_sum++;
 }
 
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
@@ -65,8 +67,9 @@ static inline unsigned int kstat_irqs_cp
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
 #define kstat_irqs_this_cpu(DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()])
-#define kstat_incr_irqs_this_cpu(irqno, DESC) \
-	((DESC)->kstat_irqs[smp_processor_id()]++)
+#define kstat_incr_irqs_this_cpu(irqno, DESC) do {\
+	((DESC)->kstat_irqs[smp_processor_id()]++);\
+	kstat_this_cpu.irqs_sum++; } while (0)
 
 #endif
 
@@ -94,6 +97,13 @@ static inline unsigned int kstat_irqs(un
 	return sum;
 }
 
+/*
+ * Number of interrupts per cpu, since bootup
+ */
+static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
+{
+	return kstat_cpu(cpu).irqs_sum;
+}
 
 /*
  * Lock/unlock the current runqueue - to extract task statistics:

