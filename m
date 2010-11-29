Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0K2UHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:07:54 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:24052 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751784Ab0K2UHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:07:52 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: cupWvB0VM1kL1KR7_U5bs2fBwj_wX0NAEYphhTE8B2Tl3gO
 v0pW.A7jgpkqP9FpOZj.UBU2VwjqLMkIucfowx4O9OqDMkMm0tpJ_ztsh9rp
 _1rj4JTfswL2LUrFVNqYmmRJUBdj7TtFxdaIssxCq0snQmZEWqnlg1i0u8Kk
 MglbZrAK058EvDJWfJHpm86QTW.YeEEmkzP1wplGXoqYxaoAige5M7oMbnew
 3p._X_yG3roTAJj2qwH0DSL3ohXvUi.t_H4bRL9IddVgarfnxyJxN
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 29 Nov 2010 14:07:49 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 02/10] vmstat: Optimize zone counter modifications
 through the use of this cpu operations
In-Reply-To: <20101129192801.GE25610@Krystal>
Message-ID: <alpine.DEB.2.00.1011291402300.4836@router.home>
References: <20101126210937.383047168@linux.com> <20101126210950.142747403@linux.com> <20101127144949.GC15365@Krystal> <alpine.DEB.2.00.1011291013460.3923@router.home> <alpine.DEB.2.00.1011291111110.4836@router.home> <20101129192801.GE25610@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Mathieu Desnoyers wrote:

> * Christoph Lameter (cl@linux.com) wrote:
> > We could do this with local cmpxchgs like in the following patch. This
> > would avoid preemption disable and interrupt disable (at least on x86).
> > Trouble is how do we make this fit for architectures that do not have
> > cmpxchg?
>
> All architectures should have a fallback nowadays, no ? This might involve
> disabling interrupts around a cmpxchg emulation, which would make the slow path
> disable/enable interrupts twice. Is it what you are concerned about ?

We are adding new per cpu atomic functionality here and we are
establishing the fallbacks as we go.

Fallbacks are to an cmpxchg emulation using interrupt disable etc of
course but the performance may be lower than the current version. I need
to get some numbers to assess the impact. In the meantime I have a full
cmpxchg based vmstat implementation here that seems to work without a
problem:

Subject: vmstat: User per cpu atomics to avoid interrupt and preempt disable

Currently the operations to increment vm counters must disable preempt and/or
interrupts in order to not mess up their housekeeping of counters. Both measures
have disadvantages. Interrupt disable causes a lot of overhead. Disabling
preemption is something that the RT folks do not like.

So use this_cpu_cmpxchg() to avoid any of those things. The fetching of the
counter thresholds is racy. A threshold from another cpu may be applied
if we happen to be rescheduled on another cpu.  However, the following
vmstat operation will then bring the counter again under the
threshold limit.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/vmstat.c |  145 +++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 86 insertions(+), 59 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2010-11-29 12:31:20.000000000 -0600
+++ linux-2.6/mm/vmstat.c	2010-11-29 12:36:42.000000000 -0600
@@ -162,27 +162,87 @@ static void refresh_zone_stat_thresholds
 }

 /*
- * For use when we know that interrupts are disabled.
+ * mod_state() modifies the zone counter state through atomic per cpu
+ * operations.
+ *
+ * Overstep mode specifies how overstep should handled:
+ *	0	No overstepping
+ *	1	Overstepping half of threshold
+ *	-1	Overstepping minus half of threshold
  */
-void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
-				int delta)
+static inline void mod_state(struct zone *zone,
+	enum zone_stat_item item, int delta, int overstep_mode)
 {
 	struct per_cpu_pageset __percpu *pcp = zone->pageset;
 	s8 __percpu *p = pcp->vm_stat_diff + item;
-	long x;
-	long t;
+	long o, n, t, z;

-	x = delta + __this_cpu_read(*p);
+	do {
+		z = 0;	/* overflow to zone counters */

-	t = __this_cpu_read(pcp->stat_threshold);
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
+	} while (o != n && irqsafe_cpu_cmpxchg(*p, o, n) != o);

-	if (unlikely(x > t || x < -t)) {
-		zone_page_state_add(x, zone, item);
-		x = 0;
-	}
-	__this_cpu_write(*p, x);
+	if (z)
+		zone_page_state_add(z, zone, item);
+}
+
+/*
+ * Variant for the case where we know that the preemption /interrupt
+ * has been taken care of.
+ */
+static inline void __mod_state(struct zone *zone,
+	enum zone_stat_item item, int delta, int overstep_mode)
+{
+	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	s8 __percpu *p = pcp->vm_stat_diff + item;
+	long o, n, t, z;
+
+	do {
+		z = 0;	/* overflow to zone counters */
+
+		/*
+		 * The fetching of the stat_threshold is racy. We may apply
+		 * a counter threshold to the wrong the cpu if we get
+		 * rescheduled while executing here. However, the following
+		 * will apply the threshold again and therefore bring the
+		 * counter under the threshold.
+		 */
+		t = __this_cpu_read(pcp->stat_threshold);
+
+		o = __this_cpu_read(*p);
+		n = delta + o;
+
+		if (n > t || n < -t) {
+			int os = overstep_mode * (t >> 1) ;
+
+			/* Overflow must be added to zone counters */
+			z = n + os;
+			n = -os;
+		}
+	} while (o != n && __this_cpu_cmpxchg(*p, o, n) != o);
+
+	if (z)
+		zone_page_state_add(z, zone, item);
 }
-EXPORT_SYMBOL(__mod_zone_page_state);

 /*
  * For an unknown interrupt state
@@ -190,14 +250,17 @@ EXPORT_SYMBOL(__mod_zone_page_state);
 void mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 					int delta)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__mod_zone_page_state(zone, item, delta);
-	local_irq_restore(flags);
+	mod_state(zone, item, delta, 0);
 }
 EXPORT_SYMBOL(mod_zone_page_state);

+void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
+					int delta)
+{
+	__mod_state(zone, item, delta, 0);
+}
+EXPORT_SYMBOL(__mod_zone_page_state);
+
 /*
  * Optimized increment and decrement functions.
  *
@@ -223,18 +286,7 @@ EXPORT_SYMBOL(mod_zone_page_state);
  */
 void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset __percpu *pcp = zone->pageset;
-	s8 __percpu *p = pcp->vm_stat_diff + item;
-	s8 v, t;
-
-	v = __this_cpu_inc_return(*p);
-	t = __this_cpu_read(pcp->stat_threshold);
-	if (unlikely(v > t)) {
-		s8 overstep = t >> 1;
-
-		zone_page_state_add(v + overstep, zone, item);
-		__this_cpu_write(*p, - overstep);
-	}
+	__mod_state(zone, item, 1, 1);
 }

 void __inc_zone_page_state(struct page *page, enum zone_stat_item item)
@@ -245,18 +297,7 @@ EXPORT_SYMBOL(__inc_zone_page_state);

 void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset __percpu *pcp = zone->pageset;
-	s8 __percpu *p = pcp->vm_stat_diff + item;
-	s8 v, t;
-
-	v = __this_cpu_dec_return(*p);
-	t = __this_cpu_read(pcp->stat_threshold);
-	if (unlikely(v < - t)) {
-		s8 overstep = t >> 1;
-
-		zone_page_state_add(v - overstep, zone, item);
-		__this_cpu_write(*p, overstep);
-	}
+	__mod_state(zone, item, -1, -1);
 }

 void __dec_zone_page_state(struct page *page, enum zone_stat_item item)
@@ -267,32 +308,18 @@ EXPORT_SYMBOL(__dec_zone_page_state);

 void inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__inc_zone_state(zone, item);
-	local_irq_restore(flags);
+	mod_state(zone, item, 1, 1);
 }

 void inc_zone_page_state(struct page *page, enum zone_stat_item item)
 {
-	unsigned long flags;
-	struct zone *zone;
-
-	zone = page_zone(page);
-	local_irq_save(flags);
-	__inc_zone_state(zone, item);
-	local_irq_restore(flags);
+	mod_state(page_zone(page), item, 1, 1);
 }
 EXPORT_SYMBOL(inc_zone_page_state);

 void dec_zone_page_state(struct page *page, enum zone_stat_item item)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__dec_zone_page_state(page, item);
-	local_irq_restore(flags);
+	mod_state(page_zone(page), item, -1, -1);
 }
 EXPORT_SYMBOL(dec_zone_page_state);



