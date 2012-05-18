Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031024Ab2ERDCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:02:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59477 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030712Ab2ERDAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:00:15 -0400
From: koverstreet@google.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: [PATCH 07/13] pktcdvd: Switch to bio_kmalloc()
Date: Thu, 17 May 2012 22:59:54 -0400
Message-Id: <04a4d6c2c8b6f0097e3594c6e0932093afffc1da.1337308722.git.koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.rc2
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
In-Reply-To: <cover.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

This is prep work for killing bi_destructor

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/block/pktcdvd.c |  115 ++++++++++++++++-------------------------------
 1 files changed, 39 insertions(+), 76 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index ba66e44..6fe693a 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -522,36 +522,38 @@ static void pkt_bio_finished(struct pktcdvd_device *pd)
 	}
 }
 
-static void pkt_bio_destructor(struct bio *bio)
+static void pkt_end_io_read(struct bio *bio, int err)
 {
-	kfree(bio->bi_io_vec);
-	kfree(bio);
-}
+	struct packet_data *pkt = bio->bi_private;
+	struct pktcdvd_device *pd = pkt->pd;
+	BUG_ON(!pd);
 
-static struct bio *pkt_bio_alloc(int nr_iovecs)
-{
-	struct bio_vec *bvl = NULL;
-	struct bio *bio;
+	VPRINTK("pkt_end_io_read: bio=%p sec0=%llx sec=%llx err=%d\n", bio,
+		(unsigned long long)pkt->sector, (unsigned long long)bio->bi_sector, err);
 
-	bio = kmalloc(sizeof(struct bio), GFP_KERNEL);
-	if (!bio)
-		goto no_bio;
-	bio_init(bio);
+	if (err)
+		atomic_inc(&pkt->io_errors);
+	if (atomic_dec_and_test(&pkt->io_wait)) {
+		atomic_inc(&pkt->run_sm);
+		wake_up(&pd->wqueue);
+	}
+	pkt_bio_finished(pd);
+}
 
-	bvl = kcalloc(nr_iovecs, sizeof(struct bio_vec), GFP_KERNEL);
-	if (!bvl)
-		goto no_bvl;
+static void pkt_end_io_packet_write(struct bio *bio, int err)
+{
+	struct packet_data *pkt = bio->bi_private;
+	struct pktcdvd_device *pd = pkt->pd;
+	BUG_ON(!pd);
 
-	bio->bi_max_vecs = nr_iovecs;
-	bio->bi_io_vec = bvl;
-	bio->bi_destructor = pkt_bio_destructor;
+	VPRINTK("pkt_end_io_packet_write: id=%d, err=%d\n", pkt->id, err);
 
-	return bio;
+	pd->stats.pkt_ended++;
 
- no_bvl:
-	kfree(bio);
- no_bio:
-	return NULL;
+	pkt_bio_finished(pd);
+	atomic_dec(&pkt->io_wait);
+	atomic_inc(&pkt->run_sm);
+	wake_up(&pd->wqueue);
 }
 
 /*
@@ -567,10 +569,13 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
 		goto no_pkt;
 
 	pkt->frames = frames;
-	pkt->w_bio = pkt_bio_alloc(frames);
+	pkt->w_bio = bio_kmalloc(GFP_KERNEL, frames);
 	if (!pkt->w_bio)
 		goto no_bio;
 
+	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
+	pkt->w_bio->bi_private = pkt;
+
 	for (i = 0; i < frames / FRAMES_PER_PAGE; i++) {
 		pkt->pages[i] = alloc_page(GFP_KERNEL|__GFP_ZERO);
 		if (!pkt->pages[i])
@@ -581,9 +586,12 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
 	bio_list_init(&pkt->orig_bios);
 
 	for (i = 0; i < frames; i++) {
-		struct bio *bio = pkt_bio_alloc(1);
+		struct bio *bio = bio_kmalloc(GFP_KERNEL, 1);
 		if (!bio)
 			goto no_rd_bio;
+
+		bio->bi_end_io = pkt_end_io_read;
+		bio->bi_private = pkt;
 		pkt->r_bios[i] = bio;
 	}
 
@@ -1036,40 +1044,6 @@ static void pkt_make_local_copy(struct packet_data *pkt, struct bio_vec *bvec)
 	}
 }
 
-static void pkt_end_io_read(struct bio *bio, int err)
-{
-	struct packet_data *pkt = bio->bi_private;
-	struct pktcdvd_device *pd = pkt->pd;
-	BUG_ON(!pd);
-
-	VPRINTK("pkt_end_io_read: bio=%p sec0=%llx sec=%llx err=%d\n", bio,
-		(unsigned long long)pkt->sector, (unsigned long long)bio->bi_sector, err);
-
-	if (err)
-		atomic_inc(&pkt->io_errors);
-	if (atomic_dec_and_test(&pkt->io_wait)) {
-		atomic_inc(&pkt->run_sm);
-		wake_up(&pd->wqueue);
-	}
-	pkt_bio_finished(pd);
-}
-
-static void pkt_end_io_packet_write(struct bio *bio, int err)
-{
-	struct packet_data *pkt = bio->bi_private;
-	struct pktcdvd_device *pd = pkt->pd;
-	BUG_ON(!pd);
-
-	VPRINTK("pkt_end_io_packet_write: id=%d, err=%d\n", pkt->id, err);
-
-	pd->stats.pkt_ended++;
-
-	pkt_bio_finished(pd);
-	atomic_dec(&pkt->io_wait);
-	atomic_inc(&pkt->run_sm);
-	wake_up(&pd->wqueue);
-}
-
 /*
  * Schedule reads for the holes in a packet
  */
@@ -1111,21 +1085,15 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 	 * Schedule reads for missing parts of the packet.
 	 */
 	for (f = 0; f < pkt->frames; f++) {
-		struct bio_vec *vec;
-
 		int p, offset;
+
 		if (written[f])
 			continue;
+
 		bio = pkt->r_bios[f];
-		vec = bio->bi_io_vec;
-		bio_init(bio);
-		bio->bi_max_vecs = 1;
-		bio->bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
-		bio->bi_bdev = pd->bdev;
-		bio->bi_end_io = pkt_end_io_read;
-		bio->bi_private = pkt;
-		bio->bi_io_vec = vec;
-		bio->bi_destructor = pkt_bio_destructor;
+		bio_reset(bio);
+		bio->bi_sector	= pkt->sector + f * (CD_FRAMESIZE >> 9);
+		bio->bi_bdev	= pd->bdev;
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
 		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
@@ -1418,14 +1386,9 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	}
 
 	/* Start the write request */
-	bio_init(pkt->w_bio);
-	pkt->w_bio->bi_max_vecs = PACKET_MAX_SIZE;
+	bio_reset(pkt->w_bio);
 	pkt->w_bio->bi_sector = pkt->sector;
 	pkt->w_bio->bi_bdev = pd->bdev;
-	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
-	pkt->w_bio->bi_private = pkt;
-	pkt->w_bio->bi_io_vec = bvec;
-	pkt->w_bio->bi_destructor = pkt_bio_destructor;
 	for (f = 0; f < pkt->frames; f++)
 		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
 			BUG();
-- 
1.7.9.rc2

