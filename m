Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1HYPLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:11:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33197 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab1HYPKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:23 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 117/118] drbd: implemented receiving of P_CONN_ST_CHG_REQ
Date: Thu, 25 Aug 2011 17:08:53 +0200
Message-Id: <1314284934-17999-118-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   10 ++++++++--
 drivers/block/drbd/drbd_state.h    |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index bdd3f00..e346245 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3235,9 +3235,14 @@ static int receive_req_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 	mask = convert_state(mask);
 	val = convert_state(val);
 
-	rv = drbd_change_state(mdev, CS_VERBOSE, mask, val);
+	if (cmd == P_CONN_ST_CHG_REQ) {
+		rv = conn_request_state(mdev->tconn, mask, val, CS_VERBOSE | CS_LOCAL_ONLY);
+		conn_send_sr_reply(mdev->tconn, rv);
+	} else {
+		rv = drbd_change_state(mdev, CS_VERBOSE, mask, val);
+		drbd_send_sr_reply(mdev, rv);
+	}
 
-	drbd_send_sr_reply(mdev, rv);
 	drbd_md_sync(mdev);
 
 	return true;
@@ -3771,6 +3776,7 @@ static struct data_cmd drbd_cmd_handler[] = {
 	[P_CSUM_RS_REQUEST] = { 1, sizeof(struct p_block_req), receive_DataRequest },
 	[P_DELAY_PROBE]     = { 0, sizeof(struct p_delay_probe93), receive_skip },
 	[P_OUT_OF_SYNC]     = { 0, sizeof(struct p_block_desc), receive_out_of_sync },
+	[P_CONN_ST_CHG_REQ] = { 0, sizeof(struct p_req_state), receive_req_state },
 	/* anything missing from this table is in
 	 * the asender_tbl, see get_asender_cmd */
 	[P_MAX_CMD]	    = { 0, 0, NULL },
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index d312d84..5fdbdf0 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -63,6 +63,7 @@ enum chg_state_flags {
 	CS_SERIALIZE    = 8,
 	CS_ORDERED      = CS_WAIT_COMPLETE + CS_SERIALIZE,
 	CS_NO_CSTATE_CHG = 16, /* Do not display changes in cstate. Internal to drbd_state.c */
+	CS_LOCAL_ONLY = 32, /* Do not consider a device pair wide state change */
 };
 
 extern enum drbd_state_rv drbd_change_state(struct drbd_conf *mdev,
-- 
1.7.4.1

