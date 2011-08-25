Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1HYPJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:18 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32976 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1HYPJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 035/118] drbd: moved crypto transformations and friends from mdev to tconn
Date: Thu, 25 Aug 2011 17:07:31 +0200
Message-Id: <1314284934-17999-36-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sed -i \
       -e 's/mdev->cram_hmac_tfm/mdev->tconn->cram_hmac_tfm/g' \
       -e 's/mdev->integrity_w_tfm/mdev->tconn->integrity_w_tfm/g' \
       -e 's/mdev->integrity_r_tfm/mdev->tconn->integrity_r_tfm/g' \
       -e 's/mdev->int_dig_out/mdev->tconn->int_dig_out/g' \
       -e 's/mdev->int_dig_in/mdev->tconn->int_dig_in/g' \
       -e 's/mdev->int_dig_vv/mdev->tconn->int_dig_vv/g' \
       *.[ch]

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   13 ++++++-----
 drivers/block/drbd/drbd_main.c     |   42 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_nl.c       |   24 ++++++++++----------
 drivers/block/drbd/drbd_receiver.c |   32 +++++++++++++-------------
 4 files changed, 56 insertions(+), 55 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 0e9debe..65f0e78 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -982,6 +982,13 @@ struct drbd_tconn {			/* is a resource from the config file */
 	struct drbd_tl_epoch *oldest_tle;
 	struct list_head out_of_sequence_requests;
 
+	struct crypto_hash *cram_hmac_tfm;
+	struct crypto_hash *integrity_w_tfm; /* to be used by the worker thread */
+	struct crypto_hash *integrity_r_tfm; /* to be used by the receiver thread */
+	void *int_dig_out;
+	void *int_dig_in;
+	void *int_dig_vv;
+
 	struct drbd_thread receiver;
 	struct drbd_thread worker;
 	struct drbd_thread asender;
@@ -1114,12 +1121,6 @@ struct drbd_conf {
 	unsigned int al_tr_number;
 	int al_tr_cycle;
 	int al_tr_pos;   /* position of the next transaction in the journal */
-	struct crypto_hash *cram_hmac_tfm;
-	struct crypto_hash *integrity_w_tfm; /* to be used by the worker thread */
-	struct crypto_hash *integrity_r_tfm; /* to be used by the receiver thread */
-	void *int_dig_out;
-	void *int_dig_in;
-	void *int_dig_vv;
 	wait_queue_head_t seq_wait;
 	atomic_t packet_seq;
 	unsigned int peer_seq;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c063cd5..699f639 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2404,8 +2404,8 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packets cmd,
 int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packets cmd,
 		     struct p_data *dp, int data_size)
 {
-	data_size -= (mdev->tconn->agreed_pro_version >= 87 && mdev->integrity_r_tfm) ?
-		crypto_hash_digestsize(mdev->integrity_r_tfm) : 0;
+	data_size -= (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_r_tfm) ?
+		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
 	return _drbd_send_ack(mdev, cmd, dp->sector, cpu_to_be32(data_size),
 			      dp->block_id);
 }
@@ -2670,8 +2670,8 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	if (!drbd_get_data_sock(mdev))
 		return 0;
 
-	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->integrity_w_tfm) ?
-		crypto_hash_digestsize(mdev->integrity_w_tfm) : 0;
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
+		crypto_hash_digestsize(mdev->tconn->integrity_w_tfm) : 0;
 
 	if (req->i.size <= DRBD_MAX_SIZE_H80_PACKET) {
 		p.head.h80.magic   = cpu_to_be32(DRBD_MAGIC);
@@ -2701,8 +2701,8 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	ok = (sizeof(p) ==
 		drbd_send(mdev, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0));
 	if (ok && dgs) {
-		dgb = mdev->int_dig_out;
-		drbd_csum_bio(mdev, mdev->integrity_w_tfm, req->master_bio, dgb);
+		dgb = mdev->tconn->int_dig_out;
+		drbd_csum_bio(mdev, mdev->tconn->integrity_w_tfm, req->master_bio, dgb);
 		ok = dgs == drbd_send(mdev, mdev->tconn->data.socket, dgb, dgs, 0);
 	}
 	if (ok) {
@@ -2727,8 +2727,8 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 			/* 64 byte, 512 bit, is the largest digest size
 			 * currently supported in kernel crypto. */
 			unsigned char digest[64];
-			drbd_csum_bio(mdev, mdev->integrity_w_tfm, req->master_bio, digest);
-			if (memcmp(mdev->int_dig_out, digest, dgs)) {
+			drbd_csum_bio(mdev, mdev->tconn->integrity_w_tfm, req->master_bio, digest);
+			if (memcmp(mdev->tconn->int_dig_out, digest, dgs)) {
 				dev_warn(DEV,
 					"Digest mismatch, buffer modified by upper layers during write: %llus +%u\n",
 					(unsigned long long)req->i.sector, req->i.size);
@@ -2755,8 +2755,8 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packets cmd,
 	void *dgb;
 	int dgs;
 
-	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->integrity_w_tfm) ?
-		crypto_hash_digestsize(mdev->integrity_w_tfm) : 0;
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
+		crypto_hash_digestsize(mdev->tconn->integrity_w_tfm) : 0;
 
 	if (e->i.size <= DRBD_MAX_SIZE_H80_PACKET) {
 		p.head.h80.magic   = cpu_to_be32(DRBD_MAGIC);
@@ -2783,8 +2783,8 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packets cmd,
 
 	ok = sizeof(p) == drbd_send(mdev, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0);
 	if (ok && dgs) {
-		dgb = mdev->int_dig_out;
-		drbd_csum_ee(mdev, mdev->integrity_w_tfm, e, dgb);
+		dgb = mdev->tconn->int_dig_out;
+		drbd_csum_ee(mdev, mdev->tconn->integrity_w_tfm, e, dgb);
 		ok = dgs == drbd_send(mdev, mdev->tconn->data.socket, dgb, dgs, 0);
 	}
 	if (ok)
@@ -3276,9 +3276,9 @@ static void drbd_delete_device(unsigned int minor)
 	kfree(mdev->p_uuid);
 	/* mdev->p_uuid = NULL; */
 
-	kfree(mdev->int_dig_out);
-	kfree(mdev->int_dig_in);
-	kfree(mdev->int_dig_vv);
+	kfree(mdev->tconn->int_dig_out);
+	kfree(mdev->tconn->int_dig_in);
+	kfree(mdev->tconn->int_dig_vv);
 
 	/* cleanup the rest that has been
 	 * allocated from drbd_new_device
@@ -3629,12 +3629,12 @@ void drbd_free_resources(struct drbd_conf *mdev)
 	mdev->csums_tfm = NULL;
 	crypto_free_hash(mdev->verify_tfm);
 	mdev->verify_tfm = NULL;
-	crypto_free_hash(mdev->cram_hmac_tfm);
-	mdev->cram_hmac_tfm = NULL;
-	crypto_free_hash(mdev->integrity_w_tfm);
-	mdev->integrity_w_tfm = NULL;
-	crypto_free_hash(mdev->integrity_r_tfm);
-	mdev->integrity_r_tfm = NULL;
+	crypto_free_hash(mdev->tconn->cram_hmac_tfm);
+	mdev->tconn->cram_hmac_tfm = NULL;
+	crypto_free_hash(mdev->tconn->integrity_w_tfm);
+	mdev->tconn->integrity_w_tfm = NULL;
+	crypto_free_hash(mdev->tconn->integrity_r_tfm);
+	mdev->tconn->integrity_r_tfm = NULL;
 
 	drbd_free_sock(mdev);
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 4eaf81a..0836808 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1532,21 +1532,21 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	mdev->send_cnt = 0;
 	mdev->recv_cnt = 0;
 
-	crypto_free_hash(mdev->cram_hmac_tfm);
-	mdev->cram_hmac_tfm = tfm;
+	crypto_free_hash(mdev->tconn->cram_hmac_tfm);
+	mdev->tconn->cram_hmac_tfm = tfm;
 
-	crypto_free_hash(mdev->integrity_w_tfm);
-	mdev->integrity_w_tfm = integrity_w_tfm;
+	crypto_free_hash(mdev->tconn->integrity_w_tfm);
+	mdev->tconn->integrity_w_tfm = integrity_w_tfm;
 
-	crypto_free_hash(mdev->integrity_r_tfm);
-	mdev->integrity_r_tfm = integrity_r_tfm;
+	crypto_free_hash(mdev->tconn->integrity_r_tfm);
+	mdev->tconn->integrity_r_tfm = integrity_r_tfm;
 
-	kfree(mdev->int_dig_out);
-	kfree(mdev->int_dig_in);
-	kfree(mdev->int_dig_vv);
-	mdev->int_dig_out=int_dig_out;
-	mdev->int_dig_in=int_dig_in;
-	mdev->int_dig_vv=int_dig_vv;
+	kfree(mdev->tconn->int_dig_out);
+	kfree(mdev->tconn->int_dig_in);
+	kfree(mdev->tconn->int_dig_vv);
+	mdev->tconn->int_dig_out=int_dig_out;
+	mdev->tconn->int_dig_in=int_dig_in;
+	mdev->tconn->int_dig_vv=int_dig_vv;
 	retcode = _drbd_set_state(_NS(mdev, conn, C_UNCONNECTED), CS_VERBOSE, NULL);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index af968a0b..4b37010 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -880,7 +880,7 @@ retry:
 	if (h <= 0)
 		return h;
 
-	if (mdev->cram_hmac_tfm) {
+	if (mdev->tconn->cram_hmac_tfm) {
 		/* drbd_request_state(mdev, NS(conn, WFAuth)); */
 		switch (drbd_do_auth(mdev)) {
 		case -1:
@@ -1240,12 +1240,12 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector, int data_size) __
 	struct drbd_epoch_entry *e;
 	struct page *page;
 	int dgs, ds, rr;
-	void *dig_in = mdev->int_dig_in;
-	void *dig_vv = mdev->int_dig_vv;
+	void *dig_in = mdev->tconn->int_dig_in;
+	void *dig_vv = mdev->tconn->int_dig_vv;
 	unsigned long *data;
 
-	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->integrity_r_tfm) ?
-		crypto_hash_digestsize(mdev->integrity_r_tfm) : 0;
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_r_tfm) ?
+		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
 
 	if (dgs) {
 		rr = drbd_recv(mdev, dig_in, dgs);
@@ -1306,7 +1306,7 @@ read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector, int data_size) __
 	}
 
 	if (dgs) {
-		drbd_csum_ee(mdev, mdev->integrity_r_tfm, e, dig_vv);
+		drbd_csum_ee(mdev, mdev->tconn->integrity_r_tfm, e, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED: %llus +%u\n",
 				(unsigned long long)sector, data_size);
@@ -1358,11 +1358,11 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 	struct bio_vec *bvec;
 	struct bio *bio;
 	int dgs, rr, i, expect;
-	void *dig_in = mdev->int_dig_in;
-	void *dig_vv = mdev->int_dig_vv;
+	void *dig_in = mdev->tconn->int_dig_in;
+	void *dig_vv = mdev->tconn->int_dig_vv;
 
-	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->integrity_r_tfm) ?
-		crypto_hash_digestsize(mdev->integrity_r_tfm) : 0;
+	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_r_tfm) ?
+		crypto_hash_digestsize(mdev->tconn->integrity_r_tfm) : 0;
 
 	if (dgs) {
 		rr = drbd_recv(mdev, dig_in, dgs);
@@ -1401,7 +1401,7 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 	}
 
 	if (dgs) {
-		drbd_csum_bio(mdev, mdev->integrity_r_tfm, bio, dig_vv);
+		drbd_csum_bio(mdev, mdev->tconn->integrity_r_tfm, bio, dig_vv);
 		if (memcmp(dig_in, dig_vv, dgs)) {
 			dev_err(DEV, "Digest integrity check FAILED. Broken NICs?\n");
 			return 0;
@@ -3841,8 +3841,8 @@ static void drbd_disconnect(struct drbd_conf *mdev)
 	if (os.conn == C_DISCONNECTING) {
 		wait_event(mdev->tconn->net_cnt_wait, atomic_read(&mdev->tconn->net_cnt) == 0);
 
-		crypto_free_hash(mdev->cram_hmac_tfm);
-		mdev->cram_hmac_tfm = NULL;
+		crypto_free_hash(mdev->tconn->cram_hmac_tfm);
+		mdev->tconn->cram_hmac_tfm = NULL;
 
 		kfree(mdev->tconn->net_conf);
 		mdev->tconn->net_conf = NULL;
@@ -4012,10 +4012,10 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 	unsigned int length;
 	int rv;
 
-	desc.tfm = mdev->cram_hmac_tfm;
+	desc.tfm = mdev->tconn->cram_hmac_tfm;
 	desc.flags = 0;
 
-	rv = crypto_hash_setkey(mdev->cram_hmac_tfm,
+	rv = crypto_hash_setkey(mdev->tconn->cram_hmac_tfm,
 				(u8 *)mdev->tconn->net_conf->shared_secret, key_len);
 	if (rv) {
 		dev_err(DEV, "crypto_hash_setkey() failed with %d\n", rv);
@@ -4062,7 +4062,7 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 		goto fail;
 	}
 
-	resp_size = crypto_hash_digestsize(mdev->cram_hmac_tfm);
+	resp_size = crypto_hash_digestsize(mdev->tconn->cram_hmac_tfm);
 	response = kmalloc(resp_size, GFP_NOIO);
 	if (response == NULL) {
 		dev_err(DEV, "kmalloc of response failed\n");
-- 
1.7.4.1

