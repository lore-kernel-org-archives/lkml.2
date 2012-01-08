Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2AHQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:28:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35281 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2AHQ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:28:20 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>
Subject: [PATCH v6 8/8] mm: add vmstat counters for tracking PCP drains
Date: Sun,  8 Jan 2012 18:27:06 +0200
Message-Id: <1326040026-7285-9-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces two new vmstat counters for testing purposes:
pcp_global_drain that counts the number of times a per-cpu pages
global drain was requested and pcp_global_ipi_saved that counts
the number of times the number of CPUs with per-cpu pages in any
zone were less then 1/2 of the number of online CPUs.

The patch purpose is to show the usefulness of only sending an IPI
asking to drain per-cpu pages to CPUs that actually have them
instead of a blind global IPI. It is probably not useful by itself.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Christoph Lameter <cl@linux.com>
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-mm@kvack.org
CC: Pekka Enberg <penberg@kernel.org>
CC: Matt Mackall <mpm@selenic.com>
CC: Sasha Levin <levinsasha928@gmail.com>
CC: Rik van Riel <riel@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: Avi Kivity <avi@redhat.com>
CC: Michal Nazarewicz <mina86@mina86.org>
CC: Kosaki Motohiro <kosaki.motohiro@gmail.com>
---
 include/linux/vm_event_item.h |    1 +
 mm/page_alloc.c               |    5 +++++
 mm/vmstat.c                   |    2 ++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03b90cd..3657f6f 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -58,6 +58,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		THP_COLLAPSE_ALLOC_FAILED,
 		THP_SPLIT,
 #endif
+		PCP_GLOBAL_DRAIN, PCP_GLOBAL_IPI_SAVED,
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dc97199..8677e3e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1118,6 +1118,11 @@ void drain_all_pages(void)
 				cpumask_clear_cpu(cpu, cpus_with_pcps);
 		}
 	on_each_cpu_mask(cpus_with_pcps, drain_local_pages, NULL, 1);
+
+	count_vm_event(PCP_GLOBAL_DRAIN);
+	if (cpumask_weight(cpus_with_pcps) <
+	   (cpumask_weight(cpu_online_mask) / 2))
+		count_vm_event(PCP_GLOBAL_IPI_SAVED);
 }
 
 #ifdef CONFIG_HIBERNATION
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8fd603b..daf632c 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -786,6 +786,8 @@ const char * const vmstat_text[] = {
 	"thp_collapse_alloc_failed",
 	"thp_split",
 #endif
+	"pcp_global_drain",
+	"pcp_global_ipi_saved"
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
-- 
1.7.0.4

