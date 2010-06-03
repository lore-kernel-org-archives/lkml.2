Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0FCVOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:14:12 -0400
Received: from smtp.nokia.com ([192.100.105.134]:51141 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0FCVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:14:10 -0400
Message-ID: <4C081AF5.50306@nokia.com>
Date: Fri, 04 Jun 2010 00:13:25 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <axboe@kernel.dk>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] mmc_block: Add BLKDISCARD, BLKSECDISCARD and BLKDISCARDZEROES
 support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2010 21:13:26.0450 (UTC) FILETIME=[9B6CC920:01CB0361]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 15f8b6cda53848ced93a20554584dc860baab8b7 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Thu, 3 Jun 2010 10:47:12 +0300
Subject: [PATCH 3/4] mmc_block: Add BLKDISCARD, BLKSECDISCARD and BLKDISCARDZEROES support

Add implementations for ioctls BLKDISCARD and BLKSECDISCARD, and
flag the I/O queue if the SD/MMC card zeroes erased sectors.
N.B. SD/MMC cards set erased sectors either to ones or zeroes.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/card/block.c |  152 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/card/queue.c |    2 +
 2 files changed, 154 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index cb9fbc8..67f59bc 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
 #include <linux/string_helpers.h>
+#include <linux/delay.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -138,9 +139,160 @@ mmc_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
+static int mmc_blk_check_eod(struct block_device *bdev, unsigned int from,
+			     unsigned int nr)
+{
+	unsigned int maxsector;
+
+	if (!nr)
+		return 0;
+
+	maxsector = bdev->bd_inode->i_size >> 9;
+	if (maxsector && (maxsector < nr || maxsector - nr < from))
+		return 1;
+
+	return 0;
+}
+
+static void mmc_blk_erase_throttle(struct mmc_blk_data *md)
+{
+	struct mmc_card *card = md->queue.card;
+	struct request_queue *q = md->queue.queue;
+	int i, ok;
+
+	for (i = 0; i < 40; i++) {
+		spin_lock_irq(q->queue_lock);
+		ok = elv_queue_empty(q);
+		spin_unlock_irq(q->queue_lock);
+		if (ok)
+			break;
+		mmc_release_host(card->host);
+		msleep(50);
+		mmc_claim_host(card->host);
+	}
+}
+
+static int mmc_blk_erase(struct mmc_blk_data *md, unsigned int from,
+			 unsigned int nr)
+{
+	struct mmc_card *card = md->queue.card;
+	unsigned int n, arg;
+	int err;
+
+	if (!mmc_can_erase(card))
+		return -EOPNOTSUPP;
+
+	if (mmc_can_trim(card))
+		arg = MMC_TRIM_ARG;
+	else
+		arg = MMC_ERASE_ARG;
+
+	mmc_claim_host(card->host);
+	n = card->max_erase - (from % card->max_erase);
+	do {
+		/*
+		 * Do not allow the BLKDISCARD ioctl to have priority over
+		 * scheduled I/O.
+		 */
+		mmc_blk_erase_throttle(md);
+		if (n > nr)
+			n = nr;
+		err = mmc_erase(card, from, n, arg);
+		if (err)
+			break;
+		from += n;
+		nr -= n;
+		n = card->max_erase;
+	} while (nr);
+	mmc_release_host(card->host);
+
+	return err;
+}
+
+static int mmc_blk_secure_erase(struct mmc_blk_data *md, unsigned int from,
+				unsigned int nr)
+{
+	struct mmc_card *card = md->queue.card;
+	unsigned int arg;
+	int err;
+
+	if (!mmc_can_secure_erase_trim(card))
+		return -EOPNOTSUPP;
+
+	if (mmc_can_trim(card) && !mmc_erase_group_aligned(card, from, nr))
+		arg = MMC_SECURE_TRIM1_ARG;
+	else
+		arg = MMC_SECURE_ERASE_ARG;
+
+	mmc_claim_host(card->host);
+	/*
+	 * Secure erase can be very inefficient when used with any size
+	 * significantly smaller than the size of the whole card, so do not
+	 * break up the original request, but still wait for scheduled I/O
+	 * in case the user is trying to securely erase one partition in
+	 * small pieces while still using another partition on the same card.
+	 */
+	mmc_blk_erase_throttle(md);
+	err = mmc_erase(card, from, nr, arg);
+	if (!err && arg == MMC_SECURE_TRIM1_ARG)
+		err = mmc_erase(card, from, nr, MMC_SECURE_TRIM2_ARG);
+	mmc_release_host(card->host);
+
+	return err;
+}
+
+static int mmc_blk_ioctl_discard(struct block_device *bdev, uint64_t start,
+				 uint64_t len, int secure)
+{
+	struct mmc_blk_data *md = bdev->bd_disk->private_data;
+	unsigned int from, nr;
+
+	if ((start & 511) || (len & 511))
+		return -EINVAL;
+
+	start >>= 9;
+	len >>= 9;
+
+	if (start > UINT_MAX || len > UINT_MAX)
+		return -EINVAL;
+
+	from = start;
+	nr = len;
+
+	if (mmc_blk_check_eod(bdev, from, nr))
+		return -EINVAL;
+
+	if (bdev != bdev->bd_contains)
+		from += bdev->bd_part->start_sect;
+
+	if (secure)
+		return mmc_blk_secure_erase(md, from, nr);
+	else
+		return mmc_blk_erase(md, from, nr);
+}
+
+static int mmc_blk_ioctl(struct block_device *bdev, fmode_t mode,
+			 unsigned cmd, unsigned long arg)
+{
+	uint64_t range[2];
+	int secure = 0;
+
+	switch (cmd) {
+	case BLKSECDISCARD:
+		secure = 1;
+	case BLKDISCARD:
+		if (copy_from_user(range, (void __user *)arg, sizeof(range)))
+			return -EFAULT;
+
+		return mmc_blk_ioctl_discard(bdev, range[0], range[1], secure);
+	}
+	return -ENOTTY;
+}
+
 static const struct block_device_operations mmc_bdops = {
 	.open			= mmc_blk_open,
 	.release		= mmc_blk_release,
+	.ioctl			= mmc_blk_ioctl,
 	.getgeo			= mmc_blk_getgeo,
 	.owner			= THIS_MODULE,
 };
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index d6ded24..9b760d7 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -130,6 +130,8 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 	blk_queue_ordered(mq->queue, QUEUE_ORDERED_DRAIN, NULL);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
+	if (card->erased_byte == 0)
+		mq->queue->limits.discard_zeroes_data = 1;
 
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
 	if (host->max_hw_segs == 1) {
-- 
1.6.3.3
