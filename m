Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1IWObb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:31:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39500 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab1IWOb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:31:28 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/10] drbd: drbd_send_ping(), drbd_send_ping(): Return 0 upon success and an error code otherwise
Date: Fri, 23 Sep 2011 16:31:16 +0200
Message-Id: <1316788285-17433-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     |    4 ++--
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a6459f7..7d7b30c 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -768,13 +768,13 @@ int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd, char *data,
 int drbd_send_ping(struct drbd_tconn *tconn)
 {
 	struct p_header h;
-	return !conn_send_cmd(tconn, 0, &tconn->meta, P_PING, &h, sizeof(h));
+	return conn_send_cmd(tconn, 0, &tconn->meta, P_PING, &h, sizeof(h));
 }
 
 int drbd_send_ping_ack(struct drbd_tconn *tconn)
 {
 	struct p_header h;
-	return !conn_send_cmd(tconn, 0, &tconn->meta, P_PING_ACK, &h, sizeof(h));
+	return conn_send_cmd(tconn, 0, &tconn->meta, P_PING_ACK, &h, sizeof(h));
 }
 
 int drbd_send_sync_param(struct drbd_conf *mdev)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6e6b829..6879082 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4501,7 +4501,7 @@ static int got_RqSReply(struct drbd_tconn *tconn, struct packet_info *pi)
 
 static int got_Ping(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	return drbd_send_ping_ack(tconn);
+	return !drbd_send_ping_ack(tconn);
 
 }
 
@@ -4854,7 +4854,7 @@ int drbd_asender(struct drbd_thread *thi)
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
 		if (test_and_clear_bit(SEND_PING, &tconn->flags)) {
-			if (!drbd_send_ping(tconn)) {
+			if (drbd_send_ping(tconn)) {
 				conn_err(tconn, "drbd_send_ping has failed\n");
 				goto reconnect;
 			}
-- 
1.7.4.1

