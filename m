Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2KMNif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:38:35 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:58850 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754420Ab2KMNib convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:38:31 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CACxGe6vQxmAk_joUYbaXw4r8J3_RbQt22zFg84ANvcw+ycCMHg@mail.gmail.com>
Date: Tue, 13 Nov 2012 15:38:18 +0200
Cc: David Gibson <david@gibson.dropbear.id.au>,
        Stephen Warren <swarren@wwwdotorg.org>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7A051C2B-C4FB-41A0-8338-60B607EA3BC1@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <509D9089.7020407@wwwdotorg.org> <5B124797-6DFD-4C5E-90D7-665AFD4A7873@antoniou-consulting.com> <50A12950.6090808@wwwdotorg.org> <20121113072517.GE25915@truffula.fritz.box> <BD20AE03-C138-4BC6-AE02-F162AF6840B2@antoniou-consulting.com> <CACxGe6vQxmAk_joUYbaXw4r8J3_RbQt22zFg84ANvcw+ycCMHg@mail.gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Nov 13, 2012, at 2:24 PM, Grant Likely wrote:

> On Tue, Nov 13, 2012 at 8:09 AM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
>> On Nov 13, 2012, at 9:25 AM, David Gibson wrote:
>> Not good to rely on userspace kicking off dtc and compiling from source.
>> Some capes/expansion boards might have your root fs device, for example
>> there is an eMMC cape coming up, while networking capes are common too.
>> 
>> However I have a compromise.
>> 
>> I agree that compiling from source can be an option for a runtime definable
>> cape, but for built-in capes we could do a bit better.
>> 
>> In particular, I don't see any particular need to have a DT fragment
>> reference anything that dependent of the runtime device tree. It should
>> be possible to compile the DT fragment in kernel, against the generated
>> flattened device tree, producing a flattened DT fragment with the phandles
>> already resolved.
> 
> Do you mean linking dtc into the kernel?

No, no :)

Typo there, s/in kernel/outside of the kernel/


> 
>> So the sequence could be something like this:
>> 
>> $ dtc -O dtb -o am335x-bone.dtb -b 0 am335x-bone.dts -@ ${LAST_PHANDLE_FILE}
>> $ dtc -O dtbf -R am335x-bone.dtb -o weather-cape.dtb -b 0 weather-cape.dts -@ ${LAST_PHANDLE_FILE}
>> $ dtc -O dtbf -R am335x-bone.dtb -o geiger-cape.dtb -b 0 geiger-cape.dts -@ ${LAST_PHANDLE_FILE}
>> 
>> The ${LAST_PHANDLE_FILE} can be updated with the last phandle value generated.
>> 
>> Alternatively we could have a way to statically assign a phandle range
>> for well known capes. All the others will have to use the runtime compile
>> mechanism.
>> $ dtc -O dtb -o am335x-bone.dtb -b 0 am335x-bone.dts
>> $ dtc -O dtbf -R am335x-bone.dtb -o weather-cape.dtb -b 0 weather-cape.dts
>> $ dtc -O dtbf -R am335x-bone.dtb -o geiger-cape.dtb -b 0 geiger-cape.dts
>> 
>> With the cape dtses having a /phandle-range/ statement at the top.
> 
> I really think the whole phandle allocation thing is a non problem.
> Generating phandles is the easy part, and using a good hash function
> pretty much solves it entirely. I know people are worried about
> collisions, but there are only two scenarios where collisions may
> happen:
> 
> 1) base and overlay try to define same phandle
>  - Easy to detect - kernel can complain and refuse to load if it happens
>  - Will never happen when overlay is compiled against the base used
> to boot (dtc can resolve the conflict)
>  - Hash phandle generation makes this exceptionally rare
> 2) two overlays try to define same phandle
>  - Also easy to detect on loading the second overlay - kernel will
>  - Hash phandle generation still makes this exceptionally rare
> 
> In both cases a collision is extremely rare and if it does happen it
> will not fail silently. Besides, in the odd scenario where it does
> happen, a node can be manually assigned a phandle. It is far better to
> do the manual override maybe once or twice (actually, I'd be surprised
> if it is ever needed) than to get into any kind of numberspace
> management for phandles. That's just a maintenance nightmare.
> 

The reason people (or at least me) is wary of collisions is that it
throws the user completely out of the normal workflow.

i.e. normal workflow is like this:

a) Edit cape DTS
b) Feed the DTB to the running kernel
c) It works.

When a collision happens c turns into

c.1) Fails with a message that 'there's a phandle collision'
c.2) Google about the error message, land on a page describing solution.
c.3) Modify the cape DTS to use an explicit phandle value.
c.4) It finally works.

Let's just say I don't expect users to deal with this easily.

Anyway, it's all academic at this point. I mostly care about making
the in-kernel dtc compile to handle the collisions automatically.

I think we agree that compiling a fragment that doesn't export any 
phandles against the base dts, should produce a dtb that would load
without any collisions.

> The hard bit to solve has always been when the overlay expects
> different phandles than the base is using, and that problem only
> occurs if the overlay is compiled against a different base dtb than
> was used to boot the system. Hashed phandle generation even makes
> phandles very stable when the base dtb is recompiled, and if they do
> change, then the kernel can detect it and report an error. Again, no
> silent failures. Phandle fixup does make the problem disappears
> entirely but I'm concerned that it is still incomplete (see below) and
> would be conceptually expensive.
> 
> Once of the requests is to support one overlay .dtb with many
> different baseboards, but now that I've thought about it more I
> realize that it just won't work for anything beyond the most trivial
> case. Phandle fixup isn's sufficient. The format of GPIO, Interrupt,
> clock, etc specifiers may change if the base board nodes change. The
> specifiers are not portable.
> 

My intention wasn't never to make overlays overly portable. My intention
was to make them in a way that portability can be introduced if the boards
are 'close' enough, but not for arbitrary boards.

There have to be compatible interfaces both on the base, and the overlay
dtbs.

> So, I no longer think that plain dtb overlays alone will work against
> any base board. Something more is needed. It may be the mechanism for
> loading new data into the kernel, but something really generic does
> require either being compiled at runtime (as David suggests) or each
> expansion interface (ie. the BeagleBone expansion or the RPi
> expansion) to really specify what kinds of references are allowed and
> run all specifiers through translation nodes. Similar to how
> interrupt-map works.
> 

All things point to the latter.

>> i2c2: i2c@4819c000 {
>>        compatible = "ti,omap4-i2c";
>>        #address-cells = <1>;
>>        #size-cells = <0>;
>>        ti,hwmods = "i2c3";
>>        reg = <0x4819c000 0x1000>;
>>        interrupt-parent = <&intc>;
>>        interrupts = <30>;
>>        status = "disabled";
>> };
>> 
>> And in the cape definition (when compiled with the special mode I describe
>> below)
>> 
>> / {
>>        plugin-bundle;
>>        compatible = "cco,weather-cape";
>>        version = <00A0>;
>> 
>>        i2c2-graft = {
>>                compatible = <dt,graft>;
>>                graft-point = <&i2c2>;
> 
> Since overlays are different, we can interpret them slightly
> differently. The node name itself could be the graft point, and the
> name could be either a full path "/foo/bar/i2c@10002000" or an alias
> reference "i2c2". I think that is a bit better than a new graft-point
> property.
> 

Can you expand a bit on the exact syntax?

> g.

Regards

-- Pantelis

