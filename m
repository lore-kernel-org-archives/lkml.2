Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1HQNFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:05:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38525 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752126Ab1HQNFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:05:43 -0400
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, sdharia@codeaurora.org,
        David Brown <davidb@codeaurora.org>, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201108171242.24918.arnd@arndb.de>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
	 <1772239.ndMLD9ec3r@wuerfel>
	 <20110817080327.GD13460@opensource.wolfsonmicro.com>
	 <201108171242.24918.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Wolfson Microelectronics
Date: Wed, 17 Aug 2011 22:04:01 +0900
Message-ID: <1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 12:42 +0200, Arnd Bergmann wrote:

> the bus is probed. It's a bit unfortunate that the initial slimbus
> code was modeled after i2c and spi, when it's really more like USB
> in the sense that devices can (and should) actually be discovered
> using methods provided by the bus spec.

Yeah, though in reality it's somewhere in between.

> > I'd expect that bringing the device out of reset is going to be largely
> > unrelated to the host controller, it's going to be GPIOs, clocks and
> > regulators.  The individual drivers are going to want to manage this
> > stuff dynamically at runtime too.

> But it's even less related to the individual driver than to the host.

No, not at all - all the bus specifies is the two wire control
interface, if a device on the bus requires power or anything else that's
not something the CPU Slimbus (I keep wanting to typo that as
Slumbus...) controller has any idea about. In this respect Slimbus is
much more like I2C than USB where there's a standard provision for power
even if embedded systems routinely ignore it.

The device driver will know what power supplies and other signals the
device has, and it will know how and when to use them. This can
generally be done independently of the board with just some platform or
device tree data to configure GPIOs.

> Clearly, the code for starting up the device has to live somewhere, but
> I think that should not be the device driver that is responsible
> for talking to the slimbus device itself, because that each board
> will do that slightly differently and the slimbus_driver should not
> need to know about the device before it has been found on the bus.

If we're going to do that we should do the same thing for at least I2C
and SPI also. In terms of the board differences they're generally not
hard to abstract.

One thing to bear in mind here is that in these sort of systems it's not
uncommon for devices to want to dynamically manage their power at
runtime, both partially removing supplies and going to complete power
down (we've got drivers in the kernel at present which are doing that)
depending on usage. The full power off is fairly straightforward but
partial power states will mean complication as we have to work out how
to hand the resources from the pre-driver code to the driver and back
again.

> The way I see this working is that something outside of the driver
> should provide a way to enable each device in order for it to get
> probed, and the driver's ->probe callback does a pm_runtime_get()
> call when it wants to keep the device enabled.

Some pre-cooked off the shelf device wide power management is definitely
useful for simple cases but I don't think that scales to high end
devices - it's too binary. Like I said I really do want to have some
transparent device model way of handling the simple cases but we need to
leave room for devices which want to do more complicated things.

It also occurs to me that if we're supporting going down to cold with
runtime PM anyway the kernel is going to have to be able to understand
the idea that devices it already knows about are going to hotplug in and
out while staying registered. If we're doing that then it seems like the
bus is going to have pretty much all the concepts required for explicit
registration anyway.

