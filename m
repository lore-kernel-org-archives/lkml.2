Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716Ab2EDXwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:52:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42298 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758151Ab2EDXwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:52:49 -0400
Date: Sat, 5 May 2012 00:52:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-embedded@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Handling of modular boards
Message-ID: <20120504235225.GN897@n2100.arm.linux.org.uk>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com> <20120504225514.GM897@n2100.arm.linux.org.uk> <20120504234056.GV14230@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120504234056.GV14230@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 12:40:57AM +0100, Mark Brown wrote:
> On Fri, May 04, 2012 at 11:55:14PM +0100, Russell King - ARM Linux wrote:
> > On Fri, May 04, 2012 at 07:58:51PM +0100, Mark Brown wrote:
> 
> > > I'm just starting to put some stuff together for this so I was wondering
> > > if anyone had been thinking about this and had any bright ideas for how
> > > to handle it, and also if people think that MFD is a good fit for this
> > > or if we should split the silicon MFDs from these PCBs.
> 
> > I don't think its true to say that there's no support for this kind of
> > thing.
> 
> > If you're thinking about a motherboard with separate add-on cards, then
> > you can view the cards as their own separate platform device.  Your
> > platform device driver would be a "whole board driver" responsible
> > for creating and registering the specific devices found on the board
> > in its probe function, and unregistering them in the remove function.
> 
> Oh, absolutely - there's support there at that level and several boards
> doing some or all of this in mainline already.  It's not that you can't
> do it, it's that there's a bunch of generic stuff to do with how you map
> the resources through to the devices on the modules and describe the
> chips that are on the modules for which there's no infrastructure so
> everything needs to be hand coded on a per board basis.  The board
> identification bits are board specific but the remapping and subdevice
> instantiation bits seem like they shouldn't be.

How about this - we have struct platform_device_info, which is used to
create platform devices.  We can use this as an array to describe what
platform devices to create in the sub-driver, including what the resources
should be etc.

However, there's a problem with this - what if you need to do some board
level init before hand?  That needs to be handled somehow before these
devices are instantiated.  That could be done via a callback through
platform data.

But... this all seems wrong, because rather than having a driver which
knows about the details of the board, we now have all the details of the
board in question back in platform code which originally declared the
board device.  That's wrong, because a daughter board may be shared
between different platforms, and we don't want multiple copies of that
data all around the place.

I don't think there's an easy or generic solution to this.

The best I can think of is ACPI, where they _do_ handle devices and
such like coming and going dynamically (I know this, it happens to my
serial and printer ports every time I dock and undock the laptop - and
stock Linux doesn't support that.  Which reminds me I need to get those
patches properly prepared and submitted...)  I'd assume that it also
deals with PCI bridges and buses behind that if you have one of those
docking stations too (I don't)...
