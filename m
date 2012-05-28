Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab2E1DwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:52:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51918 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515Ab2E1D3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:12 -0400
Message-Id: <20120528031204.124440304@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 009/117] bio allocation failure due to bio_get_nr_vecs()
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/bio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/bio.c b/fs/bio.c
index e453924..84da885 100644
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
 


