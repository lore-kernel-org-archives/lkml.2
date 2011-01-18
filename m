Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1ARDAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 22:00:32 -0500
Received: from amavis-outgoing2.knology.net ([24.214.64.231]:59273 "EHLO
	amavis-outgoing2.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444Ab1ARDAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 22:00:31 -0500
Subject: [PATCH v3]  fs/direct-io.c: don't try to allocate more than
 BIO_MAX_PAGES in a bio
From: David Dillow <dillowda@ornl.gov>
To: Jeff Moyer <jmoyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <x49y66jmljv.fsf@segfault.boston.devel.redhat.com>
References: <1294977946.21790.20.camel@obelisk.thedillows.org>
	 <x498vynbl4e.fsf@segfault.boston.devel.redhat.com>
	 <1295023584.24487.16.camel@lap75545.ornl.gov>
	 <x49y66jmljv.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 22:00:27 -0500
Message-ID: <1295319627.3051.89.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
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
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: stable@kernel.org
--
Also added cc to stable, as this has been a longstanding item.

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 85882f6..0df6597 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -325,13 +325,18 @@ void dio_end_io(struct bio *bio, int error)
 }
 EXPORT_SYMBOL_GPL(dio_end_io);
 
-static int
+static void
 dio_bio_alloc(struct dio *dio, struct block_device *bdev,
 		sector_t first_sector, int nr_vecs)
 {
 	struct bio *bio;
 
+	/*
+	 * bio_alloc() is guaranteed to return a bio when called with
+	 * __GFP_WAIT and we request a valid number of vectors.
+	 */
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
+	BUG_ON(!bio);
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
@@ -342,7 +347,6 @@ dio_bio_alloc(struct dio *dio, struct block_device *bdev,
 
 	dio->bio = bio;
 	dio->logical_offset_in_bio = dio->cur_page_fs_offset;
-	return 0;
 }
 
 /*
@@ -583,8 +587,9 @@ static int dio_new_bio(struct dio *dio, sector_t start_sector)
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


