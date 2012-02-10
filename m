Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab2BJUFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:05:10 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52949 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab2BJUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:05:08 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18vcCnIj2nLI+cI9NXUEYx/
Date: Fri, 10 Feb 2012 12:05:03 -0800
From: Tony Lindgren <tony@atomide.com>
To: Dong Aisheng <dongas86@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 2/2] pinctrl: Add simple pinmux driver using device
 tree data
Message-ID: <20120210200503.GX1426@atomide.com>
References: <20120203205049.4089.74610.stgit@kaulin.local>
 <20120203205508.4089.35304.stgit@kaulin.local>
 <20120204175903.GF1426@atomide.com>
 <CAA+hA=Tux3P0RyaB=vG7UeycTt8z4nX9dBicpjB7tQ+xzwoSDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA+hA=Tux3P0RyaB=vG7UeycTt8z4nX9dBicpjB7tQ+xzwoSDQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong,

* Dong Aisheng <dongas86@gmail.com> [120207 17:22]:
> On 2/4/12, Tony Lindgren <tony@atomide.com> wrote:
>
> The most difference may be the function enable due to hw difference.
> But i see that for DT case, it seems function and group creation may
> also be a problem.

What all do you see as a problem with group creation? Just the
naming?

> > +/**
> > + * smux_add_pin() - add a pin to the static per controller pin array
> > + * @smux: smux driver instance
> > + * @offset: register offset from base
> > + */
> > +static int __init smux_add_pin(struct smux_device *smux, unsigned offset)
> > +{
> > +	struct pinctrl_pin_desc *pin;
> > +	struct smux_name *pn;
> > +	char *name;
> > +	int i;
> > +
> > +	i = smux->pins.cur;
> Can we drop cur if it's only temply used for add pin.

Yes I think so, the pins should be static and added at once during
the init. If you have other sets of pins, then they should probably
be separate driver instances. So we should be able to get rid of it.
 
> > +	sprintf(name, "%lx",
> > +		(unsigned long)smux->res->start + offset);
> > +	pin->name = name;
> I'm wondering how about other people do not want the reg address to be PIN name?
> It's less meaningful.

How about try adding optional pinctrl-simple,pin-name entry that you
can add to each mux entry?

The generic plan is to make the names optional in pinctrl framework,
and then expose the register addresses for future user space debug
tools. So you may end up noticing that the pinctrl-simple.c driver
probably does not even need to care about the names.
 
> > +static int __init smux_allocate_pin_table(struct smux_device *smux)
> > +{
> > +	int mux_bytes, i;
> > +
> > +	mux_bytes = smux->width / BITS_PER_BYTE;
> > +	smux->pins.max = smux->size / mux_bytes;
> > +
> The main issue for IMX to use this driver is that IMX pins number can
> not be calculated in this way
> since the imx pin controller reg range contains mux reg range and
> config reg range as well as a few other misc registers
> And it seems it's also not fit for Tegra since Tegra2's one register
> may involve many pins.
> This may need some proper way to fix.

Well maybe take a look adding support for wider #pinmux-cells?

So far I was thinking we could have:

/* one mux register for each pin */
#pinmux-cells = <2>;

/* three mux registers for each pin */
#pinmux-cells = <6>;
...

Note that for more complex mapping you may want to add a hardware
specific .data entry that corresponds to the compatible flag, let's
say for conf range offset to mux range offset.
 
> > +		res = smux_rename_function(function, np->full_name);
> A little unclear for rename here.
> Can we find a better way?

You might want to play with parsing optional names from .dts file.
I don't need the names and they slow down the parsing. For the names,
we can show them with userspace tools using debugfs.

For reference, this is what I get under debugfs function entry
after the rename:

function: /ocp/serial@0x48020000, groups = [ pinconfig-uart3 ]

> > +static int __init smux_parse_one_pinctrl_entry(struct smux_device *smux,
> > +                                           struct device_node *np)
> > +{
> > +   int count = 0;
> > +
> > +   do {

...
 
> > +	} while (++count);
> This 'while' is for what? Define multi pinctrl properties?

Yes each client device might request multiple muxes, let's say
two pingroups from two different pinctrl driver instances.
 
> > +/**
> > + * smux_load_mux_register() - parses all the device tree mux entries
> > + * @smux: smux driver instance
> > + */
> > +static int __init smux_load_mux_registers(struct smux_device *smux)
> > +{
> > +	struct device_node *np;
> > +	int ret;
> > +
> > +	for_each_child_of_node(smux->dev->of_node, np) {
> > +		ret = smux_parse_one_pinmux_entry(smux, np);
> > +	}
> > +
> > +	for_each_node_with_property(np, PMX_PINCTRL_NAME) {
> > +		ret = smux_parse_one_pinctrl_entry(smux, np);
> 
> Can we put this in pinctrl core?
> Just like something mentioned in my last proposal that pinctrl core
> does the common pinmux node search, pinmux map table process and
> register.
> https://lkml.org/lkml/2012/2/3/276
> That could be a very easy and flexible pinctrl binding.

Yes to summarize what we've discussed for people who have not
been at the conference this week: The idea is the have a generic
functions for the common bindings. Then have separate driver
specific bindings.
 
> > +	val = of_get_property(pdev->dev.of_node,
> > +				"pinctrl-simple,register-width", &len);
> Is there any reason not use of_property_read_u32 here? It may reduce some code.

Hmm yes I guess u32 should be plenty for the register width :)
 
> > +	val = of_get_property(pdev->dev.of_node,
> > +				"pinctrl-simple,function-off", &len);
> > +	if (!val || len != 4) {
> > +		dev_err(smux->dev, "function off mode not specified\n");
> > +		ret = -EINVAL;
> How about other SoCs not support function off mode?

Maybe disable should not do anything if function-off is not specified?
 
> > +free:
> > +	devm_kfree(smux->dev, smux);
> > +
> For devm_* routines, do you still need this error checking?
> IIRC, the resource will be automatically released if probe failed.

I guess, are there some recommendations somewhere for that?

Also, most of the string copying can be avoided if we use the
read-only strings in DT, and then have a separate optional name
that can be allocated.

Regards,

Tony 
