Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226Ab2JXQOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:14:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65497 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab2JXQOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:14:34 -0400
Date: Wed, 24 Oct 2012 09:14:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        tony@atomide.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121024161429.GA16350@core.coreip.homeip.net>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121022155028.GA13791@core.coreip.homeip.net>
 <508660D4.9030507@ti.com>
 <20121023200249.GA2712@core.coreip.homeip.net>
 <20121024083704.GF5665@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024083704.GF5665@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:37:04AM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Oct 23, 2012 at 01:02:49PM -0700, Dmitry Torokhov wrote:
> > On Tue, Oct 23, 2012 at 11:18:12AM +0200, Benoit Cousson wrote:
> > > Hi Dimitry,
> > > 
> > > On 10/22/2012 05:50 PM, Dmitry Torokhov wrote:
> > > > Hi Sourav,
> > > > 
> > > > On Mon, Oct 22, 2012 at 06:43:00PM +0530, Sourav Poddar wrote:
> > > >> Adapt keypad to use pinctrl framework.
> > > >>
> > > >> Tested on omap4430 sdp with 3.7-rc1 kernel.
> > > > 
> > > > I do not see anything in the driver that would directly use pinctrl. Is
> > > > there a better place to select default pin configuration; maybe when
> > > > instantiating platform device?
> > > 
> > > Why?
> > > The devm_pinctrl_get_select_default is using the pinctrl.
> > 
> > No, I guess we ihave different understanding of what "directly use" means.
> > This particular driver does directly use interrupts: it requests it and
> > performs some actions when interrupt arrives. Same goes for IO memory -
> > it gets requested, then we access it. With pinctrl we do not do anything
> > - we just ask another layer to configure it and that is it.
> 
> this is true for almost anything we do:
> 
> - we ask another layer to allocate memory for us
> - we ask another layer to call our ISR once the IRQ line is asserted
> - we ask another layer to handle the input events we just received
> - we ask another layer to transfer data through DMA for us
> - we ask another layer to turn regulators on and off.

But we are _directly_ _using_ all of these. You allocate memory and you
(the driver) stuff data into that memory. You ask for DMA and you take
the DMAed data and work with it. Not so with pinctrl in omap keypad and
other drivers I have seen so far.

> 
> and so on. This is just how abstractions work, we group common parts in
> a framework so that users don't need to know the details, but still need
> to tell the framework when to fiddle with those resources.
> 
> > I have seen just in a few days 3 or 4 drivers having exactly the same
> > change - call to devm_pinctrl_get_select_default(), and I guess I will
> > receive the same patches for the rest of input drivers shortly.
> > This suggests that the operation is done at the wrong level. Do the
> > pin configuration as you parse DT data, the same way you set up i2c
> > devices registers in of_i2c.c, and leave the individual drivers that do
> > not care about specifics alone.
> 
> Makes no sense to hide that from drivers. The idea here is that driver
> should know when it needs its pins to muxed correctly.

The driver also needs memory controller to be initialized, gpio chip be
ready and registered, DMA subsystem ready, input core reade, etc, etc,
etc. You however do not have every driver explicitly initialize any of
that; you expect certain working environment to be already operable. The
driver does manage resources it controls, it has ultimate knowledge
about, pin configuration is normally is not it. We just need to know
that we wired/muxed properly, otherwise we won't work. So please let
parent layers deal with it.

> 95% of the time
> it will be done during probe() but then again, so what ?
> 
> doing that when parsing DT, or on bus notifiers is just plain wrong.
> Drivers should be required to handle all of their resources.

All of _their_ resources, exactly. They do not own nor control pins so
they should not be bothered with them either. Look, when you see that
potentially _every_ driver in the system needs to set up the same object
that it doe snot use otherwise you should realize that individual driver
is not the proper place to do that.

> 
> > > That's why it is named "get_select_default" and not "get" only.
> > > This API ensure that the pin will be set to the default state, and this
> > > is all we need to do during the probe.
> > 
> > Why during the probe and not by default? Realistically, the driver will
> > be loaded as long as there is a matching device and pins will need to be
> > configured.
> 
> likewise memory will be allocated when matching happens, IRQs will be
> allocated, regulators will be turned on. So why don't we do all that by
> default ? Because it is wrong.

No, because we do not know how. The generic layer does not know the ISR
to install, how much memory to allocate, etc. Having regulator turned on
before getting to probe might not be a bad idea.

> 
> > > There is no point to change the mux if the driver is not probed, because
> > > potentially the pin can be use be another driver.
> > 
> > What other driver would use it? Who would chose what driver to load?
> 
> Well, you _do_ know that on a SoC we have a limited amount of pins
> right ?
> 
> Considering the amont of features which are packed inside a single die,
> it's not farfetched to assume we will have a lot less pins then we
> actually need, so we need muxers behind each pin in order to choose
> which functionality we want.
> 
> If it happens that keypad's pins are shared with another IP (e.g. GPIO),
> we need to give the final user (a OEM/ODM) the choice of using those
> pins as either keypad or GPIOs, thus the need for pinctrl framework and
> the calls in the drivers.

Right, so please walk me through, step by step, how an OEM/ODM woudl
select a particular configuration. Do you expect it to happen at
runtime, or do you expect relevant data be put in DT?

Thanks.

-- 
Dmitry
