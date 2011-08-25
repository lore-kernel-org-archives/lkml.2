Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1HYPRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:17:43 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35361 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1HYPJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 087/118] drbd: Converted drbd_(get|put)_data_sock() and drbd_send_cmd2() to tconn
Date: Thu, 25 Aug 2011 17:08:23 +0200
Message-Id: <1314284934-17999-88-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   20 ++++++++++----------
 drivers/block/drbd/drbd_main.c     |   26 +++++++++++++-------------
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 drivers/block/drbd/drbd_worker.c   |    4 ++--
 4 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d238bb1..ddff35b 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1108,26 +1108,26 @@ static inline unsigned int mdev_to_minor(struct drbd_conf *mdev)
 /* returns 1 if it was successful,
  * returns 0 if there was no data socket.
  * so wherever you are going to use the data.socket, e.g. do
- * if (!drbd_get_data_sock(mdev))
+ * if (!drbd_get_data_sock(mdev->tconn))
  *	return 0;
  *	CODE();
- * drbd_put_data_sock(mdev);
+ * drbd_get_data_sock(mdev->tconn);
  */
-static inline int drbd_get_data_sock(struct drbd_conf *mdev)
+static inline int drbd_get_data_sock(struct drbd_tconn *tconn)
 {
-	mutex_lock(&mdev->tconn->data.mutex);
+	mutex_lock(&tconn->data.mutex);
 	/* drbd_disconnect() could have called drbd_free_sock()
 	 * while we were waiting in down()... */
-	if (unlikely(mdev->tconn->data.socket == NULL)) {
-		mutex_unlock(&mdev->tconn->data.mutex);
+	if (unlikely(tconn->data.socket == NULL)) {
+		mutex_unlock(&tconn->data.mutex);
 		return 0;
 	}
 	return 1;
 }
 
-static inline void drbd_put_data_sock(struct drbd_conf *mdev)
+static inline void drbd_put_data_sock(struct drbd_tconn *tconn)
 {
-	mutex_unlock(&mdev->tconn->data.mutex);
+	mutex_unlock(&tconn->data.mutex);
 }
 
 /*
@@ -1170,12 +1170,12 @@ extern int drbd_send_state(struct drbd_conf *mdev);
 extern int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct socket *sock,
 			  enum drbd_packet cmd, struct p_header *h, size_t size,
 			  unsigned msg_flags);
+extern int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd,
+			  char *data, size_t size);
 #define USE_DATA_SOCKET 1
 #define USE_META_SOCKET 0
 extern int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
 			 enum drbd_packet cmd, struct p_header *h, size_t size);
-extern int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packet cmd,
-			  char *data, size_t size);
 extern int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc);
 extern int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr,
 			u32 set_size);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 544171a..14961d8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -739,23 +739,23 @@ int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
 	return ok;
 }
 
-int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packet cmd, char *data,
+int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd, char *data,
 		   size_t size)
 {
-	struct p_header h;
+	struct p_header80 h;
 	int ok;
 
-	prepare_header(mdev, &h, cmd, size);
+	prepare_header80(&h, cmd, size);
 
-	if (!drbd_get_data_sock(mdev))
+	if (!drbd_get_data_sock(tconn))
 		return 0;
 
 	ok = (sizeof(h) ==
-		drbd_send(mdev->tconn, mdev->tconn->data.socket, &h, sizeof(h), 0));
+		drbd_send(tconn, tconn->data.socket, &h, sizeof(h), 0));
 	ok = ok && (size ==
-		drbd_send(mdev->tconn, mdev->tconn->data.socket, data, size, 0));
+		drbd_send(tconn, tconn->data.socket, data, size, 0));
 
-	drbd_put_data_sock(mdev);
+	drbd_put_data_sock(tconn);
 
 	return ok;
 }
@@ -1200,10 +1200,10 @@ int drbd_send_bitmap(struct drbd_conf *mdev)
 {
 	int err;
 
-	if (!drbd_get_data_sock(mdev))
+	if (!drbd_get_data_sock(mdev->tconn))
 		return -1;
 	err = !_drbd_send_bitmap(mdev);
-	drbd_put_data_sock(mdev);
+	drbd_put_data_sock(mdev->tconn);
 	return err;
 }
 
@@ -1517,7 +1517,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	void *dgb;
 	int dgs;
 
-	if (!drbd_get_data_sock(mdev))
+	if (!drbd_get_data_sock(mdev->tconn))
 		return 0;
 
 	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
@@ -1576,7 +1576,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 		} */
 	}
 
-	drbd_put_data_sock(mdev);
+	drbd_put_data_sock(mdev->tconn);
 
 	return ok;
 }
@@ -1607,7 +1607,7 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 	 * This one may be interrupted by DRBD_SIG and/or DRBD_SIGKILL
 	 * in response to admin command or module unload.
 	 */
-	if (!drbd_get_data_sock(mdev))
+	if (!drbd_get_data_sock(mdev->tconn))
 		return 0;
 
 	ok = sizeof(p) == drbd_send(mdev->tconn, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0);
@@ -1619,7 +1619,7 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 	if (ok)
 		ok = _drbd_send_zc_ee(mdev, peer_req);
 
-	drbd_put_data_sock(mdev);
+	drbd_put_data_sock(mdev->tconn);
 
 	return ok;
 }
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 7c6c385..4b637bf 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4096,7 +4096,7 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 
 	get_random_bytes(my_challenge, CHALLENGE_LEN);
 
-	rv = drbd_send_cmd2(mdev, P_AUTH_CHALLENGE, my_challenge, CHALLENGE_LEN);
+	rv = conn_send_cmd2(mdev->tconn, P_AUTH_CHALLENGE, my_challenge, CHALLENGE_LEN);
 	if (!rv)
 		goto fail;
 
@@ -4151,7 +4151,7 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 		goto fail;
 	}
 
-	rv = drbd_send_cmd2(mdev, P_AUTH_RESPONSE, response, resp_size);
+	rv = conn_send_cmd2(mdev->tconn, P_AUTH_RESPONSE, response, resp_size);
 	if (!rv)
 		goto fail;
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 5be179b..f5c27bb 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1197,7 +1197,7 @@ int w_send_barrier(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	if (cancel)
 		return 1;
 
-	if (!drbd_get_data_sock(mdev))
+	if (!drbd_get_data_sock(mdev->tconn))
 		return 0;
 	p->barrier = b->br_number;
 	/* inc_ap_pending was done where this was queued.
@@ -1205,7 +1205,7 @@ int w_send_barrier(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	 * or (on connection loss) in w_clear_epoch.  */
 	ok = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BARRIER,
 			    &p->head, sizeof(*p), 0);
-	drbd_put_data_sock(mdev);
+	drbd_put_data_sock(mdev->tconn);
 
 	return ok;
 }
-- 
1.7.4.1

