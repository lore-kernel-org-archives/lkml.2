Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935416Ab2KAMAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:00:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45242 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2KAMAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:00:21 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <50925C49.7060004@ti.com>
Date: Thu, 1 Nov 2012 13:00:21 +0100
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>, <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <CBDE21C5-1980-4BDC-9153-7653A07D0024@dominion.thruhere.net>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com> <20121031175219.GH12739@atomide.com> <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com> <20121031180935.GL12739@atomide.com> <50918223.6080003@ti.com> <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com> <20121031212639.GQ12739@atomide.com> <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com> <20121031221402.GA29490@arwen.pp.htv.fi> <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com> <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com> <50925C49.7060004@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
X-Mailer: Apple Mail (2.1498)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tl;dr: please suggest an actual solution that allows plug&play when plugging in multiple capes and applying power after that. Preferably one that doesn't pass the buck to u-boot.

Op 1 nov. 2012, om 12:26 heeft "Cousson, Benoit" <b-cousson@ti.com> het volgende geschreven:

> Hi Panto,
> 
> On 11/1/2012 11:39 AM, Pantelis Antoniou wrote:
>> Hi Benoit,
>> 
>> On Nov 1, 2012, at 12:23 PM, Cousson, Benoit wrote:
>> 
>>> On 11/1/2012 8:02 AM, Pantelis Antoniou wrote:
>>>> Hi Felibe,
>>>> 
>>>> On Nov 1, 2012, at 12:14 AM, Felipe Balbi wrote:
>>>> 
>>>>> Hi,
>>>>> 
>>>>> On Wed, Oct 31, 2012 at 11:36:25PM +0200, Pantelis Antoniou wrote:
>>>>>>> * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 13:14]:
>>>>>>>> On Oct 31, 2012, at 9:55 PM, Benoit Cousson wrote:
>>>>>>>>> 
>>>>>>>>> Yeah, I do agree. I'm confused as well. Only OMAP IPs under PRCM control
>>>>>>>>> could have an hwmod and thus must be handled by an omap_device.
>>>>>>>>> 
>>>>>>>>> Any devices that is created later cannot be omap_device. The DT core
>>>>>>>>> will create regular platform_device for them.
>>>>>>>>> 
>>>>>>>>> Since cape is an external board, it should have nothing to do with
>>>>>>>>> omap_device.
>>>>>>>>> 
>>>>>>>>> Looking at your patch:
>>>>>>>>> da8xx-dt: Create da8xx DT adapter device
>>>>>>>>> 
>>>>>>>>> I understand why you do that, but in fact that patch does not make sense
>>>>>>>>> to me :-(
>>>>>>>>> 
>>>>>>>>> Why do you have to create an omap_device from the driver probe?
>>>>>>>>> 
>>>>>>>> 
>>>>>>>> The problem is that capes are not external boards in the normal sense
>>>>>>>> as a PCI board is. In the PCI case the hardware that implements the
>>>>>>>> desired functionality is on the PCI board, while in the cape case the
>>>>>>>> hardware module is in the SoC. The cape most of the times is quite
>>>>>>>> simple and contains passive components, leds or some kind of I2C/SPI devices.
>>>>>>> 
>>>>>>> Ah now I see, you're talking about the beaglebone extension
>>>>>>> boards :)
>>>>>>> 
>>>>>>> The way to deal with those properly is to just edit the
>>>>>>> board .dts entry to include omap-beaglebone-cape-xyz.dtsi
>>>>>>> whatever.
>>>>>>> 
>>>>>> 
>>>>>> That is what is being done...
>>>>>> This is the fallout.
>>>>>> 
>>>>>>>> You can't instantiate the omap_device early in the boot process like it was done up to
>>>>>>>> now in the board file. You can only do that later in the boot process (for built-in
>>>>>>>> cape drivers), or even after user-space has booted and the matching cape driver module
>>>>>>>> has been loaded.
>>>>>>> 
>>>>>>> Yes you can, just edit the .dts file for the extension
>>>>>>> board you have connected. This stuff should be DT
>>>>>>> only for sure, let's not even start adding platform_data
>>>>>>> entries for that.
>>>>>>> 
>>>>>>> The omap_device entries for the omap internal devices
>>>>>>> will be created automatically during startup based on the
>>>>>>> .dts. Note that you can set status = "disabled" for the
>>>>>>> omap internal devices in the .dts file, the devices are
>>>>>>> there in the hardware.
>>>>>>> 
>>>>>>> If you are sure the extension boards are safely hot
>>>>>>> pluggable, then all you need is some interface to enable
>>>>>>> and disable devices after booting. But that should be
>>>>>>> done in Linux generic way.
>>>>>>> 
>>>>>>> So we should not export any omap_hwmod or omap_device
>>>>>>> things, and want to keep it __init only, and local to
>>>>>>> arch/arm/mach-omap2.
>>>>>>> 
>>>>>> 
>>>>>> I disagree. This is not something that is handled by just
>>>>>> editing the dts. The way it is handled, is in the Linux
>>>>>> generic way, we have a proper bus, and the drivers as compiled
>>>>>> as standalone file.
>>>>> 
>>>>> when you have an actual bus, that'd be correct.
>>>> 
>>>> What do you think capebus is? It is an actual bus that allows you
>>>> to do so.
>>>> 
>>>>> 
>>>>>> We're hitting a use case that wasn't there in omap until now.
>>>>>> 
>>>>>> There a a whole bunch of conflicting capes. There's no
>>>>>> way to instantiate them together. They must be instantiated
>>>>>> only after their EEPROMs are read and they are matched
>>>>>> to their corresponding cape drivers.
>>>>> 
>>>>> why this requirement of instantiating them only after reading EEPROMs ?
>>>>> 
>>>>> It's unnecessary to add that requirement, just do what Tony said
>>>>> (include my-awesome-cape.dtsi to bone.dts) and all i2c/spi devices
>>>>> should be created automatically.
>>>>> 
>>>>> The thing is that there is no such thing as a cape-device. The cape is
>>>>> just a collection of I2C, 1-wire and SPI devices anyway. What we should
>>>>> instantiate is bmp085, tls2550, sht21, instead of instantiating
>>>>> beagle-bone-weather-cape.
>>>>> 
>>>>> What's the problem in just instantiating all of those from bone.dts ?
>>>>> Expose the EEPROMs to userland so whatever SW you guys have running on
>>>>> the bone can figure out what features to expose to the SDK which the
>>>>> user sees, but the kernel doesn't need to know that there is a
>>>>> weather-cape attached to the bone.
>>>>> 
>>>> 
>>>> The I2C/SPI devices are not a problem at all.
>>>> 
>>>> Let me try to explain what the problem is, and why it all this
>>>> is needed.
>>>> 
>>>> First of all, capes may be relatively simple boards, which may function
>>>> as a generic device - like the generic capes. They might not necessarily
>>>> be simple. Some capes, for example the geiger cape have a number of
>>>> components that perform a specific task; in this instance the driving
>>>> circuit of the geiger tube and the event detector input. Other capes
>>>> that are being designed now are even more complex, i.e. there's a
>>>> radar cape, an fpga cape and so on. So for these kind of boards
>>>> you will need a specific driver. That driver will probably use some
>>>> generic-cape bits (like gpios, pwms, keys what-ever).
>>>> But it will put them to use in the custom in-kernel driver in it's own
>>>> way. You can't put that task to user-space, if it's ever slightly complex.
>>>> 
>>>> So for really simple capes, after considerable pain you might, just
>>>> might, dump the problem to user-space and try to make it work.
>>>> People have tried that and it's a total pain. There is no way that this will
>>>> work with anything more complex than a generic cape.
>>>> 
>>>> Then there's the out of the box experience problem.
>>>> 
>>>> What a customer that buys one of these boards along with a number of
>>>> capes wants is to plug them, and have them work. You cannot have
>>>> the DTS file activating all the drivers for each possible cape since
>>>> they conflict; the pins that one SPI bus that one cape uses might be a
>>>> PWM output for another, and so on.
>>>> 
>>>> Asking the customer to edit the distro supplied kernel's dts and recompiling,
>>>> while figuring out how to solve conflicts is not going to fly.
>>> 
>>> Well you do not have to rebuild the kernel if you just want to update the DTS.
>>> The way DT is done, the best you can do is to rely on the bootloader in your case to select the proper DTB. You should try to merge dynamically AMxx + beaglebone + capeXXX based on some EEPROM id.
>>> 
>> 
>> That is what the capebus does. It inserts
> 
> It inserts what?
> 
>>> FWIW, we do have a similar, but simpler, problem with the beagle / beagle-xm and panda / panda-es. But for the moment we are just using a different DTS for each board.
>> 
>> A different DTS for each board combination... There alot more capes for the bone that they are for the beagle & the panda.
>> And more are going to come, but not necessarily from people that have any connection to TI or CCO.
> 
> Sure, but my point is that your solution will not solve our problem :-)
> This is a generic problem that you address with a very custom / specific approach.
> 
>> You still haven't described how I could solve the issue of conflicting capes using a single DTS.
> 
> Well I don't have the solution otherwise I will have done it already :-)
> My point is that the solution has to be in the DT core if not in the bootloader.

<snarky comment>So when we at beagleboard.org handled the beagleboard and beagleboard xM expansionboards in the bootloader (detection, muxing, etc) we were told it was wrong and we should handle it in the kernel and if we waited a bit, DT would solve everything. And now that we actually handle it in the kernel you are saying that it is wrong and we should handle it in the bootloader and that DT won't solve everything. I guess someone will now tell us that uEFI will fix everything.</snarky comment>

Apart from that, you and others still fail to tell us how you want to handle a user (or customer) that buys a beaglebone, an LCD cape, a weatherstation cape and a geiger counter cape and plugs those together and powers them on. With the evil TI vendor tree and extra patches the boardfile reads the eeproms and tries its best to instantiate all the platform data. One of the capes won't have working LEDs since appending to the leds-gpio struct is pretty much impossible in this situation. But it gets a picture on the screen, blinks LEDs and does largely what the user expects.

With capebus we get:

1) da8xx-fb which lacks DT bindingsp[1] receives plaftorm data to match the LCD
2) the i2c sensors on the weathercape are registered
3) the one-wire bus on the weathercape gets registered
4) the LEDs on the lcd cape get registered5
5) the LED on the geigercape gets registered and adds a custom trigger
6) the ADC, which again, lacks DT bindings[2], receives plaftorm data and a custom IIO binding
7) pinctrl sets the pinmuxes for the above

In other words: plug & play, even for devices with drivers that are still lacking DT support. 

Now please explain to me why you think it's such an awesome idea that the users will need to find the right dtsi files (multiple revisions of the lcd cape exist), include them in the dts, run dtc, add a few missing semicolons, run dtc again, copy it over to /boot and reboot to have a change of making it work?
I know you can't escape that for new or custom capes, but I do want all the capes my company assembles work out of the box. (Cross)compiling a kernel is a bridge too far for 95% of the intended audience.

With capebus most capes can be supported by editing the DTS, your bootloader proposal involves updating u-boot for every new cape as well. That is downright scary. The RMA department will get flooded.

More importantly: capebus is generic enough to work on beagleboard, beagleboard xm, panda, panda es and even raspberry-pi. Basically on any DT capable platform.

Koen

[1] Patches for DT bindings were sent for that last week
[2] No DT bindings, contacting the author of the ADC support: *crickets*