Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab1HYPRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:17:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35396 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab1HYPJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 088/118] drbd: Converted drbd_do_auth() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:24 +0200
Message-Id: <1314284934-17999-89-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   58 ++++++++++++++++++------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 4b637bf..95b0d6c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -61,7 +61,7 @@ enum finish_epoch {
 };
 
 static int drbd_do_handshake(struct drbd_tconn *tconn);
-static int drbd_do_auth(struct drbd_conf *mdev);
+static int drbd_do_auth(struct drbd_tconn *tconn);
 
 static enum finish_epoch drbd_may_finish_epoch(struct drbd_conf *, struct drbd_epoch *, enum epoch_event);
 static int e_end_block(struct drbd_conf *, struct drbd_work *, int);
@@ -889,7 +889,7 @@ retry:
 
 	if (mdev->tconn->cram_hmac_tfm) {
 		/* drbd_request_state(mdev, NS(conn, WFAuth)); */
-		switch (drbd_do_auth(mdev)) {
+		switch (drbd_do_auth(mdev->tconn)) {
 		case -1:
 			dev_err(DEV, "Authentication of peer failed\n");
 			return -1;
@@ -4055,7 +4055,7 @@ static int drbd_do_handshake(struct drbd_tconn *tconn)
 }
 
 #if !defined(CONFIG_CRYPTO_HMAC) && !defined(CONFIG_CRYPTO_HMAC_MODULE)
-static int drbd_do_auth(struct drbd_conf *mdev)
+static int drbd_do_auth(struct drbd_tconn *tconn)
 {
 	dev_err(DEV, "This kernel was build without CONFIG_CRYPTO_HMAC.\n");
 	dev_err(DEV, "You need to disable 'cram-hmac-alg' in drbd.conf.\n");
@@ -4070,73 +4070,73 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 	-1 - auth failed, don't try again.
 */
 
-static int drbd_do_auth(struct drbd_conf *mdev)
+static int drbd_do_auth(struct drbd_tconn *tconn)
 {
 	char my_challenge[CHALLENGE_LEN];  /* 64 Bytes... */
 	struct scatterlist sg;
 	char *response = NULL;
 	char *right_response = NULL;
 	char *peers_ch = NULL;
-	unsigned int key_len = strlen(mdev->tconn->net_conf->shared_secret);
+	unsigned int key_len = strlen(tconn->net_conf->shared_secret);
 	unsigned int resp_size;
 	struct hash_desc desc;
 	struct packet_info pi;
 	int rv;
 
-	desc.tfm = mdev->tconn->cram_hmac_tfm;
+	desc.tfm = tconn->cram_hmac_tfm;
 	desc.flags = 0;
 
-	rv = crypto_hash_setkey(mdev->tconn->cram_hmac_tfm,
-				(u8 *)mdev->tconn->net_conf->shared_secret, key_len);
+	rv = crypto_hash_setkey(tconn->cram_hmac_tfm,
+				(u8 *)tconn->net_conf->shared_secret, key_len);
 	if (rv) {
-		dev_err(DEV, "crypto_hash_setkey() failed with %d\n", rv);
+		conn_err(tconn, "crypto_hash_setkey() failed with %d\n", rv);
 		rv = -1;
 		goto fail;
 	}
 
 	get_random_bytes(my_challenge, CHALLENGE_LEN);
 
-	rv = conn_send_cmd2(mdev->tconn, P_AUTH_CHALLENGE, my_challenge, CHALLENGE_LEN);
+	rv = conn_send_cmd2(tconn, P_AUTH_CHALLENGE, my_challenge, CHALLENGE_LEN);
 	if (!rv)
 		goto fail;
 
-	rv = drbd_recv_header(mdev->tconn, &pi);
+	rv = drbd_recv_header(tconn, &pi);
 	if (!rv)
 		goto fail;
 
 	if (pi.cmd != P_AUTH_CHALLENGE) {
-		dev_err(DEV, "expected AuthChallenge packet, received: %s (0x%04x)\n",
+		conn_err(tconn, "expected AuthChallenge packet, received: %s (0x%04x)\n",
 		    cmdname(pi.cmd), pi.cmd);
 		rv = 0;
 		goto fail;
 	}
 
 	if (pi.size > CHALLENGE_LEN * 2) {
-		dev_err(DEV, "expected AuthChallenge payload too big.\n");
+		conn_err(tconn, "expected AuthChallenge payload too big.\n");
 		rv = -1;
 		goto fail;
 	}
 
 	peers_ch = kmalloc(pi.size, GFP_NOIO);
 	if (peers_ch == NULL) {
-		dev_err(DEV, "kmalloc of peers_ch failed\n");
+		conn_err(tconn, "kmalloc of peers_ch failed\n");
 		rv = -1;
 		goto fail;
 	}
 
-	rv = drbd_recv(mdev->tconn, peers_ch, pi.size);
+	rv = drbd_recv(tconn, peers_ch, pi.size);
 
 	if (rv != pi.size) {
 		if (!signal_pending(current))
-			dev_warn(DEV, "short read AuthChallenge: l=%u\n", rv);
+			conn_warn(tconn, "short read AuthChallenge: l=%u\n", rv);
 		rv = 0;
 		goto fail;
 	}
 
-	resp_size = crypto_hash_digestsize(mdev->tconn->cram_hmac_tfm);
+	resp_size = crypto_hash_digestsize(tconn->cram_hmac_tfm);
 	response = kmalloc(resp_size, GFP_NOIO);
 	if (response == NULL) {
-		dev_err(DEV, "kmalloc of response failed\n");
+		conn_err(tconn, "kmalloc of response failed\n");
 		rv = -1;
 		goto fail;
 	}
@@ -4146,44 +4146,44 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 
 	rv = crypto_hash_digest(&desc, &sg, sg.length, response);
 	if (rv) {
-		dev_err(DEV, "crypto_hash_digest() failed with %d\n", rv);
+		conn_err(tconn, "crypto_hash_digest() failed with %d\n", rv);
 		rv = -1;
 		goto fail;
 	}
 
-	rv = conn_send_cmd2(mdev->tconn, P_AUTH_RESPONSE, response, resp_size);
+	rv = conn_send_cmd2(tconn, P_AUTH_RESPONSE, response, resp_size);
 	if (!rv)
 		goto fail;
 
-	rv = drbd_recv_header(mdev->tconn, &pi);
+	rv = drbd_recv_header(tconn, &pi);
 	if (!rv)
 		goto fail;
 
 	if (pi.cmd != P_AUTH_RESPONSE) {
-		dev_err(DEV, "expected AuthResponse packet, received: %s (0x%04x)\n",
+		conn_err(tconn, "expected AuthResponse packet, received: %s (0x%04x)\n",
 			cmdname(pi.cmd), pi.cmd);
 		rv = 0;
 		goto fail;
 	}
 
 	if (pi.size != resp_size) {
-		dev_err(DEV, "expected AuthResponse payload of wrong size\n");
+		conn_err(tconn, "expected AuthResponse payload of wrong size\n");
 		rv = 0;
 		goto fail;
 	}
 
-	rv = drbd_recv(mdev->tconn, response , resp_size);
+	rv = drbd_recv(tconn, response , resp_size);
 
 	if (rv != resp_size) {
 		if (!signal_pending(current))
-			dev_warn(DEV, "short read receiving AuthResponse: l=%u\n", rv);
+			conn_warn(tconn, "short read receiving AuthResponse: l=%u\n", rv);
 		rv = 0;
 		goto fail;
 	}
 
 	right_response = kmalloc(resp_size, GFP_NOIO);
 	if (right_response == NULL) {
-		dev_err(DEV, "kmalloc of right_response failed\n");
+		conn_err(tconn, "kmalloc of right_response failed\n");
 		rv = -1;
 		goto fail;
 	}
@@ -4192,7 +4192,7 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 
 	rv = crypto_hash_digest(&desc, &sg, sg.length, right_response);
 	if (rv) {
-		dev_err(DEV, "crypto_hash_digest() failed with %d\n", rv);
+		conn_err(tconn, "crypto_hash_digest() failed with %d\n", rv);
 		rv = -1;
 		goto fail;
 	}
@@ -4200,8 +4200,8 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 	rv = !memcmp(response, right_response, resp_size);
 
 	if (rv)
-		dev_info(DEV, "Peer authenticated using %d bytes of '%s' HMAC\n",
-		     resp_size, mdev->tconn->net_conf->cram_hmac_alg);
+		conn_info(tconn, "Peer authenticated using %d bytes of '%s' HMAC\n",
+		     resp_size, tconn->net_conf->cram_hmac_alg);
 	else
 		rv = -1;
 
-- 
1.7.4.1

