Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723Ab2K3TeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:34:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:57361 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031607Ab2K3StS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [ 16/37] dm: fix deadlock with request based dm and queue request_fn recursion
Date: Fri, 30 Nov 2012 10:46:03 -0800
Message-Id: <20121130183858.990299497@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -745,8 +745,14 @@ static void rq_completed(struct mapped_d
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


