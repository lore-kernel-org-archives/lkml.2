Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1IELvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:51:10 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59870 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1IELpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/54] drbd: drbd_send_sync_param(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:00 +0200
Message-Id: <1315223145-20640-10-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c     |    8 ++++----
 drivers/block/drbd/drbd_receiver.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index b2f1022..7a5019a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -769,7 +769,7 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 {
 	struct p_rs_param_95 *p;
 	struct socket *sock;
-	int size, rv;
+	int size, err;
 	const int apv = mdev->tconn->agreed_pro_version;
 
 	size = apv <= 87 ? sizeof(struct p_rs_param)
@@ -813,13 +813,13 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 		if (apv >= 89)
 			strcpy(p->csums_alg, mdev->tconn->net_conf->csums_alg);
 
-		rv = !_drbd_send_cmd(mdev, sock, cmd, &p->head, size, 0);
+		err = _drbd_send_cmd(mdev, sock, cmd, &p->head, size, 0);
 	} else
-		rv = 0; /* not ok */
+		err = -EIO;
 
 	mutex_unlock(&mdev->tconn->data.mutex);
 
-	return rv;
+	return err;
 }
 
 int drbd_send_protocol(struct drbd_tconn *tconn)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 7431e3c..d93bb3c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -763,7 +763,7 @@ int drbd_connected(int vnr, void *p, void *data)
 		&mdev->tconn->cstate_mutex :
 		&mdev->own_state_mutex;
 
-	ok &= drbd_send_sync_param(mdev);
+	ok &= !drbd_send_sync_param(mdev);
 	ok &= drbd_send_sizes(mdev, 0, 0);
 	ok &= drbd_send_uuids(mdev);
 	ok &= drbd_send_state(mdev);
-- 
1.7.4.1

