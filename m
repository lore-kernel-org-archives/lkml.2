Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935554Ab2JYKCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:02:32 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:65408 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934884Ab2JYKCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:02:30 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.898
From: Lars Poeschel <poeschel@lemonage.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
Date: Thu, 25 Oct 2012 12:02:36 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
References: <20120925085559.GL28670@sortiz-mobl> <CACRpkdZ3=VFOHqmo=XbyDGUKoxFaG+PpzDUsBQTQ1O3F-DhTvg@mail.gmail.com> <20121024163155.GH18814@opensource.wolfsonmicro.com>
In-Reply-To: <20121024163155.GH18814@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210251202.36708.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012 at 18:31:55, Mark Brown wrote:
> On Wed, Oct 24, 2012 at 09:53:06AM +0200, Linus Walleij wrote:
> > On Tue, Oct 23, 2012 at 5:24 PM, Lars Poeschel <poeschel@lemonage.de> 
wrote:
> > > Ok, I tried to implement it (at least for the gpioa part of the
> > > driver).
> > 
> > > It does not work. I got stuck. There are three problems I could not 
solve:
> > So I'm looping in Mark Brown to get some hints whether the following
> > can be resolved easily or needs to be given up on...
> 
> Some context would've been enormously useful for working out what the
> discussion is all about...  this is *very* verbose and not at all clear.

You can reread our conversation before Linus Walleij brought you in starting 
with my first patch submission here:

https://lkml.org/lkml/2012/10/12/218

I'll try to sum up, what happend so far:
I'd submit a driver some strange device (called "viperboard") that besides 
some other functionality is a USB interface that has 2x16 GPIO at the other 
side. Some USB to GPIO converter.
In my driver I had two 16 bit variables that cache the values of the GPIO and 
two 16 bit variables holding the direction of the GPIO pin (input or output). 
The idea is that in case a pin is an output and there is a read on that pin, 
that I wanted to save the USB ping pong for reading the value of the pin.
Linus Walleij pointed out that there is already a framework for marshalling 
and caching register read/writes called regmap.
I gave it a try and used it for my driver but I had problems and this is where 
you came in.
As there is no general regmap_bus for reading/writing registers over USB (and 
probably will never be). I had to implement it in my driver for the special 
case of this device. I also have a regmap_config, that provides a volatile_reg 
function. I need this to decide if the pin the value is queried is an output 
or an input. In the latter case I obviously can't use the cache, in the former 
case I want to use it. Here the first problem arises. In the volatile_reg 
function I can not do a read of a regmap register since regmap internally uses 
a mutex lock. Thus I have my own cache in a device private variable. This is a 
bit strange. To use the cache to have to implement my own cache ;-)
The other problem is, that the volatile_reg function is called with struct 
device and I can not container_of up to my device vprbrd_gpio struct, since 
the struct regmap seems to be regmap private - not for use in drivers.
The last problem is that I have 16 registers for setting/reading the first 16 
pins value. And there is another 16 registers for setting the pins direction 
(input/output). Setting the pin to output is an atomic operation of setting 
the pins direction AND setting it's value. So if there is a set pin direction 
to output operation in my driver I want to update the value of the 
corresponding value register, since regmap does not know of this change. But 
the regcache_write I would use for this seems also not intended for use by 
drivers. It is not exported.
You can have a look at my current development code of the driver in question 
in this mail:
https://lkml.org/lkml/2012/10/23/374
 
> > > Setting the direction to output is an atomic set direction and set
> > > value. The register number is different from setting the value only.
> > > So after a successful call, I want to update the cache of output value
> > > using regcache_write. This is also not publicy available api. The only
> > > thing I could do is invalidate the whole cache using
> > > regcache_mark_dirty. (3rd problem)
> > 
> > Same thing.
> 
> The above doesn't sound like marking the register as dirty is going to
> be helpful...  at most you'd want to discard the cache which is already
> supported per register.  Marking the register as dirty would leave the
> existing (presumably wrong if there's a problem) value in place in the
> cache.  It's not at all clear to me that a cache is even useful for
> these registers.
> 
> > > I attach my current working state here. This is NOT WORKING and only as
> > > reference.
> > 
> > So if you want to do this with regmap, I suggest the way forward would
> > be to go solve it at the root by implementing something like
> > drivers/base/regmap/regmap-usb-ctrl.c with your desired semantics
> > and using that.
> 
> So the issue is that we're trying to use regmap for some USB device?

This is not an issue, since I can implement my regmap_bus for this inside my 
driver.

Thanks for your help!

Lars
