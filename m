Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab2LHFyG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 00:54:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2LHFyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 00:54:04 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/5] f2fs: rewrite f2fs_bio_alloc to make it simpler
Date: Sat,  8 Dec 2012 14:53:40 +0900
Message-Id: <1354946021-7550-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Since, GFP_NOFS(__GFP_WAIT) is used for allocation requests of bio in f2fs.
So, there is no chance of returning NULL from the BIO allocation.

Making the bio allocation routine for f2fs simpler.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/segment.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 969df1a..8894b39 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -647,28 +647,18 @@ struct bio *f2fs_bio_alloc(struct block_device *bdev, sector_t first_sector,
 					int nr_vecs, gfp_t gfp_flags)
 {
 	struct bio *bio;
-repeat:
+
 	/* allocate new bio */
 	bio = bio_alloc(gfp_flags, nr_vecs);
 
-	if (bio == NULL && (current->flags & PF_MEMALLOC)) {
-		while (!bio && (nr_vecs /= 2))
-			bio = bio_alloc(gfp_flags, nr_vecs);
-	}
-	if (bio) {
-		bio->bi_bdev = bdev;
-		bio->bi_sector = first_sector;
+	bio->bi_bdev = bdev;
+	bio->bi_sector = first_sector;
 retry:
-		bio->bi_private = kmalloc(sizeof(struct bio_private),
-						GFP_NOFS | __GFP_HIGH);
-		if (!bio->bi_private) {
-			cond_resched();
-			goto retry;
-		}
-	}
-	if (bio == NULL) {
+	bio->bi_private = kmalloc(sizeof(struct bio_private),
+					GFP_NOFS | __GFP_HIGH);
+	if (!bio->bi_private) {
 		cond_resched();
-		goto repeat;
+		goto retry;
 	}
 	return bio;
 }
-- 
1.7.9.5

