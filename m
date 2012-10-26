Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871Ab2JZPXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:23:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:20986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933738Ab2JZPXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:23:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="scan'208";a="240586314"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Cc: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] thp, vmstat: implement HZP_ALLOC and HZP_ALLOC_FAILED events
Date: Fri, 26 Oct 2012 18:14:02 +0300
Message-Id: <1351264442-4730-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350280859-18801-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1350280859-18801-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

HZP_ALLOC event triggers on every huge zero page allocation, including
allocations which where dropped due race with other allocation.

HZP_ALLOC_FAILED event triggers on huge zero page allocation fail
(ENOMEM).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/vm_event_item.h |    2 ++
 mm/huge_memory.c              |    5 ++++-
 mm/vmstat.c                   |    2 ++
 3 files changed, 8 insertions(+), 1 deletions(-)

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

