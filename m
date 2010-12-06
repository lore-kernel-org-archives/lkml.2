Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab0LFRSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:18:04 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:21401 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753257Ab0LFRQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:16:40 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: NAeXXmkVM1mGiG_NG9D0GJ1ogcq4tQeBVF36sodMarMzJQm
 O903VV9P1yXZaH54yf9HLQ4U4caXMP7gg9AFyVBxmF3FAzAnD7PA4csHh.Wp
 Hst0TK4V4WQirm99tiRnjRoUZC4wr4ByuNNjJh1bMEcULyQdcpTwXP_2OzF_
 GD69c1ldAoMGx9rkC8NnRGJgcWnGm2.QF6x0nl22_8sNfJQAE.KQVOwMUgsX
 87jOfbiQnZ2MBFD3EkijXDs9EuI1j8chrgFUCDGkYgota.iCsW7Cb
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206171637.445023081@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:16:20 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [Use cpuops V1 02/11] vmstat: Optimize zone counter modifications through the use of this cpu operations
References: <20101206171618.302060721@linux.com>
Content-Disposition: inline; filename=cpuops_vmstat_this_cpu
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
 

