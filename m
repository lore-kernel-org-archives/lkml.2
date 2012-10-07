Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab2JGXXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:23:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38590 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754569Ab2JGXXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:07 -0400
Message-Id: <20121007225841.080304011@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Snitzer <snitzer@redhat.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 046/108] dm: handle requests beyond end of device instead of using BUG_ON
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit ba1cbad93dd47223b1f3b8edd50dd9ef2abcb2ed upstream.

The access beyond the end of device BUG_ON that was introduced to
dm_request_fn via commit 29e4013de7ad950280e4b2208 ("dm: implement
REQ_FLUSH/FUA support for request-based dm") was an overly
drastic (but simple) response to this situation.

I have received a report that this BUG_ON was hit and now think
it would be better to use dm_kill_unmapped_request() to fail the clone
and original request with -EIO.

map_request() will assign the valid target returned by
dm_table_find_target to tio->ti.  But when the target
isn't valid tio->ti is never assigned (because map_request isn't
called); so add a check for tio->ti != NULL to dm_done().

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm.c |   56 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4e09b6f..6748e0c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -865,10 +865,14 @@ static void dm_done(struct request *clone, int error, bool mapped)
 {
 	int r = error;
 	struct dm_rq_target_io *tio = clone->end_io_data;
-	dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
+	dm_request_endio_fn rq_end_io = NULL;
 
-	if (mapped && rq_end_io)
-		r = rq_end_io(tio->ti, clone, error, &tio->info);
+	if (tio->ti) {
+		rq_end_io = tio->ti->type->rq_end_io;
+
+		if (mapped && rq_end_io)
+			r = rq_end_io(tio->ti, clone, error, &tio->info);
+	}
 
 	if (r <= 0)
 		/* The target wants to complete the I/O */
@@ -1588,15 +1592,6 @@ static int map_request(struct dm_target *ti, struct request *clone,
 	int r, requeued = 0;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
-	/*
-	 * Hold the md reference here for the in-flight I/O.
-	 * We can't rely on the reference count by device opener,
-	 * because the device may be closed during the request completion
-	 * when all bios are completed.
-	 * See the comment in rq_completed() too.
-	 */
-	dm_get(md);
-
 	tio->ti = ti;
 	r = ti->type->map_rq(ti, clone, &tio->info);
 	switch (r) {
@@ -1628,6 +1623,26 @@ static int map_request(struct dm_target *ti, struct request *clone,
 	return requeued;
 }
 
+static struct request *dm_start_request(struct mapped_device *md, struct request *orig)
+{
+	struct request *clone;
+
+	blk_start_request(orig);
+	clone = orig->special;
+	atomic_inc(&md->pending[rq_data_dir(clone)]);
+
+	/*
+	 * Hold the md reference here for the in-flight I/O.
+	 * We can't rely on the reference count by device opener,
+	 * because the device may be closed during the request completion
+	 * when all bios are completed.
+	 * See the comment in rq_completed() too.
+	 */
+	dm_get(md);
+
+	return clone;
+}
+
 /*
  * q->request_fn for request-based dm.
  * Called with the queue lock held.
@@ -1657,14 +1672,21 @@ static void dm_request_fn(struct request_queue *q)
 			pos = blk_rq_pos(rq);
 
 		ti = dm_table_find_target(map, pos);
-		BUG_ON(!dm_target_is_valid(ti));
+		if (!dm_target_is_valid(ti)) {
+			/*
+			 * Must perform setup, that dm_done() requires,
+			 * before calling dm_kill_unmapped_request
+			 */
+			DMERR_LIMIT("request attempted access beyond the end of device");
+			clone = dm_start_request(md, rq);
+			dm_kill_unmapped_request(clone, -EIO);
+			continue;
+		}
 
 		if (ti->type->busy && ti->type->busy(ti))
 			goto delay_and_out;
 
-		blk_start_request(rq);
-		clone = rq->special;
-		atomic_inc(&md->pending[rq_data_dir(clone)]);
+		clone = dm_start_request(md, rq);
 
 		spin_unlock(q->queue_lock);
 		if (map_request(ti, clone, md))
@@ -1684,8 +1706,6 @@ delay_and_out:
 	blk_delay_queue(q, HZ / 10);
 out:
 	dm_table_put(map);
-
-	return;
 }
 
 int dm_underlying_device_busy(struct request_queue *q)


