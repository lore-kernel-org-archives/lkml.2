Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab0KZVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:09:58 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:35466 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751399Ab0KZVJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:09:54 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: SnncbPEVM1lfK2KDfR2rSsQ0JVqHIzxlVU_Ji9Zs_vSZVPN
 VzsZf7lfQv55J1bsct2yAF9lfudmEzUMilYxYfqYX0ajvvcZcJAJ3ejXkbjz
 j9NQzTOtVpUDt.IF55V2Ay80r5KkLUjvGTHAntLIkpXskuPkxS6R.skVRcYL
 goZLc_WHTqfseKw_qequvuLEb7jIiXqBof95Pgmlp.U0KoilQ.zMLmSkEUSf
 ed0Iwv07mBLECwcw.pR12.6It32sr8e9A9lF2qq9cUPyHs91NdwPpA19bVSq
 SIhCnuXn3Jc.Uhv5AjdfJ
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101126210952.446650993@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Nov 2010 15:09:43 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thisops uV2 06/10] vmstat: Use this_cpu_inc_return for vm statistics
References: <20101126210937.383047168@linux.com>
Content-Disposition: inline; filename=this_cpu_add_vmstat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_inc_return() saves us a memory access there. Code
size does not change.

V1->V2:
	- Fixed the location of the __per_cpu pointer attributes
	- Sparse checked

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/vmstat.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2010-11-26 10:35:45.000000000 -0600
+++ linux-2.6/mm/vmstat.c	2010-11-26 10:45:49.000000000 -0600
@@ -167,8 +167,8 @@ static void refresh_zone_stat_thresholds
 void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 				int delta)
 {
-	struct per_cpu_pageset * __percpu pcp = zone->pageset;
-	s8 * __percpu p = pcp->vm_stat_diff + item;
+	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	s8 __percpu *p = pcp->vm_stat_diff + item;
 	long x;
 	long t;
 
@@ -223,13 +223,11 @@ EXPORT_SYMBOL(mod_zone_page_state);
  */
 void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset * __percpu pcp = zone->pageset;
-	s8 * __percpu p = pcp->vm_stat_diff + item;
+	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	__this_cpu_inc(*p);
-
-	v = __this_cpu_read(*p);
+	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
 		s8 overstep = t >> 1;
@@ -247,13 +245,11 @@ EXPORT_SYMBOL(__inc_zone_page_state);
 
 void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset * __percpu pcp = zone->pageset;
-	s8 * __percpu p = pcp->vm_stat_diff + item;
+	struct per_cpu_pageset __percpu *pcp = zone->pageset;
+	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	__this_cpu_dec(*p);
-
-	v = __this_cpu_read(*p);
+	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
 		s8 overstep = t >> 1;

