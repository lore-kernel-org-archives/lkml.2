Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab1ESPMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:12:34 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:51990 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1ESPMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:12:33 -0400
Message-ID: <4DD5334D.4060800@tilera.com>
Date: Thu, 19 May 2011 11:12:13 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: add /proc/tile, /proc/sys/tile, and a sysfs
 cpu attribute
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com> <201105191541.11939.arnd@arndb.de>
In-Reply-To: <201105191541.11939.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/2011 9:41 AM, Arnd Bergmann wrote:
> These all [below] look like ideal candidates for sysfs attributes under
> /sys/hypervisor, doing them one value per file, instead of grouping
> them into multiple entries per file.
>
> You can also turn each of these files into one directory under
> /sys/hypervisor, with one or more files under it.
>
> On Tuesday 17 May 2011, Chris Metcalf wrote
>> /proc/tile/hv
>>   Version information about the running Tilera hypervisor

Yes, for "hv" this does make sense; I've coded it up.  I had to add a
"select SYS_HYPERVISOR" for "config TILE" since otherwise tile doesn't
normally get a /sys/hypervisor directory.  The upshot is
/sys/hypervisor/version and /sys/hypervisor/config_version files.  The
"config_version" can be long (typically in the hundreds of characters) but
should rarely get up to the page size, and it's probably OK to just
truncate it in that case.  It looks like Xen also tries to do things in
this directory, but we don't currently support Xen (we're working on KVM
instead) so I won't worry about it.

>> /proc/tile/hvconfig
>>   Detailed configuration description of the hypervisor config

I'm concerned about moving this one out of /proc, since it's just (copious)
free text.  An "hvconfig" (hypervisor config) file describes hypervisor
driver "dedicated tiles" that run things like network packet or PCIe
ingress/egress processing, etc.  In addition it lists hypervisor driver
options, boot flags for the kernel, etc, all kinds of things -- and you
can't really guarantee that it will fit on a 4KB page, though in practice
it usually does.  The hypervisor reads this file from the boot stream when
it boots, and then makes it available to Linux not for Linux's use, or even
for programmatic userspace use, but just for end users to be able to review
and verify that the configuration they think they booted is really what
they got, for customer remote debugging, etc.  The "remote debugging"
aspect makes truncation to page size a particularly worrisome idea.

>> /proc/tile/board
>>   Information on part numbers, serial numbers, etc., of the
>>   hardware that the kernel is executing on
>>
>> /proc/tile/switch
>>   The type of control path for the onboard network switch, if any.

These two report information about the hardware, not the hypervisor.  For
example:

# cat /proc/tile/board
board_part: 402-00002-05
board_serial: NBS-5002-00012
chip_serial: P62338.01.110
chip_revision: A0
board_revision: 2.2
board_description: Tilera TILExpressPro-64, TILEPro64 processor (866 MHz-capable), 1 10GbE, 6 1GbE
# cat /proc/tile/switch
control: mdio gbe/0

The chip_serial and chip_revision can certainly hang off
/sys/devices/system/cpu along with chip_height and chip_width (I've made
this change now) but I don't know where the remaining "board" level
description could go.  Note that (as you can see in the source) certain
boards will also include four lines of output with the "mezzanine board"
part number, serial number, revision, and description; this particular
example doesn't have a mezzanine board.  The "switch" info is broken out
into a separate file just to make it easier to script some /etc/rc code
that launches a configurator for the Marvell switch on some of our boards,
but is conceptually part of the board info.

>> /proc/tile/hardwall
>>   Information on the set of currently active hardwalls (note that
>>   the implementation is already present in arch/tile/kernel/hardwall.c;
>>   this change just enables it)

This one is not a hypervisor-related file.  It just lists information about
the set of Linux hardwalls currently active.  Again, it's not primarily
intended for programmatic use, but as a diagnostic tool.

>> diff --git a/arch/tile/kernel/sysfs.c b/arch/tile/kernel/sysfs.c
>> new file mode 100644
>> index 0000000..151deeb
>> --- /dev/null
>> +++ b/arch/tile/kernel/sysfs.c
>> [...]
>> +static int __init create_cpu_entries(void)
>> +{
>> +	struct sysdev_class *cls = &cpu_sysdev_class;
>> +	int err = 0;
>> +
>> +	if (!err)
>> +		err = sysfs_create_file(&cls->kset.kobj,
>> +					&attr_chip_width.attr);
>> +	if (!err)
>> +		err = sysfs_create_file(&cls->kset.kobj,
>> +					&attr_chip_height.attr);
>> +
>> +	return err;
>> +}
> This should use sysdev_create_file instead of open-coding it.

My impression was that I had to associate my new attributes to the
sysdev_class corresponding to "/sys/devices/system/cpu/", since I'm
registering these as top-level items in the cpu directory, e.g.
/sys/devices/system/cpu/chip_width; they are not properties of individual
cpus.  It doesn't appear that there is a sys_device corresponding to where
I want to register them.

As always, thanks, Arnd!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


