Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab0LNQ3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:29:35 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:45642 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759570Ab0LNQ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:28:57 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 6A9YFREVM1mWhiK89bFuxFlenXSbHZYXEKXp36W9uuCpWak
 JQpc4RLPmEG54MfLYtkcSWkBFS.CyLI1q6bREwYGu4IkNUVDj19_v_EmSEvL
 nlx2YttHDTr5qzrPt088BtUGsCyfV8n3McRgyKxomjnpBxLFbj3Fl57xw0pa
 e643mm_.M2Q.4MMADav6_uttamcCAniaEDxjGyGSeIBGANvSjXsnKGfDaP48
 a64tsVpdKtkPz8eRxyazs.Awvd0HdLRRJCAflHkplnpoOq_bUQXQ8OxZdDEY
 .7WZ.d7ytsJIzVj3gt19LetDVEjHNHCPe7jm3zELBYQh9rbk-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101214162854.811759020@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 14 Dec 2010 10:28:46 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg V2 4/5] vmstat: User per cpu atomics to avoid interrupt disable / enable
References: <20101214162842.542421046@linux.com>
Content-Disposition: inline; filename=cpuops_cmpxchg_vmstat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the operations to increment vm counters must disable interrupts
in order to not mess up their housekeeping of counters.

So use this_cpu_cmpxchg() to avoid the overhead. Since we can no longer
count on preremption being disabled we still have some minor issues.
The fetching of the counter thresholds is racy.
A threshold from another cpu may be applied if we happen to be
rescheduled on another cpu.  However, the following vmstat operation
will then bring the counter again under the threshold limit.

The operations for __xxx_zone_state are not changed since the caller
has taken care of the synchronization needs (and therefore the cycle
count is even less than the optimized version for the irq disable case
provided here).

The optimization using this_cpu_cmpxchg will only be used if the arch
supports efficient this_cpu_ops (must have CONFIG_CMPXCHG_LOCAL set!)

The use of this_cpu_cmpxchg reduces the cycle count for the counter
operations by %80 (inc_zone_page_state goes from 170 cycles to 32).

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/vmstat.c |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 87 insertions(+), 14 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2010-12-01 10:04:19.000000000 -0600
+++ linux-2.6/mm/vmstat.c	2010-12-01 10:09:06.000000000 -0600
@@ -185,20 +185,6 @@ void __mod_zone_page_state(struct zone *
 EXPORT_SYMBOL(__mod_zone_page_state);
 
 /*
- * For an unknown interrupt state
- */
-void mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
-					int delta)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__mod_zone_page_state(zone, item, delta);
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(mod_zone_page_state);
-
-/*
  * Optimized increment and decrement functions.
  *
  * These are only for a single page and therefore can take a struct page *
@@ -265,6 +251,92 @@ void __dec_zone_page_state(struct page *
 }
 EXPORT_SYMBOL(__dec_zone_page_state);
 
+#ifdef CONFIG_CMPXCHG_LOCAL
+/*
+ * If we have cmpxchg_local support then we do not need to incur the overhead
+ * that comes with local_irq_save/restore if we use this_cpu_cmpxchg.
+ *
+ * mod_state() modifies the zone counter state through atomic per cpu
+ * operations.
+ *
+ * Overstep mode specifies how overstep should handled:
+ *     0       No overstepping
+ *     1       Overstepping half of threshold
+ *     -1      Overstepping minus half of threshold
+*/
+static inline void mod_state(struct zone *zone,
+       enum zone_stat_item item, int delta, int overstep_mode)
+{
+	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	s8 __percpu *p = pcp->vm_stat_diff + item;
+	long o, n, t, z;
+
+	do {
+		z = 0;  /* overflow to zone counters */
+
+		/*
+		 * The fetching of the stat_threshold is racy. We may apply
+		 * a counter threshold to the wrong the cpu if we get
+		 * rescheduled while executing here. However, the following
+		 * will apply the threshold again and therefore bring the
+		 * counter under the threshold.
+		 */
+		t = this_cpu_read(pcp->stat_threshold);
+
+		o = this_cpu_read(*p);
+		n = delta + o;
+
+		if (n > t || n < -t) {
+			int os = overstep_mode * (t >> 1) ;
+
+			/* Overflow must be added to zone counters */
+			z = n + os;
+			n = -os;
+		}
+	} while (this_cpu_cmpxchg(*p, o, n) != o);
+
+	if (z)
+		zone_page_state_add(z, zone, item);
+}
+
+void mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
+					int delta)
+{
+	mod_state(zone, item, delta, 0);
+}
+EXPORT_SYMBOL(mod_zone_page_state);
+
+void inc_zone_state(struct zone *zone, enum zone_stat_item item)
+{
+	mod_state(zone, item, 1, 1);
+}
+
+void inc_zone_page_state(struct page *page, enum zone_stat_item item)
+{
+	mod_state(page_zone(page), item, 1, 1);
+}
+EXPORT_SYMBOL(inc_zone_page_state);
+
+void dec_zone_page_state(struct page *page, enum zone_stat_item item)
+{
+	mod_state(page_zone(page), item, -1, -1);
+}
+EXPORT_SYMBOL(dec_zone_page_state);
+#else
+/*
+ * Use interrupt disable to serialize counter updates
+ */
+void mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
+					int delta)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__mod_zone_page_state(zone, item, delta);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(mod_zone_page_state);
+
 void inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
 	unsigned long flags;
@@ -295,6 +367,7 @@ void dec_zone_page_state(struct page *pa
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(dec_zone_page_state);
+#endif
 
 /*
  * Update the zone counters for one cpu.

