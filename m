Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0I3FOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 01:14:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59760 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab0I3FOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 01:14:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 30 Sep 2010 14:09:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jack Steiner <steiner@sgi.com>
Cc: yinghai@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: Problem: scaling of /proc/stat on large systems
Message-Id: <20100930140901.037f9dc7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100929122206.GA30317@sgi.com>
References: <20100929122206.GA30317@sgi.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 07:22:06 -0500
Jack Steiner <steiner@sgi.com> wrote:

> I'm looking for suggestions on how to fix a scaling problem with access to
> /proc/stat.
> 
> On a large x86_64 system (4096p, 256 nodes, 5530 IRQs), access to
> /proc/stat takes too long -  more than 12 sec:
> 
> 	# time cat /proc/stat >/dev/null
> 	real	12.630s
> 	user	 0.000s
> 	sys	12.629s
> 
> This affects top, ps (some variants), w, glibc (sysconf) and much more.
> 
> 
> One of the items reported in /proc/stat is a total count of interrupts that
> have been received. This calculation requires summation of the interrupts
> received on each cpu (kstat_irqs_cpu()).
> 
> The data is kept in per-cpu arrays linked to each irq_desc. On a
> 4096p/5530IRQ system summing this data requires accessing ~90MB.
> 
Wow.

> 
> Deleting the summation of the kstat_irqs_cpu data eliminates the high
> access time but is an API breakage that I assume is unacceptible.
> 
> Another possibility would be using delayed work (similar to vmstat_update)
> that periodically sums the data into a single array. The disadvantage in
> this approach is that there would be a delay between receipt of an
> interrupt & it's count appearing /proc/stat. Is this an issue for anyone?
> Another disadvantage is that it adds to the overall "noise" introduced by
> kernel threads.
> 
> Is there a better approach to take?
> 

Hmm, this ? 
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

/proc/stat shows the total number of all interrupts to each cpu. But when
the number of IRQs are very large, it take very long time and 'cat /proc/stat'
takes more than 10 secs. This is because sum of all irq events are counted
when /proc/stat is read. This patch adds "sum of all irq" counter percpu
and reduce read costs.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/stat.c              |    4 +---
 include/linux/kernel_stat.h |   14 ++++++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

Index: mmotm-0922/fs/proc/stat.c
===================================================================
--- mmotm-0922.orig/fs/proc/stat.c
+++ mmotm-0922/fs/proc/stat.c
@@ -52,9 +52,7 @@ static int show_stat(struct seq_file *p,
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 		guest_nice = cputime64_add(guest_nice,
 			kstat_cpu(i).cpustat.guest_nice);
-		for_each_irq_nr(j) {
-			sum += kstat_irqs_cpu(j, i);
-		}
+		sum = kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
Index: mmotm-0922/include/linux/kernel_stat.h
===================================================================
--- mmotm-0922.orig/include/linux/kernel_stat.h
+++ mmotm-0922/include/linux/kernel_stat.h
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
+	kstat_this_cpu.irqs_sum++;} while (0)
 
 #endif
 
@@ -94,6 +97,13 @@ static inline unsigned int kstat_irqs(un
 	return sum;
 }
 
+/*
+ * Number of interrupts per cpu, since bootup
+ */
+static inline unsigned long kstat_cpu_irqs_sum(unsigned int cpu)
+{
+	return kstat_cpu(cpu).irqs_sum;
+}
 
 /*
  * Lock/unlock the current runqueue - to extract task statistics:


