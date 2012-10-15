Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab2JOUKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:10:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46616 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2JOUKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:41 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de
Subject: [PATCH v2 10/26] block: Add submit_bio_wait(), remove from md
Date: Mon, 15 Oct 2012 13:09:13 -0700
Message-Id: <1350331769-14856-40-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Random cleanup - this code was duplicated and it's not really specific
to md.

Also added the ability to return the actual error code.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c  | 19 -------------------
 drivers/md/raid10.c | 19 -------------------
 fs/bio.c            | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |  1 +
 4 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2488440..ee85154 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2048,25 +2048,6 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 	}
 }
 
-static void bi_complete(struct bio *bio, int error)
-{
-	complete((struct completion *)bio->bi_private);
-}
-
-static int submit_bio_wait(int rw, struct bio *bio)
-{
-	struct completion event;
-	rw |= REQ_SYNC;
-
-	init_completion(&event);
-	bio->bi_private = &event;
-	bio->bi_end_io = bi_complete;
-	submit_bio(rw, bio);
-	wait_for_completion(&event);
-
-	return test_bit(BIO_UPTODATE, &bio->bi_flags);
-}
-
 static int narrow_write_error(struct r1bio *r1_bio, int i)
 {
 	struct mddev *mddev = r1_bio->mddev;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6d06d83..f001c1b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2410,25 +2410,6 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	}
 }
 
-static void bi_complete(struct bio *bio, int error)
-{
-	complete((struct completion *)bio->bi_private);
-}
-
-static int submit_bio_wait(int rw, struct bio *bio)
-{
-	struct completion event;
-	rw |= REQ_SYNC;
-
-	init_completion(&event);
-	bio->bi_private = &event;
-	bio->bi_end_io = bi_complete;
-	submit_bio(rw, bio);
-	wait_for_completion(&event);
-
-	return test_bit(BIO_UPTODATE, &bio->bi_flags);
-}
-
 static int narrow_write_error(struct r10bio *r10_bio, int i)
 {
 	struct bio *bio = r10_bio->master_bio;
diff --git a/fs/bio.c b/fs/bio.c
index addeac2..1342a16 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -750,6 +750,42 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 }
 EXPORT_SYMBOL(bio_add_page);
 
+struct submit_bio_ret {
+	struct completion event;
+	int error;
+};
+
+static void submit_bio_wait_endio(struct bio *bio, int error)
+{
+	struct submit_bio_ret *ret = bio->bi_private;
+
+	ret->error = error;
+	complete(&ret->event);
+}
+
+/**
+ * submit_bio_wait - submit a bio, and wait until it completes
+ * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
+ * @bio: The &struct bio which describes the I/O
+ *
+ * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
+ * bio_endio() on failure.
+ */
+int submit_bio_wait(int rw, struct bio *bio)
+{
+	struct submit_bio_ret ret;
+
+	rw |= REQ_SYNC;
+	init_completion(&ret.event);
+	bio->bi_private = &ret;
+	bio->bi_end_io = submit_bio_wait_endio;
+	submit_bio(rw, bio);
+	wait_for_completion(&ret.event);
+
+	return ret.error;
+}
+EXPORT_SYMBOL(submit_bio_wait);
+
 /**
  * bio_advance - increment/complete a bio by some number of bytes
  * @bio:	bio to advance
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 92bff0e..949c48a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -249,6 +249,7 @@ extern void bio_endio(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
+extern int submit_bio_wait(int rw, struct bio *bio);
 void bio_advance(struct bio *, unsigned);
 
 extern void bio_init(struct bio *);
-- 
1.7.12

