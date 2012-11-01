Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397Ab2KAL0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:26:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49079 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab2KAL0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:26:07 -0400
Message-ID: <50925C49.7060004@ti.com>
Date: Thu, 1 Nov 2012 12:26:01 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com> <20121031175219.GH12739@atomide.com> <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com> <20121031180935.GL12739@atomide.com> <50918223.6080003@ti.com> <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com> <20121031212639.GQ12739@atomide.com> <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com> <20121031221402.GA29490@arwen.pp.htv.fi> <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com> <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
In-Reply-To: <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Panto,

On 11/1/2012 11:39 AM, Pantelis Antoniou wrote:
> Hi Benoit,
>
> On Nov 1, 2012, at 12:23 PM, Cousson, Benoit wrote:
>
>> On 11/1/2012 8:02 AM, Pantelis Antoniou wrote:
>>> Hi Felibe,
>>>
>>> On Nov 1, 2012, at 12:14 AM, Felipe Balbi wrote:
>>>
>>>> Hi,
>>>>
>>>> On Wed, Oct 31, 2012 at 11:36:25PM +0200, Pantelis Antoniou wrote:
>>>>>> * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 13:14]:
>>>>>>> On Oct 31, 2012, at 9:55 PM, Benoit Cousson wrote:
>>>>>>>>
>>>>>>>> Yeah, I do agree. I'm confused as well. Only OMAP IPs under PRCM control
>>>>>>>> could have an hwmod and thus must be handled by an omap_device.
>>>>>>>>
>>>>>>>> Any devices that is created later cannot be omap_device. The DT core
>>>>>>>> will create regular platform_device for them.
>>>>>>>>
>>>>>>>> Since cape is an external board, it should have nothing to do with
>>>>>>>> omap_device.
>>>>>>>>
>>>>>>>> Looking at your patch:
>>>>>>>> da8xx-dt: Create da8xx DT adapter device
>>>>>>>>
>>>>>>>> I understand why you do that, but in fact that patch does not make sense
>>>>>>>> to me :-(
>>>>>>>>
>>>>>>>> Why do you have to create an omap_device from the driver probe?
>>>>>>>>
>>>>>>>
>>>>>>> The problem is that capes are not external boards in the normal sense
>>>>>>> as a PCI board is. In the PCI case the hardware that implements the
>>>>>>> desired functionality is on the PCI board, while in the cape case the
>>>>>>> hardware module is in the SoC. The cape most of the times is quite
>>>>>>> simple and contains passive components, leds or some kind of I2C/SPI devices.
>>>>>>
>>>>>> Ah now I see, you're talking about the beaglebone extension
>>>>>> boards :)
>>>>>>
>>>>>> The way to deal with those properly is to just edit the
>>>>>> board .dts entry to include omap-beaglebone-cape-xyz.dtsi
>>>>>> whatever.
>>>>>>
>>>>>
>>>>> That is what is being done...
>>>>> This is the fallout.
>>>>>
>>>>>>> You can't instantiate the omap_device early in the boot process like it was done up to
>>>>>>> now in the board file. You can only do that later in the boot process (for built-in
>>>>>>> cape drivers), or even after user-space has booted and the matching cape driver module
>>>>>>> has been loaded.
>>>>>>
>>>>>> Yes you can, just edit the .dts file for the extension
>>>>>> board you have connected. This stuff should be DT
>>>>>> only for sure, let's not even start adding platform_data
>>>>>> entries for that.
>>>>>>
>>>>>> The omap_device entries for the omap internal devices
>>>>>> will be created automatically during startup based on the
>>>>>> .dts. Note that you can set status = "disabled" for the
>>>>>> omap internal devices in the .dts file, the devices are
>>>>>> there in the hardware.
>>>>>>
>>>>>> If you are sure the extension boards are safely hot
>>>>>> pluggable, then all you need is some interface to enable
>>>>>> and disable devices after booting. But that should be
>>>>>> done in Linux generic way.
>>>>>>
>>>>>> So we should not export any omap_hwmod or omap_device
>>>>>> things, and want to keep it __init only, and local to
>>>>>> arch/arm/mach-omap2.
>>>>>>
>>>>>
>>>>> I disagree. This is not something that is handled by just
>>>>> editing the dts. The way it is handled, is in the Linux
>>>>> generic way, we have a proper bus, and the drivers as compiled
>>>>> as standalone file.
>>>>
>>>> when you have an actual bus, that'd be correct.
>>>
>>> What do you think capebus is? It is an actual bus that allows you
>>> to do so.
>>>
>>>>
>>>>> We're hitting a use case that wasn't there in omap until now.
>>>>>
>>>>> There a a whole bunch of conflicting capes. There's no
>>>>> way to instantiate them together. They must be instantiated
>>>>> only after their EEPROMs are read and they are matched
>>>>> to their corresponding cape drivers.
>>>>
>>>> why this requirement of instantiating them only after reading EEPROMs ?
>>>>
>>>> It's unnecessary to add that requirement, just do what Tony said
>>>> (include my-awesome-cape.dtsi to bone.dts) and all i2c/spi devices
>>>> should be created automatically.
>>>>
>>>> The thing is that there is no such thing as a cape-device. The cape is
>>>> just a collection of I2C, 1-wire and SPI devices anyway. What we should
>>>> instantiate is bmp085, tls2550, sht21, instead of instantiating
>>>> beagle-bone-weather-cape.
>>>>
>>>> What's the problem in just instantiating all of those from bone.dts ?
>>>> Expose the EEPROMs to userland so whatever SW you guys have running on
>>>> the bone can figure out what features to expose to the SDK which the
>>>> user sees, but the kernel doesn't need to know that there is a
>>>> weather-cape attached to the bone.
>>>>
>>>
>>> The I2C/SPI devices are not a problem at all.
>>>
>>> Let me try to explain what the problem is, and why it all this
>>> is needed.
>>>
>>> First of all, capes may be relatively simple boards, which may function
>>> as a generic device - like the generic capes. They might not necessarily
>>> be simple. Some capes, for example the geiger cape have a number of
>>> components that perform a specific task; in this instance the driving
>>> circuit of the geiger tube and the event detector input. Other capes
>>> that are being designed now are even more complex, i.e. there's a
>>> radar cape, an fpga cape and so on. So for these kind of boards
>>> you will need a specific driver. That driver will probably use some
>>> generic-cape bits (like gpios, pwms, keys what-ever).
>>> But it will put them to use in the custom in-kernel driver in it's own
>>> way. You can't put that task to user-space, if it's ever slightly complex.
>>>
>>> So for really simple capes, after considerable pain you might, just
>>> might, dump the problem to user-space and try to make it work.
>>> People have tried that and it's a total pain. There is no way that this will
>>> work with anything more complex than a generic cape.
>>>
>>> Then there's the out of the box experience problem.
>>>
>>> What a customer that buys one of these boards along with a number of
>>> capes wants is to plug them, and have them work. You cannot have
>>> the DTS file activating all the drivers for each possible cape since
>>> they conflict; the pins that one SPI bus that one cape uses might be a
>>> PWM output for another, and so on.
>>>
>>> Asking the customer to edit the distro supplied kernel's dts and recompiling,
>>> while figuring out how to solve conflicts is not going to fly.
>>
>> Well you do not have to rebuild the kernel if you just want to update the DTS.
>> The way DT is done, the best you can do is to rely on the bootloader in your case to select the proper DTB. You should try to merge dynamically AMxx + beaglebone + capeXXX based on some EEPROM id.
>>
>
> That is what the capebus does. It inserts

It inserts what?

>> FWIW, we do have a similar, but simpler, problem with the beagle / beagle-xm and panda / panda-es. But for the moment we are just using a different DTS for each board.
>
> A different DTS for each board combination... There alot more capes for the bone that they are for the beagle & the panda.
> And more are going to come, but not necessarily from people that have any connection to TI or CCO.

Sure, but my point is that your solution will not solve our problem :-)
This is a generic problem that you address with a very custom / specific 
approach.

> You still haven't described how I could solve the issue of conflicting capes using a single DTS.

Well I don't have the solution otherwise I will have done it already :-)
My point is that the solution has to be in the DT core if not in the 
bootloader.
We can add some new binding to handle revision. And then we should be 
able during DT tree device creation to remove nodes that does not match 
the version criteria.

In the case of panda/beagle, some GPIO lines are used to identify the 
board version.

So we should be able to define some generic way to export revision and 
use that to select the proper nodes.

This is not necessarily different to what your are doing with your 
capebus. The point is to build a generic way / binding to do that properly.

>>> We have the versioning problem. All the standard capes go through
>>> a very fast evolution processes. So we now have 3 versions of a DVI cape,
>>> 2 of a small LCD cape and so on. We don't want to abandon the capes that
>>> are already sold and are out on the field, but we don't want to spend
>>> too much time hacking the driver to support all the different version.
>>> The version capability of capebus handles that; taking as an example the
>>> DVI cape in which the power down GPIO moved around:
>>>
>>>>         version@00A0 {
>>>>                  version = "00A0";
>>>>                  dvi {
>>>>                          compatible = "da8xx-dt";
>>>>                          pinctrl-names = "default";
>>>>                          pinctrl-0 = <&bone_dvi_cape_dvi_00A0_pins>;
>>>>                          ti,hwmods = "lcdc";
>>
>> That part is still weird to me. Assuming the lcdc is the Display controller, the DVI should be a child of the lcdc not the opposite.
>>
>
> At the time of this there are no DT bindings yet for the da8xx driver.

OK, but that does not answer my question...

I don't know this HW, but the LCD controller should be the parent in 
that case.

lcdc@48000000 {
	ti,hwmods = "lcdc";
	reg = <0x48000000>;

	dvi {
		disp-pll = <>;
               	panel-type = "1024x560000000768@60";
		powerdn-gpio = <&gpio2 7 0>;
	};
} ;

FWIW, there is some discussion about a generic panel fmwk / DT binding, 
so I'm not even sure it will look like that at the end.

>>>>                          disp-pll = <>;
>>>>                          panel-type = "1024x560000000768@60";
>>>>                          powerdn-gpio = <&gpio2 7 0>;
>>>>                  };
>>>>          };
>>>>
>>>>          version@00A1 {
>>>>                  version = "00A1", "01";
>>>>                  dvi {
>>>>                          compatible = "da8xx-dt";
>>>>                          pinctrl-names = "default";
>>>>                          pinctrl-0 = <&bone_dvi_cape_dvi_00A1_pins>;
>>>>                          ti,hwmods = "lcdc";
>>>>
>>>>                          disp-pll = <560000000>;
>>>>                          panel-type = "1024x768@60";
>>>>                          powerdn-gpio = <&gpio2 31 0>;
>>>>                  };
>>>>          };
>>>>
>>>>
>>>
>>> Finally, we have the target user-base problem. The users are all going to
>>> be hobbyists, persons that buy beaglebones as a step up from Arduino. They
>>> will want to hack their own kind of hardware; they might not even have
>>> an EEPROM in their custom boards. They need some kind of runtime selection
>>> of the cape they have defined, these is handled by the case of overrides.
>>>
>>> For example, the Adafruit 1.8 Display is pretty popular, but it's not a cape.
>>> You have to wire it yourself and connect it to the expansion header. Then
>>> there's two different kinds of the display. It also has a PWM input for
>>> backlight control.
>>>
>>> Making use of it is simple with capebus:
>>>
>>> # cd /sys/devices/capebus.10
>>> # echo "0:Adafruit 1.8 Cape" >slots
>>>
>>> And that's it. The disable spi & pwm device the display needs will
>>> be turned on, the pinmux it needs will be set, and the spi device
>>> that the display uses will be created.
>>>
>>> I have no clue how this can be simpler using any kind of user-space
>>> method. And no, you can't have this active in the DTS of the common
>>> kernel for all beaglebones.
>>>
>>>> &bone_adafruit_cape {
>>>>          board-name = "Adafruit 1.8 Cape";
>>>>
>>>>          backlight {
>>>>                  compatible      = "pwm-backlight";
>>>>                  pinctrl-names   = "default";
>>>>                  pinctrl-0       = <&pwm_bl_pins>;
>>>>
>>>>                  pwms = <&ehrpwm1 1 500000 0>;
>>>>                  pwm-names = "st7735fb";
>>>>                  brightness-levels = <0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36
>>>>                  default-brightness-level = <50>; /* index to the array above */
>>>>          };
>>>>
>>>>          spi1-devices {
>>>>                  compatible = "spi-dt";
>>>>
>>>>                  #address-cells = <1>;
>>>>                  #size-cells = <0>;
>>>>
>>>>                  parent = <&spi1>;
>>
>> Why do you need that? You seems to completely break the whole DT semantic with tons of customs bindings.
>>
>>  From the driver code, it looks like the cape bus is not a real bus at all. If this is just a connector, then the I2C devices will be children of the AM33xx I2C controller, but there is no intermediate HW in the middle.
>
> No it is not that way. One set of capes can be just simple connector capes. Other capes are full blown devices with their
> own drivers. What do you propose as a fix is for the complex kind of capes?

What does that mean?

If the HW is like that:

beaglebone -- AM33XX -- I2C bus -- connector -- I2C devices in the cape

The connector does not have do be represented in the DT since it is a 
dumb interface without any device / driver. At the end this is just an 
board with more devices.

What is a complex cape?

>>>>                  lcd@0 {
>>>>                          compatible = "adafruit,tft-lcd-1.8-red", "sitronix,st7735";
>>>>                          spi-max-frequency = <8000000>;
>>>>                          reg = <0>;
>>>>                          spi-cpol;
>>>>                          spi-cpha;
>>>>                          pinctrl-names = "default";
>>>>                          pinctrl-0 = <&lcd_pins>;
>>>>                          st7735-rst = <&gpio4 19 0>;
>>>>                          st7735-dc = <&gpio4 21 0>;
>>>>                  };
>>>>
>>>>          };
>>>> };
>>>>
>>
>> I guess there is no easy solution for that, but it looks to me that what you have to do is to make the DT creation dynamic in your case. Assuming you do not want to do that in the bootloader, you must do that pretty early during the boot process to end up with a full description of your DT tree before creating the devices.
>>
>
> Do it pretty early in the boot processes ended up with the am335xevm board file in the PSP tree.

Well, you have to put somewhere the data that will represent the HW. And 
you seem to do that anyway in am335x-bone-common.dtsi. So I'm not sure 
to get your point.

My point was to potentially use some smaller DTB: am335x-bone.dtb, 
geiger.dtb, capeXXX.dtb and create a mechanism to merge these DTB based 
on configuration in bootloader/ early kernel boot.

> The whole set of possible cape designs cannot be controlled, nor do we want to.
> We want to empower users to come up with their own designs without having to do any kernel/boot loader
> hacking.

Mmm, how can that be possible? They do have at least to write a driver 
for their cape and add some more DTS data, isn't it?

>> Each cape will have their own DTS and based on some board id you will fix the DT dynamically.
>>
>> My point is that the issue you are facing is a real limitation of DT, so you should fix the DT core and not workaround it by creating artificial bindings / drivers.
>>
>
> You still haven't described any mechanism to deal with all the use cases I described.
>
> DT can't and will not deal with the complexity that we're facing right now.
>
> This is a relatively clean way to fix it; we can actually ship a mainline kernel that works.

Sure, but that does not mean it cannot be done in a more generic / 
cleaner way.

Regards,
Benoit



