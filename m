Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724Ab2JaUMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:12:52 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:58259 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759725Ab2JaUMu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:12:50 -0400
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <50918223.6080003@ti.com>
Date: Wed, 31 Oct 2012 22:12:44 +0200
Cc: Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com> <20121031175219.GH12739@atomide.com> <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com> <20121031180935.GL12739@atomide.com> <50918223.6080003@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Oct 31, 2012, at 9:55 PM, Benoit Cousson wrote:

> Hi Panto,
> 
> On 10/31/2012 07:09 PM, Tony Lindgren wrote:
>> * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 11:05]:
>>> Hi Tony,
>>> 
>>> On Oct 31, 2012, at 7:52 PM, Tony Lindgren wrote:
>>> 
>>>> * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 10:26]:
>>>>> It is painless to move the adapter DT devices to arch/arm/mach-omap2
>>>>> 
>>>>> However I got bit by the __init at omap_build_device family functions.
>>>>> If you don't remove it, crashes every time you instantiate a device
>>>>> at runtime, or you load the cape driver as a module.
>>>> 
>>>> Hmm I think you misunderstood me. You only need to create the
>>>> platform_device under arch/arm/mach-omap2. The device creation
>>>> happens only at __init, so omap_build_device can stay as __init.
>>>> The driver itself should be under drivers.
>>>> 
>>>> But is this bus on non-device-tree omaps? If not, just make it
>>>> device tree only.
>>>> 
>>> 
>>> I'm afraid that's not the case. The whole notion of capebus is that
>>> instantiation of the devices doesn't just happen early at the boot
>>> sequence.
>>> 
>>> It is perfectly valid for a cape to be instantiated via loading
>>> a module, or by making an override by writing a sysfs file.
>>> 
>>> When having the __init there, the function has been long removed
>>> and you get a crash by calling into the weeds.
>>> 
>>> So the sequence is:
>>> 
>>> <early boot>       Register the adapter driver.
>> 
>> OK this is always there for the hardware, and done during
>> the __init and this one should have an omap_device..
>> 
>>> <user>             insmod bone-geiger-cape
>>> <cape-is-matched>  call omap_build_device
>>> 
>>> Please look into the capebus patches for the details. 
>> 
>> ..but it seems that the devices connected to capebus should
>> not have anything to do with omap_device and hwmod?
> 
> 
> Yeah, I do agree. I'm confused as well. Only OMAP IPs under PRCM control
> could have an hwmod and thus must be handled by an omap_device.
> 
> Any devices that is created later cannot be omap_device. The DT core
> will create regular platform_device for them.
> 
> Since cape is an external board, it should have nothing to do with
> omap_device.
> 
> Looking at your patch:
> da8xx-dt: Create da8xx DT adapter device
> 
> I understand why you do that, but in fact that patch does not make sense
> to me :-(
> 
> Why do you have to create an omap_device from the driver probe?
> 

The problem is that capes are not external boards in the normal sense
as a PCI board is. In the PCI case the hardware that implements the 
desired functionality is on the PCI board, while in the cape case the
hardware module is in the SoC. The cape most of the times is quite
simple and contains passive components, leds or some kind of I2C/SPI devices.

In the da8xx case it contains only the minimum hardware required for 
interfacing to the required display type, be it an LCD or a DVI or something
other.

You can't instantiate the omap_device early in the boot process like it was done up to 
now in the board file. You can only do that later in the boot process (for built-in 
cape drivers), or even after user-space has booted and the matching cape driver module
has been loaded.

So this is a use case that hasn't been encountered yet I'm afraid, but it is a valid
use case.

I don't see what the big deal is about to be honest. The omap device is safely created
in the da8xx-dt adapter's probe method, and everything seems to work.

If there are any gotcha's or problems with this approach I think can be overcome.

> 
> Regards,
> Benoit
> 

Regards

-- Pantelis


