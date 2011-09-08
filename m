Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab1IHMsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:48:06 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37569 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab1IHMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:44 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/16] drbd: Change how the "handshake" packets are called
Date: Thu,  8 Sep 2011 14:45:32 +0200
Message-Id: <1315485937-18989-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
References: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Packets of type P_HAND_SHAKE define which protocol versions and features
a node supports.  For clarity, call those packets P_CONNECTION_FEATURES
instead.

(This does not determine the features that a specific drbd device
supports, such as drbd protocol A, B, C.)

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    6 +++---
 drivers/block/drbd/drbd_main.c     |    6 +++---
 drivers/block/drbd/drbd_receiver.c |   26 +++++++++++++-------------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 33cc132..7b4203c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -235,7 +235,7 @@ enum drbd_packet {
 	P_INITIAL_META	      = 0xfff1, /* First Packet on the MetaSock */
 	P_INITIAL_DATA	      = 0xfff2, /* First Packet on the Socket */
 
-	P_HAND_SHAKE	      = 0xfffe	/* FIXED for the next century! */
+	P_CONNECTION_FEATURES = 0xfffe	/* FIXED for the next century! */
 };
 
 extern const char *cmdname(enum drbd_packet cmd);
@@ -374,14 +374,14 @@ struct p_block_req {
 
 /*
  * commands with their own struct for additional fields:
- *   P_HAND_SHAKE
+ *   P_CONNECTION_FEATURES
  *   P_BARRIER
  *   P_BARRIER_ACK
  *   P_SYNC_PARAM
  *   ReportParams
  */
 
-struct p_handshake {
+struct p_connection_features {
 	struct p_header head;   /* Note: vnr will be ignored */
 	u32 protocol_min;
 	u32 feature_flags;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 3df84ad..a773d73 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2499,7 +2499,7 @@ int __init drbd_init(void)
 	int err;
 
 	BUILD_BUG_ON(sizeof(struct p_header80) != sizeof(struct p_header95));
-	BUILD_BUG_ON(sizeof(struct p_handshake) != 80);
+	BUILD_BUG_ON(sizeof(struct p_connection_features) != 80);
 
 	if (minor_count < DRBD_MINOR_COUNT_MIN || minor_count > DRBD_MINOR_COUNT_MAX) {
 		printk(KERN_ERR
@@ -3151,8 +3151,8 @@ const char *cmdname(enum drbd_packet cmd)
 		return "InitialMeta";
 	if (cmd == P_INITIAL_DATA)
 		return "InitialData";
-	if (cmd == P_HAND_SHAKE)
-		return "HandShake";
+	if (cmd == P_CONNECTION_FEATURES)
+		return "ConnectionFeatures";
 	if (cmd >= ARRAY_SIZE(cmdnames))
 		return "Unknown";
 	return cmdnames[cmd];
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 865c6e9..619a172 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -60,7 +60,7 @@ enum finish_epoch {
 	FE_RECYCLED,
 };
 
-static int drbd_do_handshake(struct drbd_tconn *tconn);
+static int drbd_do_features(struct drbd_tconn *tconn);
 static int drbd_do_auth(struct drbd_tconn *tconn);
 static int drbd_disconnected(int vnr, void *p, void *data);
 
@@ -913,7 +913,7 @@ retry:
 	/* NOT YET ...
 	 * sock->sk->sk_sndtimeo = tconn->net_conf->timeout*HZ/10;
 	 * sock->sk->sk_rcvtimeo = MAX_SCHEDULE_TIMEOUT;
-	 * first set it to the P_HAND_SHAKE timeout,
+	 * first set it to the P_CONNECTION_FEATURES timeout,
 	 * which we set to 4x the configured ping_timeout. */
 	sock->sk->sk_sndtimeo =
 	sock->sk->sk_rcvtimeo = tconn->net_conf->ping_timeo*4*HZ/10;
@@ -928,7 +928,7 @@ retry:
 
 	tconn->last_received = jiffies;
 
-	h = drbd_do_handshake(tconn);
+	h = drbd_do_features(tconn);
 	if (h <= 0)
 		return h;
 
@@ -4179,10 +4179,10 @@ static int drbd_disconnected(int vnr, void *p, void *data)
  *
  * for now, they are expected to be zero, but ignored.
  */
-static int drbd_send_handshake(struct drbd_tconn *tconn)
+static int drbd_send_features(struct drbd_tconn *tconn)
 {
 	/* ASSERT current == mdev->tconn->receiver ... */
-	struct p_handshake *p = tconn->data.sbuf;
+	struct p_connection_features *p = tconn->data.sbuf;
 	int err;
 
 	if (mutex_lock_interruptible(&tconn->data.mutex)) {
@@ -4198,7 +4198,7 @@ static int drbd_send_handshake(struct drbd_tconn *tconn)
 	memset(p, 0, sizeof(*p));
 	p->protocol_min = cpu_to_be32(PRO_VERSION_MIN);
 	p->protocol_max = cpu_to_be32(PRO_VERSION_MAX);
-	err = _conn_send_cmd(tconn, 0, &tconn->data, P_HAND_SHAKE,
+	err = _conn_send_cmd(tconn, 0, &tconn->data, P_CONNECTION_FEATURES,
 			     &p->head, sizeof(*p), 0);
 	mutex_unlock(&tconn->data.mutex);
 	return err;
@@ -4211,15 +4211,15 @@ static int drbd_send_handshake(struct drbd_tconn *tconn)
  *  -1 peer talks different language,
  *     no point in trying again, please go standalone.
  */
-static int drbd_do_handshake(struct drbd_tconn *tconn)
+static int drbd_do_features(struct drbd_tconn *tconn)
 {
 	/* ASSERT current == tconn->receiver ... */
-	struct p_handshake *p = tconn->data.rbuf;
-	const int expect = sizeof(struct p_handshake) - sizeof(struct p_header80);
+	struct p_connection_features *p = tconn->data.rbuf;
+	const int expect = sizeof(struct p_connection_features) - sizeof(struct p_header80);
 	struct packet_info pi;
 	int err;
 
-	err = drbd_send_handshake(tconn);
+	err = drbd_send_features(tconn);
 	if (err)
 		return 0;
 
@@ -4227,14 +4227,14 @@ static int drbd_do_handshake(struct drbd_tconn *tconn)
 	if (err)
 		return 0;
 
-	if (pi.cmd != P_HAND_SHAKE) {
-		conn_err(tconn, "expected HandShake packet, received: %s (0x%04x)\n",
+	if (pi.cmd != P_CONNECTION_FEATURES) {
+		conn_err(tconn, "expected ConnectionFeatures packet, received: %s (0x%04x)\n",
 		     cmdname(pi.cmd), pi.cmd);
 		return -1;
 	}
 
 	if (pi.size != expect) {
-		conn_err(tconn, "expected HandShake length: %u, received: %u\n",
+		conn_err(tconn, "expected ConnectionFeatures length: %u, received: %u\n",
 		     expect, pi.size);
 		return -1;
 	}
-- 
1.7.4.1

