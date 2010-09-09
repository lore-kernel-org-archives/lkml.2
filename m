Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0IIRlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:41:31 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58805 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0IIRl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:41:29 -0400
Message-Id: <201009091741.o89HfPfM011522@d03av02.boulder.ibm.com>
Subject: [PATCH 1/1] block: Range check cpu in blk_cpu_to_group
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
From: Brian King <brking@linux.vnet.ibm.com>
Date: Thu, 09 Sep 2010 12:41:31 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While testing CPU DLPAR, the following problem was discovered.
We were DLPAR removing the first CPU, which in this case was
logical CPUs 0-3. CPUs 0-2 were already marked offline and
we were in the process of offlining CPU 3. After marking
the CPU inactive and offline in cpu_disable, but before the
cpu was completely idle (cpu_die), we ended up in __make_request
on CPU 3. There we looked at the topology map to see which CPU
to complete the I/O on and found no CPUs in the cpu_sibling_map.
This resulted in the block layer setting the completion cpu
to be NR_CPUS, which then caused an oops when we tried to
complete the I/O.

Fix this by sanity checking the value we return from blk_cpu_to_group
to be a valid cpu value.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 block/blk.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN block/blk.h~blk_cpu_to_group_range_fix block/blk.h
--- linux-2.6/block/blk.h~blk_cpu_to_group_range_fix	2010-08-31 09:12:18.000000000 -0500
+++ linux-2.6-bjking1/block/blk.h	2010-08-31 16:48:17.000000000 -0500
@@ -142,14 +142,19 @@ static inline int queue_congestion_off_t
 
 static inline int blk_cpu_to_group(int cpu)
 {
+	int group = NR_CPUS;
 #ifdef CONFIG_SCHED_MC
 	const struct cpumask *mask = cpu_coregroup_mask(cpu);
-	return cpumask_first(mask);
+	group = cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
-	return cpumask_first(topology_thread_cpumask(cpu));
+	group = cpumask_first(topology_thread_cpumask(cpu));
 #else
 	return cpu;
 #endif
+
+	if (likely(group < NR_CPUS))
+		return group;
+	return cpu;
 }
 
 /*
_
