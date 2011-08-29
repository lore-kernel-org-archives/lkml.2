Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1H2Vqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:46:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3707 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab1H2Vqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:46:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 29 Aug 2011 14:46:10 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Date: Mon, 29 Aug 2011 14:46:00 -0700
Subject: RE: [PATCH v3 10/13] of: add a generic pinmux helper
Thread-Topic: [PATCH v3 10/13] of: add a generic pinmux helper
Thread-Index: AcxmPBq8D8cHsnrlS56ijPyMbiplzwAV3PNQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B3279BEB@HQMAIL01.nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
	<1314315824-9687-11-git-send-email-swarren@nvidia.com>
 <CACRpkdaTiWEtgjVOhUKeXhpiESvrWyz97p5j_PHe3MvEM4UaCw@mail.gmail.com>
In-Reply-To: <CACRpkdaTiWEtgjVOhUKeXhpiESvrWyz97p5j_PHe3MvEM4UaCw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Monday, August 29, 2011 5:09 AM:
> On Fri, Aug 26, 2011 at 1:43 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > diff --git a/drivers/of/of_pinmux.c b/drivers/of/of_pinmux.c
> 
> > +int of_pinmux_parse(const struct of_pinmux_ctrl *ctrl,
> > +                   struct of_pinmux_cfg *cfg)
> 
> OK...
> 
> > +{
> > +       struct device_node *np;
> > +
> > +       if (!ctrl || !ctrl->dev || !ctrl->node || !ctrl->configure)
> > +               return -EINVAL;
> > +
> > +       for_each_child_of_node(ctrl->node, np) {
> > +               int ret;
> > +               bool hadpins = 0;
> > +               struct of_iter_string_prop iter;
> > +
> > +               cfg->node = np;
> > +
> > +               ret = of_property_read_string(np, "function",
> > +                                             &cfg->function);
> > +               if (ret < 0) {
> > +                       dev_err(ctrl->dev, "no function for node %s\n",
> > +                               np->name);
> > +                       continue;
> > +               }
> 
> I buy this part.
> 
> > +
> > +               cfg->flags &= 0;
> > +
> > +               if (of_find_property(np, "pull-up", NULL))
> > +                       cfg->flags |= OF_PINMUX_PULL_UP;
> > +               if (of_find_property(np, "pull-down", NULL))
> > +                       cfg->flags |= OF_PINMUX_PULL_DOWN;
> > +
> > +               if ((cfg->flags & OF_PINMUX_PULL_MASK) ==
> > +                   OF_PINMUX_PULL_MASK) {
> > +                       dev_warn(ctrl->dev, "node %s has both "
> > +                                "pull-up and pull-down properties - "
> > +                                "defaulting to no pull\n",
> > +                                np->name);
> > +                       cfg->flags &= ~OF_PINMUX_PULL_MASK;
> > +               }
> > +
> > +               if (of_find_property(np, "tristate", NULL))
> > +                       cfg->flags |= OF_PINMUX_TRISTATE;
> 
> But what does this stuff has to do with pinmux?
> 
> I call this "pin biasing" and it has very little to do with muxing.
> 
> If a broader, generic term is to be used, I'd prefer "pin control"
> which sort of nails the thing.
> 
> > +               for_each_string_property_value(iter, np, "pins") {
> > +                       hadpins = 1;
> > +
> > +                       cfg->pin = iter.value;
> > +
> > +                       dev_dbg(ctrl->dev,
> > +                               "configure pin %s func=%s flags=0x%lx\n",
> > +                               cfg->pin, cfg->function, cfg->flags);
> > +                       if (ctrl->configure(ctrl, cfg))
> > +                               dev_warn(ctrl->dev,
> > +                                        "failed to configure pin %s\n",
> > +                                        cfg->pin);
> > +               }
> > +
> > +               if (!hadpins)
> > +                       dev_warn(ctrl->dev, "no pins for node %s\n",
> > +                                np->name);
> > +       }
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(of_pinmux_parse);
> 
> Renamed of_pinctrl_parse I'm happier with it.

Well, it's not just that; the struct contains the function field to
select for each pingroup, so it's not just pinctrl either.

> > +/**
> > + * struct of_pinmux_cfg - configuration state for a single pinmux entry.
> > + *
> > + * @function: the name of the function that the pinmux entry should be
> > + *     configured to.
> > + * @pin: the device_node of the pinmux entry that should be configured.
> > + *     Platform specific properties that aren't in the generic binding may be
> > + *     obtained from this device node.
> > + * @flags: flags for common pinmux options such as pull and tristate.
> 
> I don't think these things has anything to do with pinmux at all.
> 
> But with the struct renamed of_pinctrl_cfg I'm again happier.
> 
> > + */
> > +struct of_pinmux_cfg {
> > +       struct device_node      *node;
> > +       const char              *pin;
> > +       const char              *function;
> > +       unsigned long           flags;
> > +};
> 
> The current pinctrl patch set would probably want an unsigned
> "position" attribute too. (If we should build on that.)

This does beg the question I asked previously:

The intent of this patch was to provide a way for devicetree to set the
complete initial state of the pinmux, in a SoC-specific fashion, without
interaction with the pinmux API.

However, I'm guessing you see the pinmux driver as not touching HW at
boot at all, and never programming anything except in response to a
driver calling pinmux_get()/pinmux_enable()?

In the former case, this code and related bindings wouldn't be influenced
by the pinmux API at all (and indeed arguably never should be, since DT
is supposed to be oriented purely at HW, and not influenced by driver
design). This approach might make the pinmux API mostly relevant only
for drivers that actively change between configurations at run-time, and
not for drivers that don't need dynamic muxing.

However, in the latter case, this code should be part of the pinmux core,
and my patches to Tegra's pinmux driver dropped. It'd be difficult to
define a pinmux binding that wasn't influenced by the pinmux API's needs
in this case.

So, that's probably something we have to resolve first.

-- 
nvpublic

