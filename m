Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1IGQtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:49:20 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48576 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab1IGQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:45:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/14] drbd: Preallocate one page per drbd_socket as a receive buffer
Date: Wed,  7 Sep 2011 16:17:34 +0200
Message-Id: <1315405061-1473-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
References: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    4 ++-
 drivers/block/drbd/drbd_main.c     |   22 ++++++++++++
 drivers/block/drbd/drbd_receiver.c |   65 ++++++++++++++++--------------------
 3 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 47a435a..4a4ecec 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -554,6 +554,8 @@ struct p_delay_probe93 {
 #error "PAGE_SIZE too small"
 #endif
 
+#define DRBD_SOCKET_BUFFER_SIZE 4096
+
 union p_polymorph {
         struct p_header           header;
         struct p_handshake       handshake;
@@ -803,7 +805,7 @@ struct drbd_socket {
 	/* this way we get our
 	 * send/receive buffers off the stack */
 	union p_polymorph sbuf;
-	union p_polymorph rbuf;
+	void *rbuf;
 };
 
 struct drbd_md {
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 54778e9..7b6da0e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2274,6 +2274,19 @@ found:
 	return tconn;
 }
 
+static int drbd_alloc_socket(struct drbd_socket *socket)
+{
+	socket->rbuf = (void *) __get_free_page(GFP_KERNEL);
+	if (!socket->rbuf)
+		return -ENOMEM;
+	return 0;
+}
+
+static void drbd_free_socket(struct drbd_socket *socket)
+{
+	free_page((unsigned long) socket->rbuf);
+}
+
 struct drbd_tconn *drbd_new_tconn(const char *name)
 {
 	struct drbd_tconn *tconn;
@@ -2286,6 +2299,11 @@ struct drbd_tconn *drbd_new_tconn(const char *name)
 	if (!tconn->name)
 		goto fail;
 
+	if (drbd_alloc_socket(&tconn->data))
+		goto fail;
+	if (drbd_alloc_socket(&tconn->meta))
+		goto fail;
+
 	if (!zalloc_cpumask_var(&tconn->cpu_mask, GFP_KERNEL))
 		goto fail;
 
@@ -2324,6 +2342,8 @@ struct drbd_tconn *drbd_new_tconn(const char *name)
 fail:
 	tl_cleanup(tconn);
 	free_cpumask_var(tconn->cpu_mask);
+	drbd_free_socket(&tconn->meta);
+	drbd_free_socket(&tconn->data);
 	kfree(tconn->name);
 	kfree(tconn);
 
@@ -2336,6 +2356,8 @@ void drbd_free_tconn(struct drbd_tconn *tconn)
 	idr_destroy(&tconn->volumes);
 
 	free_cpumask_var(tconn->cpu_mask);
+	drbd_free_socket(&tconn->meta);
+	drbd_free_socket(&tconn->data);
 	kfree(tconn->name);
 	kfree(tconn->int_dig_out);
 	kfree(tconn->int_dig_in);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 08140d9..3738d56 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -743,7 +743,7 @@ static int drbd_send_fp(struct drbd_tconn *tconn, struct socket *sock, enum drbd
 
 static enum drbd_packet drbd_recv_fp(struct drbd_tconn *tconn, struct socket *sock)
 {
-	struct p_header80 *h = &tconn->data.rbuf.header.h80;
+	struct p_header80 *h = tconn->data.rbuf;
 	int rr;
 
 	rr = drbd_recv_short(sock, h, sizeof(*h), 0);
@@ -997,7 +997,7 @@ static int decode_header(struct drbd_tconn *tconn, struct p_header *h, struct pa
 
 static int drbd_recv_header(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_header *h = &tconn->data.rbuf.header;
+	struct p_header *h = tconn->data.rbuf;
 	int err;
 
 	err = drbd_recv_all_warn(tconn, h, sizeof(*h));
@@ -1239,7 +1239,7 @@ static int receive_Barrier(struct drbd_conf *mdev, enum drbd_packet cmd,
 			   unsigned int data_size)
 {
 	int rv;
-	struct p_barrier *p = &mdev->tconn->data.rbuf.barrier;
+	struct p_barrier *p = mdev->tconn->data.rbuf;
 	struct drbd_epoch *epoch;
 
 	inc_unacked(mdev);
@@ -1549,7 +1549,7 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 	struct drbd_request *req;
 	sector_t sector;
 	int err;
-	struct p_data *p = &mdev->tconn->data.rbuf.data;
+	struct p_data *p = mdev->tconn->data.rbuf;
 
 	sector = be64_to_cpu(p->sector);
 
@@ -1577,7 +1577,7 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 {
 	sector_t sector;
 	int err;
-	struct p_data *p = &mdev->tconn->data.rbuf.data;
+	struct p_data *p = mdev->tconn->data.rbuf;
 
 	sector = be64_to_cpu(p->sector);
 	D_ASSERT(p->block_id == ID_SYNCER);
@@ -1966,7 +1966,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 {
 	sector_t sector;
 	struct drbd_peer_request *peer_req;
-	struct p_data *p = &mdev->tconn->data.rbuf.data;
+	struct p_data *p = mdev->tconn->data.rbuf;
 	u32 peer_seq = be32_to_cpu(p->seq_num);
 	int rw = WRITE;
 	u32 dp_flags;
@@ -2150,7 +2150,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 	struct digest_info *di = NULL;
 	int size, verb;
 	unsigned int fault_type;
-	struct p_block_req *p =	&mdev->tconn->data.rbuf.block_req;
+	struct p_block_req *p =	mdev->tconn->data.rbuf;
 
 	sector = be64_to_cpu(p->sector);
 	size   = be32_to_cpu(p->blksize);
@@ -2870,7 +2870,7 @@ static int cmp_after_sb(enum drbd_after_sb_p peer, enum drbd_after_sb_p self)
 static int receive_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd,
 			    unsigned int data_size)
 {
-	struct p_protocol *p = &tconn->data.rbuf.protocol;
+	struct p_protocol *p = tconn->data.rbuf;
 	int p_proto, p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
 	int p_want_lose, p_two_primaries, cf;
 	char p_integrity_alg[SHARED_SECRET_MAX] = "";
@@ -2972,7 +2972,7 @@ struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_conf *mdev,
 static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 			     unsigned int packet_size)
 {
-	struct p_rs_param_95 *p = &mdev->tconn->data.rbuf.rs_param_95;
+	struct p_rs_param_95 *p = mdev->tconn->data.rbuf;
 	unsigned int header_size, data_size, exp_max_sz;
 	struct crypto_hash *verify_tfm = NULL;
 	struct crypto_hash *csums_tfm = NULL;
@@ -3139,7 +3139,7 @@ static void warn_if_differ_considerably(struct drbd_conf *mdev,
 static int receive_sizes(struct drbd_conf *mdev, enum drbd_packet cmd,
 			 unsigned int data_size)
 {
-	struct p_sizes *p = &mdev->tconn->data.rbuf.sizes;
+	struct p_sizes *p = mdev->tconn->data.rbuf;
 	enum determine_dev_size dd = unchanged;
 	sector_t p_size, p_usize, my_usize;
 	int ldsc = 0; /* local disk size changed */
@@ -3237,7 +3237,7 @@ static int receive_sizes(struct drbd_conf *mdev, enum drbd_packet cmd,
 static int receive_uuids(struct drbd_conf *mdev, enum drbd_packet cmd,
 			 unsigned int data_size)
 {
-	struct p_uuids *p = &mdev->tconn->data.rbuf.uuids;
+	struct p_uuids *p = mdev->tconn->data.rbuf;
 	u64 *p_uuid;
 	int i, updated_uuids = 0;
 
@@ -3333,7 +3333,7 @@ static union drbd_state convert_state(union drbd_state ps)
 static int receive_req_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 			     unsigned int data_size)
 {
-	struct p_req_state *p = &mdev->tconn->data.rbuf.req_state;
+	struct p_req_state *p = mdev->tconn->data.rbuf;
 	union drbd_state mask, val;
 	enum drbd_state_rv rv;
 
@@ -3360,7 +3360,7 @@ static int receive_req_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 static int receive_req_conn_state(struct drbd_tconn *tconn, enum drbd_packet cmd,
 				  unsigned int data_size)
 {
-	struct p_req_state *p = &tconn->data.rbuf.req_state;
+	struct p_req_state *p = tconn->data.rbuf;
 	union drbd_state mask, val;
 	enum drbd_state_rv rv;
 
@@ -3385,7 +3385,7 @@ static int receive_req_conn_state(struct drbd_tconn *tconn, enum drbd_packet cmd
 static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 			 unsigned int data_size)
 {
-	struct p_state *p = &mdev->tconn->data.rbuf.state;
+	struct p_state *p = mdev->tconn->data.rbuf;
 	union drbd_state os, ns, peer_state;
 	enum drbd_disk_state real_peer_disk;
 	enum chg_state_flags cs_flags;
@@ -3538,7 +3538,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 static int receive_sync_uuid(struct drbd_conf *mdev, enum drbd_packet cmd,
 			     unsigned int data_size)
 {
-	struct p_rs_uuid *p = &mdev->tconn->data.rbuf.rs_uuid;
+	struct p_rs_uuid *p = mdev->tconn->data.rbuf;
 
 	wait_event(mdev->misc_wait,
 		   mdev->state.conn == C_WF_SYNC_UUID ||
@@ -3750,7 +3750,7 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 	struct bm_xfer_ctx c;
 	void *buffer;
 	int err;
-	struct p_header *h = &mdev->tconn->data.rbuf.header;
+	struct p_header *h = mdev->tconn->data.rbuf;
 	struct packet_info pi;
 
 	drbd_bm_lock(mdev, "receive bitmap", BM_LOCKED_SET_ALLOWED);
@@ -3891,7 +3891,7 @@ static int receive_UnplugRemote(struct drbd_conf *mdev, enum drbd_packet cmd,
 static int receive_out_of_sync(struct drbd_conf *mdev, enum drbd_packet cmd,
 			       unsigned int data_size)
 {
-	struct p_block_desc *p = &mdev->tconn->data.rbuf.block_desc;
+	struct p_block_desc *p = mdev->tconn->data.rbuf;
 
 	switch (mdev->state.conn) {
 	case C_WF_SYNC_UUID:
@@ -3946,16 +3946,9 @@ static struct data_cmd drbd_cmd_handler[] = {
 	[P_CONN_ST_CHG_REQ] = { 0, sizeof(struct p_req_state), CONN, { .conn_fn = receive_req_conn_state } },
 };
 
-/* All handler functions that expect a sub-header get that sub-heder in
-   mdev->tconn->data.rbuf.header.head.payload.
-
-   Usually in mdev->tconn->data.rbuf.header.head the callback can find the usual
-   p_header, but they may not rely on that. Since there is also p_header95 !
- */
-
 static void drbdd(struct drbd_tconn *tconn)
 {
-	struct p_header *header = &tconn->data.rbuf.header;
+	struct p_header *header = tconn->data.rbuf;
 	struct packet_info pi;
 	size_t shs; /* sub header size */
 	int err;
@@ -4186,7 +4179,7 @@ static int drbd_send_handshake(struct drbd_tconn *tconn)
 static int drbd_do_handshake(struct drbd_tconn *tconn)
 {
 	/* ASSERT current == tconn->receiver ... */
-	struct p_handshake *p = &tconn->data.rbuf.handshake;
+	struct p_handshake *p = tconn->data.rbuf;
 	const int expect = sizeof(struct p_handshake) - sizeof(struct p_header80);
 	struct packet_info pi;
 	int err;
@@ -4433,7 +4426,7 @@ int drbdd_init(struct drbd_thread *thi)
 
 static int got_conn_RqSReply(struct drbd_tconn *tconn, enum drbd_packet cmd)
 {
-	struct p_req_state_reply *p = &tconn->meta.rbuf.req_state_reply;
+	struct p_req_state_reply *p = tconn->meta.rbuf;
 	int retcode = be32_to_cpu(p->retcode);
 
 	if (retcode >= SS_SUCCESS) {
@@ -4450,7 +4443,7 @@ static int got_conn_RqSReply(struct drbd_tconn *tconn, enum drbd_packet cmd)
 
 static int got_RqSReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
-	struct p_req_state_reply *p = &mdev->tconn->meta.rbuf.req_state_reply;
+	struct p_req_state_reply *p = mdev->tconn->meta.rbuf;
 	int retcode = be32_to_cpu(p->retcode);
 
 	if (retcode >= SS_SUCCESS) {
@@ -4483,7 +4476,7 @@ static int got_PingAck(struct drbd_tconn *tconn, enum drbd_packet cmd)
 
 static int got_IsInSync(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
-	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
+	struct p_block_ack *p = mdev->tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 
@@ -4528,7 +4521,7 @@ validate_req_change_req_state(struct drbd_conf *mdev, u64 id, sector_t sector,
 
 static int got_BlockAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
-	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
+	struct p_block_ack *p = mdev->tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 	enum drbd_req_event what;
@@ -4573,7 +4566,7 @@ static int got_BlockAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 
 static int got_NegAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
-	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
+	struct p_block_ack *p = mdev->tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
 	int size = be32_to_cpu(p->blksize);
 	bool missing_ok = mdev->tconn->net_conf->wire_protocol == DRBD_PROT_A ||
@@ -4606,7 +4599,7 @@ static int got_NegAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 
 static int got_NegDReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
-	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
+	struct p_block_ack *p = mdev->tconn->meta.rbuf;
 	sector_t sector = be64_to_cpu(p->sector);
 
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
@@ -4623,7 +4616,7 @@ static int got_NegRSDReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	sector_t sector;
 	int size;
-	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
+	struct p_block_ack *p = mdev->tconn->meta.rbuf;
 
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
@@ -4652,7 +4645,7 @@ static int got_NegRSDReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 
 static int got_BarrierAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
-	struct p_barrier_ack *p = &mdev->tconn->meta.rbuf.barrier_ack;
+	struct p_barrier_ack *p = mdev->tconn->meta.rbuf;
 
 	tl_release(mdev->tconn, p->barrier, be32_to_cpu(p->set_size));
 
@@ -4668,7 +4661,7 @@ static int got_BarrierAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 
 static int got_OVResult(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
-	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
+	struct p_block_ack *p = mdev->tconn->meta.rbuf;
 	struct drbd_work *w;
 	sector_t sector;
 	int size;
@@ -4774,7 +4767,7 @@ static struct asender_cmd asender_tbl[] = {
 int drbd_asender(struct drbd_thread *thi)
 {
 	struct drbd_tconn *tconn = thi->tconn;
-	struct p_header *h = &tconn->meta.rbuf.header;
+	struct p_header *h = tconn->meta.rbuf;
 	struct asender_cmd *cmd = NULL;
 	struct packet_info pi;
 	int rv;
-- 
1.7.4.1

