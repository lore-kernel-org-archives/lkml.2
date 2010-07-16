Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936111Ab0GPJHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:07:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42715 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936052Ab0GPJHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:07:44 -0400
Date: Fri, 16 Jul 2010 10:07:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Conke Hu <conke.hu@gmail.com>, CoffBeta <coffbeta@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        inux kernel <linux-kernel@vger.kernel.org>,
        ext-jani.1.nikula@nokia.com,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: tq 2440
Message-ID: <20100716090719.GA16995@n2100.arm.linux.org.uk>
References: <AANLkTimyBHliUa62qmfja_ke6YTTysiVAtJcZfi8l2gG@mail.gmail.com> <AANLkTil8GE1OguyAfp3XgfJvEmH98yNrlvGAx684a-qL@mail.gmail.com> <20100715163526.GJ29322@n2100.arm.linux.org.uk> <20100715165141.GA21272@suse.de> <20100715171029.GK29322@n2100.arm.linux.org.uk> <20100715172218.GA22197@suse.de> <20100715173322.GL29322@n2100.arm.linux.org.uk> <20100715205153.GC24463@suse.de> <20100715210936.GB6773@n2100.arm.linux.org.uk> <20100716085533.GB2419@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100716085533.GB2419@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 01:55:33AM -0700, Greg KH wrote:
> On Thu, Jul 15, 2010 at 10:09:36PM +0100, Russell King - ARM Linux wrote:
> > On Thu, Jul 15, 2010 at 01:51:53PM -0700, Greg KH wrote:
> > > On Thu, Jul 15, 2010 at 06:33:22PM +0100, Russell King - ARM Linux wrote:
> > > > Another way to avoid the other complaints is to remove
> > > > the unregistration in platform_register_devices().
> > > 
> > > No, because you could have created a platform device with a call to
> > > platform_device_alloc() and then called platform_device_register() and
> > > then later, platform_device_unregister(), right?
> > 
> > No.  Sorry, platform_register_devices should've been platform_add_devices().
> > Please look at that function.
> 
> Hm, it just calls platform_device_register(), so it's pretty hard to
> determine that it's a static device from that function.
> 
> > It's used to register an array of static platform devices from architecture
> > code, as I've said in this thread once already.
> 
> I can't think of an easy way to prevent these types of devices from
> being removed, other than the existing warnings we have.  I'll mull it
> over some more and see if I can come up with something in the future.

platform_add_devices() purpose is to allow platforms to bulk-register
their statically declared platform devices.  That's what I created it
for.

The easiest solution is to arrange for platform_add_devices() to avoid
unregistering them all if any one fails - eg, we don't particularly want
the platform device for the serial console being unregistered if a
subsequent device fails.

I'd also argue that it should be trying to register as many of the
platform devices as it possibly can, and only warning about devices
it can't register.

Of course, it is possible that it's been used for other purposes by now -
and yes it has:

drivers/mfd/ab3100-core.c:      platform_add_devices(ab3100_platform_devs,
drivers/video/backlight/kb3886_bl.c:    platform_add_devices(devices, ARRAY_SIZE(devices));

The first one is an oops waiting to happen - it's a modular driver which
has statically allocated platform devices which it registers, and on
removal it just unregisters its I2C driver.  Two problems with that:

1. references hanging around after registration and the memory backing
   the driver has been unmapped.
2. if two ab3100 devices are present, the same platform device structures
   are attempted to be registered more than once.

kb3886_bl.c has the same problem (1) above.

These two drivers need to be converted to use the platform_device_alloc()
et.al. API, which'll then mean that platform_add_devices() goes back to
its original purpose - bulk registering statically allocated platform
devices from arch code.
