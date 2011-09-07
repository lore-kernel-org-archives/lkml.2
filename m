Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1IGQv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:51:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48568 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1IGQp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:45:57 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/14] drbd: A small cleanup in drbdd()
Date: Wed,  7 Sep 2011 16:17:38 +0200
Message-Id: <1315405061-1473-12-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_receiver.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 57e65ac..a4b24f9 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3943,18 +3943,20 @@ static void drbdd(struct drbd_tconn *tconn)
 	int err;
 
 	while (get_t_state(&tconn->receiver) == RUNNING) {
+		struct data_cmd *cmd;
+
 		drbd_thread_current_set_cpu(&tconn->receiver);
 		if (drbd_recv_header(tconn, &pi))
 			goto err_out;
 
-		if (unlikely(pi.cmd >= ARRAY_SIZE(drbd_cmd_handler) ||
-		    !drbd_cmd_handler[pi.cmd].mdev_fn)) {
+		cmd = &drbd_cmd_handler[pi.cmd];
+		if (unlikely(pi.cmd >= ARRAY_SIZE(drbd_cmd_handler) || !cmd->mdev_fn)) {
 			conn_err(tconn, "unknown packet type %d, l: %d!\n", pi.cmd, pi.size);
 			goto err_out;
 		}
 
-		shs = drbd_cmd_handler[pi.cmd].pkt_size - sizeof(struct p_header);
-		if (pi.size - shs > 0 && !drbd_cmd_handler[pi.cmd].expect_payload) {
+		shs = cmd->pkt_size - sizeof(struct p_header);
+		if (pi.size - shs > 0 && !cmd->expect_payload) {
 			conn_err(tconn, "No payload expected %s l:%d\n", cmdname(pi.cmd), pi.size);
 			goto err_out;
 		}
@@ -3965,12 +3967,12 @@ static void drbdd(struct drbd_tconn *tconn)
 				goto err_out;
 		}
 
-		if (drbd_cmd_handler[pi.cmd].fa_type == CONN) {
-			err = drbd_cmd_handler[pi.cmd].conn_fn(tconn, pi.cmd, pi.size - shs);
+		if (cmd->fa_type == CONN) {
+			err = cmd->conn_fn(tconn, pi.cmd, pi.size - shs);
 		} else {
 			struct drbd_conf *mdev = vnr_to_mdev(tconn, pi.vnr);
 			err = mdev ?
-				drbd_cmd_handler[pi.cmd].mdev_fn(mdev, pi.cmd, pi.size - shs) :
+				cmd->mdev_fn(mdev, pi.cmd, pi.size - shs) :
 				tconn_receive_skip(tconn, pi.cmd, pi.size - shs);
 		}
 
-- 
1.7.4.1

