Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab0DIGVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:21:31 -0400
Received: from ozlabs.org ([203.10.76.45]:46438 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab0DIGVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:21:23 -0400
To: Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Michael Neuling <mikey@neuling.org>
Date: Fri, 09 Apr 2010 16:21:19 +1000
Subject: [PATCH 5/5] sched: make fix_small_imbalance work with asymmetric packing
In-Reply-To: <1270794078.794237.347827867455.qpush@pale>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Message-Id: <20100409062119.10AC5CBB6D@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the asymmetric packing infrastructure, fix_small_imbalance is
causing idle higher threads to pull tasks off lower threads.  

This is being caused by an off-by-one error.  

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
I'm not sure this is the right fix but without it, higher threads pull
tasks off the lower threads, then the packing pulls it back down, etc
etc and tasks bounce around constantly.

---

 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-ozlabs/kernel/sched_fair.c
===================================================================
--- linux-2.6-ozlabs.orig/kernel/sched_fair.c
+++ linux-2.6-ozlabs/kernel/sched_fair.c
@@ -2652,7 +2652,7 @@ static inline void fix_small_imbalance(s
 						 * SCHED_LOAD_SCALE;
 	scaled_busy_load_per_task /= sds->busiest->cpu_power;
 
-	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
+	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >
 			(scaled_busy_load_per_task * imbn)) {
 		*imbalance = sds->busiest_load_per_task;
 		return;
