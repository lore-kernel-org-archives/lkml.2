Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1EINHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:07:17 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:44142 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab1EINHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:07:15 -0400
Date: Mon, 9 May 2011 16:07:07 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>, Liam Girdwood <lrg@kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 4/4] USB: TWL6025 allow different regulator name
Message-ID: <20110509130703.GM1254@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
 <1303897191-14792-5-git-send-email-gg@slimlogic.co.uk>
 <20110427104542.GZ13227@legolas.emea.dhcp.ti.com>
 <1304867317.3246.10.camel@odin>
 <20110509090335.GC1254@legolas.emea.dhcp.ti.com>
 <1304941430.3192.4.camel@odin>
 <20110509121600.GK1254@legolas.emea.dhcp.ti.com>
 <20110509122941.GA3225@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509122941.GA3225@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 09, 2011 at 02:29:41PM +0200, Mark Brown wrote:
> On Mon, May 09, 2011 at 03:16:03PM +0300, Felipe Balbi wrote:
> > On Mon, May 09, 2011 at 12:43:49PM +0100, Liam Girdwood wrote:
> 
> > > I think it's the lesser evil though, especially for device integrators.
> > > They will just match the regulator name from the schematics together
> > > with the TRM name when creating their regulator constraints and having
> > > different names here will definitely cause confusion.
> 
> > Any chance Device Tree could be used to pass that data to kernel
> > instead, together with regulator names and all needed data for each one
> > of them ?
> 
> I'm pretty sure that as soon as we have viable device tree support for
> relevant platforms in mainline we'll have regulator support, though I'm
> not sure that this will help too much with the naming as you'll still
> have to figure out what the consumer requests.  We shouldn't be passing
> in the consumer supply names from device tree (at least not a board
> specific one) as this breaks the model that the supply names correspond
> to the chip pins.

The thing is. We already had problems in the past with the Clock FW
because drivers were passing clock names on platform_data and I really
want to avoid the same on regulators. We need something clever.

We pass in the data of how regulators are wired at the board level and
drivers would regulator_get(my_dev->dev, "whatever fancy name I want as
it doesn't matter at all");

If a driver has >1 regulator, you can distinguish them by which
functionality they provide, no matter the name, they will be connected
to a particular ball on the IC package which has a certain definition
on the TRM. In other words, we should match on the functionality they
provide, not on the name.

Let's try to thing some 5 - 6 years ahead. With the current trend, we
will be working on support for the PMIC on OMAP10, imagine if each one
of those revisions decide to change the name of the regulator, because
this new HW engineer working on the PMIC design doesn't like the old
name. We will have X regulator pointers and X regulator name pointers in
our platform_data. It will be really cumbersome and prone to errors if
people continue on copy&pasting old code to "generate" a new driver.

What I was expecting to see, was a mechanism where we define how those
things are wired (it doesn't matter if the data uses DeviceTree or what)
at the HW level and we ask the framework to give us the regulator
connected to device X which provides a certain functionality. Just like
clkdev has managed to get close to. Currently drivers will:

clk_get(dev, "ick");
clk_get(dev, "fck");

etc...

and the name really doesn't matter. Clkdev still isn't perfect as it
uses device names, then when we want/need to change the device/driver
name (due to some re-factoring for example) we end up breaking things.
IMHO, struct device should point to its dependencies, be it a clock, be
it a regulator.

-- 
balbi
