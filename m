Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1JJP2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:28:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:58413 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab1JJP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:28:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        hch@infradead.org, Jan Beulich <JBeulich@novell.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] xen/blkback: Support 'feature-barrier' aka old-style BARRIER requests.
Date: Mon, 10 Oct 2011 11:28:12 -0400
Message-Id: <1318260494-27985-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090203.4E930F18.0246,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We emulate the barrier requests by draining the outstanding bio's
and then sending the WRITE_FLUSH command. To drain the I/Os
we use the refcnt that is used during disconnect to wait for all
the I/Os before disconnecting from the frontend. We latch on its
value and if it reaches either the threshold for disconnect or when
there are no more outstanding I/Os, then we have drained all I/Os.

Suggested-by: Christopher Hellwig <hch@infradead.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |   37 +++++++++++++++++++++++++++++++++-
 drivers/block/xen-blkback/common.h  |    5 ++++
 drivers/block/xen-blkback/xenbus.c  |   18 +++++++++++++++++
 3 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index e0dab61..184b133 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -452,6 +452,23 @@ static void xen_blk_discard(struct xen_blkif *blkif, struct blkif_request *req)
 	make_response(blkif, req->id, req->operation, status);
 }
 
+static void xen_blk_drain_io(struct xen_blkif *blkif)
+{
+	atomic_set(&blkif->drain, 1);
+	do {
+		wait_for_completion_interruptible_timeout(
+				&blkif->drain_complete, HZ);
+
+		if (!atomic_read(&blkif->drain))
+			break;
+		/* The initial value is one, and one refcnt taken at the
+		 * start of the xen_blkif_schedule thread. */
+		if (atomic_read(&blkif->refcnt) <= 2)
+			break;
+	} while (!kthread_should_stop());
+	atomic_set(&blkif->drain, 0);
+}
+
 /*
  * Completion callback on the bio's. Called as bh->b_end_io()
  */
@@ -464,6 +481,11 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 		pr_debug(DRV_PFX "flush diskcache op failed, not supported\n");
 		xen_blkbk_flush_diskcache(XBT_NIL, pending_req->blkif->be, 0);
 		pending_req->status = BLKIF_RSP_EOPNOTSUPP;
+	} else if ((pending_req->operation == BLKIF_OP_WRITE_BARRIER) &&
+		    (error == -EOPNOTSUPP)) {
+		pr_debug(DRV_PFX "write barrier op failed, not supported\n");
+		xen_blkbk_barrier(XBT_NIL, pending_req->blkif->be, 0);
+		pending_req->status = BLKIF_RSP_EOPNOTSUPP;
 	} else if (error) {
 		pr_debug(DRV_PFX "Buffer not up-to-date at end of operation,"
 			 " error=%d\n", error);
@@ -481,6 +503,10 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 			      pending_req->operation, pending_req->status);
 		xen_blkif_put(pending_req->blkif);
 		free_req(pending_req);
+		if (atomic_read(&pending_req->blkif->refcnt) <= 2) {
+			if (atomic_read(&pending_req->blkif->drain))
+				complete(&pending_req->blkif->drain_complete);
+		}
 	}
 }
 
@@ -574,7 +600,6 @@ do_block_io_op(struct xen_blkif *blkif)
 
 	return more_to_do;
 }
-
 /*
  * Transmutation of the 'struct blkif_request' to a proper 'struct bio'
  * and call the 'submit_bio' to pass it to the underlying storage.
@@ -591,6 +616,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	int i, nbio = 0;
 	int operation;
 	struct blk_plug plug;
+	bool drain = false;
 
 	switch (req->operation) {
 	case BLKIF_OP_READ:
@@ -601,6 +627,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		blkif->st_wr_req++;
 		operation = WRITE_ODIRECT;
 		break;
+	case BLKIF_OP_WRITE_BARRIER:
+		drain = true;
 	case BLKIF_OP_FLUSH_DISKCACHE:
 		blkif->st_f_req++;
 		operation = WRITE_FLUSH;
@@ -609,7 +637,6 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		blkif->st_ds_req++;
 		operation = REQ_DISCARD;
 		break;
-	case BLKIF_OP_WRITE_BARRIER:
 	default:
 		operation = 0; /* make gcc happy */
 		goto fail_response;
@@ -668,6 +695,12 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		}
 	}
 
+	/* Wait on all outstanding I/O's and once that has been completed
+	 * issue the WRITE_FLUSH.
+	 */
+	if (drain)
+		xen_blk_drain_io(pending_req->blkif);
+
 	/*
 	 * If we have failed at this point, we need to undo the M2P override,
 	 * set gnttab_set_unmap_op on all of the grant references and perform
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 1b1bc44..e638457 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -181,6 +181,9 @@ struct xen_blkif {
 	atomic_t		refcnt;
 
 	wait_queue_head_t	wq;
+	/* for barrier (drain) requests */
+	struct completion	drain_complete;
+	atomic_t		drain;
 	/* One thread per one blkif. */
 	struct task_struct	*xenblkd;
 	unsigned int		waiting_reqs;
@@ -229,6 +232,8 @@ int xen_blkif_schedule(void *arg);
 int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
 			      struct backend_info *be, int state);
 
+int xen_blkbk_barrier(struct xenbus_transaction xbt,
+		      struct backend_info *be, int state);
 struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be);
 
 static inline void blkif_get_x86_32_req(struct blkif_request *dst,
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 1c44b32..a6d4303 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -114,6 +114,8 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	spin_lock_init(&blkif->blk_ring_lock);
 	atomic_set(&blkif->refcnt, 1);
 	init_waitqueue_head(&blkif->wq);
+	init_completion(&blkif->drain_complete);
+	atomic_set(&blkif->drain, 0);
 	blkif->st_print = jiffies;
 	init_waitqueue_head(&blkif->waiting_to_free);
 
@@ -474,6 +476,19 @@ kfree:
 out:
 	return err;
 }
+int xen_blkbk_barrier(struct xenbus_transaction xbt,
+		      struct backend_info *be, int state)
+{
+	struct xenbus_device *dev = be->dev;
+	int err;
+
+	err = xenbus_printf(xbt, dev->nodename, "feature-barrier",
+			    "%d", state);
+	if (err)
+		xenbus_dev_fatal(dev, err, "writing feature-barrier");
+
+	return err;
+}
 
 /*
  * Entry point to this code when a new device is created.  Allocate the basic
@@ -708,6 +723,9 @@ again:
 
 	err = xen_blkbk_discard(xbt, be);
 
+	/* If we can't advertise it is OK. */
+	err = xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
+
 	err = xenbus_printf(xbt, dev->nodename, "sectors", "%llu",
 			    (unsigned long long)vbd_sz(&be->blkif->vbd));
 	if (err) {
-- 
1.7.5.4

