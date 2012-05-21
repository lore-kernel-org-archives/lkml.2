Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2EUMgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:36:06 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:10898
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754604Ab2EUMgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:36:04 -0400
X-SpamScore: -18
X-BigFish: VS-18(zzbb2dI9371I179dN1521I1432N98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 21 May 2012 20:39:30 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Subject: Re: [PATCH RFC v2 2/2] pinctrl: add pinctrl gpio binding support
Message-ID: <20120521123929.GA27055@shlinux2.ap.freescale.net>
References: <1337346755-8761-1-git-send-email-b29396@freescale.com>
 <1337346755-8761-2-git-send-email-b29396@freescale.com>
 <4FB6AB9A.4080006@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FB6AB9A.4080006@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 04:05:46AM +0800, Stephen Warren wrote:
> On 05/18/2012 07:12 AM, Dong Aisheng wrote:
> > The gpio ranges standard dt binding format is
> > <&gpio $gpio_offset $pin_offset $npin>
> > 
> > The core will parse and register the pinctrl gpio ranges
> > from device tree.
> 
> Overall this conceptually makes sense, and looks good. Some comments though:
> 
Great, thanks Stephen.

> > +/*
> > + * pinctrl_dt_add_gpio_range() - parse and register GPIO ranges from device tree
> > + * @pctldev: pin controller device to add the range to
> > + * @np: the device node contains the property @propname
> > + * @propname: a list of phandles of gpios and corresponding data.
> > + *  The format is: <&gpio0 $gpio_offset $pin_offset $count>
> > + */
> > +int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,
> > +				struct device_node *np,
> > +				const char *propname)
> 
> If this will be fully standardized, perhaps we should just choose a
> standard property name, rather than allowing different drivers to do
> different things.
> 
> Perhaps "gpio-map"?
> 
Well, correct, this name is ok to me.

> > +	nranges = size /4;
> 
> Add a space after the /
> 
> > +	ranges = devm_kzalloc(pctldev->dev, nranges * sizeof(*ranges),
> > +				GFP_KERNEL);
> > +	for (i = 0; i < nranges; i++) {
> > +			phandle = be32_to_cpup(list++);
> 
> Looks like double indentation througout this block?
> 
Correct, will fix them in a formal patch.

> > +			np_gpio = of_find_node_by_phandle(phandle);
> > +			if (!np_gpio) {
> > +				dev_err(pctldev->dev,
> > +					"failed to find gpio node(%s)\n",
> > +					np_gpio->name);
> 
> Perhaps devm_kfree(ranges) here so that if this is called multiple times
> due to deferred probe, the allocations from the failed attempts don't
> accumulate. Same for other error paths.
> 
Correct.
Will add it.

> > +				return -ENODEV;
> > +			}
> > +
> > +			ranges[i].gc = of_node_to_gpiochip(np_gpio);
> 
> Of course, there is the outstanding question of whether this API will
> exist and how it will work.
> 
> I think you can of_node_put(np_gpio) here, before the error-check for
> ranges[i].gc, to avoid having to do it in all the error paths below.
> 
Good idea. Will do it.

> Do you need to xxx_get(ranges[i].gc) to prevent it going away, and put()
> it when removing the ranges?
> 
How would you suggest to implement xxx_get(ranges[i].gc)?
Since the parameter is a struct gpiochip, my first sense is that it may be
provided by gpio subsystem, but i did not find such a function.
Looking at gpio subsystem, i also can't see it should provide such function.

I wonder if we need to implement it, if gpiochip is gone way,
the error will be detected in the higher gpio layer and will not pass
down to pinctrl.

> > +			if (gpio_offset < 0 ||
> > +			    gpio_offset > ranges[i].gc->ngpio ||
> > +			    pin_offset < 0 || npins < 0) {
> 
> These are all unsigned, so most of those conditions can never be true.
> 
Correct, will remove negative value checking.

> Perhaps replace the remaining check with:
> 
> 	gpio_offset + npins > ranges[i].gc->ngpio
> 
Good idea, will replace above checking with this one.

> to make sure the range isn't too long either
> 
> > +	pinctrl_add_gpio_ranges(pctldev, ranges, nranges);
> 
> I think we should also store ranges somewhere separate in pctldev ...
> 
Hmm, i'm not quite understand,
What do you mean separate in pctldev?
We already save the ranges in pctldev's gpio_ranges list.

> > +void pinctrl_dt_remove_gpio_ranges(struct pinctrl_dev *pctldev,
> > +				   struct pinctrl_gpio_range *ranges,
> > +				   unsigned nranges)
> 
> ... so that this function doesn't need ranges/nranges passed to it; it
> can just get them out of pctldec.
> 
For remove ranges/nranges, maybe we can use list_for_each_entry_safe
plus list_del like:
list_for_each_entry_safe(range, tmp, &pctldev->gpio_ranges, node)
    list_del(range->node);

I just follow the original way here and if change we may need another
patch.

> Or better yet, what if pinctrl_unregister automatically removed any
> ranges registered by pinctrl_dt_add_gpio_ranges, so this function
> doesn't even need to exist?
> 
Yes, it seems this can also work for non-dt registered gpio ranges added by
pinctrl_add_gpio_ranges, e.g, remove need pinctrl_remove_gpio_range too,
It seems it should be in a separate patch which is not related to gpio ranges
binding.

Do you want me to work on that patch first for this series to rebase or
we can do it later?

Regards
Dong Aisheng

