Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3AGRIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:08:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab3AGRIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:08:19 -0500
Date: Mon, 7 Jan 2013 17:08:15 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] mm: migrate: Check page_count of THP before migrating
Message-ID: <20130107170815.GO3885@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins pointed out that migrate_misplaced_transhuge_page() does not
check page_count before migrating like base page migration and khugepage. He
could not see why this was safe and he is right.

The potential impact of the bug is avoided due to the limitations of NUMA
balancing.  The page_mapcount() check ensures that only a single address
space is using this page and as THPs are typically private it should not be
possible for another address space to fault it in parallel. If the address
space has one associated task then it's difficult to have both a GUP pin
and be referencing the page at the same time. If there are multiple tasks
then a buggy scenario requires that another thread be accessing the page
while the direct IO is in flight. This is dodgy behaviour as there is
a possibility of corruption with or without THP migration. It would be
difficult to identify the corruption as being a migration bug.

While we happen to be safe for the most part it is shoddy to depend on
such "safety" so this patch checks the page count similar to anonymous
pages. Note that this does not mean that the page_mapcount() check can go
away. If we were to remove the page_mapcount() check the the THP would
have to be unmapped from all referencing PTEs, replaced with migration
PTEs and restored properly afterwards.

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/migrate.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 3b676b0..f466827 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1679,9 +1679,18 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	page_xchg_last_nid(new_page, page_last_nid(page));
 
 	isolated = numamigrate_isolate_page(pgdat, page);
-	if (!isolated) {
+
+	/*
+	 * Failing to isolate or a GUP pin prevents migration. The expected
+	 * page count is 2. 1 for anonymous pages without a mapping and 1
+	 * for the callers pin. If the page was isolated, the page will
+	 * need to be put back on the LRU.
+	 */
+	if (!isolated || page_count(page) != 2) {
 		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 		put_page(new_page);
+		if (isolated)
+			putback_lru_page(page);
 		goto out_keep_locked;
 	}
 
