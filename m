Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab1IAMvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:51:07 -0400
Received: from mail09.linbit.com ([212.69.161.110]:55673 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab1IAMtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:49:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 15/18] drbd: new-connection and new-minor succeed, if the object already exists
Date: Thu,  1 Sep 2011 14:49:02 +0200
Message-Id: <1314881345-6420-16-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
References: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Follow O_CREAT semantics when creating connection or minor device/volume
objects.  If we need O_CREAT|O_EXCL semantics some time down the road,
we can add NLM_F_EXCL to the netlink message flags.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 740649b..e89d108 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2625,8 +2625,11 @@ int drbd_adm_create_connection(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 
 	if (adm_ctx.tconn) {
-		retcode = ERR_INVALID_REQUEST;
-		drbd_msg_put_info("connection exists");
+		if (info->nlhdr->nlmsg_flags & NLM_F_EXCL) {
+			retcode = ERR_INVALID_REQUEST;
+			drbd_msg_put_info("connection exists");
+		}
+		/* else: still NO_ERROR */
 		goto out;
 	}
 
@@ -2659,6 +2662,15 @@ int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
 		return ERR_INVALID_REQUEST;
 	}
 
+	/* drbd_adm_prepare made sure already
+	 * that mdev->tconn and mdev->vnr match the request. */
+	if (adm_ctx.mdev) {
+		if (info->nlhdr->nlmsg_flags & NLM_F_EXCL)
+			retcode = ERR_MINOR_EXISTS;
+		/* else: still NO_ERROR */
+		goto out;
+	}
+
 	retcode = conn_new_minor(adm_ctx.tconn, dh->minor, adm_ctx.volume);
 out:
 	drbd_adm_finish(info, retcode);
-- 
1.7.4.1

