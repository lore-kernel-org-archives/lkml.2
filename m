Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab1IELrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:47:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59865 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1IELqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 39/54] drbd: drbd_recv_header(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:30 +0200
Message-Id: <1315223145-20640-40-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   38 ++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 47c9c4d..d1a2dbf 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -974,19 +974,21 @@ static int decode_header(struct drbd_tconn *tconn, struct p_header *h, struct pa
 static int drbd_recv_header(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct p_header *h = &tconn->data.rbuf.header;
-	int r;
+	int err;
 
-	r = drbd_recv(tconn, h, sizeof(*h));
-	if (unlikely(r != sizeof(*h))) {
+	err = drbd_recv(tconn, h, sizeof(*h));
+	if (unlikely(err != sizeof(*h))) {
 		if (!signal_pending(current))
-			conn_warn(tconn, "short read expecting header on sock: r=%d\n", r);
-		return false;
+			conn_warn(tconn, "short read expecting header on sock: r=%d\n", err);
+		if (err >= 0)
+			err = -EIO;
+		return err;
 	}
 
-	r = !decode_header(tconn, h, pi);
+	err = decode_header(tconn, h, pi);
 	tconn->last_received = jiffies;
 
-	return r;
+	return err;
 }
 
 static void drbd_flush(struct drbd_conf *mdev)
@@ -3788,7 +3790,7 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 				goto out;
 			break;
 		}
-		if (!drbd_recv_header(mdev->tconn, &pi))
+		if (drbd_recv_header(mdev->tconn, &pi))
 			goto out;
 		cmd = pi.cmd;
 		data_size = pi.size;
@@ -3939,7 +3941,7 @@ static void drbdd(struct drbd_tconn *tconn)
 
 	while (get_t_state(&tconn->receiver) == RUNNING) {
 		drbd_thread_current_set_cpu(&tconn->receiver);
-		if (!drbd_recv_header(tconn, &pi))
+		if (drbd_recv_header(tconn, &pi))
 			goto err_out;
 
 		if (unlikely(pi.cmd >= ARRAY_SIZE(drbd_cmd_handler) ||
@@ -4177,8 +4179,8 @@ static int drbd_do_handshake(struct drbd_tconn *tconn)
 	if (err)
 		return 0;
 
-	rv = drbd_recv_header(tconn, &pi);
-	if (!rv)
+	err = drbd_recv_header(tconn, &pi);
+	if (err)
 		return 0;
 
 	if (pi.cmd != P_HAND_SHAKE) {
@@ -4252,7 +4254,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 	unsigned int resp_size;
 	struct hash_desc desc;
 	struct packet_info pi;
-	int rv;
+	int err, rv;
 
 	desc.tfm = tconn->cram_hmac_tfm;
 	desc.flags = 0;
@@ -4271,9 +4273,11 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 	if (!rv)
 		goto fail;
 
-	rv = drbd_recv_header(tconn, &pi);
-	if (!rv)
+	err = drbd_recv_header(tconn, &pi);
+	if (err) {
+		rv = 0;
 		goto fail;
+	}
 
 	if (pi.cmd != P_AUTH_CHALLENGE) {
 		conn_err(tconn, "expected AuthChallenge packet, received: %s (0x%04x)\n",
@@ -4326,9 +4330,11 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 	if (!rv)
 		goto fail;
 
-	rv = drbd_recv_header(tconn, &pi);
-	if (!rv)
+	err = drbd_recv_header(tconn, &pi);
+	if (err) {
+		rv = 0;
 		goto fail;
+	}
 
 	if (pi.cmd != P_AUTH_RESPONSE) {
 		conn_err(tconn, "expected AuthResponse packet, received: %s (0x%04x)\n",
-- 
1.7.4.1

