Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2LNLB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:01:27 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:37776 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2LNLBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:01:25 -0500
Subject: [PATCH] mm/swap: add independed bio pool for swap
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Date: Fri, 14 Dec 2012 15:01:18 +0400
Message-ID: <20121214110118.8387.66431.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bio pool guarantees reclaiming progress for anonymous pages.
All avaliable bio in fs_bio_set may be borrowed by writeback which may
never ends, because disk too slow or broken. I have seen this situation in
real life in system where was a lot of bio requests to a loop device which
laying on top of special fuse-based filesystem.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
---
 mm/page_io.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 78eee32..699f85e 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -22,12 +22,14 @@
 #include <linux/frontswap.h>
 #include <asm/pgtable.h>
 
+static struct bio_set *swap_bio_set;
+
 static struct bio *get_swap_bio(gfp_t gfp_flags,
 				struct page *page, bio_end_io_t end_io)
 {
 	struct bio *bio;
 
-	bio = bio_alloc(gfp_flags, 1);
+	bio = bio_alloc_bioset(gfp_flags, 1, swap_bio_set);
 	if (bio) {
 		bio->bi_sector = map_swap_page(page, &bio->bi_bdev);
 		bio->bi_sector <<= PAGE_SHIFT - 9;
@@ -290,3 +292,12 @@ int swap_set_page_dirty(struct page *page)
 		return __set_page_dirty_no_writeback(page);
 	}
 }
+
+static int __init swap_bio_init(void)
+{
+	swap_bio_set = bioset_create(SWAP_CLUSTER_MAX, 0);
+	if (!swap_bio_set)
+		panic("can't allocate swap_bio_set\n");
+	return 0;
+}
+late_initcall(swap_bio_init);

