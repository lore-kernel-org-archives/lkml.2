Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1IGQuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:50:13 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48573 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab1IGQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:45:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/14] drbd: Preallocate one page per drbd_socket as a send buffer
Date: Wed,  7 Sep 2011 16:17:36 +0200
Message-Id: <1315405061-1473-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
References: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   23 +----------------------
 drivers/block/drbd/drbd_main.c     |    6 +++++-
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 drivers/block/drbd/drbd_worker.c   |    2 +-
 4 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 4a4ecec..984b2a3 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -556,27 +556,6 @@ struct p_delay_probe93 {
 
 #define DRBD_SOCKET_BUFFER_SIZE 4096
 
-union p_polymorph {
-        struct p_header           header;
-        struct p_handshake       handshake;
-        struct p_data            data;
-        struct p_block_ack       block_ack;
-        struct p_barrier         barrier;
-        struct p_barrier_ack     barrier_ack;
-        struct p_rs_param_89     rs_param_89;
-        struct p_rs_param_95     rs_param_95;
-        struct p_protocol        protocol;
-        struct p_sizes           sizes;
-        struct p_uuids           uuids;
-        struct p_state           state;
-        struct p_req_state       req_state;
-        struct p_req_state_reply req_state_reply;
-        struct p_block_req       block_req;
-	struct p_delay_probe93   delay_probe93;
-	struct p_rs_uuid         rs_uuid;
-	struct p_block_desc      block_desc;
-} __packed;
-
 /**********************************************************************/
 enum drbd_thread_state {
 	NONE,
@@ -804,7 +783,7 @@ struct drbd_socket {
 	struct socket    *socket;
 	/* this way we get our
 	 * send/receive buffers off the stack */
-	union p_polymorph sbuf;
+	void *sbuf;
 	void *rbuf;
 };
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7b6da0e..6c2a51f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -800,7 +800,7 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 		enum drbd_packet cmd =
 			apv >= 89 ? P_SYNC_PARAM89 : P_SYNC_PARAM;
 
-		p = &mdev->tconn->data.sbuf.rs_param_95;
+		p = mdev->tconn->data.sbuf;
 
 		/* initialize verify_alg and csums_alg */
 		memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
@@ -2279,11 +2279,15 @@ static int drbd_alloc_socket(struct drbd_socket *socket)
 	socket->rbuf = (void *) __get_free_page(GFP_KERNEL);
 	if (!socket->rbuf)
 		return -ENOMEM;
+	socket->sbuf = (void *) __get_free_page(GFP_KERNEL);
+	if (!socket->sbuf)
+		return -ENOMEM;
 	return 0;
 }
 
 static void drbd_free_socket(struct drbd_socket *socket)
 {
+	free_page((unsigned long) socket->sbuf);
 	free_page((unsigned long) socket->rbuf);
 }
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e5099db..57e65ac 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -736,7 +736,7 @@ out:
 
 static int drbd_send_fp(struct drbd_tconn *tconn, struct socket *sock, enum drbd_packet cmd)
 {
-	struct p_header *h = &tconn->data.sbuf.header;
+	struct p_header *h = tconn->data.sbuf;
 
 	return !_conn_send_cmd(tconn, 0, sock, cmd, h, sizeof(*h), 0);
 }
@@ -4136,7 +4136,7 @@ static int drbd_disconnected(int vnr, void *p, void *data)
 static int drbd_send_handshake(struct drbd_tconn *tconn)
 {
 	/* ASSERT current == mdev->tconn->receiver ... */
-	struct p_handshake *p = &tconn->data.sbuf.handshake;
+	struct p_handshake *p = tconn->data.sbuf;
 	int err;
 
 	if (mutex_lock_interruptible(&tconn->data.mutex)) {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index e96a816..ed12cdf 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1195,7 +1195,7 @@ int w_send_barrier(struct drbd_work *w, int cancel)
 {
 	struct drbd_tl_epoch *b = container_of(w, struct drbd_tl_epoch, w);
 	struct drbd_conf *mdev = w->mdev;
-	struct p_barrier *p = &mdev->tconn->data.sbuf.barrier;
+	struct p_barrier *p = mdev->tconn->data.sbuf;
 	int err = 0;
 
 	/* really avoid racing with tl_clear.  w.cb may have been referenced
-- 
1.7.4.1

