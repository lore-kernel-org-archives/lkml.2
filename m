Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab1FWOGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:06:33 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:59760 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab1FWOGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:06:31 -0400
Date: Thu, 23 Jun 2011 18:05:39 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] USB: EHCI: Allow users to override 80% max
	periodic bandwidth
Message-ID: <20110623140539.GA4403@tugrik.mns.mnsspb.ru>
References: <1308758567-8205-1-git-send-email-kirr@mns.spb.ru> <Pine.LNX.4.44L0.1106221514350.1977-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106221514350.1977-100000@iolanthe.rowland.org>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 03:22:28PM -0400, Alan Stern wrote:
> On Wed, 22 Jun 2011, Kirill Smelkov wrote:
> 
> > There are cases, when 80% max isochronous bandwidth is too limiting.
> > 
> > For example I have two USB video capture cards which stream uncompressed
> > video, and to stream full NTSC + PAL videos we'd need
> > 
> >     NTSC 640x480 YUV422 @30fps      ~17.6 MB/s
> >     PAL  720x576 YUV422 @25fps      ~19.7 MB/s
> > 
> > isoc bandwidth.
> > 
> > Now, due to limited alt settings in capture devices NTSC one ends up
> > streaming with max_pkt_size=2688  and  PAL with max_pkt_size=2892, both
> > with interval=1. In terms of microframe time allocation this gives
> > 
> >     NTSC    ~53us
> >     PAL     ~57us
> > 
> > and together
> > 
> >     ~110us  >  100us == 80% of 125us uframe time.
> > 
> > So those two devices can't work together simultaneously because the'd
> > over allocate isochronous bandwidth.
> > 
> > 80% seemed a bit arbitrary to me, and I've tried to raise it to 90% and
> > both devices started to work together, so I though sometimes it would be
> > a good idea for users to override hardcoded default of max 80% isoc
> > bandwidth.
> > 
> > After all, isn't it a user who should decide how to load the bus? If I
> > can live with 10% or even 5% bulk bandwidth that should be ok. I'm a USB
> > newcomer, but that 80% seems to be chosen pretty arbitrary to me, just
> > to serve as a reasonable default.
> 
> This seems like the sort of feature somebody might reasonably want to 
> use -- if they know exactly what they're doing.

Yes, thanks, exactly my case. Now I know the idea won't be rejected it
can be polished.


> > NOTE: for two streams with max_pkt_size=3072 (worst case) both time
> > allocation would be 60us+60us=120us which is 96% periodic bandwidth
> > leaving 4% for bulk and control. I think this should work too.
> 
> At 480 Mb/s, each microframe holds 7500 bytes (less if you count 
> bit-stuffing).  4% of that is 300 bytes, which is not enough for a 
> 512-byte bulk packet.  I think you'd run into trouble trying to do any 
> serious bulk transfers on such a tight schedule.

Yes, you seem to be right.

I still think 4% is maybe enough for control traffic.


> > Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > ---
> >  drivers/usb/host/ehci-hcd.c   |   16 ++++++++++++++++
> >  drivers/usb/host/ehci-sched.c |   17 +++++++----------
> >  2 files changed, 23 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
> > index c606b02..1d36e72 100644
> > --- a/drivers/usb/host/ehci-hcd.c
> > +++ b/drivers/usb/host/ehci-hcd.c
> > @@ -112,6 +112,14 @@ static unsigned int hird;
> >  module_param(hird, int, S_IRUGO);
> >  MODULE_PARM_DESC(hird, "host initiated resume duration, +1 for each 75us\n");
> >  
> > +/*
> > + * max periodic time per microframe
> > + * (be careful, USB 2.0 requires it to be 100us = 80% of 125us)
> > + */
> > +static unsigned int uframe_periodic_max = 100;
> > +module_param(uframe_periodic_max, uint, S_IRUGO);
> > +MODULE_PARM_DESC(uframe_periodic_max, "maximum allowed periodic part of a microframe, us");
> > +
> 
> This probably should be a sysfs attribute rather than a module 
> parameter, so that it can be applied to individual buses separately.

Agree


> >  #define	INTR_MASK (STS_IAA | STS_FATAL | STS_PCD | STS_ERR | STS_INT)
> >  
> >  /*-------------------------------------------------------------------------*/
> > @@ -571,6 +579,14 @@ static int ehci_init(struct usb_hcd *hcd)
> >  	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
> >  
> >  	/*
> > +	 * tell user, if using non-standard (80% == 100 usec/uframe) bandwidth
> > +	 */
> > +	if (uframe_periodic_max != 100)
> > +		ehci_info(ehci, "using non-standard max periodic bandwith "
> > +				"(%u%% == %u usec/uframe)",
> > +				100*uframe_periodic_max/125, uframe_periodic_max);
> > +
> > +	/*
> 
> Check for invalid values.  This should never be less than 100 or 
> greater than 125.

Ok. By the way, why should we limit it to be not less than 100?
Likewise, a user who knows exactly what he/she is doing could limit
periodic bandwidth to be less than 80% required by USB specification.


> >  	 * hw default: 1K periodic list heads, one per frame.
> >  	 * periodic_size can shrink by USBCMD update if hcc_params allows.
> >  	 */
> > diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
> > index d12426f..fb374f2 100644
> > --- a/drivers/usb/host/ehci-sched.c
> > +++ b/drivers/usb/host/ehci-sched.c
> > @@ -172,7 +172,7 @@ periodic_usecs (struct ehci_hcd *ehci, unsigned frame, unsigned uframe)
> >  		}
> >  	}
> >  #ifdef	DEBUG
> > -	if (usecs > 100)
> > +	if (usecs > uframe_periodic_max)
> 
> These changes all seem right.

Thanks. I'll try to prepare updated patch.


Kirill
