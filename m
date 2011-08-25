Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1HYP02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:26:28 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34276 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab1HYPJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:31 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 053/118] drbd: Defer new writes when detecting conflicting writes
Date: Thu, 25 Aug 2011 17:07:49 +0200
Message-Id: <1314284934-17999-54-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Before submitting a new local write request, wait for any conflicting
local or remote requests to complete.

We could assume that the new request occurred first and that the
conflicting requests overwrote it (and therefore discard the new
reques), but we know for sure that the new request occurred after the
conflicting requests and so this behavior would we weird.  We would also
end up with the wrong result if the new request is not fully contained
within the conflicting requests.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |  103 +++++++++++++++-------------------------
 1 files changed, 39 insertions(+), 64 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index e11ea47..6bcf417 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -300,48 +300,6 @@ static void _req_may_be_done_not_susp(struct drbd_request *req, struct bio_and_e
 		_req_may_be_done(req, m);
 }
 
-/*
- * checks whether there was an overlapping request
- * or ee already registered.
- *
- * if so, return 1, in which case this request is completed on the spot,
- * without ever being submitted or send.
- *
- * return 0 if it is ok to submit this request.
- *
- * NOTE:
- * paranoia: assume something above us is broken, and issues different write
- * requests for the same block simultaneously...
- *
- * To ensure these won't be reordered differently on both nodes, resulting in
- * diverging data sets, we discard the later one(s). Not that this is supposed
- * to happen, but this is the rationale why we also have to check for
- * conflicting requests with local origin, and why we have to do so regardless
- * of whether we allowed multiple primaries.
- */
-static int _req_conflicts(struct drbd_request *req)
-{
-	struct drbd_conf *mdev = req->mdev;
-	const sector_t sector = req->i.sector;
-	const int size = req->i.size;
-	struct drbd_interval *i;
-
-	D_ASSERT(drbd_interval_empty(&req->i));
-
-	i = drbd_find_overlap(&mdev->write_requests, sector, size);
-	if (i) {
-		dev_alert(DEV, "%s[%u] Concurrent %s write detected! "
-		      "[DISCARD L] new: %llus +%u; "
-		      "pending: %llus +%u\n",
-		      current->comm, current->pid,
-		      i->local ? "local" : "remote",
-		      (unsigned long long)sector, size,
-		      (unsigned long long)i->sector, i->size);
-		return 1;
-	}
-	return 0;
-}
-
 /* obviously this could be coded as many single functions
  * instead of one huge switch,
  * or by putting the code directly in the respective locations
@@ -721,6 +679,34 @@ static int drbd_may_do_local_read(struct drbd_conf *mdev, sector_t sector, int s
 	return 0 == drbd_bm_count_bits(mdev, sbnr, ebnr);
 }
 
+/*
+ * complete_conflicting_writes  -  wait for any conflicting write requests
+ *
+ * The write_requests tree contains all active write requests which we
+ * currently know about.  Wait for any requests to complete which conflict with
+ * the new one.
+ */
+static int complete_conflicting_writes(struct drbd_conf *mdev,
+				       sector_t sector, int size)
+{
+	for(;;) {
+		DEFINE_WAIT(wait);
+		struct drbd_interval *i;
+
+		i = drbd_find_overlap(&mdev->write_requests, sector, size);
+		if (!i)
+			return 0;
+		i->waiting = true;
+		prepare_to_wait(&mdev->misc_wait, &wait, TASK_INTERRUPTIBLE);
+		spin_unlock_irq(&mdev->tconn->req_lock);
+		schedule();
+		finish_wait(&mdev->misc_wait, &wait);
+		spin_lock_irq(&mdev->tconn->req_lock);
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+	}
+}
+
 static int drbd_make_request_common(struct drbd_conf *mdev, struct bio *bio, unsigned long start_time)
 {
 	const int rw = bio_rw(bio);
@@ -729,7 +715,7 @@ static int drbd_make_request_common(struct drbd_conf *mdev, struct bio *bio, uns
 	struct drbd_tl_epoch *b = NULL;
 	struct drbd_request *req;
 	int local, remote, send_oos = 0;
-	int err = -EIO;
+	int err;
 	int ret = 0;
 
 	/* allocate outside of all locks; */
@@ -799,6 +785,7 @@ static int drbd_make_request_common(struct drbd_conf *mdev, struct bio *bio, uns
 	if (!(local || remote) && !is_susp(mdev->state)) {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "IO ERROR: neither local nor remote disk\n");
+		err = -EIO;
 		goto fail_free_complete;
 	}
 
@@ -823,6 +810,14 @@ allocate_barrier:
 	/* GOOD, everything prepared, grab the spin_lock */
 	spin_lock_irq(&mdev->tconn->req_lock);
 
+	if (rw == WRITE) {
+		err = complete_conflicting_writes(mdev, sector, size);
+		if (err) {
+			spin_unlock_irq(&mdev->tconn->req_lock);
+			goto fail_free_complete;
+		}
+	}
+
 	if (is_susp(mdev->state)) {
 		/* If we got suspended, use the retry mechanism of
 		   generic_make_request() to restart processing of this
@@ -843,6 +838,7 @@ allocate_barrier:
 		if (!(local || remote)) {
 			dev_err(DEV, "IO ERROR: neither local nor remote disk\n");
 			spin_unlock_irq(&mdev->tconn->req_lock);
+			err = -EIO;
 			goto fail_free_complete;
 		}
 	}
@@ -903,12 +899,6 @@ allocate_barrier:
 	if (local)
 		_req_mod(req, TO_BE_SUBMITTED);
 
-	/* check this request on the collision detection hash tables.
-	 * if we have a conflict, just complete it here.
-	 * THINK do we want to check reads, too? (I don't think so...) */
-	if (rw == WRITE && _req_conflicts(req))
-		goto fail_conflicting;
-
 	list_add_tail(&req->tl_requests, &mdev->tconn->newest_tle->requests);
 
 	/* NOTE remote first: to get the concurrent write detection right,
@@ -975,21 +965,6 @@ allocate_barrier:
 
 	return 0;
 
-fail_conflicting:
-	/* this is a conflicting request.
-	 * even though it may have been only _partially_
-	 * overlapping with one of the currently pending requests,
-	 * without even submitting or sending it, we will
-	 * pretend that it was successfully served right now.
-	 */
-	_drbd_end_io_acct(mdev, req);
-	spin_unlock_irq(&mdev->tconn->req_lock);
-	if (remote)
-		dec_ap_pending(mdev);
-	/* THINK: do we want to fail it (-EIO), or pretend success?
-	 * this pretends success. */
-	err = 0;
-
 fail_free_complete:
 	if (req->rq_state & RQ_IN_ACT_LOG)
 		drbd_al_complete_io(mdev, sector);
-- 
1.7.4.1

