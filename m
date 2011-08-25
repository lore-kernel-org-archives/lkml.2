Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab1HYPJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:34 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33376 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1HYPJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:16 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 038/118] drbd: Replaced all p_header80 with a generic p_header
Date: Thu, 25 Aug 2011 17:07:34 +0200
Message-Id: <1314284934-17999-39-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   64 ++++++++++++++++++-----------------
 drivers/block/drbd/drbd_main.c     |   54 ++++++++++++------------------
 drivers/block/drbd/drbd_receiver.c |   16 ++++----
 drivers/block/drbd/drbd_worker.c   |    2 +-
 4 files changed, 64 insertions(+), 72 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 75c760f..9d0ba1f 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -338,7 +338,6 @@ struct p_header80 {
 	u32	  magic;
 	u16	  command;
 	u16	  length;	/* bytes of data after this header */
-	u8	  payload[0];
 } __packed;
 
 /* Header for big packets, Used for data packets exceeding 64kB */
@@ -349,9 +348,12 @@ struct p_header95 {
 	u8	  payload[0];
 } __packed;
 
-union p_header {
-	struct p_header80 h80;
-	struct p_header95 h95;
+struct p_header {
+	union {
+		struct p_header80 h80;
+		struct p_header95 h95;
+	};
+	u8	  payload[0];
 };
 
 /*
@@ -380,7 +382,7 @@ union p_header {
 #define DP_DISCARD           64 /* equals REQ_DISCARD */
 
 struct p_data {
-	union p_header head;
+	struct p_header head;
 	u64	    sector;    /* 64 bits sector number */
 	u64	    block_id;  /* to identify the request in protocol B&C */
 	u32	    seq_num;
@@ -396,7 +398,7 @@ struct p_data {
  *   P_DATA_REQUEST, P_RS_DATA_REQUEST
  */
 struct p_block_ack {
-	struct p_header80 head;
+	struct p_header head;
 	u64	    sector;
 	u64	    block_id;
 	u32	    blksize;
@@ -405,7 +407,7 @@ struct p_block_ack {
 
 
 struct p_block_req {
-	struct p_header80 head;
+	struct p_header head;
 	u64 sector;
 	u64 block_id;
 	u32 blksize;
@@ -422,7 +424,7 @@ struct p_block_req {
  */
 
 struct p_handshake {
-	struct p_header80 head;	/* 8 bytes */
+	struct p_header head;	/* Note: You must always use a h80 here */
 	u32 protocol_min;
 	u32 feature_flags;
 	u32 protocol_max;
@@ -437,19 +439,19 @@ struct p_handshake {
 /* 80 bytes, FIXED for the next century */
 
 struct p_barrier {
-	struct p_header80 head;
+	struct p_header head;
 	u32 barrier;	/* barrier number _handle_ only */
 	u32 pad;	/* to multiple of 8 Byte */
 } __packed;
 
 struct p_barrier_ack {
-	struct p_header80 head;
+	struct p_header head;
 	u32 barrier;
 	u32 set_size;
 } __packed;
 
 struct p_rs_param {
-	struct p_header80 head;
+	struct p_header head;
 	u32 rate;
 
 	      /* Since protocol version 88 and higher. */
@@ -457,7 +459,7 @@ struct p_rs_param {
 } __packed;
 
 struct p_rs_param_89 {
-	struct p_header80 head;
+	struct p_header head;
 	u32 rate;
         /* protocol version 89: */
 	char verify_alg[SHARED_SECRET_MAX];
@@ -465,7 +467,7 @@ struct p_rs_param_89 {
 } __packed;
 
 struct p_rs_param_95 {
-	struct p_header80 head;
+	struct p_header head;
 	u32 rate;
 	char verify_alg[SHARED_SECRET_MAX];
 	char csums_alg[SHARED_SECRET_MAX];
@@ -481,7 +483,7 @@ enum drbd_conn_flags {
 };
 
 struct p_protocol {
-	struct p_header80 head;
+	struct p_header head;
 	u32 protocol;
 	u32 after_sb_0p;
 	u32 after_sb_1p;
@@ -495,17 +497,17 @@ struct p_protocol {
 } __packed;
 
 struct p_uuids {
-	struct p_header80 head;
+	struct p_header head;
 	u64 uuid[UI_EXTENDED_SIZE];
 } __packed;
 
 struct p_rs_uuid {
-	struct p_header80 head;
+	struct p_header head;
 	u64	    uuid;
 } __packed;
 
 struct p_sizes {
-	struct p_header80 head;
+	struct p_header head;
 	u64	    d_size;  /* size of disk */
 	u64	    u_size;  /* user requested size */
 	u64	    c_size;  /* current exported size */
@@ -515,18 +517,18 @@ struct p_sizes {
 } __packed;
 
 struct p_state {
-	struct p_header80 head;
+	struct p_header head;
 	u32	    state;
 } __packed;
 
 struct p_req_state {
-	struct p_header80 head;
+	struct p_header head;
 	u32	    mask;
 	u32	    val;
 } __packed;
 
 struct p_req_state_reply {
-	struct p_header80 head;
+	struct p_header head;
 	u32	    retcode;
 } __packed;
 
@@ -541,14 +543,14 @@ struct p_drbd06_param {
 } __packed;
 
 struct p_discard {
-	struct p_header80 head;
+	struct p_header head;
 	u64	    block_id;
 	u32	    seq_num;
 	u32	    pad;
 } __packed;
 
 struct p_block_desc {
-	struct p_header80 head;
+	struct p_header head;
 	u64 sector;
 	u32 blksize;
 	u32 pad;	/* to multiple of 8 Byte */
@@ -564,7 +566,7 @@ enum drbd_bitmap_code {
 };
 
 struct p_compressed_bm {
-	struct p_header80 head;
+	struct p_header head;
 	/* (encoding & 0x0f): actual encoding, see enum drbd_bitmap_code
 	 * (encoding & 0x80): polarity (set/unset) of first runlength
 	 * ((encoding >> 4) & 0x07): pad_bits, number of trailing zero bits
@@ -576,7 +578,7 @@ struct p_compressed_bm {
 } __packed;
 
 struct p_delay_probe93 {
-	struct p_header80 head;
+	struct p_header head;
 	u32     seq_num; /* sequence number to match the two probe packets */
 	u32     offset;  /* usecs the probe got sent after the reference time point */
 } __packed;
@@ -625,7 +627,7 @@ DCBP_set_pad_bits(struct p_compressed_bm *p, int n)
  * so we need to use the fixed size 4KiB page size
  * most architectures have used for a long time.
  */
-#define BM_PACKET_PAYLOAD_BYTES (4096 - sizeof(struct p_header80))
+#define BM_PACKET_PAYLOAD_BYTES (4096 - sizeof(struct p_header))
 #define BM_PACKET_WORDS (BM_PACKET_PAYLOAD_BYTES/sizeof(long))
 #define BM_PACKET_VLI_BYTES_MAX (4096 - sizeof(struct p_compressed_bm))
 #if (PAGE_SIZE < 4096)
@@ -634,7 +636,7 @@ DCBP_set_pad_bits(struct p_compressed_bm *p, int n)
 #endif
 
 union p_polymorph {
-        union p_header           header;
+        struct p_header           header;
         struct p_handshake       handshake;
         struct p_data            data;
         struct p_block_ack       block_ack;
@@ -1245,12 +1247,12 @@ extern int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_f
 extern int _drbd_send_state(struct drbd_conf *mdev);
 extern int drbd_send_state(struct drbd_conf *mdev);
 extern int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
-			enum drbd_packets cmd, struct p_header80 *h,
+			enum drbd_packets cmd, struct p_header *h,
 			size_t size, unsigned msg_flags);
 #define USE_DATA_SOCKET 1
 #define USE_META_SOCKET 0
 extern int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
-			enum drbd_packets cmd, struct p_header80 *h,
+			enum drbd_packets cmd, struct p_header *h,
 			size_t size);
 extern int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packets cmd,
 			char *data, size_t size);
@@ -2019,19 +2021,19 @@ static inline void request_ping(struct drbd_conf *mdev)
 static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
 	enum drbd_packets cmd)
 {
-	struct p_header80 h;
+	struct p_header h;
 	return drbd_send_cmd(mdev, USE_DATA_SOCKET, cmd, &h, sizeof(h));
 }
 
 static inline int drbd_send_ping(struct drbd_conf *mdev)
 {
-	struct p_header80 h;
+	struct p_header h;
 	return drbd_send_cmd(mdev, USE_META_SOCKET, P_PING, &h, sizeof(h));
 }
 
 static inline int drbd_send_ping_ack(struct drbd_conf *mdev)
 {
-	struct p_header80 h;
+	struct p_header h;
 	return drbd_send_cmd(mdev, USE_META_SOCKET, P_PING_ACK, &h, sizeof(h));
 }
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 699f639..55ce48e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1822,9 +1822,10 @@ void drbd_thread_current_set_cpu(struct drbd_conf *mdev)
 
 /* the appropriate socket mutex must be held already */
 int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
-			  enum drbd_packets cmd, struct p_header80 *h,
+			  enum drbd_packets cmd, struct p_header *hg,
 			  size_t size, unsigned msg_flags)
 {
+	struct p_header80 *h = (struct p_header80 *)hg;
 	int sent, ok;
 
 	if (!expect(h))
@@ -1849,7 +1850,7 @@ int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
  * when we hold the appropriate socket mutex.
  */
 int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
-		  enum drbd_packets cmd, struct p_header80 *h, size_t size)
+		  enum drbd_packets cmd, struct p_header *h, size_t size)
 {
 	int ok = 0;
 	struct socket *sock;
@@ -1983,8 +1984,7 @@ int drbd_send_protocol(struct drbd_conf *mdev)
 	if (mdev->tconn->agreed_pro_version >= 87)
 		strcpy(p->integrity_alg, mdev->tconn->net_conf->integrity_alg);
 
-	rv = drbd_send_cmd(mdev, USE_DATA_SOCKET, P_PROTOCOL,
-			   (struct p_header80 *)p, size);
+	rv = drbd_send_cmd(mdev, USE_DATA_SOCKET, P_PROTOCOL, &p->head, size);
 	kfree(p);
 	return rv;
 }
@@ -2009,8 +2009,7 @@ int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
 
 	put_ldev(mdev);
 
-	return drbd_send_cmd(mdev, USE_DATA_SOCKET, P_UUIDS,
-			     (struct p_header80 *)&p, sizeof(p));
+	return drbd_send_cmd(mdev, USE_DATA_SOCKET, P_UUIDS, &p.head, sizeof(p));
 }
 
 int drbd_send_uuids(struct drbd_conf *mdev)
@@ -2054,8 +2053,7 @@ int drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev)
 	drbd_md_sync(mdev);
 	p.uuid = cpu_to_be64(uuid);
 
-	return drbd_send_cmd(mdev, USE_DATA_SOCKET, P_SYNC_UUID,
-			     (struct p_header80 *)&p, sizeof(p));
+	return drbd_send_cmd(mdev, USE_DATA_SOCKET, P_SYNC_UUID, &p.head, sizeof(p));
 }
 
 int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags flags)
@@ -2087,8 +2085,7 @@ int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags fl
 	p.queue_order_type = cpu_to_be16(q_order_type);
 	p.dds_flags = cpu_to_be16(flags);
 
-	ok = drbd_send_cmd(mdev, USE_DATA_SOCKET, P_SIZES,
-			   (struct p_header80 *)&p, sizeof(p));
+	ok = drbd_send_cmd(mdev, USE_DATA_SOCKET, P_SIZES, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -2112,8 +2109,7 @@ int drbd_send_state(struct drbd_conf *mdev)
 	sock = mdev->tconn->data.socket;
 
 	if (likely(sock != NULL)) {
-		ok = _drbd_send_cmd(mdev, sock, P_STATE,
-				    (struct p_header80 *)&p, sizeof(p), 0);
+		ok = _drbd_send_cmd(mdev, sock, P_STATE, &p.head, sizeof(p), 0);
 	}
 
 	mutex_unlock(&mdev->tconn->data.mutex);
@@ -2130,8 +2126,7 @@ int drbd_send_state_req(struct drbd_conf *mdev,
 	p.mask    = cpu_to_be32(mask.i);
 	p.val     = cpu_to_be32(val.i);
 
-	return drbd_send_cmd(mdev, USE_DATA_SOCKET, P_STATE_CHG_REQ,
-			     (struct p_header80 *)&p, sizeof(p));
+	return drbd_send_cmd(mdev, USE_DATA_SOCKET, P_STATE_CHG_REQ, &p.head, sizeof(p));
 }
 
 int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
@@ -2140,8 +2135,7 @@ int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
 
 	p.retcode    = cpu_to_be32(retcode);
 
-	return drbd_send_cmd(mdev, USE_META_SOCKET, P_STATE_CHG_REPLY,
-			     (struct p_header80 *)&p, sizeof(p));
+	return drbd_send_cmd(mdev, USE_META_SOCKET, P_STATE_CHG_REPLY, &p.head, sizeof(p));
 }
 
 int fill_bitmap_rle_bits(struct drbd_conf *mdev,
@@ -2246,7 +2240,7 @@ int fill_bitmap_rle_bits(struct drbd_conf *mdev,
  */
 static int
 send_bitmap_rle_or_plain(struct drbd_conf *mdev,
-			 struct p_header80 *h, struct bm_xfer_ctx *c)
+			 struct p_header *h, struct bm_xfer_ctx *c)
 {
 	struct p_compressed_bm *p = (void*)h;
 	unsigned long num_words;
@@ -2300,7 +2294,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev,
 int _drbd_send_bitmap(struct drbd_conf *mdev)
 {
 	struct bm_xfer_ctx c;
-	struct p_header80 *p;
+	struct p_header *p;
 	int err;
 
 	if (!expect(mdev->bitmap))
@@ -2308,7 +2302,7 @@ int _drbd_send_bitmap(struct drbd_conf *mdev)
 
 	/* maybe we should use some per thread scratch page,
 	 * and allocate that during initial device creation? */
-	p = (struct p_header80 *) __get_free_page(GFP_NOIO);
+	p = (struct p_header *) __get_free_page(GFP_NOIO);
 	if (!p) {
 		dev_err(DEV, "failed to allocate one page buffer in %s\n", __func__);
 		return false;
@@ -2365,8 +2359,7 @@ int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr, u32 set_size)
 
 	if (mdev->state.conn < C_CONNECTED)
 		return false;
-	ok = drbd_send_cmd(mdev, USE_META_SOCKET, P_BARRIER_ACK,
-			(struct p_header80 *)&p, sizeof(p));
+	ok = drbd_send_cmd(mdev, USE_META_SOCKET, P_BARRIER_ACK, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -2393,8 +2386,7 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packets cmd,
 
 	if (!mdev->tconn->meta.socket || mdev->state.conn < C_CONNECTED)
 		return false;
-	ok = drbd_send_cmd(mdev, USE_META_SOCKET, cmd,
-				(struct p_header80 *)&p, sizeof(p));
+	ok = drbd_send_cmd(mdev, USE_META_SOCKET, cmd, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -2452,8 +2444,7 @@ int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
 	p.block_id = block_id;
 	p.blksize  = cpu_to_be32(size);
 
-	ok = drbd_send_cmd(mdev, USE_DATA_SOCKET, cmd,
-				(struct p_header80 *)&p, sizeof(p));
+	ok = drbd_send_cmd(mdev, USE_DATA_SOCKET, cmd, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -2469,9 +2460,9 @@ int drbd_send_drequest_csum(struct drbd_conf *mdev,
 	p.block_id = ID_SYNCER /* unused */;
 	p.blksize  = cpu_to_be32(size);
 
-	p.head.magic   = cpu_to_be32(DRBD_MAGIC);
-	p.head.command = cpu_to_be16(cmd);
-	p.head.length  = cpu_to_be16(sizeof(p) - sizeof(struct p_header80) + digest_size);
+	p.head.h80.magic   = cpu_to_be32(DRBD_MAGIC);
+	p.head.h80.command = cpu_to_be16(cmd);
+	p.head.h80.length  = cpu_to_be16(sizeof(p) - sizeof(struct p_header80) + digest_size);
 
 	mutex_lock(&mdev->tconn->data.mutex);
 
@@ -2492,8 +2483,7 @@ int drbd_send_ov_request(struct drbd_conf *mdev, sector_t sector, int size)
 	p.block_id = ID_SYNCER /* unused */;
 	p.blksize  = cpu_to_be32(size);
 
-	ok = drbd_send_cmd(mdev, USE_DATA_SOCKET, P_OV_REQUEST,
-			   (struct p_header80 *)&p, sizeof(p));
+	ok = drbd_send_cmd(mdev, USE_DATA_SOCKET, P_OV_REQUEST, &p.head, sizeof(p));
 	return ok;
 }
 
@@ -2677,12 +2667,12 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 		p.head.h80.magic   = cpu_to_be32(DRBD_MAGIC);
 		p.head.h80.command = cpu_to_be16(P_DATA);
 		p.head.h80.length  =
-			cpu_to_be16(sizeof(p) - sizeof(union p_header) + dgs + req->i.size);
+			cpu_to_be16(sizeof(p) - sizeof(struct p_header) + dgs + req->i.size);
 	} else {
 		p.head.h95.magic   = cpu_to_be16(DRBD_MAGIC_BIG);
 		p.head.h95.command = cpu_to_be16(P_DATA);
 		p.head.h95.length  =
-			cpu_to_be32(sizeof(p) - sizeof(union p_header) + dgs + req->i.size);
+			cpu_to_be32(sizeof(p) - sizeof(struct p_header) + dgs + req->i.size);
 	}
 
 	p.sector   = cpu_to_be64(req->i.sector);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 12fdd73..9393fe4 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -700,7 +700,7 @@ out:
 static int drbd_send_fp(struct drbd_conf *mdev,
 	struct socket *sock, enum drbd_packets cmd)
 {
-	struct p_header80 *h = &mdev->tconn->data.sbuf.header.h80;
+	struct p_header *h = &mdev->tconn->data.sbuf.header;
 
 	return _drbd_send_cmd(mdev, sock, cmd, h, sizeof(*h), 0);
 }
@@ -925,7 +925,7 @@ out_release_sockets:
 
 static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packets *cmd, unsigned int *packet_size)
 {
-	union p_header *h = &mdev->tconn->data.rbuf.header;
+	struct p_header *h = &mdev->tconn->data.rbuf.header;
 	int r;
 
 	r = drbd_recv(mdev, h, sizeof(*h));
@@ -3477,7 +3477,7 @@ void INFO_bm_xfer_stats(struct drbd_conf *mdev,
 		const char *direction, struct bm_xfer_ctx *c)
 {
 	/* what would it take to transfer it "plaintext" */
-	unsigned plain = sizeof(struct p_header80) *
+	unsigned plain = sizeof(struct p_header) *
 		((c->bm_words+BM_PACKET_WORDS-1)/BM_PACKET_WORDS+1)
 		+ c->bm_words * sizeof(long);
 	unsigned total = c->bytes[0] + c->bytes[1];
@@ -3699,7 +3699,7 @@ static struct data_cmd drbd_cmd_handler[] = {
 
 static void drbdd(struct drbd_conf *mdev)
 {
-	union p_header *header = &mdev->tconn->data.rbuf.header;
+	struct p_header *header = &mdev->tconn->data.rbuf.header;
 	unsigned int packet_size;
 	enum drbd_packets cmd;
 	size_t shs; /* sub header size */
@@ -3715,14 +3715,14 @@ static void drbdd(struct drbd_conf *mdev)
 			goto err_out;
 		}
 
-		shs = drbd_cmd_handler[cmd].pkt_size - sizeof(union p_header);
+		shs = drbd_cmd_handler[cmd].pkt_size - sizeof(struct p_header);
 		if (packet_size - shs > 0 && !drbd_cmd_handler[cmd].expect_payload) {
 			dev_err(DEV, "No payload expected %s l:%d\n", cmdname(cmd), packet_size);
 			goto err_out;
 		}
 
 		if (shs) {
-			rv = drbd_recv(mdev, &header->h80.payload, shs);
+			rv = drbd_recv(mdev, &header->payload, shs);
 			if (unlikely(rv != shs)) {
 				if (!signal_pending(current))
 					dev_warn(DEV, "short read while reading sub header: rv=%d\n", rv);
@@ -3909,8 +3909,8 @@ static int drbd_send_handshake(struct drbd_conf *mdev)
 	memset(p, 0, sizeof(*p));
 	p->protocol_min = cpu_to_be32(PRO_VERSION_MIN);
 	p->protocol_max = cpu_to_be32(PRO_VERSION_MAX);
-	ok = _drbd_send_cmd( mdev, mdev->tconn->data.socket, P_HAND_SHAKE,
-			     (struct p_header80 *)p, sizeof(*p), 0 );
+	ok = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_HAND_SHAKE,
+			    &p->head, sizeof(*p), 0 );
 	mutex_unlock(&mdev->tconn->data.mutex);
 	return ok;
 }
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 671251a..afad8ea 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1224,7 +1224,7 @@ int w_send_barrier(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	 * dec_ap_pending will be done in got_BarrierAck
 	 * or (on connection loss) in w_clear_epoch.  */
 	ok = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BARRIER,
-				(struct p_header80 *)p, sizeof(*p), 0);
+			    &p->head, sizeof(*p), 0);
 	drbd_put_data_sock(mdev);
 
 	return ok;
-- 
1.7.4.1

