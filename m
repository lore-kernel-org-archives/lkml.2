Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1IELqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:46:32 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59852 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1IELpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/54] drbd: drbd_send_handshake(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:02 +0200
Message-Id: <1315223145-20640-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 66772be..91de208 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4133,25 +4133,25 @@ static int drbd_send_handshake(struct drbd_tconn *tconn)
 {
 	/* ASSERT current == mdev->tconn->receiver ... */
 	struct p_handshake *p = &tconn->data.sbuf.handshake;
-	int ok;
+	int err;
 
 	if (mutex_lock_interruptible(&tconn->data.mutex)) {
 		conn_err(tconn, "interrupted during initial handshake\n");
-		return 0; /* interrupted. not ok. */
+		return -EINTR;
 	}
 
 	if (tconn->data.socket == NULL) {
 		mutex_unlock(&tconn->data.mutex);
-		return 0;
+		return -EIO;
 	}
 
 	memset(p, 0, sizeof(*p));
 	p->protocol_min = cpu_to_be32(PRO_VERSION_MIN);
 	p->protocol_max = cpu_to_be32(PRO_VERSION_MAX);
-	ok = !_conn_send_cmd(tconn, 0, tconn->data.socket, P_HAND_SHAKE,
+	err = _conn_send_cmd(tconn, 0, tconn->data.socket, P_HAND_SHAKE,
 			     &p->head, sizeof(*p), 0);
 	mutex_unlock(&tconn->data.mutex);
-	return ok;
+	return err;
 }
 
 /*
@@ -4167,10 +4167,10 @@ static int drbd_do_handshake(struct drbd_tconn *tconn)
 	struct p_handshake *p = &tconn->data.rbuf.handshake;
 	const int expect = sizeof(struct p_handshake) - sizeof(struct p_header80);
 	struct packet_info pi;
-	int rv;
+	int err, rv;
 
-	rv = drbd_send_handshake(tconn);
-	if (!rv)
+	err = drbd_send_handshake(tconn);
+	if (err)
 		return 0;
 
 	rv = drbd_recv_header(tconn, &pi);
-- 
1.7.4.1

