Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1HYPLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:11:39 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33213 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1HYPKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:22 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 115/118] drbd: Implemented conn_send_sr_reply()
Date: Thu, 25 Aug 2011 17:08:51 +0200
Message-Id: <1314284934-17999-116-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    1 +
 drivers/block/drbd/drbd_main.c |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 35e7303..4fc1b0db 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1216,6 +1216,7 @@ extern int drbd_send_ov_request(struct drbd_conf *mdev,sector_t sector,int size)
 extern int drbd_send_bitmap(struct drbd_conf *mdev);
 extern int _drbd_send_bitmap(struct drbd_conf *mdev);
 extern int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode);
+extern int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode);
 extern void drbd_free_bc(struct drbd_backing_dev *ldev);
 extern void drbd_mdev_cleanup(struct drbd_conf *mdev);
 void drbd_print_uuids(struct drbd_conf *mdev, const char *text);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c41d93c..c4ac636 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1002,6 +1002,16 @@ int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
 	return drbd_send_cmd(mdev, USE_META_SOCKET, P_STATE_CHG_REPLY, &p.head, sizeof(p));
 }
 
+int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode)
+{
+	struct p_req_state_reply p;
+	enum drbd_packet cmd = tconn->agreed_pro_version < 100 ? P_STATE_CHG_REPLY : P_CONN_ST_CHG_REPLY;
+
+	p.retcode    = cpu_to_be32(retcode);
+
+	return conn_send_cmd(tconn, 0, USE_META_SOCKET, cmd, &p.head, sizeof(p));
+}
+
 int fill_bitmap_rle_bits(struct drbd_conf *mdev,
 	struct p_compressed_bm *p,
 	struct bm_xfer_ctx *c)
-- 
1.7.4.1

