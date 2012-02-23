Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2BWD1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 22:27:33 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:50906 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2BWD1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 22:27:32 -0500
X-SpamScore: -10
X-BigFish: VS-10(zz9371I1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 23 Feb 2012 11:35:11 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Message-ID: <20120223033510.GA9141@shlinux2.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-9-git-send-email-swarren@nvidia.com>
 <CACRpkdYK1epBfxPCu+cc3Edmd_9aZf4nvNyBx8O0sns5V+gNWw@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC323@HQMAIL01.nvidia.com>
 <20120222063440.GB11087@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC6A9@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC6A9@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:05:20AM -0800, Stephen Warren wrote:
> Dong Aisheng wrote at Tuesday, February 21, 2012 11:35 PM:
> > On Tue, Feb 21, 2012 at 09:46:01AM -0800, Stephen Warren wrote:
> > ....
> > > > we might just
> > > >
> > > > #define PIN_MAP_NAME_DEFAULT "default"
> > > > In <linux/pinctrl/consumer.h> and <linux/pinctrl/machine.h> alike,
> > > > maybe in some <linux/pinctrl/mapnames.h> that both of these
> > > > include?
> > > >
> > > > the have the driver ask for:
> > > >
> > > > sirfport->p = pinctrl_get(&pdev->dev, PIN_MAP_NAME_DEFAULT);
> > > >
> > > > (Similar changes can be done for U300, naming all its map
> > > > "default".)
> > >
> > > I guess we could just modify pinmux_get() such that if NULL is passed as
> > > the state name, it uses "default" instead internally. The disadvantage I
> > > see here is that someone reading the client driver and writing the mapping
> > > table then has to know that pinmux_get() does that internally, rather than
> > > it being obvious right in the client driver code.
> >
> > It looks like a way out.
> 
> > The left problem seems to be that we may force the mapping table writer to
> > specify "default" name for map at least.
> > Is there any way to avoid it?
> 
> That specific restriction has been present since the very first patch
> that created the pinctrl subsystem.
> 
Since i saw some code in pinctrl subsystem formerly like:
/*
 * If we're looking for a specific named map, this must match,
 * else we loop and look for the next.
 */
if (name != NULL) {
	if (map->name == NULL)
		continue;
	if (strcmp(map->name, name))
		continue;
}
So i guessed the map->name could be NULL in the original design.
Of course, if we used the convenience macro to define map, there's no
chance to make map name NULL.
We did not force users to must convenience macros, right?

> > I just think it may be better if we do not have such restriction.
> 
> Given that all map entries have a name, I'd really prefer that all drivers
> had to request a specific matching name, rather than saying "just give me
> whatever is in the mapping table".
> 
> I don't see this as a restriction, but more of a correctness issue;
> every mapping table entry has a name and drivers (or device tree bindings)
> define what that name must be, so why shouldn't drivers be required to
> request that specific name, and experience an error if the mapping table
> author didn't create that name?
> 
Yes, i agree.
Based on this point, i feel maybe internally convert NULL to a "default" name for
pinctrl_get does not make too much sense.

> regulator_get(dev, id) requires id != NULL.
> 
> clk_get(dev, con_id) requires con_id != NULL in order to match a clock
> that has a non-NULL con_id defined (although clocks with a NULL con_id
> are also legal, in which case, the con_id parameter to clk_get is
> ignored)
> 
> So pinctrl_get(dev, state) requiring state != NULL seems consistent
> with existing practice.
> 
Yes, it's true if given all map entries have a name.

Now i'm intend to the way you mentioned at:
https://lkml.org/lkml/2012/2/21/213

And i agree with the way you said:
If we continue to allow NULL names, I think we should change that to:
if name:
    match = map->name && !strcmp(name, map->name)
else:
    match = !map->name

And i think allowing map name to be NULL will make life easy for those
devices who do not support multi states.

Originally i'm wondering how about more than one entries with a NULL name.
But now i think it's actually not an issue since we indeed support multi
entries with the same map name.

Regards
Dong Aisheng

