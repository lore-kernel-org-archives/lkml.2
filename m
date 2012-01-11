Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab2AKSR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 13:17:57 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6012 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665Ab2AKSRt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 13:17:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 11 Jan 2012 10:17:41 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        Dong Aisheng <dongas86@gmail.com>,
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
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>
Date: Wed, 11 Jan 2012 10:17:40 -0800
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AczNQnowu+UjOr4lRsez1HbTpQ9XpADRVJ8Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A6E5@HQMAIL01.nvidia.com>
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
In-Reply-To: <20120107135445.GI4790@S2101-09.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Guo wrote at Saturday, January 07, 2012 6:55 AM:
> On Fri, Jan 06, 2012 at 10:03:07AM -0800, Stephen Warren wrote:
...
> > So, this does appear to be conflating the two things: The definition of
> > what pins are in a pingroup, and the mux function for a particular
> > setting of that pingroup. I think you need separate nodes for this.
> >
> At least for imx, we do not have mux function setting for pingroup.
> Instead, it only applies to individual pin.

Ah. There's a slight disconnect between my understanding of your HW and
how it really is then! I saw pingroup definitions on Dong's patch, and
hence I assume that your HW was like Tegra, namely that pins were grouped
together for mux control, i.e. muxing isn't a per-pin option. Given that,
some of my responses may not entirely have made sense for your HW...

Just to confirm my understanding:

IMX:

* HW has a set of pins.
* Each pin has a register/field that defines its mux function.

And contrast this to Tegra for reference:

* HW has a set of pins.
* Each pin is a member of a single mux group..
* Each mux group has a register/field that defines its mux function.
  This affects all the pins in the group at once, which are all set to
  the same logical function (e.g. UART). For that logical function, each
  pin has some specific signal muxed onto it. For example, a pin group
  "X" may have pins P1 and P2, and when function "UART" is muxed onto "X",
  P1 will be UART.RX and P2 UART.TX.
* Note that there also exist other properties that can be configured for
  each of these mux groups (e.g. pullup/down, tristate). There also exist
  other types of groups that don't align with the mux groups, and each of
  those allows various other properties (e.g. drive strength) to be
  configured. However, this bullet isn't relevant for the pin mux
  discussion, just pin config.

So, my position is that:

* Something (either the pinctrl driver, or the SoC .dtsi file) should
enumerate all available muxable entities that exist in the SoC (pins for
IMX, groups for Tegra).

* Something (either the pinctrl driver, or the SoC .dtsi file) should
enumerate all the available functions that can be assigned to a muxable
entity.

* The enumerations above should be purely at the level the HW exposes,
i.e. if a UART uses 4 signals (RX, TX, CTS, RTS), and the SoC configures
muxing at a per-pin level, and 6 pins exist which can have various UART
signals mux'd on to them, there should be a "muxable entity" enumeration
for each of the 6 pins, not an enumeration for each possible combination
of assignments of signals to pins, since in general that number could be
extremely large as Richard Zao points out in his email that was sent right
after yours.

* pinmux properties in device drivers should list the muxable entities
that they use, and the mux function for each of them.

This is the minimal data model to represent the pure HW functionality,
and is what the pinctrl subsystem uses too.

> > Without separate nodes, there will eventually be a lot of duplication.
> > A made-up example of the same uart4grp allowing either of two functions
> > uart3, uart4 to be muxed out onto it:
> >
> > aips-bus@02000000 { /* AIPS1 */
> >     iomuxc@020e0000 {
> >             pinctrl_uart4_3: uart4@option_3 {
> >                     func-name = "uart3";
> >                     grp-name = "uart4grp";
>
> With phandle in dts reflecting the mapping, neither func-name nor
> grp-name should be needed, and both can just be dropped, IMO.

I'd now argue that these nodes shouldn't even exist in the device tree;
rather the "combination" of which muxable entities are used and their
used mux function should be something in the board .dts files, since its
board-specific.

> >                     grp-pins = <107 108>;
> >                     num-pins = <2>;
> >                     grp-mux = <3 3>;
> >                     num-mux = <2>;
> >             };
> >             pinctrl_uart4_4: uart4@option_4 {
> >                     func-name = "uart4";
> >                     grp-name = "uart4grp";
> >                     grp-pins = <107 108>;
> >                     num-pins = <2>;
> >                     grp-mux = <3 3>;
> >                     num-mux = <2>;
> >             };
> >     }
> > };
> >
> > Now I understand that initially you aren't going to type out the complete
> > list of every available option into imx6q.dtsi because it's probably huge,
> > but the binding does need to allow you to do so without duplicating a lot
> > of data, because eventually you'll get boards that use a larger and larger
> > subset of all the options, so the number you need to represent at once in
> > imx6q.dtsi will grow.
> >
> > So I think you need to model the IMX pinmux controller's bindings more on
> > how the pinctrl subsystem represents objects; separate definitions of pins,
> > groups of pins, functions, and board settings. Something more like:
> >
> > imx6q.dtsi:
> >
> > aips-bus@02000000 { /* AIPS1 */
> >     iomuxc@020e0000 {
> >             /* FIXME: Perhaps need pin nodes here to name them too */
>
> No, it's been listed in imx pinctrl driver.

OK, that's fine too. I just recalled there being such a node in one of
Dong's patches.

> >             /* A node per group of pins. Each lists the group name, and
> >              * the list of pins in the group */
> >             foogrp: group@100 {
> >                     grp-name = "foogrp";
> >                     grp-pins = <100 101>;
> >             };
> >             bargrp: group@102 {
> >                     grp-name = "bargrp";
> >                     grp-pins = <102 103>;
> >             };
> >             bazgrp: group@104 {
> >                     grp-name = "bargrp";
> >                     grp-pins = <104 105>;
> >             };
>
> I agree that we should define pingroups in <soc>.dtsi, but the mux
> setting needs to be under the pingroup node too.  See comment below ...

As I mention above, I'd assert we shouldn't have any group nodes in
the .dtsi file for SoCs that don't mux pins in groups at the raw HW level.

> >             /* A node per function that can be muxed onto pin groups,
> >              * each listing the function name, the set of groups it can
> >              * be muxed onto, and the mux selector value to program into
> >              * the groups' mux control register to select it */
> >             uart3func: func@0 {
> >                     func-name = "uart3";
> >                     /* Length of locations and mux-value must match */
> >                     locations = <&foogrp &bargrp>;
> >                     mux-value = <0 4>;
>
> This can be easily broken for imx.  As the mux setting applies to
> individual pin rather than pingroup, it's very valid for foogrp to
> have pin 100 muxed on mode 0 while pin 101 on mode 1.  That said,
> it's not necessarily true that we always have all the pins in
> particular pingroup muxed on the same setting for given function.

OK, that node doesn't make sense for IMX, since muxing is at a per-pin
level. If Tegra were to enumerate the available functions in the .dtsi
file instead of in the pinctrl driver, this node would make sense for
Tegra since it does mux on a per-group basis.

> >             };
> >             uart4func: func@1 {
> >                     func-name = "uart4";
> >                     locations = <&bargrp &bazgrp>;
> >                     mux-value = <6 3>;
> >             };
>
> I prefer to have function node defined in <board>.dtsi, since it's
> all about defining phandle to the correct pingroup, which should be
> decided by board design.

Just to explicitly re-iterate, if there are no groups in HW, I don't
think the .dtsi file should attempt to represent any groups.

(I think I'll talk a little more about this in a response to Richard
Zhao's email later)

> >     }
> > };
> >
> > Or, instead of separate locations and mux-value properties with matching
> > lengths, perhaps a node for each location:
> >
> >             uart3func: func@0 {
> >                     func-name = "uart3";
> >                     location@0 {
> >                             location = <&foogrp>;
> >                             mux-value = <0>;
> >                     };
> >                     location@1 {
> >                             location = <&bargrp>;
> >                             mux-value = <4>;
> >                     };
> >             };
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
>
> What's that for right now?  I guess we can add it later when we see
> the need.

I guess as long as we have a #pinmux-cells in the pinmux controller's
node, we could write the driver to accept 2 now (phandle of muxable
entity and mux function value) but also accept 3 in the future (adding
a flags field), and hence have an upgrade path. So, yes, flags aren't
needed now.

> > * Should "pinmux" be a node, and the configuration of each group be a
> > separate sub-node, so we can add more properties to each "table" entry
> > in the future, e.g. pin config parameters?
>
> I do not think it's necessary. 'pinctrl' phandle works perfectly fine
> to me at least for now.  How pinconf support should be added into
> pinctrl subsystem is still up in the air to me.

Well, I think we definitely need to have a rough idea how to support pin
config in the future; representing the current pin mux as a node rather
than a property seems like a pretty easy way to allow this future
flexibility.

> > * For Tegra, I elected to put the definitions of pins, groups, and
> > functions into the driver rather than in the device tree.
>
> IMO, we do not want to do this for imx, as I'm scared of the size
> of Tegra pinctrl patches.  If we go this way for imx, we will have
> even bigger patches.

Now you're confusing me! In one of your answers above, you said:

  > >           /* FIXME: Perhaps need pin nodes here to name them too */
  > No, it's been listed in imx pinctrl driver.

So it sounds like the raw HW capabilities /are/ being enumerated by the
pinctrl driver and not device tree, which is exactly what I was saying
I'd chosen for Tegra. Well, with the exception that IMX's pinctrl driver
doesn't define groups, since the HW doesn't mux in groups.

Perhaps you're talking about enumerating groups of pins, which don't
really exist in HW. I wasn't.

> > This avoids
> > parsing a heck of a lot of data from device tree. That means there isn't
> > any per-function node that can be referred to by phandle. Does it make
> > sense to refer to groups and functions by string name or integer ID
> > instead of phandle? Perhaps:
> >
> > usdhc@0219c000 { /* uSDHC4 */
> >     fsl,card-wired;
> >     status = "okay";
> >     pinmux = {
> >             group@0 {
> >                     group = "foo";
> >                     function = "uart3";
> >                     /* You could add pin config options here too */
> >             };
> >             group@1 {
> >                     group = "baz";
> >                     function = "uart4";
> >             };
> >     };
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
> >     fsl,card-wired;
> >     status = "okay";
> >     pinmux = {
> >             group@0 {
> >                     group = <IMX_PINGRP_FOO>;
> >                     function = <IMX_PINFUNC_UART3>;
> >                     /* You could add pin config options here too */
> >             };
> >             group@1 {
> >                     group = <IMX_PINGRP_BAZ>;
> >                     function = <IMX_PINFUNC_UART4>;
> >             };
> >     };
> > };

So given that IMX muxes per pin not per group of pins, that "group"
property above should really be named "pin", and the IMX_PINGRP_* values
renamed IMX_PIN_* instead.

In general, it'd be nice to come up with a binding for the users of
pinmux (i.e. the device nodes like usdhc above) that allowed them to
refer to what I've been calling "muxable entity". perhaps instead of
"pin" or "group" the property should be called "mux-point", and it's
up to the pinctrl driver to interpret that as a pin or group ID based
on what its muxable entities are.

> Doing this does not change the fact that this is bound with Linux
> driver details.  That said, if the indexing of either pingrp array
> or pinfunc array changes in the driver, the binding is broken.

I don't agree here.

Having a driver state that it wants "pin P" or "group G" to be programmed
to "mux function F" is very purely HW oriented.

The fact this so closely aligns with the data model that the pinctrl
subsystem uses is simply because I pushed for the same pure HW oriented
data model in the pinctrl subsystem; both models were derived from how
the HW works, rather than the binding being derived from the driver.

Equally, the binding for the individual pin mux HW will define what the
integer values for pin/group/function are. In practice, we will choose
the values that the Linux pinctrl driver uses to remove the need for
conversion when parsing the device tree. However, we should be very aware
that the binding is what specifies the values, not the driver, so if the
driver changes its internal representation, it must add conversion code
when parsing the device tree, not require the device tree to change.

That said, I don't see why the pinctrl driver would change its pin, group,
or mux function numbering scheme for a given SoC; the HW is fixed, right?
(Well, for shipping HW, and designs-in-progress can presumably handle some
churn in the device tree binding specification during RTL development
or layout)

If there's a bug in the list of pins/groups/functions, that's probably
also a bug in the device tree binding too, not an arbitrary change, so
it seems fine to fix that, hopefully in as backwards-compatible way as
possible though, i.e. adding missing entries to the end of the list so
there's no renumbering etc. this is unlikely to happen late in the game.

--
nvpublic

