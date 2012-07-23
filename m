Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2GWNiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:38:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab2GWNit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:38:49 -0400
From: Mel Gorman <mgorman@suse.de>
To: Stable <stable@vger.kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 01/34] mm: vmstat: cache align vm_stat
Date: Mon, 23 Jul 2012 14:38:14 +0100
Message-Id: <1343050727-3045-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1343050727-3045-1-git-send-email-mgorman@suse.de>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dimitri Sivanich <sivanich@sgi.com>

commit a1cb2c60ddc98ff4e5246f410558805401ceee67 upstream.

Stable note: Not tracked on Bugzilla. This patch is known to make a big
	difference to tmpfs performance on larger machines.

Avoid false sharing of the vm_stat array. This was found to adversely
affect tmpfs I/O performance.

Tests run on a 640 cpu UV system.

With 120 threads doing parallel writes, each to different tmpfs mounts:
No patch:		~300 MB/sec
With vm_stat alignment:	~430 MB/sec

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 20c18b7..6559013 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -78,7 +78,7 @@ void vm_events_fold_cpu(int cpu)
  *
  * vm_stat contains the global counters
  */
-atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS];
+atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS] __cacheline_aligned_in_smp;
 EXPORT_SYMBOL(vm_stat);
 
 #ifdef CONFIG_SMP
-- 
1.7.9.2

