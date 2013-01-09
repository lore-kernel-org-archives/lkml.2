Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab3AIKqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:46:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62080 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3AIKqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:46:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
Date: Wed, 9 Jan 2013 10:46:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <201301081306.02942.arnd@arndb.de> <CAAVeFu+vWe+ZGBPy2MMEv=7n-ob=F65rfz+b6ND9zk1d16LbEA@mail.gmail.com>
In-Reply-To: <CAAVeFu+vWe+ZGBPy2MMEv=7n-ob=F65rfz+b6ND9zk1d16LbEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301091046.13020.arnd@arndb.de>
X-Provags-ID: V02:K0:MIRR9WpF6+KbY2T2EPm+y1Dzwpd5MRint6Mcr/AxXJw
 wyIq7xSxjfjuFV8Wwx/+8iF8IkafIhABhUCZ/AwyHT9jiBdMLx
 AWLdcevuD+9NiuNJmAtoMNkU9YDbiOkK1HO58BU0j/GfLbJcxk
 JuG+KAj+HlxmmefiGPu1YXbNI4suBjRYCgAk73gB6pSvsRgd6K
 +ZabHwprKmtBXCZg85m2eMnUVqAakyrbbmpnHbk+3kTq1Qi/BS
 dIv6gmABZV5MjPYpOeV99MX5lR7QfSrQiXzg0yvz2/yU11BYZf
 iXTc+rSrs4tQLCly6sF7tkoiG4g8IeAOczBHfoxva2192boCTR
 VN7nE+Cq1Oa+9k0rrTDs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Alexandre Courbot wrote:
> On Tue, Jan 8, 2013 at 10:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > I like the interface, good idea!
> 
> Great! This was initially suggested by Linus W.
> 
> > A few questions:
> >
> > Is there a plan for migrating all the existing users of the current GPIO
> > interface?
> 
> Nothing specifically planned for now, as we need to make sure the new
> interface covers all needs first. There would be a lot of drivers to
> change if we decide to deprecate the integer interface, but Coccinelle
> could probably help here.

Right.

> The question is, do we want to totally get rid of the integer
> namespace? That would be the ultimate step, but would require another
> way to identify GPIOs (controller_device:offset might be such a way),
> and also to reorganize sysfs nodes. Wouldn't that be considered
> breaking user-space? 'cause we all know what happens to those who
> break user-space.

The user interface could eventually be the only part of the kernel that
uses the numbers, but you are right that we cannot change that.

> > How do you want to deal with drivers that work on platforms that currently
> > don't use gpiolib but have their own implementation of asm/gpio.h? Are
> > we going to phase them out?
> 
> With the current code, a driver should depend on gpiolib being
> compiled if it uses the new interface. It is not even declared if
> gpiolib is not used.
> 
> Given that both interfaces are quite close, one could imagine having a
> gpiod wrapper around the integer namespace (the "opaque descriptors"
> would then just be casted integers). This way drivers would only need
> to depend on GENERIC_GPIO. It's a little bit weird to have gpiod
> wrapping around gpio in one case and the opposite in another though -
> I'd rather have these platforms convert to GPIO descriptors internally
> (or even better, to gpiolib), but this is probably asking too much.

I think it would be reasonable to force everybody to use gpiolib,
that's much easier than converting everyone to the descriptor based
interface.

> I do not know all the details of gpiolib's history, but why would
> anyone want to implement the generic gpio interface and not use
> gpiolib anyways?

Only legacy users did this. Initially there was only the header file,
with the API declared but several different implementations of it.
gpiolib was introduced later to reduce code duplication and allow having
multiple implementations in the same kernel.

> Then there are platforms who do not follow generic gpios and implement
> their own sauce. I don't think we need to care here, as these are not
> supposed to be used with generic drivers anyway.

I agree. Ideally we would convert them over as well, but there is no
need to rush that, or force it on anybody. We should just make sure
we don't grow any new platforms doing this.

> > If we are adding a new way to deal with GPIOs, would it make sense to
> > have that more closely integrated into pinctrl in one form or another?
> > My feeling is that there is already a significant overlap between the
> > two, and while the addition of the gpiod_* functions doesn't necessarily
> > make this worse, it could be a chance to improve the current situation
> > to make the interface more consistent with pinctrl.
> 
> That may be a chance to introduce deeper changes indeed - what do you
> have in mind exactly?

I don't know enough about pinctrl to have a specific idea yet, but maybe
someone else has ideas. Regarding the integration of pinctrl with gpio,
I was thinking in the past that we could make pinctrl provide everything
that gpiolib does, and have a generic gpiolib driver on top of pinctrl
so that platforms don't need to implement both interfaces but only need
to provide a pure pinctrl driver. Not sure if this makes any sense.

	Arnd
