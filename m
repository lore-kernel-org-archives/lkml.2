Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1IELqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:46:06 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59839 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1IELpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:51 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/54] drbd: _drbd_send_cmd(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:44:56 +0200
Message-Id: <1315223145-20640-6-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h    |    2 +-
 drivers/block/drbd/drbd_main.c   |   15 +++++++--------
 drivers/block/drbd/drbd_worker.c |    4 ++--
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 9badc52..32799ea 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1926,7 +1926,7 @@ static inline int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
 				  enum drbd_packet cmd, struct p_header *h, size_t size,
 				  unsigned msg_flags)
 {
-	return !_conn_send_cmd(mdev->tconn, mdev->vnr, sock, cmd, h, size, msg_flags);
+	return _conn_send_cmd(mdev->tconn, mdev->vnr, sock, cmd, h, size, msg_flags);
 }
 
 static inline int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 58141ba..cf13c75 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -827,7 +827,7 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 		if (apv >= 89)
 			strcpy(p->csums_alg, mdev->tconn->net_conf->csums_alg);
 
-		rv = _drbd_send_cmd(mdev, sock, cmd, &p->head, size, 0);
+		rv = !_drbd_send_cmd(mdev, sock, cmd, &p->head, size, 0);
 	} else
 		rv = 0; /* not ok */
 
@@ -995,9 +995,8 @@ int drbd_send_state(struct drbd_conf *mdev)
 	p.state = cpu_to_be32(mdev->state.i); /* Within the send mutex */
 	sock = mdev->tconn->data.socket;
 
-	if (likely(sock != NULL)) {
-		ok = _drbd_send_cmd(mdev, sock, P_STATE, &p.head, sizeof(p), 0);
-	}
+	if (likely(sock != NULL))
+		ok = !_drbd_send_cmd(mdev, sock, P_STATE, &p.head, sizeof(p), 0);
 
 	mutex_unlock(&mdev->tconn->data.mutex);
 
@@ -1150,8 +1149,8 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev,
 
 	if (len) {
 		DCBP_set_code(p, RLE_VLI_Bits);
-		ok = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_COMPRESSED_BITMAP, h,
-			sizeof(*p) + len, 0);
+		ok = !_drbd_send_cmd(mdev, mdev->tconn->data.socket, P_COMPRESSED_BITMAP, h,
+				     sizeof(*p) + len, 0);
 
 		c->packets[0]++;
 		c->bytes[0] += sizeof(*p) + len;
@@ -1165,8 +1164,8 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev,
 		len = num_words * sizeof(long);
 		if (len)
 			drbd_bm_get_lel(mdev, c->word_offset, num_words, (unsigned long*)h->payload);
-		ok = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BITMAP,
-				   h, sizeof(struct p_header80) + len, 0);
+		ok = !_drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BITMAP,
+				     h, sizeof(struct p_header80) + len, 0);
 		c->word_offset += num_words;
 		c->bit_offset = c->word_offset * BITS_PER_LONG;
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 39e4915..d726309 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1215,8 +1215,8 @@ int w_send_barrier(struct drbd_work *w, int cancel)
 	/* inc_ap_pending was done where this was queued.
 	 * dec_ap_pending will be done in got_BarrierAck
 	 * or (on connection loss) in w_clear_epoch.  */
-	ok = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BARRIER,
-			    &p->head, sizeof(*p), 0);
+	ok = !_drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BARRIER,
+			     &p->head, sizeof(*p), 0);
 	drbd_put_data_sock(mdev->tconn);
 
 	return ok;
-- 
1.7.4.1

