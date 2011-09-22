Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1IVXcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:32:03 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:54834 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1IVXcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:32:00 -0400
Date: Thu, 22 Sep 2011 17:31:59 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
cc: "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        "parthab@india.ti.com" <parthab@india.ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Subject: Re: [PATCH 1/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <4E7B8C68.7020407@ti.com>
Message-ID: <alpine.DEB.2.00.1109221524560.10719@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221213500.10719@utopia.booyaka.com> <4E7B8C68.7020407@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, 22 Sep 2011, Cousson, Benoit wrote:

> ADDR_TYPE_RT is mainly use for sysconfig access inside hwmod core today, so
> why should we use it in this case?

Just for consistency, since the flag isn't defined to be 
SYSCONFIG-specific.

That way, if there's another need -- other than SYSCONFIG access -- to 
identify the chunk of address space that's used for register access, we 
won't have to dig through and possibly repatch the hwmod data, just 
because some people didn't want to follow the rule.

If the flag was simply defined to be SYSCONFIG-specific, then you're 
right, it wouldn't be needed.

> To be honest, I've been confused with that flag for some time :-)
>  * ADDR_TYPE_RT: Address space contains module register target data.
> Maybe that's my English, but what does "register target data" mean exactly?

The name comes from the L3 section of the 34xx TRM - see for example 
section 9.1.1 "Terminology" of the rev ZR TRM.  The L3 has several address 
space sections, and whoever wrote that text -- Sonics? -- called the one 
with the L3's own internal registers the "register target."  And I was 
looking for a name that I did not have to make up, so I personally 
wouldn't have to defend the name ;-)

> What was the intent? Providing a way to identify some register vs memory
> space?

As you suggest, the original impetus for the flag was to identify which 
chunk of address space needs to be mapped by the hwmod code for SYSCONFIG 
accesses to work.  On current OMAPs, this seems to be the same thing as 
identifying the IP block's primary register area for every module with 
SYS* and REVISION registers.  And I probably thought at the time that 
specifying the IP block's main register mapping seemed more useful and 
generally applicable than designating where the SYSCONFIG register was.  
Hence the current definition.

> Regarding main_clk, I do not think that some internal IPs like ohci/ehci
> should have a main_clk, since this is not visible at that level. 

Do you not agree that every IP block that contains sequential logic on 
current and foreseeable future SoCs must have some clock signal to drive 
that logic?

The idea of the main_clk was not intended to be PRCM or OCP or even 
OMAP-specific.  It's just intended to represent a clock that is used to 
drive the register logic inside the IP block.  Therefore it must be 
enabled before any register access may occur.  Even if clock gating is 
handled by some higher-level interface (e.g., at the IP block level), the 
main_clk has a rate, so it also implies an upper limit on how quickly 
register operations can occur.  I suppose that all of the IP block's 
clocks could be "optional clocks," but we know that every IP block with 
registers requires at least one clock to work, and that should be the 
main_clk.

> These blocks do not have any PRCM / OCP connection.  In fact they should 
> not even be hwmod in theory, these are just some internal IPs inside the 
> usb_host controller. 

After looking at the OMAP USB host controller drivers, particularly 
drivers/mfd/omap-usb-host.c, I completely agree: it's not just theory: 
OMAP shouldn't have EHCI and OHCI hwmods in practice, either :-)

> These are hwmods just because of the dynamic mux support needed by these 
> IPs. That was one of the comments I made on these, and Keshava explained 
> me the rational and added it in the changelog.

On OMAP, since the EHCI and OHCI IP blocks are integrated into the UHH IP 
block, an MFD driver creates the EHCI and OHCI platform_devices (see 
drivers/mfd/omap-usb-host.c:omap_usbhs_alloc_children()).  On OMAP, the 
EHCI and OHCI aren't hwmod-backed devices, and so they shouldn't be using 
the hwmod dynamic pin remuxing code directly.

So I'd suggest one of two approaches:

1. If the pin muxing can follow the PM runtime status of the UHH IP block, 
   then the pin mux data should be associated with the UHH hwmod.

2. If the pin muxing must follow the EHCI/OHCI IP block PM runtime status, 
   then drivers/mfd/omap-usb-host.c is what should be handling the 
   remuxing.  omap-usb-host.c can set the dev_pm_ops of the EHCI/OHCI
   platform_devices to point to functions either in 
   arch/arm/mach-omap2/usb-host.c, or local functions that call into 
   mach-omap2/usb-host.c functions to handle pin remuxing.  (Those 
   function pointers should be provided to the MFD driver in some clean way, 
   like via platform_data.)

> Hopefully, we will not have that limitation once we will have migrated 
> that to DT :-)

Even if the data is coming from some other source, if the code still 
relies on main_clk, then it will need to be present.

But why do you perceive that specifying a main_clk is a limitation?  Or, 
put differently: what problem is caused by specifying a main_clk here?


- Paul
