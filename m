Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab0EMFUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 01:20:15 -0400
Received: from smtp-out.google.com ([74.125.121.35]:26067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0EMFUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 01:20:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:subject:cc:message-id:date:from:x-system-of-record;
	b=RFhYerZjKbaDgdSrjkNv5O9dz2+aPHpr2LeBBwYB5Zg1I2LBfJeDVaOYBVoDllLIX
	zvuLLQ52mfejfAmeTga+Q==
To: hch@infradead.org, jens.axboe@oracle.com
Subject: [PATCH, RFC] addjust discard request to be aligned with hwsect size to support SSDs with larger sector size
Cc: linux-kernel@vger.kernel.org, mrubin@google.com
Message-Id: <20100513051953.532821BC316@ruihe.smo.corp.google.com>
Date: Wed, 12 May 2010 22:19:53 -0700 (PDT)
From: jiayingz@google.com (Jiaying Zhang)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The currect blkdev_issue_discard() function assumes 512 sector size.
We have seen some problem when using discard on a SSD that has larger
sector size. The following patch adjusts the starting address and size of
a discard request to be aligned with hwsect size.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 6d88544..576b7a1 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -376,14 +376,22 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		DISCARD_BARRIER : DISCARD_NOBARRIER;
 	struct bio *bio;
 	struct page *page;
+	int hwsect_shift = blksize_bits(bdev_logical_block_size(bdev)) - 9;
+	int hwsect_mask = (1 << hwsect_shift) - 1;
+	sector_t end_sector;
 	int ret = 0;
 
 	if (!q)
 		return -ENXIO;
 
-	if (!blk_queue_discard(q))
+	if (!blk_queue_discard(q) || q->limits.max_discard_sectors == 0)
 		return -EOPNOTSUPP;
 
+	if (hwsect_shift > 0) {
+		end_sector = (sector + nr_sects) & ~hwsect_mask;
+		sector = (sector + hwsect_mask) & ~hwsect_mask;
+		nr_sects = end_sector - sector;
+	}
 	while (nr_sects && !ret) {
 		unsigned int sector_size = q->limits.logical_block_size;
 		unsigned int max_discard_sectors =
