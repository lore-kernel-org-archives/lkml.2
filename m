Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2AIGSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 01:18:10 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51386 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142Ab2AIGSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 01:18:08 -0500
MIME-Version: 1.0
In-Reply-To: <20120109015625.GE1835@S2101-09.ap.freescale.net>
References: <1324402840-32451-3-git-send-email-b29396@freescale.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
	<CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
	<20120107135445.GI4790@S2101-09.ap.freescale.net>
	<20120108125156.GB2203@richard-laptop>
	<20120109015625.GE1835@S2101-09.ap.freescale.net>
Date: Sun, 8 Jan 2012 22:18:06 -0800
X-Google-Sender-Auth: c6X3MRV4gbuEbjheAwTRZmPiXSc
Message-ID: <CAPnjgZ1LL7g_s1e+Pe-XN27yTNL4SCZvm6swJ_zX=ZULQirOxQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux mappings
From: Simon Glass <sjg@chromium.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Richard Zhao <richard.zhao@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng <dongas86@gmail.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[snip lots of discussion]

Someone copied me on this so I feel I can sneak in with a response. I
have read this entire thread and implemented Tegra pinmux in U-boot,
but not much else on the topic so have limited understanding,
particular of the kernel pinmux setup, unfortunately. Sorry if I have
the wrong end of the stick on some of this, but I hope my comments are
useful.

1. Symbolic names

> Stephen said:
> It's a real pity that dtc doesn't have a way of doing named integer
> constants, so this could be re-written as e.g.:
> SoC .dtsi file:
> /define/ TEGRA_MUX_FUNC_SD4 234

IMO this is essential for pinmux. Stephen has already done a patch
which implements this feature. The alternative is bindings with lots
of arbitrary numbers - lots of errors, lots of confusion, lots of
pain. He has asked a few times on the device-tree list for this
feature to be accepted. I believe it should be, and pinmux brough in
with that in mind. Turning symbols into numbers is the role of the
device tree compiler I think.

If Stephen's proposed grammar needs tweaking that is fine, but I think
we are pushing the limits of a pure numerical representation here.


2. Stephen also said:

> We also need to consider compatibility and extensibility. A DT binding
> is an ABI between the kernel and whatever is providing it, and so we
> need to be able to maintain and extend it in a compatible fashion, just
> like the user-space syscall ABI. Now it's true that the .dts files are
> currently part of the kernel source tree and can be rev'd in sync with
> kernel changes, but that may not always be the case moving forward.
>
> In other words, taking a board with an old device tree embedded into
> Flash and running a new kernel using that device tree should work just
> like running the original kernel did.

While this is true we should remember that SOCs will change and
evolve, and we don't actually need a device tree for a Tegra 2 (say)
to be able to boot a Tegra 3 kernel. So each time we create a new SOC
in a family, we have the opportunity to update the fdt, potentially in
an incompatible way, since we know that the old boot loader and new
kernel are incompatible anyway.

Anyway we are looking at pinmux from a 2012 view of how SOCs do
things. We can't predict what things will look like in the future. The
device tree format is great for making things extensible, but there is
an efficiency cost also.

Backwards compatibility can create a lot of problems with newer
designs, so I don't think we should be slaves to it. We are backwards
compatible because it aids understanding, is necessary for kernels to
run across different boards, etc., not just for its own sake. If in
the future we decide that the approach agreed now no longer servers
the purpose and has too much baggage, we can change it. Similar things
happen in the rest of the kernel.

Also IMO updating the kernel without the device tree doesn't make a
huge amount of sense. Why not just update both? Really to me the
device tree is almost like static data for the kernel. It is a worthy
goal to keep it as static as possible, but if it changes I don' t
think it is the end of civilisation.


3. Efficiency

There has been talk about using strings to link things. IMO this is
inefficient and slow compared to integers and device trees already
have phandles. Some platforms will care more than others, but if the
reason for using strings is that the device tree format does not
support symbolic representation of integers, then see 1 above.


4. Who bears the pain?

There is a lot of complexity in pinmux - if we continue to split the
device tree into an SOC file and a board file then we should think
about which one bears the brunt of the complexity. IMO it should be
the SOC file. The SOC file is written by very clever engineers working
for the SOC vendor. They are motivated to get their SOC working
properly and for it to be easy for customers to access the glorious
ground-breaking feature therein. On the other hand, the board file (to
the extent it is not just copied from the vendor's example) is put
together by people with little knowledge of the SOC, limited time to
do the work and minimal interest in the wonders of the device tree
structure.

With this in mind I think the pinmux complexity should mostly be in
the SOC file. This includes the selection of valid pinmux options.
After all, despite the many possible ways that functions could be
brought out of the chip, only a certain few ways typically make sense.
For example, an SDMMC peripheral needs clock and command pins - unless
these are connected then nothing with work. Similarly there is no
sense in having two data[0] pins brought out for the same SDMMC port.

In fact the SOC vendor generally has a good idea about the different
options and mostly there are a small number of useful ones. So why
don't we just enumerate these in the SOC file and let the board select
what it wants in a single setting?


5. Start at the top: function mux

I propose adding a new level at the top, a function mux. This
basically routes functions to one of 2-3 predefined options. So UART1
can come out on 3 different sets of pins, SDMMC2 on two sets, etc.
These are recommended from the vendor and in common use (e.g. on
reference designs), so should be easy to use.

Below the function mux is the group mux. Here we specify a list of pin
groups and which function each group is assigned to. Together these
2-3 groups join to give us the pins that the function mux needs.

Below the pin groups are the pins. Some SOCs will have only one pin
per group, some will have a group mux that really just moves entire
functions around.

IMO the top level belongs with the board file. If the board designer
wants to depart from common options they can suffer the pain of
dropping down to the group level.

So at the board level it would be nice to do something like this:

sdhci@c8000400 {
	funcmux = <&sdmmc3-funcmux 0 0>;  /* funcmux phandle, config option, flags */
};

which means that we want this SDMMC port to use configuration 0 (out
of perhaps 2-3 recommended options the SOC provides for bringing out
this SDMMC function) and that there are no special flags required. Or:

emmc: sdhci@c8000600 {
	funcmux = <&sdmmc4-funcmux 1 OPT_SDMMC_8BIT>;
}

which means for this port we want to use configuration 1 with 8-bit wide data.

Something like this is easy for the board files to deal with. It fits
with the way reference designs are done (selecting from a few
options). It allows flags to specify different options like 4-bit or
8-bit wide SDMMC which can affect what pinmux groups are affected.

Some boot loaders might even implement things only at the funcmux
level, with hard-coded configuration of the actual pin groups in
static data in their code, without reference to the device tree. This
might allow them to operate with a vastly truncated device tree. They
might be very motivated to do this if the full device tree consists of
20KB of strings :-)


6. Groups

Already done in the discussion prior to this email:

uart4func: func@1 {
       func-name = "uart4";
       locations = <&bargrp &bazgrp>;
       mux-value = <6 3>;
};

but how above adding a flag cell and putting the locations and values
into the same property, like:

uart4func: func@1 {
       func-name = "uart4";
       locations = <&bargrp 6 0>
		<&bazgrp 3 SOME_FLAG>;
};


So the SDMMC example might have three options for SDMMC4: a 4-bit one,
and two 8-bit ones (changing 'locations' to 'groups'):

sdmmc4-funcmux : sdmmc4_funcmux@0 {
	setting@0 {
		config = <0>;
		option = <OPT_SDMMC_8BIT>;
		groups = <&pingrp-atc FUNC_SDIO4 0> /* clk, cmd, data 1, 3, 5, 7 */
			<&pingrp-atd FUNC_SDIO4 0>; /* data 0, 2, 4, 6 */
	};

	setting@1 {
		config = <1>;
		option = <0>;
		groups = <&pingrp-atb FUNC_SDIO4 0>  /* clock, command */
			<&pingrp-gma FUNC_SDIO4 0>; /* data[3:0] */
	};

	setting@2 {
		config = <1>;
		option = <OPT_SDMMC_8BIT>;
		groups = <&pingrp-atb FUNC_SDIO4 0>  /* clock, command */
			<&pingrp-gma FUNC_SDIO4 0> /* data[3:0] */
			<&pingrp-gme FUNC_SDIO4 0>; /* data [7:4] */
	};
};

The 'config' property refers to the second cell of the reference in
the funcmux. The option property refers to the third cell. Essentially
the vendor is recommending three possible options for SDMMC4 and the
board can choose which one it likes.

The disadvantage is that the last two share the pingrp-atb setting,
and the last just adds an extra group, but no matter. It is easy to
understand.

A related problem is that the options must each be enumerated. Maybe
that doesn't matter either for the moment.

Then for the groups, again already done above, but I am less clear on
the exact binding that is arrived at above. Something like this?

pingrp-atb: pingrp_atb@0 {
	locations = <&pin-i02 &pin-t07>;
	control = <&pinmux 0>;
	/* 4 options available, numbered 0 to 3 */
	functions = <FUNC_IDE   FUNC_NAND   FUNC_GMI   FUNC_SDIO4>;
	/* do we want to specify what the flags do here? I assume they are
           globally understood by the pinmux system rather than specific to
	   each group */
};

pingrp-atd: pingrp_atd@0 {
	locations = <&pin-h01 &pin-h02 &pin-h03 &pin-h04>;
	control = <&pinmux 3>;  /* 3 is the pinmux controller's ID for the atd group */
	/* 4 options available, numbered 0 to 3 */
	functions = <FUNC_IDE   FUNC_NAND   FUNC_GMI   FUNC_SDIO4>;
};


(It is probably obvious, but FUNC_SDIO4 is not just the value 3. It
might be 21 - the pinmux code searches the list of 4 options for
FUNC_SDIO4. The position it finds it in this case is 3, so that is the
value written to &pinmux)


7. Pins

At this level I'm not sure if a device tree representation adds much.
Maybe connect the GPIOs?

pin-i02: pin_i02@0 {
	name = "i02";
	gpio = <&gpio 66>;
};

pin-t07: pin_t07@0 {
	name = "t07";
	gpio = <&gpio 167>;
};


8. Flexibility

Someone asked how to deal with an LCD output with 16 bits each of
which can be on two pins. Know you of such an SOC? If so, then it is
still possible that the SOC would provide a few basic 'common' options
at the funcmux level. But board designers may have to steel themselves
and dive into the the pingroup level.

Where an SOC has no groups but only pins, then perhaps the funcmux can
still be provided, but uses a 'pins' property instead of 'groups':

sdmmc4-funcmux : sdmmc4_funcmux@0 {
        ...
	setting@2 {
		config = <1>;
		option = <OPT_SDMMC_8BIT>;
		pins = <&pin-i02 FUNC_SDIO4 0>  /* clock */
			<&pin-t07 FUNC_SDIO4 0>  /* command */
			<&pin-a00 FUNC_SDIO4 0>  /* data[0] */
			<&pin-a01 FUNC_SDIO4 0>  /* data[1] */
			<&pin-a02 FUNC_SDIO4 0>  /* data[2] */
			<&pin-a03 FUNC_SDIO4 0>;  /* data[3] */
			<&pin-a04 FUNC_SDIO4 0>;  /* data[4] */
			<&pin-a05 FUNC_SDIO4 0>;  /* data[5] */
			<&pin-a06 FUNC_SDIO4 0>;  /* data[6] */
			<&pin-a07 FUNC_SDIO4 0>;  /* data[7] */
	};
};

IMO this sort of thing makes it even more desirable to have a
high-level pinmux feature in the device tree. Again, the board
designer can dive into pins by defining his own custom funcmux-level
things, so no flexibility is lost.

Regards,
Simon
