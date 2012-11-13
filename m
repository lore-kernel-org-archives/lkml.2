Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2KMRKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:10:20 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58218 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2KMRKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:10:18 -0500
Message-ID: <50A27EF5.7080806@wwwdotorg.org>
Date: Tue, 13 Nov 2012 10:10:13 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: David Gibson <david@gibson.dropbear.id.au>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <509D9089.7020407@wwwdotorg.org> <5B124797-6DFD-4C5E-90D7-665AFD4A7873@antoniou-consulting.com> <50A12950.6090808@wwwdotorg.org> <20121113072517.GE25915@truffula.fritz.box> <BD20AE03-C138-4BC6-AE02-F162AF6840B2@antoniou-consulting.com>
In-Reply-To: <BD20AE03-C138-4BC6-AE02-F162AF6840B2@antoniou-consulting.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 01:09 AM, Pantelis Antoniou wrote:
> On Nov 13, 2012, at 9:25 AM, David Gibson wrote:
...
>> 1) We annotate the base tree with some extra label information for
>> nodes which overlays are likely to want to reference by phandle.  e.g.
>>
>> 	beaglebone_pic: interrupt-controller@XXXXX {
>> 		...
>> 		phandle,symbolic-name = "beaglebone_pic";
>> 	};
>>
>> We could extend dtc to (optionally?) auto-generate those properties
>> from its existing label syntax.  Not sure if that's a good idea or
>> not yet.  In any case, we compile this augmented base tree to .dtb as
>> normal and boot our kernel with it.
> 
> I'm fine with that. You can auto-generate when there's a label to a node.
> The cape dt fragment will use the label name to reference a node.
> More details below...
> 
>> 2) The information for the capes/modules/whatever is
>> distributed/packaged as .dts, never .dtb.  When userspace detects the
>> new module (or the user explicitly tells it, if it's not probeable) it
>> picks up the correct dts and runs it through dtc in a special mode.
>> In this mode dtc takes the existing base tree (from /proc/device-tree,
>> say) as well as the new dts.  In this mode, dtc allocates phandles for
>> the new tree fragment so as not to collide with anything from the
>> supplied base tree (as well as avoiding internal conflicts,
>> obviously).  It also allows node references to the base tree by using
>> those label annotations from (1) to match symbolic names to the
>> phandle values in the base tree.
> 
> Not good to rely on userspace kicking off dtc and compiling from source.
> Some capes/expansion boards might have your root fs device, for example
> there is an eMMC cape coming up, while networking capes are common too.
> 
> However I have a compromise. 
> 
> I agree that compiling from source can be an option for a runtime definable 
> cape, but for built-in capes we could do a bit better.
> 
> In particular, I don't see any particular need to have a DT fragment
> reference anything that dependent of the runtime device tree. It should
> be possible to compile the DT fragment in kernel, against the generated
> flattened device tree, producing a flattened DT fragment with the phandles
> already resolved.
> 
> So the sequence could be something like this:
> 
> $ dtc -O dtb -o am335x-bone.dtb -b 0 am335x-bone.dts -@ ${LAST_PHANDLE_FILE}
> $ dtc -O dtbf -R am335x-bone.dtb -o weather-cape.dtb -b 0 weather-cape.dts -@ ${LAST_PHANDLE_FILE}
> $ dtc -O dtbf -R am335x-bone.dtb -o geiger-cape.dtb -b 0 geiger-cape.dts -@ ${LAST_PHANDLE_FILE}
> 
> The ${LAST_PHANDLE_FILE} can be updated with the last phandle value generated.

I'm not sure that will avoid phandle collisions though.

If you build everything at runtime, you'll always be compiling each new
partial .dtb based on the phandles actually in-use in the kernel's
current complete device tree. You can always easily avoid collisions
that way.

If you instead pre-compile both the based .dtb /and/ some partial .dtbs,
then you're essentially statically defining some phandle values, but
splitting those static assignments across 3 (in your example) different
.dtbs. However, what guarantees that those 3 .dtbs are already loaded
into the system when some fourth partial .dtb is loaded, such that the
static phandle assignments influence that fourth partial .dtb's runtime
compilation?

Put another way, what happens when you:

1) Boot the kernel using am335x-bone.dtb.
2) Incrementally load weather-cape.dtb. Don't incrementally load
geiger-cape.dtb for whatever reason.
3) Load runtime-compiled-cape.dtb. This avoids conflicts with the
already-loaded am335x-bone.dtb and weather-cape.dtb since
runtime-compiled-cape.dtb is compiled at runtime based on the currently
loaded .dtbs. However, it may well end up conflicting with
geiger-cape.dtb since that isn't loaded.
4) Now attempt to load geiger-cape.dtb - possible conflict.

Given all of that, I'd assert that if you want to statically assign any
phandles, all static assignments need to be done in the base .dtb that
the kernel is loaded with, and not in any pre-compiled partial .dtbs.

So, if your root filesystem is on an eMMC cape, then you need to create
a board .dts file that /include/s the base board .dts and the cape .dts
files and boot the kernel with that.

Or, you get U-Boot/... to merge the relevant pre-compiled .dtbs and boot
the kernel with that.

Or I suppose you could have a well-known range of phandles for
pre-compiled .dtbs that the runtime dtc mode always avoided, preferably
without the need for explicit phandle-range statements in the .dts
files, e.g. driven by a dtc static-assignment-vs-dynamic-assignment
command-line option?
