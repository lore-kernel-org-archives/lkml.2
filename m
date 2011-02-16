Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab1BPA7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:59:47 -0500
Received: from kroah.org ([198.145.64.141]:46086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab1BPAvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:12 2011
Message-Id: <20110216002112.759367994@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Dillow <dillowda@ornl.gov>
Subject: [patch 137/176] fs/direct-io.c: dont try to allocate more than BIO_MAX_PAGES in a bio
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Dillow <dillowda@ornl.gov>

commit 20d9600cb407b0b55fef6ee814b60345c6f58264 upstream.

When using devices that support max_segments > BIO_MAX_PAGES (256), direct
IO tries to allocate a bio with more pages than allowed, which leads to an
oops in dio_bio_alloc().  Clamp the request to the supported maximum, and
change dio_bio_alloc() to reflect that bio_alloc() will always return a
bio when called with __GFP_WAIT and a valid number of vectors.

[akpm@linux-foundation.org: remove redundant BUG_ON()]
Signed-off-by: David Dillow <dillowda@ornl.gov>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/direct-io.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -325,12 +325,16 @@ void dio_end_io(struct bio *bio, int err
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
 
 	bio->bi_bdev = bdev;
@@ -342,7 +346,6 @@ dio_bio_alloc(struct dio *dio, struct bl
 
 	dio->bio = bio;
 	dio->logical_offset_in_bio = dio->cur_page_fs_offset;
-	return 0;
 }
 
 /*
@@ -583,8 +586,9 @@ static int dio_new_bio(struct dio *dio,
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


