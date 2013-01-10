Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab3AJEHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 23:07:43 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11611 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3AJEHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 23:07:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 09 Jan 2013 20:07:40 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
Date: Thu, 10 Jan 2013 13:07:36 +0900
Message-ID: <2270940.DTxEYMZtED@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.5 (Linux/3.6.11-1-ARCH; KDE/4.9.5; x86_64; ; )
In-Reply-To: <201301091046.13020.arnd@arndb.de>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <CAAVeFu+vWe+ZGBPy2MMEv=7n-ob=F65rfz+b6ND9zk1d16LbEA@mail.gmail.com> <201301091046.13020.arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013 18:46:12 Arnd Bergmann wrote:
> > The question is, do we want to totally get rid of the integer
> > namespace? That would be the ultimate step, but would require another
> > way to identify GPIOs (controller_device:offset might be such a way),
> > and also to reorganize sysfs nodes. Wouldn't that be considered
> > breaking user-space? 'cause we all know what happens to those who
> > break user-space.
> 
> 
> The user interface could eventually be the only part of the kernel that
> uses the numbers, but you are right that we cannot change that.

That's sad, as it makes it necessary to maintain the global integer namespace 
(assigning a base GPIO to each controller and making sure the controllers 
ranges do no overlap) even if it is not used internally anymore. We could make 
global numbers assignment transparent, but that would potentially change the 
GPIO numbers in user-space and cause another incompatibility.

> > With the current code, a driver should depend on gpiolib being
> > compiled if it uses the new interface. It is not even declared if
> > gpiolib is not used.
> > 
> > Given that both interfaces are quite close, one could imagine having a
> > gpiod wrapper around the integer namespace (the "opaque descriptors"
> > would then just be casted integers). This way drivers would only need
> > to depend on GENERIC_GPIO. It's a little bit weird to have gpiod
> > wrapping around gpio in one case and the opposite in another though -
> > I'd rather have these platforms convert to GPIO descriptors internally
> > (or even better, to gpiolib), but this is probably asking too much.
> 
> 
> I think it would be reasonable to force everybody to use gpiolib,
> that's much easier than converting everyone to the descriptor based
> interface.
> 
> 
> > I do not know all the details of gpiolib's history, but why would
> > anyone want to implement the generic gpio interface and not use
> > gpiolib anyways?
> 
> 
> Only legacy users did this. Initially there was only the header file,
> with the API declared but several different implementations of it.
> gpiolib was introduced later to reduce code duplication and allow having
> multiple implementations in the same kernel.

Does the following sound reasonable?
1) Make sure every target that uses GENERIC_GPIO also implements its drivers 
using gpiolib, convert the (hopefully) few ones that don't to use gpiolib
2) Make GENERIC_GPIO require GPIOLIB or just merge both options into a single 
one
3) Turn gpio into a full subsystem (like pinctrl)

This should make things less blurry and easier to maintain (less header files, 
only one interface, etc.) GPIO controllers would also be better integrated 
into the driver model.

> > > If we are adding a new way to deal with GPIOs, would it make sense to
> > > have that more closely integrated into pinctrl in one form or another?
> > > My feeling is that there is already a significant overlap between the
> > > two, and while the addition of the gpiod_* functions doesn't
> > > necessarily
> > > make this worse, it could be a chance to improve the current situation
> > > to make the interface more consistent with pinctrl.
> > 
> > 
> > That may be a chance to introduce deeper changes indeed - what do you
> > have in mind exactly?
> 
> 
> I don't know enough about pinctrl to have a specific idea yet, but maybe
> someone else has ideas.

I had a deeper look at pinctrl, and indeed I can see the connection between 
the two. There already interfaces to link GPIO ranges to pin ranges and have 
GPIO drivers switch the pin to the correct state when a GPIO is requested 
(this, btw, should also be updated to not use global GPIO numbers at some 
point). Maybe some tighter integration that I just don't see yet can be done 
too.

> Regarding the integration of pinctrl with gpio,
> I was thinking in the past that we could make pinctrl provide everything
> that gpiolib does, and have a generic gpiolib driver on top of pinctrl
> so that platforms don't need to implement both interfaces but only need
> to provide a pure pinctrl driver. Not sure if this makes any sense.

That would work if all GPIOs were connected to a ball, but how about GPIO 
expanders that are external to the chip? They have no use for pinctrl AFAICT. 
On the other hand, maybe we can have one pinctrl-gpio driver for those chips 
where pinctrl alone can emulate all the functionality of a GPIO controller. 
Maybe such a driver exists already?

But in general, I agree pinctrl should be a source of inspiration for how to 
design GPIO. In particular, having a per-chip integer namespace instead of a 
single global one is definitely something to take (and that's how things work 
in the DT already).

Alex.

