Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1EFThL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:37:11 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:55208 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab1EFThJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:37:09 -0400
Message-ID: <4DC44DE3.8000509@tilera.com>
Date: Fri, 6 May 2011 15:37:07 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM
 driver
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <201105050841.40576.arnd@arndb.de>
In-Reply-To: <201105050841.40576.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/2011 2:41 AM, Arnd Bergmann wrote:
> On Wednesday 04 May 2011, Chris Metcalf wrote:
>> This commit does two things: it adds the infrastructure for a new
>> arch/tile/drivers/ directory, and it populates it with the first
>> instance of a driver for that directory, a SPI Flash ROM (srom) driver.
>>
>> The directory is motivated as follows.  While some classes of
>> driver implementations should be grouped together so they are easily
>> modified as a class (network, ATA, RTC, PCI, I2C, etc etc) there are
>> "miscellaneous" drivers that don't benefit from any sharing with other
>> driver implementations.  If those drivers are for hardware that can
>> plausibly be used by multiple architectures, it makes sense to put
>> them somewhere like drivers/char.  But if they are only usable on
>> a single architecture (in this case drivers written for the Tilera
>> para-virtualization model using our hypervisor) it makes sense to group
>> such drivers with their architecture, to avoid cluttering the "drivers"
>> hierarchy for other architectures that can't use that driver.
> I generally advise against putting any device drivers into arch/*/,
> on the ground that it is much easier to find similar drivers when
> they are in a common place. We probably have a few similar drivers
> in the tree already, e.g drivers/misc/eeprom/* and drivers/char/ps3flash.c
> and drivers/platform/x86/intel_scu_ipcutil.c are examples of preexisting
> drivers.
>
> I'd probably put this one in driver/misc/eeprom and make the interface
> look like the other ones (sysfs bin attribute instead of character
> device), which is a trivial change.
>
> Alternatively, you could create drivers/platform/tile to hold tile
> specific device drivers, instead of keeping them under arch/tile.

For the implementation, as you say, it's worth conforming to the other
eeprom drivers regardless of where we put the actual implementation, so
I'll look into the sysfs infrastructure (I haven't used it before, but I
need to learn about it anyway).

As far as the location in the tree, I think it's 50/50 on something like
our eeprom driver.  On the one hand the actual implementation is very
Tilera-specific and very similar to all the other simple Tilera-specific
para-virtualized drivers, which are mostly just read/write wrappers around
hypervisor syscalls (we currently have about a dozen of these for various
minor bits of I/O).  On the other hand there is a little bit of eeprom
commonality too, but on balance it feels like it makes more sense to keep
it with the other "misc" Tilera drivers.  I'd say neither answer is
obviously wrong :-)

As to where the "misc" Tilera drivers should go, I see that so far there is
only drivers/platform/x86 (as created by Len Brown in 2008, along with a
note that "other architectures will create drivers/platform/<arch>").  Is
it fair to say that "drivers/s390", "drivers/parisc", and "drivers/sh" (for
example) are all in their current locations just for historical reasons,
and should in principle also be under "drivers/platform"?  If so, yes,
drivers/platform/tile seems like a reasonable location.

>> +/**
>> + * srom_llseek() - Change the current device offset.
>> [...]
> This looks unnecessary, just use generic_file_llseek.

It looks like I also can just discard the llseek code altogether if we
switch over to the sysfs model - even better :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


