Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1EUPbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 11:31:41 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:30966 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1EUPbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 11:31:38 -0400
Message-ID: <4DD7DAD4.4020401@tilera.com>
Date: Sat, 21 May 2011 11:31:32 -0400
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
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <201105211133.50238.arnd@arndb.de> <4DD7C3A7.5010402@tilera.com> <201105211702.15949.arnd@arndb.de>
In-Reply-To: <201105211702.15949.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/2011 11:02 AM, Arnd Bergmann wrote:
> On Saturday 21 May 2011 15:52:39 Chris Metcalf wrote:
>> Sounds like the consensus is that a character driver is in fact the best
>> option here.
> At least the one that meets the least resistance ;-)

Well, perhaps that's what I meant :-)  I do take Greg K-H's point that we
don't really want to mess with the cleanliness of the bin_attribute API,
though.

> The general tendency is to always group drivers by their purpose these
> days, instead of by the bus or other interface that they are attached
> to. I would definitely prefer grouping it with drivers of the same
> purpose.
>
> The main reason is to make sure that a driver writer can easily find
> existing drivers with the same purpose take them as example code, so
> that new code uses the same API as existing code.
>
> If you want to keep the srom.c driver with a chardev interface for
> the SPI chip only, I would recommend sticking it into drivers/char/
> for now, or possibly a new drivers/char/flash/.

I will plan to push it to drivers/char/tile-srom.c for now, then.

> I have agreed to take over future maintainership of drivers/char and
> driver/misc during UDS in Budapest, basically to keep random
> stuff from getting added there, so I will try to find a better place
> for flash drivers like this.

I'll add my thanks for helping keep the kernel a better place.  It's great
that there are folks like yourself who are willing to devote time to code
and structural cleanliness rather than just shoving in whatever they can
get away with :-)

> Can you explain why there are both i2c and spi drivers? If they
> have the same purpose (e.g. providing a place to store the kernel
> binary) and same data layout, I would recommend using the
> same user interface for both.

The I2C eeprom driver can't be used to store the boot stream, just the SPI
driver; the I2C eeprom driver is mostly for customer use.  In fact the
drivers are similar enough that I rewrote the SPI driver for sysfs first,
since it was harder, but then found that grafting in support for the I2C
driver was pretty easy, since all I had to do was add some
conditionalization (different "chunk" size for writes, no need for write
retries during sector erase, no support for page_size and sector_size
attributes).  The absence of "size" attributes for the I2C driver is the
only visible user interface difference, but it's fundamental to the devices.

It's tempting to combine the drivers into one, but it feels like we might
as well publish the I2C driver with the other eeprom sysfs drivers, and the
SPI driver as a character device, as discussed.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


