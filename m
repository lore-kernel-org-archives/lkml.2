Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2EYDUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 23:20:13 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:5151
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309Ab2EYDUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 23:20:11 -0400
X-SpamScore: -12
X-BigFish: VS-12(zzbb2dI9371I1432N1418I98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 25 May 2012 11:22:52 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        Dong Aisheng <dongas86@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH RFC v3 3/3] pinctrl: add pinctrl gpio binding support
Message-ID: <20120525032250.GA13524@shlinux2.ap.freescale.net>
References: <1337779362-31259-1-git-send-email-b29396@freescale.com>
 <1337779362-31259-3-git-send-email-b29396@freescale.com>
 <4FBD4C13.8080209@wwwdotorg.org>
 <CAA+hA=Rb1Qix67QBthPjo_4d5ATWjA7pePembZRwJkPMtQNpjg@mail.gmail.com>
 <4FBE5225.301@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FBE5225.301@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:22:13PM +0800, Stephen Warren wrote:
> On 05/23/2012 11:19 PM, Dong Aisheng wrote:
> > On Thu, May 24, 2012 at 12:42:19PM +0800, Stephen Warren wrote:
> >> On 05/23/2012 07:42 PM, Dong Aisheng wrote:
> >>> On Thu, May 24, 2012 at 4:44 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >>>> On 05/23/2012 07:22 AM, Dong Aisheng wrote:
> >>>>> From: Dong Aisheng <dong.aisheng@linaro.org>
> >>>>>
> >>>>> This patch implements a standard common binding for pinctrl gpio ranges.
> >>>>> Each SoC can add gpio ranges through device tree by adding a gpio-maps property
> >>>>> under their pinctrl devices node with the format:
> >>>>> <&gpio $gpio_offset $pin_offset $npin>.
> >>>>>
> >>>>> Then the pinctrl driver can call pinctrl_dt_add_gpio_ranges(pctldev, node)
> >>>>> to parse and register the gpio ranges from device tree.
> ...
> >>>> Re: your locking comments in your other email: ranges[i].gc doesn't
> >>>> appear to be used anywhere else in pinctrl, so I think it's OK not to
> >>>> lock the GPIO chip for any more time than between the above two blocks
> >>>> of code.
> >>>
> >>> So i will add lock between them like:
> >>> ranges[i].gc = of_node_to_gpiochip(np_gpio);
> >>> if (!try_module_get(ranges[i].gc->owner))
> >>>     err...
> >>
> >> I think that module_get() needs to happen inside of_node_to_gpiochip(),
> >> so that it executes inside any lock that function takes.
> >
> > Can you please help explain a bit more?
> > I did not quite understand.
> > It looks to me of_node_to_gpiochip is only convert the gpio node to gpio chip.
> > Why need get the module inside this function?
> > For gpio_request function, it also calls try_module_get(gc) after find the gpio
> > chip.
> 
> The problem is this:
> 
> Thread 1: Call of_node_to_gpiochip(), returns a gpio_chip.
> Thread 2: Unregisters the same gpio_chip that was returned above.
> Thread 1: Accesses the now unregistered (and possibly free'd) gpio_chip
> -> at best, bad data, at worst, OOPS.
> 
Correct. We did have this issue.
Thanks for clarify.

> In order to prevent this, of_node_to_gpiochip() should take measures to
> prevent another thread from unregistering the gpio_chip until thread 1
> has completed its step above.
> 
> The existing of_get_named_gpio_flags() is safe from this, since
> gpiochip_find() acquires the GPIO lock, and all accesses to the fouond
> gpio chip occur with that lock held, inside the match function. Perhaps
> a similar approach could be used here.
Why it looks to me of_get_named_gpio_flags has the same issue and also not safe?
For of_node_to_gpiochip itself called in of_get_named_gpio_flags, it's safe.
But after that, i'm suspecting it has the same issue as you described above, right?

For example:
int of_get_named_gpio_flags(struct device_node *np, const char *propname,
                           int index, enum of_gpio_flags *flags)
{
...
	gc = of_node_to_gpiochip(gpiospec.np);
	if (!gc) {
		pr_debug("%s: gpio controller %s isn't registered\n",
			 np->full_name, gpiospec.np->full_name);
		ret = -ENODEV;
		goto err1;
	}

	===> the gc may be unregistered here by another thread and
	     even already have been freed, right?

	ret = gc->of_xlate(gc, &gpiospec, flags);
...
}

Maybe we need get the lock in of_node_to_gpiochip and release it by calling
of_gpio_put(..) after using?

Regards
Dong Aisheng

