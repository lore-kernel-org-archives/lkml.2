Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab1AUAn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 19:43:57 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44697 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1AUAn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:43:56 -0500
Message-ID: <4D38D6DE.10405@vflare.org>
Date: Thu, 20 Jan 2011 19:44:14 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] [resend] Staging: zram: simplify zram_make_request
References: <4D0B88E5.4040005@redhat.com> <4D0B89F7.1000103@redhat.com>
In-Reply-To: <4D0B89F7.1000103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


zram_read() and zram_write() always return zero, so make them return
void to simplify the code.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
---
  drivers/staging/zram/zram_drv.c |   19 ++++++++-----------
  1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c 
b/drivers/staging/zram/zram_drv.c
index 01d6dd9..5ed4e75 100644
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
@@ -271,14 +271,13 @@ static int zram_read(struct zram *zram, struct bio 
*bio)

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
@@ -431,7 +429,6 @@ static inline int valid_io_request(struct zram 
*zram, struct bio *bio)
   */
  static int zram_make_request(struct request_queue *queue, struct bio *bio)
  {
-	int ret = 0;
  	struct zram *zram = queue->queuedata;

  	if (!valid_io_request(zram, bio)) {
@@ -442,15 +439,15 @@ static int zram_make_request(struct request_queue 
*queue, struct bio *bio)

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
-- 
1.7.3.5
