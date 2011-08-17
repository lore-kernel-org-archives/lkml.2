Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1HQOBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:01:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55976 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab1HQOB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:01:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Date: Wed, 17 Aug 2011 16:00:37 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kenneth Heitke <kheitke@codeaurora.org>, sdharia@codeaurora.org,
        David Brown <davidb@codeaurora.org>, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <201108171242.24918.arnd@arndb.de> <1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
In-Reply-To: <1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108171600.37791.arnd@arndb.de>
X-Provags-ID: V02:K0:CHjCTJc7TrQyrOcSEnLxddBJXEs6Ez6LWN06Yf/bPxd
 wESqEIYqkZ1Kjr6aRXI391LLYlyXzbXcXY1hfKR696OLrcQvCK
 cjNAGfaSVyhdPM6j2jW6Rb3qqTGy2nMaoGx/+fjo3OFIApInDg
 aggNrlTc4DcfrNNmiiaG6V74XhQ5+xYbfUzUm6jDOmdqH3Vwys
 etStzdoISK8Clak+kKBMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011, Mark Brown wrote:
> On Wed, 2011-08-17 at 12:42 +0200, Arnd Bergmann wrote:
> > > I'd expect that bringing the device out of reset is going to be largely
> > > unrelated to the host controller, it's going to be GPIOs, clocks and
> > > regulators.  The individual drivers are going to want to manage this
> > > stuff dynamically at runtime too.
> 
> > But it's even less related to the individual driver than to the host.
> 
> No, not at all - all the bus specifies is the two wire control
> interface, if a device on the bus requires power or anything else that's
> not something the CPU Slimbus (I keep wanting to typo that as
> Slumbus...) controller has any idea about. In this respect Slimbus is
> much more like I2C than USB where there's a standard provision for power
> even if embedded systems routinely ignore it.
>
> The device driver will know what power supplies and other signals the
> device has, and it will know how and when to use them. This can
> generally be done independently of the board with just some platform or
> device tree data to configure GPIOs.

Ok, I think you've managed to get through to me ;-)

> > The way I see this working is that something outside of the driver
> > should provide a way to enable each device in order for it to get
> > probed, and the driver's ->probe callback does a pm_runtime_get()
> > call when it wants to keep the device enabled.
> 
> Some pre-cooked off the shelf device wide power management is definitely
> useful for simple cases but I don't think that scales to high end
> devices - it's too binary. Like I said I really do want to have some
> transparent device model way of handling the simple cases but we need to
> leave room for devices which want to do more complicated things.
> 
> It also occurs to me that if we're supporting going down to cold with
> runtime PM anyway the kernel is going to have to be able to understand
> the idea that devices it already knows about are going to hotplug in and
> out while staying registered. If we're doing that then it seems like the
> bus is going to have pretty much all the concepts required for explicit
> registration anyway.

How about a mixed model then?

I can see three relevant cases to consider:

1. A simple potentially hotplugged device that registers itself to the bus
   can be automatically matched to the driver.
2. A device tree representation for hardwired devices that require
   something to happen in order to register to the bus (clock, regulator,
   ...).
3. A hardcoded list of devices on a slimbus host for stuff that is known
   to be there, e.g. on a PCI card that has its own driver and that
   also need some special setup as in case 2.

I think in all three cases, we should identify the device by its EA and
match that to the device driver. We create the slim_device and register
it to the bus as soon as one of the three above is found, but in case 2
and 3, the driver is responsible for the device to actually become active
on the bus before it's allowed to send any commands to it.

For the device tree binding, I would suggest defining a slimbus bus to
have #address-cells=1, #size-cells=0 and just put the EA into the reg
property. This is enough for the host driver to add create a
slim_device and match a driver to it. The driver can access all the
properties from the device_node (or platform_data in case of statically
defined devices). When the physical device shows up on the bus, it is
automatically associated with the existing slim_device.

	Arnd
