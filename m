Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1HYPT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:19:27 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34634 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab1HYPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:51 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 082/118] drbd: Converted drbd_recv() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:18 +0200
Message-Id: <1314284934-17999-83-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   46 ++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e4aa2d6..6283911 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -498,7 +498,7 @@ static int drbd_recv_short(struct socket *sock, void *buf, size_t size, int flag
 	return rv;
 }
 
-static int drbd_recv(struct drbd_conf *mdev, void *buf, size_t size)
+static int drbd_recv(struct drbd_tconn *tconn, void *buf, size_t size)
 {
 	mm_segment_t oldfs;
 	struct kvec iov = {
@@ -516,7 +516,7 @@ static int drbd_recv(struct drbd_conf *mdev, void *buf, size_t size)
 	set_fs(KERNEL_DS);
 
 	for (;;) {
-		rv = sock_recvmsg(mdev->tconn->data.socket, &msg, size, msg.msg_flags);
+		rv = sock_recvmsg(tconn->data.socket, &msg, size, msg.msg_flags);
 		if (rv == size)
 			break;
 
@@ -527,12 +527,12 @@ static int drbd_recv(struct drbd_conf *mdev, void *buf, size_t size)
 
 		if (rv < 0) {
 			if (rv == -ECONNRESET)
-				dev_info(DEV, "sock was reset by peer\n");
+				conn_info(tconn, "sock was reset by peer\n");
 			else if (rv != -ERESTARTSYS)
-				dev_err(DEV, "sock_recvmsg returned %d\n", rv);
+				conn_err(tconn, "sock_recvmsg returned %d\n", rv);
 			break;
 		} else if (rv == 0) {
-			dev_info(DEV, "sock was shut down by peer\n");
+			conn_info(tconn, "sock was shut down by peer\n");
 			break;
 		} else	{
 			/* signal came in, or peer/link went down,
@@ -546,7 +546,7 @@ static int drbd_recv(struct drbd_conf *mdev, void *buf, size_t size)
 	set_fs(oldfs);
 
 	if (rv != size)
-		drbd_force_state(mdev, NS(conn, C_BROKEN_PIPE));
+		drbd_force_state(tconn->volume0, NS(conn, C_BROKEN_PIPE));
 
 	return rv;
 }
@@ -953,7 +953,7 @@ static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packet *cmd,
 	struct p_header *h = &mdev->tconn->data.rbuf.header;
 	int r;
 
-	r = drbd_recv(mdev, h, sizeof(*h));
+	r = drbd_recv(mdev->tconn, h, sizeof(*h));
 	if (unlikely(r != sizeof(*h))) {
 		if (!signal_pending(current))
 			dev_warn(DEV, "short read expecting header on sock: r=%d\n", r);
@@ -1276,7 +1276,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
 
 	if (dgs) {
-		rr = drbd_recv(mdev, dig_in, dgs);
+		rr = drbd_recv(mdev->tconn, dig_in, dgs);
 		if (rr != dgs) {
 			if (!signal_pending(current))
 				dev_warn(DEV,
@@ -1317,7 +1317,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
 	page_chain_for_each(page) {
 		unsigned len = min_t(int, ds, PAGE_SIZE);
 		data = kmap(page);
-		rr = drbd_recv(mdev, data, len);
+		rr = drbd_recv(mdev->tconn, data, len);
 		if (drbd_insert_fault(mdev, DRBD_FAULT_RECEIVE)) {
 			dev_err(DEV, "Fault injection: Corrupting data on receive\n");
 			data[0] = data[0] ^ (unsigned long)-1;
@@ -1364,7 +1364,7 @@ static int drbd_drain_block(struct drbd_conf *mdev, int data_size)
 
 	data = kmap(page);
 	while (data_size) {
-		rr = drbd_recv(mdev, data, min_t(int, data_size, PAGE_SIZE));
+		rr = drbd_recv(mdev->tconn, data, min_t(int, data_size, PAGE_SIZE));
 		if (rr != min_t(int, data_size, PAGE_SIZE)) {
 			rv = 0;
 			if (!signal_pending(current))
@@ -1393,7 +1393,7 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
 
 	if (dgs) {
-		rr = drbd_recv(mdev, dig_in, dgs);
+		rr = drbd_recv(mdev->tconn, dig_in, dgs);
 		if (rr != dgs) {
 			if (!signal_pending(current))
 				dev_warn(DEV,
@@ -1414,7 +1414,7 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 
 	bio_for_each_segment(bvec, bio, i) {
 		expect = min_t(int, data_size, bvec->bv_len);
-		rr = drbd_recv(mdev,
+		rr = drbd_recv(mdev->tconn,
 			     kmap(bvec->bv_page)+bvec->bv_offset,
 			     expect);
 		kunmap(bvec->bv_page);
@@ -2098,7 +2098,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 		peer_req->digest = di;
 		peer_req->flags |= EE_HAS_DIGEST;
 
-		if (drbd_recv(mdev, di->digest, digest_size) != digest_size)
+		if (drbd_recv(mdev->tconn, di->digest, digest_size) != digest_size)
 			goto out_free_e;
 
 		if (cmd == P_CSUM_RS_REQUEST) {
@@ -2789,7 +2789,7 @@ static int receive_protocol(struct drbd_conf *mdev, enum drbd_packet cmd,
 	if (mdev->tconn->agreed_pro_version >= 87) {
 		unsigned char *my_alg = mdev->tconn->net_conf->integrity_alg;
 
-		if (drbd_recv(mdev, p_integrity_alg, data_size) != data_size)
+		if (drbd_recv(mdev->tconn, p_integrity_alg, data_size) != data_size)
 			return false;
 
 		p_integrity_alg[SHARED_SECRET_MAX-1] = 0;
@@ -2875,7 +2875,7 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 	/* initialize verify_alg and csums_alg */
 	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
-	if (drbd_recv(mdev, &p->head.payload, header_size) != header_size)
+	if (drbd_recv(mdev->tconn, &p->head.payload, header_size) != header_size)
 		return false;
 
 	mdev->sync_conf.rate	  = be32_to_cpu(p->rate);
@@ -2889,7 +2889,7 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 				return false;
 			}
 
-			if (drbd_recv(mdev, p->verify_alg, data_size) != data_size)
+			if (drbd_recv(mdev->tconn, p->verify_alg, data_size) != data_size)
 				return false;
 
 			/* we expect NUL terminated string */
@@ -3428,7 +3428,7 @@ receive_bitmap_plain(struct drbd_conf *mdev, unsigned int data_size,
 	}
 	if (want == 0)
 		return 0;
-	err = drbd_recv(mdev, buffer, want);
+	err = drbd_recv(mdev->tconn, buffer, want);
 	if (err != want) {
 		if (err >= 0)
 			err = -EIO;
@@ -3617,7 +3617,7 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 			/* use the page buff */
 			p = buffer;
 			memcpy(p, h, sizeof(*h));
-			if (drbd_recv(mdev, p->head.payload, data_size) != data_size)
+			if (drbd_recv(mdev->tconn, p->head.payload, data_size) != data_size)
 				goto out;
 			if (data_size <= (sizeof(*p) - sizeof(p->head))) {
 				dev_err(DEV, "ReportCBitmap packet too small (l:%u)\n", data_size);
@@ -3681,7 +3681,7 @@ static int receive_skip(struct drbd_conf *mdev, enum drbd_packet cmd,
 	size = data_size;
 	while (size > 0) {
 		want = min_t(int, size, sizeof(sink));
-		r = drbd_recv(mdev, sink, want);
+		r = drbd_recv(mdev->tconn, sink, want);
 		if (!expect(r > 0))
 			break;
 		size -= r;
@@ -3788,7 +3788,7 @@ static void drbdd(struct drbd_conf *mdev)
 		}
 
 		if (shs) {
-			rv = drbd_recv(mdev, &header->payload, shs);
+			rv = drbd_recv(mdev->tconn, &header->payload, shs);
 			if (unlikely(rv != shs)) {
 				if (!signal_pending(current))
 					dev_warn(DEV, "short read while reading sub header: rv=%d\n", rv);
@@ -4017,7 +4017,7 @@ static int drbd_do_handshake(struct drbd_conf *mdev)
 		return -1;
 	}
 
-	rv = drbd_recv(mdev, &p->head.payload, expect);
+	rv = drbd_recv(mdev->tconn, &p->head.payload, expect);
 
 	if (rv != expect) {
 		if (!signal_pending(current))
@@ -4120,7 +4120,7 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 		goto fail;
 	}
 
-	rv = drbd_recv(mdev, peers_ch, length);
+	rv = drbd_recv(mdev->tconn, peers_ch, length);
 
 	if (rv != length) {
 		if (!signal_pending(current))
@@ -4168,7 +4168,7 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 		goto fail;
 	}
 
-	rv = drbd_recv(mdev, response , resp_size);
+	rv = drbd_recv(mdev->tconn, response , resp_size);
 
 	if (rv != resp_size) {
 		if (!signal_pending(current))
-- 
1.7.4.1

