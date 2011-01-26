Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1AZRX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:23:27 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56233 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab1AZRXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:23:25 -0500
Date: Wed, 26 Jan 2011 11:23:18 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] zram: Prevent overflow in logical block size
Message-ID: <20110126172317.GD8446@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110126172148.GB8446@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126172148.GB8446@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 64K page kernel, the value PAGE_SIZE passed to
blk_queue_logical_block_size would overflow the logical block size
argument (resulting in setting it to 0).

Take the minimum of PAGE_SIZE or 4096 and use this for the block device
logical block size.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/staging/zram/zram_drv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index d0e9e02..d5e0275 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -621,7 +621,8 @@ static int create_device(struct zram *zram, int device_id)
 	 * and n*PAGE_SIZED sized I/O requests.
 	 */
 	blk_queue_physical_block_size(zram->disk->queue, PAGE_SIZE);
-	blk_queue_logical_block_size(zram->disk->queue, PAGE_SIZE);
+	blk_queue_logical_block_size(zram->disk->queue,
+			(unsigned short) min_t(unsigned int, PAGE_SIZE, 4096));
 	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
 	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
 
-- 
1.6.0.2

