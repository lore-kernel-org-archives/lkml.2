Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1EUPCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 11:02:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab1EUPCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 11:02:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM driver
Date: Sat, 21 May 2011 17:02:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Eric Biederman <ebiederm@aristanetworks.com>,
        linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <201105211133.50238.arnd@arndb.de> <4DD7C3A7.5010402@tilera.com>
In-Reply-To: <4DD7C3A7.5010402@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211702.15949.arnd@arndb.de>
X-Provags-ID: V02:K0:f0f2Uc609EtG4SOW/8TznO4kEi29b6XPq/PnM+PzRfy
 r8EVl62rwFNluVpO4j8A2YDgff21zFJGu9j6Via0qHGBkkS45q
 VbBOIWdXqhLBfADUJDVBmhjySMHeKt9LYewSQ7BgCT+Le/rXOR
 yTwn8SDJ+eGJHqoAH/Q2g4Mtm68tTUcV4xcx7HKKE8QyymSEDt
 cXCZaT056TZsB0z5c3f9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 May 2011 15:52:39 Chris Metcalf wrote:

> On 5/21/2011 5:33 AM, Arnd Bergmann wrote:
> > What I only now noticed is that the other eeprom drivers only support
> > reading the eeprom, not writing it, so there is a significant difference.
> 
> However, this point isn't quite correct.  Both the at24 (I2C) and at25
> (SPI) sysfs drivers support the "write" callback for at least some of their
> supported hardware.  It's true that all the other drivers are read-only.

Ok, I stand corrected again.

> > Using the bin_attribute doesn't sound completely wrong to me, especially
> > if you put it in your /sys/hypervisor/* direcory together with the
> > regular attributes we talked about. The character device would also
> > be an option (better than /proc/ppc/update_flash that is used on pSeries),
> > but if we do that, I would group it together with the other similar
> > files (ps3flash, nwflash, ...) in a new subdirectory.
> 
> Sounds like the consensus is that a character driver is in fact the best
> option here.

At least the one that meets the least resistance ;-)

> > We do have precedent for multiple interfaces that have the same
> > purpose as this one:
> >
> > drivers/misc/eeprom/*
> > drivers/char/ps3flash.c
> > drivers/char/nwflash.c
> > drivers/char/bfin-otp.c
> > arch/powerpc/kernel/rtas_flash.c
> > drivers/sbus/char/jsflash.c
> 
> I'm certainly happy to push the original SPI ROM character device as
> drivers/platform/tile/srom.c.  I'm not sure there's enough value in trying
> to group that device together with other devices that are sort of similar
> but with pretty variant ancestry and not a lot of need for commonality --
> other than all have a file_operations structure :-)  In this case I think
> grouping it with other paravirtualized tile drivers may be the closer
> connection.

The general tendency is to always group drivers by their purpose these
days, instead of by the bus or other interface that they are attached
to. I would definitely prefer grouping it with drivers of the same
purpose.

The main reason is to make sure that a driver writer can easily find
existing drivers with the same purpose take them as example code, so
that new code uses the same API as existing code.

> Having gone through the process of creating a sysfs driver, I will also go
> ahead and remove the SPI support from it (since that's the part that
> requires "flush") and post the remaining pure-EEPROM I2C paravirtualized
> driver to LKML.  Since it has no need for flushes, it ends up exactly
> parallel to at24.c.
> 
> So here's my thought.  How does this sound?
> 
> - Add drivers/platform/tile
> - Put the original character device there as srom.c
> - Drop the bin_attribute "flush" changes
> - Add drivers/misc/eeprom/tile.c for our "pure" I2C EEPROM driver
> 
> I appreciate everyone's feedback and help on this!

Can you explain why there are both i2c and spi drivers? If they
have the same purpose (e.g. providing a place to store the kernel
binary) and same data layout, I would recommend using the
same user interface for both.

If you want to keep the srom.c driver with a chardev interface for
the SPI chip only, I would recommend sticking it into drivers/char/
for now, or possibly a new drivers/char/flash/.

I have agreed to take over future maintainership of drivers/char and
driver/misc during UDS in Budapest, basically to keep random
stuff from getting added there, so I will try to find a better place
for flash drivers like this.

	Arnd
