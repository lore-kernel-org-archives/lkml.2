Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1BQQL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:11:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab1BQQLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:11:55 -0500
Message-ID: <4D5D48C5.3090906@redhat.com>
Date: Thu, 17 Feb 2011 17:11:49 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: zram: initialize device on first read
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently the device is initialized when first write is done to the
device. Any read attempt before the first write would fail, including
"hidden" read the user may not know about (as for example if he tries
to write a partial block).

This patch initializes the device on first request, whether read or
write.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 zram_drv.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 5fdf9d2..aab4ec4 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -211,11 +211,6 @@ static void zram_read(struct zram *zram, struct bio *bio)
 	u32 index;
 	struct bio_vec *bvec;
 
-	if (unlikely(!zram->init_done)) {
-		bio_endio(bio, -ENXIO);
-		return;
-	}
-
 	zram_stat64_inc(zram, &zram->stats.num_reads);
 	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
 
@@ -286,20 +281,15 @@ out:
 
 static void zram_write(struct zram *zram, struct bio *bio)
 {
-	int i, ret;
+	int i;
 	u32 index;
 	struct bio_vec *bvec;
 
-	if (unlikely(!zram->init_done)) {
-		ret = zram_init_device(zram);
-		if (ret)
-			goto out;
-	}
-
 	zram_stat64_inc(zram, &zram->stats.num_writes);
 	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
 
 	bio_for_each_segment(bvec, bio, i) {
+		int ret;
 		u32 offset;
 		size_t clen;
 		struct zobj_header *zheader;
@@ -445,6 +435,11 @@ static int zram_make_request(struct request_queue *queue, struct bio *bio)
 		return 0;
 	}
 
+	if (unlikely(!zram->init_done) && zram_init_device(zram)) {
+		bio_io_error(bio);
+		return 0;
+	}
+
 	switch (bio_data_dir(bio)) {
 	case READ:
 		zram_read(zram, bio);
