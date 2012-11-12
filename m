Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2KLUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:16:27 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58758 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab2KLUQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:16:25 -0500
MIME-Version: 1.0
In-Reply-To: <C3971D11-2BAC-4B58-AF8D-987FF8FFF678@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
	<50999145.2070306@wwwdotorg.org>
	<CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com>
	<C3971D11-2BAC-4B58-AF8D-987FF8FFF678@antoniou-consulting.com>
Date: Mon, 12 Nov 2012 12:16:23 -0800
X-Google-Sender-Auth: RSC6McAcCpGHEUzUEgPW72y7YUc
Message-ID: <CA+Bv8XZV_RXQ351QG6ztvX=aTQubFHOR2Hgtc+ZSLKRo4_MNsQ@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
From: Russ Dill <Russ.Dill@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 3:23 AM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> Hi Grant,
>
> Sorry for the late comments, travelling...
>
> On Nov 9, 2012, at 6:28 PM, Grant Likely wrote:
>
>> On Tue, Nov 6, 2012 at 10:37 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 11/05/2012 01:40 PM, Grant Likely wrote:
>>>> Hey folks,
>>>>
>>>> As promised, here is my early draft to try and capture what device
>>>> tree overlays need to do and how to get there. Comments and
>>>> suggestions greatly appreciated.
>>>
>>> Interesting. This just came up internally at NVIDIA within the last
>>> couple weeks, and was discussed on the U-Boot mailing list very recently
>>> too:
>>>
>>> http://lists.denx.de/pipermail/u-boot/2012-October/thread.html#138227
>>> (it spills into the November archive too)
>>>
>>>> For these cases it is proposed to implement an overlay feature for the
>>>> so that the initial device tree data can be modified by userspace at
>>>
>>> I don't know if you're maintaining this as a document and taking patches
>>> to it, but if so:
>>
>> Sure, why not...
>>
>> http://git.secretlab.ca/?p=devicetree-overlays.git;a=summary
>>
>>>
>>> "for the so" split across those two lines.
>>
>> fixed
>>
>>>>  - SHOULD reliably handle changes between different underlying overlays
>>>>    (ie. what happens to existing .dtb overly files if the structure of
>>>>    the dtb it is layered over changes. If not possible, then SHALL
>>>>    detect when the base tree doesn't match and refuse to apply the
>>>>    overlay.
>>>
>>> Perhaps use (versioned) DT bindings to represent the interface between
>>> the two .dts files? See the links to the U-Boot mailing list discussions
>>> below?
>>
>> Implementing versioning is conceptually a lot more complex than plain
>> overlays since it means either the kernel or u-boot needs to start
>> filtering the data that it's given. This can get really complex in a
>> hurry. Mitch makes a valid point later in this thread that when it
>> comes to manipulating the data depending on the board then the data
>> overlay model alone doesn't handle it well.
>>
>> I'm not actually opposed to it, but it needs to be done in an elegant
>> way. The DT data model already imposes more of a conceptual learning
>> curve than I wish it did and I don't want to make that worse with a
>> versioning model that is difficult to get ones head around.
>>
>> Suggestions and proposals are definitely welcome here.
>>
>
> I didn't find versioning all that difficult TBH.
>
> Making the property access functions work sanely with versioning
> should cover most (if not all) kernel users.
> Keep non versioned property access function available to possibly
> users with a prefix for those that need it.
>
>>>
>>>> - What is the model for overlays?
>>>>  - Can an overlay modify existing properties?
>>>>  - Can an overlay add new properties to existing nodes?
>>>>  - Can an overlay delete existing nodes/properties?
>>>
>>> This proposal is very oriented at an overlay-based approach. I'm not
>>> totally convinced that a pure overlay approach (as in how dtc does
>>> overlayed DT nodes) will be flexible enough, but would love to be
>>> persuaded. Again see below.
>>
>> The way I'm currently thinking about the overlay approach is as a
>> discrete set of changes that all can be applied at once.* That
>> certainly doesn't preclude the change being generated with a script or
>> other tool in either firmware or userspace. For most changes it works
>> really well. Of the scenarios that don't work well, I can think of
>> two. The first is it moving or renaming existing nodes, and the second
>> is if the structure of the base tree changes (say due to a firmware
>> update). Although the second limitation is specifically with binary
>> .dtb overlays. Recompiling the dts overlay against the new tree would
>> work fine.**
>>
>
> Atomicity should be handled correctly. I can't imagine how hard would
> be to back out a semi-applied overlay without some kind of core DT
> tracking support. Leaving it to the driver/user is too difficult to get
> right.
>
> About moving and renaming nodes, I can't think of a user-case today that
> needs it. Perhaps it can be handled by removal & re-insertion?
>
>> *with the caveat that not all types of changes are a good idea and we
>> may disallow. For example, is changing properties in existing nodes a
>> good idea?
>
> Yes, changing properties is something that we need. One such change is
> the change of the bus controller 'status' properties to enabled upon
> insertion of a child device node, and change back to 'on-demand' when
> all the child device nodes are gone.

Some devices will probably have to support on the fly changes that
they may not have otherwise supported. An example of a driver that
needs to modify it's device based on DT would be an I²C bus speed
change.
