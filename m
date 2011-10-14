Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1JNWA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:00:28 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60868 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab1JNV5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:57:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/11] drbd: report net config even for resources without a single volume
Date: Fri, 14 Oct 2011 23:57:43 +0200
Message-Id: <1318629472-11110-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
References: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Currently it is legal (though unusual) to create and connect a resource,
before adding in all necessary volumes. We should include the network
configuration details, even if we don't have a single volume (yet).

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index a71a5f5..3250c8f 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2783,14 +2783,18 @@ next_tconn:
 			goto out;
 
 		if (!mdev) {
-			/* this is a tconn without a single volume */
+			/* This is a tconn without a single volume.
+			 * Suprisingly enough, it may have a network
+			 * configuration. */
+			struct net_conf *nc;
 			dh->minor = -1U;
 			dh->ret_code = NO_ERROR;
 			if (nla_put_drbd_cfg_context(skb, tconn, VOLUME_UNSPECIFIED))
-				genlmsg_cancel(skb, dh);
-			else
-				genlmsg_end(skb, dh);
-			goto out;
+				goto cancel;
+			nc = rcu_dereference(tconn->net_conf);
+			if (nc && net_conf_to_skb(skb, nc, 1) != 0)
+				goto cancel;
+			goto done;
 		}
 
 		D_ASSERT(mdev->vnr == volume);
@@ -2800,9 +2804,11 @@ next_tconn:
 		dh->ret_code = NO_ERROR;
 
 		if (nla_put_status_info(skb, mdev, NULL)) {
+cancel:
 			genlmsg_cancel(skb, dh);
 			goto out;
 		}
+done:
 		genlmsg_end(skb, dh);
         }
 
-- 
1.7.4.1

