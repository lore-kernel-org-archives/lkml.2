Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab1KKIMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 03:12:21 -0500
Received: from mort.rzone.de ([81.169.144.234]:59643 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab1KKIMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 03:12:20 -0500
From: Arne Jansen <sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Cc: andrea.gelmini@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Btrfs: handle bio_add_page failure gracefully in scrub
Date: Fri, 11 Nov 2011 09:12:17 +0100
Message-Id: <1320999137-20721-1-git-send-email-sensille@gmx.net>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently scrub fails with ENOMEM when bio_add_page fails. Unfortunately
dm based targets accept only one page per bio, thus making scrub always
fails. This patch just submits the current bio when an error is encountered
and starts a new one.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/scrub.c |   64 ++++++++++++++++++++++++-----------------------------
 1 files changed, 29 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ed11d38..f4190f2 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -944,50 +944,18 @@ static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer)
 static int scrub_submit(struct scrub_dev *sdev)
 {
 	struct scrub_bio *sbio;
-	struct bio *bio;
-	int i;
 
 	if (sdev->curr == -1)
 		return 0;
 
 	sbio = sdev->bios[sdev->curr];
-
-	bio = bio_alloc(GFP_NOFS, sbio->count);
-	if (!bio)
-		goto nomem;
-
-	bio->bi_private = sbio;
-	bio->bi_end_io = scrub_bio_end_io;
-	bio->bi_bdev = sdev->dev->bdev;
-	bio->bi_sector = sbio->physical >> 9;
-
-	for (i = 0; i < sbio->count; ++i) {
-		struct page *page;
-		int ret;
-
-		page = alloc_page(GFP_NOFS);
-		if (!page)
-			goto nomem;
-
-		ret = bio_add_page(bio, page, PAGE_SIZE, 0);
-		if (!ret) {
-			__free_page(page);
-			goto nomem;
-		}
-	}
-
 	sbio->err = 0;
 	sdev->curr = -1;
 	atomic_inc(&sdev->in_flight);
 
-	submit_bio(READ, bio);
+	submit_bio(READ, sbio->bio);
 
 	return 0;
-
-nomem:
-	scrub_free_bio(bio);
-
-	return -ENOMEM;
 }
 
 static int scrub_page(struct scrub_dev *sdev, u64 logical, u64 len,
@@ -995,6 +963,8 @@ static int scrub_page(struct scrub_dev *sdev, u64 logical, u64 len,
 		      u8 *csum, int force)
 {
 	struct scrub_bio *sbio;
+	struct page *page;
+	int ret;
 
 again:
 	/*
@@ -1015,12 +985,22 @@ again:
 	}
 	sbio = sdev->bios[sdev->curr];
 	if (sbio->count == 0) {
+		struct bio *bio;
+
 		sbio->physical = physical;
 		sbio->logical = logical;
+		bio = bio_alloc(GFP_NOFS, SCRUB_PAGES_PER_BIO);
+		if (!bio)
+			return -ENOMEM;
+
+		bio->bi_private = sbio;
+		bio->bi_end_io = scrub_bio_end_io;
+		bio->bi_bdev = sdev->dev->bdev;
+		bio->bi_sector = sbio->physical >> 9;
+		sbio->err = 0;
+		sbio->bio = bio;
 	} else if (sbio->physical + sbio->count * PAGE_SIZE != physical ||
 		   sbio->logical + sbio->count * PAGE_SIZE != logical) {
-		int ret;
-
 		ret = scrub_submit(sdev);
 		if (ret)
 			return ret;
@@ -1030,6 +1010,20 @@ again:
 	sbio->spag[sbio->count].generation = gen;
 	sbio->spag[sbio->count].have_csum = 0;
 	sbio->spag[sbio->count].mirror_num = mirror_num;
+
+	page = alloc_page(GFP_NOFS);
+	if (!page)
+		return -ENOMEM;
+
+	ret = bio_add_page(sbio->bio, page, PAGE_SIZE, 0);
+	if (!ret) {
+		__free_page(page);
+		ret = scrub_submit(sdev);
+		if (ret)
+			return ret;
+		goto again;
+	}
+
 	if (csum) {
 		sbio->spag[sbio->count].have_csum = 1;
 		memcpy(sbio->spag[sbio->count].csum, csum, sdev->csum_size);
-- 
1.7.3.4

