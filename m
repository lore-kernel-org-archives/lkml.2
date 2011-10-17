Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab1JQQxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:53:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49963 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1JQQxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:53:04 -0400
Date: Mon, 17 Oct 2011 12:52:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: hch@infradead.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] xen/blkback: Support 'feature-barrier' aka old-style
 BARRIER requests.
Message-ID: <20111017165247.GB19724@phenom.dumpdata.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-2-git-send-email-konrad.wilk@oracle.com>
 <4E9C3B39020000780005BA5D@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9C3B39020000780005BA5D@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4E9C5D69.00DF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 01:27:05PM +0100, Jan Beulich wrote:
> >>> On 10.10.11 at 17:28, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > We emulate the barrier requests by draining the outstanding bio's
> > and then sending the WRITE_FLUSH command. To drain the I/Os
> > we use the refcnt that is used during disconnect to wait for all
> > the I/Os before disconnecting from the frontend. We latch on its
> > value and if it reaches either the threshold for disconnect or when
> > there are no more outstanding I/Os, then we have drained all I/Os.
> > 
> > Suggested-by: Christopher Hellwig <hch@infradead.org>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/block/xen-blkback/blkback.c |   37 +++++++++++++++++++++++++++++++++-
> >  drivers/block/xen-blkback/common.h  |    5 ++++
> >  drivers/block/xen-blkback/xenbus.c  |   18 +++++++++++++++++
> >  3 files changed, 58 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/block/xen-blkback/blkback.c 
> > b/drivers/block/xen-blkback/blkback.c
> > index e0dab61..184b133 100644
> > --- a/drivers/block/xen-blkback/blkback.c
> > +++ b/drivers/block/xen-blkback/blkback.c
> > @@ -452,6 +452,23 @@ static void xen_blk_discard(struct xen_blkif *blkif, 
> > struct blkif_request *req)
> >  	make_response(blkif, req->id, req->operation, status);
> >  }
> >  
> > +static void xen_blk_drain_io(struct xen_blkif *blkif)
> > +{
> > +	atomic_set(&blkif->drain, 1);
> > +	do {
> > +		wait_for_completion_interruptible_timeout(
> > +				&blkif->drain_complete, HZ);
> > +
> > +		if (!atomic_read(&blkif->drain))
> > +			break;
> > +		/* The initial value is one, and one refcnt taken at the
> > +		 * start of the xen_blkif_schedule thread. */
> > +		if (atomic_read(&blkif->refcnt) <= 2)
> > +			break;
> 
> Shouldn't this test be done the very first thing in the loop? It looks
> racy the way it's placed now, and it would incur a 1 sec stall if this
> was the only request currently being processed (as no completion
> of ane earlier request could signal completion).

Sure does. An earlier version of this (not posted), had this check right
before going in the loop as all of the requests might have been already
processed.

I accidently dropped that logic as I moved this whole code into a function.

