Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2E0BGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:06:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2E0BFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:05:53 -0400
Message-Id: <20120527010424.075751499@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:25 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 02/94] bio allocation failure due to bio_get_nr_vecs()
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

commit f908ee9463b09ddd05e1c1a0111132212dc05fac upstream.

The number of bio_get_nr_vecs() is passed down via bio_alloc() to
bvec_alloc_bs(), which fails the bio allocation if
nr_iovecs > BIO_MAX_PAGES. For the underlying caller this causes an
unexpected bio allocation failure.
Limiting to queue_max_segments() is not sufficient, as max_segments
also might be very large.

bvec_alloc_bs(gfp_mask, nr_iovecs, ) => NULL when nr_iovecs  > BIO_MAX_PAGES
bio_alloc_bioset(gfp_mask, nr_iovecs, ...)
bio_alloc(GFP_NOIO, nvecs)
xfs_alloc_ioend_bio()

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/bio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/bio.c
+++ b/fs/bio.c
@@ -505,9 +505,14 @@ EXPORT_SYMBOL(bio_clone);
 int bio_get_nr_vecs(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-	return min_t(unsigned,
+	int nr_pages;
+
+	nr_pages = min_t(unsigned,
 		     queue_max_segments(q),
 		     queue_max_sectors(q) / (PAGE_SIZE >> 9) + 1);
+
+	return min_t(unsigned, nr_pages, BIO_MAX_PAGES);
+
 }
 EXPORT_SYMBOL(bio_get_nr_vecs);
 


