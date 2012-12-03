Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2LCOxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:53:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43676 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318Ab2LCOgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:08 -0500
Message-Id: <20121203143158.704079874@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:33:05 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 79/89] dm: fix deadlock with request based dm and queue request_fn
 recursion
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 02db918..77e6eff 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -740,8 +740,14 @@ static void rq_completed(struct mapped_device *md, int rw, int run_queue)
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


