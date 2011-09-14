Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1INJam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 05:30:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42384 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab1INJal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 05:30:41 -0400
Date: Wed, 14 Sep 2011 05:30:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>, jaxboe@fusionio.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, hch@infradead.org,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Help with implementing some form of barriers in 3.0 kernels.
Message-ID: <20110914093019.GA15866@phenom.oracle.com>
References: <20110907174832.GN32190@dumpdata.com>
 <4E6F50170200007800055CF5@nat28.tlf.novell.com>
 <20110914085913.GB25628@phenom.oracle.com>
 <4E708C240200007800055FDF@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E708C240200007800055FDF@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E707435.00DA:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Below is what Jan Kara came up with for addressing this - what do
> >> you think?

Jens,

Could you take a look at the block/elevator patch below?
> > 
> > It looks like it would do it. I modified it a bit, testing it now.
> > 
> > 
> > commit 315c0cf1a5174b9aed494d7903133ce9ac76d6f1
> > Author: Jan Kara <jack@suse.cz>
> > Date:   Tue Sep 13 11:44:07 2011 +0100
> > 
> >     xen: Add support for old BARRIER requests to xenblk driver
> >     
> >     Recent kernels do not support BARRIER operation but only FLUSH 
> > operation. But
> >     older xenblk frontends still use the BARRIER operation to achieve data
> >     integrity requirements. So add support for BARRIER operation into xenblk
> >     backend so that all guests do not corrupt their filesystem on host 
> > crash.
> >     
> >     Signed-off-by: Jan Kara <jack@suse.cz>
> >     Signed-off-by: Jan Beulich <JBeulich@suse.com>
> >     [v1: Added some extra functions, and other cases]
> 
> Ah, yes, of course - Jan probably didn't pay attention because in our
> variant of the driver these functions never got removed.

<nods> Which is OK - but you might want to migrate in the the 'feature-write-flush'
> 
> >     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > diff --git a/block/elevator.c b/block/elevator.c
> > index a3b64bc..b2143a8 100644
> > --- a/block/elevator.c
> > +++ b/block/elevator.c
> > @@ -616,6 +616,7 @@ void elv_drain_elevator(struct request_queue *q)
> >  		       q->elevator->elevator_type->elevator_name, q->nr_sorted);
> >  	}
> >  }
> > +EXPORT_SYMBOL(elv_drain_elevator);
> 
> Now, if you modify it anyway, how about making this an
> EXPORT_SYMBOL_GPL()?

The rest of that file had EXPORT_SYMBOL.. so I figured I will follow
the same appearance. But I am OK doing it via EXPORT_SYMBOL_GPL. Lets
ask Jens.

> 
> Jan
> 
> >  
> >  /*
> >   * Call with queue lock held, interrupts disabled
> > diff --git a/drivers/block/xen-blkback/blkback.c 
> > b/drivers/block/xen-blkback/blkback.c
> > index 9713d5a..1df773c 100644
> > --- a/drivers/block/xen-blkback/blkback.c
> > +++ b/drivers/block/xen-blkback/blkback.c
> > @@ -464,6 +464,11 @@ static void __end_block_io_op(struct pending_req 
> > *pending_req, int error)
> >  		pr_debug(DRV_PFX "flush diskcache op failed, not supported\n");
> >  		xen_blkbk_flush_diskcache(XBT_NIL, pending_req->blkif->be, 0);
> >  		pending_req->status = BLKIF_RSP_EOPNOTSUPP;
> > +	} else if ((pending_req->operation == BLKIF_OP_WRITE_BARRIER) &&
> > +		 (error == -EOPNOTSUPP)) {
> > +		pr_debug(DRV_PFX "write barrier op failed, not supported\n");
> > +		xen_blkbk_barrier(XBT_NIL, pending_req->blkif->be, 0);
> > +		pending_req->status = BLKIF_RSP_EOPNOTSUPP;
> >  	} else if (error) {
> >  		pr_debug(DRV_PFX "Buffer not up-to-date at end of operation,"
> >  			 " error=%d\n", error);
> > @@ -590,6 +595,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
> >  	struct bio *biolist[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> >  	int i, nbio = 0;
> >  	int operation;
> > +	bool drain = false;
> >  	struct blk_plug plug;
> >  
> >  	switch (req->operation) {
> > @@ -601,6 +607,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
> >  		blkif->st_wr_req++;
> >  		operation = WRITE_ODIRECT;
> >  		break;
> > +	case BLKIF_OP_WRITE_BARRIER:
> > +		drain = true;
> >  	case BLKIF_OP_FLUSH_DISKCACHE:
> >  		blkif->st_f_req++;
> >  		operation = WRITE_FLUSH;
> > @@ -609,7 +617,6 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
> >  		blkif->st_ds_req++;
> >  		operation = REQ_DISCARD;
> >  		break;
> > -	case BLKIF_OP_WRITE_BARRIER:
> >  	default:
> >  		operation = 0; /* make gcc happy */
> >  		goto fail_response;
> > @@ -668,6 +675,17 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
> >  		}
> >  	}
> >  
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
> > +
> >  	/*
> >  	 * If we have failed at this point, we need to undo the M2P override,
> >  	 * set gnttab_set_unmap_op on all of the grant references and perform
> > diff --git a/drivers/block/xen-blkback/common.h 
> > b/drivers/block/xen-blkback/common.h
> > index bfb532e..42b0e46 100644
> > --- a/drivers/block/xen-blkback/common.h
> > +++ b/drivers/block/xen-blkback/common.h
> > @@ -228,6 +228,8 @@ int xen_blkif_schedule(void *arg);
> >  
> >  int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
> >  			      struct backend_info *be, int state);
> > +int xen_blkbk_barrier(struct xenbus_transaction xbt,
> > +		      struct backend_info *be, int state);
> >  
> >  struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be);
> >  
> > diff --git a/drivers/block/xen-blkback/xenbus.c 
> > b/drivers/block/xen-blkback/xenbus.c
> > index 2b3aef0..b477aee 100644
> > --- a/drivers/block/xen-blkback/xenbus.c
> > +++ b/drivers/block/xen-blkback/xenbus.c
> > @@ -421,6 +421,20 @@ int xen_blkbk_flush_diskcache(struct xenbus_transaction 
> > xbt,
> >  	return err;
> >  }
> >  
> > +int xen_blkbk_barrier(struct xenbus_transaction xbt,
> > +		      struct backend_info *be, int state)
> > +{
> > +	struct xenbus_device *dev = be->dev;
> > +	int err;
> > +
> > +	err = xenbus_printf(xbt, dev->nodename, "feature-barrier",
> > +			    "%d", state);
> > +	if (err)
> > +		xenbus_dev_fatal(dev, err, "writing feature-barrier");
> > +
> > +	return err;
> > +}
> > +
> >  int xen_blkbk_discard(struct xenbus_transaction xbt, struct backend_info 
> > *be)
> >  {
> >  	struct xenbus_device *dev = be->dev;
> > @@ -706,6 +720,8 @@ again:
> >  	if (err)
> >  		goto abort;
> >  
> > +	err = xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
> > +
> >  	err = xen_blkbk_discard(xbt, be);
> >  
> >  	err = xenbus_printf(xbt, dev->nodename, "sectors", "%llu",
> 
