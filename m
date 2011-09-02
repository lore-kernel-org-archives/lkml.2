Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab1IBKBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:01:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33146 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303Ab1IBKAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:00:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/16] drbd: Converted got_Ping() and got_PingAck() from mdev to tconn
Date: Fri,  2 Sep 2011 12:00:42 +0200
Message-Id: <1314957648-13242-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
References: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 0117dcd..e28f194 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4444,15 +4444,14 @@ static int got_RqSReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 	return true;
 }
 
-static int got_Ping(struct drbd_conf *mdev, enum drbd_packet cmd)
+static int got_Ping(struct drbd_tconn *tconn, enum drbd_packet cmd)
 {
-	return drbd_send_ping_ack(mdev->tconn);
+	return drbd_send_ping_ack(tconn);
 
 }
 
-static int got_PingAck(struct drbd_conf *mdev, enum drbd_packet cmd)
+static int got_PingAck(struct drbd_tconn *tconn, enum drbd_packet cmd)
 {
-	struct drbd_tconn *tconn = mdev->tconn;
 	/* restore idle timeout */
 	tconn->meta.socket->sk->sk_rcvtimeo = tconn->net_conf->ping_int*HZ;
 	if (!test_and_set_bit(GOT_PING_ACK, &tconn->flags))
@@ -4732,8 +4731,8 @@ struct asender_cmd {
 };
 
 static struct asender_cmd asender_tbl[] = {
-	[P_PING]	    = { sizeof(struct p_header), MDEV, { got_Ping } },
-	[P_PING_ACK]	    = { sizeof(struct p_header), MDEV, { got_PingAck } },
+	[P_PING]	    = { sizeof(struct p_header), CONN, { .conn_fn = got_Ping } },
+	[P_PING_ACK]	    = { sizeof(struct p_header), CONN, { .conn_fn = got_PingAck } },
 	[P_RECV_ACK]	    = { sizeof(struct p_block_ack), MDEV, { got_BlockAck } },
 	[P_WRITE_ACK]	    = { sizeof(struct p_block_ack), MDEV, { got_BlockAck } },
 	[P_RS_WRITE_ACK]    = { sizeof(struct p_block_ack), MDEV, { got_BlockAck } },
-- 
1.7.4.1

