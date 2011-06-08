Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab1FHV1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:27:49 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:50398 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab1FHV1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:27:47 -0400
Message-ID: <4DEFE938.70408@freemail.hu>
Date: Wed, 08 Jun 2011 23:27:20 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Kulikov Vasiliy <segooon@gmail.com>, Endre Kollar <taxy443@gmail.com>,
        Arjan Mels <arjan.mels@gmx.net>, Ilia Mirkin <imirkin@alum.mit.edu>,
        David Chang <dchang@novell.com>,
        Himanshu Chauhan <hschauhan@nulltrace.org>,
        Max Vozeler <max@vozeler.com>, Arnd Bergmann <arnd@arndb.de>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbip: handle length at sysfs show() functions
References: <4DE5CA9F.6010303@freemail.hu> <20110607213418.GB11102@kroah.com> <4DEF0822.7070500@freemail.hu> <20110608160931.GB21645@kroah.com>
In-Reply-To: <20110608160931.GB21645@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Original: 94.21.203.101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Jun 08, 2011 at 07:26:58AM +0200, Németh Márton wrote:
>> Greg KH wrote:
>>> On Wed, Jun 01, 2011 at 07:14:07AM +0200, Németh Márton wrote:
>>>> The sysfs show() functions shall return the actual content length of
>>>> the result buffer. According to Documentation/filesystems/sysfs.txt:215
>>>> the scnprintf() function is preferred.
>>>>
>>>> See also the article titled "snprintf() confusion" at
>>>> http://lwn.net/Articles/69419/ .
>>> [...]
>>>
>>> Here we are doing lots of work to try to put more than one value in the
>>> sysfs file, and return the proper data to the kernel about how big the
>>> buffer we used.
>>>
>>> That's wrong, and violates the "one value per file" sysfs rule, so that
>>> should be fixed instead of trying to change the sprintf() call.
>> As I understand there is a need to change the design here. Currently I
>> get the following content when vhci-hcd is loaded but not yet used:
>>
>> $ cat /sys/devices/platform/vhci_hcd/status
>> prt sta spd bus dev socket           local_busid
>> 000 004 000 000 000 0000000000000000 0-0
>> 001 004 000 000 000 0000000000000000 0-0
>> 002 004 000 000 000 0000000000000000 0-0
>> 003 004 000 000 000 0000000000000000 0-0
>> 004 004 000 000 000 0000000000000000 0-0
>> 005 004 000 000 000 0000000000000000 0-0
>> 006 004 000 000 000 0000000000000000 0-0
>> 007 004 000 000 000 0000000000000000 0-0
>>
>> The fields are: port, status, speed, device ID, socket pointer and
>> local busid name. This is too complex for sysfs. Maybe we could extend
>> the devices file of usbfs with some new rows?
> 
> Ick, I doubt it as there are lots of tools that parse that file already.

usbip is still part of the staging directory. In dmesg the following appear:

| usbip_common_mod: module is from the staging directory, the quality is unknown, you have been warned.
| usbip_common_mod: usbip common driver1.0
| vhci_hcd: module is from the staging directory, the quality is unknown, you have been warned.

so this means that usbip is a work-in-progress, it might be changed anytime. On
the other hand we can do this nice way: a new entry in  Documentation/feature-removal-schedule.txt
for /sys/devices/platform/vhci_hcd/status file removal, let's say it will be
removed before the usbip goes to mainline. In parallel the new interface
can be developed.

> But yes, you are correct, this should not be in sysfs at all.
> 
> What's the use for this file?  Who uses it?  Is it just debugging
> output?  Information for people to gaze at if they feel like it?
> Something else?

Based on the user space source code at drivers/staging/usbip/userspace/
I can identify the following usages:

libsrc/vhci_driver.c::get_nports():
 - finding out how many ports the VHCI has

libsrc/vhci_driver.c::parse_status():
 - VHCI port number to identify virtual ports
 - fetching the status of each VHCI ports whether it is
     - vdev does not connect a remote device: (status = VDEV_ST_NULL = 4):
       "Port Available"
     - vdev is used, but the USB address is not assigned yet (status =
       VDEV_ST_NOTASSIGNED = 5): "Port Initializing"
     - used (status = VDEV_ST_USED = 6): "Port in Use"
     - error (VDEV_ST_ERROR = 7): "Port Error"
 - the speed can be unknown/low/full/high/variable
 - it looks like the bus column was merged with the device column but I
   currently cannot find when
 - the device ID is splited to the upper 16bits: bus number, and lower
   16bits: device number
 - based on local_busid the usb device file can be found in /sys using
   sysfs_open_device()

Note that the socket parameter is only printed out as a debug information: it
is not used anywhere.

Maybe most of the file content is redundant, because:

 - we have /sys/bus/usb/devices/usb*/maxchild which is "number of ports if hub"
   according to linux/usb.h:410 ;
 - we have /sys/bus/usb/devices/*-*/speed to identify the device speed;
 - We have already bus number at /sys/bus/usb/devices/usb*/busnum or at
   /sys/bus/usb/devices/*-*/busnum ;
 - we also have /sys/bus/usb/devices/*-*/devnum ;
 - it is possbile to collect all the devices from /sys/bus/usb/devices/*-*
   filtering to the first number to /sys/bus/usb/devices/usb*/busnum .

The only thing which is special for VHCI is the status for each port:
DEV_ST_NULL/VDEV_ST_NOTASSIGNED/VDEV_ST_USED/VDEV_ST_ERROR .

> Once we figure that out, then we can determine where it should go
> (debugfs, sysfs in a different file format, usbfs, etc.)

Maybe the status could fit under /sys/devices/platform/vhci_hcd/*-*/status .
This file could contain only one number showing the status of that single
device.

Regards,

	Márton Németh

