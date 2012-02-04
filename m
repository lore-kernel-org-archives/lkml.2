Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2BDRnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 12:43:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43199 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2BDRnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 12:43:04 -0500
Date: Sat, 4 Feb 2012 17:41:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Grant Likely <grant.likely@secretlab.ca>, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] gpiolib/arches: Centralise bolierplate asm/gpio.h
Message-ID: <20120204174115.GX889@n2100.arm.linux.org.uk>
References: <1328370879-18523-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20120204170632.GA3615@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120204170632.GA3615@merkur.ravnborg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 06:06:32PM +0100, Sam Ravnborg wrote:
> On Sat, Feb 04, 2012 at 03:54:39PM +0000, Mark Brown wrote:
> > Rather than requiring architectures that use gpiolib but don't have any
> > need to define anything custom to copy an asm/gpio.h provide a Kconfig
> > symbol which architectures must select in order to include gpio.h and
> > for other architectures just provide the trivial implementation directly.
> 
> Hi Mark.
> 
> There is an even simpler solution.
> 
> For each arch that uses asm-generic/gpio.h add a line
> to arch/$ARCH/include/asm/Kbuild like this:
> 
> 
>     generic-y += gpio.h
> 
> This will then make this arch pick up the asm-generic version when
> you do #include <asm/gpio.h>.

You're assuming that asm-generic/gpio.h was invented to be a replacement
for an architecture asm/gpio.h.  Unfortunately, things aren't that
simple.

It would have been a lot better if asm-generic/gpio.h was tacked on the
bottom of linux/gpio.h - because that's what it really is.  It's core
code features, not platform stuff.

What's platform specific about asm/gpio.h is the number of GPIOs in
the system, and whether it wants to intercept the gpio_xxx() functions
to provide fast access to on-chip GPIOs.

What I'd suggest is moving asm-generic/gpio.h to linux/gpiolib.h, and
making asm-generic/gpio.h include that as a patch until stuff is fixed
for its new location.  That should result in a proper asm-generic/gpio.h
being:

/* The trivial gpiolib dispatchers */
#define gpio_get_value  __gpio_get_value
#define gpio_set_value  __gpio_set_value
#define gpio_cansleep   __gpio_cansleep
#define gpio_to_irq     __gpio_to_irq

and nothing else.

Alternatively, instead of linux/gpiolib.h, put it in linux/gpio.h instead,
but that gets more icky because of the mess of asm/gpio.h includes (which
I've been banging on for years about in ARM patches and they're _still_
coming.)
