Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2EXFRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 01:17:11 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14271 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891Ab2EXFRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 01:17:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VS-13(zzbb2dI9371I1521I1432N1418I98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah)
Date: Thu, 24 May 2012 13:19:47 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng <dongas86@gmail.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH RFC v3 3/3] pinctrl: add pinctrl gpio binding support
Message-ID: <20120524051946.GA14953@shlinux2.ap.freescale.net>
References: <1337779362-31259-1-git-send-email-b29396@freescale.com>
 <1337779362-31259-3-git-send-email-b29396@freescale.com>
 <4FBD4C13.8080209@wwwdotorg.org>
 <CAA+hA=Rb1Qix67QBthPjo_4d5ATWjA7pePembZRwJkPMtQNpjg@mail.gmail.com>
 <4FBDBC2B.3090300@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FBDBC2B.3090300@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:42:19PM +0800, Stephen Warren wrote:
> On 05/23/2012 07:42 PM, Dong Aisheng wrote:
> > On Thu, May 24, 2012 at 4:44 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >> On 05/23/2012 07:22 AM, Dong Aisheng wrote:
> >>> From: Dong Aisheng <dong.aisheng@linaro.org>
> >>>
> >>> This patch implements a standard common binding for pinctrl gpio ranges.
> >>> Each SoC can add gpio ranges through device tree by adding a gpio-maps property
> >>> under their pinctrl devices node with the format:
> >>> <&gpio $gpio_offset $pin_offset $npin>.
> >>>
> >>> Then the pinctrl driver can call pinctrl_dt_add_gpio_ranges(pctldev, node)
> >>> to parse and register the gpio ranges from device tree.
> >>>
> >>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> >>
> >> This is mostly good. Just a few comments:
> >>
> >>> +gpio-maps: 4 integers array, each entry in the array represents a gpio
> >>> +range with the format: <&gpio $gpio_offset $pin_offset $count>
> >>> +- gpio: phandle pointing at gpio device node
> >>> +- gpio_offset: integer, the local offset of $gpio
> >>> +- pin_offset: integer, the pin offset or pin id
> >>> +- npins: integer, the gpio ranges starting from pin_offset
> >>
> >> This uses a single cell to represent a GPIO ID within a GPIO controller.
> >> The standard GPIO bindings use #gpio-cells, where that's a property in
> >> the GPIO controller's node. I wonder if we shouldn't do the same here,
> >> and call into the GPIO driver to parse #gpio-cells and give back the
> >> Linux GPIO ID, just like of_get_named_gpio_flags() does. This would also
> >> make this code able to cope with the GPIO of_xlate function returning a
> >> different GPIO chip, which Grant put in place for banked GPIO controllers.
> >>
> > I checked the code, the second cell only represents gpio flag in
> > of_gpio_simple_xlate which seems meaningless to pinctrl, so it looks
> > increase overhead to pinctrl gpio ranges map.
> 
> With the simple translation function, yes it's just flags. However, not
> all GPIO controllers use the simple translation function; I think I
> recall the Exynos binding having 4 or 5 cells. In other words, the
> format is defined by each individual GPIO controller, even if many/most
> do happen to follow the same format.
> 
Correct, it should be SoC dependent.

> > However, it seems i may have to agree that we need keep align with the
> > exist of gpio design to use the standard way to get gpio number via
> > of_xlate function rather than do it privately in pinctrl driver.
> > 
> > One disadvantage is that i can not reuse of_get_named_gpio_flags due
> > to different format
> > for gpio-maps, i may have to write a slightly different one as
> > of_get_named_gpio_flags
> > for gpio-maps.
> > 
> >>> diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
> >>
> >>> +int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,
> >>
> >> The locking I was talking about before is between the following line:
> >>
> >>> +             ranges[i].gc = of_node_to_gpiochip(np_gpio);
> >>
> >> and this code:
> >>
> >>> +             ranges[i].name = dev_name(pctldev->dev);
> >>> +             ranges[i].base = ranges[i].gc->base + gpio_offset;
> >>> +             ranges[i].pin_base = pin_offset;
> >>> +             ranges[i].npins = npins;
> >>
> >> If of_node_to_gpiochip() doesn't mark the GPIO chip as "in use", then
> >> the module that provides that device could be unloaded between the two
> >> blocks of code above.
> >>
> > Correct.
> > 
> >> Re: your locking comments in your other email: ranges[i].gc doesn't
> >> appear to be used anywhere else in pinctrl, so I think it's OK not to
> >> lock the GPIO chip for any more time than between the above two blocks
> >> of code.
> >>
> > So i will add lock between them like:
> > ranges[i].gc = of_node_to_gpiochip(np_gpio);
> > if (!try_module_get(ranges[i].gc->owner))
> >     err...
> 
> I think that module_get() needs to happen inside of_node_to_gpiochip(),
> so that it executes inside any lock that function takes.
Can you please help explain a bit more?
I did not quite understand.
It looks to me of_node_to_gpiochip is only convert the gpio node to gpio chip.
Why need get the module inside this function?
For gpio_request function, it also calls try_module_get(gc) after find the gpio
chip.

> 
> > ranges[i].name = dev_name(pctldev->dev);
> > ranges[i].base = ranges[i].gc->base + gpio_offset;
> > ranges[i].pin_base = pin_offset;
> > ranges[i].npins = npins;
> > module_put(ranges[i].gc->owner)
> > If anything wrong please let me know.
> > 
> >> Finally, just a minor nit:
> >>
> >>> +             ranges[i].gc = of_node_to_gpiochip(np_gpio);
> >>> +             if (!ranges[i].gc) {
> >>> +                     dev_err(pctldev->dev,
> >>> +                             "can not find gpio chip of node(%s)\n",
> >>> +                             np_gpio->name);
> >>> +                     of_node_put(np_gpio);
> >>> +                     return -EPROBE_DEFER;
> >>> +             }
> >>> +
> >>> +             of_node_put(np_gpio);
> >>
> >> could be slightly simpler:
> >>
> >> +               ranges[i].gc = of_node_to_gpiochip(np_gpio);
> >> +               of_node_put(np_gpio); <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
> >> +               if (!ranges[i].gc) {
> >> +                       dev_err(pctldev->dev,
> >> +                               "can not find gpio chip of node(%s)\n",
> >> +                               np_gpio->name);
> > Because here still uese np_gpio,  Can i still use it after of_node_put?
> 
> Oh right, that makes sense, yes.
> 
I guess you mean no(can not use the node after of_node_put), right?

Regards
Dong Aisheng

