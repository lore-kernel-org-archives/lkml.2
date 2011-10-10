Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1JJLzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:55:43 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45076 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab1JJLzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:55:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/13] drbd: drbd_adm_prepare(): Pass through error codes
Date: Mon, 10 Oct 2011 13:55:05 +0200
Message-Id: <1318247706-7732-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
References: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index fc0ea77..011f7f4 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -180,15 +180,19 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	       return -EPERM;
 
 	adm_ctx.reply_skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
-	if (!adm_ctx.reply_skb)
+	if (!adm_ctx.reply_skb) {
+		err = -ENOMEM;
 		goto fail;
+	}
 
 	adm_ctx.reply_dh = genlmsg_put_reply(adm_ctx.reply_skb,
 					info, &drbd_genl_family, 0, cmd);
 	/* put of a few bytes into a fresh skb of >= 4k will always succeed.
 	 * but anyways */
-	if (!adm_ctx.reply_dh)
+	if (!adm_ctx.reply_dh) {
+		err = -ENOMEM;
 		goto fail;
+	}
 
 	adm_ctx.reply_dh->minor = d_in->minor;
 	adm_ctx.reply_dh->ret_code = NO_ERROR;
@@ -257,7 +261,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 fail:
 	nlmsg_free(adm_ctx.reply_skb);
 	adm_ctx.reply_skb = NULL;
-	return -ENOMEM;
+	return err;
 }
 
 static int drbd_adm_finish(struct genl_info *info, int retcode)
-- 
1.7.4.1

