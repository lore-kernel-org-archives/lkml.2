Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1IELwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:52:32 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59824 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1IELpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:50 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/54] drbd: conn_send_cmd2(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:44:54 +0200
Message-Id: <1315223145-20640-4-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c     |   24 ++++++++++--------------
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1381d01..79389bf 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -769,21 +769,17 @@ int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd, char *data,
 		   size_t size)
 {
 	struct p_header80 h;
-	int ok;
+	int err;
 
 	prepare_header80(&h, cmd, size);
-
-	if (drbd_get_data_sock(tconn))
-		return 0;
-
-	ok = (sizeof(h) ==
-		drbd_send(tconn, tconn->data.socket, &h, sizeof(h), 0));
-	ok = ok && (size ==
-		drbd_send(tconn, tconn->data.socket, data, size, 0));
-
-	drbd_put_data_sock(tconn);
-
-	return ok;
+	err = drbd_get_data_sock(tconn);
+	if (!err) {
+		err = drbd_send_all(tconn, tconn->data.socket, &h, sizeof(h), 0);
+		if (!err)
+			err = drbd_send_all(tconn, tconn->data.socket, data, size, 0);
+		drbd_put_data_sock(tconn);
+	}
+	return err;
 }
 
 int drbd_send_sync_param(struct drbd_conf *mdev)
@@ -882,7 +878,7 @@ int drbd_send_protocol(struct drbd_tconn *tconn)
 	if (tconn->agreed_pro_version >= 87)
 		strcpy(p->integrity_alg, tconn->net_conf->integrity_alg);
 
-	rv = conn_send_cmd2(tconn, P_PROTOCOL, p->head.payload, size);
+	rv = !conn_send_cmd2(tconn, P_PROTOCOL, p->head.payload, size);
 	kfree(p);
 	return rv;
 }
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6949f07..e7e6ed6 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4263,7 +4263,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 
 	get_random_bytes(my_challenge, CHALLENGE_LEN);
 
-	rv = conn_send_cmd2(tconn, P_AUTH_CHALLENGE, my_challenge, CHALLENGE_LEN);
+	rv = !conn_send_cmd2(tconn, P_AUTH_CHALLENGE, my_challenge, CHALLENGE_LEN);
 	if (!rv)
 		goto fail;
 
@@ -4318,7 +4318,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 		goto fail;
 	}
 
-	rv = conn_send_cmd2(tconn, P_AUTH_RESPONSE, response, resp_size);
+	rv = !conn_send_cmd2(tconn, P_AUTH_RESPONSE, response, resp_size);
 	if (!rv)
 		goto fail;
 
-- 
1.7.4.1

