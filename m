Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab0LQQEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:04:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab0LQQEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:04:13 -0500
Message-ID: <4D0B89F7.1000103@redhat.com>
Date: Fri, 17 Dec 2010 17:04:07 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: [PATCH 4/4] Staging: zram: simplify zram_make_request
References: <4D0B88E5.4040005@redhat.com>
In-Reply-To: <4D0B88E5.4040005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


zram_read() and zram_write() always return zero, so make them return
void to simplify the code.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 zram_drv.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 4085958..54577b0 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -200,7 +200,7 @@ static void handle_uncompressed_page(struct zram *zram,
 	flush_dcache_page(page);
 }
 
-static int zram_read(struct zram *zram, struct bio *bio)
+static void zram_read(struct zram *zram, struct bio *bio)
 {
 
 	int i;
@@ -209,7 +209,7 @@ static int zram_read(struct zram *zram, struct bio *bio)
 
 	if (unlikely(!zram->init_done)) {
 		bio_endio(bio, -ENXIO);
-		return 0;
+		return;
 	}
 
 	zram_stat64_inc(zram, &zram->stats.num_reads);
@@ -271,14 +271,13 @@ static int zram_read(struct zram *zram, struct bio *bio)
 
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio_endio(bio, 0);
-	return 0;
+	return;
 
 out:
 	bio_io_error(bio);
-	return 0;
 }
 
-static int zram_write(struct zram *zram, struct bio *bio)
+static void zram_write(struct zram *zram, struct bio *bio)
 {
 	int i, ret;
 	u32 index;
@@ -402,11 +401,10 @@ memstore:
 
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio_endio(bio, 0);
-	return 0;
+	return;
 
 out:
 	bio_io_error(bio);
-	return 0;
 }
 
 /*
@@ -431,7 +429,6 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
  */
 static int zram_make_request(struct request_queue *queue, struct bio *bio)
 {
-	int ret = 0;
 	struct zram *zram = queue->queuedata;
 
 	if (unlikely(!zram->init_done)) {
@@ -448,15 +445,15 @@ static int zram_make_request(struct request_queue *queue, struct bio *bio)
 
 	switch (bio_data_dir(bio)) {
 	case READ:
-		ret = zram_read(zram, bio);
+		zram_read(zram, bio);
 		break;
 
 	case WRITE:
-		ret = zram_write(zram, bio);
+		zram_write(zram, bio);
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 void zram_reset_device(struct zram *zram)

