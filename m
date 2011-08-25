Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1HYPau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:30:50 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32962 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1HYPJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 040/118] drbd: Implemented receiving of new style packets on meta socket
Date: Thu, 25 Aug 2011 17:07:36 +0200
Message-Id: <1314284934-17999-41-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now drbd communication with protocol 100 actually works.
Replaced the remaining p_header80 with p_header where we
no longer know which header it is.

In the places where p_header80 is still in use, it is on
purpose, because we know that it is an old style header
there.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |  132 ++++++++++++++++++-----------------
 1 files changed, 68 insertions(+), 64 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e45ed47..24c906f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -926,18 +926,10 @@ out_release_sockets:
 	return -1;
 }
 
-static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packets *cmd, unsigned int *packet_size)
+static bool decode_header(struct drbd_conf *mdev, struct p_header *h, enum drbd_packets *cmd,
+			  unsigned int *packet_size)
 {
-	struct p_header *h = &mdev->tconn->data.rbuf.header;
 	u32 vol_n_len;
-	int r;
-
-	r = drbd_recv(mdev, h, sizeof(*h));
-	if (unlikely(r != sizeof(*h))) {
-		if (!signal_pending(current))
-			dev_warn(DEV, "short read expecting header on sock: r=%d\n", r);
-		return false;
-	}
 
 	if (h->h80.magic == cpu_to_be32(DRBD_MAGIC)) {
 		*cmd = be16_to_cpu(h->h80.command);
@@ -954,9 +946,25 @@ static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packets *cmd, unsi
 		    be16_to_cpu(h->h80.length));
 		return false;
 	}
+	return true;
+}
+
+static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packets *cmd, unsigned int *packet_size)
+{
+	struct p_header *h = &mdev->tconn->data.rbuf.header;
+	int r;
+
+	r = drbd_recv(mdev, h, sizeof(*h));
+	if (unlikely(r != sizeof(*h))) {
+		if (!signal_pending(current))
+			dev_warn(DEV, "short read expecting header on sock: r=%d\n", r);
+		return false;
+	}
+
+	r = decode_header(mdev, h, cmd, packet_size);
 	mdev->tconn->last_received = jiffies;
 
-	return true;
+	return r;
 }
 
 static void drbd_flush(struct drbd_conf *mdev)
@@ -2810,14 +2818,14 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 	}
 
 	if (apv <= 88) {
-		header_size = sizeof(struct p_rs_param) - sizeof(struct p_header80);
+		header_size = sizeof(struct p_rs_param) - sizeof(struct p_header);
 		data_size   = packet_size  - header_size;
 	} else if (apv <= 94) {
-		header_size = sizeof(struct p_rs_param_89) - sizeof(struct p_header80);
+		header_size = sizeof(struct p_rs_param_89) - sizeof(struct p_header);
 		data_size   = packet_size  - header_size;
 		D_ASSERT(data_size == 0);
 	} else {
-		header_size = sizeof(struct p_rs_param_95) - sizeof(struct p_header80);
+		header_size = sizeof(struct p_rs_param_95) - sizeof(struct p_header);
 		data_size   = packet_size  - header_size;
 		D_ASSERT(data_size == 0);
 	}
@@ -3527,7 +3535,7 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packets cmd, unsigne
 	void *buffer;
 	int err;
 	int ok = false;
-	struct p_header80 *h = &mdev->tconn->data.rbuf.header.h80;
+	struct p_header *h = &mdev->tconn->data.rbuf.header;
 
 	drbd_bm_lock(mdev, "receive bitmap", BM_LOCKED_SET_ALLOWED);
 	/* you are supposed to send additional out-of-sync information
@@ -3574,7 +3582,7 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packets cmd, unsigne
 		}
 
 		c.packets[cmd == P_BITMAP]++;
-		c.bytes[cmd == P_BITMAP] += sizeof(struct p_header80) + data_size;
+		c.bytes[cmd == P_BITMAP] += sizeof(struct p_header) + data_size;
 
 		if (err <= 0) {
 			if (err < 0)
@@ -3673,13 +3681,13 @@ static struct data_cmd drbd_cmd_handler[] = {
 	[P_DATA_REPLY]	    = { 1, sizeof(struct p_data), receive_DataReply },
 	[P_RS_DATA_REPLY]   = { 1, sizeof(struct p_data), receive_RSDataReply } ,
 	[P_BARRIER]	    = { 0, sizeof(struct p_barrier), receive_Barrier } ,
-	[P_BITMAP]	    = { 1, sizeof(struct p_header80), receive_bitmap } ,
-	[P_COMPRESSED_BITMAP] = { 1, sizeof(struct p_header80), receive_bitmap } ,
-	[P_UNPLUG_REMOTE]   = { 0, sizeof(struct p_header80), receive_UnplugRemote },
+	[P_BITMAP]	    = { 1, sizeof(struct p_header), receive_bitmap } ,
+	[P_COMPRESSED_BITMAP] = { 1, sizeof(struct p_header), receive_bitmap } ,
+	[P_UNPLUG_REMOTE]   = { 0, sizeof(struct p_header), receive_UnplugRemote },
 	[P_DATA_REQUEST]    = { 0, sizeof(struct p_block_req), receive_DataRequest },
 	[P_RS_DATA_REQUEST] = { 0, sizeof(struct p_block_req), receive_DataRequest },
-	[P_SYNC_PARAM]	    = { 1, sizeof(struct p_header80), receive_SyncParam },
-	[P_SYNC_PARAM89]    = { 1, sizeof(struct p_header80), receive_SyncParam },
+	[P_SYNC_PARAM]	    = { 1, sizeof(struct p_header), receive_SyncParam },
+	[P_SYNC_PARAM89]    = { 1, sizeof(struct p_header), receive_SyncParam },
 	[P_PROTOCOL]        = { 1, sizeof(struct p_protocol), receive_protocol },
 	[P_UUIDS]	    = { 0, sizeof(struct p_uuids), receive_uuids },
 	[P_SIZES]	    = { 0, sizeof(struct p_sizes), receive_sizes },
@@ -4187,9 +4195,9 @@ int drbdd_init(struct drbd_thread *thi)
 
 /* ********* acknowledge sender ******** */
 
-static int got_RqSReply(struct drbd_conf *mdev, struct p_header80 *h)
+static int got_RqSReply(struct drbd_conf *mdev, enum drbd_packets cmd)
 {
-	struct p_req_state_reply *p = (struct p_req_state_reply *)h;
+	struct p_req_state_reply *p = &mdev->tconn->meta.rbuf.req_state_reply;
 
 	int retcode = be32_to_cpu(p->retcode);
 
@@ -4205,13 +4213,13 @@ static int got_RqSReply(struct drbd_conf *mdev, struct p_header80 *h)
 	return true;
 }
 
-static int got_Ping(struct drbd_conf *mdev, struct p_header80 *h)
+static int got_Ping(struct drbd_conf *mdev, enum drbd_packets cmd)
 {
 	return drbd_send_ping_ack(mdev);
 
 }
 
-static int got_PingAck(struct drbd_conf *mdev, struct p_header80 *h)
+static int got_PingAck(struct drbd_conf *mdev, enum drbd_packets cmd)
 {
 	/* restore idle timeout */
 	mdev->tconn->meta.socket->sk->sk_rcvtimeo = mdev->tconn->net_conf->ping_int*HZ;
@@ -4221,9 +4229,9 @@ static int got_PingAck(struct drbd_conf *mdev, struct p_header80 *h)
 	return true;
 }
 
-static int got_IsInSync(struct drbd_conf *mdev, struct p_header80 *h)
+static int got_IsInSync(struct drbd_conf *mdev, enum drbd_packets cmd)
 {
-	struct p_block_ack *p = (struct p_block_ack *)h;
+	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 
@@ -4266,9 +4274,9 @@ validate_req_change_req_state(struct drbd_conf *mdev, u64 id, sector_t sector,
 	return true;
 }
 
-static int got_BlockAck(struct drbd_conf *mdev, struct p_header80 *h)
+static int got_BlockAck(struct drbd_conf *mdev, enum drbd_packets cmd)
 {
-	struct p_block_ack *p = (struct p_block_ack *)h;
+	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
 	sector_t sector = be64_to_cpu(p->sector);
 	int blksize = be32_to_cpu(p->blksize);
 	enum drbd_req_event what;
@@ -4280,7 +4288,7 @@ static int got_BlockAck(struct drbd_conf *mdev, struct p_header80 *h)
 		dec_rs_pending(mdev);
 		return true;
 	}
-	switch (be16_to_cpu(h->command)) {
+	switch (cmd) {
 	case P_RS_WRITE_ACK:
 		D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
 		what = WRITE_ACKED_BY_PEER_AND_SIS;
@@ -4307,9 +4315,9 @@ static int got_BlockAck(struct drbd_conf *mdev, struct p_header80 *h)
 					     what, false);
 }
 
-static int got_NegAck(struct drbd_conf *mdev, struct p_header80 *h)
+static int got_NegAck(struct drbd_conf *mdev, enum drbd_packets cmd)
 {
-	struct p_block_ack *p = (struct p_block_ack *)h;
+	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
 	sector_t sector = be64_to_cpu(p->sector);
 	int size = be32_to_cpu(p->blksize);
 	bool missing_ok = mdev->tconn->net_conf->wire_protocol == DRBD_PROT_A ||
@@ -4340,9 +4348,9 @@ static int got_NegAck(struct drbd_conf *mdev, struct p_header80 *h)
 	return true;
 }
 
-static int got_NegDReply(struct drbd_conf *mdev, struct p_header80 *h)
+static int got_NegDReply(struct drbd_conf *mdev, enum drbd_packets cmd)
 {
-	struct p_block_ack *p = (struct p_block_ack *)h;
+	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
 	sector_t sector = be64_to_cpu(p->sector);
 
 	update_peer_seq(mdev, be32_to_cpu(p->seq_num));
@@ -4354,11 +4362,11 @@ static int got_NegDReply(struct drbd_conf *mdev, struct p_header80 *h)
 					     NEG_ACKED, false);
 }
 
-static int got_NegRSDReply(struct drbd_conf *mdev, struct p_header80 *h)
+static int got_NegRSDReply(struct drbd_conf *mdev, enum drbd_packets cmd)
 {
 	sector_t sector;
 	int size;
-	struct p_block_ack *p = (struct p_block_ack *)h;
+	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
 
 	sector = be64_to_cpu(p->sector);
 	size = be32_to_cpu(p->blksize);
@@ -4369,7 +4377,7 @@ static int got_NegRSDReply(struct drbd_conf *mdev, struct p_header80 *h)
 
 	if (get_ldev_if_state(mdev, D_FAILED)) {
 		drbd_rs_complete_io(mdev, sector);
-		switch (be16_to_cpu(h->command)) {
+		switch (cmd) {
 		case P_NEG_RS_DREPLY:
 			drbd_rs_failed_io(mdev, sector, size);
 		case P_RS_CANCEL:
@@ -4385,9 +4393,9 @@ static int got_NegRSDReply(struct drbd_conf *mdev, struct p_header80 *h)
 	return true;
 }
 
-static int got_BarrierAck(struct drbd_conf *mdev, struct p_header80 *h)
+static int got_BarrierAck(struct drbd_conf *mdev, enum drbd_packets cmd)
 {
-	struct p_barrier_ack *p = (struct p_barrier_ack *)h;
+	struct p_barrier_ack *p = &mdev->tconn->meta.rbuf.barrier_ack;
 
 	tl_release(mdev, p->barrier, be32_to_cpu(p->set_size));
 
@@ -4401,9 +4409,9 @@ static int got_BarrierAck(struct drbd_conf *mdev, struct p_header80 *h)
 	return true;
 }
 
-static int got_OVResult(struct drbd_conf *mdev, struct p_header80 *h)
+static int got_OVResult(struct drbd_conf *mdev, enum drbd_packets cmd)
 {
-	struct p_block_ack *p = (struct p_block_ack *)h;
+	struct p_block_ack *p = &mdev->tconn->meta.rbuf.block_ack;
 	struct drbd_work *w;
 	sector_t sector;
 	int size;
@@ -4445,14 +4453,14 @@ static int got_OVResult(struct drbd_conf *mdev, struct p_header80 *h)
 	return true;
 }
 
-static int got_skip(struct drbd_conf *mdev, struct p_header80 *h)
+static int got_skip(struct drbd_conf *mdev, enum drbd_packets cmd)
 {
 	return true;
 }
 
 struct asender_cmd {
 	size_t pkt_size;
-	int (*process)(struct drbd_conf *mdev, struct p_header80 *h);
+	int (*process)(struct drbd_conf *mdev, enum drbd_packets cmd);
 };
 
 static struct asender_cmd *get_asender_cmd(int cmd)
@@ -4461,8 +4469,8 @@ static struct asender_cmd *get_asender_cmd(int cmd)
 		/* anything missing from this table is in
 		 * the drbd_cmd_handler (drbd_default_handler) table,
 		 * see the beginning of drbdd() */
-	[P_PING]	    = { sizeof(struct p_header80), got_Ping },
-	[P_PING_ACK]	    = { sizeof(struct p_header80), got_PingAck },
+	[P_PING]	    = { sizeof(struct p_header), got_Ping },
+	[P_PING_ACK]	    = { sizeof(struct p_header), got_PingAck },
 	[P_RECV_ACK]	    = { sizeof(struct p_block_ack), got_BlockAck },
 	[P_WRITE_ACK]	    = { sizeof(struct p_block_ack), got_BlockAck },
 	[P_RS_WRITE_ACK]    = { sizeof(struct p_block_ack), got_BlockAck },
@@ -4486,15 +4494,16 @@ static struct asender_cmd *get_asender_cmd(int cmd)
 int drbd_asender(struct drbd_thread *thi)
 {
 	struct drbd_conf *mdev = thi->mdev;
-	struct p_header80 *h = &mdev->tconn->meta.rbuf.header.h80;
+	struct p_header *h = &mdev->tconn->meta.rbuf.header;
 	struct asender_cmd *cmd = NULL;
 
-	int rv, len;
+	int rv;
 	void *buf    = h;
 	int received = 0;
-	int expect   = sizeof(struct p_header80);
-	int empty;
+	int expect   = sizeof(struct p_header);
 	int ping_timeout_active = 0;
+	int empty, pkt_size;
+	enum drbd_packets cmd_nr;
 
 	sprintf(current->comm, "drbd%d_asender", mdev_to_minor(mdev));
 
@@ -4584,30 +4593,25 @@ int drbd_asender(struct drbd_thread *thi)
 		}
 
 		if (received == expect && cmd == NULL) {
-			if (unlikely(h->magic != cpu_to_be32(DRBD_MAGIC))) {
-				dev_err(DEV, "magic?? on meta m: 0x%08x c: %d l: %d\n",
-				    be32_to_cpu(h->magic),
-				    be16_to_cpu(h->command),
-				    be16_to_cpu(h->length));
+			if (!decode_header(mdev, h, &cmd_nr, &pkt_size))
 				goto reconnect;
-			}
-			cmd = get_asender_cmd(be16_to_cpu(h->command));
-			len = be16_to_cpu(h->length);
+			cmd = get_asender_cmd(cmd_nr);
 			if (unlikely(cmd == NULL)) {
-				dev_err(DEV, "unknown command?? on meta m: 0x%08x c: %d l: %d\n",
-				    be32_to_cpu(h->magic),
-				    be16_to_cpu(h->command),
-				    be16_to_cpu(h->length));
+				dev_err(DEV, "unknown command %d on meta (l: %d)\n",
+					cmd_nr, pkt_size);
 				goto disconnect;
 			}
 			expect = cmd->pkt_size;
-			if (!expect(len == expect - sizeof(struct p_header80)))
+			if (pkt_size != expect - sizeof(struct p_header)) {
+				dev_err(DEV, "Wrong packet size on meta (c: %d, l: %d)\n",
+					cmd_nr, pkt_size);
 				goto reconnect;
+			}
 		}
 		if (received == expect) {
 			mdev->tconn->last_received = jiffies;
 			D_ASSERT(cmd != NULL);
-			if (!cmd->process(mdev, h))
+			if (!cmd->process(mdev, cmd_nr))
 				goto reconnect;
 
 			/* the idle_timeout (ping-int)
@@ -4617,7 +4621,7 @@ int drbd_asender(struct drbd_thread *thi)
 
 			buf	 = h;
 			received = 0;
-			expect	 = sizeof(struct p_header80);
+			expect	 = sizeof(struct p_header);
 			cmd	 = NULL;
 		}
 	}
-- 
1.7.4.1

