Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0K3TIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:08:48 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:33392 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752155Ab0K3TIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:44 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: UaTa.NIVM1k8Fk56tCtTeN_rqvQL1UFQypgBfROyUX6r5Jj
 roZofpTG0FKcEWMUKUs3oFiP_EuBNNCNMIV6oHUOcOreuL3oFgTNYx7HAzqF
 KHmP3QD4pGCtzxpb8alSWfOzVAwO89UIM7V3O669vy8tv6rau7a5mOSl_NYT
 1XiHNKi.VN4gPHxSM8ArynohhlLbh9Qf.l.esACys4j2ik1NVLSgvh65Hwgm
 RPtxjp.V65IdAcG_EmHKK9QQjpmbUlHhmM4A3kc4zgRlBGEZcF8dC
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190842.265514747@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:09 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 02/18] vmstat: Optimize zone counter modifications through the use of this cpu operations
References: <20101130190707.457099608@linux.com>
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

V1->V2:
	- Fix __dec_zone_state overflow handling
	- Use s8 variables for temporary storage.

V2->V3:
	- Put __percpu annotations in correct places.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/vmstat.c |   56 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2010-11-29 10:17:28.000000000 -0600
+++ linux-2.6/mm/vmstat.c	2010-11-29 10:36:16.000000000 -0600
@@ -167,18 +167,20 @@ static void refresh_zone_stat_thresholds
 void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 				int delta)
 {
-	struct per_cpu_pageset *pcp = this_cpu_ptr(zone->pageset);
-
-	s8 *p = pcp->vm_stat_diff + item;
+	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	s8 __percpu *p = pcp->vm_stat_diff + item;
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
+	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	s8 __percpu *p = pcp->vm_stat_diff + item;
+	s8 v, t;
+
+	__this_cpu_inc(*p);
+
+	v = __this_cpu_read(*p);
+	t = __this_cpu_read(pcp->stat_threshold);
+	if (unlikely(v > t)) {
+		s8 overstep = t >> 1;
 
-	if (unlikely(*p > pcp->stat_threshold)) {
-		int overstep = pcp->stat_threshold / 2;
-
-		zone_page_state_add(*p + overstep, zone, item);
-		*p = -overstep;
+		zone_page_state_add(v + overstep, zone, item);
+		__this_cpu_write(*p, - overstep);
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
+	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	s8 __percpu *p = pcp->vm_stat_diff + item;
+	s8 v, t;
+
+	__this_cpu_dec(*p);
+
+	v = __this_cpu_read(*p);
+	t = __this_cpu_read(pcp->stat_threshold);
+	if (unlikely(v < - t)) {
+		s8 overstep = t >> 1;
 
-		zone_page_state_add(*p - overstep, zone, item);
-		*p = overstep;
+		zone_page_state_add(v - overstep, zone, item);
+		__this_cpu_write(*p, overstep);
 	}
 }
 

