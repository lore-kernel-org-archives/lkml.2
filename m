Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2BQTei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:34:38 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16691 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2BQTeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:34:36 -0500
Date: Fri, 17 Feb 2012 20:30:30 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv22 10/16] mm: Serialize access to min_free_kbytes
In-reply-to: <1329507036-24362-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>
Message-id: <1329507036-24362-11-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329507036-24362-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>

There is a race between the min_free_kbytes sysctl, memory hotplug
and transparent hugepage support enablement.  Memory hotplug uses a
zonelists_mutex to avoid a race when building zonelists. Reuse it to
serialise watermark updates.

[a.p.zijlstra@chello.nl: Older patch fixed the race with spinlock]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page_alloc.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5d23933..444e3fd 100644
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
1.7.1


