Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945956Ab2JaSZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:25:03 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:48188 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758486Ab2JaSZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:25:00 -0400
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121031180935.GL12739@atomide.com>
Date: Wed, 31 Oct 2012 20:24:55 +0200
Cc: linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, "Cousson, Benoit" <b-cousson@ti.com>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Transfer-Encoding: 7bit
Message-Id: <80C42CBA-1BA0-4B02-A13F-F1E74FA796F5@antoniou-consulting.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com> <20121031175219.GH12739@atomide.com> <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com> <20121031180935.GL12739@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 31, 2012, at 8:09 PM, Tony Lindgren wrote:

> * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 11:05]:
>> Hi Tony,
>> 
>> On Oct 31, 2012, at 7:52 PM, Tony Lindgren wrote:
>> 
>>> * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 10:26]:
>>>> It is painless to move the adapter DT devices to arch/arm/mach-omap2
>>>> 
>>>> However I got bit by the __init at omap_build_device family functions.
>>>> If you don't remove it, crashes every time you instantiate a device
>>>> at runtime, or you load the cape driver as a module.
>>> 
>>> Hmm I think you misunderstood me. You only need to create the
>>> platform_device under arch/arm/mach-omap2. The device creation
>>> happens only at __init, so omap_build_device can stay as __init.
>>> The driver itself should be under drivers.
>>> 
>>> But is this bus on non-device-tree omaps? If not, just make it
>>> device tree only.
>>> 
>> 
>> I'm afraid that's not the case. The whole notion of capebus is that
>> instantiation of the devices doesn't just happen early at the boot
>> sequence.
>> 
>> It is perfectly valid for a cape to be instantiated via loading
>> a module, or by making an override by writing a sysfs file.
>> 
>> When having the __init there, the function has been long removed
>> and you get a crash by calling into the weeds.
>> 
>> So the sequence is:
>> 
>> <early boot>       Register the adapter driver.
> 
> OK this is always there for the hardware, and done during
> the __init and this one should have an omap_device..
> 

It is there at this point in time. The __init section
will go away after the boot is complete.

So you have this (as an example da8xx-dt):

1. During the boot sequence (postcore_initcall) da8xx_dt_init()
   is called. It registers the platform device driver (da8xx_dt_driver).
   The probe method is _not_ called yet since a matching device is
   _not_ yet in the DT. The matching device is found in a number of
   cape definitions but none have been activated.

2. capebus probes the capes and enumerates using the EEPROM header
   (for the beaglebone case). But a matching cape driver is not yet
   been loaded.

3. At this point booting ends, and the __init sections are discarded.

4. User space starts and insmod's the cape driver.

5. Capebus now has match and calls the cape driver's probe method.

6. Cape driver, locates matching da8xx_dt in the cape DT definition,
   and eventuall will call device_add. device_add will eventually
   call da8xx-dt's probe method.

7. da8xx-dt probe method will retrieve the hwmod (all OK) and it
   will call omap_device_build (which it is in an __init section)
   and is now freed.

8. Crash.
 

>> <user>             insmod bone-geiger-cape
>> <cape-is-matched>  call omap_build_device
>> 
>> Please look into the capebus patches for the details. 
> 
> ..but it seems that the devices connected to capebus should
> not have anything to do with omap_device and hwmod?
> 
> They should only need to use capebus, just like USB devices
> use the USB bus and are registered as USB devices.
> 
> Anyways, please sort it out with Benoit, Kevin and Paul,
> I've added them to cc. Maybe I'm missing something here.
> 
> Regards,
> 
> Tony


Regards

-- Pantelis

