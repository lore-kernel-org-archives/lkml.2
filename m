Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab1IBKBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:01:02 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33127 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298Ab1IBKAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:00:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/16] drbd: Converted receive_protocol() from mdev to tconn
Date: Fri,  2 Sep 2011 12:00:39 +0200
Message-Id: <1314957648-13242-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
References: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   46 ++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1301ba1..17904f7 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2856,10 +2856,10 @@ static int cmp_after_sb(enum drbd_after_sb_p peer, enum drbd_after_sb_p self)
 	return 1;
 }
 
-static int receive_protocol(struct drbd_conf *mdev, enum drbd_packet cmd,
+static int receive_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd,
 			    unsigned int data_size)
 {
-	struct p_protocol *p = &mdev->tconn->data.rbuf.protocol;
+	struct p_protocol *p = &tconn->data.rbuf.protocol;
 	int p_proto, p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
 	int p_want_lose, p_two_primaries, cf;
 	char p_integrity_alg[SHARED_SECRET_MAX] = "";
@@ -2872,60 +2872,60 @@ static int receive_protocol(struct drbd_conf *mdev, enum drbd_packet cmd,
 	cf		= be32_to_cpu(p->conn_flags);
 	p_want_lose = cf & CF_WANT_LOSE;
 
-	clear_bit(CONN_DRY_RUN, &mdev->tconn->flags);
+	clear_bit(CONN_DRY_RUN, &tconn->flags);
 
 	if (cf & CF_DRY_RUN)
-		set_bit(CONN_DRY_RUN, &mdev->tconn->flags);
+		set_bit(CONN_DRY_RUN, &tconn->flags);
 
-	if (p_proto != mdev->tconn->net_conf->wire_protocol) {
-		dev_err(DEV, "incompatible communication protocols\n");
+	if (p_proto != tconn->net_conf->wire_protocol) {
+		conn_err(tconn, "incompatible communication protocols\n");
 		goto disconnect;
 	}
 
-	if (cmp_after_sb(p_after_sb_0p, mdev->tconn->net_conf->after_sb_0p)) {
-		dev_err(DEV, "incompatible after-sb-0pri settings\n");
+	if (cmp_after_sb(p_after_sb_0p, tconn->net_conf->after_sb_0p)) {
+		conn_err(tconn, "incompatible after-sb-0pri settings\n");
 		goto disconnect;
 	}
 
-	if (cmp_after_sb(p_after_sb_1p, mdev->tconn->net_conf->after_sb_1p)) {
-		dev_err(DEV, "incompatible after-sb-1pri settings\n");
+	if (cmp_after_sb(p_after_sb_1p, tconn->net_conf->after_sb_1p)) {
+		conn_err(tconn, "incompatible after-sb-1pri settings\n");
 		goto disconnect;
 	}
 
-	if (cmp_after_sb(p_after_sb_2p, mdev->tconn->net_conf->after_sb_2p)) {
-		dev_err(DEV, "incompatible after-sb-2pri settings\n");
+	if (cmp_after_sb(p_after_sb_2p, tconn->net_conf->after_sb_2p)) {
+		conn_err(tconn, "incompatible after-sb-2pri settings\n");
 		goto disconnect;
 	}
 
-	if (p_want_lose && mdev->tconn->net_conf->want_lose) {
-		dev_err(DEV, "both sides have the 'want_lose' flag set\n");
+	if (p_want_lose && tconn->net_conf->want_lose) {
+		conn_err(tconn, "both sides have the 'want_lose' flag set\n");
 		goto disconnect;
 	}
 
-	if (p_two_primaries != mdev->tconn->net_conf->two_primaries) {
-		dev_err(DEV, "incompatible setting of the two-primaries options\n");
+	if (p_two_primaries != tconn->net_conf->two_primaries) {
+		conn_err(tconn, "incompatible setting of the two-primaries options\n");
 		goto disconnect;
 	}
 
-	if (mdev->tconn->agreed_pro_version >= 87) {
-		unsigned char *my_alg = mdev->tconn->net_conf->integrity_alg;
+	if (tconn->agreed_pro_version >= 87) {
+		unsigned char *my_alg = tconn->net_conf->integrity_alg;
 
-		if (drbd_recv(mdev->tconn, p_integrity_alg, data_size) != data_size)
+		if (drbd_recv(tconn, p_integrity_alg, data_size) != data_size)
 			return false;
 
 		p_integrity_alg[SHARED_SECRET_MAX-1] = 0;
 		if (strcmp(p_integrity_alg, my_alg)) {
-			dev_err(DEV, "incompatible setting of the data-integrity-alg\n");
+			conn_err(tconn, "incompatible setting of the data-integrity-alg\n");
 			goto disconnect;
 		}
-		dev_info(DEV, "data-integrity-alg: %s\n",
+		conn_info(tconn, "data-integrity-alg: %s\n",
 		     my_alg[0] ? my_alg : (unsigned char *)"<not-used>");
 	}
 
 	return true;
 
 disconnect:
-	conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+	conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 	return false;
 }
 
@@ -3883,7 +3883,7 @@ static struct data_cmd drbd_cmd_handler[] = {
 	[P_RS_DATA_REQUEST] = { 0, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
 	[P_SYNC_PARAM]	    = { 1, sizeof(struct p_header), MDEV, { receive_SyncParam } },
 	[P_SYNC_PARAM89]    = { 1, sizeof(struct p_header), MDEV, { receive_SyncParam } },
-	[P_PROTOCOL]        = { 1, sizeof(struct p_protocol), MDEV, { receive_protocol } },
+	[P_PROTOCOL]        = { 1, sizeof(struct p_protocol), CONN, { .conn_fn = receive_protocol } },
 	[P_UUIDS]	    = { 0, sizeof(struct p_uuids), MDEV, { receive_uuids } },
 	[P_SIZES]	    = { 0, sizeof(struct p_sizes), MDEV, { receive_sizes } },
 	[P_STATE]	    = { 0, sizeof(struct p_state), MDEV, { receive_state } },
-- 
1.7.4.1

