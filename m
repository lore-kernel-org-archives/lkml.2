Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab2AUB1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 20:27:46 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40757 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab2AUB1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 20:27:44 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB475@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
	<CAJuYYwQoh4_SnA9wmy4x+cG0w0hGukxTkODWtcSw_2QHYuDsrg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1780DAB475@HQMAIL01.nvidia.com>
Date: Sat, 21 Jan 2012 06:57:43 +0530
Message-ID: <CAJuYYwTOW7wOTA-a4q1aL7XvnnrXWa6Cp9vRnNAmQZ-9aBHo4A@mail.gmail.com>
Subject: Re: Pinmux bindings proposal
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 21 January 2012 02:41, Stephen Warren <swarren@nvidia.com> wrote:
> Thomas Abraham wrote at Thursday, January 19, 2012 6:10 AM:
>> On 14 January 2012 02:09, Stephen Warren <swarren@nvidia.com> wrote:
>> > I thought a bit more about pinmux DT bindings. I came up with something
>> > that I like well enough, and is pretty similar to the binding that Dong
>> > posted recently. I think it'll work for both Tegra's and IMX's needs.
>> > Please take a look!
>> >
>> > Note: I've used named constants below just to make this easier to read.
>> > We still don't have a solution to actually use named constants in dtc yet.
>>
>> [...]
>>
>> For Samsung io-pad controllers, I had been considering a dt approach
>> which has been described below. Kindly review and any comments will be
>> helpful.
>>
>>
>> * Main points to be considered:
>>
>> All Samsung SoC's use a io-pad controller that includes gpio, pinmux
>> and pinconfig functionality in a single controller, i.e. there is a
>> single intermixed address space for gpio/pinmux/pinconfig portions in
>> the controller. Additionally, all the drivers for the Samsung SoC's
>> setup pinmux/pinconfig in its probe function (and in resume if
>> required).
>>
>>
>> * IO Pad controllers in dts file:
>>
>> The io-pad controller (gpio/pinmux/pinconfig) can be represented in a
>> dtsi file as below. There could be multiple io-pad controllers
>> supported in the system.
>>
>> pctrl0: pinctrl@11400000 {
>>        compatible = "samsung,exynos4210-pinctrl";
>>        reg = <0x11400000 0x1000>;
>>        interrupts = <.......>;
>>        pin-banks = <....>;
>>        [... other properties TBD ...]
>>        #pinctrl-cells = <5>;
>> };
>>
>> Each such node instantiates one instance of the pin-controller device.
>> The 'struct pinctrl_dev' should include a new member 'struct of_node'
>> to point to the corresponding pin-controller node in dt which
>> instantiated the controller. The pinctrl_register() function called
>> from drivers/pinctrl/pinctrl-xyz.c then registers the pin-controller
>> instance.
>>
>
> Yes, that's all reasonable, and exactly what I had in mind when I wrote
> my binding proposal.
>
>> * Specifying the pinmux/pinconfig settings in dts files:
>>
>> Device nodes which require specific pinmux/pinconfig settings should
>> include information about the required settings. For example, a i2c
>> controller node in dts file is listed below.
>>
>> i2c0: i2c@18000000 {
>>         [... other properties ...]
>>         pinctrl-active = <&pctrl0 5 0 2 3 0>,
>>                              <&pctrl0 5 1 2 3 0>;
>>         pinctrl-suspend = <&pctrl0 5 0 2 0 0>,
>>                                 <&pctrl0 5 1 2 0 0>;
>> };
>
> The idea of encoding the state names into the property names came up
> before in this thread.

Yes, I did borrow the idea of states 'active' and 'suspend' from the
dt binding discussions here. The current Samsung mainline dt support
for gpio and pinmux is using this type of encoding but did not have
the states.

> The problem is that it's hard for core code
> to know which properties are actually related to pinctrl and which
> aren't. reserving one name such as "pinctrl" seems reasonable, whereas
> reserving a whole class of names; everything prefixed "pinctrl-foo" is
> a little less so.

The basic premise with which I proposed about the dt support for pinctrl was

- The pinctrl core code does not have to know anything about these
bindings inside device nodes (of say i2c).

- Device drivers (such as i2c) retrieve the value of pinctrl-*
property and pass on two parameters to the pinctrl code.
  (a) The 'struct device_node' pointer of the intended pinctrl_dev
instance (obtained from the phandle above).
  (b) The encoding that specifies the hardware register values.

- Pinctrl core scans its list for all registered pinctrl_dev, matches
it against the 'device node' specified and selects one of the
pinctrl_dev. It then passes on the second parameter to the pinctrl
driver which decodes it and writes appropriate values to the hardware
registers.

- pinmux/pinconfig/pindesc tables are not built from DT. There are no
static tables built into the SoC specific pinctrl driver.

Detailed steps on how this can be handled (from driver getting hold of
pinctrl-* property till hardware registers getting programmed) is
listed in the previous email.

>
> If the parsing of these nodes were a direct result of a driver calling
> pinmux_get("name") or similar, this might be less relevant. However,
> there's a desire to parse all the pinmux properties/nodes up-front so
> that the pinctrl pinmux mapping table can be completely populated early
> during boot, and hence contain all pinmux information, just as if that
> mapping table were registered from static tables by a board file in the
> non DT case. So, being certain what's a pinctrl node/property without
> information on the state names drivers will use is important.

Yes, that is true if the pinmux/pinconfig tables are built from DT.
But it would be easier if no tables are built.

>
>> In the example above, the specifier of pinctrl-* is specific for
>> Samsung io-pad controllers. Its format/syntax would be mainly
>> dependent on the io-pad controller used, the above is only an example
>> for Samsung io-pad controller. In the above node, the format of the
>> pinctrl-* specifier is
>>
>> property-name = <phandle of the pin-controller
>>                            pin bank within the pin-controller
>>                            pin number within the pin-bank
>>                            pin-mux function number
>>                            pull up/down config
>>                            drive strength config>;
>
> Yes, that seems reasonable.
>
> The only thing different between that example and my proposal is that:
>
> a) In my proposal, the property in the device nodes doesn't actually
>   contain all those fields, but a phandle to a child node of the pin
>   controller where that data is kept. This keeps all the pin mux data
>   stored under the pin controller's node for neatness.

I am not sure if that is required. In case dt support for interrupt
controller such as gic, the interrupt number, type of interrupt and
edge/level type flags are all listed in the device node itself and not
under the gic device node.

>
>   Thus, there's 1 extra level of indirection.
>
>   This allows common sets of values to be defined and the device
>   nodes can simply reference this, rather than cut/pasting the data
>   into every board file that uses the same configuration.

Yes, that is true. I also had the same concern on this.

>
>   (Well, I actually proposed that referenced node could be anywhere,
>   but others were insistent it should only be allowed under the pin
>   controller node)
>
> b) I didn't actually include a #pinctrl-cells property in my proposal,
>   assuming that a fixed-format would be acceptable for these properties.
>   However, I will include such a property in my V2 proposal.
>
>> * Using the pinmux/pinconfig specifier in device nodes to configure hardware.
>>
>> A driver (for a device instantiated from device tree) would require
>> code to be made aware of the pinmux/pinconfig options available. The
>> typical sequence in a probe function would be as below.
>>
>> (a) call of_get_named_gpio() to get the gpio number. In case of
>
> Not everything is a GPIO in all SoCs, so initiating pin mux configuration
> from of_get_named_gpio() doesn't really make sense.

Right, I was mainly writing about what can be done for Samsung
platforms. Other platforms can opt to do things differently. But what
is important here is, the ability in pinctrl core to identify a
pinctrl driver which can decode the bindings and have it program the
registers.

>
> The pinctrl subsystem already has APIs such as pinmux_get() and
> pinmux_enable() that initiating pin mux programming, so I've been
> assuming they'd be used identically for both systems that use board
> files and systems that use DT.
>

In case of DT based boot, the code that handles the device node
containing pinctrl-* (either device driver or platform code) need not
call the pinmux_get(). The encoding in the pinctrl-* (as listed above)
is sufficient to setup the pinmux/pinconfig as required.

> ...
>> (d) For all entries in pinctrl-* property, use
>> of_parse_phandles_with_args() and get the pinctrl node pointer and the
>> pinctrl specifier. As an example, the i2c driver would do the
>> following, incrementing pin-index parameter for each call.
>>
>> ret = of_parse_phandle_with_args(i2c_np, "pinctrl-active",
>> "#pinctrl-cells", pin-index, &pctrl_np, &pctrl_specifier);
>>
>> (e) There should be a new api in pinctrl subsystem whose signature
>> could be something like
>>
>> int pinctrl_dt_parse_and_set_mux_cfg(struct device_node *, const void *);
>>
>> For each iteration of step (d) in the driver, this new api will be
>> called. The value of pctrl_np and pctrl_specifier obtained from step
>> (d) is passed as a parameters to this new api. This api will do the
>> following
>>
>> (e1) Find the pin-controller (struct pinctrl_dev) that has a
>> device_node pointer which is same as the first parameter. To recap, it
>> was mentioned above that: "The 'struct pinctrl_dev' should include a
>> new member 'struct of_node' to point to the corresponding
>> pin-controller node in dt which instantiated the controller."
>>
>> (e2) A new callback 'xlate_pinctrl' is required in 'struct
>> pinctrl_ops' which can translate the second parameter of
>> 'pinctrl_dt_parse_and_set_mux_cfg' function. From the pin controller
>> found in step (e1), call pinctrl_dev->desc->pctlops->xlate_pinctrl
>> passing the second parameter of 'pinctrl_dt_parse_and_set_mux_cfg'
>> function. The pin-controller specific translator function will
>> translate the parameter and program the hardware registers. The
>> xlate_pinctrl is specific to each pin-controller is it knows how to
>> decode the specifier and program the registers.
>
> But yes, I'd expect much of those mechanics to be used roughly as you
> describe, just initiated by other APIs; some DT-wide parsing of the
> pinmux properties at either system boot time or pin controller
> registration time, and application of the data during pinmux_get().
>
> --
> nvpublic
>

Thanks for having a look on this.

Regards,
Thomas.
