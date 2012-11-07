Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2KGPBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:01:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:60560 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab2KGPAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:00:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,730,1344236400"; 
   d="scan'208";a="216333094"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v5 11/11] thp, vmstat: implement HZP_ALLOC and HZP_ALLOC_FAILED events
Date: Wed,  7 Nov 2012 17:01:03 +0200
Message-Id: <1352300463-12627-12-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

hzp_alloc is incremented every time a huge zero page is successfully
	allocated. It includes allocations which where dropped due
	race with other allocation. Note, it doesn't count every map
	of the huge zero page, only its allocation.

hzp_alloc_failed is incremented if kernel fails to allocate huge zero
	page and falls back to using small pages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 Documentation/vm/transhuge.txt |    8 ++++++++
 include/linux/vm_event_item.h  |    2 ++
 mm/huge_memory.c               |    5 ++++-
 mm/vmstat.c                    |    2 ++
 4 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/Documentation/vm/transhuge.txt b/Documentation/vm/transhuge.txt
index 677a599..ec4e84e 100644
--- a/Documentation/vm/transhuge.txt
+++ b/Documentation/vm/transhuge.txt
@@ -197,6 +197,14 @@ thp_split is incremented every time a huge page is split into base
 	pages. This can happen for a variety of reasons but a common
 	reason is that a huge page is old and is being reclaimed.
 
+hzp_alloc is incremented every time a huge zero page is successfully
+	allocated. It includes allocations which where dropped due
+	race with other allocation. Note, it doesn't count every map
+	of the huge zero page, only its allocation.
+
+hzp_alloc_failed is incremented if kernel fails to allocate huge zero
+	page and falls back to using small pages.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in /proc/vmstat to help
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 3d31145..d7156fb 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -58,6 +58,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		THP_COLLAPSE_ALLOC,
 		THP_COLLAPSE_ALLOC_FAILED,
 		THP_SPLIT,
+		HZP_ALLOC,
+		HZP_ALLOC_FAILED,
 #endif
 		NR_VM_EVENT_ITEMS
 };
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 92a1b66..492658a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -183,8 +183,11 @@ retry:
 
 	zero_page = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
-	if (!zero_page)
+	if (!zero_page) {
+		count_vm_event(HZP_ALLOC_FAILED);
 		return 0;
+	}
+	count_vm_event(HZP_ALLOC);
 	preempt_disable();
 	if (cmpxchg(&huge_zero_pfn, 0, page_to_pfn(zero_page))) {
 		preempt_enable();
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c737057..cb8901c 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -801,6 +801,8 @@ const char * const vmstat_text[] = {
 	"thp_collapse_alloc",
 	"thp_collapse_alloc_failed",
 	"thp_split",
+	"hzp_alloc",
+	"hzp_alloc_failed",
 #endif
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
-- 
1.7.7.6

