Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab2LMOJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:09:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2LMOJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jens Axboe <axboe@kernel.dk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 138/241] dm: fix deadlock with request based dm and queue request_fn recursion
Date: Thu, 13 Dec 2012 11:58:23 -0200
Message-Id: <1355407206-17100-139-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit a8c32a5c98943d370ea606a2e7dc04717eb92206 upstream.

Request based dm attempts to re-run the request queue off the
request completion path. If used with a driver that potentially does
end_io from its request_fn, we could deadlock trying to recurse
back into request dispatch. Fix this by punting the request queue
run to kblockd.

Tested to fix a quickly reproducible deadlock in such a scenario.

Acked-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/md/dm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9ff3019..32370ea 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -754,8 +754,14 @@ static void rq_completed(struct mapped_device *md, int rw, int run_queue)
 	if (!md_in_flight(md))
 		wake_up(&md->wait);
 
+	/*
+	 * Run this off this callpath, as drivers could invoke end_io while
+	 * inside their request_fn (and holding the queue lock). Calling
+	 * back into ->request_fn() could deadlock attempting to grab the
+	 * queue lock again.
+	 */
 	if (run_queue)
-		blk_run_queue(md->queue);
+		blk_run_queue_async(md->queue);
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
-- 
1.7.9.5

