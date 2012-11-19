Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab2KSHRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 02:17:36 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43018 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2KSHRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 02:17:33 -0500
Message-ID: <1353309387.12210.0.camel@erika>
Subject: [PATCH] Enable /proc/diskstats for /dev/ramX
From: Ryo Onodera <ryoqun@gmail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 19 Nov 2012 16:16:27 +0900
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ryo Onodera <ryoqun@gmail.com>
---
 drivers/block/brd.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 531ceb3..181b2d7 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -332,6 +332,7 @@ static void brd_make_request(struct request_queue *q, struct bio *bio)
 	sector_t sector;
 	int i;
 	int err = -EIO;
+	int cpu;
 
 	sector = bio->bi_sector;
 	if (sector + (bio->bi_size >> SECTOR_SHIFT) >
@@ -348,6 +349,12 @@ static void brd_make_request(struct request_queue *q, struct bio *bio)
 	if (rw == READA)
 		rw = READ;
 
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &brd->brd_disk->part0, ios[rw]);
+	part_stat_add(cpu, &brd->brd_disk->part0, sectors[rw],
+					bio_sectors(bio));
+	part_stat_unlock();
+
 	bio_for_each_segment(bvec, bio, i) {
 		unsigned int len = bvec->bv_len;
 		err = brd_do_bvec(brd, bvec->bv_page, len,
-- 
1.7.9.5



