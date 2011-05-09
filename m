Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1EINfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:35:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34306 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752680Ab1EINfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:35:37 -0400
Date: Mon, 9 May 2011 15:35:43 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Liam Girdwood <lrg@kernel.org>, Graeme Gregory <gg@slimlogic.co.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 4/4] USB: TWL6025 allow different regulator name
Message-ID: <20110509133542.GF3225@opensource.wolfsonmicro.com>
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
 <1303897191-14792-5-git-send-email-gg@slimlogic.co.uk>
 <20110427104542.GZ13227@legolas.emea.dhcp.ti.com>
 <1304867317.3246.10.camel@odin>
 <20110509090335.GC1254@legolas.emea.dhcp.ti.com>
 <1304941430.3192.4.camel@odin>
 <20110509121600.GK1254@legolas.emea.dhcp.ti.com>
 <20110509122941.GA3225@opensource.wolfsonmicro.com>
 <20110509130703.GM1254@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509130703.GM1254@legolas.emea.dhcp.ti.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 04:07:07PM +0300, Felipe Balbi wrote:

> The thing is. We already had problems in the past with the Clock FW
> because drivers were passing clock names on platform_data and I really
> want to avoid the same on regulators. We need something clever.

Right, which is why you should *never* do that.  Any time I see anyone
requesting a regulator based on anything other than a fixed string in
the driver and the struct device for the consumer I push back very hard,
and so should everyone else.

> We pass in the data of how regulators are wired at the board level and
> drivers would regulator_get(my_dev->dev, "whatever fancy name I want as
> it doesn't matter at all");

No, not at all.  Consumer drivers should be hard coding the strings they
request and the strings used should correspond to the pin names used on
the device.

> If a driver has >1 regulator, you can distinguish them by which
> functionality they provide, no matter the name, they will be connected
> to a particular ball on the IC package which has a certain definition

Having more than one supply is the common case for devices; relatively
few devices have a single supply.

> on the TRM. In other words, we should match on the functionality they
> provide, not on the name.

As Liam said this will just make the situation worse.  Users will have
to figure out what the names the driver authors assigned to the various
device supplies map onto in the physical system via an additional layer
of indirection which will at best be written down in comments in the
driver.

> Let's try to thing some 5 - 6 years ahead. With the current trend, we
> will be working on support for the PMIC on OMAP10, imagine if each one
> of those revisions decide to change the name of the regulator, because
> this new HW engineer working on the PMIC design doesn't like the old
> name. We will have X regulator pointers and X regulator name pointers in
> our platform_data. It will be really cumbersome and prone to errors if
> people continue on copy&pasting old code to "generate" a new driver.

Here you're apparently talking about something different - you're
talking about how we pass in the regulator init data for the regulators
supplied by the chip.  The patch being discussed changes the consumer
side for USB, not the regulator driver side.  The naming on the driver
side is a particular problem for TWL devices since unlike most PMICs the
regulators aren't simply numbered but are instead assigned individual
names so you can't just use a big array indexed by number.

> What I was expecting to see, was a mechanism where we define how those
> things are wired (it doesn't matter if the data uses DeviceTree or what)
> at the HW level and we ask the framework to give us the regulator
> connected to device X which provides a certain functionality. Just like
> clkdev has managed to get close to. Currently drivers will:

This is preceisely what is happening.  A well written consumer driver
asks the regulator core for the regulator supplying a given supply, with
the supplies named in the same way as they are named in the datasheet.

You appear to be arging strongly for us to adopt the model which is
already in use.
