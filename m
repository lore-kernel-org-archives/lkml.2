Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1BPBTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:19:36 -0500
Received: from kroah.org ([198.145.64.141]:45276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880Ab1BPAsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:02 2011
Message-Id: <20110216002102.629528400@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nitin Gupta <ngupta@vflare.org>
Subject: [patch 035/176] staging: zram: fix data corruption issue
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nitin Gupta <ngupta@vflare.org>

commit 5414e557fca545614ceedc3d3496f747457e2e3b upstream.

In zram_read() and zram_write() we were not incrementing the
index number and thus were reading/writing values from/to
incorrect sectors on zram disk, resulting in data corruption.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/zram/zram_drv.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -235,6 +235,7 @@ static int zram_read(struct zram *zram,
 
 		if (zram_test_flag(zram, index, ZRAM_ZERO)) {
 			handle_zero_page(page);
+			index++;
 			continue;
 		}
 
@@ -243,12 +244,14 @@ static int zram_read(struct zram *zram,
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
 
@@ -324,6 +327,7 @@ static int zram_write(struct zram *zram,
 			mutex_unlock(&zram->lock);
 			zram_stat_inc(&zram->stats.pages_zero);
 			zram_set_flag(zram, index, ZRAM_ZERO);
+			index++;
 			continue;
 		}
 


