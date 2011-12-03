Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1LCBEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:04:45 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:45760 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab1LCBEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:04:44 -0500
Date: Fri, 2 Dec 2011 18:04:43 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Turquette, Mike" <mturquette@ti.com>, linus.walleij@stericsson.com,
        patches@linaro.org, shawn.guo@freescale.com, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        richard.zhao@linaro.org, grant.likely@secretlab.ca, dsaxena@linaro.org,
        eric.miao@linaro.org, sboyd@quicinc.com, skannan@quicinc.com,
        linaro-dev@lists.linaro.org, jeremy.kerr@canonical.com,
        linux-omap@vger.kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
In-Reply-To: <20111201220337.GE19739@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1112021440270.6289@utopia.booyaka.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1111291619110.6289@utopia.booyaka.com> <CAJOA=zM4vcyTt_RBEVm6JxmzW-Dna0gpuWda7ytq_mqFSuXw9g@mail.gmail.com>
 <alpine.DEB.2.00.1111302308280.6289@utopia.booyaka.com> <20111201144205.GA2103@sirena.org.uk> <alpine.DEB.2.00.1112011124221.6289@utopia.booyaka.com> <20111201220337.GE19739@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011, Russell King - ARM Linux wrote:

> On Thu, Dec 01, 2011 at 11:30:16AM -0700, Paul Walmsley wrote:
> > The intention behind the clk_{allow,block}_rate_change() proposal was to 
> > allow the current user of the clock to change its rate without having to 
> > call clk_{allow,block}_rate_change(), if that driver was the sole user of 
> > the clock.
> 
> And how does a driver know that?

The driver author might make this assumption when the device's upstream 
clock tree is simple.  This assumption simplifies the driver's clock code, 
since no clock rate change notifier callback would be needed.

This should be possible:

1. when there are no other users of the device's upstream clocks; or,

2. when a subset of the device's upstream clock tree can be used by
   other devices, but the rates or source clocks of that subset either 
   cannot be changed, or should never change.

For example, consider an external audio codec device, such as the 
TLV320AIC23.  The input clock source rate for this chip is likely to be 
fixed for a given board design[1].  So the driver wouldn't need a clock 
rate change notifier callback for its input clock source, since it would 
never be called.  The clock dividers inside the codec may be represented 
by clock nodes, but since they are handled by the same driver, the 
coordination between them doesn't require any notifier callbacks.

Another example would be a device that shares a portion of its upstream 
clock tree with other devices, where the upstream clock tree is designed 
to run at the same rate for all of the devices, such as the USIM IP block 
on OMAP3430/3630[2].  The USIM shares a dedicated DPLL with the USBHOST 
and USBTLL devices, but the DPLL is only intended to be programmed at a 
single rate.  When the USIM is using this DPLL as a clock source, a 
dedicated downstream clock divider is available that can be used to reduce 
the USIM's input clock rate.  So the USIM driver would also not require 
any clock rate change notifier callbacks, since the shared portions of its 
parent clock tree should never change.

Of course, it is possible that a new chip could appear with an identical 
IP block inside it, but where cases 1 and 2 above are no longer true.  
The worst outcome is that the driver's clk_set_rate() may no longer 
succeed, returning -EBUSY, since another device may be blocking the rate 
change.  The remedy is to update the driver to add the rate change 
callback, and the associated internal logic to deal with it.


- Paul

1. Texas Instruments, _TLV320AIC23 Stereo Audio CODEC, 8- to 96-kHz, With 
   Integrated Headphone Amplifier Data Manual_ (SLWS106D), May 2002, 
   Section 3.3.2 "Audio Sampling Rates" and section 1.2 "Functional Block 
   Diagram".   Available from http://www.ti.com/lit/gpn/tlv320aic23
   (among others)

2. Linux kernel v3.1-rc4, arch/arm/mach-omap2/clock3xxx_data.c, 
   usim_clksel (line 2300).  Available from 
   http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux.git;a=blob;f=arch/arm/mach-omap2/clock3xxx_data.c;h=5d0064a4fb5a638bb1141489354244e95899c1a1;hb=HEAD#l2300
   (among others)


