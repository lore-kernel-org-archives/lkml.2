Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768Ab1IONYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:24:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125Ab1IONYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:24:12 -0400
Date: Thu, 15 Sep 2011 15:24:08 +0200
From: Jan Kara <jack@suse.cz>
To: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, hch@infradead.org,
        axboe@kernel.dk, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: xen/blkback: Add support for old BARRIER requests -
 'feature-barrier', was "Help with implementing some form of barriers in
 3.0 kernels."
Message-ID: <20110915132408.GB4739@quack.suse.cz>
References: <20110907174832.GN32190@dumpdata.com>
 <4E6F50170200007800055CF5@nat28.tlf.novell.com>
 <20110914085913.GB25628@phenom.oracle.com>
 <4E708C240200007800055FDF@nat28.tlf.novell.com>
 <20110914143247.GA17206@phenom.oracle.com>
 <20110914150102.GA18015@phenom.oracle.com>
 <4E70EEB302000078000561AE@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E70EEB302000078000561AE@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-09-11 17:13:07, Jan Beulich wrote:
> >>> On 14.09.11 at 17:01, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Wed, Sep 14, 2011 at 10:32:47AM -0400, Konrad Rzeszutek Wilk wrote:
> > 
> > Let me just post the one that I've succesfully tested. Not sure
> > about the need for the check for q->elvator in the dispatch_rw_block_io
> > so if you guys want me to remove it I can certainly do it.
> > 
> > commit a5a12f729697161522ecae0564915cf4145cb65c
> > Author: Jan Kara <jack@suse.cz>
> > Date:   Tue Sep 13 11:44:07 2011 +0100
> > 
> >     xen/blkback: Add support for old BARRIER requests - 'feature-barrier'
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
> >     [v2: Added check for q->elevator]
> >     [v3: Changed EXPORT_SYMBOL to EXPORT_SYMBOL_GPL]
> >     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > diff --git a/block/elevator.c b/block/elevator.c
> > index a3b64bc..4e6c5b6 100644
> > --- a/block/elevator.c
> > +++ b/block/elevator.c
> > @@ -616,6 +616,7 @@ void elv_drain_elevator(struct request_queue *q)
> >  		       q->elevator->elevator_type->elevator_name, q->nr_sorted);
> >  	}
> >  }
> > +EXPORT_SYMBOL_GPL(elv_drain_elevator);
> >  
> >  /*
> >   * Call with queue lock held, interrupts disabled
> > diff --git a/drivers/block/xen-blkback/blkback.c 
> > b/drivers/block/xen-blkback/blkback.c
> > index 9713d5a..573744e 100644
> > --- a/drivers/block/xen-blkback/blkback.c
> > +++ b/drivers/block/xen-blkback/blkback.c
> > @@ -464,6 +464,11 @@ static void __end_block_io_op(struct pending_req 
> > *pending_req, int error)
> >  		pr_debug(DRV_PFX "flush diskcache op failed, not supported\n");
> >  		xen_blkbk_flush_diskcache(XBT_NIL, pending_req->blkif->be, 0);
> >  		pending_req->status = BLKIF_RSP_EOPNOTSUPP;
> > +	} else if ((pending_req->operation == BLKIF_OP_WRITE_BARRIER) &&
> > +		   (error == -EOPNOTSUPP)) {
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
> > @@ -668,6 +675,21 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
> >  		}
> >  	}
> >  
> > +	if (drain) {
> > +		struct request_queue *q = bdev_get_queue(preq.bdev);
> > +		unsigned long flags;
> > +
> > +		if (!q->elevator) {
> > +			__end_block_io_op(pending_req, -EOPNOTSUPP);
> > +			return -EOPNOTSUPP;
> > +		}
> 
> You shouldn't return here - barrier requests may be "non-empty" (i.e.
> carry data to be written), and hence you'd need to make sure the
> writes get carried out nevertheless.
> 
> Jan - this suggests that the placement isn't correct either: The
> draining of the queue - as I understand it - should be happening
> *after* these writes completed, not before they get started.
  The draining should really happen before. It was like that in older
kernels as well. But you are right that we should probably make the
operation be WRITE_FLUSH_FUA to properly simulate the old behavior.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
