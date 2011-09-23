Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1IWOb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:31:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39541 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab1IWObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:31:31 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/10] drbd: Remove headers from on-the-wire data structures (struct p_*)
Date: Fri, 23 Sep 2011 16:31:22 +0200
Message-Id: <1316788285-17433-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   45 ----------
 drivers/block/drbd/drbd_main.c     |   44 +++++-----
 drivers/block/drbd/drbd_receiver.c |  171 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_worker.c   |    2 +-
 4 files changed, 108 insertions(+), 154 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d8e63c4..9868518 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -307,32 +307,8 @@ struct p_header95 {
 	u32	  vol_n_len;	/* big endian: high byte = volume; remaining 24 bit = length */
 } __packed;
 
-struct p_header {
-	union {
-		struct p_header80 h80;
-		struct p_header95 h95;
-	};
-	u8	  payload[0];
-};
-
 extern unsigned int drbd_header_size(struct drbd_tconn *tconn);
 
-/*
- * short commands, packets without payload, plain p_header:
- *   P_PING
- *   P_PING_ACK
- *   P_BECOME_SYNC_TARGET
- *   P_BECOME_SYNC_SOURCE
- *   P_UNPLUG_REMOTE
- */
-
-/*
- * commands with out-of-struct payload:
- *   P_BITMAP    (no additional fields)
- *   P_DATA, P_DATA_REPLY (see p_data)
- *   P_COMPRESSED_BITMAP (see receive_compressed_bitmap)
- */
-
 /* these defines must not be changed without changing the protocol version */
 #define DP_HARDBARRIER	      1 /* depricated */
 #define DP_RW_SYNC	      2 /* equals REQ_SYNC    */
@@ -343,7 +319,6 @@ extern unsigned int drbd_header_size(struct drbd_tconn *tconn);
 #define DP_DISCARD           64 /* equals REQ_DISCARD */
 
 struct p_data {
-	struct p_header head;
 	u64	    sector;    /* 64 bits sector number */
 	u64	    block_id;  /* to identify the request in protocol B&C */
 	u32	    seq_num;
@@ -359,7 +334,6 @@ struct p_data {
  *   P_DATA_REQUEST, P_RS_DATA_REQUEST
  */
 struct p_block_ack {
-	struct p_header head;
 	u64	    sector;
 	u64	    block_id;
 	u32	    blksize;
@@ -367,7 +341,6 @@ struct p_block_ack {
 } __packed;
 
 struct p_block_req {
-	struct p_header head;
 	u64 sector;
 	u64 block_id;
 	u32 blksize;
@@ -384,7 +357,6 @@ struct p_block_req {
  */
 
 struct p_connection_features {
-	struct p_header head;   /* Note: vnr will be ignored */
 	u32 protocol_min;
 	u32 feature_flags;
 	u32 protocol_max;
@@ -396,22 +368,18 @@ struct p_connection_features {
 	u32 _pad;
 	u64 reserverd[7];
 } __packed;
-/* 80 bytes, FIXED for the next century */
 
 struct p_barrier {
-	struct p_header head;
 	u32 barrier;	/* barrier number _handle_ only */
 	u32 pad;	/* to multiple of 8 Byte */
 } __packed;
 
 struct p_barrier_ack {
-	struct p_header head;
 	u32 barrier;
 	u32 set_size;
 } __packed;
 
 struct p_rs_param {
-	struct p_header head;
 	u32 rate;
 
 	      /* Since protocol version 88 and higher. */
@@ -419,7 +387,6 @@ struct p_rs_param {
 } __packed;
 
 struct p_rs_param_89 {
-	struct p_header head;
 	u32 rate;
         /* protocol version 89: */
 	char verify_alg[SHARED_SECRET_MAX];
@@ -427,7 +394,6 @@ struct p_rs_param_89 {
 } __packed;
 
 struct p_rs_param_95 {
-	struct p_header head;
 	u32 rate;
 	char verify_alg[SHARED_SECRET_MAX];
 	char csums_alg[SHARED_SECRET_MAX];
@@ -443,7 +409,6 @@ enum drbd_conn_flags {
 };
 
 struct p_protocol {
-	struct p_header head;
 	u32 protocol;
 	u32 after_sb_0p;
 	u32 after_sb_1p;
@@ -457,17 +422,14 @@ struct p_protocol {
 } __packed;
 
 struct p_uuids {
-	struct p_header head;
 	u64 uuid[UI_EXTENDED_SIZE];
 } __packed;
 
 struct p_rs_uuid {
-	struct p_header head;
 	u64	    uuid;
 } __packed;
 
 struct p_sizes {
-	struct p_header head;
 	u64	    d_size;  /* size of disk */
 	u64	    u_size;  /* user requested size */
 	u64	    c_size;  /* current exported size */
@@ -477,18 +439,15 @@ struct p_sizes {
 } __packed;
 
 struct p_state {
-	struct p_header head;
 	u32	    state;
 } __packed;
 
 struct p_req_state {
-	struct p_header head;
 	u32	    mask;
 	u32	    val;
 } __packed;
 
 struct p_req_state_reply {
-	struct p_header head;
 	u32	    retcode;
 } __packed;
 
@@ -503,14 +462,12 @@ struct p_drbd06_param {
 } __packed;
 
 struct p_discard {
-	struct p_header head;
 	u64	    block_id;
 	u32	    seq_num;
 	u32	    pad;
 } __packed;
 
 struct p_block_desc {
-	struct p_header head;
 	u64 sector;
 	u32 blksize;
 	u32 pad;	/* to multiple of 8 Byte */
@@ -526,7 +483,6 @@ enum drbd_bitmap_code {
 };
 
 struct p_compressed_bm {
-	struct p_header head;
 	/* (encoding & 0x0f): actual encoding, see enum drbd_bitmap_code
 	 * (encoding & 0x80): polarity (set/unset) of first runlength
 	 * ((encoding >> 4) & 0x07): pad_bits, number of trailing zero bits
@@ -538,7 +494,6 @@ struct p_compressed_bm {
 } __packed;
 
 struct p_delay_probe93 {
-	struct p_header head;
 	u32     seq_num; /* sequence number to match the two probe packets */
 	u32     offset;  /* usecs the probe got sent after the reference time point */
 } __packed;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index ee45370..34cdb97 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -703,27 +703,29 @@ unsigned int drbd_header_size(struct drbd_tconn *tconn)
 	return sizeof(struct p_header80);
 }
 
-static void prepare_header80(struct p_header80 *h, enum drbd_packet cmd, int size)
+static unsigned int prepare_header80(struct p_header80 *h, enum drbd_packet cmd, int size)
 {
 	h->magic   = cpu_to_be32(DRBD_MAGIC);
 	h->command = cpu_to_be16(cmd);
 	h->length  = cpu_to_be16(size);
+	return sizeof(struct p_header80);
 }
 
-static void prepare_header95(struct p_header95 *h, enum drbd_packet cmd, int size, int vnr)
+static unsigned int prepare_header95(struct p_header95 *h, enum drbd_packet cmd, int size, int vnr)
 {
 	h->magic   = cpu_to_be16(DRBD_MAGIC_BIG);
 	h->command = cpu_to_be16(cmd);
 	h->vol_n_len = cpu_to_be32(vnr << 24 | size);
+	return sizeof(struct p_header95);
 }
 
-static void prepare_header(struct drbd_tconn *tconn, int vnr, struct p_header *h,
-			   enum drbd_packet cmd, int size)
+static unsigned int prepare_header(struct drbd_tconn *tconn, int vnr, void *buffer,
+				   enum drbd_packet cmd, int size)
 {
 	if (tconn->agreed_pro_version >= 95)
-		prepare_header95(&h->h95, cmd, size, vnr);
+		return prepare_header95(buffer, cmd, size, vnr);
 	else
-		prepare_header80(&h->h80, cmd, size);
+		return prepare_header80(buffer, cmd, size);
 }
 
 void *conn_prepare_command(struct drbd_tconn *tconn, struct drbd_socket *sock)
@@ -733,7 +735,7 @@ void *conn_prepare_command(struct drbd_tconn *tconn, struct drbd_socket *sock)
 		mutex_unlock(&sock->mutex);
 		return NULL;
 	}
-	return sock->sbuf;
+	return sock->sbuf + drbd_header_size(tconn);
 }
 
 void *drbd_prepare_command(struct drbd_conf *mdev, struct drbd_socket *sock)
@@ -758,8 +760,8 @@ static int __send_command(struct drbd_tconn *tconn, int vnr,
 	 */
 	msg_flags = data ? MSG_MORE : 0;
 
-	prepare_header(tconn, vnr, sock->sbuf, cmd,
-		       header_size - sizeof(struct p_header) + size);
+	header_size += prepare_header(tconn, vnr, sock->sbuf, cmd,
+				      header_size + size);
 	err = drbd_send_all(tconn, sock->socket, sock->sbuf, header_size,
 			    msg_flags);
 	if (data && !err)
@@ -797,7 +799,7 @@ int drbd_send_ping(struct drbd_tconn *tconn)
 	sock = &tconn->meta;
 	if (!conn_prepare_command(tconn, sock))
 		return -EIO;
-	return conn_send_command(tconn, sock, P_PING, sizeof(struct p_header), NULL, 0);
+	return conn_send_command(tconn, sock, P_PING, 0, NULL, 0);
 }
 
 int drbd_send_ping_ack(struct drbd_tconn *tconn)
@@ -807,7 +809,7 @@ int drbd_send_ping_ack(struct drbd_tconn *tconn)
 	sock = &tconn->meta;
 	if (!conn_prepare_command(tconn, sock))
 		return -EIO;
-	return conn_send_command(tconn, sock, P_PING_ACK, sizeof(struct p_header), NULL, 0);
+	return conn_send_command(tconn, sock, P_PING_ACK, 0, NULL, 0);
 }
 
 int drbd_send_sync_param(struct drbd_conf *mdev)
@@ -1187,10 +1189,10 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
 {
 	struct drbd_socket *sock = &mdev->tconn->data;
 	unsigned int header_size = drbd_header_size(mdev->tconn);
-	struct p_compressed_bm *p = sock->sbuf;
+	struct p_compressed_bm *p = sock->sbuf + header_size;
 	int len, err;
 
-	len = fill_bitmap_rle_bits(mdev, p, DRBD_SOCKET_BUFFER_SIZE - sizeof(*p) /* FIXME */, c);
+	len = fill_bitmap_rle_bits(mdev, p, DRBD_SOCKET_BUFFER_SIZE - header_size, c);
 	if (len < 0)
 		return -EIO;
 
@@ -1200,7 +1202,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
 				     P_COMPRESSED_BITMAP, sizeof(*p) + len,
 				     NULL, 0);
 		c->packets[0]++;
-		c->bytes[0] += sizeof(*p) + len;
+		c->bytes[0] += header_size + sizeof(*p) + len;
 
 		if (c->bit_offset >= c->bm_bits)
 			len = 0; /* DONE */
@@ -1209,17 +1211,15 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev, struct bm_xfer_ctx *c)
 		 * send a buffer full of plain text bits instead. */
 		unsigned int data_size;
 		unsigned long num_words;
-		struct p_header *h = sock->sbuf;
+		unsigned long *p = sock->sbuf + header_size;
 
 		data_size = DRBD_SOCKET_BUFFER_SIZE - header_size;
-		num_words = min_t(size_t, data_size / sizeof(unsigned long),
+		num_words = min_t(size_t, data_size / sizeof(*p),
 				  c->bm_words - c->word_offset);
-		len = num_words * sizeof(unsigned long);
+		len = num_words * sizeof(*p);
 		if (len)
-			drbd_bm_get_lel(mdev, c->word_offset, num_words,
-					(unsigned long *)h->payload);
-		err = __send_command(mdev->tconn, mdev->vnr, sock, P_BITMAP,
-				     sizeof(*h) + len, NULL, 0);
+			drbd_bm_get_lel(mdev, c->word_offset, num_words, p);
+		err = __send_command(mdev->tconn, mdev->vnr, sock, P_BITMAP, len, NULL, 0);
 		c->word_offset += num_words;
 		c->bit_offset = c->word_offset * BITS_PER_LONG;
 
@@ -2532,8 +2532,6 @@ int __init drbd_init(void)
 {
 	int err;
 
-	BUILD_BUG_ON(sizeof(struct p_connection_features) != 80);
-
 	if (minor_count < DRBD_MINOR_COUNT_MIN || minor_count > DRBD_MINOR_COUNT_MAX) {
 		printk(KERN_ERR
 		       "drbd: invalid minor_count (%d)\n", minor_count);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index d0d1924..0b0f453 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -52,6 +52,7 @@ struct packet_info {
 	enum drbd_packet cmd;
 	unsigned int size;
 	unsigned int vnr;
+	void *data;
 };
 
 enum finish_epoch {
@@ -729,14 +730,14 @@ out:
 	return s_estab;
 }
 
-static int decode_header(struct drbd_tconn *, struct p_header *, struct packet_info *);
+static int decode_header(struct drbd_tconn *, void *, struct packet_info *);
 
 static int send_first_packet(struct drbd_tconn *tconn, struct drbd_socket *sock,
 			     enum drbd_packet cmd)
 {
 	if (!conn_prepare_command(tconn, sock))
 		return -EIO;
-	return conn_send_command(tconn, sock, cmd, sizeof(struct p_header), NULL, 0);
+	return conn_send_command(tconn, sock, cmd, 0, NULL, 0);
 }
 
 static int receive_first_packet(struct drbd_tconn *tconn, struct socket *sock)
@@ -978,39 +979,45 @@ out_release_sockets:
 	return -1;
 }
 
-static int decode_header(struct drbd_tconn *tconn, struct p_header *h, struct packet_info *pi)
+static int decode_header(struct drbd_tconn *tconn, void *header, struct packet_info *pi)
 {
-	u32 vol_n_len;
+	unsigned int header_size = drbd_header_size(tconn);
 
-	if (h->h80.magic == cpu_to_be32(DRBD_MAGIC)) {
-		pi->cmd = be16_to_cpu(h->h80.command);
-		pi->size = be16_to_cpu(h->h80.length);
-		pi->vnr = 0;
-	} else if (h->h95.magic == cpu_to_be16(DRBD_MAGIC_BIG)) {
-		pi->cmd = be16_to_cpu(h->h95.command);
-		vol_n_len = be32_to_cpu(h->h95.vol_n_len);
+	if (header_size == sizeof(struct p_header95) &&
+	    *(__be16 *)header == cpu_to_be16(DRBD_MAGIC_BIG)) {
+		struct p_header95 *h = header;
+		u32 vol_n_len;
+
+		pi->cmd = be16_to_cpu(h->command);
+		vol_n_len = be32_to_cpu(h->vol_n_len);
 		pi->size = vol_n_len & 0x00ffffff;
 		pi->vnr  = vol_n_len >> 24;
+	} else if (header_size == sizeof(struct p_header80) &&
+		   *(__be32 *)header == cpu_to_be32(DRBD_MAGIC)) {
+		struct p_header80 *h = header;
+		pi->cmd = be16_to_cpu(h->command);
+		pi->size = be16_to_cpu(h->length);
+		pi->vnr = 0;
 	} else {
-		conn_err(tconn, "magic?? on data m: 0x%08x c: %d l: %d\n",
-		    be32_to_cpu(h->h80.magic),
-		    be16_to_cpu(h->h80.command),
-		    be16_to_cpu(h->h80.length));
+		conn_err(tconn, "Wrong magic value 0x%08x in protocol version %d\n",
+			 be32_to_cpu(*(__be32 *)header),
+			 tconn->agreed_pro_version);
 		return -EINVAL;
 	}
+	pi->data = header + header_size;
 	return 0;
 }
 
 static int drbd_recv_header(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_header *h = tconn->data.rbuf;
+	void *buffer = tconn->data.rbuf;
 	int err;
 
-	err = drbd_recv_all_warn(tconn, h, drbd_header_size(tconn));
+	err = drbd_recv_all_warn(tconn, buffer, drbd_header_size(tconn));
 	if (err)
 		return err;
 
-	err = decode_header(tconn, h, pi);
+	err = decode_header(tconn, buffer, pi);
 	tconn->last_received = jiffies;
 
 	return err;
@@ -1245,7 +1252,7 @@ static int receive_Barrier(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
 	int rv;
-	struct p_barrier *p = tconn->data.rbuf;
+	struct p_barrier *p = pi->data;
 	struct drbd_epoch *epoch;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
@@ -1563,7 +1570,7 @@ static int receive_DataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct drbd_request *req;
 	sector_t sector;
 	int err;
-	struct p_data *p = tconn->data.rbuf;
+	struct p_data *p = pi->data;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
@@ -1595,7 +1602,7 @@ static int receive_RSDataReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct drbd_conf *mdev;
 	sector_t sector;
 	int err;
-	struct p_data *p = tconn->data.rbuf;
+	struct p_data *p = pi->data;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
@@ -1988,7 +1995,7 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct drbd_conf *mdev;
 	sector_t sector;
 	struct drbd_peer_request *peer_req;
-	struct p_data *p = tconn->data.rbuf;
+	struct p_data *p = pi->data;
 	u32 peer_seq = be32_to_cpu(p->seq_num);
 	int rw = WRITE;
 	u32 dp_flags;
@@ -2176,7 +2183,7 @@ static int receive_DataRequest(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct digest_info *di = NULL;
 	int size, verb;
 	unsigned int fault_type;
-	struct p_block_req *p =	tconn->data.rbuf;
+	struct p_block_req *p =	pi->data;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
@@ -2896,7 +2903,7 @@ static int cmp_after_sb(enum drbd_after_sb_p peer, enum drbd_after_sb_p self)
 
 static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_protocol *p = tconn->data.rbuf;
+	struct p_protocol *p = pi->data;
 	int p_proto, p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
 	int p_want_lose, p_two_primaries, cf;
 	char p_integrity_alg[SHARED_SECRET_MAX] = "";
@@ -3036,7 +3043,7 @@ static int config_unknown_volume(struct drbd_tconn *tconn, struct packet_info *p
 static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_rs_param_95 *p = tconn->data.rbuf;
+	struct p_rs_param_95 *p;
 	unsigned int header_size, data_size, exp_max_sz;
 	struct crypto_hash *verify_tfm = NULL;
 	struct crypto_hash *csums_tfm = NULL;
@@ -3062,22 +3069,23 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	}
 
 	if (apv <= 88) {
-		header_size = sizeof(struct p_rs_param) - sizeof(struct p_header);
+		header_size = sizeof(struct p_rs_param);
 		data_size = pi->size - header_size;
 	} else if (apv <= 94) {
-		header_size = sizeof(struct p_rs_param_89) - sizeof(struct p_header);
+		header_size = sizeof(struct p_rs_param_89);
 		data_size = pi->size - header_size;
 		D_ASSERT(data_size == 0);
 	} else {
-		header_size = sizeof(struct p_rs_param_95) - sizeof(struct p_header);
+		header_size = sizeof(struct p_rs_param_95);
 		data_size = pi->size - header_size;
 		D_ASSERT(data_size == 0);
 	}
 
 	/* initialize verify_alg and csums_alg */
+	p = pi->data;
 	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
-	err = drbd_recv_all(mdev->tconn, &p->head.payload, header_size);
+	err = drbd_recv_all(mdev->tconn, p, header_size);
 	if (err)
 		return err;
 
@@ -3212,7 +3220,7 @@ static void warn_if_differ_considerably(struct drbd_conf *mdev,
 static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_sizes *p = tconn->data.rbuf;
+	struct p_sizes *p = pi->data;
 	enum determine_dev_size dd = unchanged;
 	sector_t p_size, p_usize, my_usize;
 	int ldsc = 0; /* local disk size changed */
@@ -3314,7 +3322,7 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 static int receive_uuids(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_uuids *p = tconn->data.rbuf;
+	struct p_uuids *p = pi->data;
 	u64 *p_uuid;
 	int i, updated_uuids = 0;
 
@@ -3414,7 +3422,7 @@ static union drbd_state convert_state(union drbd_state ps)
 static int receive_req_state(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_req_state *p = tconn->data.rbuf;
+	struct p_req_state *p = pi->data;
 	union drbd_state mask, val;
 	enum drbd_state_rv rv;
 
@@ -3444,7 +3452,7 @@ static int receive_req_state(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int receive_req_conn_state(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_req_state *p = tconn->data.rbuf;
+	struct p_req_state *p = pi->data;
 	union drbd_state mask, val;
 	enum drbd_state_rv rv;
 
@@ -3469,7 +3477,7 @@ static int receive_req_conn_state(struct drbd_tconn *tconn, struct packet_info *
 static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_state *p = tconn->data.rbuf;
+	struct p_state *p = pi->data;
 	union drbd_state os, ns, peer_state;
 	enum drbd_disk_state real_peer_disk;
 	enum chg_state_flags cs_flags;
@@ -3626,7 +3634,7 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 static int receive_sync_uuid(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_rs_uuid *p = tconn->data.rbuf;
+	struct p_rs_uuid *p = pi->data;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
@@ -3664,14 +3672,13 @@ static int receive_sync_uuid(struct drbd_tconn *tconn, struct packet_info *pi)
  */
 static int
 receive_bitmap_plain(struct drbd_conf *mdev, unsigned int size,
-		     struct p_header *h, struct bm_xfer_ctx *c)
+		     unsigned long *p, struct bm_xfer_ctx *c)
 {
-	unsigned long *buffer = (unsigned long *)h->payload;
 	unsigned int data_size = DRBD_SOCKET_BUFFER_SIZE -
 				 drbd_header_size(mdev->tconn);
-	unsigned int num_words = min_t(size_t, data_size / sizeof(unsigned long),
+	unsigned int num_words = min_t(size_t, data_size / sizeof(*p),
 				       c->bm_words - c->word_offset);
-	unsigned int want = num_words * sizeof(unsigned long);
+	unsigned int want = num_words * sizeof(*p);
 	int err;
 
 	if (want != size) {
@@ -3680,11 +3687,11 @@ receive_bitmap_plain(struct drbd_conf *mdev, unsigned int size,
 	}
 	if (want == 0)
 		return 0;
-	err = drbd_recv_all(mdev->tconn, buffer, want);
+	err = drbd_recv_all(mdev->tconn, p, want);
 	if (err)
 		return err;
 
-	drbd_bm_merge_lel(mdev, c->word_offset, num_words, buffer);
+	drbd_bm_merge_lel(mdev, c->word_offset, num_words, p);
 
 	c->word_offset += num_words;
 	c->bit_offset = c->word_offset * BITS_PER_LONG;
@@ -3847,7 +3854,6 @@ static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct drbd_conf *mdev;
 	struct bm_xfer_ctx c;
 	int err;
-	struct p_header *h = tconn->data.rbuf;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
@@ -3863,28 +3869,26 @@ static int receive_bitmap(struct drbd_tconn *tconn, struct packet_info *pi)
 	};
 
 	for(;;) {
-		if (pi->cmd == P_BITMAP) {
-			err = receive_bitmap_plain(mdev, pi->size, h, &c);
-		} else if (pi->cmd == P_COMPRESSED_BITMAP) {
+		if (pi->cmd == P_BITMAP)
+			err = receive_bitmap_plain(mdev, pi->size, pi->data, &c);
+		else if (pi->cmd == P_COMPRESSED_BITMAP) {
 			/* MAYBE: sanity check that we speak proto >= 90,
 			 * and the feature is enabled! */
-			struct p_compressed_bm *p;
+			struct p_compressed_bm *p = pi->data;
 
 			if (pi->size > DRBD_SOCKET_BUFFER_SIZE - drbd_header_size(tconn)) {
 				dev_err(DEV, "ReportCBitmap packet too large\n");
 				err = -EIO;
 				goto out;
 			}
-
-			p = mdev->tconn->data.rbuf;
-			err = drbd_recv_all(mdev->tconn, p->head.payload, pi->size);
-			if (err)
-			       goto out;
-			if (pi->size <= (sizeof(*p) - sizeof(p->head))) {
+			if (pi->size <= sizeof(*p)) {
 				dev_err(DEV, "ReportCBitmap packet too small (l:%u)\n", pi->size);
 				err = -EIO;
 				goto out;
 			}
+			err = drbd_recv_all(mdev->tconn, p, pi->size);
+			if (err)
+			       goto out;
 			err = decode_bitmap_c(mdev, p, &c, pi->size);
 		} else {
 			dev_warn(DEV, "receive_bitmap: cmd neither ReportBitMap nor ReportCBitMap (is 0x%x)", pi->cmd);
@@ -3951,7 +3955,7 @@ static int receive_UnplugRemote(struct drbd_tconn *tconn, struct packet_info *pi
 static int receive_out_of_sync(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_block_desc *p = tconn->data.rbuf;
+	struct p_block_desc *p = pi->data;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
@@ -3983,13 +3987,13 @@ static struct data_cmd drbd_cmd_handler[] = {
 	[P_DATA_REPLY]	    = { 1, sizeof(struct p_data), receive_DataReply },
 	[P_RS_DATA_REPLY]   = { 1, sizeof(struct p_data), receive_RSDataReply } ,
 	[P_BARRIER]	    = { 0, sizeof(struct p_barrier), receive_Barrier } ,
-	[P_BITMAP]	    = { 1, sizeof(struct p_header), receive_bitmap } ,
-	[P_COMPRESSED_BITMAP] = { 1, sizeof(struct p_header), receive_bitmap } ,
-	[P_UNPLUG_REMOTE]   = { 0, sizeof(struct p_header), receive_UnplugRemote },
+	[P_BITMAP]	    = { 1, 0, receive_bitmap } ,
+	[P_COMPRESSED_BITMAP] = { 1, 0, receive_bitmap } ,
+	[P_UNPLUG_REMOTE]   = { 0, 0, receive_UnplugRemote },
 	[P_DATA_REQUEST]    = { 0, sizeof(struct p_block_req), receive_DataRequest },
 	[P_RS_DATA_REQUEST] = { 0, sizeof(struct p_block_req), receive_DataRequest },
-	[P_SYNC_PARAM]	    = { 1, sizeof(struct p_header), receive_SyncParam },
-	[P_SYNC_PARAM89]    = { 1, sizeof(struct p_header), receive_SyncParam },
+	[P_SYNC_PARAM]	    = { 1, 0, receive_SyncParam },
+	[P_SYNC_PARAM89]    = { 1, 0, receive_SyncParam },
 	[P_PROTOCOL]        = { 1, sizeof(struct p_protocol), receive_protocol },
 	[P_UUIDS]	    = { 0, sizeof(struct p_uuids), receive_uuids },
 	[P_SIZES]	    = { 0, sizeof(struct p_sizes), receive_sizes },
@@ -4006,7 +4010,6 @@ static struct data_cmd drbd_cmd_handler[] = {
 
 static void drbdd(struct drbd_tconn *tconn)
 {
-	struct p_header *header = tconn->data.rbuf;
 	struct packet_info pi;
 	size_t shs; /* sub header size */
 	int err;
@@ -4024,14 +4027,14 @@ static void drbdd(struct drbd_tconn *tconn)
 			goto err_out;
 		}
 
-		shs = cmd->pkt_size - sizeof(struct p_header);
-		if (pi.size - shs > 0 && !cmd->expect_payload) {
+		shs = cmd->pkt_size;
+		if (pi.size > shs && !cmd->expect_payload) {
 			conn_err(tconn, "No payload expected %s l:%d\n", cmdname(pi.cmd), pi.size);
 			goto err_out;
 		}
 
 		if (shs) {
-			err = drbd_recv_all_warn(tconn, &header->payload, shs);
+			err = drbd_recv_all_warn(tconn, pi.data, shs);
 			if (err)
 				goto err_out;
 			pi.size -= shs;
@@ -4222,8 +4225,8 @@ static int drbd_send_features(struct drbd_tconn *tconn)
 static int drbd_do_features(struct drbd_tconn *tconn)
 {
 	/* ASSERT current == tconn->receiver ... */
-	struct p_connection_features *p = tconn->data.rbuf;
-	const int expect = sizeof(struct p_connection_features) - sizeof(struct p_header80);
+	struct p_connection_features *p;
+	const int expect = sizeof(struct p_connection_features);
 	struct packet_info pi;
 	int err;
 
@@ -4247,7 +4250,8 @@ static int drbd_do_features(struct drbd_tconn *tconn)
 		return -1;
 	}
 
-	err = drbd_recv_all_warn(tconn, &p->head.payload, expect);
+	p = pi.data;
+	err = drbd_recv_all_warn(tconn, p, expect);
 	if (err)
 		return 0;
 
@@ -4325,8 +4329,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 		rv = 0;
 		goto fail;
 	}
-	rv = !conn_send_command(tconn, sock, P_AUTH_CHALLENGE,
-				sizeof(struct p_header),
+	rv = !conn_send_command(tconn, sock, P_AUTH_CHALLENGE, 0,
 				my_challenge, CHALLENGE_LEN);
 	if (!rv)
 		goto fail;
@@ -4385,8 +4388,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 		rv = 0;
 		goto fail;
 	}
-	rv = !conn_send_command(tconn, sock, P_AUTH_RESPONSE,
-				sizeof(struct p_header),
+	rv = !conn_send_command(tconn, sock, P_AUTH_RESPONSE, 0,
 				response, resp_size);
 	if (!rv)
 		goto fail;
@@ -4485,7 +4487,7 @@ int drbdd_init(struct drbd_thread *thi)
 
 static int got_conn_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_req_state_reply *p = tconn->meta.rbuf;
+	struct p_req_state_reply *p = pi->data;
 	int retcode = be32_to_cpu(p->retcode);
 
 	if (retcode >= SS_SUCCESS) {
@@ -4503,7 +4505,7 @@ static int got_conn_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 static int got_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_req_state_reply *p = tconn->meta.rbuf;
+	struct p_req_state_reply *p = pi->data;
 	int retcode = be32_to_cpu(p->retcode);
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
@@ -4541,7 +4543,7 @@ static int got_PingAck(struct drbd_tconn *tconn, struct packet_info *pi)
 static int got_IsInSync(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_block_ack *p = tconn->meta.rbuf;
+	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 
@@ -4591,7 +4593,7 @@ validate_req_change_req_state(struct drbd_conf *mdev, u64 id, sector_t sector,
 static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_block_ack *p = tconn->meta.rbuf;
+	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 	enum drbd_req_event what;
@@ -4641,7 +4643,7 @@ static int got_BlockAck(struct drbd_tconn *tconn, struct packet_info *pi)
 static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_block_ack *p = tconn->meta.rbuf;
+	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 	int size = be32_to_cpu(p->blksize);
 	bool missing_ok = tconn->net_conf->wire_protocol == DRBD_PROT_A ||
@@ -4679,7 +4681,7 @@ static int got_NegAck(struct drbd_tconn *tconn, struct packet_info *pi)
 static int got_NegDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_block_ack *p = tconn->meta.rbuf;
+	struct p_block_ack *p = pi->data;
 	sector_t sector = be64_to_cpu(p->sector);
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
@@ -4701,7 +4703,7 @@ static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct drbd_conf *mdev;
 	sector_t sector;
 	int size;
-	struct p_block_ack *p = tconn->meta.rbuf;
+	struct p_block_ack *p = pi->data;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
@@ -4735,7 +4737,7 @@ static int got_NegRSDReply(struct drbd_tconn *tconn, struct packet_info *pi)
 static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_barrier_ack *p = tconn->meta.rbuf;
+	struct p_barrier_ack *p = pi->data;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
@@ -4756,7 +4758,7 @@ static int got_BarrierAck(struct drbd_tconn *tconn, struct packet_info *pi)
 static int got_OVResult(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct drbd_conf *mdev;
-	struct p_block_ack *p = tconn->meta.rbuf;
+	struct p_block_ack *p = pi->data;
 	struct drbd_work *w;
 	sector_t sector;
 	int size;
@@ -4840,8 +4842,8 @@ struct asender_cmd {
 };
 
 static struct asender_cmd asender_tbl[] = {
-	[P_PING]	    = { sizeof(struct p_header), got_Ping },
-	[P_PING_ACK]	    = { sizeof(struct p_header), got_PingAck },
+	[P_PING]	    = { 0, got_Ping },
+	[P_PING_ACK]	    = { 0, got_PingAck },
 	[P_RECV_ACK]	    = { sizeof(struct p_block_ack), got_BlockAck },
 	[P_WRITE_ACK]	    = { sizeof(struct p_block_ack), got_BlockAck },
 	[P_RS_WRITE_ACK]    = { sizeof(struct p_block_ack), got_BlockAck },
@@ -4862,11 +4864,10 @@ static struct asender_cmd asender_tbl[] = {
 int drbd_asender(struct drbd_thread *thi)
 {
 	struct drbd_tconn *tconn = thi->tconn;
-	struct p_header *h = tconn->meta.rbuf;
 	struct asender_cmd *cmd = NULL;
 	struct packet_info pi;
 	int rv;
-	void *buf    = h;
+	void *buf    = tconn->meta.rbuf;
 	int received = 0;
 	unsigned int header_size = drbd_header_size(tconn);
 	int expect   = header_size;
@@ -4944,7 +4945,7 @@ int drbd_asender(struct drbd_thread *thi)
 		}
 
 		if (received == expect && cmd == NULL) {
-			if (decode_header(tconn, h, &pi))
+			if (decode_header(tconn, tconn->meta.rbuf, &pi))
 				goto reconnect;
 			cmd = &asender_tbl[pi.cmd];
 			if (pi.cmd >= ARRAY_SIZE(asender_tbl) || !cmd->fn) {
@@ -4952,7 +4953,7 @@ int drbd_asender(struct drbd_thread *thi)
 					pi.cmd, pi.size);
 				goto disconnect;
 			}
-			expect = cmd->pkt_size;
+			expect = header_size + cmd->pkt_size;
 			if (pi.size != expect - header_size) {
 				conn_err(tconn, "Wrong packet size on meta (c: %d, l: %d)\n",
 					pi.cmd, pi.size);
@@ -4975,7 +4976,7 @@ int drbd_asender(struct drbd_thread *thi)
 			if (cmd == &asender_tbl[P_PING_ACK])
 				ping_timeout_active = 0;
 
-			buf	 = h;
+			buf	 = tconn->meta.rbuf;
 			received = 0;
 			expect	 = header_size;
 			cmd	 = NULL;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 6feaa4a..3c7b6d7 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1231,7 +1231,7 @@ int w_send_write_hint(struct drbd_work *w, int cancel)
 	sock = &mdev->tconn->data;
 	if (!drbd_prepare_command(mdev, sock))
 		return -EIO;
-	return drbd_send_command(mdev, sock, P_UNPLUG_REMOTE, sizeof(struct p_header), NULL, 0);
+	return drbd_send_command(mdev, sock, P_UNPLUG_REMOTE, 0, NULL, 0);
 }
 
 int w_send_out_of_sync(struct drbd_work *w, int cancel)
-- 
1.7.4.1

