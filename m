Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab1HYPQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:16:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35578 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab1HYPKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:00 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 093/118] drbd: Converted drbdd() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:29 +0200
Message-Id: <1314284934-17999-94-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drbd_md_sync(mdev) happens in the after state change anyways...

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    5 +++++
 drivers/block/drbd/drbd_receiver.c |   30 ++++++++++++++----------------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index ae482ed..70509c5 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1107,6 +1107,11 @@ static inline unsigned int mdev_to_minor(struct drbd_conf *mdev)
 	return mdev->minor;
 }
 
+static inline struct drbd_conf *vnr_to_mdev(struct drbd_tconn *tconn, int vnr)
+{
+	return (struct drbd_conf *)idr_find(&tconn->volumes, vnr);
+}
+
 /* returns 1 if it was successful,
  * returns 0 if there was no data socket.
  * so wherever you are going to use the data.socket, e.g. do
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 306532c..1d6df7a 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -941,6 +941,7 @@ static bool decode_header(struct drbd_tconn *tconn, struct p_header *h, struct p
 	if (h->h80.magic == cpu_to_be32(DRBD_MAGIC)) {
 		pi->cmd = be16_to_cpu(h->h80.command);
 		pi->size = be16_to_cpu(h->h80.length);
+		pi->vnr = 0;
 	} else if (h->h95.magic == cpu_to_be16(DRBD_MAGIC_BIG)) {
 		pi->cmd = be16_to_cpu(h->h95.command);
 		vol_n_len = be32_to_cpu(h->h95.vol_n_len);
@@ -3774,42 +3775,42 @@ static struct data_cmd drbd_cmd_handler[] = {
    p_header, but they may not rely on that. Since there is also p_header95 !
  */
 
-static void drbdd(struct drbd_conf *mdev)
+static void drbdd(struct drbd_tconn *tconn)
 {
-	struct p_header *header = &mdev->tconn->data.rbuf.header;
+	struct p_header *header = &tconn->data.rbuf.header;
 	struct packet_info pi;
 	size_t shs; /* sub header size */
 	int rv;
 
-	while (get_t_state(&mdev->tconn->receiver) == RUNNING) {
-		drbd_thread_current_set_cpu(&mdev->tconn->receiver);
-		if (!drbd_recv_header(mdev->tconn, &pi))
+	while (get_t_state(&tconn->receiver) == RUNNING) {
+		drbd_thread_current_set_cpu(&tconn->receiver);
+		if (!drbd_recv_header(tconn, &pi))
 			goto err_out;
 
 		if (unlikely(pi.cmd >= P_MAX_CMD || !drbd_cmd_handler[pi.cmd].function)) {
-			dev_err(DEV, "unknown packet type %d, l: %d!\n", pi.cmd, pi.size);
+			conn_err(tconn, "unknown packet type %d, l: %d!\n", pi.cmd, pi.size);
 			goto err_out;
 		}
 
 		shs = drbd_cmd_handler[pi.cmd].pkt_size - sizeof(struct p_header);
 		if (pi.size - shs > 0 && !drbd_cmd_handler[pi.cmd].expect_payload) {
-			dev_err(DEV, "No payload expected %s l:%d\n", cmdname(pi.cmd), pi.size);
+			conn_err(tconn, "No payload expected %s l:%d\n", cmdname(pi.cmd), pi.size);
 			goto err_out;
 		}
 
 		if (shs) {
-			rv = drbd_recv(mdev->tconn, &header->payload, shs);
+			rv = drbd_recv(tconn, &header->payload, shs);
 			if (unlikely(rv != shs)) {
 				if (!signal_pending(current))
-					dev_warn(DEV, "short read while reading sub header: rv=%d\n", rv);
+					conn_warn(tconn, "short read while reading sub header: rv=%d\n", rv);
 				goto err_out;
 			}
 		}
 
-		rv = drbd_cmd_handler[pi.cmd].function(mdev, pi.cmd, pi.size - shs);
+		rv = drbd_cmd_handler[pi.cmd].function(vnr_to_mdev(tconn, pi.vnr), pi.cmd, pi.size - shs);
 
 		if (unlikely(!rv)) {
-			dev_err(DEV, "error receiving %s, l: %d!\n",
+			conn_err(tconn, "error receiving %s, l: %d!\n",
 			    cmdname(pi.cmd), pi.size);
 			goto err_out;
 		}
@@ -3817,11 +3818,8 @@ static void drbdd(struct drbd_conf *mdev)
 
 	if (0) {
 	err_out:
-		drbd_force_state(mdev, NS(conn, C_PROTOCOL_ERROR));
+		drbd_force_state(tconn->volume0, NS(conn, C_PROTOCOL_ERROR));
 	}
-	/* If we leave here, we probably want to update at least the
-	 * "Connected" indicator on stable storage. Do so explicitly here. */
-	drbd_md_sync(mdev);
 }
 
 void drbd_flush_workqueue(struct drbd_tconn *tconn)
@@ -4242,7 +4240,7 @@ int drbdd_init(struct drbd_thread *thi)
 
 	if (h > 0) {
 		if (get_net_conf(mdev->tconn)) {
-			drbdd(mdev);
+			drbdd(mdev->tconn);
 			put_net_conf(mdev->tconn);
 		}
 	}
-- 
1.7.4.1

