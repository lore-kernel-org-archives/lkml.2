Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585Ab2EDWzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:55:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55340 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2EDWzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:55:41 -0400
Date: Fri, 4 May 2012 23:55:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-embedded@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Handling of modular boards
Message-ID: <20120504225514.GM897@n2100.arm.linux.org.uk>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120504185850.GO14230@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 07:58:51PM +0100, Mark Brown wrote:
> Quite a few reference platforms (including Wolfson ones, which is why
> I'm particularly interested) use replaceable modules to allow
> configuration changes.  Since we can often identify the configuration at
> runtime we should ideally do that but currently there's no infrastructure 
> to help with that, generally this seems to be done in arch code for the
> machine but this doesn't scale when even the CPU might change and isn't
> terribly device tree compatible either.
> 
> For reference the code for current Wolfson plugin modules is in
> arch/arm/mach-s3c64xx/mach-crag6410-module.c.
> 
> The most obvious current fit here is the MFD subsystem but it feels like
> we need some slightly different infastructure to what MFD currently
> provides.  MFD is really set up to handle platform devices with a core
> and linear ranges of resources fanning out from that core since they're
> really oriented around chips.  In contrast these boards are more about
> remapping random collections of potentially unrelated resources and
> instantiating devices on all sorts of buses and share more with board
> files.
> 
> I'm just starting to put some stuff together for this so I was wondering
> if anyone had been thinking about this and had any bright ideas for how
> to handle it, and also if people think that MFD is a good fit for this
> or if we should split the silicon MFDs from these PCBs.

I don't think its true to say that there's no support for this kind of
thing.

If you're thinking about a motherboard with separate add-on cards, then
you can view the cards as their own separate platform device.  Your
platform device driver would be a "whole board driver" responsible
for creating and registering the specific devices found on the board
in its probe function, and unregistering them in the remove function.

This is exactly how I've now setup the Assabet with Neponset daughter
board - all the Neponset devices sit behind the Neponset platform
device, including things like the SA1111 multifunction chip and SMC91x
network interface.  I can bind and unbind the Neponset device from its
driver and have everything behind that driver appear and disappear
appropriately - which is useful if your modules can be hotplugged.

It also helps to give the right model to the power management support,
because you're automatically arranging the child devices below the
board-level device, which means all the child devices should be
suspended before the board level device, and the board level device
should be resumed before the child devices.
