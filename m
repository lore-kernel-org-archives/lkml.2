Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2BMTLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:11:20 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64881 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab2BMTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:11:18 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+JRzCmjzwiFnd3lvUXRT1K
Date: Mon, 13 Feb 2012 11:11:13 -0800
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
Message-ID: <20120213191113.GF1426@atomide.com>
References: <20120203205049.4089.74610.stgit@kaulin.local>
 <20120203205508.4089.35304.stgit@kaulin.local>
 <20120204175903.GF1426@atomide.com>
 <CAA+hA=Tux3P0RyaB=vG7UeycTt8z4nX9dBicpjB7tQ+xzwoSDQ@mail.gmail.com>
 <20120210200503.GX1426@atomide.com>
 <CAA+hA=Qa_3vXvgNMRuDjw93Wb3fGNOM1EqmvYVQO5CN9w2FA3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA+hA=Qa_3vXvgNMRuDjw93Wb3fGNOM1EqmvYVQO5CN9w2FA3A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dong Aisheng <dongas86@gmail.com> [120210 16:02]:
> Hi Tony,
> 
> On Fri, Feb 10, 2012 at 12:05:03PM -0800, Tony Lindgren wrote:
> > Hi Dong,
> >
> > * Dong Aisheng <dongas86@gmail.com> [120207 17:22]:
> > > On 2/4/12, Tony Lindgren <tony@atomide.com> wrote:
> > >
> > > The most difference may be the function enable due to hw difference.
> > > But i see that for DT case, it seems function and group creation may
> > > also be a problem.
> >
> > What all do you see as a problem with group creation? Just the
> > naming?
> I said from different SoC's pointer of view.
> Not only naming, but also if group and function created in driver or dt file
> and their map parsing.
> 
> > > > + sprintf(name, "%lx",
> > > > +         (unsigned long)smux->res->start + offset);
> > > > + pin->name = name;
> > > I'm wondering how about other people do not want the reg address to be PIN name?
> > > It's less meaningful.
> >
> > How about try adding optional pinctrl-simple,pin-name entry that you
> > can add to each mux entry?
> >
> Put it in pinctrl device node?
> Then how do we name each pin?
> And for IMX, currently we name all pins in driver.
> I still can not find a good reason that i should name all pins in dt file.

But do you actually need the pin names in kernel? :)

> Yes, we indeed have such a case.
> For IMX, some special pins mux still need a setting called 'select input' which
> is controlled in other registers.
> But a rough idea in my mind that may choose different way to fix this issue.
> It's a little like:
> pinctrl_usdhc4: pinconfig-usdhc4 {
>        mux =
>                <MX6Q_SD4_CMD  0 SELECT_INPUT>
>                <MX6Q_SD4_CLK  0 0>
>                <MX6Q_SD4_DAT0 1 0>
>                <MX6Q_SD4_DAT1 1 0>
>                <MX6Q_SD4_DAT2 1 SELECT_INPUT>
>                <MX6Q_SD4_DAT3 1 0>
>                <MX6Q_SD4_DAT4 1 0>
>                <MX6Q_SD4_DAT5 1 0>
>                <MX6Q_SD4_DAT6 1 0>
>                <MX6Q_SD4_DAT7 1 0>;
> }
> This format would not make the dts writer to take too much care of
> register address
> and value. For this case, the #pinmux-cells would be <3>;
> It is a little different from OMAP.

If you don't want to keep the extra register entry around, then you
could have a custom .data entry in the pinctrl driver that contains
the mapping of these special registers.

> For your proposal, I'm afraid it is a little too much depend on the SoC register
> layout. We need to find a flexible enough way to cover all possible
> register layout
> difference for all SoCs.
> (Considering one register controls multi muxs?)

Most likely those special cases are best handled in hardware specific
drivers.
 
> > Note that for more complex mapping you may want to add a hardware
> > specific .data entry that corresponds to the compatible flag, let's
> > say for conf range offset to mux range offset.
> >
> > > > +         res = smux_rename_function(function, np->full_name);
> > > A little unclear for rename here.
> > > Can we find a better way?
> >
> > You might want to play with parsing optional names from .dts file.
> > I don't need the names and they slow down the parsing. For the names,
> > we can show them with userspace tools using debugfs.
> >
> > For reference, this is what I get under debugfs function entry
> > after the rename:
> >
> > function: /ocp/serial@0x48020000, groups = [ pinconfig-uart3 ]
> >
> The name looks reasonable to me.
> 
> > > > +static int __init smux_parse_one_pinctrl_entry(struct smux_device *smux,
> > > > +                                           struct device_node *np)
> > > > +{
> > > > +   int count = 0;
> > > > +
> > > > +   do {
> >
> > ...
> >
> > > > + } while (++count);
> > > This 'while' is for what? Define multi pinctrl properties?
> >
> > Yes each client device might request multiple muxes, let's say
> > two pingroups from two different pinctrl driver instances.
> >
> You mean like this?
> serial@48020000 {
>       pinctrl = <&pmx_uart3_x>;
>       pinctrl = <&pmx_uart3_y>;
> };
> 
> Did i misunderstand?
> I still can not understand why need this.
> The pinctrl properly in device node can support multi pinmuxs .
> serial@48020000 {
>       pinctrl = <&pmx_uart3_x &pmx_uart3_y>;
> It's good to me that the consensus we reached at Linaro Connect is much like
> my proposal in above URL. :)

I meant like what you have in the second option here, the count is
used to parse each entry.
 
> > > > + val = of_get_property(pdev->dev.of_node,
> > > > +                         "pinctrl-simple,function-off", &len);
> > > > + if (!val || len != 4) {
> > > > +         dev_err(smux->dev, "function off mode not specified\n");
> > > > +         ret = -EINVAL;
> > > How about other SoCs not support function off mode?
> >
> > Maybe disable should not do anything if function-off is not specified?
> >
> IIRC currently pinctrl must need a disable function, if that, yes.
> However i think we may change it in the future that make .disable function
> optinal.

Sounds good to me.
 
> > > > +free:
> > > > + devm_kfree(smux->dev, smux);
> > > > +
> > > For devm_* routines, do you still need this error checking?
> > > IIRC, the resource will be automatically released if probe failed.
> >
> > I guess, are there some recommendations somewhere for that?
> I don't know where it is.
> I just checked the code before.
> You can see really_probe in drivers/base/dd.c.

I guess no devm_kstrdup yet though :) Anyways, most of the strings
can be the DT names directly and stay as read-only.

Tony
