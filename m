Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1IOOWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:22:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:61018 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab1IOOWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:22:40 -0400
Date: Thu, 15 Sep 2011 10:21:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, hch@infradead.org, axboe@kernel.dk,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: xen/blkback: Add support for old BARRIER requests -
 'feature-barrier', was "Help with implementing some form of barriers in 3.0
 kernels."
Message-ID: <20110915142125.GB19897@phenom.oracle.com>
References: <20110907174832.GN32190@dumpdata.com>
 <4E6F50170200007800055CF5@nat28.tlf.novell.com>
 <20110914085913.GB25628@phenom.oracle.com>
 <4E708C240200007800055FDF@nat28.tlf.novell.com>
 <20110914143247.GA17206@phenom.oracle.com>
 <20110914150102.GA18015@phenom.oracle.com>
 <4E70EEB302000078000561AE@nat28.tlf.novell.com>
 <20110915125111.GA18875@phenom.oracle.com>
 <4E72131B02000078000564AC@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E72131B02000078000564AC@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E7209F6.01E9:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 02:00:43PM +0100, Jan Beulich wrote:
> >>> On 15.09.11 at 14:51, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> >> > +	if (drain) {
> >> > +		struct request_queue *q = bdev_get_queue(preq.bdev);
> >> > +		unsigned long flags;
> >> > +
> >> > +		if (!q->elevator) {
> >> > +			__end_block_io_op(pending_req, -EOPNOTSUPP);
> >> > +			return -EOPNOTSUPP;
> >> > +		}
> >> 
> >> You shouldn't return here - barrier requests may be "non-empty" (i.e.
> >> carry data to be written), and hence you'd need to make sure the
> >> writes get carried out nevertheless.
> > 
> > In theory (and in practice) the 'feature-barrier' is set to zero
> > if !q->elevator. So the frontend should not even try WRITE_BARRIER.
> > 
> > I think the better approach will be to outright fail the WRITE_BARRIER
> > request if 'feature-barrier=0' instead of just trying (which is what
> > this tries).
> > 
> > On a unrelated topic is what to do with devices which are bio based
> > but not request based. From the DM directory, only multipath is capable
> > of doing requests, while the rest are all bio. There is code to
> > quisce the bio's: dm_suspend, but it is not apparent to me how to
> > make it be exposed.
> > 
> > 
> >> 
> >> Jan - this suggests that the placement isn't correct either: The
> >> draining of the queue - as I understand it - should be happening
> >> *after* these writes completed, not before they get started.
> > 
> > So that looks like it should be just moved a bit, like this new patch:
> 
> Looks like this is the patch after the very first modifications you made
> to it - I don't see anything being moved, and I no longer see any of
> the subsequent changes you did.

duh!
commit 9e8970f64bceffd90113f6cbb426af93cb7043dd
Author: Jan Kara <jack@suse.cz>
Date:   Tue Sep 13 11:44:07 2011 +0100

    xen/blkback: Add support for old BARRIER requests - 'feature-barrier'
    
    Recent kernels do not support BARRIER operation but only FLUSH operation. But
    older xenblk frontends still use the BARRIER operation to achieve data
    integrity requirements. So add support for BARRIER operation into xenblk
    backend so that all guests do not corrupt their filesystem on host crash.
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Jan Beulich <JBeulich@suse.com>
    [v1: Added some extra functions, and other cases]
    [v2: Added check for q->elevator]
    [v3: Changed EXPORT_SYMBOL to EXPORT_SYMBOL_GPL]
    [v4: Moved the drain _after_ the write request and fix failling]
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/block/elevator.c b/block/elevator.c
index a3b64bc..4e6c5b6 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -616,6 +616,7 @@ void elv_drain_elevator(struct request_queue *q)
 		       q->elevator->elevator_type->elevator_name, q->nr_sorted);
 	}
 }
+EXPORT_SYMBOL_GPL(elv_drain_elevator);
 
 /*
  * Call with queue lock held, interrupts disabled
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 9713d5a..738966e 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -464,6 +464,11 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 		pr_debug(DRV_PFX "flush diskcache op failed, not supported\n");
 		xen_blkbk_flush_diskcache(XBT_NIL, pending_req->blkif->be, 0);
 		pending_req->status = BLKIF_RSP_EOPNOTSUPP;
+	} else if ((pending_req->operation == BLKIF_OP_WRITE_BARRIER) &&
+		   (error == -EOPNOTSUPP)) {
+		pr_debug(DRV_PFX "write barrier op failed, not supported\n");
+		xen_blkbk_barrier(XBT_NIL, pending_req->blkif->be, 0);
+		pending_req->status = BLKIF_RSP_EOPNOTSUPP;
 	} else if (error) {
 		pr_debug(DRV_PFX "Buffer not up-to-date at end of operation,"
 			 " error=%d\n", error);
@@ -601,6 +606,9 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		blkif->st_wr_req++;
 		operation = WRITE_ODIRECT;
 		break;
+	case BLKIF_OP_WRITE_BARRIER:
+		if (!blkif->vbd.barrier_support)
+			goto fail_response;
 	case BLKIF_OP_FLUSH_DISKCACHE:
 		blkif->st_f_req++;
 		operation = WRITE_FLUSH;
@@ -609,7 +617,6 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		blkif->st_ds_req++;
 		operation = REQ_DISCARD;
 		break;
-	case BLKIF_OP_WRITE_BARRIER:
 	default:
 		operation = 0; /* make gcc happy */
 		goto fail_response;
@@ -667,7 +674,6 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 			goto fail_response;
 		}
 	}
-
 	/*
 	 * If we have failed at this point, we need to undo the M2P override,
 	 * set gnttab_set_unmap_op on all of the grant references and perform
@@ -746,6 +752,16 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	else if (operation == WRITE || operation == WRITE_FLUSH)
 		blkif->st_wr_sect += preq.nr_sects;
 
+	if (req->operation == BLKIF_OP_WRITE_BARRIER) {
+		struct request_queue *q = bdev_get_queue(preq.bdev);
+		unsigned long flags;
+
+		/* Emulate the original behavior of write barriers */
+		spin_lock_irqsave(q->queue_lock, flags);
+		elv_drain_elevator(q);
+		__blk_run_queue(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
 	return 0;
 
  fail_flush:
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index bfb532e..9f1990b 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -157,6 +157,7 @@ struct xen_vbd {
 	/* Cached size parameter. */
 	sector_t		size;
 	bool			flush_support;
+	bool			barrier_support;
 };
 
 struct backend_info;
@@ -228,6 +229,8 @@ int xen_blkif_schedule(void *arg);
 
 int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
 			      struct backend_info *be, int state);
+int xen_blkbk_barrier(struct xenbus_transaction xbt,
+		      struct backend_info *be, int state);
 
 struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be);
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 2b3aef0..ec0975b 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -376,6 +376,9 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 	if (q && q->flush_flags)
 		vbd->flush_support = true;
 
+	if (q && q->elevator)
+		vbd->barrier_support = true;
+
 	DPRINTK("Successful creation of handle=%04x (dom=%u)\n",
 		handle, blkif->domid);
 	return 0;
@@ -421,6 +424,20 @@ int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
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
+
 int xen_blkbk_discard(struct xenbus_transaction xbt, struct backend_info *be)
 {
 	struct xenbus_device *dev = be->dev;
@@ -706,6 +723,8 @@ again:
 	if (err)
 		goto abort;
 
+	err = xen_blkbk_barrier(xbt, be, be->blkif->vbd.barrier_support);
+
 	err = xen_blkbk_discard(xbt, be);
 
 	err = xenbus_printf(xbt, dev->nodename, "sectors", "%llu",
