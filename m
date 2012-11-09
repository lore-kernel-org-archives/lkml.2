Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2KIQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:29:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65078 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2KIQ3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:29:22 -0500
MIME-Version: 1.0
In-Reply-To: <50999145.2070306@wwwdotorg.org>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <50999145.2070306@wwwdotorg.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 16:28:59 +0000
X-Google-Sender-Auth: 4bMtYnSVKt4XkTkopj5wkyydH1Y
Message-ID: <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 10:37 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
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

Sure, why not...

http://git.secretlab.ca/?p=devicetree-overlays.git;a=summary

>
> "for the so" split across those two lines.

fixed

>>   - SHOULD reliably handle changes between different underlying overlays
>>     (ie. what happens to existing .dtb overly files if the structure of
>>     the dtb it is layered over changes. If not possible, then SHALL
>>     detect when the base tree doesn't match and refuse to apply the
>>     overlay.
>
> Perhaps use (versioned) DT bindings to represent the interface between
> the two .dts files? See the links to the U-Boot mailing list discussions
> below?

Implementing versioning is conceptually a lot more complex than plain
overlays since it means either the kernel or u-boot needs to start
filtering the data that it's given. This can get really complex in a
hurry. Mitch makes a valid point later in this thread that when it
comes to manipulating the data depending on the board then the data
overlay model alone doesn't handle it well.

I'm not actually opposed to it, but it needs to be done in an elegant
way. The DT data model already imposes more of a conceptual learning
curve than I wish it did and I don't want to make that worse with a
versioning model that is difficult to get ones head around.

Suggestions and proposals are definitely welcome here.

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

The way I'm currently thinking about the overlay approach is as a
discrete set of changes that all can be applied at once.* That
certainly doesn't preclude the change being generated with a script or
other tool in either firmware or userspace. For most changes it works
really well. Of the scenarios that don't work well, I can think of
two. The first is it moving or renaming existing nodes, and the second
is if the structure of the base tree changes (say due to a firmware
update). Although the second limitation is specifically with binary
.dtb overlays. Recompiling the dts overlay against the new tree would
work fine.**

*with the caveat that not all types of changes are a good idea and we
may disallow. For example, is changing properties in existing nodes a
good idea?
** all this is based on my current ideas about the .dtb overlay format
which would be trivial to implement, but I'm not committed to that
approach just yet. The above problems could be solved.

>> It may be sufficient to solve it by making the phandle values less
>> volatile. Right now dtc generates phandles linearly. Generated phandles
>> could be overridden with explicit phandle properties, but it isn't a
>> fantastic solution. Perhaps generating the phandle from a hash of the
>> node name would be sufficient.
>
> Node names don't have to be unique though right; perhaps hash the
> path-name instead of the node-name? But then, why not just reference by
> path name; similar to <{&/path/to/node}> rather than <&label>?

I was thinking about using the full_name for generating phandles. On
the odd chance there is a collision, one of the nodes will get
something like the hash value +1. Or in that condition we can require
one of the nodes to have the phandle value explicitly set in the
source file.

Note; this doesn't actually affect anything outside of dtc. Right now
dtc starts at 1 and assigns phandles incrementally. I'm suggesting
using a hash of the full_name to assign the phandle for a node so that
it will not change unless the full_path changes.

>> This handles many of the use cases, but it assumes that an overlay is
>> board specific. If it ever is required to support multiple base boards
>> with a single overlay file then there is a problem. The .dtb overlays
>> generated in this manor cannot handle different phandles or nodes that
>> are in a different place. On the other hand, the overlay source files
>> should have no problem being compiled for multiple targets.
>
> s/manor/manner/

Fixed

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

>From your perspective, is it important to use the exact same .dtb
overlays for those add-on boards, or is it okay to have a separate
build of the overlay for each base tree?

g.
