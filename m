Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab1IBKA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:00:58 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33022 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960Ab1IBKAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:00:50 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/16] drbd: New minors have to intherit the connection state form their connection
Date: Fri,  2 Sep 2011 12:00:34 +0200
Message-Id: <1314957648-13242-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
References: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    1 +
 drivers/block/drbd/drbd_main.c     |    5 +++++
 drivers/block/drbd/drbd_receiver.c |    5 +++--
 drivers/block/drbd/drbd_state.c    |    4 ++--
 4 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d84a073..05bb9fd 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1595,6 +1595,7 @@ extern void _drbd_wait_ee_list_empty(struct drbd_conf *mdev,
 extern void drbd_set_recv_tcq(struct drbd_conf *mdev, int tcq_enabled);
 extern void _drbd_clear_done_ee(struct drbd_conf *mdev, struct list_head *to_be_freed);
 extern void conn_flush_workqueue(struct drbd_tconn *tconn);
+extern int drbd_connected(int vnr, void *p, void *data);
 static inline void drbd_flush_workqueue(struct drbd_conf *mdev)
 {
 	conn_flush_workqueue(mdev->tconn);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index de49c8d..4bfffe9 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2410,6 +2410,11 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	}
 	add_disk(disk);
 
+	/* inherit the connection state */
+	mdev->state.conn = tconn->cstate;
+	if (mdev->state.conn == C_WF_REPORT_PARAMS)
+		drbd_connected(vnr, mdev, tconn);
+
 	return NO_ERROR;
 
 out_idr_remove_vol:
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 956a0e2..1c83a12 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -744,8 +744,9 @@ static int drbd_socket_okay(struct socket **sock)
 		return false;
 	}
 }
-
-static int drbd_connected(int vnr, void *p, void *data)
+/* Gets called if a connection is established, or if a new minor gets created
+   in a connection */
+int drbd_connected(int vnr, void *p, void *data)
 {
 	struct drbd_conf *mdev = (struct drbd_conf *)p;
 	int ok = 1;
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 3ca535e..37b52d7 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -433,8 +433,8 @@ is_valid_soft_transition(union drbd_state os, union drbd_state ns)
 	if (ns.conn == C_DISCONNECTING && os.conn == C_UNCONNECTED)
 		rv = SS_IN_TRANSIENT_STATE;
 
-	if (ns.conn == os.conn && ns.conn == C_WF_REPORT_PARAMS)
-		rv = SS_IN_TRANSIENT_STATE;
+	/* if (ns.conn == os.conn && ns.conn == C_WF_REPORT_PARAMS)
+	   rv = SS_IN_TRANSIENT_STATE; */
 
 	if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) && os.conn < C_CONNECTED)
 		rv = SS_NEED_CONNECTION;
-- 
1.7.4.1

