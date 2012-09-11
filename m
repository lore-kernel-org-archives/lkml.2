Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab2IKVbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 17:31:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2IKVbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 17:31:38 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] btrfs: Kill some bi_idx references
Date: Tue, 11 Sep 2012 14:31:14 -0700
Message-Id: <1347399074-23546-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For immutable bio vecs, I've been auditing and removing bi_idx
references. These were harmless, but removing them will make auditing
easier.

scrub_bio_end_io_worker() was open coding a bio_reset() - but this
doesn't appear to have been needed for anything as right after it does a
bio_put(), and perusing the code it doesn't appear anything else was
holding a reference to the bio.

The other use end_bio_extent_readpage() was just for a pr_debug() -
changed it to something that might be a bit more useful.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Chris Mason <chris.mason@fusionio.com>
CC: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/extent_io.c |  4 ++--
 fs/btrfs/scrub.c     | 15 ---------------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4c87847..8d7fb96 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2298,8 +2298,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		struct extent_state *cached = NULL;
 		struct extent_state *state;
 
-		pr_debug("end_bio_extent_readpage: bi_vcnt=%d, idx=%d, err=%d, "
-			 "mirror=%ld\n", bio->bi_vcnt, bio->bi_idx, err,
+		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
+			 "mirror=%ld\n", (u64)bio->bi_sector, err,
 			 (long int)bio->bi_bdev);
 		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b223620..2683ea7 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1666,21 +1666,6 @@ static void scrub_bio_end_io_worker(struct btrfs_work *work)
 		scrub_block_put(sblock);
 	}
 
-	if (sbio->err) {
-		/* what is this good for??? */
-		sbio->bio->bi_flags &= ~(BIO_POOL_MASK - 1);
-		sbio->bio->bi_flags |= 1 << BIO_UPTODATE;
-		sbio->bio->bi_phys_segments = 0;
-		sbio->bio->bi_idx = 0;
-
-		for (i = 0; i < sbio->page_count; i++) {
-			struct bio_vec *bi;
-			bi = &sbio->bio->bi_io_vec[i];
-			bi->bv_offset = 0;
-			bi->bv_len = PAGE_SIZE;
-		}
-	}
-
 	bio_put(sbio->bio);
 	sbio->bio = NULL;
 	spin_lock(&sdev->list_lock);
-- 
1.7.12

