Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2JOUKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:10:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38591 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab2JOUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:09 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH v4 15/24] pktcdvd: use bio_copy_data()
Date: Mon, 15 Oct 2012 13:08:49 -0700
Message-Id: <1350331769-14856-16-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Jiri Kosina <jkosina@suse.cz>
---
 drivers/block/pktcdvd.c | 79 ++++++++-----------------------------------------
 1 file changed, 12 insertions(+), 67 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 2c27744..783c96c 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -948,31 +948,6 @@ static int pkt_set_segment_merging(struct pktcdvd_device *pd, struct request_que
 }
 
 /*
- * Copy CD_FRAMESIZE bytes from src_bio into a destination page
- */
-static void pkt_copy_bio_data(struct bio *src_bio, int seg, int offs, struct page *dst_page, int dst_offs)
-{
-	unsigned int copy_size = CD_FRAMESIZE;
-
-	while (copy_size > 0) {
-		struct bio_vec *src_bvl = bio_iovec_idx(src_bio, seg);
-		void *vfrom = kmap_atomic(src_bvl->bv_page) +
-			src_bvl->bv_offset + offs;
-		void *vto = page_address(dst_page) + dst_offs;
-		int len = min_t(int, copy_size, src_bvl->bv_len - offs);
-
-		BUG_ON(len < 0);
-		memcpy(vto, vfrom, len);
-		kunmap_atomic(vfrom);
-
-		seg++;
-		offs = 0;
-		dst_offs += len;
-		copy_size -= len;
-	}
-}
-
-/*
  * Copy all data for this packet to pkt->pages[], so that
  * a) The number of required segments for the write bio is minimized, which
  *    is necessary for some scsi controllers.
@@ -1325,55 +1300,35 @@ try_next_bio:
  */
 static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 {
-	struct bio *bio;
 	int f;
-	int frames_write;
 	struct bio_vec *bvec = pkt->w_bio->bi_io_vec;
 
+	bio_reset(pkt->w_bio);
+	pkt->w_bio->bi_sector = pkt->sector;
+	pkt->w_bio->bi_bdev = pd->bdev;
+	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
+	pkt->w_bio->bi_private = pkt;
+
+	/* XXX: locking? */
 	for (f = 0; f < pkt->frames; f++) {
 		bvec[f].bv_page = pkt->pages[(f * CD_FRAMESIZE) / PAGE_SIZE];
 		bvec[f].bv_offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
+		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
+			BUG();
 	}
+	VPRINTK(DRIVER_NAME": vcnt=%d\n", pkt->w_bio->bi_vcnt);
 
 	/*
 	 * Fill-in bvec with data from orig_bios.
 	 */
-	frames_write = 0;
 	spin_lock(&pkt->lock);
-	bio_list_for_each(bio, &pkt->orig_bios) {
-		int segment = bio->bi_idx;
-		int src_offs = 0;
-		int first_frame = (bio->bi_sector - pkt->sector) / (CD_FRAMESIZE >> 9);
-		int num_frames = bio->bi_size / CD_FRAMESIZE;
-		BUG_ON(first_frame < 0);
-		BUG_ON(first_frame + num_frames > pkt->frames);
-		for (f = first_frame; f < first_frame + num_frames; f++) {
-			struct bio_vec *src_bvl = bio_iovec_idx(bio, segment);
-
-			while (src_offs >= src_bvl->bv_len) {
-				src_offs -= src_bvl->bv_len;
-				segment++;
-				BUG_ON(segment >= bio->bi_vcnt);
-				src_bvl = bio_iovec_idx(bio, segment);
-			}
+	bio_copy_data(pkt->w_bio, pkt->orig_bios.head);
 
-			if (src_bvl->bv_len - src_offs >= CD_FRAMESIZE) {
-				bvec[f].bv_page = src_bvl->bv_page;
-				bvec[f].bv_offset = src_bvl->bv_offset + src_offs;
-			} else {
-				pkt_copy_bio_data(bio, segment, src_offs,
-						  bvec[f].bv_page, bvec[f].bv_offset);
-			}
-			src_offs += CD_FRAMESIZE;
-			frames_write++;
-		}
-	}
 	pkt_set_state(pkt, PACKET_WRITE_WAIT_STATE);
 	spin_unlock(&pkt->lock);
 
 	VPRINTK("pkt_start_write: Writing %d frames for zone %llx\n",
-		frames_write, (unsigned long long)pkt->sector);
-	BUG_ON(frames_write != pkt->write_size);
+		pkt->write_size, (unsigned long long)pkt->sector);
 
 	if (test_bit(PACKET_MERGE_SEGS, &pd->flags) || (pkt->write_size < pkt->frames)) {
 		pkt_make_local_copy(pkt, bvec);
@@ -1383,16 +1338,6 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	}
 
 	/* Start the write request */
-	bio_reset(pkt->w_bio);
-	pkt->w_bio->bi_sector = pkt->sector;
-	pkt->w_bio->bi_bdev = pd->bdev;
-	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
-	pkt->w_bio->bi_private = pkt;
-	for (f = 0; f < pkt->frames; f++)
-		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
-			BUG();
-	VPRINTK(DRIVER_NAME": vcnt=%d\n", pkt->w_bio->bi_vcnt);
-
 	atomic_set(&pkt->io_wait, 1);
 	pkt->w_bio->bi_rw = WRITE;
 	pkt_queue_bio(pd, pkt->w_bio);
-- 
1.7.12

