Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab0EVSJH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 14:09:07 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:37160 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab0EVSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 14:09:00 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH 2/3] kernel/power/swap.c: do not use end_swap_bio_read
Date: Sat, 22 May 2010 15:08:50 -0300
Message-Id: <1274551731-4534-2-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <4BF81D87.6010506@cesarb.net>
References: <4BF81D87.6010506@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The swap checksum patches will change end_swap_bio_read to also verify
the page's checksum. This is not compatible with its use at submit()
from kernel/power/swap.c.

Make kernel/power/swap.c use a private copy of end_swap_bio_read, and
modify it to not say "Read-error" if the error was on a write.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 include/linux/swap.h |    1 -
 kernel/power/swap.c  |   21 ++++++++++++++++++++-
 mm/page_io.c         |    2 +-
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1f59d93..86a0d64 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -291,7 +291,6 @@ extern void swap_unplug_io_fn(struct backing_dev_info *, struct page *);
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
-extern void end_swap_bio_read(struct bio *bio, int err);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swapper_space;
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 66824d7..7305a3f 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -147,6 +147,25 @@ int swsusp_swap_in_use(void)
 static unsigned short root_swap = 0xffff;
 static struct block_device *resume_bdev;
 
+static void end_swap_bio(struct bio *bio, int err)
+{
+	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	struct page *page = bio->bi_io_vec[0].bv_page;
+
+	if (!uptodate) {
+		SetPageError(page);
+		ClearPageUptodate(page);
+		printk(KERN_ALERT "%s-error on swap-device (%u:%u:%Lu)\n",
+				bio->bi_rw & BIO_RW ? "Write" : "Read",
+				imajor(bio->bi_bdev->bd_inode),
+				iminor(bio->bi_bdev->bd_inode),
+				(unsigned long long)bio->bi_sector);
+	} else {
+		SetPageUptodate(page);
+	}
+	unlock_page(page);
+	bio_put(bio);
+}
 /**
  *	submit - submit BIO request.
  *	@rw:	READ or WRITE.
@@ -167,7 +186,7 @@ static int submit(int rw, pgoff_t page_off, struct page *page,
 	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
 	bio->bi_sector = page_off * (PAGE_SIZE >> 9);
 	bio->bi_bdev = resume_bdev;
-	bio->bi_end_io = end_swap_bio_read;
+	bio->bi_end_io = end_swap_bio;
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
 		printk(KERN_ERR "PM: Adding page to bio failed at %ld\n",
diff --git a/mm/page_io.c b/mm/page_io.c
index 31a3b96..0e2d4e8 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -66,7 +66,7 @@ static void end_swap_bio_write(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-void end_swap_bio_read(struct bio *bio, int err)
+static void end_swap_bio_read(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
-- 
1.6.6.1

