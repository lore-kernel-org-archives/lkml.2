Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab1ANRAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:00:25 -0500
Received: from emroute3.ornl.gov ([160.91.4.110]:58892 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757553Ab1ANRAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:00:13 -0500
X-Greylist: delayed 833 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 12:00:12 EST
Date: Fri, 14 Jan 2011 11:46:24 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: [PATCH v2 alt 2]  fs/direct-io.c: don't try to allocate more than
 BIO_MAX_PAGES in a bio
In-reply-to: <x498vynbl4e.fsf@segfault.boston.devel.redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Message-id: <1295023584.24487.16.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
References: <1294977946.21790.20.camel@obelisk.thedillows.org>
 <x498vynbl4e.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using devices that support max_segments > BIO_MAX_PAGES (256),
direct IO tries to allocate a bio with more pages than allowed, which
leads to an oops in dio_bio_alloc(). Clamp the request to the supported
maximum, and change dio_bio_alloc() to reflect that bio_alloc() will
always return a bio when called with __GFP_WAIT and a valid number of
vectors.
    
Signed-off-by: David Dillow <dillowda@ornl.gov>
--
Second alternate, my preferred that reflects that bio_alloc() cannot
fail when properly called. I can take or leave the comment.


diff --git a/fs/direct-io.c b/fs/direct-io.c
index 85882f6..96a01d8 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -325,13 +325,17 @@ void dio_end_io(struct bio *bio, int error)
 }
 EXPORT_SYMBOL_GPL(dio_end_io);
 
-static int
+static void
 dio_bio_alloc(struct dio *dio, struct block_device *bdev,
 		sector_t first_sector, int nr_vecs)
 {
 	struct bio *bio;
 
+	/* bio_alloc() is guaranteed to return a bio when called with
+	 * __GFP_WAIT and we request a valid number of vectors.
+	 */
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
+	BUG_ON(!bio);
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
@@ -342,7 +346,6 @@ dio_bio_alloc(struct dio *dio, struct block_device *bdev,
 
 	dio->bio = bio;
 	dio->logical_offset_in_bio = dio->cur_page_fs_offset;
-	return 0;
 }
 
 /*
@@ -583,8 +586,9 @@ static int dio_new_bio(struct dio *dio, sector_t start_sector)
 		goto out;
 	sector = start_sector << (dio->blkbits - 9);
 	nr_pages = min(dio->pages_in_io, bio_get_nr_vecs(dio->map_bh.b_bdev));
+	nr_pages = min(nr_pages, BIO_MAX_PAGES);
 	BUG_ON(nr_pages <= 0);
-	ret = dio_bio_alloc(dio, dio->map_bh.b_bdev, sector, nr_pages);
+	dio_bio_alloc(dio, dio->map_bh.b_bdev, sector, nr_pages);
 	dio->boundary = 0;
 out:
 	return ret;


