Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1IELv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:51:27 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59865 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1IELpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:54 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/54] drbd: drbd_send_protocol(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:03 +0200
Message-Id: <1315223145-20640-13-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c     |   10 +++++-----
 drivers/block/drbd/drbd_receiver.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 4e53450..9ee7cf1 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -825,7 +825,7 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 int drbd_send_protocol(struct drbd_tconn *tconn)
 {
 	struct p_protocol *p;
-	int size, cf, rv;
+	int size, cf, err;
 
 	size = sizeof(struct p_protocol);
 
@@ -836,7 +836,7 @@ int drbd_send_protocol(struct drbd_tconn *tconn)
 	 * as that is blocked during handshake */
 	p = kmalloc(size, GFP_NOIO);
 	if (p == NULL)
-		return 0;
+		return -ENOMEM;
 
 	p->protocol      = cpu_to_be32(tconn->net_conf->wire_protocol);
 	p->after_sb_0p   = cpu_to_be32(tconn->net_conf->after_sb_0p);
@@ -853,7 +853,7 @@ int drbd_send_protocol(struct drbd_tconn *tconn)
 		else {
 			conn_err(tconn, "--dry-run is not supported by peer");
 			kfree(p);
-			return -1;
+			return -EOPNOTSUPP;
 		}
 	}
 	p->conn_flags    = cpu_to_be32(cf);
@@ -861,9 +861,9 @@ int drbd_send_protocol(struct drbd_tconn *tconn)
 	if (tconn->agreed_pro_version >= 87)
 		strcpy(p->integrity_alg, tconn->net_conf->integrity_alg);
 
-	rv = !conn_send_cmd2(tconn, P_PROTOCOL, p->head.payload, size);
+	err = conn_send_cmd2(tconn, P_PROTOCOL, p->head.payload, size);
 	kfree(p);
-	return rv;
+	return err;
 }
 
 int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 91de208..0ca559b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -931,7 +931,7 @@ retry:
 
 	drbd_thread_start(&tconn->asender);
 
-	if (drbd_send_protocol(tconn) == -1)
+	if (drbd_send_protocol(tconn) == -EOPNOTSUPP)
 		return -1;
 
 	return !idr_for_each(&tconn->volumes, drbd_connected, tconn);
-- 
1.7.4.1

