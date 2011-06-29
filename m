Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab1F2FzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:55:07 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:49778 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1F2FzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:55:04 -0400
Message-ID: <4E0ABDFE.6080009@freemail.hu>
Date: Wed, 29 Jun 2011 07:54:06 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David Chang <dchang@novell.com>, Greg KH <greg@kroah.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kulikov Vasiliy <segooon@gmail.com>, Endre Kollar <taxy443@gmail.com>,
        Arjan Mels <arjan.mels@gmx.net>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Himanshu Chauhan <hschauhan@nulltrace.org>,
        Max Vozeler <max@vozeler.com>, Arnd Bergmann <arnd@arndb.de>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbip: handle length at sysfs show() functions
References: <4DE5CA9F.6010303@freemail.hu> <20110607213418.GB11102@kroah.com> <4DEF0822.7070500@freemail.hu> <20110608160931.GB21645@kroah.com> <4DEFE938.70408@freemail.hu> <20110608221655.GA27576@kroah.com> <BANLkTikokYys2srX3+5r+fkdaaX5V2zxUg@mail.gmail.com> <20110629024528.GA37164@haskell.muteddisk.com>
In-Reply-To: <20110629024528.GA37164@haskell.muteddisk.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Original: 94.21.97.208
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

matt mooney írta:
> On 18:28 Mon 27 Jun     , David Chang wrote:
>> Hi,
>>
>> 2011/6/9 Greg KH <greg@kroah.com>
>>
>>> On Wed, Jun 08, 2011 at 11:27:20PM +0200, N?meth M?rton wrote:
>>>>> Ick, I doubt it as there are lots of tools that parse that file
>>> already.
>>>> usbip is still part of the staging directory. In dmesg the following
>>> appear:
>>>> | usbip_common_mod: module is from the staging directory, the quality is
>>> unknown, you have been warned.
>>>> | usbip_common_mod: usbip common driver1.0
>>>> | vhci_hcd: module is from the staging directory, the quality is unknown,
>>> you have been warned.
>>>> so this means that usbip is a work-in-progress, it might be changed
>>> anytime. On
>>>> the other hand we can do this nice way: a new entry in
>>>  Documentation/feature-removal-schedule.txt
>>>> for /sys/devices/platform/vhci_hcd/status file removal, let's say it will
>>> be
>>>> removed before the usbip goes to mainline. In parallel the new interface
>>>> can be developed.
>>> Or we can just fix it properly, as we have the userspace tools in the
>>> kernel now as well, and the interface is obviously broken.  That's what
>>> being in the staging tree allows us to do.
>>>
>>>
>>>
>>>> But yes, you are correct, this should not be in sysfs at all.
>>>>> What's the use for this file?  Who uses it?  Is it just debugging
>>>>> output?  Information for people to gaze at if they feel like it?
>>>>> Something else?
>>>> Based on the user space source code at drivers/staging/usbip/userspace/
>>>> I can identify the following usages:
>>>>
>>>> libsrc/vhci_driver.c::get_nports():
>>>>  - finding out how many ports the VHCI has
>>> Is that really necessary as they are just "virtual" ports :)
>>> We can put that in a single sysfs file if needed.
>>>
>>>> libsrc/vhci_driver.c::parse_status():
>>>>  - VHCI port number to identify virtual ports
>>>>  - fetching the status of each VHCI ports whether it is
>>>>      - vdev does not connect a remote device: (status = VDEV_ST_NULL =
>>> 4):
>>>>        "Port Available"
>>>>      - vdev is used, but the USB address is not assigned yet (status =
>>>>        VDEV_ST_NOTASSIGNED = 5): "Port Initializing"
>>>>      - used (status = VDEV_ST_USED = 6): "Port in Use"
>>>>      - error (VDEV_ST_ERROR = 7): "Port Error"
>>>>  - the speed can be unknown/low/full/high/variable
>>>>  - it looks like the bus column was merged with the device column but I
>>>>    currently cannot find when
>>>>  - the device ID is splited to the upper 16bits: bus number, and lower
>>>>    16bits: device number
>>>>  - based on local_busid the usb device file can be found in /sys using
>>>>    sysfs_open_device()
>>> All of those can be placed in individual files under the different port
>>> directories, so we should be fine.
>>>
>> I would like to help on this. :)
>>
>> And I just want to make sure that I understand your discussion.
>>
>> 1. remove current port status table file (
>> /sys/devices/platform/vhci_hcd/status )
>> 2. create each port in path "/sys/devices/platform/vhci-hcd" as a directory
>> ( /sys/devices/platform/vhci_hcd/ports/[0][0-7] )
>> 3. put the port info/status files into each port directory (
>> /sys/devices/platform/vhci_hcd/ports/*/status )
>>
>> Any suggestions are welcome, thanks!
>>
> 
> I think it seems like ../ports/.. is unnecessary. We should use
> ../vhci_hcd/*-*/status as suggested by Nemeth. I do believe that we will
> probably need to encode the vhci-hcd port number in there somewhere to allow
> remote devices on different machines but same busid to be imported.
> 
> Nemeth are you already working on this?

No, I'm not.

> I need to add the `usbip port' command. I will add a template with some basic
> functionality but will wait on the actual port access.
> 
> -mfm
> 
>> Regards,
>> David Chang
>>
>>
>>>> Note that the socket parameter is only printed out as a debug
>>> information: it
>>>> is not used anywhere.
>>>>
>>>> Maybe most of the file content is redundant, because:
>>>>
>>>>  - we have /sys/bus/usb/devices/usb*/maxchild which is "number of ports
>>> if hub"
>>>>    according to linux/usb.h:410 ;
>>> Yes.
>>>
>>>>  - we have /sys/bus/usb/devices/*-*/speed to identify the device speed;
>>> Yes.
>>>
>>>>  - We have already bus number at /sys/bus/usb/devices/usb*/busnum or at
>>>>    /sys/bus/usb/devices/*-*/busnum ;
>>> Yes.
>>>
>>>>  - we also have /sys/bus/usb/devices/*-*/devnum ;
>>>>  - it is possbile to collect all the devices from
>>> /sys/bus/usb/devices/*-*
>>>>    filtering to the first number to /sys/bus/usb/devices/usb*/busnum .
>>>>
>>>> The only thing which is special for VHCI is the status for each port:
>>>> DEV_ST_NULL/VDEV_ST_NOTASSIGNED/VDEV_ST_USED/VDEV_ST_ERROR .
>>> So we add a status file and we are set.
>>>
>>> Anyone care to send patches to fix this all up?
>>>
>>> thanks,
>>>
>>> greg k-h
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
> 
> 

