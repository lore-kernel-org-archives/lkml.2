Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab1IBKDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:03:10 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33134 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933301Ab1IBKAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:00:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/16] drbd: Separate connection state changes from minor dev state changes #1
Date: Fri,  2 Sep 2011 12:00:40 +0200
Message-Id: <1314957648-13242-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
References: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 17904f7..7e25a80 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3334,19 +3334,39 @@ static int receive_req_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 	mask = convert_state(mask);
 	val = convert_state(val);
 
-	if (cmd == P_CONN_ST_CHG_REQ) {
-		rv = conn_request_state(mdev->tconn, mask, val, CS_VERBOSE | CS_LOCAL_ONLY);
-		conn_send_sr_reply(mdev->tconn, rv);
-	} else {
-		rv = drbd_change_state(mdev, CS_VERBOSE, mask, val);
-		drbd_send_sr_reply(mdev, rv);
-	}
+	rv = drbd_change_state(mdev, CS_VERBOSE, mask, val);
+	drbd_send_sr_reply(mdev, rv);
 
 	drbd_md_sync(mdev);
 
 	return true;
 }
 
+static int receive_req_conn_state(struct drbd_tconn *tconn, enum drbd_packet cmd,
+				  unsigned int data_size)
+{
+	struct p_req_state *p = &tconn->data.rbuf.req_state;
+	union drbd_state mask, val;
+	enum drbd_state_rv rv;
+
+	mask.i = be32_to_cpu(p->mask);
+	val.i = be32_to_cpu(p->val);
+
+	if (test_bit(DISCARD_CONCURRENT, &tconn->flags) &&
+	    mutex_is_locked(&tconn->cstate_mutex)) {
+		conn_send_sr_reply(tconn, SS_CONCURRENT_ST_CHG);
+		return true;
+	}
+
+	mask = convert_state(mask);
+	val = convert_state(val);
+
+	rv = conn_request_state(tconn, mask, val, CS_VERBOSE | CS_LOCAL_ONLY);
+	conn_send_sr_reply(tconn, rv);
+
+	return true;
+}
+
 static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 			 unsigned int data_size)
 {
@@ -3894,7 +3914,7 @@ static struct data_cmd drbd_cmd_handler[] = {
 	[P_CSUM_RS_REQUEST] = { 1, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
 	[P_DELAY_PROBE]     = { 0, sizeof(struct p_delay_probe93), MDEV, { receive_skip } },
 	[P_OUT_OF_SYNC]     = { 0, sizeof(struct p_block_desc), MDEV, { receive_out_of_sync } },
-	[P_CONN_ST_CHG_REQ] = { 0, sizeof(struct p_req_state), MDEV, { receive_req_state } },
+	[P_CONN_ST_CHG_REQ] = { 0, sizeof(struct p_req_state), CONN, { .conn_fn = receive_req_conn_state } },
 };
 
 /* All handler functions that expect a sub-header get that sub-heder in
-- 
1.7.4.1

