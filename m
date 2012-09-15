Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2IOSdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 14:33:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33624 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab2IOSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 14:33:07 -0400
Date: Sat, 15 Sep 2012 19:32:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [BUG] Deferred probing in driver model is racy, resulting in
	lost probes
Message-ID: <20120915183249.GI12245@n2100.arm.linux.org.uk>
References: <20120818145856.GP18957@n2100.arm.linux.org.uk> <20120915160304.GA536@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120915160304.GA536@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2012 at 09:03:04AM -0700, Greg Kroah-Hartman wrote:
> On Sat, Aug 18, 2012 at 03:58:56PM +0100, Russell King - ARM Linux wrote:
> > Okay, so EPROBE_DEFER seems to work when I build everything into the
> > kernel, but when I build a pile of ASoC drivers as modules, it fails
> > every time I've tried booting the platform so far.
> 
> Ugh, sorry for the delay in this, but this is really Grant's area, as he
> added this feature.
> 
> Actually, for some reason, I thought this was only supposed to work for
> built-in drivers, not for modules at all.  The fact that it works for
> them some times seems like an additional feature :)

It has to work for modules because there's no way to tell modprobe about
these kinds of dependencies - the modules make no direct reference to
their dependent drivers.

Think of a driver making use of gpiolib.  It makes reference only to
GPIO functions defined by gpiolib, which then redirects them to the
appropriate driver.

If upon requesting the GPIOs, it finds that the GPIOs it should be
using aren't there yet, it would decide to return -EPROBE_DEFER.
There is no direct reference to the GPIO module (which could be some
I2C peripheral also built as a module).

If you happen to have udev setup to automatically load all modules for
devices, this provides a definite case where EPROBE_DEFER sorts out the
probe ordering in this case - in theory, when the GPIO driver module
gets loaded, the GPIO-using driver will reprobe and hopefully initialize.

So, I think there's a valid use case by this for modules - in any case,
we can't really treat built-in drivers differently from modular drivers
unless we want them scattered with #ifdef MODULE...#endif stuff.
