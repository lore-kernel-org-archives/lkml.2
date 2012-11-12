Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2KLR3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:29:08 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53983 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2KLR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:29:06 -0500
Message-ID: <50A131DD.8020201@wwwdotorg.org>
Date: Mon, 12 Nov 2012 10:29:01 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <C3971D11-2BAC-4B58-AF8D-987FF8FFF678@antoniou-consulting.com> <50A128AF.1010803@wwwdotorg.org> <7C181180-2FE7-4EE4-BB5A-D7A1ACEC4244@antoniou-consulting.com> <50A12D9D.5030300@wwwdotorg.org> <F7FF2B16-6880-4D64-A630-6D22DCC695BD@antoniou-consulting.com>
In-Reply-To: <F7FF2B16-6880-4D64-A630-6D22DCC695BD@antoniou-consulting.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 10:19 AM, Pantelis Antoniou wrote:
> Hi Stephen,
> 
> On Nov 12, 2012, at 7:10 PM, Stephen Warren wrote:
> 
>> On 11/12/2012 10:00 AM, Pantelis Antoniou wrote:
>>> Hi Stephen,
>>>
>>> On Nov 12, 2012, at 6:49 PM, Stephen Warren wrote:
>>>
>>>> On 11/12/2012 04:23 AM, Pantelis Antoniou wrote:
>>>>> Hi Grant,
>>>>>
>>>>> Sorry for the late comments, travelling...
>>>>>
>>>>> On Nov 9, 2012, at 6:28 PM, Grant Likely wrote:
>>>> ...
>>>>>> *with the caveat that not all types of changes are a good idea and we
>>>>>> may disallow. For example, is changing properties in existing nodes a
>>>>>> good idea?
>>>>>
>>>>> Yes, changing properties is something that we need. One such change is
>>>>> the change of the bus controller 'status' properties to enabled upon
>>>>> insertion of a child device node, and change back to 'on-demand' when
>>>>> all the child device nodes are gone.
>>>>
>>>> Do we actually need to do that?
>>>>
>>>> From the base-board perspective, consider an SoC's I2C channel that is
>>>> routed to the child board connector. The routing to the connector is
>>>> always present on the base board. Only the presence (or lack thereof) of
>>>> devices on that I2C bus is influenced by whether a child board is
>>>> connected or not, and the design of the child board. Therefore, wouldn't
>>>> it make sense for the base board to always enable the I2C controller?
>>>>
>>>> That would make it easier for someone to hook up a couple wires to the
>>>> I2C pins and use utilities such as i2cget/set to communicate with it,
>>>> without going through the whole process of creating a DT to represent
>>>> the device. This could speed up simple hacking/prototyping and allow it
>>>> to proceed in a less structured way.
>>>
>>> Unfortunately that doesn't work for the beaglebone (am355x) and a large
>>> number of general purpose SoCs.
>>>
>>> What is different between general purpose SoCs and vertical market SoCs
>>> (i.e. OMAP) is that the design of the the latter is for devices where
>>> pretty much all the interfaces are expected to be active at the same time.
>>>
>>> General purpose SoCs put more peripherals in the SoC, but due to packaging
>>> considerations (and price), the peripheral pins are highly muxed.
>>>
>>> So the i2c bus pins are shared with the LCD controller are shared with the
>>> analog input and so on.
>>>
>>> It is impossible (and on top of that really dangerous) to enable peripheral
>>> blocks without knowing what's connected on the other side.
>>>
>>> In a nutshell, for the bone and similar devices, probing with the devices
>>> enabled doesn't work.
>>
>> I think this can be solved by deferring the pinmux to the .dts for the
>> child board. Presumably the I2C controller node can be enabled just
>> fine, but the I2C signals not actually routed out to any pins on the SoC
>> until the specific pinmux configuration is loaded.
>>
> 
> Well, I2C is just an example; same thing happens with SPI, LCD, audio, etc.
> 
> So you'll end up hacking the device drivers to handle a weird state that
> basically means 'don't activate until I tell you to go'. It is simpler
> just not to create the device.
> 
>> But your explanation still feels a little odd; is it really true on the
>> BeagleBone, you can either use LCD for graphics /or/ you can use the I2C
>> controller to communicate with a cape? I certainly fully understand that
>> from a SoC's perspective (and soc.dtsi perspective) you can't just
>> enable everything due to pinmux constraints, but it seems that once you
>> get to the level of a particular board design, the designer has made
>> those trade-offs and so you know which specific combination is to be
>> selected.
> 
> There are multiple I2C busses, multiple SPI buses, multiple options to
> connect something that produces audio, and so on. It is not odd at the least
> for the kind of market these chips are for.
> 
> Even TI doesn't know exactly the kind of applications these devices will be 
> used for. The chip is there to provide connection option at a (cheap) price
> point.
> 
> Think of a swiss-army knife with some tools that can be used at the
> same time, and some that can't.

Yes, I fully understand the flexibility of the SoC; the NVIDIA Tegra SoC
I maintain has exactly the same kind of flexibility.

However, I'm still thining that presumably the pins that could be used
for hypothetical example as any of (a) LCD, (b) I2C controller 2, (c)
UART 3 have been routed to the cape-bus connector specifically for the
purpose of e.g. I2C controller 2, and hence their usage has been locked in.

Is that not the case? Is it instead true that some SoC pins are routed
to both an LCD connector /and/ the cape-bus connector so the board
itself has a usage conflict, or is it true that the cape-bus connector
is in fact just a set of 100 "random" pins each with no specific
pre-defined purpose, and it's up to the cape designer to pick the SoC's
pinmux configuration rather than the base board designer? That would
make the cape-bus pinout specific to the BeagleBone or the specific SoC
on the board, which if IIUC is something very different to the Arduino
shield pinout design, where each pin on the connector is designated for
a specific purpose, and hence arbitrary different SoCs could (and do)
host the same connector design without needing the same pinmux HW
design, which would obviously be impossible.
