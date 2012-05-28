Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2E1PVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:21:40 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46644 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2E1PVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:21:39 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        akpm@linux-foundation.org, rientjes@google.com
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] mm/hugetlb: Use compound page head in migrate_huge_page
Date: Mon, 28 May 2012 20:51:30 +0530
Message-Id: <1338218490-30978-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
x-cbid: 12052815-4790-0000-0000-000002FA10A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

The change was introduced by "hugetlb: simplify migrate_huge_page() "

We should use compound page head instead of tail pages in
migrate_huge_page().

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

This is an important bug fix. If we want we can fold it with the not
yet merged upstream patch mentioned above in linux-next. The stack
trace for the crash is

[   75.337421] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
[   75.338386] IP: [<ffffffff816b3f0f>] __mutex_lock_common+0xa1/0x350
[   75.338386] PGD 1d700067 PUD 1d7dd067 PMD 0
[   75.338386] Oops: 0002 [#1] SMP
[   75.338386] CPU 1
[   75.338386] Modules linked in:
...
...

[   75.338386] Call Trace:
[   75.338386]  [<ffffffff810ffc04>] ? try_to_unmap_file+0x38/0x51c
[   75.338386]  [<ffffffff810ffc04>] ? try_to_unmap_file+0x38/0x51c
[   75.338386]  [<ffffffff813b5f8b>] ? vsnprintf+0x83/0x421
[   75.338386]  [<ffffffff816b427d>] mutex_lock_nested+0x2a/0x31
[   75.338386]  [<ffffffff8110999b>] ? alloc_huge_page_node+0x1d/0x55
[   75.338386]  [<ffffffff810ffc04>] try_to_unmap_file+0x38/0x51c
[   75.338386]  [<ffffffff8110999b>] ? alloc_huge_page_node+0x1d/0x55
[   75.338386]  [<ffffffff810a06b9>] ? arch_local_irq_save+0x9/0xc
[   75.338386]  [<ffffffff816b5e3b>] ? _raw_spin_unlock+0x23/0x27
[   75.338386]  [<ffffffff81100839>] try_to_unmap+0x25/0x3c
[   75.338386]  [<ffffffff810641c2>] ? console_unlock+0x210/0x238
[   75.338386]  [<ffffffff811141e3>] migrate_huge_page+0x8d/0x178


diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 4a45098..53a1495 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1428,8 +1428,8 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	}
 
 	/* Keep page count to indicate a given hugepage is isolated. */
-	ret = migrate_huge_page(page, new_page, MPOL_MF_MOVE_ALL, 0, true);
-	put_page(page);
+	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL, 0, true);
+	put_page(hpage);
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 			pfn, ret, page->flags);
-- 
1.7.10

