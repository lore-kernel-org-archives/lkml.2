Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935769Ab2JYQCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:02:40 -0400
Received: from smtp1.goneo.de ([212.90.139.80]:61632 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933842Ab2JYQCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:02:38 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.945
From: Lars Poeschel <poeschel@lemonage.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
Date: Thu, 25 Oct 2012 18:02:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
References: <20120925085559.GL28670@sortiz-mobl> <201210251202.36708.poeschel@lemonage.de> <20121025140013.GK18814@opensource.wolfsonmicro.com>
In-Reply-To: <20121025140013.GK18814@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210251802.42349.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure if I did something fundamentally wrong or if you did not 
understand, what I am trying to do. I am sorry, I am not a native english 
writer, maybe I did a bad explanation.

On Thursday 25 October 2012 at 16:00:13, Mark Brown wrote:
> On Thu, Oct 25, 2012 at 12:02:36PM +0200, Lars Poeschel wrote:
> > As there is no general regmap_bus for reading/writing registers over USB
> > (and probably will never be). I had to implement it in my driver for the
> > special case of this device. I also have a regmap_config, that provides
> > a volatile_reg function. I need this to decide if the pin the value is
> > queried is an output or an input. In the latter case I obviously can't
> > use the cache, in the former
> 
> Why would you want to implement this as a bus?  If you're not actually
> rendering things down into a register and value on the bus then you
> should be hooking in at the level before we do the marshalling since
> that's totally irrelevant.  This should be done by making the
> marashalling pluggable.

Did you have a look at the code ? I want to render things down to registers 
and values on the bus! In the one and only case a pin is set to be an output 
and someone reads it's value, I don't want the bus to become active and 
instead read the value from the regmap cache.
There is no ready-to-use remap-usb-something, so I have to implement this bus 
on my own. regmap_init needs some regmap_bus. This is what I've done for this 
usb device inside my driver.
 
> > case I want to use it. Here the first problem arises. In the volatile_reg
> > function I can not do a read of a regmap register since regmap internally
> > uses a mutex lock. Thus I have my own cache in a device private
> > variable. This is a bit strange. To use the cache to have to implement
> > my own cache ;-)
> 
> What do you actually need to read back here?

Someone reads a gpio value register. To be able to decide if I really have to 
do the read on the usb bus or if I can use a cached value, I have to know if 
the pin in question is an output or an input. To get this information I have 
to do another register read. If it's an output I give back the cached value, 
if it's an input I do the register read.
 
> > The other problem is, that the volatile_reg function is called with
> > struct device and I can not container_of up to my device vprbrd_gpio
> > struct, since
> 
> Why on earth can't you do that?  That sounds like something that should
> be fixed for whatever bus you're using if it's an issue but normally
> this is simply a case of setting and reading some driver data.

Sorry, I did not see this. I was confused by the regmap_bus functions get 
called with a void *context pointer and the volatile_reg function with the 
struct device *device. But those are different. Thanks for the hint.
 
> > The last problem is that I have 16 registers for setting/reading the
> > first 16 pins value. And there is another 16 registers for setting the
> > pins direction (input/output). Setting the pin to output is an atomic
> > operation of setting the pins direction AND setting it's value. So if
> > there is a set pin direction to output operation in my driver I want to
> > update the value of the corresponding value register, since regmap does
> > not know of this change. But the regcache_write I would use for this
> > seems also not intended for use by drivers. It is not exported.
> 
> So just invalidate the cache and it'll get restored next time we look at
> the register.

Yes, this is exactly what I gave as an alternative in my second to last mail. 
But this invalidates the whole register map although I just want to update 
one register value.
