Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1IELta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:49:30 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60165 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1IELp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:58 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 20/54] drbd: drbd_send_b_ack(): Return void: the result is never used
Date: Mon,  5 Sep 2011 13:45:11 +0200
Message-Id: <1315223145-20640-21-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h  |    4 ++--
 drivers/block/drbd/drbd_main.c |   10 +++-------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index b2e7c75..8e0f59b 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1181,8 +1181,8 @@ extern int conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct drbd_socket *
 extern int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd,
 			  char *data, size_t size);
 extern int drbd_send_sync_param(struct drbd_conf *mdev);
-extern int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr,
-			u32 set_size);
+extern void drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr,
+			    u32 set_size);
 extern int drbd_send_ack(struct drbd_conf *, enum drbd_packet,
 			 struct drbd_peer_request *);
 extern int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index d18030a..3bbe85b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1227,19 +1227,15 @@ int drbd_send_bitmap(struct drbd_conf *mdev)
 	drbd_put_data_sock(mdev->tconn);
 	return err;
 }
-
-int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr, u32 set_size)
+void drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr, u32 set_size)
 {
-	int ok;
 	struct p_barrier_ack p;
 
 	p.barrier  = barrier_nr;
 	p.set_size = cpu_to_be32(set_size);
 
-	if (mdev->state.conn < C_CONNECTED)
-		return false;
-	ok = !drbd_send_cmd(mdev, &mdev->tconn->meta, P_BARRIER_ACK, &p.head, sizeof(p));
-	return ok;
+	if (mdev->state.conn >= C_CONNECTED)
+		drbd_send_cmd(mdev, &mdev->tconn->meta, P_BARRIER_ACK, &p.head, sizeof(p));
 }
 
 /**
-- 
1.7.4.1

