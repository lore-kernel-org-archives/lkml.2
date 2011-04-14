Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab1DNKlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:41:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932807Ab1DNKll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:41:41 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 01/12] mm: Serialize access to min_free_kbytes
Date: Thu, 14 Apr 2011 11:41:27 +0100
Message-Id: <1302777698-28237-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1302777698-28237-1-git-send-email-mgorman@suse.de>
References: <1302777698-28237-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race between the min_free_kbytes sysctl, memory hotplug
and transparent hugepage support enablement.  Memory hotplug uses a
zonelists_mutex to avoid a race when building zonelists. Reuse it to
serialise watermark updates.

[a.p.zijlstra@chello.nl: Older patch fixed the race with spinlock]
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cdef1d4..93afea3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4928,14 +4928,7 @@ static void setup_per_zone_lowmem_reserve(void)
 	calculate_totalreserve_pages();
 }
 
-/**
- * setup_per_zone_wmarks - called when min_free_kbytes changes
- * or when memory is hot-{added|removed}
- *
- * Ensures that the watermark[min,low,high] values for each zone are set
- * correctly with respect to min_free_kbytes.
- */
-void setup_per_zone_wmarks(void)
+static void __setup_per_zone_wmarks(void)
 {
 	unsigned long pages_min = min_free_kbytes >> (PAGE_SHIFT - 10);
 	unsigned long lowmem_pages = 0;
@@ -4990,6 +4983,20 @@ void setup_per_zone_wmarks(void)
 	calculate_totalreserve_pages();
 }
 
+/**
+ * setup_per_zone_wmarks - called when min_free_kbytes changes
+ * or when memory is hot-{added|removed}
+ *
+ * Ensures that the watermark[min,low,high] values for each zone are set
+ * correctly with respect to min_free_kbytes.
+ */
+void setup_per_zone_wmarks(void)
+{
+	mutex_lock(&zonelists_mutex);
+	__setup_per_zone_wmarks();
+	mutex_unlock(&zonelists_mutex);
+}
+
 /*
  * The inactive anon list should be small enough that the VM never has to
  * do too much work, but large enough that each inactive page has a chance
-- 
1.7.3.4

