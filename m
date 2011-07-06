Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1GFU5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:57:54 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:32900 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab1GFU5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:57:53 -0400
Date: Wed, 6 Jul 2011 14:57:52 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        Rajendra Nayak <rnayak@ti.com>,
        =?ISO-8859-15?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] OMAP: hwmod: add kernel cmdline flag to avoid resetting
 IP blocks during init
In-Reply-To: <20110706064116.GH5783@atomide.com>
Message-ID: <alpine.DEB.2.00.1107060155250.4217@utopia.booyaka.com>
References: <20110703010204.19046.85186.stgit@dusk> <20110703010206.19046.85293.stgit@dusk> <20110704085503.GQ23145@atomide.com> <alpine.DEB.2.00.1107051936250.4217@utopia.booyaka.com> <20110706064116.GH5783@atomide.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony

On Tue, 5 Jul 2011, Tony Lindgren wrote:

> So basically we want to tell the following from the board file or board
> specific .dts file:
> 
> - Device is being used on the board and can be reset and configured.
>   This is the usual case.

By 'used', you mean, have a Linux driver associated with them, right?

> - Device is being used on the board but can't be reset. This is the
>   case for booting Linux from other operating systems initially where
>   you want to keep the LCD on for debug console.

Or, to use examples that would be needed in a production device, the 
4460/N810 GPIO examples discussed earlier.  

Based on our current experience, there are a very small number of these 
cases, and they are board-specific.  So it seems to make sense to 
explicitly state these exceptions in the board files, via 
omap_hwmod_no_setup_reset() or something similar.

> - Device is not being used on the board but can be reset for decent PM.
>   This is often needed in cases where the bootloader just enables all the
>   clocks.

Yeah.  And it's not just bootloaders, it's also the previous kernel in the 
case of something like kexec.  Since we don't know what devices the 
bootloader or previous kernel touched, it seems to make sense to reset all 
of these devices by default, once the drivers are converted to use runtime 
PM.

The current issue here is that some drivers aren't yet converted, so the 
hwmod code might think that some devices are 'unused' when they are 
actually in use by a non-runtime-PM-based driver.
 
> - Device is reserved by secure mode or a coprocessor. In this case
>   the device can't be reset.

Indeed - or even accessed.

> So I guess that makes the flags noreset, disabled and unavailable?

I think we only need 'no reset' and 'unavailable'?  Once the runtime PM 
driver conversion is complete, I don't think there's any reason to keep 
the 'hwmod_unused_reset' command line flag around, since it can be the 
default.  That's because the hwmod code would then be able to track which 
devices were actually used.


- Paul
