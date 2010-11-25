Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab0KYAfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 19:35:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab0KYAfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 19:35:10 -0500
Date: Wed, 24 Nov 2010 19:35:01 -0500
From: Dean Nelson <dnelson@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20101125003501.4884.70261.send-patch@localhost6.localdomain6>
Subject: [PATCH] Conditionally call unlock_page() in hugetlb_fault()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have hugetlb_fault() call unlock_page(page) only if it had previously called
lock_page(page).

Signed-off-by: Dean Nelson <dnelson@redhat.com>
CC: stable@kernel.org

---

Setting CONFIG_DEBUG_VM=y and then running the libhugetlbfs test suite,
resulted in the tripping of VM_BUG_ON(!PageLocked(page)) in unlock_page()
having been called by hugetlb_fault() when page == pagecache_page.
This patch remedied the problem.

 mm/hugetlb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c4a3558..8585524 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2738,7 +2738,8 @@ out_page_table_lock:
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
 	}
-	unlock_page(page);
+	if (page != pagecache_page)
+		unlock_page(page);
 
 out_mutex:
 	mutex_unlock(&hugetlb_instantiation_mutex);
