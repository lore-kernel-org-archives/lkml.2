Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab2IKPeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:34:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30862 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2IKPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:34:49 -0400
Date: Tue, 11 Sep 2012 18:33:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 08/20] Staging: ipack: Switch to 8MHz operation before
 reading ID.
Message-ID: <20120911153349.GY19396@mwanda>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
 <1347267118-9580-8-git-send-email-siglesias@igalia.com>
 <20120911084818.GP19396@mwanda>
 <1347363066.4539.112.camel@fourier.local.igalia.com>
 <20120911113919.GA7174@endeavour.taprogge.org>
 <1347374377.4539.115.camel@fourier.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347374377.4539.115.camel@fourier.local.igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 04:39:37PM +0200, Samuel Iglesias Gonsálvez wrote:
> On Tue, 2012-09-11 at 13:39 +0200, Jens Taprogge wrote:
> > On Tue, Sep 11, 2012 at 01:31:06PM +0200, Samuel Iglesias Gonsálvez wrote:
> > > On Tue, 2012-09-11 at 11:48 +0300, Dan Carpenter wrote:
> > > > On Mon, Sep 10, 2012 at 10:51:46AM +0200, Samuel Iglesias Gonsálvez wrote:
> > > > > From: Jens Taprogge <jens.taprogge@taprogge.org>
> > > > > 
> > > > > Reading the ID space at 8 MHz is always supported.  Most carriers will
> > > > > boot up in 8MHz mode.  Still, play it safe and ensure we are operating at
> > > > > 8Mhz.
> > > > > 
> > > > > Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> > > > > Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
> > > > > ---
> > > > >  drivers/staging/ipack/ipack.c |   11 ++++++++---
> > > > >  1 file changed, 8 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
> > > > > index 4f3c945..95f56b8 100644
> > > > > --- a/drivers/staging/ipack/ipack.c
> > > > > +++ b/drivers/staging/ipack/ipack.c
> > > > > @@ -376,6 +376,9 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
> > > > >  	dev_set_name(&dev->dev,
> > > > >  		     "ipack-dev.%u.%u", dev->bus_nr, dev->slot);
> > > > >  
> > > > > +	if (bus->ops->set_clockrate(dev, 8))
> > > > > +		dev_warn(&dev->dev, "failed to switch to 8 MHz operation for reading of device ID.\n");
> > > > > +
> > > > >  	ret = ipack_device_read_id(dev);
> > > > >  	if (ret < 0) {
> > > > >  		dev_err(&dev->dev, "error reading device id section.\n");
> > > > > @@ -384,9 +387,11 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
> > > > >  	}
> > > > >  
> > > > >  	/* if the device supports 32 MHz operation, use it. */
> > > > > -	ret = bus->ops->set_clockrate(dev, dev->speed_32mhz ? 32 : 8);
> > > > > -	if (ret < 0)
> > > > > -		dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
> > > > > +	if (dev->speed_32mhz) {
> > > > > +		ret = bus->ops->set_clockrate(dev, 32);
> > > > > +		if (ret < 0)
> > > > > +			dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
> > > > > +	}
> > > > 
> > > > Ah.  Well done.  That's what I suggested earlier.  I think you
> > > > should get rid of the ->speed_8mhz all together.
> > > 
> > > I will do it in a follow-up patch. The rest of suggestions have been
> > > integrated in the patches. I will submit the patches very soon.
> > 
> > I have not seen any IPack V2 device yet.  But since the ID space
> > provides the 8MHz flag, it might be useful.  On the other hand, we can
> > still readd it when we see it.
> > 
> 
> If we have the flag, we should use it in some point. Not only save it in
> the variable speed_8mhz and don't use it at all.
> 
> > When you remove the flag, you can perhaps leave a comment in the code so
> > that it is easy to re-enable.
> > 
> 
> OK. I will send a patch in Industry Pack mailing list and we can discuss
> there if this is a good solution or not before sending to staging ML.

People worry too much about things they might need in the future.
This email thread is there on google.  That's the first place people
will look for the information if we need it.

The rest of my inbox today is full of people (Aaro and Hartley)
removing write only variables that where we probed the hardware
for all kinds interesting stuff and don't use it.

regards,
dan carpenter

