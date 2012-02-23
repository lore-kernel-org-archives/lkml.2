Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab2BWNv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:51:57 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39147 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2BWNvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:51:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.155.77 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v3 03/21] memcg: fix page_referencies cgroup filter on global
 reclaim
To: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Date: Thu, 23 Feb 2012 17:51:51 +0400
Message-ID: <20120223135151.12988.37646.stgit@zurg>
In-Reply-To: <20120223133728.12988.5432.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Global memory reclaimer shouldn't skip any page referencies.

This patch pass sc->target_mem_cgroup into page_referenced().
On global memory reclaim it always NULL, so we will account all.
Cgroup reclaimer will account only referencies from target cgroup and its childs.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 39aa4d7..d133ac6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -701,13 +701,13 @@ enum page_references {
 };
 
 static enum page_references page_check_references(struct page *page,
-						  struct mem_cgroup_zone *mz,
 						  struct scan_control *sc)
 {
 	int referenced_ptes, referenced_page;
 	unsigned long vm_flags;
 
-	referenced_ptes = page_referenced(page, 1, mz->mem_cgroup, &vm_flags);
+	referenced_ptes = page_referenced(page, 1,
+					  sc->target_mem_cgroup, &vm_flags);
 	referenced_page = TestClearPageReferenced(page);
 
 	/* Lumpy reclaim - ignore references */
@@ -828,7 +828,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 			}
 		}
 
-		references = page_check_references(page, mz, sc);
+		references = page_check_references(page, sc);
 		switch (references) {
 		case PAGEREF_ACTIVATE:
 			goto activate_locked;
@@ -1735,7 +1735,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 			continue;
 		}
 
-		if (page_referenced(page, 0, mz->mem_cgroup, &vm_flags)) {
+		if (page_referenced(page, 0,
+				    sc->target_mem_cgroup, &vm_flags)) {
 			nr_rotated += hpage_nr_pages(page);
 			/*
 			 * Identify referenced, file-backed active pages and

