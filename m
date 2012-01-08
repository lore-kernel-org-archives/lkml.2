Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab2AHMwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 07:52:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35384 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2AHMwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 07:52:19 -0500
Date: Sun, 8 Jan 2012 20:51:59 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng <dongas86@gmail.com>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Message-ID: <20120108125156.GB2203@richard-laptop>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
 <20120107135445.GI4790@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120107135445.GI4790@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 09:54:48PM +0800, Shawn Guo wrote:
> On Fri, Jan 06, 2012 at 10:03:07AM -0800, Stephen Warren wrote:
> > I see now.
> > 
> > I'd definitely be inclined to drop the num-pins and num-mux properties;
> > The values are just len(grp-pins)/4. You can still check that
> > len(grp-pins)==len(grp-mux) if you want to catch typos etc.
Maybe add a function of_u32_array_size? There' other drivers that need
to get array size.
> > 
> +1
> 
> > So, this does appear to be conflating the two things: The definition of
> > what pins are in a pingroup, and the mux function for a particular
> > setting of that pingroup. I think you need separate nodes for this.
> > 
> At least for imx, we do not have mux function setting for pingroup.
> Instead, it only applies to individual pin.
I think it depends on function definition of pinmux driver. For the
imx example patch, it's one-to-one.
> 
> > Without separate nodes, there will eventually be a lot of duplication.
> > A made-up example of the same uart4grp allowing either of two functions
> > uart3, uart4 to be muxed out onto it:
> > 
> > aips-bus@02000000 { /* AIPS1 */
> > 	iomuxc@020e0000 {
> > 		pinctrl_uart4_3: uart4@option_3 {
> > 			func-name = "uart3";
> > 			grp-name = "uart4grp";
> 
> With phandle in dts reflecting the mapping, neither func-name nor
> grp-name should be needed, and both can just be dropped, IMO.
Maybe map-name can be dropped too if dev-name uses phandle.
> 
> > 			grp-pins = <107 108>;
> > 			num-pins = <2>;
> > 			grp-mux = <3 3>;
> > 			num-mux = <2>;
> > 		};
> > 		pinctrl_uart4_4: uart4@option_4 {
> > 			func-name = "uart4";
> > 			grp-name = "uart4grp";
> > 			grp-pins = <107 108>;
> > 			num-pins = <2>;
> > 			grp-mux = <3 3>;
> > 			num-mux = <2>;
> > 		};
> > 	}
> > };
> > 
> > Now I understand that initially you aren't going to type out the complete
> > list of every available option into imx6q.dtsi because it's probably huge,
> > but the binding does need to allow you to do so without duplicating a lot
> > of data, because eventually you'll get boards that use a larger and larger
> > subset of all the options, so the number you need to represent at once in
> > imx6q.dtsi will grow.
If we don't want to lose flexibity, the pin group number will be huge
than you think. For example, 16bit display interface, has two alternatives
for every pin. The group number will be 2^16.
> > 
> > So I think you need to model the IMX pinmux controller's bindings more on
> > how the pinctrl subsystem represents objects; separate definitions of pins,
> > groups of pins, functions, and board settings. Something more like:
> > 
> > imx6q.dtsi:
> > 
> > aips-bus@02000000 { /* AIPS1 */
> > 	iomuxc@020e0000 {
> > 		/* FIXME: Perhaps need pin nodes here to name them too */
> 
> No, it's been listed in imx pinctrl driver.
> 
> > 
> > 		/* A node per group of pins. Each lists the group name, and
> > 		 * the list of pins in the group */
> > 		foogrp: group@100 {
> > 			grp-name = "foogrp";
> > 			grp-pins = <100 101>;
> > 		};
> > 		bargrp: group@102 {
> > 			grp-name = "bargrp";
> > 			grp-pins = <102 103>;
> > 		};
> > 		bazgrp: group@104 {
> > 			grp-name = "bargrp";
> > 			grp-pins = <104 105>;
> > 		};
> 
> I agree that we should define pingroups in <soc>.dtsi, but the mux
> setting needs to be under the pingroup node too.  See comment below ...
> 
> > 		/* A node per function that can be muxed onto pin groups,
> > 		 * each listing the function name, the set of groups it can
> > 		 * be muxed onto, and the mux selector value to program into
> > 		 * the groups' mux control register to select it */
> > 		uart3func: func@0 {
> > 			func-name = "uart3";
> > 			/* Length of locations and mux-value must match */
> > 			locations = <&foogrp &bargrp>;
> > 			mux-value = <0 4>;
> 
> This can be easily broken for imx.  As the mux setting applies to
> individual pin rather than pingroup, it's very valid for foogrp to
> have pin 100 muxed on mode 0 while pin 101 on mode 1.  That said,
> it's not necessarily true that we always have all the pins in
> particular pingroup muxed on the same setting for given function.
right.
> 
> > 		};
> > 		uart4func: func@1 {
> > 			func-name = "uart4";
> > 			locations = <&bargrp &bazgrp>;
> > 			mux-value = <6 3>;
> > 		};
> 
> I prefer to have function node defined in <board>.dtsi, since it's
> all about defining phandle to the correct pingroup, which should be
> decided by board design.
group and function are one-to-one mapped for imx. So if you put function
in board dts, why not put pin group there too?
> 
> > 	}
> > };
> > 
> > Or, instead of separate locations and mux-value properties with matching
> > lengths, perhaps a node for each location:
> > 
> > 		uart3func: func@0 {
> > 			func-name = "uart3";
> > 			location@0 {
> > 				location = <&foogrp>;
> > 				mux-value = <0>;
> > 			};
> > 			location@1 {
> > 				location = <&bargrp>;
> > 				mux-value = <4>;
> > 			};
> > 		};
> > 
> > That's more long-winded, but might be more easily extensible if we need
> > to add more properties later.
> > 
> > Now in the board's .dts file, you need to specify for each device the
> > list of pinmux groups the device needs to use, and the function to
> > select for each group. Perhaps something like:
> > 
> > board.dts:
> > 
> > usdhc@0219c000 { /* uSDHC4 */
> >         fsl,card-wired;
> >         status = "okay";
> >         pinmux = <&foogrp &uart3func &bazgrp &uart4func>;
> > };
> > 
> > I haven't convinced myself that's actually a good binding, but I think
> > it does represent the data required for muxing. Some potential issues
> > as before:
> > 
> > * Do we need to add flags to each entry in the list; GPIO/interrupt do?
> > 
> What's that for right now?  I guess we can add it later when we see
> the need.
> 
> > * Should "pinmux" be a node, and the configuration of each group be a
> > separate sub-node, so we can add more properties to each "table" entry
> > in the future, e.g. pin config parameters?
> > 
> I do not think it's necessary. 'pinctrl' phandle works perfectly fine
> to me at least for now.  How pinconf support should be added into
> pinctrl subsystem is still up in the air to me.
> 
> > * For Tegra, I elected to put the definitions of pins, groups, and
> > functions into the driver rather than in the device tree.
> 
> IMO, we do not want to do this for imx, as I'm scared of the size
> of Tegra pinctrl patches.  If we go this way for imx, we will have
> even bigger patches.
> 
> > This avoids
> > parsing a heck of a lot of data from device tree. That means there isn't
> > any per-function node that can be referred to by phandle. Does it make
> > sense to refer to groups and functions by string name or integer ID
> > instead of phandle? Perhaps:
> > 
> > usdhc@0219c000 { /* uSDHC4 */
> > 	fsl,card-wired;
> > 	status = "okay";
> > 	pinmux = {
> > 		group@0 {
> > 			group = "foo";
> > 			function = "uart3";
> > 			/* You could add pin config options here too */
> > 		};
> > 		group@1 {
> > 			group = "baz";
> > 			function = "uart4";
> > 		};
> > 	};
> > };
> > 
> > I guess referring to things by name isn't that idiomatic for device tree.
> > Using integers here would be fine too, so long as dtc gets support for
> > named constants:
> > 
> > imx6q.dtsi:
> > 
> > /define/ IMX_PINGRP_FOO 0
> > /define/ IMX_PINGRP_BAR 1
> > /define/ IMX_PINGRP_BAZ 2
> > /define/ IMX_PINFUNC_UART3 0
> > /define/ IMX_PINFUNC_UART4 1
> > ...
> > 
> > board .dts:
> > 
> > usdhc@0219c000 { /* uSDHC4 */
> > 	fsl,card-wired;
> > 	status = "okay";
> > 	pinmux = {
> > 		group@0 {
> > 			group = <IMX_PINGRP_FOO>;
> > 			function = <IMX_PINFUNC_UART3>;
> > 			/* You could add pin config options here too */
> > 		};
> > 		group@1 {
> > 			group = <IMX_PINGRP_BAZ>;
> > 			function = <IMX_PINFUNC_UART4>;
> > 		};
> > 	};
> > };
> > 
> Doing this does not change the fact that this is bound with Linux
> driver details.  That said, if the indexing of either pingrp array
> or pinfunc array changes in the driver, the binding is broken.
> 
> -- 
> Regards,
> Shawn
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
