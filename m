Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1JKLyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 07:54:05 -0400
Received: from smtp.citrix.com ([66.165.176.89]:8424 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab1JKLyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 07:54:03 -0400
X-IronPort-AV: E=Sophos;i="4.68,523,1312171200"; 
   d="scan'208";a="18114349"
From: David Vrabel <david.vrabel@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Jens Axboe <axboe@kernel.dk>, David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH] block: initialize the bounce pool if high memory may be added later
Date: Tue, 11 Oct 2011 12:53:38 +0100
Message-ID: <1318334018-3312-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_emergency_pool() does not create the page pool for bouncing block
requests if the current count of high pages is zero.  If high memory
may be added later (either via memory hotplug or a balloon driver in a
virtualized system) then a oops occurs if a request with a high page
need bouncing because the pool does not exist.

So, always create the pool if memory hotplug is enabled and change the
test so it's valid even if all high pages are currently in the balloon
(the balloon drivers adjust totalhigh_pages but not max_pfn).

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 mm/bounce.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/bounce.c b/mm/bounce.c
index 1481de6..434fb4f 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/highmem.h>
+#include <linux/bootmem.h>
 #include <asm/tlbflush.h>
 
 #include <trace/events/block.h>
@@ -26,12 +27,10 @@ static mempool_t *page_pool, *isa_page_pool;
 #ifdef CONFIG_HIGHMEM
 static __init int init_emergency_pool(void)
 {
-	struct sysinfo i;
-	si_meminfo(&i);
-	si_swapinfo(&i);
-
-	if (!i.totalhigh)
+#ifndef CONFIG_MEMORY_HOTPLUG
+	if (max_pfn <= max_low_pfn)
 		return 0;
+#endif
 
 	page_pool = mempool_create_page_pool(POOL_SIZE, 0);
 	BUG_ON(!page_pool);
-- 
1.7.2.5

