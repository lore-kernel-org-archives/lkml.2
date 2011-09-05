Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1IELsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:48:53 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60521 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1IELqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:16 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 54/54] drbd: Introduce and use drbd_recv_all_warn()
Date: Mon,  5 Sep 2011 13:45:45 +0200
Message-Id: <1315223145-20640-55-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The pattern of receiving a fixed number of bytes and warning if a short
packet is received and the receiver has not actively been interruped is
repeated many times; clean that up.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |  113 +++++++++++++-----------------------
 1 files changed, 40 insertions(+), 73 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 74b9428..8557a4c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -577,6 +577,16 @@ static int drbd_recv_all(struct drbd_tconn *tconn, void *buf, size_t size)
 	return err;
 }
 
+static int drbd_recv_all_warn(struct drbd_tconn *tconn, void *buf, size_t size)
+{
+	int err;
+
+	err = drbd_recv_all(tconn, buf, size);
+	if (err && !signal_pending(current))
+		conn_warn(tconn, "short read (expected size %d)\n", (int)size);
+	return err;
+}
+
 /* quoting tcp(7):
  *   On individual connections, the socket buffer size must be set prior to the
  *   listen(2) or connect(2) calls in order to have it take effect.
@@ -988,14 +998,9 @@ static int drbd_recv_header(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct p_header *h = &tconn->data.rbuf.header;
 	int err;
 
-	err = drbd_recv(tconn, h, sizeof(*h));
-	if (unlikely(err != sizeof(*h))) {
-		if (!signal_pending(current))
-			conn_warn(tconn, "short read expecting header on sock: r=%d\n", err);
-		if (err >= 0)
-			err = -EIO;
+	err = drbd_recv_all_warn(tconn, h, sizeof(*h));
+	if (err)
 		return err;
-	}
 
 	err = decode_header(tconn, h, pi);
 	tconn->last_received = jiffies;
@@ -1309,7 +1314,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
 	struct drbd_peer_request *peer_req;
 	struct page *page;
-	int dgs, ds, rr;
+	int dgs, ds, err;
 	void *dig_in = mdev->tconn->int_dig_in;
 	void *dig_vv = mdev->tconn->int_dig_vv;
 	unsigned long *data;
@@ -1318,14 +1323,9 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
 
 	if (dgs) {
-		rr = drbd_recv(mdev->tconn, dig_in, dgs);
-		if (rr != dgs) {
-			if (!signal_pending(current))
-				dev_warn(DEV,
-					"short read receiving data digest: read %d expected %d\n",
-					rr, dgs);
+		err = drbd_recv_all_warn(mdev->tconn, dig_in, dgs);
+		if (err)
 			return NULL;
-		}
 	}
 
 	data_size -= dgs;
@@ -1359,20 +1359,17 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 	page_chain_for_each(page) {
 		unsigned len = min_t(int, ds, PAGE_SIZE);
 		data = kmap(page);
-		rr = drbd_recv(mdev->tconn, data, len);
+		err = drbd_recv_all_warn(mdev->tconn, data, len);
 		if (drbd_insert_fault(mdev, DRBD_FAULT_RECEIVE)) {
 			dev_err(DEV, "Fault injection: Corrupting data on receive\n");
 			data[0] = data[0] ^ (unsigned long)-1;
 		}
 		kunmap(page);
-		if (rr != len) {
+		if (err) {
 			drbd_free_ee(mdev, peer_req);
-			if (!signal_pending(current))
-				dev_warn(DEV, "short read receiving data: read %d expected %d\n",
-				rr, len);
 			return NULL;
 		}
-		ds -= rr;
+		ds -= len;
 	}
 
 	if (dgs) {
@@ -1394,7 +1391,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 static int drbd_drain_block(struct drbd_conf *mdev, int data_size)
 {
 	struct page *page;
-	int rr, err = 0;
+	int err = 0;
 	void *data;
 
 	if (!data_size)
@@ -1406,16 +1403,10 @@ static int drbd_drain_block(struct drbd_conf *mdev, int data_size)
 	while (data_size) {
 		unsigned int len = min_t(int, data_size, PAGE_SIZE);
 
-		rr = drbd_recv(mdev->tconn, data, len);
-		if (rr != len) {
-			if (!signal_pending(current))
-				dev_warn(DEV,
-					"short read receiving data: read %d expected %d\n",
-					rr, len);
-			err = (rr < 0) ? rr : -EIO;
+		err = drbd_recv_all_warn(mdev->tconn, data, len);
+		if (err)
 			break;
-		}
-		data_size -= rr;
+		data_size -= len;
 	}
 	kunmap(page);
 	drbd_pp_free(mdev, page, 0);
@@ -1427,7 +1418,7 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 {
 	struct bio_vec *bvec;
 	struct bio *bio;
-	int dgs, rr, i, expect;
+	int dgs, err, i, expect;
 	void *dig_in = mdev->tconn->int_dig_in;
 	void *dig_vv = mdev->tconn->int_dig_vv;
 
@@ -1435,14 +1426,9 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
 
 	if (dgs) {
-		rr = drbd_recv(mdev->tconn, dig_in, dgs);
-		if (rr != dgs) {
-			if (!signal_pending(current))
-				dev_warn(DEV,
-					"short read receiving data reply digest: read %d expected %d\n",
-					rr, dgs);
-			return rr < 0 ? rr : -EIO;
-		}
+		err = drbd_recv_all_warn(mdev->tconn, dig_in, dgs);
+		if (err)
+			return err;
 	}
 
 	data_size -= dgs;
@@ -1455,19 +1441,13 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 	D_ASSERT(sector == bio->bi_sector);
 
 	bio_for_each_segment(bvec, bio, i) {
+		void *mapped = kmap(bvec->bv_page) + bvec->bv_offset;
 		expect = min_t(int, data_size, bvec->bv_len);
-		rr = drbd_recv(mdev->tconn,
-			     kmap(bvec->bv_page)+bvec->bv_offset,
-			     expect);
+		err = drbd_recv_all_warn(mdev->tconn, mapped, expect);
 		kunmap(bvec->bv_page);
-		if (rr != expect) {
-			if (!signal_pending(current))
-				dev_warn(DEV, "short read receiving data reply: "
-					"read %d expected %d\n",
-					rr, expect);
-			return rr < 0 ? rr : -EIO;
-		}
-		data_size -= rr;
+		if (err)
+			return err;
+		data_size -= expect;
 	}
 
 	if (dgs) {
@@ -3981,12 +3961,9 @@ static void drbdd(struct drbd_tconn *tconn)
 		}
 
 		if (shs) {
-			err = drbd_recv_all(tconn, &header->payload, shs);
-			if (err) {
-				if (!signal_pending(current))
-					conn_warn(tconn, "short read while reading sub header: rv=%d\n", err);
+			err = drbd_recv_all_warn(tconn, &header->payload, shs);
+			if (err)
 				goto err_out;
-			}
 		}
 
 		if (drbd_cmd_handler[pi.cmd].fa_type == CONN) {
@@ -4196,7 +4173,7 @@ static int drbd_do_handshake(struct drbd_tconn *tconn)
 	struct p_handshake *p = &tconn->data.rbuf.handshake;
 	const int expect = sizeof(struct p_handshake) - sizeof(struct p_header80);
 	struct packet_info pi;
-	int err, rv;
+	int err;
 
 	err = drbd_send_handshake(tconn);
 	if (err)
@@ -4218,13 +4195,9 @@ static int drbd_do_handshake(struct drbd_tconn *tconn)
 		return -1;
 	}
 
-	rv = drbd_recv(tconn, &p->head.payload, expect);
-
-	if (rv != expect) {
-		if (!signal_pending(current))
-			conn_warn(tconn, "short read receiving handshake packet: l=%u\n", rv);
+	err = drbd_recv_all_warn(tconn, &p->head.payload, expect);
+	if (err)
 		return 0;
-	}
 
 	p->protocol_min = be32_to_cpu(p->protocol_min);
 	p->protocol_max = be32_to_cpu(p->protocol_max);
@@ -4322,11 +4295,8 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 		goto fail;
 	}
 
-	rv = drbd_recv(tconn, peers_ch, pi.size);
-
-	if (rv != pi.size) {
-		if (!signal_pending(current))
-			conn_warn(tconn, "short read AuthChallenge: l=%u\n", rv);
+	err = drbd_recv_all_warn(tconn, peers_ch, pi.size);
+	if (err) {
 		rv = 0;
 		goto fail;
 	}
@@ -4372,11 +4342,8 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 		goto fail;
 	}
 
-	rv = drbd_recv(tconn, response , resp_size);
-
-	if (rv != resp_size) {
-		if (!signal_pending(current))
-			conn_warn(tconn, "short read receiving AuthResponse: l=%u\n", rv);
+	err = drbd_recv_all_warn(tconn, response , resp_size);
+	if (err) {
 		rv = 0;
 		goto fail;
 	}
-- 
1.7.4.1

