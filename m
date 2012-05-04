Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab2EDMZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:25:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60863 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab2EDMZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:25:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: Making ARM multiplatform kernels DT-only?
Date: Fri, 4 May 2012 12:20:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, linaro-dev@lists.linaro.org,
        Jason Cooper <jason@lakedaemon.net>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
References: <201205031350.35476.arnd@arndb.de> <20120503140428.GB897@n2100.arm.linux.org.uk>
In-Reply-To: <20120503140428.GB897@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041220.24747.arnd@arndb.de>
X-Provags-ID: V02:K0:eFqGIuU1R5ST9gYejab1OFvuhVM+pWEgE80Tms9gt6P
 i1ykm94HpkcfsdwziZAa7BYKo5CtjueuCHE1GUk70wY/3Hrrq8
 c8MXNhq/S2c6ewmlc2V3mjkAez4WS7hTuxkXYT3RY8Kl4pJpte
 CMK0kUENYwxQftFmwOPO+sYJP0QZK8k6cOtkqfcSGfYrdRBJCE
 Knf+hojm9Q0I8845XVqAAdt4QVkN38eMqKzOb1Ymjg0tddSOHR
 i5X8ZOYZr/1aqkvDi6VFb+sZt+DkTjZPlRLnkWg8biZs8rIG/k
 PXDI6TUUULjf/fxX2Jf7lWq6AEPQexCLAnNyaHW9HLnkUsgKRg
 Bdp9umFBHRwf2mLA6Ec4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2012, Russell King - ARM Linux wrote:
> I'm basing my comments off mach-zynq.

It's a different question because mach-zynq is already DT-only, but we
can also discuss this for a bit.

> How about we take the following steps towards it?
> 
> 1. create arch/arm/include/mach/ which contains standardized headers
>    for DT based implementations.  This must include all headers included
>    by asm/ or linux/ includes.  This will also be the only mach/ header
>    directory included for code outside of arch/arm/mach-*.  This also
>    acts as the 'default' set of mach/* includes for stuff like timex.h
>    and the empty hardware.h
>
> 2. DT based mach-* directories do not have an include directory; their
>    include files must be located in the main include/ heirarchy if shared
>    with other parts of the kernel, otherwise they must be in the mach-*
>    directory.

My idea for the header files was slightly different, reorganizing only
the headers that actually conflict between the platforms renaming the
ones that conflict by name but not by content.

I know you are aware of my experiment with just renaming the header files
from mach/*.h to mach-*/*.h, and that has helped me a lot in understanding
the specific problems. I don't care about the specific names of the headers
but it has helped so far in identifying which drivers are already relying
on a specific platform's version of a header and which ones multiplex
between different platforms (e.g. sa1100/pxa/mmp or s3c*/s5p*/exynos)
and need more work. 

I also wouldn't change anything for the current configurations where
you only have one mach-* directory at a time (or the samsung speciality).

My plan is to have multiplatform kernels in parallel with what we have now,
so we can avoid breaking working machines but also play with multiplatform
configurations at the same time for a subset of the platforms and with
certain restrictions (not all board files, not all drivers, no generic
early printk, ...).

> 3. Allow build multiple mach-* directories (which we already do... see
>    the samsung stuff.)

Incidentally, the samsung headers are what are currently causing the most
headaches regarding the header files, because they use a lot of files
with soc-specific definitions for the same symbols, which means significant
reorganization of the code using to to turn that into run-time selectable
values.

> We still have irqs.h being SoC dependent, and we still haven't taken
> debug-macros.S far enough along to get rid of that.

I believe the irqs.h conflict is only for the NR_IRQS constant, all other
defines in there should only be used inside of the mach-* directory,
or not at all for fully DT-based platforms.

> Then there's also the problem of uncompress.h.  The last piece of the
> puzzle is the common clock stuff.

Initially, I think we can live without debug-macros.S and uncompress.h
and change the code using those to just not output anything when
MULTIPLATFORM is enabled: you'd have to disable MULTIPLATFORM in order
to debug the early boot process and hope that any bugs are not
specific to multiplatform configurations. In the long run, we probably
want to have a better solution, but it's not on my hotlist.

The common clock support OTOH is definitely a requirement as soon as
we want to actually run multiplatform kernels rather than just building
them.
 
> So, I think we're still a way off it yet - maybe six months or so.

True, but in order to work on the points you raised and a few others,
I would like to know where we're heading because it does impact
some decisions like whether we need to make all initcalls in non-DT
board files aware of potentially being run on other platforms.

	Arnd
