Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3AJKJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:09:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3AJKJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:09:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alex Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
Date: Thu, 10 Jan 2013 10:08:44 +0000
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
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <201301091046.13020.arnd@arndb.de> <2270940.DTxEYMZtED@percival>
In-Reply-To: <2270940.DTxEYMZtED@percival>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301101008.45091.arnd@arndb.de>
X-Provags-ID: V02:K0:LyEpwV2KD1CuT4gg83xwYz7lsObQ7nTtmnxOVPznVuT
 ziq7qSW9X6LxUXzxP9zzhEnxVY7AHqVsSFEWg80RboHMtp3908
 7+vj2rsNM6q2BLTdmbwDh+DGeQr9Qfa2+Pxcnc3a9uSCJhHYhx
 M66MKkJOUdE1JCOrgatzIOzMIY7o6Lkzk2yctvIwgNKc8EX/Pv
 MDMrN2xNdu0Xk+fKG1dCK6EF11BKmnVT8vfk48gGUKhtsNceXt
 QfR7oqboaNnPkbHjTEDk9uwfgSogujYSR4/rRgNqniaX4ZlgLo
 irV4zrstoB8OoqCx4suFY5ueSt8nwHy9MwrayqefIdN3P+foZ/
 601QK7ID26CLDCz3t2aM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2013, Alex Courbot wrote:
> On Wednesday 09 January 2013 18:46:12 Arnd Bergmann wrote:
> > 
> > Only legacy users did this. Initially there was only the header file,
> > with the API declared but several different implementations of it.
> > gpiolib was introduced later to reduce code duplication and allow having
> > multiple implementations in the same kernel.
> 
> Does the following sound reasonable?
> 1) Make sure every target that uses GENERIC_GPIO also implements its drivers 
> using gpiolib, convert the (hopefully) few ones that don't to use gpiolib
> 2) Make GENERIC_GPIO require GPIOLIB or just merge both options into a single 
> one
> 3) Turn gpio into a full subsystem (like pinctrl)
> 
> This should make things less blurry and easier to maintain (less header files, 
> only one interface, etc.) GPIO controllers would also be better integrated 
> into the driver model.

Yes, I think that would be good.

I've tried to find platforms that don't yet use GPIOLIB and fortunately
there are very few left:

I found two that provide the generic gpio interfaces when gpiolib
is disabled, but use gpiolib otherwise for the same hardware,
arch/m68k/include/asm/mcfgpio.h and arch/blackfin/include/asm/gpio.h.
I would assume that we can simply remove the non-gpiolib shortcut
here at cost of a small overhead.

Then there are a bunch that use gpiolib but have a nontrivial
implementation of gpio_get_value and other functions. I'm not sure
if these are a problematic with your code.

> > Regarding the integration of pinctrl with gpio,
> > I was thinking in the past that we could make pinctrl provide everything
> > that gpiolib does, and have a generic gpiolib driver on top of pinctrl
> > so that platforms don't need to implement both interfaces but only need
> > to provide a pure pinctrl driver. Not sure if this makes any sense.
> 
> That would work if all GPIOs were connected to a ball, but how about GPIO 
> expanders that are external to the chip? They have no use for pinctrl AFAICT. 
> On the other hand, maybe we can have one pinctrl-gpio driver for those chips 
> where pinctrl alone can emulate all the functionality of a GPIO controller. 
> Maybe such a driver exists already?

I don't think we have that yet, but it would be another option: rather
than putting a generic gpiolib driver on top of pinctrl, we could have
pinctrl support for all gpios that go through gpiolib, and move device
drivers over to use pinctrl as the way to manage gpios rather than the
classic gpio drivers. That would be a larger change though, and require
that we pull in the pinctrl subsystem on a lot of machines that don't
need it today.

	Arnd
