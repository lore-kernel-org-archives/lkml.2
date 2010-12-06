Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0LFRlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:41:23 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:44524 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752395Ab0LFRkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:40:17 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: vlqAfQUVM1nYTRJMkft8NTpwHyFk4ZVu9EJjrb8sHMvgxrX
 xNWYuWM4EZfaA8oWumrsp.y4MrJ0s100FQlxBP7gZW0Dv0pLLXTTnE8VuA6j
 piXXtwz3Zhihv4pRhsf04X835R0TSTuIDuCIENhK1q8mtYEIxYoEMX.N04pe
 ke5kjQ570s5zmgsrGAGuJeImBjK3oMvWp4jJk5xjA_I.9YiQA3P1JVLBNi5I
 2pZydevn9z.3ZpPHT2vBM6lmqEJW2m0ZGiIdLEzT1pElRnBJKc.74sEFEA8t
 Q4X1OaAoRVCSe7E7NNIwF
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206174015.389916144@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:40:02 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops inc_return V1 4/9] vmstat: Use this_cpu_inc_return for vm statistics
References: <20101206173958.685460926@linux.com>
Content-Disposition: inline; filename=cpuops_inc_return_vmstat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_inc_return() saves us a memory access there. Code
size does not change.

V1->V2:
	- Fixed the location of the __per_cpu pointer attributes
	- Sparse checked
V2->V3:
	- Move fixes to __percpu attribute usage to earlier patch

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/vmstat.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2010-11-29 10:36:16.000000000 -0600
+++ linux-2.6/mm/vmstat.c	2010-11-29 10:38:50.000000000 -0600
@@ -227,9 +227,7 @@ void __inc_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	__this_cpu_inc(*p);
-
-	v = __this_cpu_read(*p);
+	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
 		s8 overstep = t >> 1;
@@ -251,9 +249,7 @@ void __dec_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	__this_cpu_dec(*p);
-
-	v = __this_cpu_read(*p);
+	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
 		s8 overstep = t >> 1;

