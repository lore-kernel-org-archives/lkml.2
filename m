Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab2AVDhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 22:37:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63232 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2AVDhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 22:37:37 -0500
Date: Sat, 21 Jan 2012 19:37:25 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: jaxboe@fusionio.com
Cc: tejun@google.com, valdis.kletnieks@vt.edu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Don't overflow in bio_get_nr_vecs()
Message-ID: <20120122033654.GA18076@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were two places bio_get_nr_vecs() could overflow:

First, it did a left shift to convert from sectors to bytes immediately
before dividing by PAGE_SIZE. If PAGE_SIZE ever was less than 512 a
great many things would break, so dividing by PAGE_SIZE >> 9 is safe and
will generate smaller code too.

The nastier overflow was in the DIV_ROUND_UP() (that's what the code was
effectively doing, anyways). If n + d overflowed, the whole thing would
return 0 which breaks things rather effectively.

bio_get_nr_vecs() doesn't claim to give an exact value anyways, so the
DIV_ROUND_UP() is silly; we could do a straight divide except if a
device's queue_max_sectors was less than PAGE_SIZE we'd return 0. So we
just add 1; this should always be safe - things will break badly if
bio_get_nr_vecs() returns > BIO_MAX_PAGES (bio_alloc() will suddenly
start failing) but it's queue_max_segments that must guard against this,
if queue_max_sectors is preventing this from happen things are going to
explode on architectures with different PAGE_SIZE.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/bio.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index f33a30d..a856534 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -511,13 +511,9 @@ EXPORT_SYMBOL(bio_clone);
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
 
-- 
1.7.8.3

