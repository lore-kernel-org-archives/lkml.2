Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2H1SD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 14:03:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22889 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2H1SD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 14:03:27 -0400
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: Fix bad range check in bio_sector_offset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Date: Tue, 28 Aug 2012 14:03:18 -0400
Message-ID: <yq1a9xesxll.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


DM would occasionally end up splitting data integrity-enabled requests
incorrectly. The culprit was a bad range check in bio_sector_offset.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: <stable@vger.kernel.org>

diff --git a/fs/bio.c b/fs/bio.c
index 9bfade8..b9a6744 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1552,8 +1552,8 @@ sector_t bio_sector_offset(struct bio *bio, unsigned short index,
 	sector_sz = queue_logical_block_size(bio->bi_bdev->bd_disk->queue);
 	sectors = 0;
 
-	if (index >= bio->bi_idx)
-		index = bio->bi_vcnt - 1;
+	if (index > bio->bi_vcnt)
+		return 0;
 
 	__bio_for_each_segment(bv, bio, i, 0) {
 		if (i == index) {
