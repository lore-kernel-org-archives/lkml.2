Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab0L3JIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 04:08:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41409 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab0L3JIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 04:08:14 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dennis Jansen <dennis.jansen@web.de>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][zram] Do not check for init flag before starting I/O
Date: Thu, 30 Dec 2010 04:07:58 -0500
Message-Id: <1293700078-5141-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram module is unusable without this fix.

Checking for init_done flag in zram_make_request() results in a
*no-op* for any I/O operation since we simply always return
success. This flag is actually set when the first write occurs
on a zram disk which triggers its initialization.

Bug report: https://bugzilla.kernel.org/show_bug.cgi?id=25722

Reported-by: Dennis Jansen <dennis.jansen@web.de>
Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zram/zram_drv.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 8c3c057..d0e9e02 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -435,12 +435,6 @@ static int zram_make_request(struct request_queue *queue, struct bio *bio)
 	int ret = 0;
 	struct zram *zram = queue->queuedata;
 
-	if (unlikely(!zram->init_done)) {
-		set_bit(BIO_UPTODATE, &bio->bi_flags);
-		bio_endio(bio, 0);
-		return 0;
-	}
-
 	if (!valid_io_request(zram, bio)) {
 		zram_stat64_inc(zram, &zram->stats.invalid_io);
 		bio_io_error(bio);
-- 
1.7.3.4

