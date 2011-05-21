Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab1EUD3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 23:29:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:42938 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1EUD3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 23:29:13 -0400
Date: Fri, 20 May 2011 20:21:02 -0700
From: Greg KH <gregkh@suse.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Eric Biederman <ebiederm@aristanetworks.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM
 driver
Message-ID: <20110521032102.GD19907@suse.de>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
 <201105050841.40576.arnd@arndb.de>
 <4DD6AD51.7090900@tilera.com>
 <201105202046.40696.arnd@arndb.de>
 <BANLkTimMndGzjZJ0xUNgStY7kwM0aW7Ojg@mail.gmail.com>
 <4DD6FB9E.2050604@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD6FB9E.2050604@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 07:39:10PM -0400, Chris Metcalf wrote:
> On 5/20/2011 6:40 PM, Eric Biederman wrote:
> > Please do not make sysfs the direct access method to your device.
> > I may be wrong but I don't think any other driver relies exclusively on sysfs.
> 
> I'm basing my implementation on drivers/misc/eeprom/.  All the drivers
> there use the same sysfs model.
> 
> > Certainly with the introduction of a flush you are introducing an completely
> > different usage paradigm from current users and will need an entirely different
> > set of tools.
> 
> I don't think using my proposed implementation will be detectably different
> for most user tools.  The addition of the flush() method just allows my
> implementation to defer the final sector's write until the device is closed
> (sectors are in fact still written to hardware as one does seek() or
> write() from one sector to another; only the "current" sector is cached by
> the hypervisor).  I suppose some third-party tool that kept the eeprom file
> descriptor open indefinitely and did multiple writes to the same sector
> might not work as expected with this implementation.  But it seems hard to
> imagine a use case for such a tool.
> 
> The direct motivation for this case is to "impedance match" to the
> hypervisor driver for this device, which handles sector management
> internally, so the Linux device doesn't have to.  Having a 'flush' method
> avoids excessive re-writes of the same sector for certain access patterns. 
> The only alternatives that I see are to rewrite the tile userspace tools,
> but they are the way they are because the current model gives good
> consistency guarantees for writing the boot rom in the presence of
> arbitrary failure modes; or, to add something like a delayed timer event
> that allows the Linux driver to notify the hypervisor driver that writes
> are likely complete and it can write out the last sector.  Neither of these
> are particularly attractive.
> 
> > You are vastly exceeding the one value per file rule of sysfs.
> 
> True, but bin_attribute has always been an exception to that rule anyway.

No it hasn't.  A bin attribute is for something that is "one" value, it
is a binary file that the kernel doesn't know anything about, nor does
it intrepret it.

It sounds like you want this binary attribute file to be a bit different
than the "normal" one, and because of that you are wanting to modify the
sysfs file, which proves that you are doing things differently here.

So, I agree with Eric, please do something else as you are not really
wanting to use a binary attribute, you want something else, like a
character driver.

Why can't you do that?

> This driver is a paravirtualized hypervisor driver, so not really an I2C
> driver at all (in fact it handles both SPI and I2C eeproms almost
> identically within the Linux driver).  And I think the driver's "eeprom"
> file should be compatible with userspace cli tools, assuming they close
> their file descriptor when they're done writing.

Big assumption.

> I apologize for not including more of the back story in this email when
> adding the cc's, by the way.

Yeah, that made things difficult :)

> Originally I proposed a straightforward character device for this
> role.

Ah, ok, I think you should do that.

> Arnd Bergmann encouraged me to look at kernel precedents like
> drivers/char/eeprom/, which is why I converted this driver to sysfs.
> The first post in this thread is here:
> https://lkml.org/lkml/2011/5/4/415 .  Since then I've come around to
> believing that it's more valuable to group this driver with the other
> eeprom drivers, rather than with the other paravirtualized tile
> drivers.

See above why I don't think that is so.

thanks,

greg k-h
