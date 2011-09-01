Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1IAMu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:50:29 -0400
Received: from mail09.linbit.com ([212.69.161.110]:55664 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab1IAMtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:49:14 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 16/18] drbd: bail out if a config requrest is over-determined, and not matching
Date: Thu,  1 Sep 2011 14:49:03 +0200
Message-Id: <1314881345-6420-17-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
References: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

We have resources resp. connections, volumes, and minor numbers.
A config request may specifies all three of them.
If it turns out that the minor belongs to a different connection, or a
different volume number in the same connection, that configuration
request is invalid.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index e89d108..773946d 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -232,20 +232,20 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	}
 
 	/* some more paranoia, if the request was over-determined */
+	if (adm_ctx.mdev && adm_ctx.tconn &&
+	    adm_ctx.mdev->tconn != adm_ctx.tconn) {
+		pr_warning("request: minor=%u, conn=%s; but that minor belongs to connection %s\n",
+				adm_ctx.minor, adm_ctx.conn_name, adm_ctx.mdev->tconn->name);
+		drbd_msg_put_info("minor exists in different connection");
+		return ERR_INVALID_REQUEST;
+	}
 	if (adm_ctx.mdev &&
 	    adm_ctx.volume != VOLUME_UNSPECIFIED &&
 	    adm_ctx.volume != adm_ctx.mdev->vnr) {
 		pr_warning("request: minor=%u, volume=%u; but that minor is volume %u in %s\n",
 				adm_ctx.minor, adm_ctx.volume,
 				adm_ctx.mdev->vnr, adm_ctx.mdev->tconn->name);
-		drbd_msg_put_info("over-determined configuration context mismatch");
-		return ERR_INVALID_REQUEST;
-	}
-	if (adm_ctx.mdev && adm_ctx.tconn &&
-	    adm_ctx.mdev->tconn != adm_ctx.tconn) {
-		pr_warning("request: minor=%u, conn=%s; but that minor belongs to connection %s\n",
-				adm_ctx.minor, adm_ctx.conn_name, adm_ctx.mdev->tconn->name);
-		drbd_msg_put_info("over-determined configuration context mismatch");
+		drbd_msg_put_info("minor exists as different volume");
 		return ERR_INVALID_REQUEST;
 	}
 	if (adm_ctx.mdev && !adm_ctx.tconn)
-- 
1.7.4.1

