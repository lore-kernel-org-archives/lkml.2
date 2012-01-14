Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab2ANR6G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 12:58:06 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42334 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab2ANR6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 12:58:04 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D1FAB@HQMAIL01.nvidia.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
	<1324402840-32451-3-git-send-email-b29396@freescale.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
	<CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC605788508AC65@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF177EE3A76A@HQMAIL01.nvidia.com>
	<CAA+hA=RCmctmQJU4-k7YhzQDMi8KuyisBqOFhuMd3RV4_E=gCA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17801D1FAB@HQMAIL01.nvidia.com>
Date: Sun, 15 Jan 2012 01:58:03 +0800
Message-ID: <CAA+hA=TKNS+rYZ34Ev9ebRF12CEfBQQY71E+GUKNJoWHZTgLWw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux mappings
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 2:33 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Dong Aisheng wrote at Friday, January 13, 2012 10:12 AM:
>> On Thu, Jan 12, 2012 at 4:17 AM, Stephen Warren <swarren@nvidia.com> wrote:
>> ...
>> >> To keep consistency as the currently design of pinctrl subsystem and also meet
>> >> the dt design philosophy, we still do not introduce a pinmux map in dt.
>> >> Instead, we choose to scan all the device node with a 'pinmux' phandle to construct
>> >> a pinmux map table before register the pin controller device(here we may also scan
>> >> the hog_on_boot node) and I guess it's easy to do that.
>> > ...
>> >> (Without scan the device node to construct the pinmux map table, we can only get the map
>> >> Information when we run the pinmux_get.
>> >> See: https://lkml.org/lkml/2012/1/5/153
>> >> So no pinmux map table exists and we surely do not want to see that the sysfs exporting
>> >> pinmux map information works in dt but unwork in non-dt)
>> >
>> > Hmmm. I'm not sure that the pinctrl code should actively scan all nodes
>> > in the device tree for pin mux properties. That seems a little invasive;
>> > how does pinctrl know which nodes it really should be looking at, and
>> > which nodes are random internal parts of some device's custom binding?
>> >
>> > Personally, I think I'd be OK with the sysfs pinctrl map file only
>> > containing the map entries for devices that had used the pinctrl API,
>> > and hence only parsing the pinmux properties in pinmux_get().
>> >
>> > However, we could perhaps do better by registering a bus notifier, and
>> > pro-actively parsing the top-level DT node (if there is one) for every
>> > device that is created. That way, the mapping would be parsed as soon
>> > as the device was created (or perhaps after probe?).
>>
>> After refer to usb bus notifier, usb core will register a bus notifier.
>> When a new usb bus is registered, it will notify the usb core for a
>> new bus added.
>>
>> So i guess you mean pinctrl core provides a notifier to handle the map
>> creation when new map is found during parsing each device node, right?
>
> Yes.
>
>> But it seems parsing of device node and creation of device is at the very early
>> stage when call of_platform_populate in .init_machine code and pinctrl subsystem
>> may still have not change to run to register a bus notifier.
>
> That's possible. There are some early initcalls that might work out
> fine for this,
Ok, looks .init_machine is the level of ARCH_INIT, will try a earlier one.
and we may add that init function in pinctrl core if it's reasonable.

> but...
but what?

>
>> And i'm not sure it's the right place for of_platform.c to handle
>> pinmux things when create new devices.
>
> So of_device_alloc(), which is called by of_platform_populate() for each
> device, already parses basic DT content such as reg and interrupts, and
> converts them to Linux resources. I'd consider parsing any pinmux properties
> and registering them with the pinctrl subsystem to be of a similar nature,
> so adding some code to of_device_alloc() that calls a core pinmux function
> to parse the DT node seems reasonable to me.
>
It's not perfect to me since pinmux map looks not the pure hw
conception like reg/int.
but i wonder if we can find a better way, (scanning?)

>> I wonder it may not work for pinmux map case.
>> If pinctrl core does not provide notifier, who else can be the right
>> one to privide it?
>>
>> > The only case this
>> > might not cover is DT nodes for which the kernel doesn't actually have
>> > a driver, and hence no device is created.
>>
>> Per my understanding, the device creation should be independent on the driver.
>> I don't know why no device is created if not have a driver.
>> Did i miss something?
>
> Yes, I think the device gets created irrespective, so this isn't actually a problem
>
> --
> nvpublic
>
