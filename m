Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab2KMIJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:09:37 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:59316 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296Ab2KMIJf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:09:35 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121113072517.GE25915@truffula.fritz.box>
Date: Tue, 13 Nov 2012 10:09:28 +0200
Cc: Stephen Warren <swarren@wwwdotorg.org>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BD20AE03-C138-4BC6-AE02-F162AF6840B2@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <509D9089.7020407@wwwdotorg.org> <5B124797-6DFD-4C5E-90D7-665AFD4A7873@antoniou-consulting.com> <50A12950.6090808@wwwdotorg.org> <20121113072517.GE25915@truffula.fritz.box>
To: David Gibson <david@gibson.dropbear.id.au>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Nov 13, 2012, at 9:25 AM, David Gibson wrote:

> On Mon, Nov 12, 2012 at 09:52:32AM -0700, Stephen Warren wrote:
>> On 11/12/2012 05:10 AM, Pantelis Antoniou wrote:
> [snip]
>>> Oh yes. In fact if one was to use a single kernel image for beagleboard
>>> and beaglebone, for the cape to work for both, it is required for it's
>>> dtb to be compatible. 
>> 
>> Well, as Grant pointed out, it's not actually strictly necessary for the
>> .dtb to be compatible; only the .dts /need/ be compatible, and the .dtb
>> can be generated at run-time using dtc for example.
> 
> So, actually, I think a whole bunch of problems with phandle
> resolution disappear if we don't try to define an overlay .dtb format,
> or at least treat it only as a very shortlived object.  A more precise
> proposal below.  Note that this works more or less equally well with
> either the original overlay approach or the graft/graft-bundle
> proposal I made elsewhere.
> 
> 1) We annotate the base tree with some extra label information for
> nodes which overlays are likely to want to reference by phandle.  e.g.
> 
> 	beaglebone_pic: interrupt-controller@XXXXX {
> 		...
> 		phandle,symbolic-name = "beaglebone_pic";
> 	};
> 
> We could extend dtc to (optionally?) auto-generate those properties
> from its existing label syntax.  Not sure if that's a good idea or
> not yet.  In any case, we compile this augmented base tree to .dtb as
> normal and boot our kernel with it.
> 

I'm fine with that. You can auto-generate when there's a label to a node.
The cape dt fragment will use the label name to reference a node.
More details below...

> 2) The information for the capes/modules/whatever is
> distributed/packaged as .dts, never .dtb.  When userspace detects the
> new module (or the user explicitly tells it, if it's not probeable) it
> picks up the correct dts and runs it through dtc in a special mode.
> In this mode dtc takes the existing base tree (from /proc/device-tree,
> say) as well as the new dts.  In this mode, dtc allocates phandles for
> the new tree fragment so as not to collide with anything from the
> supplied base tree (as well as avoiding internal conflicts,
> obviously).  It also allows node references to the base tree by using
> those label annotations from (1) to match symbolic names to the
> phandle values in the base tree.
> 

Not good to rely on userspace kicking off dtc and compiling from source.
Some capes/expansion boards might have your root fs device, for example
there is an eMMC cape coming up, while networking capes are common too.

However I have a compromise. 

I agree that compiling from source can be an option for a runtime definable 
cape, but for built-in capes we could do a bit better.

In particular, I don't see any particular need to have a DT fragment
reference anything that dependent of the runtime device tree. It should
be possible to compile the DT fragment in kernel, against the generated
flattened device tree, producing a flattened DT fragment with the phandles
already resolved.

So the sequence could be something like this:

$ dtc -O dtb -o am335x-bone.dtb -b 0 am335x-bone.dts -@ ${LAST_PHANDLE_FILE}
$ dtc -O dtbf -R am335x-bone.dtb -o weather-cape.dtb -b 0 weather-cape.dts -@ ${LAST_PHANDLE_FILE}
$ dtc -O dtbf -R am335x-bone.dtb -o geiger-cape.dtb -b 0 geiger-cape.dts -@ ${LAST_PHANDLE_FILE}

The ${LAST_PHANDLE_FILE} can be updated with the last phandle value generated.

Alternatively we could have a way to statically assign a phandle range 
for well known capes. All the others will have to use the runtime compile
mechanism.
$ dtc -O dtb -o am335x-bone.dtb -b 0 am335x-bone.dts
$ dtc -O dtbf -R am335x-bone.dtb -o weather-cape.dtb -b 0 weather-cape.dts
$ dtc -O dtbf -R am335x-bone.dtb -o geiger-cape.dtb -b 0 geiger-cape.dts

With the cape dtses having a /phandle-range/ statement at the top.

This can work because the cape dts do not cross-reference each other, and
neither the boot dts references the capes.

That way we can use request_firmware() pretty early in the boot sequence
and get the DT fragment we need even before user-space starts and root fs
has mounted. request_firmware() can locate the fragments in the kernel
image before rootfs.
 
I don't know if this will cover all the cases Grant has in mind though.

So just to make sure I got it right, this could work for our case.

i2c2: i2c@4819c000 {
	compatible = "ti,omap4-i2c";
        #address-cells = <1>;
        #size-cells = <0>;
        ti,hwmods = "i2c3";
        reg = <0x4819c000 0x1000>;
        interrupt-parent = <&intc>;
        interrupts = <30>;
        status = "disabled";
};

And in the cape definition (when compiled with the special mode I describe
below)

/ {
	plugin-bundle;
	compatible = "cco,weather-cape";
	version = <00A0>;

	i2c2-graft = {
		compatible = <dt,graft>;
		graft-point = <&i2c2>;
		
		#address-cells = <1>;
                #size-cells = <0>;
 
		/* Ambient light sensor */ 
		tsl2550@39 { 
			compatible = "tsl,tsl2550"; 
			reg = <0x39>;
		}; 	
	};
};

DTC when compiling in the special fragment mode will pick up that
&i2c2 can not be resolved and lookup the phandle on the main dtb.
That way, even 'phandle,symbolic-name = "i2c2";' is redundant.


> 3) The resulting partial .dtb for the module is highly specific to the
> base tree (which if the base tree was generated at runtime by firmware
> could even be specific to a particular boot).  But that's ok, because
> we just spit it into the kernel, absolute phandle values and all, then
> throw it away.  Next time we need the module info, we recompile it
> again.
> 
>> Of course, relying on .dts compatibility rather than .dtb compatibility
>> might negatively impact the complexity of an initrd environment if we
>> end up loading overlays from there...
> 
> Well, it does mean we'd need dtc in the initrd.  But dtc has no
> library dependencies except libc, so that really shouldn't be too
> bad.  In return we entirely avoid inventing a new phandle resolution
> protocol.
> 

Not every board boots with initrd; most embedded boards don't use it
at all. This way we make initrd a hard requirement.

It's best if we avoid it.

> -- 
> David Gibson			| I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
> 				| _way_ _around_!
> http://www.ozlabs.org/~dgibson

Regards

-- Pantelis

