Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1HYPLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:11:25 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33318 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1HYPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:22 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 116/118] drbd: Implemented receiving of P_CONN_ST_CHG_REPLY
Date: Thu, 25 Aug 2011 17:08:52 +0200
Message-Id: <1314284934-17999-117-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 ++
 drivers/block/drbd/drbd_receiver.c |   28 ++++++++++++++++++++--------
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 4fc1b0db..ed3d498 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -913,6 +913,8 @@ enum {
 	SEND_PING,		/* whether asender should send a ping asap */
 	SIGNAL_ASENDER,		/* whether asender wants to be interrupted */
 	GOT_PING_ACK,		/* set when we receive a ping_ack packet, ping_wait gets woken */
+	CONN_WD_ST_CHG_OKAY,
+	CONN_WD_ST_CHG_FAIL,
 };
 
 struct drbd_tconn {			/* is a resource from the config file */
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 86d1e9b..bdd3f00 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4268,18 +4268,29 @@ int drbdd_init(struct drbd_thread *thi)
 static int got_RqSReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
 	struct p_req_state_reply *p = &mdev->tconn->meta.rbuf.req_state_reply;
+	struct drbd_tconn *tconn = mdev->tconn;
 
 	int retcode = be32_to_cpu(p->retcode);
 
-	if (retcode >= SS_SUCCESS) {
-		set_bit(CL_ST_CHG_SUCCESS, &mdev->flags);
-	} else {
-		set_bit(CL_ST_CHG_FAIL, &mdev->flags);
-		dev_err(DEV, "Requested state change failed by peer: %s (%d)\n",
-		    drbd_set_st_err_str(retcode), retcode);
+	if (cmd == P_STATE_CHG_REPLY) {
+		if (retcode >= SS_SUCCESS) {
+			set_bit(CL_ST_CHG_SUCCESS, &mdev->flags);
+		} else {
+			set_bit(CL_ST_CHG_FAIL, &mdev->flags);
+			dev_err(DEV, "Requested state change failed by peer: %s (%d)\n",
+				drbd_set_st_err_str(retcode), retcode);
+		}
+		wake_up(&mdev->state_wait);
+	} else /* conn == P_CONN_ST_CHG_REPLY */ {
+		if (retcode >= SS_SUCCESS) {
+			set_bit(CONN_WD_ST_CHG_OKAY, &tconn->flags);
+		} else {
+			set_bit(CONN_WD_ST_CHG_FAIL, &tconn->flags);
+			conn_err(tconn, "Requested state change failed by peer: %s (%d)\n",
+				 drbd_set_st_err_str(retcode), retcode);
+		}
+		wake_up(&tconn->ping_wait);
 	}
-	wake_up(&mdev->state_wait);
-
 	return true;
 }
 
@@ -4556,6 +4567,7 @@ static struct asender_cmd *get_asender_cmd(int cmd)
 	[P_RS_IS_IN_SYNC]   = { sizeof(struct p_block_ack), got_IsInSync },
 	[P_DELAY_PROBE]     = { sizeof(struct p_delay_probe93), got_skip },
 	[P_RS_CANCEL]       = { sizeof(struct p_block_ack), got_NegRSDReply},
+	[P_CONN_ST_CHG_REPLY]={ sizeof(struct p_req_state_reply), got_RqSReply },
 	[P_MAX_CMD]	    = { 0, NULL },
 	};
 	if (cmd > P_MAX_CMD || asender_tbl[cmd].process == NULL)
-- 
1.7.4.1

