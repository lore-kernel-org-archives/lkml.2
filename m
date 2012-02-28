Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2B1FsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 00:48:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37720 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2B1FsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 00:48:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.41.161 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
Date: Tue, 28 Feb 2012 06:48:12 +0100
Message-ID: <CACRpkdY1W-RGE0JL4Sx5UcPY-EGieu8vo7H0fp9xyXtegpaaKw@mail.gmail.com>
Subject: RFC: what do we do with system controllers?
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mattias NILSSON <mattias.i.nilsson@stericsson.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly addressed to Greg but anyone is welcome to join the
discussion...

Several ARM platforms have system controllers. In this I
include all custom terminology such as:

- System Control
- Chip Controller
- Core Module control registers
- Power Reset Control Management Units
- Multimedia Communications Port
- ASIC control of "stuff"

These are register-mapped ranges controlling "various" or
"misc" parts of the system. The registers you find there can
do e.g.:

* Reset or shut down the system
   arch/arm/mach-integrator/core.c
   arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h

* Reset individual ASIC blocks
  drivers/mfd/db8500-prcmu.c
  arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h

* Control some core voltage domains
  drivers/mfd/db8500-prcmu.c

* Control system frequency
   arch/arm/mach-integrator/cpu.c
   drivers/mfd/db8500-prcmu.c

* Select clocking of indvidual ASIC IP blocks:
  drivers/mfd/db8500-prcmu.c
  arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h

* Provide some versioning numbers for the entire system
  drivers/misc/atmel-ssc.c
  arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h
  (Integrator, Versatile, RealView, Versatile Express)

* Enable and reset external buses such as PCI
  arch/arm/mach-integrator/pci_v3.c

* (De)protect flash memory
  arch/arm/mach-integrator/integrator_cp.c

* Provide a communication channel to another control unit
  drivers/mfd/mcp-core.c
  drivers/mfd/db8500-prcmu.c

* Set some clock divisors for misc units
  drivers/mfd/mcp-core.c
  (also PL810 as discussed recently)

* LEDs, GPIO etc communication channel
  drivers/mfd/asic3.c

* USB transciever control:
  arch/arm/mach-omap2/omap_phy_internal.c

* Get OTP (one-time-programmable) bits:
  arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h
  arch/powerpc/platforms/ps3/os-area.c
  arch/powerpc/platforms/chrp/nvram.c

* Set up DDR control registers:
  arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h

* Pin control:
  arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h

(Some non-ARM examples included for fun.)

As can be seen from the diverse examples there is a fit
to various extent to existing subsystems, and often mfd is
increasingly used as an arbitration point for other
subsystems.

The current way to split this problem is to:

- Push each subfunctionality into a specialized subsystem
  PLL and clocks to drivers/clk using the new framework
  RealSoonNow for example, pin control we have in place
  regulators can handle domain switches...

- Put in place an arbitration hub-like mechanism using MFD

This can be done in two ways:

- Permanently map the register range and let subdrivers
  poke directly into the registers they're interested in.

- Map the register range in a hub driver (often MFD) and
  write accessor functions for all subfunctionality.

As far as the drivers are small and nice the heterogeneous
character of these device register ranges are not much
of a problem. Some will argue to not fix what ain't broken
and not move these out of arch/arm/* at all.

What we need to discuss is if this is how we go about
taking care of these devices going forward - what shall be
the preferred design pattern?

My current assumption is that we need to get these things
out of arch/arm/* and into proper subsystems, using
drivers/mfd/* as an arbitration point. However I am not
sure that everyone really agrees on this. Right now it's
more a modus operandi and following what someone else
does than a conscious decision to do this.

We have discussed creating drivers/scm/* (system controller
modules) but I'm pretty unsure of what the definition of
such creatures would be, and the border toward MFD
would be pretty blurred.

x86 have conveniently put some of their equivalents under
drivers/platform/x86 but if I understood Arnd correctly
creating drivers/platform/arm would break the intentions
of that directory.

Thoughts, ideas?

Yours,
Linus Walleij
