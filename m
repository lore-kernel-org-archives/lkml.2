Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1HSKqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:46:46 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42554 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1HSKqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:46:45 -0400
X-AuditID: b753bd60-a0885ba000000655-7f-4e4e3f126be8
X-AuditID: b753bd60-a0885ba000000655-7f-4e4e3f126be8
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH v2] avoid null pointer access in vm_struct
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Fri, 19 Aug 2011 19:51:33 +0900
Message-ID: <20110819105133.7504.62129.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The /proc/vmallocinfo shows information about vmalloc allocations in vmlist
that is a linklist of vm_struct. It, however, may access pages field of
vm_struct where a page was not allocated, which results in a null pointer
access and leads to a kernel panic.

Why this happen:
In __vmalloc_area_node(), the nr_pages field of vm_struct are set to the
expected number of pages to be allocated, before the actual pages
allocations. At the same time, when the /proc/vmallocinfo is read, it
accesses the pages field of vm_struct according to the nr_pages field at
show_numa_info(). Thus, a null pointer access happens.

Patch:
This patch sets nr_pages field of vm_struct AFTER the pages allocations
finished in __vmalloc_area_node(). So, it can avoid accessing the pages
field with unallocated page when show_numa_info() is called.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---

 mm/vmalloc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7ef0903..49d8aed 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1529,7 +1529,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
 
-	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|__GFP_HIGHMEM,
@@ -1538,15 +1537,15 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
-	area->pages = pages;
-	area->caller = caller;
-	if (!area->pages) {
+	if (!pages) {
 		remove_vm_area(area->addr);
 		kfree(area);
 		return NULL;
 	}
+	area->pages = pages;
+	area->caller = caller;
 
-	for (i = 0; i < area->nr_pages; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
 		gfp_t tmp_mask = gfp_mask | __GFP_NOWARN;
 
@@ -1562,6 +1561,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		}
 		area->pages[i] = page;
 	}
+	area->nr_pages = nr_pages;
 
 	if (map_vm_area(area, prot, &pages))
 		goto fail;

