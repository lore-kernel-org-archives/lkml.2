Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab1KVLJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:09:59 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61102 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381Ab1KVLJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:09:54 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH v4 5/5] mm: Only IPI CPUs to drain local pages if they exist
Date: Tue, 22 Nov 2011 13:08:48 +0200
Message-Id: <1321960128-15191-6-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321960128-15191-1-git-send-email-gilad@benyossef.com>
References: <1321960128-15191-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculate a cpumask of CPUs with per-cpu pages in any zone and only send an IPI requesting CPUs to drain these pages to the buddy allocator if they actually have pages when asked to flush.

The code path of memory allocation failure for CPUMASK_OFFSTACK=y config was tested using fault injection framework.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Christoph Lameter <cl@linux.com>
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
---
 mm/page_alloc.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9dd443d..a3efdf1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1119,7 +1119,23 @@ void drain_local_pages(void *arg)
  */
 void drain_all_pages(void)
 {
-	on_each_cpu(drain_local_pages, NULL, 1);
+	int cpu;
+	struct zone *zone;
+	cpumask_var_t cpus;
+	struct per_cpu_pageset *pcp;
+
+	if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
+		for_each_online_cpu(cpu) {
+			for_each_populated_zone(zone) {
+				pcp = per_cpu_ptr(zone->pageset, cpu);
+				if (pcp->pcp.count)
+					cpumask_set_cpu(cpu, cpus);
+		}
+	}
+		on_each_cpu_mask(cpus, drain_local_pages, NULL, 1);
+		free_cpumask_var(cpus);
+	} else
+		on_each_cpu(drain_local_pages, NULL, 1);
 }
 
 #ifdef CONFIG_HIBERNATION
-- 
1.7.0.4

