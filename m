Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab0DVTpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:45:43 -0400
Received: from kroah.org ([198.145.64.141]:41151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab0DVT3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:09 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:18 2010
Message-Id: <20100422190918.449035839@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Junichi Nomura" <j-nomura@ce.jp.nec.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair G Kergon <agk@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: [124/197] dm mpath: fix stall when requeueing io
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

upstream commit 9eef87da2a8ea4920e0d913ff977cac064b68ee0 backported to
2.6.32.10 by Nikanth Karthikesan <knikanth@suse.de>

This patch fixes the problem that system may stall if target's ->map_rq
returns DM_MAPIO_REQUEUE in map_request().
E.g. stall happens on 1 CPU box when a dm-mpath device with queue_if_no_path
     bounces between all-paths-down and paths-up on I/O load.

When target's ->map_rq returns DM_MAPIO_REQUEUE, map_request() requeues
the request and returns to dm_request_fn().  Then, dm_request_fn()
doesn't exit the I/O dispatching loop and continues processing
the requeued request again.
This map and requeue loop can be done with interrupt disabled,
so 1 CPU system can be stalled if this situation happens.

For example, commands below can stall my 1 CPU box within 1 minute or so:
  # dmsetup table mp
  mp: 0 2097152 multipath 1 queue_if_no_path 0 1 1 service-time 0 1 2 8:144 1 1
  # while true; do dd if=/dev/mapper/mp of=/dev/null bs=1M count=100; done &
  # while true; do \
  > dmsetup message mp 0 "fail_path 8:144" \
  > dmsetup suspend --noflush mp \
  > dmsetup resume mp \
  > dmsetup message mp 0 "reinstate_path 8:144" \
  > done

To fix the problem above, this patch changes dm_request_fn() to exit
the I/O dispatching loop once if a request is requeued in map_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1487,10 +1487,15 @@ static int dm_prep_fn(struct request_que
 	return BLKPREP_OK;
 }
 
-static void map_request(struct dm_target *ti, struct request *rq,
-			struct mapped_device *md)
+/*
+ * Returns:
+ * 0  : the request has been processed (not requeued)
+ * !0 : the request has been requeued
+ */
+static int map_request(struct dm_target *ti, struct request *rq,
+		       struct mapped_device *md)
 {
-	int r;
+	int r, requeued = 0;
 	struct request *clone = rq->special;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
@@ -1516,6 +1521,7 @@ static void map_request(struct dm_target
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
 		dm_requeue_unmapped_request(clone);
+		requeued = 1;
 		break;
 	default:
 		if (r > 0) {
@@ -1527,6 +1533,8 @@ static void map_request(struct dm_target
 		dm_kill_unmapped_request(clone, r);
 		break;
 	}
+
+	return requeued;
 }
 
 /*
@@ -1568,12 +1576,17 @@ static void dm_request_fn(struct request
 
 		blk_start_request(rq);
 		spin_unlock(q->queue_lock);
-		map_request(ti, rq, md);
+		if (map_request(ti, rq, md))
+			goto requeued;
+
 		spin_lock_irq(q->queue_lock);
 	}
 
 	goto out;
 
+requeued:
+	spin_lock_irq(q->queue_lock);
+
 plug_and_out:
 	if (!elv_queue_empty(q))
 		/* Some requests still remain, retry later */


