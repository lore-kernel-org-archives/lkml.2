Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1JLQPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:15:00 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:60629 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab1JLQO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:14:59 -0400
X-IronPort-AV: E=Sophos;i="4.69,335,1315180800"; 
   d="scan'208";a="8354121"
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, "hch@infradead.org" <hch@infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dong Yang Li <lidongyang@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Oct 2011 17:14:57 +0100
In-Reply-To: <20111012154549.GB1732@phenom.oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
	 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
	 <1318263187.21903.464.camel@zakaz.uk.xensource.com>
	 <20111010164250.GG28646@phenom.oracle.com>
	 <1318274402.27397.13.camel@dagon.hellion.org.uk>
	 <20111010195749.GA5755@phenom.oracle.com>
	 <4E940E21020000780005AA29@nat28.tlf.novell.com>
	 <20111011155133.GC29349@phenom.oracle.com>
	 <20111011205729.GB22668@phenom.oracle.com>
	 <1318416842.21903.674.camel@zakaz.uk.xensource.com>
	 <20111012154549.GB1732@phenom.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318436097.21903.762.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 16:45 +0100, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 12, 2011 at 11:54:02AM +0100, Ian Campbell wrote:
> > On Tue, 2011-10-11 at 21:57 +0100, Konrad Rzeszutek Wilk wrote:
> > > > My later response to it should include it:
> > > > http://lists.xensource.com/archives/html/xen-devel/2011-10/msg00652.html
> > > >
> > > > >
> > > > > Further I wonder why you don't use the "reserved" field instead of
> > > > > extending the structure at the end.
> > > >
> > > > <blinks> I completly missed it. That would definitly work as well.
> > > >
> > > > Let me redo it with that in mind.
> > > 
> > > I've posted the Xen hypervisor ABI one that thread above. The implementation
> > > of that looks as follow:
> > 
> > Ian.
> > 
> > > 
> > > commit ae33f998d66c5982af533bda25c2b6c4f863789f
> > > Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > Date:   Mon Oct 10 10:58:40 2011 -0400
> > > 
> > >     xen/blk[front|back]: Enhance discard support with secure erasing support.
> > > 
> > >     Part of the blkdev_issue_discard(xx) operation is that it can also
> > >     issue a secure discard operation that will permanantly remove the
> > >     sectors in question. We advertise that we can support that via the
> > >     'discard-secure' attribute and on the request, if the 'secure' bit
> > >     is set, we will attempt to pass in REQ_DISCARD | REQ_SECURE.
> > > 
> > >     CC: Li Dongyang <lidongyang@novell.com>
> > >     [v1: Used 'flag' instead of 'secure:1' bit]
> > >     [v2: Use 'reserved 'uint8_t' as a flag]
> > >     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > 
> > > diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> > > index 94e659d..4f33c13 100644
> > > --- a/drivers/block/xen-blkback/blkback.c
> > > +++ b/drivers/block/xen-blkback/blkback.c
> > > @@ -362,7 +362,7 @@ static int xen_blkbk_map(struct blkif_request *req,
> > >  {
> > >         struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> > >         int i;
> > > -       int nseg = req->nr_segments;
> > > +       int nseg = req->u1.nr_segments;
> > >         int ret = 0;
> > > 
> > >         /*
> > > @@ -422,13 +422,16 @@ static void xen_blk_discard(struct xen_blkif *blkif, struct blkif_request *req)
> > >         int status = BLKIF_RSP_OKAY;
> > >         struct block_device *bdev = blkif->vbd.bdev;
> > > 
> > > -       if (blkif->blk_backend_type == BLKIF_BACKEND_PHY)
> > > +       if (blkif->blk_backend_type == BLKIF_BACKEND_PHY) {
> > > +               unsigned long secure = (blkif->vbd.discard_secure &&
> > > +                       (req->u1.flag & BLKIF_OP_DISCARD_FLAG_SECURE)) ?
> > > +                       BLKDEV_DISCARD_SECURE : 0;
> > >                 /* just forward the discard request */
> > >                 err = blkdev_issue_discard(bdev,
> > >                                 req->u.discard.sector_number,
> > >                                 req->u.discard.nr_sectors,
> > > -                               GFP_KERNEL, 0);
> > > -       else if (blkif->blk_backend_type == BLKIF_BACKEND_FILE) {
> > > +                               GFP_KERNEL, secure);
> > > +       } else if (blkif->blk_backend_type == BLKIF_BACKEND_FILE) {
> > >                 /* punch a hole in the backing file */
> > >                 struct loop_device *lo = bdev->bd_disk->private_data;
> > >                 struct file *file = lo->lo_backing_file;
> > > @@ -618,6 +621,9 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
> > >         struct blk_plug plug;
> > >         bool drain = false;
> > > 
> > > +       /* Check that the number of segments is sane. */
> > > +       nseg = req->u1.nr_segments;
> > 
> > This field is invalid (at least with these semantics) if req->operation
> > == BLKIF_OP_DISCARD so reading it here and clearing it later when you
> > decide it is invalid is just confusing. Why not read it inside the
> > switch iff it is valid?
> 
> The problem was that 'nseg' would be read after the switch, so it would
> contain the flag value. Which would throw off a lot of the loops which
> would try to enumerate "(for (i = 0; i < nseg;...)".
> 
> 
> Hence moving it to the top would make it valid for all the operations
> except the BLKIF_OP_DISCARD. And BLKIF_OP_DISCARD would sensibly set it
> nseg to zero so that we would not trip on those 'for (i = 0').

I think this is the crux of the problem: setting nsegs to an invalid
value just so you can clear it again later when you check the op is
completely backwards and confusing to any reader of the code.

> But I think you idea of making it an if statement would do, like:
> 
> 
> > > @@ -643,8 +650,6 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
> > >                 break;
> > >         }
> > > 
>             if (operation != REQ_DISCARD)
>               /* Check that the number of segments is sane. */
>          	nseg = req->nr_segments;
> 	    else
> 		nseg = 0;

Right above this hunk is a switch statement over the req->operation. The
value of req->operation precisely defines the semantics/validity or
otherwise of the req->nr_segments field and whether or not it contains
the nr of segments or (due to the aliasing) something else. Why not set
nsegs inside that switch statement (and explicitly zero it in the other
cases) so that this obvious connection is retained?

> > >         if (unlikely(nseg == 0 && operation != WRITE_FLUSH &&
> > >                                 operation != REQ_DISCARD) ||
> 
> And I guess we can also skip the REQ_DISCARD test here.

I don't think so, if nseg == 0 and operation == REQ_DISCARD that is
fine, right? The fact that there is all this "operation != xx &&
operation != yy" conditional stuff suggests this would also be cleaner
if it was also pulled up into the existing switch over req->operation.
IOW overall you end up with:

	switch (req->operation) {
	case BLKIF_OP_READ:
		blkif->st_rd_req++;
		operation = READ;
		nseg = req->nr_segments;
		if (unlikely(nseg == 0 || nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) {
			pr_debug(DRV_PFX "Bad number of segments in read request (%d)\n",
				 nseg);
			/* Haven't submitted any bio's yet. */
			goto fail_response;
		}
		break;
	case BLKIF_OP_WRITE:
		blkif->st_wr_req++;
		operation = WRITE_ODIRECT;
		nseg = req->nr_segments;
		if (unlikely(nseg == 0 || nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) {
			pr_debug(DRV_PFX "Bad number of segments in write request (%d)\n",
				 nseg);
			/* Haven't submitted any bio's yet. */
			goto fail_response;
		}
		break;
	case BLKIF_OP_FLUSH_DISKCACHE:
		blkif->st_f_req++;
		operation = WRITE_FLUSH;
		nseg = req->nr_segments;
		/* nseg == 0 is ok here */
		if (unlikely(nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) {
			pr_debug(DRV_PFX "Bad number of segments in write/flush-cache request (%d)\n",
				 nseg);
			/* Haven't submitted any bio's yet. */
			goto fail_response;
		}
		break;
	case BLKIF_OP_DISCARD:
		blkif->st_some_stat++;
		operation = REQ_DISCARD;
		nseg = 0; /* No data associated with a discard */
		break;
	case BLKIF_OP_WRITE_BARRIER:
	default:
		operation = 0; /* make gcc happy */
		goto fail_response;
		break;
	}

(I think I'm right that BLKIF_OP_FLUSH_DISKCACHE can have associated
data or not)

However do discard and r/w really have so much in common that handling
them all in dispatch_rw_block_io() and relying on nsegs == 0 when the
operation is discard makes sense?

Would it be clearer if the caller (__do_block_io_op) had this switch
over req->operation and called dispatch_rw_block_io(req, WRITE_FLUSH,
nsegs), dispatch_discard(req) etc as appropriate?

Ian.

