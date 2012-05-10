Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab2EJNpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:45:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab2EJNpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:45:15 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 01/17] mm: Serialize access to min_free_kbytes
Date: Thu, 10 May 2012 14:44:54 +0100
Message-Id: <1336657510-24378-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1336657510-24378-1-git-send-email-mgorman@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race between the min_free_kbytes sysctl, memory hotplug
and transparent hugepage support enablement.  Memory hotplug uses a
zonelists_mutex to avoid a race when building zonelists. Reuse it to
serialise watermark updates.

[a.p.zijlstra@chello.nl: Older patch fixed the race with spinlock]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a712fb9..280eabe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4976,14 +4976,7 @@ static void setup_per_zone_lowmem_reserve(void)
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
@@ -5038,6 +5031,20 @@ void setup_per_zone_wmarks(void)
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
1.7.9.2

