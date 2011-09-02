Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab1IBKDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:03:12 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33115 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab1IBKAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:00:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/16] drbd: Allow packet handler functions that take a connection
Date: Fri,  2 Sep 2011 12:00:38 +0200
Message-Id: <1314957648-13242-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
References: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is necessary in case a connection does not have a volume 0

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   75 ++++++++++++++++++++----------------
 1 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 7bb5e5c..1301ba1 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3856,39 +3856,45 @@ static int receive_out_of_sync(struct drbd_conf *mdev, enum drbd_packet cmd,
 	return true;
 }
 
-typedef int (*drbd_cmd_handler_f)(struct drbd_conf *, enum drbd_packet cmd,
-				  unsigned int to_receive);
-
 struct data_cmd {
 	int expect_payload;
 	size_t pkt_size;
-	drbd_cmd_handler_f function;
+	enum {
+		MDEV,
+		CONN,
+	} type;
+	union {
+		int (*mdev_fn)(struct drbd_conf *, enum drbd_packet cmd,
+				  unsigned int to_receive);
+		int (*conn_fn)(struct drbd_tconn *, enum drbd_packet cmd,
+				  unsigned int to_receive);
+	};
 };
 
 static struct data_cmd drbd_cmd_handler[] = {
-	[P_DATA]	    = { 1, sizeof(struct p_data), receive_Data },
-	[P_DATA_REPLY]	    = { 1, sizeof(struct p_data), receive_DataReply },
-	[P_RS_DATA_REPLY]   = { 1, sizeof(struct p_data), receive_RSDataReply } ,
-	[P_BARRIER]	    = { 0, sizeof(struct p_barrier), receive_Barrier } ,
-	[P_BITMAP]	    = { 1, sizeof(struct p_header), receive_bitmap } ,
-	[P_COMPRESSED_BITMAP] = { 1, sizeof(struct p_header), receive_bitmap } ,
-	[P_UNPLUG_REMOTE]   = { 0, sizeof(struct p_header), receive_UnplugRemote },
-	[P_DATA_REQUEST]    = { 0, sizeof(struct p_block_req), receive_DataRequest },
-	[P_RS_DATA_REQUEST] = { 0, sizeof(struct p_block_req), receive_DataRequest },
-	[P_SYNC_PARAM]	    = { 1, sizeof(struct p_header), receive_SyncParam },
-	[P_SYNC_PARAM89]    = { 1, sizeof(struct p_header), receive_SyncParam },
-	[P_PROTOCOL]        = { 1, sizeof(struct p_protocol), receive_protocol },
-	[P_UUIDS]	    = { 0, sizeof(struct p_uuids), receive_uuids },
-	[P_SIZES]	    = { 0, sizeof(struct p_sizes), receive_sizes },
-	[P_STATE]	    = { 0, sizeof(struct p_state), receive_state },
-	[P_STATE_CHG_REQ]   = { 0, sizeof(struct p_req_state), receive_req_state },
-	[P_SYNC_UUID]       = { 0, sizeof(struct p_rs_uuid), receive_sync_uuid },
-	[P_OV_REQUEST]      = { 0, sizeof(struct p_block_req), receive_DataRequest },
-	[P_OV_REPLY]        = { 1, sizeof(struct p_block_req), receive_DataRequest },
-	[P_CSUM_RS_REQUEST] = { 1, sizeof(struct p_block_req), receive_DataRequest },
-	[P_DELAY_PROBE]     = { 0, sizeof(struct p_delay_probe93), receive_skip },
-	[P_OUT_OF_SYNC]     = { 0, sizeof(struct p_block_desc), receive_out_of_sync },
-	[P_CONN_ST_CHG_REQ] = { 0, sizeof(struct p_req_state), receive_req_state },
+	[P_DATA]	    = { 1, sizeof(struct p_data), MDEV, { receive_Data } },
+	[P_DATA_REPLY]	    = { 1, sizeof(struct p_data), MDEV, { receive_DataReply } },
+	[P_RS_DATA_REPLY]   = { 1, sizeof(struct p_data), MDEV, { receive_RSDataReply } } ,
+	[P_BARRIER]	    = { 0, sizeof(struct p_barrier), MDEV, { receive_Barrier } } ,
+	[P_BITMAP]	    = { 1, sizeof(struct p_header), MDEV, { receive_bitmap } } ,
+	[P_COMPRESSED_BITMAP] = { 1, sizeof(struct p_header), MDEV, { receive_bitmap } } ,
+	[P_UNPLUG_REMOTE]   = { 0, sizeof(struct p_header), MDEV, { receive_UnplugRemote } },
+	[P_DATA_REQUEST]    = { 0, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
+	[P_RS_DATA_REQUEST] = { 0, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
+	[P_SYNC_PARAM]	    = { 1, sizeof(struct p_header), MDEV, { receive_SyncParam } },
+	[P_SYNC_PARAM89]    = { 1, sizeof(struct p_header), MDEV, { receive_SyncParam } },
+	[P_PROTOCOL]        = { 1, sizeof(struct p_protocol), MDEV, { receive_protocol } },
+	[P_UUIDS]	    = { 0, sizeof(struct p_uuids), MDEV, { receive_uuids } },
+	[P_SIZES]	    = { 0, sizeof(struct p_sizes), MDEV, { receive_sizes } },
+	[P_STATE]	    = { 0, sizeof(struct p_state), MDEV, { receive_state } },
+	[P_STATE_CHG_REQ]   = { 0, sizeof(struct p_req_state), MDEV, { receive_req_state } },
+	[P_SYNC_UUID]       = { 0, sizeof(struct p_rs_uuid), MDEV, { receive_sync_uuid } },
+	[P_OV_REQUEST]      = { 0, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
+	[P_OV_REPLY]        = { 1, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
+	[P_CSUM_RS_REQUEST] = { 1, sizeof(struct p_block_req), MDEV, { receive_DataRequest } },
+	[P_DELAY_PROBE]     = { 0, sizeof(struct p_delay_probe93), MDEV, { receive_skip } },
+	[P_OUT_OF_SYNC]     = { 0, sizeof(struct p_block_desc), MDEV, { receive_out_of_sync } },
+	[P_CONN_ST_CHG_REQ] = { 0, sizeof(struct p_req_state), MDEV, { receive_req_state } },
 };
 
 /* All handler functions that expect a sub-header get that sub-heder in
@@ -3901,7 +3907,6 @@ static struct data_cmd drbd_cmd_handler[] = {
 static void drbdd(struct drbd_tconn *tconn)
 {
 	struct p_header *header = &tconn->data.rbuf.header;
-	struct drbd_conf *mdev;
 	struct packet_info pi;
 	size_t shs; /* sub header size */
 	int rv;
@@ -3912,7 +3917,7 @@ static void drbdd(struct drbd_tconn *tconn)
 			goto err_out;
 
 		if (unlikely(pi.cmd >= ARRAY_SIZE(drbd_cmd_handler) ||
-		    !drbd_cmd_handler[pi.cmd].function)) {
+		    !drbd_cmd_handler[pi.cmd].mdev_fn)) {
 			conn_err(tconn, "unknown packet type %d, l: %d!\n", pi.cmd, pi.size);
 			goto err_out;
 		}
@@ -3932,10 +3937,14 @@ static void drbdd(struct drbd_tconn *tconn)
 			}
 		}
 
-		mdev = vnr_to_mdev(tconn, pi.vnr);
-		rv = mdev ?
-			drbd_cmd_handler[pi.cmd].function(mdev, pi.cmd, pi.size - shs) :
-			tconn_receive_skip(tconn, pi.cmd, pi.size - shs);
+		if (drbd_cmd_handler[pi.cmd].type == CONN) {
+			rv = drbd_cmd_handler[pi.cmd].conn_fn(tconn, pi.cmd, pi.size - shs);
+		} else {
+			struct drbd_conf *mdev = vnr_to_mdev(tconn, pi.vnr);
+			rv = mdev ?
+				drbd_cmd_handler[pi.cmd].mdev_fn(mdev, pi.cmd, pi.size - shs) :
+				tconn_receive_skip(tconn, pi.cmd, pi.size - shs);
+		}
 
 		if (unlikely(!rv)) {
 			conn_err(tconn, "error receiving %s, l: %d!\n",
-- 
1.7.4.1

