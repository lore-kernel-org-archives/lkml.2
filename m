Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407Ab0KQN35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:29:57 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44901 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934039Ab0KQN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:29:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HjxpLNArV/nJovx5IQSY3bvySYK72BKu/RjOFEhgA0Xjy/soracqLkzOqPvM2bihcR
         Vz5Trh0+3TYDmQXDQ93m7rVojyRnTQOGUd+nzWwdp8L6sR99ZOCeHqvdfLNhA7z49NIj
         1cpqh6i4GvQYy4rexGOGLGQzM7tGOyjyovCa0=
From: Hai Shan <haishan.bai@gmail.com>
To: viro@zeniv.linux.org.uk, axboe@kernel.dk
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hai Shan <shan.hai@windriver.com>
Subject: [PATCH] mpage: some code cleanups
Date: Wed, 17 Nov 2010 21:29:23 +0800
Message-Id: <1290000563-1803-2-git-send-email-shan.hai@windriver.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290000563-1803-1-git-send-email-shan.hai@windriver.com>
References: <1290000563-1803-1-git-send-email-shan.hai@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged mpage_end_io_read() and mpage_end_io_write() to mpage_end_io()

Signed-off-by: Hai Shan <shan.hai@windriver.com>
---
 fs/mpage.c |   49 +++++++++++++++++--------------------------------
 1 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index fd56ca2..1187e60 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -40,7 +40,7 @@
  * status of that page is hard.  See end_buffer_async_read() for the details.
  * There is no point in duplicating all that complexity.
  */
-static void mpage_end_io_read(struct bio *bio, int err)
+static void mpage_end_io(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -50,44 +50,29 @@ static void mpage_end_io_read(struct bio *bio, int err)
 
 		if (--bvec >= bio->bi_io_vec)
 			prefetchw(&bvec->bv_page->flags);
-
-		if (uptodate) {
-			SetPageUptodate(page);
-		} else {
-			ClearPageUptodate(page);
-			SetPageError(page);
-		}
-		unlock_page(page);
-	} while (bvec >= bio->bi_io_vec);
-	bio_put(bio);
-}
-
-static void mpage_end_io_write(struct bio *bio, int err)
-{
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-
-	do {
-		struct page *page = bvec->bv_page;
-
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-
-		if (!uptodate){
-			SetPageError(page);
-			if (page->mapping)
-				set_bit(AS_EIO, &page->mapping->flags);
+		if (bio_data_dir(bio) == READ) {
+			if (uptodate) {
+				SetPageUptodate(page);
+			} else {
+				ClearPageUptodate(page);
+				SetPageError(page);
+			}
+			unlock_page(page);
+		} else { /* bio_data_dir(bio) == WRITE */
+			if (!uptodate){
+				SetPageError(page);
+				if (page->mapping)
+					set_bit(AS_EIO, &page->mapping->flags);
+			}
+			end_page_writeback(page);
 		}
-		end_page_writeback(page);
 	} while (bvec >= bio->bi_io_vec);
 	bio_put(bio);
 }
 
 static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
-	bio->bi_end_io = mpage_end_io_read;
-	if (rw == WRITE)
-		bio->bi_end_io = mpage_end_io_write;
+	bio->bi_end_io = mpage_end_io;
 	submit_bio(rw, bio);
 	return NULL;
 }
-- 
1.7.0.4

