Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab1EUNwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 09:52:44 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:13585 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab1EUNwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 09:52:42 -0400
Message-ID: <4DD7C3A7.5010402@tilera.com>
Date: Sat, 21 May 2011 09:52:39 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@suse.de>, Eric Biederman <ebiederm@aristanetworks.com>,
        <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM
 driver
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <4DD6FB9E.2050604@tilera.com> <20110521032102.GD19907@suse.de> <201105211133.50238.arnd@arndb.de>
In-Reply-To: <201105211133.50238.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending since Thunderbird "helpfully" made the previous attempt include
an HTML portion, for no obvious reason.)

On 5/20/2011 11:21 PM, Greg KH wrote:
> On Fri, May 20, 2011 at 07:39:10PM -0400, Chris Metcalf wrote:
>> This driver is a paravirtualized hypervisor driver, so not really an I2C
>> driver at all (in fact it handles both SPI and I2C eeproms almost
>> identically within the Linux driver).  And I think the driver's "eeprom"
>> file should be compatible with userspace cli tools, assuming they close
>> their file descriptor when they're done writing.
> Big assumption.

Interesting!  I did in fact assume that most tools that read or write
eeproms would tend to be "batch" tools, i.e. they would read or write
whatever it was they wanted, then exit; the tool we have that modifies this
EEPROM is written like that, for example.  It sounds like you're saying
there are (or may be) tools that open the file descriptor and do writes to
it, then don't exit or close the file descriptor, but expect the last write
to have hit the device immediately.  It's fair to say that since my
suggested API does defer the last sector's worth of writes until the app
exits, it potentially violates that assumption, so it's a bad idea.

On 5/21/2011 3:46 AM, Eric Biederman wrote:
> What is wrong with an mtd driver?

More backstory: we actually have an MTD driver for this device (in our
local tree as drivers/mtd/devices/tile_srom.c) but we haven't yet tried to
push it back to the community.  But it doesn't work for the most important
purpose of this device, namely to serve as one of the possible boot streams
at power-on.  For this, we have to control exactly what data is on what
sector, which means a character (or sysfs) device.

> Looking a bit back into the conversation it appears clear that you are
> talking about something that resembles NOR flash with multiple sectors,
> etc.
>
> eeproms have random byte access and are typically 256 bytes.  You devices
> doesn't sound anything like an eeprom.

Yes and no.  As Arnd points out in his followup, the hypervisor driver for
this SPI ROM makes it look a lot like a typical eeprom.  But, perhaps, not
quite close enough to count as a "real" eeprom.

On 5/21/2011 5:33 AM, Arnd Bergmann wrote:
> What I only now noticed is that the other eeprom drivers only support
> reading the eeprom, not writing it, so there is a significant difference.

However, this point isn't quite correct.  Both the at24 (I2C) and at25
(SPI) sysfs drivers support the "write" callback for at least some of their
supported hardware.  It's true that all the other drivers are read-only.

> Using the bin_attribute doesn't sound completely wrong to me, especially
> if you put it in your /sys/hypervisor/* direcory together with the
> regular attributes we talked about. The character device would also
> be an option (better than /proc/ppc/update_flash that is used on pSeries),
> but if we do that, I would group it together with the other similar
> files (ps3flash, nwflash, ...) in a new subdirectory.

Sounds like the consensus is that a character driver is in fact the best
option here.

> We do have precedent for multiple interfaces that have the same
> purpose as this one:
>
> drivers/misc/eeprom/*
> drivers/char/ps3flash.c
> drivers/char/nwflash.c
> drivers/char/bfin-otp.c
> arch/powerpc/kernel/rtas_flash.c
> drivers/sbus/char/jsflash.c

I'm certainly happy to push the original SPI ROM character device as
drivers/platform/tile/srom.c.  I'm not sure there's enough value in trying
to group that device together with other devices that are sort of similar
but with pretty variant ancestry and not a lot of need for commonality --
other than all have a file_operations structure :-)  In this case I think
grouping it with other paravirtualized tile drivers may be the closer
connection.

Having gone through the process of creating a sysfs driver, I will also go
ahead and remove the SPI support from it (since that's the part that
requires "flush") and post the remaining pure-EEPROM I2C paravirtualized
driver to LKML.  Since it has no need for flushes, it ends up exactly
parallel to at24.c.

So here's my thought.  How does this sound?

- Add drivers/platform/tile
- Put the original character device there as srom.c
- Drop the bin_attribute "flush" changes
- Add drivers/misc/eeprom/tile.c for our "pure" I2C EEPROM driver

I appreciate everyone's feedback and help on this!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


