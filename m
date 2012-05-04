Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2EDQji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:39:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48324 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2EDQjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:39:37 -0400
Message-ID: <4FA40642.5040203@gmail.com>
Date: Fri, 04 May 2012 11:39:30 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        linaro-dev@lists.linaro.org, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Making ARM multiplatform kernels DT-only?
References: <201205031350.35476.arnd@arndb.de> <20120503140428.GB897@n2100.arm.linux.org.uk> <201205041220.24747.arnd@arndb.de>
In-Reply-To: <201205041220.24747.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 07:20 AM, Arnd Bergmann wrote:
> On Thursday 03 May 2012, Russell King - ARM Linux wrote:
>> I'm basing my comments off mach-zynq.
> 
> It's a different question because mach-zynq is already DT-only, but we
> can also discuss this for a bit.
> 
>> How about we take the following steps towards it?
>>
>> 1. create arch/arm/include/mach/ which contains standardized headers
>>    for DT based implementations.  This must include all headers included
>>    by asm/ or linux/ includes.  This will also be the only mach/ header
>>    directory included for code outside of arch/arm/mach-*.  This also
>>    acts as the 'default' set of mach/* includes for stuff like timex.h
>>    and the empty hardware.h
>>
>> 2. DT based mach-* directories do not have an include directory; their
>>    include files must be located in the main include/ heirarchy if shared
>>    with other parts of the kernel, otherwise they must be in the mach-*
>>    directory.
> 
> My idea for the header files was slightly different, reorganizing only
> the headers that actually conflict between the platforms renaming the
> ones that conflict by name but not by content.
> 
> I know you are aware of my experiment with just renaming the header files
> from mach/*.h to mach-*/*.h, and that has helped me a lot in understanding
> the specific problems. I don't care about the specific names of the headers
> but it has helped so far in identifying which drivers are already relying
> on a specific platform's version of a header and which ones multiplex
> between different platforms (e.g. sa1100/pxa/mmp or s3c*/s5p*/exynos)
> and need more work. 
> 
> I also wouldn't change anything for the current configurations where
> you only have one mach-* directory at a time (or the samsung speciality).
> 
> My plan is to have multiplatform kernels in parallel with what we have now,
> so we can avoid breaking working machines but also play with multiplatform
> configurations at the same time for a subset of the platforms and with
> certain restrictions (not all board files, not all drivers, no generic
> early printk, ...).
> 

Many of the headers are simply platform_data structs which may still be
needed on DT platforms, but could be moved elsewhere.

>> 3. Allow build multiple mach-* directories (which we already do... see
>>    the samsung stuff.)
> 
> Incidentally, the samsung headers are what are currently causing the most
> headaches regarding the header files, because they use a lot of files
> with soc-specific definitions for the same symbols, which means significant
> reorganization of the code using to to turn that into run-time selectable
> values.
> 
>> We still have irqs.h being SoC dependent, and we still haven't taken
>> debug-macros.S far enough along to get rid of that.
> 
> I believe the irqs.h conflict is only for the NR_IRQS constant, all other
> defines in there should only be used inside of the mach-* directory,
> or not at all for fully DT-based platforms.

A DT-enabled platform does not need irqs.h or NR_IRQS. SPARSE_IRQ should
be selected for DT. However, some DT enabled platforms don't have all
irq chips converted to domains and may still need to set the mach .nr_irqs.

> 
>> Then there's also the problem of uncompress.h.  The last piece of the
>> puzzle is the common clock stuff.

The smp/hotplug/localtimer related functions are still global. Marc Z
has posted patches for this, but I haven't seen recent activity. This
and clocks were the 2 main issues I saw trying to build 2 platforms
together. highbank and picoxcell could be built together since only
highbank has clocks and smp.

gpio.h is still required, but empty for most platforms.

Rob

> Initially, I think we can live without debug-macros.S and uncompress.h
> and change the code using those to just not output anything when
> MULTIPLATFORM is enabled: you'd have to disable MULTIPLATFORM in order
> to debug the early boot process and hope that any bugs are not
> specific to multiplatform configurations. In the long run, we probably
> want to have a better solution, but it's not on my hotlist.
> 
> The common clock support OTOH is definitely a requirement as soon as
> we want to actually run multiplatform kernels rather than just building
> them.
>  
>> So, I think we're still a way off it yet - maybe six months or so.
> 
> True, but in order to work on the points you raised and a few others,
> I would like to know where we're heading because it does impact
> some decisions like whether we need to make all initcalls in non-DT
> board files aware of potentially being run on other platforms.
> 
> 	Arnd
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

