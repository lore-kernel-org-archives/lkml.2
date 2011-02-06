Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1BFBdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 20:33:50 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38245 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab1BFBdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 20:33:49 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] zram: fix data corruption issue
Date: Sat,  5 Feb 2011 20:34:20 -0500
Message-Id: <1296956060-13594-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In zram_read() and zram_write() we were not incrementing the
index number and thus were reading/writing values from/to
incorrect sectors on zram disk, resulting in data corruption.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zram/zram_drv.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 5415712..4bd8cbd 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -227,6 +227,7 @@ static int zram_read(struct zram *zram, struct bio *bio)
 
 		if (zram_test_flag(zram, index, ZRAM_ZERO)) {
 			handle_zero_page(page);
+			index++;
 			continue;
 		}
 
@@ -235,12 +236,14 @@ static int zram_read(struct zram *zram, struct bio *bio)
 			pr_debug("Read before write: sector=%lu, size=%u",
 				(ulong)(bio->bi_sector), bio->bi_size);
 			/* Do nothing */
+			index++;
 			continue;
 		}
 
 		/* Page is stored uncompressed since it's incompressible */
 		if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED))) {
 			handle_uncompressed_page(zram, page, index);
+			index++;
 			continue;
 		}
 
@@ -320,6 +323,7 @@ static int zram_write(struct zram *zram, struct bio *bio)
 			mutex_unlock(&zram->lock);
 			zram_stat_inc(&zram->stats.pages_zero);
 			zram_set_flag(zram, index, ZRAM_ZERO);
+			index++;
 			continue;
 		}
 
-- 
1.7.3.5

