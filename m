Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1HYP0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:26:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34230 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab1HYPJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:31 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 052/118] drbd: Remove unnecessary reference counting left-over
Date: Thu, 25 Aug 2011 17:07:48 +0200
Message-Id: <1314284934-17999-53-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Nothing in this function accesses mdev->tconn->net_conf, so there is no
need for get_net_conf() / put_net_conf() anymore.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index df5f106..e11ea47 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -328,9 +328,6 @@ static int _req_conflicts(struct drbd_request *req)
 
 	D_ASSERT(drbd_interval_empty(&req->i));
 
-	if (!get_net_conf(mdev->tconn))
-		return 0;
-
 	i = drbd_find_overlap(&mdev->write_requests, sector, size);
 	if (i) {
 		dev_alert(DEV, "%s[%u] Concurrent %s write detected! "
@@ -340,17 +337,9 @@ static int _req_conflicts(struct drbd_request *req)
 		      i->local ? "local" : "remote",
 		      (unsigned long long)sector, size,
 		      (unsigned long long)i->sector, i->size);
-		goto out_conflict;
+		return 1;
 	}
-
-	/* this is like it should be, and what we expected.
-	 * our users do behave after all... */
-	put_net_conf(mdev->tconn);
 	return 0;
-
-out_conflict:
-	put_net_conf(mdev->tconn);
-	return 1;
 }
 
 /* obviously this could be coded as many single functions
-- 
1.7.4.1

