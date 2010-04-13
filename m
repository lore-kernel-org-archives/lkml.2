Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab0DMEuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:50:44 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41829 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0DMEun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:50:43 -0400
Date: Tue, 13 Apr 2010 13:42:07 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][BUGFIX][PATCH] memcg: fix underflow of mapped_file stat
Message-Id: <20100413134207.f12cdc9c.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

When I was testing page migration, I found underflow problem of "mapped_file" field
in memory.stat. This is a fix for the problem.

This patch is based on mmotm-2010-04-05-16-09, and IIUC it conflicts with Mel's
compaction patches, so I send it as RFC for now. After next mmotm, which will
include those patches, I'll update and resend this patch.

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

page_add_file_rmap(), which can be called from remove_migration_ptes(), is
assumed to increment memcg's stat of mapped file. But on success of page
migration, the newpage(mapped file) has not been charged yet, so the stat will
not be incremented. This behavior leads to underflow of memcg's stat because
when the newpage is unmapped afterwards, page_remove_rmap() decrements the stat.
This problem doesn't happen on failure path of page migration, because the old
page(mapped file) hasn't been uncharge at the point of remove_migration_ptes().
This patch fixes this problem by calling commit_charge(mem_cgroup_end_migration)
before remove_migration_ptes().

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/migrate.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 5938db5..915c35e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -485,7 +485,8 @@ static int fallback_migrate_page(struct address_space *mapping,
  *   < 0 - error code
  *  == 0 - success
  */
-static int move_to_new_page(struct page *newpage, struct page *page)
+static int move_to_new_page(struct page *newpage, struct page *page,
+						struct mem_cgroup *mem)
 {
 	struct address_space *mapping;
 	int rc;
@@ -520,9 +521,16 @@ static int move_to_new_page(struct page *newpage, struct page *page)
 	else
 		rc = fallback_migrate_page(mapping, newpage, page);
 
-	if (!rc)
+	if (!rc) {
+		/*
+		 * On success of page migration, the newpage has not been
+		 * charged yet, so we must call end_migration() before
+		 * remove_migration_ptes() to update stats of mapped file
+		 * properly.
+		 */
+		mem_cgroup_end_migration(mem, page, newpage);
 		remove_migration_ptes(page, newpage);
-	else
+	} else
 		newpage->mapping = NULL;
 
 	unlock_page(newpage);
@@ -633,7 +641,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 
 skip_unmap:
 	if (!page_mapped(page))
-		rc = move_to_new_page(newpage, page);
+		rc = move_to_new_page(newpage, page, mem);
 
 	if (rc)
 		remove_migration_ptes(page, page);
@@ -641,7 +649,8 @@ rcu_unlock:
 	if (rcu_locked)
 		rcu_read_unlock();
 uncharge:
-	if (!charge)
+	if (rc)
+		/* On success of page migration, we've alread called it */
 		mem_cgroup_end_migration(mem, page, newpage);
 unlock:
 	unlock_page(page);
-- 
1.6.4

