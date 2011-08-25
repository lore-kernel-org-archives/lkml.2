Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1HYPSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:18:52 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35240 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab1HYPJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 083/118] drbd: struct packet_info to hold information of decoded packets
Date: Thu, 25 Aug 2011 17:08:19 +0200
Message-Id: <1314284934-17999-84-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |  104 +++++++++++++++++++-----------------
 1 files changed, 54 insertions(+), 50 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6283911..deb0837 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -48,6 +48,12 @@
 
 #include "drbd_vli.h"
 
+struct packet_info {
+	enum drbd_packet cmd;
+	int size;
+	int vnr;
+};
+
 enum finish_epoch {
 	FE_STILL_LIVE,
 	FE_DESTROYED,
@@ -924,19 +930,18 @@ out_release_sockets:
 	return -1;
 }
 
-static bool decode_header(struct drbd_conf *mdev, struct p_header *h,
-			  enum drbd_packet *cmd, unsigned int *packet_size)
+static bool decode_header(struct drbd_conf *mdev, struct p_header *h, struct packet_info *pi)
 {
 	u32 vol_n_len;
 
 	if (h->h80.magic == cpu_to_be32(DRBD_MAGIC)) {
-		*cmd = be16_to_cpu(h->h80.command);
-		*packet_size = be16_to_cpu(h->h80.length);
+		pi->cmd = be16_to_cpu(h->h80.command);
+		pi->size = be16_to_cpu(h->h80.length);
 	} else if (h->h95.magic == cpu_to_be16(DRBD_MAGIC_BIG)) {
-		*cmd = be16_to_cpu(h->h95.command);
+		pi->cmd = be16_to_cpu(h->h95.command);
 		vol_n_len = be32_to_cpu(h->h95.vol_n_len);
-		*packet_size = vol_n_len & 0x00ffffff;
-		/* vnr = vol_n_len >> 24; */
+		pi->size = vol_n_len & 0x00ffffff;
+		pi->vnr  = vol_n_len >> 24;
 	} else {
 		dev_err(DEV, "magic?? on data m: 0x%08x c: %d l: %d\n",
 		    be32_to_cpu(h->h80.magic),
@@ -947,8 +952,7 @@ static bool decode_header(struct drbd_conf *mdev, struct p_header *h,
 	return true;
 }
 
-static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packet *cmd,
-			    unsigned int *packet_size)
+static int drbd_recv_header(struct drbd_conf *mdev, struct packet_info *pi)
 {
 	struct p_header *h = &mdev->tconn->data.rbuf.header;
 	int r;
@@ -960,7 +964,7 @@ static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packet *cmd,
 		return false;
 	}
 
-	r = decode_header(mdev, h, cmd, packet_size);
+	r = decode_header(mdev, h, pi);
 	mdev->tconn->last_received = jiffies;
 
 	return r;
@@ -3584,6 +3588,7 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 	int err;
 	int ok = false;
 	struct p_header *h = &mdev->tconn->data.rbuf.header;
+	struct packet_info pi;
 
 	drbd_bm_lock(mdev, "receive bitmap", BM_LOCKED_SET_ALLOWED);
 	/* you are supposed to send additional out-of-sync information
@@ -3637,8 +3642,10 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 				goto out;
 			break;
 		}
-		if (!drbd_recv_header(mdev, &cmd, &data_size))
+		if (!drbd_recv_header(mdev, &pi))
 			goto out;
+		cmd = pi.cmd;
+		data_size = pi.size;
 	}
 
 	INFO_bm_xfer_stats(mdev, "receive", &c);
@@ -3766,24 +3773,23 @@ static struct data_cmd drbd_cmd_handler[] = {
 static void drbdd(struct drbd_conf *mdev)
 {
 	struct p_header *header = &mdev->tconn->data.rbuf.header;
-	unsigned int packet_size;
-	enum drbd_packet cmd;
+	struct packet_info pi;
 	size_t shs; /* sub header size */
 	int rv;
 
 	while (get_t_state(&mdev->tconn->receiver) == RUNNING) {
 		drbd_thread_current_set_cpu(mdev, &mdev->tconn->receiver);
-		if (!drbd_recv_header(mdev, &cmd, &packet_size))
+		if (!drbd_recv_header(mdev, &pi))
 			goto err_out;
 
-		if (unlikely(cmd >= P_MAX_CMD || !drbd_cmd_handler[cmd].function)) {
-			dev_err(DEV, "unknown packet type %d, l: %d!\n", cmd, packet_size);
+		if (unlikely(pi.cmd >= P_MAX_CMD || !drbd_cmd_handler[pi.cmd].function)) {
+			dev_err(DEV, "unknown packet type %d, l: %d!\n", pi.cmd, pi.size);
 			goto err_out;
 		}
 
-		shs = drbd_cmd_handler[cmd].pkt_size - sizeof(struct p_header);
-		if (packet_size - shs > 0 && !drbd_cmd_handler[cmd].expect_payload) {
-			dev_err(DEV, "No payload expected %s l:%d\n", cmdname(cmd), packet_size);
+		shs = drbd_cmd_handler[pi.cmd].pkt_size - sizeof(struct p_header);
+		if (pi.size - shs > 0 && !drbd_cmd_handler[pi.cmd].expect_payload) {
+			dev_err(DEV, "No payload expected %s l:%d\n", cmdname(pi.cmd), pi.size);
 			goto err_out;
 		}
 
@@ -3796,11 +3802,11 @@ static void drbdd(struct drbd_conf *mdev)
 			}
 		}
 
-		rv = drbd_cmd_handler[cmd].function(mdev, cmd, packet_size - shs);
+		rv = drbd_cmd_handler[pi.cmd].function(mdev, pi.cmd, pi.size - shs);
 
 		if (unlikely(!rv)) {
 			dev_err(DEV, "error receiving %s, l: %d!\n",
-			    cmdname(cmd), packet_size);
+			    cmdname(pi.cmd), pi.size);
 			goto err_out;
 		}
 	}
@@ -3993,27 +3999,26 @@ static int drbd_do_handshake(struct drbd_conf *mdev)
 	/* ASSERT current == mdev->tconn->receiver ... */
 	struct p_handshake *p = &mdev->tconn->data.rbuf.handshake;
 	const int expect = sizeof(struct p_handshake) - sizeof(struct p_header80);
-	unsigned int length;
-	enum drbd_packet cmd;
+	struct packet_info pi;
 	int rv;
 
 	rv = drbd_send_handshake(mdev->tconn);
 	if (!rv)
 		return 0;
 
-	rv = drbd_recv_header(mdev, &cmd, &length);
+	rv = drbd_recv_header(mdev, &pi);
 	if (!rv)
 		return 0;
 
-	if (cmd != P_HAND_SHAKE) {
+	if (pi.cmd != P_HAND_SHAKE) {
 		dev_err(DEV, "expected HandShake packet, received: %s (0x%04x)\n",
-		     cmdname(cmd), cmd);
+		     cmdname(pi.cmd), pi.cmd);
 		return -1;
 	}
 
-	if (length != expect) {
+	if (pi.size != expect) {
 		dev_err(DEV, "expected HandShake length: %u, received: %u\n",
-		     expect, length);
+		     expect, pi.size);
 		return -1;
 	}
 
@@ -4075,8 +4080,7 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 	unsigned int key_len = strlen(mdev->tconn->net_conf->shared_secret);
 	unsigned int resp_size;
 	struct hash_desc desc;
-	enum drbd_packet cmd;
-	unsigned int length;
+	struct packet_info pi;
 	int rv;
 
 	desc.tfm = mdev->tconn->cram_hmac_tfm;
@@ -4096,33 +4100,33 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 	if (!rv)
 		goto fail;
 
-	rv = drbd_recv_header(mdev, &cmd, &length);
+	rv = drbd_recv_header(mdev, &pi);
 	if (!rv)
 		goto fail;
 
-	if (cmd != P_AUTH_CHALLENGE) {
+	if (pi.cmd != P_AUTH_CHALLENGE) {
 		dev_err(DEV, "expected AuthChallenge packet, received: %s (0x%04x)\n",
-		    cmdname(cmd), cmd);
+		    cmdname(pi.cmd), pi.cmd);
 		rv = 0;
 		goto fail;
 	}
 
-	if (length > CHALLENGE_LEN * 2) {
+	if (pi.size > CHALLENGE_LEN * 2) {
 		dev_err(DEV, "expected AuthChallenge payload too big.\n");
 		rv = -1;
 		goto fail;
 	}
 
-	peers_ch = kmalloc(length, GFP_NOIO);
+	peers_ch = kmalloc(pi.size, GFP_NOIO);
 	if (peers_ch == NULL) {
 		dev_err(DEV, "kmalloc of peers_ch failed\n");
 		rv = -1;
 		goto fail;
 	}
 
-	rv = drbd_recv(mdev->tconn, peers_ch, length);
+	rv = drbd_recv(mdev->tconn, peers_ch, pi.size);
 
-	if (rv != length) {
+	if (rv != pi.size) {
 		if (!signal_pending(current))
 			dev_warn(DEV, "short read AuthChallenge: l=%u\n", rv);
 		rv = 0;
@@ -4138,7 +4142,7 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 	}
 
 	sg_init_table(&sg, 1);
-	sg_set_buf(&sg, peers_ch, length);
+	sg_set_buf(&sg, peers_ch, pi.size);
 
 	rv = crypto_hash_digest(&desc, &sg, sg.length, response);
 	if (rv) {
@@ -4151,18 +4155,18 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 	if (!rv)
 		goto fail;
 
-	rv = drbd_recv_header(mdev, &cmd, &length);
+	rv = drbd_recv_header(mdev, &pi);
 	if (!rv)
 		goto fail;
 
-	if (cmd != P_AUTH_RESPONSE) {
+	if (pi.cmd != P_AUTH_RESPONSE) {
 		dev_err(DEV, "expected AuthResponse packet, received: %s (0x%04x)\n",
-			cmdname(cmd), cmd);
+			cmdname(pi.cmd), pi.cmd);
 		rv = 0;
 		goto fail;
 	}
 
-	if (length != resp_size) {
+	if (pi.size != resp_size) {
 		dev_err(DEV, "expected AuthResponse payload of wrong size\n");
 		rv = 0;
 		goto fail;
@@ -4548,14 +4552,14 @@ int drbd_asender(struct drbd_thread *thi)
 	struct drbd_conf *mdev = thi->mdev;
 	struct p_header *h = &mdev->tconn->meta.rbuf.header;
 	struct asender_cmd *cmd = NULL;
+	struct packet_info pi;
 
 	int rv;
 	void *buf    = h;
 	int received = 0;
 	int expect   = sizeof(struct p_header);
 	int ping_timeout_active = 0;
-	int empty, pkt_size;
-	enum drbd_packet cmd_nr;
+	int empty;
 
 	sprintf(current->comm, "drbd%d_asender", mdev_to_minor(mdev));
 
@@ -4644,25 +4648,25 @@ int drbd_asender(struct drbd_thread *thi)
 		}
 
 		if (received == expect && cmd == NULL) {
-			if (!decode_header(mdev, h, &cmd_nr, &pkt_size))
+			if (!decode_header(mdev, h, &pi))
 				goto reconnect;
-			cmd = get_asender_cmd(cmd_nr);
+			cmd = get_asender_cmd(pi.cmd);
 			if (unlikely(cmd == NULL)) {
 				dev_err(DEV, "unknown command %d on meta (l: %d)\n",
-					cmd_nr, pkt_size);
+					pi.cmd, pi.size);
 				goto disconnect;
 			}
 			expect = cmd->pkt_size;
-			if (pkt_size != expect - sizeof(struct p_header)) {
+			if (pi.size != expect - sizeof(struct p_header)) {
 				dev_err(DEV, "Wrong packet size on meta (c: %d, l: %d)\n",
-					cmd_nr, pkt_size);
+					pi.cmd, pi.size);
 				goto reconnect;
 			}
 		}
 		if (received == expect) {
 			mdev->tconn->last_received = jiffies;
 			D_ASSERT(cmd != NULL);
-			if (!cmd->process(mdev, cmd_nr))
+			if (!cmd->process(mdev, pi.cmd))
 				goto reconnect;
 
 			/* the idle_timeout (ping-int)
-- 
1.7.4.1

