Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1HaQSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:18:34 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:35416 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab1HaQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:18:30 -0400
Date: Wed, 31 Aug 2011 18:18:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Luciano Coelho <coelho@ti.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, matti.j.aaltonen@nokia.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] mfd: Combine MFD_SUPPORT and MFD_CORE
Message-ID: <20110831181807.4be09f72@endymion.delvare>
In-Reply-To: <1314643307-17780-1-git-send-email-coelho@ti.com>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net>
	<1314643307-17780-1-git-send-email-coelho@ti.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luciano,

On Mon, 29 Aug 2011 21:41:47 +0300, Luciano Coelho wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Combine MFD_SUPPORT (which only enabled the remainder of the MFD
> menu) and MFD_CORE.  This allows other drivers to select MFD_CORE
> without needing to also select MFD_SUPPORT, which fixes some
> kconfig unmet dependency warnings.  Modeled after I2C kconfig.
> 
> [Forward-ported to 3.1-rc4.  This fixes a warning when some drivers,
> such as RADIO_WL1273, are selected, but MFD_SUPPORT is not. -- Luca]

I like the idea in general, this makes things much simpler.

There is at least one issue with your current implementation though.
"make oldconfig" has this to complain about:

drivers/mfd/Kconfig:5:error: recursive dependency detected!
drivers/mfd/Kconfig:5:	symbol MFD_CORE is selected by OLPC_XO1_PM
arch/x86/Kconfig:2028:	symbol OLPC_XO1_PM depends on MFD_CS5535
drivers/mfd/Kconfig:613:	symbol MFD_CS5535 depends on MFD_CORE

Not sure if it is really caused by your patch or only revealed by it,
but it should be fixed anyway. The following should fix it, please
consider folding in your patch:

--- linux-3.1-rc4.orig/arch/x86/Kconfig	2011-08-16 11:49:42.000000000 +0200
+++ linux-3.1-rc4/arch/x86/Kconfig	2011-08-31 16:54:09.000000000 +0200
@@ -2028,7 +2028,6 @@ config OLPC
 config OLPC_XO1_PM
 	bool "OLPC XO-1 Power Management"
 	depends on OLPC && MFD_CS5535 && PM_SLEEP
-	select MFD_CORE
 	---help---
 	  Add support for poweroff and suspend of the OLPC XO-1 laptop.
 
@@ -2044,7 +2043,6 @@ config OLPC_XO1_SCI
 	depends on OLPC && OLPC_XO1_PM
 	select POWER_SUPPLY
 	select GPIO_CS5535
-	select MFD_CORE
 	---help---
 	  Add support for SCI-based features of the OLPC XO-1 laptop:
 	   - EC-driven system wakeups

> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
> 
> I guess this should fix the problem.  I've simple forward-ported
> Randy's patch to the latest mainline kernel.  I don't know via which
> tree this should go in, though.

Samuel Ortiz is the maintainer of the mfd subsystem, so his tree would
be an obvious choice.

> NOTE: I have *not* tested this very thoroughly.  But at least
> omap2plus stuff seems to work okay with this change.  MFD_SUPPORT is
> also selected by a couple of "tile" platforms defconfigs, but I guess
> the Kconfig system should take care of it.

I can't test it either, but it looks sane to me. If you merge the
proposed changes above, you can add:

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
