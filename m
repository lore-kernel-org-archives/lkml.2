Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0KWXxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:53:48 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:28731 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754187Ab0KWXv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:51:59 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 2Q6rebEVM1nQnSnE0DP_Sm_EKPLolt1NmGmZ7uo.Ap79B4J
 HQamIG1GfDMwGQgtXMgl4EiIaWbH0dQwwgyraSaYandiGyJxP7ZcIeO7_rG0
 EIFUIosC_dKR_ASU0CbG0bsZxKlXwSfBGuPjfYwXjHdrRMou48Oj5yCuZQO9
 TLdRkKwgit7axVLxPo9izHHWkM.fSR1g7bmJQ_xNmy8V_IKQdgLnfm1Sv8QP
 KW5B7J0buRZEFi3Nuekhq0zAnlHioZqMYuPlfAmF3xdo3tlRN5fBG
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101123235157.062638491@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Nov 2010 17:51:41 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thiscpuops upgrade 02/10] vmstat: Optimize zone counter modifications through the use of this cpu operations
References: <20101123235139.908255844@linux.com>
Content-Disposition: inline; filename=vmstat_this_cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this cpu operations can be used to slightly optimize the function. The
changes will avoid some address calculations and replace them with the
use of the percpu segment register.

If one would have this_cpu_inc_return and this_cpu_dec_return then it
would be possible to optimize inc_zone_page_state and dec_zone_page_state even
more.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/vmstat.c |   56 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2010-11-09 11:18:22.000000000 -0600
+++ linux-2.6/mm/vmstat.c	2010-11-09 11:19:06.000000000 -0600
@@ -167,18 +167,20 @@ static void refresh_zone_stat_thresholds
 void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 				int delta)
 {
-	struct per_cpu_pageset *pcp = this_cpu_ptr(zone->pageset);
-
-	s8 *p = pcp->vm_stat_diff + item;
+	struct per_cpu_pageset * __percpu pcp = zone->pageset;
+	s8 * __percpu p = pcp->vm_stat_diff + item;
 	long x;
+	long t;
+
+	x = delta + __this_cpu_read(*p);
 
-	x = delta + *p;
+	t = __this_cpu_read(pcp->stat_threshold);
 
-	if (unlikely(x > pcp->stat_threshold || x < -pcp->stat_threshold)) {
+	if (unlikely(x > t || x < -t)) {
 		zone_page_state_add(x, zone, item);
 		x = 0;
 	}
-	*p = x;
+	__this_cpu_write(*p, x);
 }
 EXPORT_SYMBOL(__mod_zone_page_state);
 
@@ -221,16 +223,19 @@ EXPORT_SYMBOL(mod_zone_page_state);
  */
 void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset *pcp = this_cpu_ptr(zone->pageset);
-	s8 *p = pcp->vm_stat_diff + item;
-
-	(*p)++;
+	struct per_cpu_pageset * __percpu pcp = zone->pageset;
+	s8 * __percpu p = pcp->vm_stat_diff + item;
+	int v, t;
+
+	__this_cpu_inc(*p);
+
+	v = __this_cpu_read(*p);
+	t = __this_cpu_read(pcp->stat_threshold);
+	if (unlikely(v > t)) {
+		int overstep = t / 2;
 
-	if (unlikely(*p > pcp->stat_threshold)) {
-		int overstep = pcp->stat_threshold / 2;
-
-		zone_page_state_add(*p + overstep, zone, item);
-		*p = -overstep;
+		zone_page_state_add(v + overstep, zone, item);
+		__this_cpu_write(*p, overstep);
 	}
 }
 
@@ -242,16 +247,19 @@ EXPORT_SYMBOL(__inc_zone_page_state);
 
 void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset *pcp = this_cpu_ptr(zone->pageset);
-	s8 *p = pcp->vm_stat_diff + item;
-
-	(*p)--;
-
-	if (unlikely(*p < - pcp->stat_threshold)) {
-		int overstep = pcp->stat_threshold / 2;
+	struct per_cpu_pageset * __percpu pcp = zone->pageset;
+	s8 * __percpu p = pcp->vm_stat_diff + item;
+	int v, t;
+
+	__this_cpu_dec(*p);
+
+	v = __this_cpu_read(*p);
+	t = __this_cpu_read(pcp->stat_threshold);
+	if (unlikely(v < - t)) {
+		int overstep = t / 2;
 
-		zone_page_state_add(*p - overstep, zone, item);
-		*p = overstep;
+		zone_page_state_add(v - overstep, zone, item);
+		__this_cpu_write(*p, overstep);
 	}
 }
 

