Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1HYPXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:23:22 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34374 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab1HYPJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:40 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 066/118] drbd: Revert "Make sure we dont send state if a cluster wide state change is in progress"
Date: Thu, 25 Aug 2011 17:08:02 +0200
Message-Id: <1314284934-17999-67-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 6e9fdc92b77915d5c7ab8fea751f48378f8b0080.

1) This did not fixed the issue
2) Long sleeping work items can cause IO requests to take as long as
   the longest work item

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index ed43cdc..dbd6d72 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -951,10 +951,6 @@ int drbd_send_state(struct drbd_conf *mdev)
 	struct p_state p;
 	int ok = 0;
 
-	/* Grab state lock so we wont send state if we're in the middle
-	 * of a cluster wide state change on another thread */
-	drbd_state_lock(mdev);
-
 	mutex_lock(&mdev->tconn->data.mutex);
 
 	p.state = cpu_to_be32(mdev->state.i); /* Within the send mutex */
@@ -966,7 +962,6 @@ int drbd_send_state(struct drbd_conf *mdev)
 
 	mutex_unlock(&mdev->tconn->data.mutex);
 
-	drbd_state_unlock(mdev);
 	return ok;
 }
 
-- 
1.7.4.1

