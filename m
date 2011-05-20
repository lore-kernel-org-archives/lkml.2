Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab1ETXjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 19:39:45 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:63280 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab1ETXji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 19:39:38 -0400
Message-ID: <4DD6FB9E.2050604@tilera.com>
Date: Fri, 20 May 2011 19:39:10 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Biederman <ebiederm@aristanetworks.com>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM
 driver
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>	<201105050841.40576.arnd@arndb.de>	<4DD6AD51.7090900@tilera.com>	<201105202046.40696.arnd@arndb.de> <BANLkTimMndGzjZJ0xUNgStY7kwM0aW7Ojg@mail.gmail.com>
In-Reply-To: <BANLkTimMndGzjZJ0xUNgStY7kwM0aW7Ojg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/2011 6:40 PM, Eric Biederman wrote:
> Please do not make sysfs the direct access method to your device.
> I may be wrong but I don't think any other driver relies exclusively on sysfs.

I'm basing my implementation on drivers/misc/eeprom/.  All the drivers
there use the same sysfs model.

> Certainly with the introduction of a flush you are introducing an completely
> different usage paradigm from current users and will need an entirely different
> set of tools.

I don't think using my proposed implementation will be detectably different
for most user tools.  The addition of the flush() method just allows my
implementation to defer the final sector's write until the device is closed
(sectors are in fact still written to hardware as one does seek() or
write() from one sector to another; only the "current" sector is cached by
the hypervisor).  I suppose some third-party tool that kept the eeprom file
descriptor open indefinitely and did multiple writes to the same sector
might not work as expected with this implementation.  But it seems hard to
imagine a use case for such a tool.

The direct motivation for this case is to "impedance match" to the
hypervisor driver for this device, which handles sector management
internally, so the Linux device doesn't have to.  Having a 'flush' method
avoids excessive re-writes of the same sector for certain access patterns. 
The only alternatives that I see are to rewrite the tile userspace tools,
but they are the way they are because the current model gives good
consistency guarantees for writing the boot rom in the presence of
arbitrary failure modes; or, to add something like a delayed timer event
that allows the Linux driver to notify the hypervisor driver that writes
are likely complete and it can write out the last sector.  Neither of these
are particularly attractive.

> You are vastly exceeding the one value per file rule of sysfs.

True, but bin_attribute has always been an exception to that rule anyway.

> Please look at the i2c core and if at all possible build a proper interface to
> your eeprom, that existing programs have a chance of utilizing rather than
> extending sysfs in ways that means cli tools can not work with it.

This driver is a paravirtualized hypervisor driver, so not really an I2C
driver at all (in fact it handles both SPI and I2C eeproms almost
identically within the Linux driver).  And I think the driver's "eeprom"
file should be compatible with userspace cli tools, assuming they close
their file descriptor when they're done writing.

I apologize for not including more of the back story in this email when
adding the cc's, by the way.  Originally I proposed a straightforward
character device for this role.  Arnd Bergmann encouraged me to look at
kernel precedents like drivers/char/eeprom/, which is why I converted this
driver to sysfs.  The first post in this thread is here:
https://lkml.org/lkml/2011/5/4/415 .  Since then I've come around to
believing that it's more valuable to group this driver with the other
eeprom drivers, rather than with the other paravirtualized tile drivers.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


