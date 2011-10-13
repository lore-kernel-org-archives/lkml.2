Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1JMKeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:34:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:58113 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab1JMKcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:32:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/10] drbd: Improve the "unexpected packet" error messages
Date: Thu, 13 Oct 2011 12:32:12 +0200
Message-Id: <1318501936-11689-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
References: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index d55a3cb..7218750 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3200,8 +3200,8 @@ static int ignore_remaining_packet(struct drbd_tconn *tconn, struct packet_info
  */
 static int config_unknown_volume(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	conn_warn(tconn, "Volume %u unknown; ignoring %s packet\n",
-		  pi->vnr, cmdname(pi->cmd));
+	conn_warn(tconn, "%s packet received for volume %u, which is not configured locally\n",
+		  cmdname(pi->cmd), pi->vnr);
 	return ignore_remaining_packet(tconn, pi);
 }
 
@@ -4256,13 +4256,15 @@ static void drbdd(struct drbd_tconn *tconn)
 
 		cmd = &drbd_cmd_handler[pi.cmd];
 		if (unlikely(pi.cmd >= ARRAY_SIZE(drbd_cmd_handler) || !cmd->fn)) {
-			conn_err(tconn, "unknown packet type %d, l: %d!\n", pi.cmd, pi.size);
+			conn_err(tconn, "Unexpected data packet %s (0x%04x)",
+				 cmdname(pi.cmd), pi.cmd);
 			goto err_out;
 		}
 
 		shs = cmd->pkt_size;
 		if (pi.size > shs && !cmd->expect_payload) {
-			conn_err(tconn, "No payload expected %s l:%d\n", cmdname(pi.cmd), pi.size);
+			conn_err(tconn, "No payload expected %s l:%d\n",
+				 cmdname(pi.cmd), pi.size);
 			goto err_out;
 		}
 
@@ -4474,7 +4476,7 @@ static int drbd_do_features(struct drbd_tconn *tconn)
 
 	if (pi.cmd != P_CONNECTION_FEATURES) {
 		conn_err(tconn, "expected ConnectionFeatures packet, received: %s (0x%04x)\n",
-		     cmdname(pi.cmd), pi.cmd);
+			 cmdname(pi.cmd), pi.cmd);
 		return -1;
 	}
 
@@ -4583,7 +4585,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 
 	if (pi.cmd != P_AUTH_CHALLENGE) {
 		conn_err(tconn, "expected AuthChallenge packet, received: %s (0x%04x)\n",
-		    cmdname(pi.cmd), pi.cmd);
+			 cmdname(pi.cmd), pi.cmd);
 		rv = 0;
 		goto fail;
 	}
@@ -4642,7 +4644,7 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 
 	if (pi.cmd != P_AUTH_RESPONSE) {
 		conn_err(tconn, "expected AuthResponse packet, received: %s (0x%04x)\n",
-			cmdname(pi.cmd), pi.cmd);
+			 cmdname(pi.cmd), pi.cmd);
 		rv = 0;
 		goto fail;
 	}
@@ -5192,8 +5194,8 @@ int drbd_asender(struct drbd_thread *thi)
 				goto reconnect;
 			cmd = &asender_tbl[pi.cmd];
 			if (pi.cmd >= ARRAY_SIZE(asender_tbl) || !cmd->fn) {
-				conn_err(tconn, "unknown command %d on meta (l: %d)\n",
-					pi.cmd, pi.size);
+				conn_err(tconn, "Unexpected meta packet %s (0x%04x)\n",
+					 cmdname(pi.cmd), pi.cmd);
 				goto disconnect;
 			}
 			expect = header_size + cmd->pkt_size;
-- 
1.7.4.1

