Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab1KRQn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:43:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32628 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1KRQnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:43:23 -0500
Date: Fri, 18 Nov 2011 17:43:10 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 03/11] mm: mmzone: introduce zone_pfn_same_memmap()
In-reply-to: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Message-id: <1321634598-16859-4-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit introduces zone_pfn_same_memmap() function which checkes
whether two PFNs within the same zone have struct pages within the
same memmap.  This check is needed because in general pointer
arithmetic on struct pages may lead to invalid pointers.

On memory models that are not affected, zone_pfn_same_memmap() is
defined as always returning true so the call should be optimised
at compile time.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 include/linux/mmzone.h |   16 ++++++++++++++++
 mm/compaction.c        |    5 ++++-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 188cb2f..84e07d0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1166,6 +1166,22 @@ static inline int memmap_valid_within(unsigned long pfn,
 }
 #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
 
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/*
+ * Both PFNs must be from the same zone!  If this function returns
+ * true, pfn_to_page(pfn1) + (pfn2 - pfn1) == pfn_to_page(pfn2).
+ */
+static inline bool zone_pfn_same_memmap(unsigned long pfn1, unsigned long pfn2)
+{
+	return pfn_to_section_nr(pfn1) == pfn_to_section_nr(pfn2);
+}
+
+#else
+
+#define zone_pfn_same_memmap(pfn1, pfn2) (true)
+
+#endif
+
 #endif /* !__GENERATING_BOUNDS.H */
 #endif /* !__ASSEMBLY__ */
 #endif /* _LINUX_MMZONE_H */
diff --git a/mm/compaction.c b/mm/compaction.c
index 6afae0e..09c9702 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -111,7 +111,10 @@ skip:
 
 next:
 		pfn += isolated;
-		page += isolated;
+		if (zone_pfn_same_memmap(pfn - isolated, pfn))
+			page += isolated;
+		else
+			page = pfn_to_page(pfn);
 	}
 
 	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
-- 
1.7.1.569.g6f426

