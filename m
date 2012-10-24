Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935417Ab2JXR7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:59:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59525 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935320Ab2JXR7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:59:08 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: balbi@ti.com
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Date: Wed, 24 Oct 2012 10:58:53 -0700
Message-ID: <64355430.MNHe7H1cg3@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.9.2 (Linux/3.6.0+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121024165749.GB32220@arwen.pp.htv.fi>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com> <20121024161801.GB16350@core.coreip.homeip.net> <20121024165749.GB32220@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 24, 2012 07:57:49 PM Felipe Balbi wrote:
> Hi,
> 
> On Wed, Oct 24, 2012 at 09:18:01AM -0700, Dmitry Torokhov wrote:
> > On Wed, Oct 24, 2012 at 02:54:23PM +0200, Linus Walleij wrote:
> > > On Tue, Oct 23, 2012 at 10:02 PM, Dmitry Torokhov
> > > 
> > > <dmitry.torokhov@gmail.com> wrote:
> > > > I have seen just in a few days 3 or 4 drivers having exactly the same
> > > > change - call to devm_pinctrl_get_select_default(), and I guess I will
> > > > receive the same patches for the rest of input drivers shortly.
> > > > This suggests that the operation is done at the wrong level. Do the
> > > > pin configuration as you parse DT data, the same way you set up i2c
> > > > devices registers in of_i2c.c, and leave the individual drivers that
> > > > do
> > > > not care about specifics alone.
> > > 
> > > Exactly this can be done with pinctrl hogs.
> > > 
> > > The problem with that is that it removes the cross-reference
> > > between the device and it's pinctrl handle (also from the device
> > > tree). Instead the pinctrl handle gets referenced to the pin controller
> > > itself. So from a modelling perpective this looks a bit ugly.
> > > 
> > > So we have two kinds of ugly:
> > > 
> > > - Sprinke devm_pinctrl_get_select_default() over all drivers
> > > 
> > >   which makes pinctrl handles properly reference their devices
> > > 
> > > - Use hogs and loose coupling between pinctrl handles and their
> > > 
> > >   devices
> > > 
> > > A third alternative as outlined is to use notifiers and some
> > > resource core in drivers/base/*
> > 
> > OK, so with drivers/base/, have you considered doing default pinctrl
> > selection in bus's probe() methods? Yo would select the default
> > configuration before starting probing the device and maybe select idle
> > when probe fails or device is unbound? That would still keep the link
> > between device object and pinctrl and there less busses than device
> > drivers out there.
> 
> it starts to become confusing after a while. I mean, there's a reason
> why all drivers explictly call pm_runtim_enable(), right ?

Right. Because not all of them support runtime PM and quite usually their
PM methods are not ready to go until initialization is complete. And again,
the driver here controls its own behavior.

> 
> From a first thought, one could think of just yanking that into bus'
> probe() as you may suggest, but sometimes the device is already enabled,
> so we need extra tricks:
> 
> pm_runtime_set_active();
> pm_runtime_enable();
> pm_runtime_get();
> 
> the same could happen with pinctrl eventually. What if a device needs to
> do something else (an errata fix as an example) before requesting
> pinctrl's default state ?

That is a valid concern and we'll need to find a compromise here. As I said,
I am not saying that no driver should ever touch pinctrl. I can see, for
example, input drivers actually disabling pins until they are ->open()ed,
in addition of doing that at [runtime] suspend/resume. But it would be nice
if we could have "dumb" drivers not care about pins.

Thanks.

-- 
Dmitry
