Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1INOdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 10:33:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45301 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1INOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 10:33:09 -0400
Date: Wed, 14 Sep 2011 10:32:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, hch@infradead.org,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Help with implementing some form of barriers in 3.0 kernels.
Message-ID: <20110914143247.GA17206@phenom.oracle.com>
References: <20110907174832.GN32190@dumpdata.com>
 <4E6F50170200007800055CF5@nat28.tlf.novell.com>
 <20110914085913.GB25628@phenom.oracle.com>
 <4E708C240200007800055FDF@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E708C240200007800055FDF@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4E70BB1D.005F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (drain) {
> > +		struct request_queue *q = bdev_get_queue(preq.bdev);
> > +		unsigned long flags;
> > +

> > +		/* Emulate the original behavior of write barriers */
> > +		spin_lock_irqsave(q->queue_lock, flags);
> > +		elv_drain_elevator(q);
> > +		__blk_run_queue(q);
> > +		spin_unlock_irqrestore(q->queue_lock, flags);
> > +	}
I also had to add:

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index eaf49d1..20fddbc 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -679,6 +679,10 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		struct request_queue *q = bdev_get_queue(preq.bdev);
 		unsigned long flags;
 
+		if (!q->elevator) {
+			__end_block_io_op(pending_req, -EOPNOTSUPP);
+			return -EOPNOTSUPP;
+		}
 		/* Emulate the original behavior of write barriers */
 		spin_lock_irqsave(q->queue_lock, flags);
 		elv_drain_elevator(q);
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 52d8893..722714a 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -157,6 +157,7 @@ struct xen_vbd {
 	/* Cached size parameter. */
 	sector_t		size;
 	bool			flush_support;
+	bool			barrier_support;
 };
 
 struct backend_info;
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index da1e27a..7189ecd 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -384,6 +384,9 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 	if (q && q->flush_flags)
 		vbd->flush_support = true;
 
+	if (q && q->elevator && q->elevator->ops)
+		vbd->barrier_support = true;
+
 	DPRINTK("Successful creation of handle=%04x (dom=%u)\n",
 		handle, blkif->domid);
 	return 0;
@@ -728,7 +731,7 @@ again:
 	if (err)
 		goto abort;
 
-	err = xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
+	err = xen_blkbk_barrier(xbt, be, be->blkif->vbd.barrier_support);
 
 	err = xen_blkbk_discard(xbt, be);


Otherwise it would crash.. Thought I am not sure why the elevator is not
set (the guest is on a LVM LV).
