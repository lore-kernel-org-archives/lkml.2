Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2AHQ2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:28:48 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35281 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab2AHQ2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:28:17 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>
Subject: [PATCH v6 7/8] mm: only IPI CPUs to drain local pages if they exist
Date: Sun,  8 Jan 2012 18:27:05 +0200
Message-Id: <1326040026-7285-8-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculate a cpumask of CPUs with per-cpu pages in any zone
and only send an IPI requesting CPUs to drain these pages
to the buddy allocator if they actually have pages when
asked to flush.

This patch saves 90%+ of IPIs asking to drain per-cpu
pages in case of severe memory preassure that leads
to OOM since in these cases multiple, possibly concurrent,
allocation requests end up in the direct reclaim code
path so when the per-cpu pages end up reclaimed on first
allocation failure for most of the proceeding allocation
attempts until the memory pressure is off (possibly via
the OOM killer) there are no per-cpu pages on most CPUs
(and there can easily be hundreds of them).

This also has the side effect of shortening the average
latency of direct reclaim by 1 or more order of magnitude
since waiting for all the CPUs to ACK the IPI takes a
long time.

Tested by running "hackbench 400" on a 4 CPU x86 otherwise
idle VM and observing the difference between the number
of direct reclaim attempts that end up in drain_all_pages()
and those were more then 1/2 of the online CPU had any
per-cpu page in them, using the vmstat counters introduced
in the next patch in the series and using proc/interrupts.

In the test sceanrio, this saved around 500 global IPIs.
After trigerring an OOM:

$ cat /proc/vmstat
...
pcp_global_drain 627
pcp_global_ipi_saved 578

I've also seen the number of drains reach 15k calls
with the saved percentage reaching 99% when there
are more tasks running during an OOM kill.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Christoph Lameter <cl@linux.com>
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-mm@kvack.org
CC: Pekka Enberg <penberg@kernel.org>
CC: Matt Mackall <mpm@selenic.com>
CC: Sasha Levin <levinsasha928@gmail.com>
CC: Rik van Riel <riel@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
CC: Avi Kivity <avi@redhat.com>
CC: Michal Nazarewicz <mina86@mina86.org>
---
 mm/page_alloc.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bdc804c..dc97199 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -67,6 +67,14 @@ DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
 #endif
 
+/*
+ * A global cpumask of CPUs with per-cpu pages that gets
+ * recomputed on each drain. We use a global cpumask
+ * here to avoid allocation on direct reclaim code path
+ * for CONFIG_CPUMASK_OFFSTACK=y
+ */
+static cpumask_var_t cpus_with_pcps;
+
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
 /*
  * N.B., Do NOT reference the '_numa_mem_' per cpu variable directly.
@@ -1097,7 +1105,19 @@ void drain_local_pages(void *arg)
  */
 void drain_all_pages(void)
 {
-	on_each_cpu(drain_local_pages, NULL, 1);
+	int cpu;
+	struct per_cpu_pageset *pcp;
+	struct zone *zone;
+
+	for_each_online_cpu(cpu)
+		for_each_populated_zone(zone) {
+			pcp = per_cpu_ptr(zone->pageset, cpu);
+			if (pcp->pcp.count)
+				cpumask_set_cpu(cpu, cpus_with_pcps);
+			else
+				cpumask_clear_cpu(cpu, cpus_with_pcps);
+		}
+	on_each_cpu_mask(cpus_with_pcps, drain_local_pages, NULL, 1);
 }
 
 #ifdef CONFIG_HIBERNATION
@@ -3601,6 +3621,10 @@ static void setup_zone_pageset(struct zone *zone)
 void __init setup_per_cpu_pageset(void)
 {
 	struct zone *zone;
+	int ret;
+
+	ret = zalloc_cpumask_var(&cpus_with_pcps, GFP_KERNEL);
+	BUG_ON(!ret);
 
 	for_each_populated_zone(zone)
 		setup_zone_pageset(zone);
-- 
1.7.0.4

