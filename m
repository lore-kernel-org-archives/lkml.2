Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1EINvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:51:37 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:54543 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802Ab1EINvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:51:36 -0400
Date: Mon, 9 May 2011 16:51:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>, Liam Girdwood <lrg@kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 4/4] USB: TWL6025 allow different regulator name
Message-ID: <20110509135122.GQ1254@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
 <1303897191-14792-5-git-send-email-gg@slimlogic.co.uk>
 <20110427104542.GZ13227@legolas.emea.dhcp.ti.com>
 <1304867317.3246.10.camel@odin>
 <20110509090335.GC1254@legolas.emea.dhcp.ti.com>
 <1304941430.3192.4.camel@odin>
 <20110509121600.GK1254@legolas.emea.dhcp.ti.com>
 <20110509122941.GA3225@opensource.wolfsonmicro.com>
 <20110509130703.GM1254@legolas.emea.dhcp.ti.com>
 <20110509133542.GF3225@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509133542.GF3225@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 03:35:43PM +0200, Mark Brown wrote:
> On Mon, May 09, 2011 at 04:07:07PM +0300, Felipe Balbi wrote:
> 
> > The thing is. We already had problems in the past with the Clock FW
> > because drivers were passing clock names on platform_data and I really
> > want to avoid the same on regulators. We need something clever.
> 
> Right, which is why you should *never* do that.  Any time I see anyone
> requesting a regulator based on anything other than a fixed string in
> the driver and the struct device for the consumer I push back very hard,
> and so should everyone else.

ok, so let's go back to the original patch:

> @@ -190,6 +190,12 @@ static int twl6030_phy_suspend(struct otg_transceiver *x, int suspend)
>  
>  static int twl6030_usb_ldo_init(struct twl6030_usb *twl)
>  {
> +	char *regulator_name;
> +
> +	if (twl_features() & TWL6025_SUBCLASS)
> +		regulator_name = "ldousb";
> +	else
> +		regulator_name = "vusb";
>  
>  	/* Set to OTG_REV 1.3 and turn on the ID_WAKEUP_COMP */
>  	twl6030_writeb(twl, TWL6030_MODULE_ID0 , 0x1, TWL6030_BACKUP_REG);
> @@ -200,7 +206,7 @@ static int twl6030_usb_ldo_init(struct twl6030_usb *twl)
>  	/* Program MISC2 register and set bit VUSB_IN_VBAT */
>  	twl6030_writeb(twl, TWL6030_MODULE_ID0 , 0x10, TWL6030_MISC2);
>  
> -	twl->usb3v3 = regulator_get(twl->dev, "vusb");
> +	twl->usb3v3 = regulator_get(twl->dev, regulator_name);
>  	if (IS_ERR(twl->usb3v3))
>  		return -ENODEV;

then, imagine 5 years from now how that branch will look. How long do
you think it'll take until someone decides to pass that name via
platform_data to avoid growing that conditional ?


> > We pass in the data of how regulators are wired at the board level and
> > drivers would regulator_get(my_dev->dev, "whatever fancy name I want as
> > it doesn't matter at all");
> 
> No, not at all.  Consumer drivers should be hard coding the strings they
> request and the strings used should correspond to the pin names used on
> the device.

but that's the thing. Why do they need to depend on that string ?

> > on the TRM. In other words, we should match on the functionality they
> > provide, not on the name.
> 
> As Liam said this will just make the situation worse.  Users will have
> to figure out what the names the driver authors assigned to the various
> device supplies map onto in the physical system via an additional layer
> of indirection which will at best be written down in comments in the
> driver.

My point is that the "name" shouldn't matter. Instead of matching a
"name" match a "reference". Have something earlier in the boot assing
regulators to devices, or something like that, so that drivers don't
need to care about "names".

> > Let's try to thing some 5 - 6 years ahead. With the current trend, we
> > will be working on support for the PMIC on OMAP10, imagine if each one
> > of those revisions decide to change the name of the regulator, because
> > this new HW engineer working on the PMIC design doesn't like the old
> > name. We will have X regulator pointers and X regulator name pointers in
> > our platform_data. It will be really cumbersome and prone to errors if
> > people continue on copy&pasting old code to "generate" a new driver.
> 
> Here you're apparently talking about something different - you're
> talking about how we pass in the regulator init data for the regulators
> supplied by the chip.  The patch being discussed changes the consumer
> side for USB, not the regulator driver side.  The naming on the driver

see above, how long do you think it'll take for someone to try and pass
that name via pdata ? On the next name change, this is already likely to
happen to prevent that conditional from growing.

> side is a particular problem for TWL devices since unlike most PMICs the
> regulators aren't simply numbered but are instead assigned individual
> names so you can't just use a big array indexed by number.

why not ? The name shouldn't matter. In anycase, if you look into
/sys/class/regulator/ all directories are regulator.<index>:

	dev_set_name(&rdev->dev, "regulator.%d",
		     atomic_inc_return(&regulator_no) - 1);

> > What I was expecting to see, was a mechanism where we define how those
> > things are wired (it doesn't matter if the data uses DeviceTree or what)
> > at the HW level and we ask the framework to give us the regulator
> > connected to device X which provides a certain functionality. Just like
> > clkdev has managed to get close to. Currently drivers will:
> 
> This is preceisely what is happening.  A well written consumer driver
> asks the regulator core for the regulator supplying a given supply, with
> the supplies named in the same way as they are named in the datasheet.
> 
> You appear to be arging strongly for us to adopt the model which is
> already in use.

I guess I hasn't been clear enough then, my whole point is that drivers
shouldn't depend on strings at all in order to fetch the correct
regulator. How many:

if (xxx_features() & XXX_CLASS_IS_YYYY)
	regulator_name = "my_first_name";
else
	regulator_name = "my_second_name";

will have to pop in drivers until we figure that it won't scale ?

-- 
balbi
