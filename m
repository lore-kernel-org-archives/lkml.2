Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1A1O62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:58:28 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33730 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab1A1O61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:58:27 -0500
Date: Fri, 28 Jan 2011 08:58:17 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] [v2] zram: Prevent overflow in logical block size
Message-ID: <20110128145816.GC2062@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110128145602.GA2062@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128145602.GA2062@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 64K page kernel, the value PAGE_SIZE passed to
blk_queue_logical_block_size would overflow the logical block size
argument (resulting in setting it to 0).

This patch sets the logical block size to 4096, using a new
ZRAM_LOGICAL_BLOCK_SIZE constant.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/staging/zram/zram_drv.c |    3 ++-
 drivers/staging/zram/zram_drv.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 5415712..d85d034 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -620,7 +620,8 @@ static int create_device(struct zram *zram, int device_id)
 	 * and n*PAGE_SIZED sized I/O requests.
 	 */
 	blk_queue_physical_block_size(zram->disk->queue, PAGE_SIZE);
-	blk_queue_logical_block_size(zram->disk->queue, PAGE_SIZE);
+	blk_queue_logical_block_size(zram->disk->queue,
+					ZRAM_LOGICAL_BLOCK_SIZE);
 	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
 	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
 
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index a481551..408b2c0 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -61,6 +61,7 @@ static const unsigned max_zpage_size = PAGE_SIZE / 4 * 3;
 #define SECTOR_SIZE		(1 << SECTOR_SHIFT)
 #define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
 #define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
+#define ZRAM_LOGICAL_BLOCK_SIZE	4096
 
 /* Flags for zram pages (table[page_no].flags) */
 enum zram_pageflags {
-- 
1.7.0.4

