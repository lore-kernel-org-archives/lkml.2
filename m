Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2JOUOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:14:35 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42248 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2JOUKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:47 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de
Subject: [PATCH v2 14/26] raid1: Refactor narrow_write_error() to not use bi_idx
Date: Mon, 15 Oct 2012 13:09:17 -0700
Message-Id: <1350331769-14856-44-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More bi_idx removal. This code was just open coding bio_clone(). This
could probably be further improved by using bio_advance() instead of
skipping over null pages, but that'd be a larger rework.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index bd3e3b9..b1072da 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2052,8 +2052,6 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
 	struct md_rdev *rdev = conf->mirrors[i].rdev;
-	int vcnt, idx;
-	struct bio_vec *vec;
 
 	/* bio has the data to be written to device 'i' where
 	 * we just recently had a write error.
@@ -2081,30 +2079,32 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		   & ~(sector_t)(block_sectors - 1))
 		- sector;
 
-	if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
-		vcnt = r1_bio->behind_page_count;
-		vec = r1_bio->behind_bvecs;
-		idx = 0;
-		while (vec[idx].bv_page == NULL)
-			idx++;
-	} else {
-		vcnt = r1_bio->master_bio->bi_vcnt;
-		vec = r1_bio->master_bio->bi_io_vec;
-		idx = r1_bio->master_bio->bi_idx;
-	}
 	while (sect_to_write) {
 		struct bio *wbio;
 		if (sectors > sect_to_write)
 			sectors = sect_to_write;
 		/* Write at 'sector' for 'sectors'*/
 
-		wbio = bio_alloc_mddev(GFP_NOIO, vcnt, mddev);
-		memcpy(wbio->bi_io_vec, vec, vcnt * sizeof(struct bio_vec));
-		wbio->bi_sector = r1_bio->sector;
+		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
+			unsigned vcnt = r1_bio->behind_page_count;
+			struct bio_vec *vec = r1_bio->behind_bvecs;
+
+			while (!vec->bv_page) {
+				vec++;
+				vcnt--;
+			}
+
+			wbio = bio_alloc_mddev(GFP_NOIO, vcnt, mddev);
+			memcpy(wbio->bi_io_vec, vec, vcnt * sizeof(struct bio_vec));
+
+			wbio->bi_vcnt = vcnt;
+		} else {
+			wbio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
+		}
+
 		wbio->bi_rw = WRITE;
-		wbio->bi_vcnt = vcnt;
+		wbio->bi_sector = r1_bio->sector;
 		wbio->bi_size = r1_bio->sectors << 9;
-		wbio->bi_idx = idx;
 
 		md_trim_bio(wbio, sector - r1_bio->sector, sectors);
 		wbio->bi_sector += rdev->data_offset;
-- 
1.7.12

