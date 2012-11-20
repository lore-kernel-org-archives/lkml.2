Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab2KTJnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:43:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2KTJnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:43:04 -0500
Date: Tue, 20 Nov 2012 10:42:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Laxman Dewangan <ldewangan@nvidia.com>
cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: max8973: add regulator driver support
In-Reply-To: <50AAE2BF.2000909@nvidia.com>
Message-ID: <Pine.LNX.4.64.1211201027190.21420@axis700.grange>
References: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com>
 <Pine.LNX.4.64.1211190900110.11024@axis700.grange> <50AAE2BF.2000909@nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:mIMt4dXckF8XvfnpN27piR9JACTquQor5OV+mBbYtmo
 PlYHnT97R+lwwLHJo82bjbULLV2QZUKqlBzqXF7ZhHhdHIdZRg
 /OnJBG5oI1q1LsUccERn+RHyosDxzWUt/Irun9wXATMw5QZkrd
 vexGEwS1gWN6ee3SsDZCUefL9vkXy3k6UaNo5GFKaFun7LsXWn
 nebCfLqKY0nebag3H1mXkXiJIYzh+jXW7JDRxzWQZrRamvRrgu
 BYeECqyUsnn/vHzzgojFU0skKU0veBCJk/9MfvGDJOVZho+ONk
 rrA3CySwdtZYJ0j+yvhRUiNJyzS12VAodZ3SJBl73mt3pb8OoD
 BZIBSS9kvEX+fA4EUBzTZ4pbVziv9X0zZxz0OpKEPjOR0wB4Tw
 Bt0iQlNssVk+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman

On Tue, 20 Nov 2012, Laxman Dewangan wrote:

> On Monday 19 November 2012 04:22 PM, Guennadi Liakhovetski wrote:
> > 
> > Hi Laxman
> > 
> > drivers in the tree. Well, I came to two conclusions so far: (1) The
> > current regulator API is not very well suitable for such regulators. I
> > would imagine, one would need two methods: for setting the "normal" and
> > the DVS voltage. Instead of this drivers are trying to be smart at
> > guessing, which voltage the user is trying to set now... (2) Drivers do
> > this in different ways and at least out of the 2 drivers I looked at both
> > have bugs and different ones at that. I'll send a separate email,
> > describing what I found suspicious in them.
> > 
> > Of course, all the above was just my DVS-newbie impression, which can very
> > well be absolutely wrong.
> > 
> 
> If there is multipel VOUT register for single vout then these registers are
> generally selected by the input pin of device.
> In a given system, you can connect the gpios pin to this input pins to select
> the proper VOUT register.
> The register update through i2c consume more time and changing the gpio state
> is comparatively less.
> So if you have let say 4 voltages 1.10, 1.11, 1.12, 1.13 and having 4 VOUT
> register. Then program these vout val to vout reg like 1.10 to vout_reg0, 1.11
> to vout_reg1 etc.
> Now for changing voltage between these will just require to change the gpio
> pin state, not the register update and so it will be faster. You can achive
> the voltage change by gpio pin state change.

Right, that's also how I understood it, thanks for confirming.

> Now if your DVS have more volatge scaling then you can use the LRU mechanism
> to use the vout register for this new value.

Well, as I commented to Mark, you certainly can do that, but it might or 
might not work very well. But we can keep it if it works well for you and, 
probably, it will also work for most other users. I just find the way you 
interface the generic LRU for arbitrary many elements and your specific 
2-element case not very cleanly. In your case the LRU selection can only 
return 0 or 1, anything else would be a bug. So, why don't you just 
BUG_ON() / WARN_ON() / dev_err() if returned index > 1 instead of taking 
the lowest bit?

> > > +     max->dev =&client->dev;
> > > +     max->desc.name = id->name;
> > > +     max->desc.id = 0;
> > Don't you have to be able to process multiple such devices?
> 
> Not really require as device have only one output. The different devices will
> have different registrations and so does not matter here.

Right, I thought it had to be unique.

> > > +     max->enable_external_control = pdata->enable_ext_control;
> > > +     max->dvs_gpio = pdata->dvs_gpio;
> > > +     max->curr_gpio_val = pdata->dvs_def_state;
> > > +     max->curr_vout_reg = MAX8973_VOUT + pdata->dvs_def_state;
> > > +     max->lru_index[0] = max->curr_vout_reg;
> > Here you actually need an offset within your register address space, so,
> > should be
> > 
> > +       max->lru_index[0] = pdata->dvs_def_state;
> 
> 
> Yaah, seems some issue if vout_base is not zero. But really dont require here
> as MAX8973_VOUT is 0 in this case.

I think cleanly differentiating between register addresses, offsets and 
indices is important.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
