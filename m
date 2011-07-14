Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1GNJND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:13:03 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:65514 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1GNJNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:13:01 -0400
X-IronPort-AV: E=Sophos;i="4.65,528,1304294400"; 
   d="scan'208";a="6776513"
Subject: Re: [PATCH resubmit] xen-blkfront: Don't send closing 
 notification to backend in blkfront_closing()
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Joe Jin <joe.jin@oracle.com>
CC: Daniel Stodden <Daniel.Stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        "annie.li@oracle.com" <annie.li@oracle.com>,
        "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        "Greg Marsden" <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <4E1EAEE9.80605@oracle.com>
References: <4E1CEB34.5090907@oracle.com>
	 <1310631209.634.444.camel@zakaz.uk.xensource.com>
	 <4E1EAEE9.80605@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 14 Jul 2011 10:12:59 +0100
Message-ID: <1310634779.634.480.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 09:55 +0100, Joe Jin wrote:
> On 07/14/11 16:13, Ian Campbell wrote:
> > On Wed, 2011-07-13 at 01:47 +0100, Joe Jin wrote:

> > 
> > I'm wondering if we might not be better off deferring the disconnect on
> > the backend side until the frontend enters XenbusStateClosed instead of
> > doing it in closing.
> 
> Yes this fix from backend side works too, also this looks reasonable than 
> fix in frontend.

I guess there is either a missing "more" or "less" in that sentence ;-)

The nice thing about a backend fix is that you don't need to go round
propagating the fix into distros etc and updating existing deployed
guests (not to mention non-Linux frontends).

I actually thought blkback had something like this already in older
"classic" Xen kernels but it seems like the patch never made it out of
the XCP patch queue :-(. See
http://xenbits.xen.org/hg/XCP/linux-2.6.32.pq.hg/file/tip/CA-7672-blkback-shutdown.patch
(which appears to also incorporate a toolstack directed graceful
shutdown of some sort as well as deferring the device close).

Daniel, do you know of any plans to extricate that stuff from the XCP
patch queue for upstream? Are there any other patches (e.g. incremental
fixes) in that pq which should go along with it?

Ian.

> 
> Konrad, any advice?
> 
> Thanks,
> Joe
> 
> > 
> > Ian
> > 
> >>
> >> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> >> Signed-off-by: Annie Li <annie.li@oracle.com>
> >> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >> Cc: Jens Axboe <jaxboe@fusionio.com>
> >> Cc: stable@kernel.org
> >>
> >> ---
> >>  xen-blkfront.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> >> index b536a9c..f6d8ac2 100644
> >> --- a/drivers/block/xen-blkfront.c
> >> +++ b/drivers/block/xen-blkfront.c
> >> @@ -1088,7 +1088,7 @@ blkfront_closing(struct blkfront_info *info)
> >>  	if (bdev->bd_openers) {
> >>  		xenbus_dev_error(xbdev, -EBUSY,
> >>  				 "Device in use; refusing to close");
> >> -		xenbus_switch_state(xbdev, XenbusStateClosing);
> >> +		xbdev->state = XenbusStateClosing;
> >>  	} else {
> >>  		xlvbd_release_gendisk(info);
> >>  		xenbus_frontend_closed(xbdev);
> > 
> > 
> 
> 


