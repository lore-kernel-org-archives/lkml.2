Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab1HYPbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:31:16 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33400 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1HYPJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:17 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 039/118] drbd: Use new header layout, and send volume IOs
Date: Thu, 25 Aug 2011 17:07:35 +0200
Message-Id: <1314284934-17999-40-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new header layout will only be used if the peer supports
it of course.

For the first packet and the handshake packet the old (h80)
layout is used for compatibility reasons.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    3 +-
 drivers/block/drbd/drbd_main.c     |   82 ++++++++++++++++--------------------
 drivers/block/drbd/drbd_receiver.c |   10 ++++-
 include/linux/drbd.h               |    2 +-
 4 files changed, 46 insertions(+), 51 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 9d0ba1f..4c5d143 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -344,8 +344,7 @@ struct p_header80 {
 struct p_header95 {
 	u16	  magic;	/* use DRBD_MAGIC_BIG here */
 	u16	  command;
-	u32	  length;	/* Use only 24 bits of that. Ignore the highest 8 bit. */
-	u8	  payload[0];
+	u32	  vol_n_len;	/* big endian: high byte = volume; remaining 24 bit = length */
 } __packed;
 
 struct p_header {
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 55ce48e..f464cfa 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1820,12 +1820,36 @@ void drbd_thread_current_set_cpu(struct drbd_conf *mdev)
 }
 #endif
 
+static void prepare_header80(struct drbd_conf *mdev, struct p_header80 *h,
+			     enum drbd_packets cmd, int size)
+{
+	h->magic   = cpu_to_be32(DRBD_MAGIC);
+	h->command = cpu_to_be16(cmd);
+	h->length  = cpu_to_be16(size);
+}
+
+static void prepare_header95(struct drbd_conf *mdev, struct p_header95 *h,
+			     enum drbd_packets cmd, int size)
+{
+	h->magic   = cpu_to_be16(DRBD_MAGIC_BIG);
+	h->command = cpu_to_be16(cmd);
+	h->vol_n_len = cpu_to_be32(mdev->vnr << 24 | size);
+}
+
+static void prepare_header(struct drbd_conf *mdev, struct p_header *h,
+			   enum drbd_packets cmd, int size)
+{
+	if (mdev->tconn->agreed_pro_version >= 100 || size > DRBD_MAX_SIZE_H80_PACKET)
+		prepare_header95(mdev, &h->h95, cmd, size);
+	else
+		prepare_header80(mdev, &h->h80, cmd, size);
+}
+
 /* the appropriate socket mutex must be held already */
 int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
-			  enum drbd_packets cmd, struct p_header *hg,
+			  enum drbd_packets cmd, struct p_header *h,
 			  size_t size, unsigned msg_flags)
 {
-	struct p_header80 *h = (struct p_header80 *)hg;
 	int sent, ok;
 
 	if (!expect(h))
@@ -1833,9 +1857,7 @@ int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
 	if (!expect(size))
 		return false;
 
-	h->magic   = cpu_to_be32(DRBD_MAGIC);
-	h->command = cpu_to_be16(cmd);
-	h->length  = cpu_to_be16(size-sizeof(struct p_header80));
+	prepare_header(mdev, h, cmd, size - sizeof(struct p_header));
 
 	sent = drbd_send(mdev, sock, h, size, msg_flags);
 
@@ -1878,12 +1900,10 @@ int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
 int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packets cmd, char *data,
 		   size_t size)
 {
-	struct p_header80 h;
+	struct p_header h;
 	int ok;
 
-	h.magic   = cpu_to_be32(DRBD_MAGIC);
-	h.command = cpu_to_be16(cmd);
-	h.length  = cpu_to_be16(size);
+	prepare_header(mdev, &h, cmd, size);
 
 	if (!drbd_get_data_sock(mdev))
 		return 0;
@@ -2456,14 +2476,11 @@ int drbd_send_drequest_csum(struct drbd_conf *mdev,
 	int ok;
 	struct p_block_req p;
 
+	prepare_header(mdev, &p.head, cmd, sizeof(p) - sizeof(struct p_header) + digest_size);
 	p.sector   = cpu_to_be64(sector);
 	p.block_id = ID_SYNCER /* unused */;
 	p.blksize  = cpu_to_be32(size);
 
-	p.head.h80.magic   = cpu_to_be32(DRBD_MAGIC);
-	p.head.h80.command = cpu_to_be16(cmd);
-	p.head.h80.length  = cpu_to_be16(sizeof(p) - sizeof(struct p_header80) + digest_size);
-
 	mutex_lock(&mdev->tconn->data.mutex);
 
 	ok = (sizeof(p) == drbd_send(mdev, mdev->tconn->data.socket, &p, sizeof(p), 0));
@@ -2663,22 +2680,10 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
 		crypto_hash_digestsize(mdev->tconn->integrity_w_tfm) : 0;
 
-	if (req->i.size <= DRBD_MAX_SIZE_H80_PACKET) {
-		p.head.h80.magic   = cpu_to_be32(DRBD_MAGIC);
-		p.head.h80.command = cpu_to_be16(P_DATA);
-		p.head.h80.length  =
-			cpu_to_be16(sizeof(p) - sizeof(struct p_header) + dgs + req->i.size);
-	} else {
-		p.head.h95.magic   = cpu_to_be16(DRBD_MAGIC_BIG);
-		p.head.h95.command = cpu_to_be16(P_DATA);
-		p.head.h95.length  =
-			cpu_to_be32(sizeof(p) - sizeof(struct p_header) + dgs + req->i.size);
-	}
-
+	prepare_header(mdev, &p.head, P_DATA, sizeof(p) - sizeof(struct p_header) + dgs + req->i.size);
 	p.sector   = cpu_to_be64(req->i.sector);
 	p.block_id = (unsigned long)req;
-	p.seq_num  = cpu_to_be32(req->seq_num =
-				 atomic_add_return(1, &mdev->packet_seq));
+	p.seq_num  = cpu_to_be32(req->seq_num = atomic_add_return(1, &mdev->packet_seq));
 
 	dp_flags = bio_flags_to_wire(mdev, req->master_bio->bi_rw);
 
@@ -2748,18 +2753,7 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packets cmd,
 	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
 		crypto_hash_digestsize(mdev->tconn->integrity_w_tfm) : 0;
 
-	if (e->i.size <= DRBD_MAX_SIZE_H80_PACKET) {
-		p.head.h80.magic   = cpu_to_be32(DRBD_MAGIC);
-		p.head.h80.command = cpu_to_be16(cmd);
-		p.head.h80.length  =
-			cpu_to_be16(sizeof(p) - sizeof(struct p_header80) + dgs + e->i.size);
-	} else {
-		p.head.h95.magic   = cpu_to_be16(DRBD_MAGIC_BIG);
-		p.head.h95.command = cpu_to_be16(cmd);
-		p.head.h95.length  =
-			cpu_to_be32(sizeof(p) - sizeof(struct p_header80) + dgs + e->i.size);
-	}
-
+	prepare_header(mdev, &p.head, cmd, sizeof(p) - sizeof(struct p_header80) + dgs + e->i.size);
 	p.sector   = cpu_to_be64(e->i.sector);
 	p.block_id = e->block_id;
 	/* p.seq_num  = 0;    No sequence numbers here.. */
@@ -3028,7 +3022,7 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	drbd_thread_init(mdev, &mdev->tconn->worker, drbd_worker);
 	drbd_thread_init(mdev, &mdev->tconn->asender, drbd_asender);
 
-	mdev->tconn->agreed_pro_version = PRO_VERSION_MAX;
+	/* mdev->tconn->agreed_pro_version gets initialized in drbd_connect() */
 	mdev->write_ordering = WO_bdev_flush;
 	mdev->resync_wenr = LC_FREE;
 	mdev->peer_max_bio_size = DRBD_MAX_BIO_SIZE_SAFE;
@@ -3506,12 +3500,8 @@ int __init drbd_init(void)
 {
 	int err;
 
-	if (sizeof(struct p_handshake) != 80) {
-		printk(KERN_ERR
-		       "drbd: never change the size or layout "
-		       "of the HandShake packet.\n");
-		return -EINVAL;
-	}
+	BUILD_BUG_ON(sizeof(struct p_header80) != sizeof(struct p_header95));
+	BUILD_BUG_ON(sizeof(struct p_handshake) != 80);
 
 	if (minor_count < DRBD_MINOR_COUNT_MIN || minor_count > DRBD_MINOR_COUNT_MAX) {
 		printk(KERN_ERR
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9393fe4..e45ed47 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -761,6 +761,9 @@ static int drbd_connect(struct drbd_conf *mdev)
 		return -2;
 
 	clear_bit(DISCARD_CONCURRENT, &mdev->flags);
+	mdev->tconn->agreed_pro_version = 99;
+	/* agreed_pro_version must be smaller than 100 so we send the old
+	   header (h80) in the first packet and in the handshake packet. */
 
 	sock  = NULL;
 	msock = NULL;
@@ -926,6 +929,7 @@ out_release_sockets:
 static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packets *cmd, unsigned int *packet_size)
 {
 	struct p_header *h = &mdev->tconn->data.rbuf.header;
+	u32 vol_n_len;
 	int r;
 
 	r = drbd_recv(mdev, h, sizeof(*h));
@@ -935,12 +939,14 @@ static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packets *cmd, unsi
 		return false;
 	}
 
-	if (likely(h->h80.magic == cpu_to_be32(DRBD_MAGIC))) {
+	if (h->h80.magic == cpu_to_be32(DRBD_MAGIC)) {
 		*cmd = be16_to_cpu(h->h80.command);
 		*packet_size = be16_to_cpu(h->h80.length);
 	} else if (h->h95.magic == cpu_to_be16(DRBD_MAGIC_BIG)) {
 		*cmd = be16_to_cpu(h->h95.command);
-		*packet_size = be32_to_cpu(h->h95.length);
+		vol_n_len = be32_to_cpu(h->h95.vol_n_len);
+		*packet_size = vol_n_len & 0x00ffffff;
+		/* vnr = vol_n_len >> 24; */
 	} else {
 		dev_err(DEV, "magic?? on data m: 0x%08x c: %d l: %d\n",
 		    be32_to_cpu(h->h80.magic),
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index d282028..35fc08a 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -56,7 +56,7 @@ extern const char *drbd_buildtag(void);
 #define REL_VERSION "8.3.11"
 #define API_VERSION 88
 #define PRO_VERSION_MIN 86
-#define PRO_VERSION_MAX 96
+#define PRO_VERSION_MAX 100
 
 
 enum drbd_io_error_p {
-- 
1.7.4.1

