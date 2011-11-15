Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab1KOXte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:49:34 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10391 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab1KOXtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:49:32 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6531"; a="135645117"
From: Laura Abbott <lauraa@codeaurora.org>
To: catalin.marinas@arm.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-msm@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>
Subject: [RFC PATCH] kmemleak: Add support for memory hotplug
Date: Tue, 15 Nov 2011 15:49:09 -0800
Message-Id: <1321400949-1852-2-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1321400949-1852-1-git-send-email-lauraa@codeaurora.org>
References: <1321400949-1852-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that memory hotplug can co-exist with kmemleak
by taking the hotplug lock before scanning the memory
banks.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 lib/Kconfig.debug |    2 +-
 mm/kmemleak.c     |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c6b006a..6a9e368 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -413,7 +413,7 @@ config SLUB_STATS
 
 config DEBUG_KMEMLEAK
 	bool "Kernel memory leak detector"
-	depends on DEBUG_KERNEL && EXPERIMENTAL && !MEMORY_HOTPLUG && \
+	depends on DEBUG_KERNEL && EXPERIMENTAL && \
 		(X86 || ARM || PPC || MIPS || S390 || SPARC64 || SUPERH || MICROBLAZE || TILE)
 
 	select DEBUG_FS
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index aacee45..4facb03 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -100,6 +100,7 @@
 
 #include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
+#include <linux/memory_hotplug.h>
 
 /*
  * Kmemleak configuration and common defines.
@@ -1220,9 +1221,9 @@ static void kmemleak_scan(void)
 #endif
 
 	/*
-	 * Struct page scanning for each node. The code below is not yet safe
-	 * with MEMORY_HOTPLUG.
+	 * Struct page scanning for each node.
 	 */
+	lock_memory_hotplug();
 	for_each_online_node(i) {
 		pg_data_t *pgdat = NODE_DATA(i);
 		unsigned long start_pfn = pgdat->node_start_pfn;
@@ -1241,6 +1242,7 @@ static void kmemleak_scan(void)
 			scan_block(page, page + 1, NULL, 1);
 		}
 	}
+	unlock_memory_hotplug();
 
 	/*
 	 * Scanning the task stacks (may introduce false negatives).
-- 
1.7.6

