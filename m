Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab2HMLPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:15:49 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47391 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2HMLPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:15:48 -0400
Message-ID: <5028E1DB.10702@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2012 19:15:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 07/12] thp: merge page pre-alloc in khugepaged_loop into khugepaged_do_scan
References: <5028E12C.70101@linux.vnet.ibm.com>
In-Reply-To: <5028E12C.70101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081311-1396-0000-0000-000001B44920
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two pre-alloc operations in these two function, the different is:
- it allows to sleep if page alloc fail in khugepaged_loop
- it exits immediately if page alloc fail in khugepaged_do_scan

Actually, in khugepaged_do_scan, we can allow the pre-alloc to sleep on the
first failure, then the operation in khugepaged_loop can be removed

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |   97 +++++++++++++++++++++++++-----------------------------
 1 files changed, 45 insertions(+), 52 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5f620cf..42d3d74 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2237,10 +2237,40 @@ static int khugepaged_wait_event(void)
 		kthread_should_stop();
 }

-static void khugepaged_do_scan(struct page **hpage)
+static void khugepaged_alloc_sleep(void)
+{
+	wait_event_freezable_timeout(khugepaged_wait, false,
+			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
+}
+
+#ifndef CONFIG_NUMA
+static struct page *khugepaged_alloc_hugepage(bool *wait)
+{
+	struct page *hpage;
+
+	do {
+		hpage = alloc_hugepage(khugepaged_defrag());
+		if (!hpage) {
+			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+			if (!*wait)
+				return NULL;
+
+			*wait = false;
+			khugepaged_alloc_sleep();
+		} else
+			count_vm_event(THP_COLLAPSE_ALLOC);
+	} while (unlikely(!hpage) && likely(khugepaged_enabled()));
+
+	return hpage;
+}
+#endif
+
+static void khugepaged_do_scan(void)
 {
+	struct page *hpage = NULL;
 	unsigned int progress = 0, pass_through_head = 0;
 	unsigned int pages = khugepaged_pages_to_scan;
+	bool wait = true;

 	barrier(); /* write khugepaged_pages_to_scan to local stack */

@@ -2248,17 +2278,18 @@ static void khugepaged_do_scan(struct page **hpage)
 		cond_resched();

 #ifndef CONFIG_NUMA
-		if (!*hpage) {
-			*hpage = alloc_hugepage(khugepaged_defrag());
-			if (unlikely(!*hpage)) {
-				count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+		if (!hpage)
+			hpage = khugepaged_alloc_hugepage(&wait);
+
+		if (unlikely(!hpage))
+			break;
+#else
+		if (IS_ERR(hpage)) {
+			if (!wait)
 				break;
-			}
-			count_vm_event(THP_COLLAPSE_ALLOC);
+			wait = false;
+			khugepaged_alloc_sleep();
 		}
-#else
-		if (IS_ERR(*hpage))
-			break;
 #endif

 		if (unlikely(kthread_should_stop() || freezing(current)))
@@ -2270,37 +2301,16 @@ static void khugepaged_do_scan(struct page **hpage)
 		if (khugepaged_has_work() &&
 		    pass_through_head < 2)
 			progress += khugepaged_scan_mm_slot(pages - progress,
-							    hpage);
+							    &hpage);
 		else
 			progress = pages;
 		spin_unlock(&khugepaged_mm_lock);
 	}
-}

-static void khugepaged_alloc_sleep(void)
-{
-	wait_event_freezable_timeout(khugepaged_wait, false,
-			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
+	if (!IS_ERR_OR_NULL(hpage))
+		put_page(hpage);
 }

-#ifndef CONFIG_NUMA
-static struct page *khugepaged_alloc_hugepage(void)
-{
-	struct page *hpage;
-
-	do {
-		hpage = alloc_hugepage(khugepaged_defrag());
-		if (!hpage) {
-			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
-			khugepaged_alloc_sleep();
-		} else
-			count_vm_event(THP_COLLAPSE_ALLOC);
-	} while (unlikely(!hpage) &&
-		 likely(khugepaged_enabled()));
-	return hpage;
-}
-#endif
-
 static void khugepaged_wait_work(void)
 {
 	try_to_freeze();
@@ -2321,25 +2331,8 @@ static void khugepaged_wait_work(void)

 static void khugepaged_loop(void)
 {
-	struct page *hpage = NULL;
-
 	while (likely(khugepaged_enabled())) {
-#ifndef CONFIG_NUMA
-		hpage = khugepaged_alloc_hugepage();
-		if (unlikely(!hpage))
-			break;
-#else
-		if (IS_ERR(hpage)) {
-			khugepaged_alloc_sleep();
-			hpage = NULL;
-		}
-#endif
-
-		khugepaged_do_scan(&hpage);
-
-		if (!IS_ERR_OR_NULL(hpage))
-			put_page(hpage);
-
+		khugepaged_do_scan();
 		khugepaged_wait_work();
 	}
 }
-- 
1.7.7.6

