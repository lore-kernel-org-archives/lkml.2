Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2KGAy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 19:54:57 -0500
Received: from rs130.luxsci.com ([72.32.115.17]:56091 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab2KGAyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 19:54:55 -0500
Message-ID: <5099B150.7070808@firmworks.com>
Date: Tue, 06 Nov 2012 14:54:40 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org>
In-Reply-To: <50999145.2070306@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message qA70sg0J017767 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/2012 12:37 PM, Stephen Warren wrote:
> On 11/05/2012 01:40 PM, Grant Likely wrote:
>> Hey folks,
>>
>> As promised, here is my early draft to try and capture what device
>> tree overlays need to do and how to get there. Comments and
>> suggestions greatly appreciated.
> 
> Interesting. This just came up internally at NVIDIA within the last
> couple weeks, and was discussed on the U-Boot mailing list very recently
> too:
> 
> http://lists.denx.de/pipermail/u-boot/2012-October/thread.html#138227
> (it spills into the November archive too)
> 
>> For these cases it is proposed to implement an overlay feature for the
>> so that the initial device tree data can be modified by userspace at
> 
> I don't know if you're maintaining this as a document and taking patches
> to it, but if so:
> 
> "for the so" split across those two lines.
> 
>> Jane solves this problem by storing an FDT overlay for each cape in the
>> root filesystem. When the kernel detects that a cape is installed it
>> reads the cape's eeprom to identify it and uses request_firmware() to
>> obtain the appropriate overlay. Userspace passes the overlay to the
>> kernel in the normal way. If the cape doesn't have an eeprom, then the
>> kernel will still use firmware_request(), but userspace needs to already
>> know which cape is installed.
> 
> As mentioned by Pantelis, multiple versions of a board is also very
> common. We already have the following .dts files in the kernel where
> this applies, for the main board even:
> 
> arch/arm/boot/dts/tegra30-cardhu.dtsi
> arch/arm/boot/dts/tegra30-cardhu-a02.dts
> arch/arm/boot/dts/tegra30-cardhu-a04.dts
> 
>> Summary points:
> 
>>   - SHOULD reliably handle changes between different underlying overlays
>>     (ie. what happens to existing .dtb overly files if the structure of
>>     the dtb it is layered over changes. If not possible, then SHALL
>>     detect when the base tree doesn't match and refuse to apply the
>>     overlay.
> 
> Perhaps use (versioned) DT bindings to represent the interface between
> the two .dts files? See the links to the U-Boot mailing list discussions
> below?
> 
>> - What is the model for overlays?
>>   - Can an overlay modify existing properties?
>>   - Can an overlay add new properties to existing nodes?
>>   - Can an overlay delete existing nodes/properties?
> 
> This proposal is very oriented at an overlay-based approach. I'm not
> totally convinced that a pure overlay approach (as in how dtc does
> overlayed DT nodes) will be flexible enough, but would love to be
> persuaded. Again see below.


An overlay approach will not be powerful enough to solve the sorts of
problems that occur when a product goes into full production, becomes a
family, and starts to evolve.  Issues like second-source parts that
aren't quite compatible and need to be detected and reported,
board-stuff options for different customer profiles, speed grades of
parts that aren't properly probeable but instead need to be identified
by some subterfuge, the list of tedious issues goes on and on.

It's nice to pretend that the world fits into a few coherent simple
use cases, but 30 years of experience shipping computer product families
proves otherwise.  You need a programming language to solve the full
set of problems - which I why the device tree is designed so it can
be generated and modified by a program.

> 
>> It may be sufficient to solve it by making the phandle values less
>> volatile. Right now dtc generates phandles linearly. Generated phandles
>> could be overridden with explicit phandle properties, but it isn't a
>> fantastic solution. Perhaps generating the phandle from a hash of the
>> node name would be sufficient.
> 
> Node names don't have to be unique though right; perhaps hash the
> path-name instead of the node-name? But then, why not just reference by
> path name; similar to <{&/path/to/node}> rather than <&label>?
> 
>> This handles many of the use cases, but it assumes that an overlay is
>> board specific. If it ever is required to support multiple base boards
>> with a single overlay file then there is a problem. The .dtb overlays
>> generated in this manor cannot handle different phandles or nodes that
>> are in a different place. On the other hand, the overlay source files
>> should have no problem being compiled for multiple targets.
> 
> s/manor/manner/
> 
> I do rather suspect this use-case is quite common. NVIDIA certainly has
> a bunch of development boards with pluggable
> PMIC/audio/WiFi/display/..., and I believe there's some ability to
> re-use the pluggable components with a variety of base-boards.
> 
> Given people within NVIDIA started talking about this recently, I asked
> them to enumerate all the boards we have that support pluggable
> components, and how common it is that some boards support being plugged
> into different main boards. I don't know when that enumeration will
> complete (or even start) but hopefully I can provide some feedback on
> how common the use-case is for us once it's done.
> 
> My earlier thoughts on how to support this included explicit
> inter-board/-component connector objects in the .dts files that allow
> "renaming" of GPIOs, I2C buses, regulators, etc.:
> 
> http://lists.denx.de/pipermail/u-boot/2012-October/138476.html
> http://lists.denx.de/pipermail/u-boot/2012-November/138925.html
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 
