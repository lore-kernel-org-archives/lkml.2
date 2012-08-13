Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2HMUVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:21:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2HMUVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:21:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joonsoo Kim <js1304@gmail.com>, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [ 18/82] mm: fix wrong argument of migrate_huge_pages() in soft_offline_huge_page()
Date: Mon, 13 Aug 2012 13:18:54 -0700
Message-Id: <20120813201748.035417521@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonsoo Kim <js1304@gmail.com>

commit dc32f63453f56d07a1073a697dcd843dd3098c09 upstream.

Commit a6bc32b89922 ("mm: compaction: introduce sync-light migration for
use by compaction") changed the declaration of migrate_pages() and
migrate_huge_pages().

But it missed changing the argument of migrate_huge_pages() in
soft_offline_huge_page().  In this case, we should call
migrate_huge_pages() with MIGRATE_SYNC.

Additionally, there is a mismatch between type the of argument and the
function declaration for migrate_pages().

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1433,8 +1433,8 @@ static int soft_offline_huge_page(struct
 	/* Keep page count to indicate a given hugepage is isolated. */
 
 	list_add(&hpage->lru, &pagelist);
-	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
-				true);
+	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, false,
+				MIGRATE_SYNC);
 	if (ret) {
 		struct page *page1, *page2;
 		list_for_each_entry_safe(page1, page2, &pagelist, lru)
@@ -1563,7 +1563,7 @@ int soft_offline_page(struct page *page,
 					    page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
-							0, MIGRATE_SYNC);
+							false, MIGRATE_SYNC);
 		if (ret) {
 			putback_lru_pages(&pagelist);
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",


