Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab2F0K3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:29:01 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:48426 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab2F0K27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:28:59 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/A8R4kqWPQKZ/yMrx3MwQi
Date: Wed, 27 Jun 2012 03:28:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: Add one-register-per-pin type device tree
 based pinctrl driver
Message-ID: <20120627102851.GC3483@atomide.com>
References: <4FDA6FCD.1020605@wwwdotorg.org>
 <20120615094938.GQ12766@atomide.com>
 <4FDB6000.5080703@wwwdotorg.org>
 <20120618055036.GU12766@atomide.com>
 <20120619135600.GX12766@atomide.com>
 <4FE39C86.5070901@wwwdotorg.org>
 <20120622083955.GZ12766@atomide.com>
 <4FE4AC40.8080400@wwwdotorg.org>
 <20120626134319.GA3483@atomide.com>
 <4FE9EBEC.9040208@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE9EBEC.9040208@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [120626 10:10]:
> On 06/26/2012 07:43 AM, Tony Lindgren wrote:
> ...
> > Subject: [PATCH] pinctrl: Add one-register-per-pin type device tree based pinctrl driver
> > 
> > Add one-register-per-pin type device tree based pinctrl driver.
> > 
> > This driver has been tested on omap2+ series of processors,
> > where there is either an 8 or 16-bit padconf register for each pin.
> > Support for other similar pinmux controllers can be added.
> 
> > diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> 
> > +/* board specific .dts file */
> > +
> > +&pmx_core {
> 
> > +	board_pins: pinmux_board_pins {
> > +		pinctrl-single,pins = <
> > +			0x6c 0xf	/* csi21_dx3 OUTPUT | MODE7 */
> > +			0x6e 0xf	/* csi21_dy3 OUTPUT | MODE7 */
> > +			0x70 0xf	/* csi21_dx4 OUTPUT | MODE7 */
> > +			0x72 0xf	/* csi21_dy4 OUTPUT | MODE7 */
> 
> If you're removing the pinconf mask, I think the comments in the example
> should reflect just setting a particular mux function, and remove any
> references to pinconf settings in that field. While the binding can be
>  abused to do that, I think the docs shouldn't encourage it:-)

I can certainly leave it out of the binding doc :)

The pinconf part is essential for the driver to work at least in
the omap2/3/4 cases though, so as long as people are OK with that it
works for me. If people don't like this, then it's probably best to
just add back the separate pinconf mask.

> Other than that, the binding looks reasonable to me, given what it's
> intended to do.
> 
> However, I'd still like Grant and Rob (and any other DT experts) to
> explicitly sign off on this binding, because it's doing exactly
> something that was rejected at Linaro Connect in February (albeit the
> binding is slightly more oriented at specifically being for pinmux
> rather than a fully general "blast in these register values", but that
> distinction seems minor to me).

Just for the record, another alternative I thought about is to
describe mux register bits a bit like the suggested clock framework
binding does.

The problem trying to define named pin states is that we need to
add new column for any pinconf value that may be orred together
with other pinconf values.

Currently there are pinconf settings for active pin states and off
mode pin states. And there is wake-up enable setting. So that would
be a total of five columns already per pin with the offset and mux
function.. Then if something new gets added, let's say signal
strength, we'll be needing yet another column.

To me it seem we should rather count on the preprocessor to handle
cases like this eventually. Otherwise we'll end up with bloated DT
data that becomes slow to parse.

The analogy here that I think is closest to this binding is the
keymap binding. In this case the mux data is basically just a map
of few hundred board specific pin settings.

Just for an example, below is what it would look like for omaps
using names to map out the register bits. There are eight functions
for each register. Then there are four active pinconf settings,
and six off mode pinconf settings that make sense. And then there's
the wakeup enable setting.

Regards,

Tony

pmx_core: pinmux@4a100040 {
	compatible = "pinctrl-single";
	reg = <0x4a100040 0x0196>;
	#address-cells = <1>;
	#size-cells = <0>;
	pinctrl-single,register-width = <16>;

	/* 8 available pinmux functions */
	mode0: pinctrl_mode0 {
		pinctrl-single,function = <0>;
		pinctrl-single,mask = <0x7>;
	};

	mode1: pinctrl_mode1 {
		pinctrl-single,function = <0x1>;
		pinctrl-single,mask = <0x7>;
	};

	mode2: pinctrl_mode2 {
		pinctrl-single,function = <0x2>;
		pinctrl-single,mask = <0x7>;
	};
	...
	mode7: pinctrl_mode7 {
		pinctrl-single,function = <0x7>;
		pinctrl-single,mask = <0x7>;
	};

	/* 4 active state pinconf settings */
	pin_output: pinctrl_pin_output {
		pinctrl-single,pinconf = <0>;
		pinctrl-single,mask = <0x1f8>;
	};

	pin_input: pinctrl_pin_input {
		pinctrl-single,pinconf = <0x20>;
		pinctrl-single,mask = <0x1f8>;
	};

	pin_input_pullup: pinctrl_pin_input_pullup {
		pinctrl-single,pinconf = <0x23>;
		pinctrl-single,mask = <0x1f8>;
	};

	pin_input_pulldown: pinctrl_pin_input_pulldown {
		pinctrl-single,pinconf = <0x21>;
		pinctrl-single,mask = <0x1f8>;
	};

	/* 5 off mode pinconf settings */
	pin_off_none: pinctrl_pin_off_none {
		pinctrl-single,pinconf = <0>;
		pinctrl-single,mask = <0x7e00>;
	};

	pin_off_output_high: pinctrl_pin_off_output_high {
		pinctrl-single,pinconf = 0xb;
		pinctrl-single,mask = <0x7e00>;
	}
	...

	/* wake-up capability */
	pin_off_wakeup_ena: pinctrl_pin_off_wakeup_ena {
		pinctrl-single,pinconf = 0xb;
		pinctrl-single,mask = <0x8000>;
	}

};

&pmx_core {
	uart2_pins: pinmux_uart2_pins {
		pinctrl-single,pins = <
			0xd8 &mode0 &pin_input_pullup &off_mode_none 0
			0xda &mode0 &pin_output &off_mode_none 0
			0xdc &mode0 &pin_input_pullup &off_mode_none &pin_off_wakeup_ena
			0xde &mode0 &pin_output &off_mode_none 0
		>;
	};
};
