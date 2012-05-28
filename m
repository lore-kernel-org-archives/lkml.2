Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2E1D3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51831 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415Ab2E1D27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:28:59 -0400
Message-Id: <20120528031203.986470805@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kent Overstreet <kent.overstreet@gmail.com>,
        Kent Overstreet <koverstreet@google.com>, Tejun Heo <tj@kernel.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 008/117] bio: dont overflow in bio_get_nr_vecs()
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@gmail.com>

commit 5abebfdd02450fa1349daacf242e70b3736581e3 upstream.

There were two places bio_get_nr_vecs() could overflow:

First, it did a left shift to convert from sectors to bytes immediately
before dividing by PAGE_SIZE.  If PAGE_SIZE ever was less than 512 a great
many things would break, so dividing by PAGE_SIZE >> 9 is safe and will
generate smaller code too.

The nastier overflow was in the DIV_ROUND_UP() (that's what the code was
effectively doing, anyways).  If n + d overflowed, the whole thing would
return 0 which breaks things rather effectively.

bio_get_nr_vecs() doesn't claim to give an exact value anyways, so the
DIV_ROUND_UP() is silly; we could do a straight divide except if a
device's queue_max_sectors was less than PAGE_SIZE we'd return 0.  So we
just add 1; this should always be safe - things will break badly if
bio_get_nr_vecs() returns > BIO_MAX_PAGES (bio_alloc() will suddenly start
failing) but it's queue_max_segments that must guard against this, if
queue_max_sectors is preventing this from happen things are going to
explode on architectures with different PAGE_SIZE.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/bio.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index b1fe82c..b980ecd 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -505,13 +505,9 @@ EXPORT_SYMBOL(bio_clone);
 int bio_get_nr_vecs(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-	int nr_pages;
-
-	nr_pages = ((queue_max_sectors(q) << 9) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (nr_pages > queue_max_segments(q))
-		nr_pages = queue_max_segments(q);
-
-	return nr_pages;
+	return min_t(unsigned,
+		     queue_max_segments(q),
+		     queue_max_sectors(q) / (PAGE_SIZE >> 9) + 1);
 }
 EXPORT_SYMBOL(bio_get_nr_vecs);
 


