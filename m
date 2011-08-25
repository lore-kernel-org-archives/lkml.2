Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1HYPLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:11:50 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33197 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab1HYPKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 113/118] drbd: Implemented conn_send_state_req()
Date: Thu, 25 Aug 2011 17:08:49 +0200
Message-Id: <1314284934-17999-114-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h   |   19 ++++++++++++++++++-
 drivers/block/drbd/drbd_main.c  |    6 +++---
 drivers/block/drbd/drbd_state.c |    2 --
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index a321bf9..35e7303 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -220,8 +220,10 @@ enum drbd_packet {
 	P_DELAY_PROBE         = 0x27, /* is used on BOTH sockets */
 	P_OUT_OF_SYNC         = 0x28, /* Mark as out of sync (Outrunning), data socket */
 	P_RS_CANCEL           = 0x29, /* meta: Used to cancel RS_DATA_REQUEST packet by SyncSource */
+	P_CONN_ST_CHG_REQ     = 0x2a, /* data sock: Connection wide state request */
+	P_CONN_ST_CHG_REPLY   = 0x2b, /* meta sock: Connection side state req reply */
 
-	P_MAX_CMD	      = 0x2A,
+	P_MAX_CMD	      = 0x2c,
 	P_MAY_IGNORE	      = 0x100, /* Flag to test if (cmd > P_MAY_IGNORE) ... */
 	P_MAX_OPT_CMD	      = 0x101,
 
@@ -1176,6 +1178,8 @@ extern int drbd_send_uuids(struct drbd_conf *mdev);
 extern int drbd_send_uuids_skip_initial_sync(struct drbd_conf *mdev);
 extern int drbd_gen_and_send_sync_uuid(struct drbd_conf *mdev);
 extern int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags flags);
+extern int _conn_send_state_req(struct drbd_tconn *, int vnr, enum drbd_packet cmd,
+				union drbd_state, union drbd_state);
 extern int _drbd_send_state(struct drbd_conf *mdev);
 extern int drbd_send_state(struct drbd_conf *mdev);
 extern int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct socket *sock,
@@ -1895,6 +1899,19 @@ static inline int drbd_send_ping_ack(struct drbd_tconn *tconn)
 	return conn_send_cmd(tconn, 0, USE_META_SOCKET, P_PING_ACK, &h, sizeof(h));
 }
 
+static inline int drbd_send_state_req(struct drbd_conf *mdev,
+				      union drbd_state mask, union drbd_state val)
+{
+	return _conn_send_state_req(mdev->tconn, mdev->vnr, P_STATE_CHG_REQ, mask, val);
+}
+
+static inline int conn_send_state_req(struct drbd_tconn *tconn,
+				      union drbd_state mask, union drbd_state val)
+{
+	enum drbd_packet cmd = tconn->agreed_pro_version < 100 ? P_STATE_CHG_REQ : P_CONN_ST_CHG_REQ;
+	return _conn_send_state_req(tconn, 0, cmd, mask, val);
+}
+
 static inline void drbd_thread_stop(struct drbd_thread *thi)
 {
 	_drbd_thread_stop(thi, false, true);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index adfef15..c41d93c 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -982,15 +982,15 @@ int drbd_send_state(struct drbd_conf *mdev)
 	return ok;
 }
 
-int drbd_send_state_req(struct drbd_conf *mdev,
-	union drbd_state mask, union drbd_state val)
+int _conn_send_state_req(struct drbd_tconn *tconn, int vnr, enum drbd_packet cmd,
+			 union drbd_state mask, union drbd_state val)
 {
 	struct p_req_state p;
 
 	p.mask    = cpu_to_be32(mask.i);
 	p.val     = cpu_to_be32(val.i);
 
-	return drbd_send_cmd(mdev, USE_DATA_SOCKET, P_STATE_CHG_REQ, &p.head, sizeof(p));
+	return conn_send_cmd(tconn, vnr, USE_DATA_SOCKET, cmd, &p.head, sizeof(p));
 }
 
 int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 29308e0..db2aee9 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -37,9 +37,7 @@ struct after_state_chg_work {
 	struct completion *done;
 };
 
-
 extern void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what);
-int drbd_send_state_req(struct drbd_conf *, union drbd_state, union drbd_state);
 static int w_after_state_ch(struct drbd_work *w, int unused);
 static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
-- 
1.7.4.1

