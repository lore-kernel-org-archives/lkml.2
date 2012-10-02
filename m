Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab2JBUOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:14:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49244 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2JBUO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:14:27 -0400
Date: Tue, 2 Oct 2012 16:02:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] xen-blkfront: handle backend CLOSED without CLOSING
Message-ID: <20121002200255.GA668@phenom.dumpdata.com>
References: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com>
 <1348243464-15903-3-git-send-email-david.vrabel@citrix.com>
 <5061EFB2.1080407@citrix.com>
 <5069D097.60606@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5069D097.60606@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 06:19:19PM +0100, David Vrabel wrote:
> On 25/09/12 18:53, David Vrabel wrote:
> > On 21/09/12 17:04, David Vrabel wrote:
> >> From: David Vrabel <david.vrabel@citrix.com>
> >>
> >> Backend drivers shouldn't transistion to CLOSED unless the frontend is
> >> CLOSED.  If a backend does transition to CLOSED too soon then the
> >> frontend may not see the CLOSING state and will not properly shutdown.
> >>
> >> So, treat an unexpected backend CLOSED state the same as CLOSING.
> > 
> > Didn't handle the frontend block device being mounted. Updated patch here.
> 
> Konrad, can you ack this updated patch if you're happy with it.

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Or should I just carry it in my for-jens-3.7 bug-fixes queue and ask
Jen to pull it once rc0 is out?
> 
> Thanks.
> 
> David
> 
> > 8<---------------------------------
> > xen-blkfront: handle backend CLOSED without CLOSING
> > 
> > Backend drivers shouldn't transistion to CLOSED unless the frontend is
> > CLOSED.  If a backend does transition to CLOSED too soon then the
> > frontend may not see the CLOSING state and will not properly shutdown.
> > 
> > So, treat an unexpected backend CLOSED state the same as CLOSING.
> > 
> > If the backend is CLOSED then the frontend can't talk to it so go to
> > CLOSED immediately without waiting for the block device to be closed
> > or unmounted.
> > 
> > Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> > ---
> >  drivers/block/xen-blkfront.c |   13 +++++++++----
> >  1 files changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> > index 2c2d2e5..c1f5f38 100644
> > --- a/drivers/block/xen-blkfront.c
> > +++ b/drivers/block/xen-blkfront.c
> > @@ -1143,7 +1143,8 @@ static int blkfront_resume(struct xenbus_device *dev)
> >  }
> >  
> >  static void
> > -blkfront_closing(struct blkfront_info *info)
> > +blkfront_closing(struct blkfront_info *info,
> > +		 enum xenbus_state backend_state)
> >  {
> >  	struct xenbus_device *xbdev = info->xbdev;
> >  	struct block_device *bdev = NULL;
> > @@ -1167,7 +1168,8 @@ blkfront_closing(struct blkfront_info *info)
> >  
> >  	mutex_lock(&bdev->bd_mutex);
> >  
> > -	if (bdev->bd_openers) {
> > +	/* If the backend is already CLOSED, close now. */
> > +	if (bdev->bd_openers && backend_state != XenbusStateClosed) {
> >  		xenbus_dev_error(xbdev, -EBUSY,
> >  				 "Device in use; refusing to close");
> >  		xenbus_switch_state(xbdev, XenbusStateClosing);
> > @@ -1340,15 +1342,18 @@ static void blkback_changed(struct xenbus_device *dev,
> >  	case XenbusStateReconfiguring:
> >  	case XenbusStateReconfigured:
> >  	case XenbusStateUnknown:
> > -	case XenbusStateClosed:
> >  		break;
> >  
> >  	case XenbusStateConnected:
> >  		blkfront_connect(info);
> >  		break;
> >  
> > +	case XenbusStateClosed:
> > +		if (dev->state == XenbusStateClosed)
> > +			break;
> > +		/* Missed the backend's Closing state -- fallthrough */
> >  	case XenbusStateClosing:
> > -		blkfront_closing(info);
> > +		blkfront_closing(info, backend_state);
> >  		break;
> >  	}
> >  }
