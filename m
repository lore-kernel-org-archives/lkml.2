Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab1HaPNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:13:13 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59912 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab1HaPLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/16] drbd: Get rid of P_MAX_CMD
Date: Wed, 31 Aug 2011 17:10:58 +0200
Message-Id: <1314803468-1201-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Instead of artificially enlarging the command decoding arrays to
P_MAX_CMD entries, check if an index is within the valid range using the
ARRAY_SIZE() macro.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    1 -
 drivers/block/drbd/drbd_main.c     |    3 +--
 drivers/block/drbd/drbd_receiver.c |   10 ++++------
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index cda1039..c7b9fc9 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -225,7 +225,6 @@ enum drbd_packet {
 	P_CONN_ST_CHG_REPLY   = 0x2b, /* meta sock: Connection side state req reply */
 	P_RETRY_WRITE	      = 0x2c, /* Protocol C: retry conflicting write request */
 
-	P_MAX_CMD	      = 0x2d,
 	P_MAY_IGNORE	      = 0x100, /* Flag to test if (cmd > P_MAY_IGNORE) ... */
 	P_MAX_OPT_CMD	      = 0x101,
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index e71b6bf..eb51650 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3020,7 +3020,6 @@ const char *cmdname(enum drbd_packet cmd)
 		[P_DELAY_PROBE]         = "DelayProbe",
 		[P_OUT_OF_SYNC]		= "OutOfSync",
 		[P_RETRY_WRITE]		= "RetryWrite",
-		[P_MAX_CMD]	        = NULL,
 	};
 
 	if (cmd == P_HAND_SHAKE_M)
@@ -3029,7 +3028,7 @@ const char *cmdname(enum drbd_packet cmd)
 		return "HandShakeS";
 	if (cmd == P_HAND_SHAKE)
 		return "HandShake";
-	if (cmd >= P_MAX_CMD)
+	if (cmd >= ARRAY_SIZE(cmdnames))
 		return "Unknown";
 	return cmdnames[cmd];
 }
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6d19b57..9b29348 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3878,9 +3878,6 @@ static struct data_cmd drbd_cmd_handler[] = {
 	[P_DELAY_PROBE]     = { 0, sizeof(struct p_delay_probe93), receive_skip },
 	[P_OUT_OF_SYNC]     = { 0, sizeof(struct p_block_desc), receive_out_of_sync },
 	[P_CONN_ST_CHG_REQ] = { 0, sizeof(struct p_req_state), receive_req_state },
-	/* anything missing from this table is in
-	 * the asender_tbl, see get_asender_cmd */
-	[P_MAX_CMD]	    = { 0, 0, NULL },
 };
 
 /* All handler functions that expect a sub-header get that sub-heder in
@@ -3902,7 +3899,8 @@ static void drbdd(struct drbd_tconn *tconn)
 		if (!drbd_recv_header(tconn, &pi))
 			goto err_out;
 
-		if (unlikely(pi.cmd >= P_MAX_CMD || !drbd_cmd_handler[pi.cmd].function)) {
+		if (unlikely(pi.cmd >= ARRAY_SIZE(drbd_cmd_handler) ||
+		    !drbd_cmd_handler[pi.cmd].function)) {
 			conn_err(tconn, "unknown packet type %d, l: %d!\n", pi.cmd, pi.size);
 			goto err_out;
 		}
@@ -4681,9 +4679,9 @@ static struct asender_cmd *get_asender_cmd(int cmd)
 	[P_RS_CANCEL]       = { sizeof(struct p_block_ack), got_NegRSDReply},
 	[P_CONN_ST_CHG_REPLY]={ sizeof(struct p_req_state_reply), got_RqSReply },
 	[P_RETRY_WRITE]	    = { sizeof(struct p_block_ack), got_BlockAck },
-	[P_MAX_CMD]	    = { 0, NULL },
 	};
-	if (cmd > P_MAX_CMD || asender_tbl[cmd].process == NULL)
+
+	if (cmd >= ARRAY_SIZE(asender_tbl) || !asender_tbl[cmd].process)
 		return NULL;
 	return &asender_tbl[cmd];
 }
-- 
1.7.4.1

