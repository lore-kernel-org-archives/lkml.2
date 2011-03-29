Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1C2LGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:06:50 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:54838 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756Ab1C2LGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:06:48 -0400
Date: Tue, 29 Mar 2011 14:06:44 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: Fix usbhs_enable error handling
Message-ID: <20110329110644.GD3041@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1301393275.2253.7.camel@phoenix>
 <50616adee81e0719b7b35884bfa194eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50616adee81e0719b7b35884bfa194eb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 04:05:40PM +0530, Keshava Munegowda wrote:
> > -----Original Message-----
> > From: Axel Lin [mailto:axel.lin@gmail.com]
> > Sent: Tuesday, March 29, 2011 3:38 PM
> > To: linux-kernel@vger.kernel.org
> > Cc: Keshava Munegowda; Samuel Ortiz
> > Subject: [PATCH] mfd: Fix usbhs_enable error handling
> >
> > In the case of missing platform_data we do not hold a spin_lock,
> > thus we should not call spin_unlock_irqrestore in the error path.
> >
> > Also simplify the error handling by separating the successful path
> > from error path. I think this change improves readability.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> >  drivers/mfd/omap-usb-host.c |    8 +++-----
> >  1 files changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> > index cb01209..4157d76 100644
> > --- a/drivers/mfd/omap-usb-host.c
> > +++ b/drivers/mfd/omap-usb-host.c
> > @@ -700,8 +700,7 @@ static int usbhs_enable(struct device *dev)
> >  	dev_dbg(dev, "starting TI HSUSB Controller\n");
> >  	if (!pdata) {
> >  		dev_dbg(dev, "missing platform_data\n");
> > -		ret =  -ENODEV;
> > -		goto end_enable;
> > +		return  -ENODEV;
> >  	}
> >
> >  	spin_lock_irqsave(&omap->lock, flags);
> > @@ -915,7 +914,8 @@ static int usbhs_enable(struct device *dev)
> >
> >  end_count:
> >  	omap->count++;
> > -	goto end_enable;
> > +	spin_unlock_irqrestore(&omap->lock, flags);
> > +	return 0;
> >
> >  err_tll:
> >  	if (pdata->ehci_data->phy_reset) {
> > @@ -931,8 +931,6 @@ err_tll:
> >  	clk_disable(omap->usbhost_fs_fck);
> >  	clk_disable(omap->usbhost_hs_fck);
> >  	clk_disable(omap->usbhost_ick);
> > -
> > -end_enable:
> >  	spin_unlock_irqrestore(&omap->lock, flags);
> >  	return ret;
> >  }
> > --
> > 1.7.1
> 
> Thanks Axel!
> Acked-by: Keshava Munegowda < keshava_mgowda@ti.com>

Samuel, Greg is out for the week, could you take this one through your
tree instead of waiting for a week until we get this fix merged. If you
need my Ack, here it goes:

Acked-by: Felipe Balbi <balbi@ti.com>

-- 
balbi
