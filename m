Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2KTIRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:17:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53396 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2KTIRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:17:48 -0500
Date: Tue, 20 Nov 2012 09:17:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: DVS regulator drivers
In-Reply-To: <20121120010547.GD4483@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1211200856380.21420@axis700.grange>
References: <Pine.LNX.4.64.1211191213380.11024@axis700.grange>
 <20121120010547.GD4483@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:W2GIBct5+ohReG1WPSZAh++4BLNRUPg2zPoX5wyF8tO
 mm9xOQ/+24dG0IRuA/6XLsKxEFDZ6XRupTjOjd1UrlV8jPqW0H
 +XNTGX5Xq5W1KiE7jfjr7EQuMiqAqQ015ZJxdSeuE+GUbtpNe6
 HHHPy7s0ZZL1iGU4ITOT5OPDu3z5kThmfL32GvaF1QthYuRJKn
 eCjdUZ+U/G6NrajrRPZqrM4k8NfT0JGmlC7Z48CnjgmTsSzypk
 DRnqZoVVrnBjf0q8dhP3U6u68C3EptKIAqUeJDHXJ1BTbCuOB2
 eQXARw6TL5Swy1iG+JBDzhMbNaSvFXGAhBmP9BL2KAMgf89Vvx
 cALFXhWidVzI4qVW7rw6BUKULtWrB29XaO+QhSHozTeLERmis6
 j2JBE/YrS3rgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark

Thanks for your reply.

On Tue, 20 Nov 2012, Mark Brown wrote:

> On Mon, Nov 19, 2012 at 12:52:09PM +0100, Guennadi Liakhovetski wrote:
> > As I mentioned in an earlier mail today [1] I have a difficulty seeing how 
> > the current regulator API can efficiently be used for DVS-type regulators. 
> 
> Please don't invent terminology or repurpose existing terminology like
> this, it's just confusing - obvious essentially all regulators covered
> by the regulator API support voltage scaling which is the usual meaning
> of DVS.

Right, sorry, a more precise term would be a "pin-selectable DVS," right?

> > wm831x-dcdc.c handles 2 voltages: "DVS" and "ON." If the new voltage in 
> > .set_voltage_sel() is equal to one of them, it is just used. If it is a 
> > new voltage, there's a comment in the driver in 
> > wm831x_buckv_set_voltage_sel():
> 
> > 	/* Always set the ON status to the minimum voltage */
> 
> > but I actually don't see, where the minimum is selected. It seems instead 
> > in this case the "ON" value is just set:
> 
> > 	ret = wm831x_set_bits(wm831x, on_reg, WM831X_DC1_ON_VSEL_MASK, vsel);
> > 	if (ret < 0)
> > 		return ret;
> > 	dcdc->on_vsel = vsel;
> 
> Can you be more specific about your concern here?  The above code does
> exactly what the comment says, it will set the selector it just picked.

Your patch fixes exactly the problem, that I was pointing at, thanks.

> You did spot one bug (I think due to bitrot) which I just fixed but in
> general I've just TLDRed this as it's a bit unclear what you're trying
> to say here, can you be a bit more concise here?  I'm not sure if
> there's a general point or if it's specific code issues?

Sorry, let's try again. Just to bring back the "too long and a bit unclear 
part:"

> > lp872x.c seems to be selecting between ON and DVS (or V1 and V2 in lp872x' 
> > terminology) in lp872x_set_dvs(), which is called every time a voltage is 
> > set. But this function always gets the same arguments - supplied from the 
> > platform data and therefore only one voltage is ever used... The two 
> > "dynamic" DVS selection fields in struct lp872x: .dvs_pin and .dvs_gpio 
> > seem just to always stay constant, the latter is also just initialised 
> > once and is never used again.

Ok, what I meant is the following:

1. some fields of struct lp872x are superfluous / unused, e.g. .dvs_gpio 
is only set once and never used again, .dvs_pin seems to be used, but I 
think it's never changed either, because:

2. .dvs_pin is initialised in lp872x_init_dvs() from platform data:

	pinstate = dvs->init_state;
	...
	lp->dvs_pin = pinstate;

There's one more location in the code, where .dvs_pin gets assigned: in 
lp872x_set_dvs():

	lp->dvs_pin = state;

but, I think, it will always be set to one and the same value: "state" is 
calculated as

	state = dvs_sel == SEL_V1 ? DVS_HIGH : DVS_LOW;

where dvs_sel is a parameter of this function. The function is called only 
from one location in lp872x_buck_set_voltage_sel() as

		lp872x_set_dvs(lp, dvs->vsel, dvs->gpio);

where dvs is platform data, i.e., all parameters are constant. So, 
lp872x_set_dvs() never switches anything, and in fact it could just have 
been called just once from initialisation to set the GPIO. This also 
means, that only one context - either SEL_V1 or SEL_V2 is used.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
