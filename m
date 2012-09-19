Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2ISNgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:36:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58270 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2ISNfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:35:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 17/24] ARM: OMAP: use __iomem pointers for MMIO
Date: Wed, 19 Sep 2012 13:35:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Felipe Balbi <felipe.balbi@nokia.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, sricharan <r.sricharan@ti.com>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <20120916203850.GI4521@atomide.com> <20120917212506.GB11762@atomide.com>
In-Reply-To: <20120917212506.GB11762@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209191335.48051.arnd@arndb.de>
X-Provags-ID: V02:K0:plMAfJfxDvN8p5Sgy+7RI+3xno0BSG9gLLBrj404S+w
 9M2QaRyBnP3NbzVKxSqxHPtKRATkbOMpckYqsvfYSjfilaKttW
 Tt25fnYBEY1zfERk919dPrgGXnZkpgDf8+G2mpxu/mmMhSX+5I
 W0eeCGT3eXQozAlERZDKOxovoAKMQ3nJToNW7QoBXDhF4rTKB6
 YCm6Zvk1GrlI2/aKT2gI7JELsRpaIltVORaXj+QwuQysK8DXv7
 SFTIcD7Ukye/wY8MUwT1KOGgNlNW10DkK5D6k7+4eyu/17uKV+
 tLsAsdOEAwNYxxbPASj8lxCJ1TuZMWTyhE4QgYvN2puL58duuW
 z149tlC2xvI9tPeAHaaY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2012, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [120916 13:39]:
> > * Arnd Bergmann <arnd@arndb.de> [120915 13:15]:
> > > On Saturday 15 September 2012, Tony Lindgren wrote:
> > > > With my patches, this is now all omap1 specific and
> > > > moved to arch/arm/mach-omap1/include/mach/hardware.h.
> > > > It's probably easiest to just update this patch on
> > > > top of the hardware.h changes I've done.
> > > 
> > > Yes, sounds good. Do you want to send a patch for that
> > > and let me drop this one then?
> > 
> > Yes I can pick this one and update it against one of my
> > branches to avoid merge conflicts.
> 
> This applies against mach-omap1/include/mach/hardware.h
> with some fuzz so no issues there.
> 
> But I think we should not apply it as these are physical
> addresses, not virtual addresses for omap1.

Right, I misread what is actually going on here because the
only driver I looked at treated the address as a virtual
address pointer.

> We have IOMEM already in use for omap_read/write because of:
> 
> #define OMAP1_IO_ADDRESS(pa)    IOMEM((pa) - OMAP1_IO_OFFSET)
> 
> I think the right solution is to eventually get rid of
> omap_read/write for omap1 also and replace them with ioremap
> + readl/writel.

Agreed.

> Or am I missing something?

I did not see any new warnings for omap1, but I did see this
on omap2plus_defconfig:

drivers/watchdog/omap_wdt.c: In function 'omap_wdt_ioctl':
drivers/watchdog/omap_wdt.c:222:4: error: passing argument 1 of '__raw_readw' makes pointer from integer without a cast [-Werror]
arch/arm/include/asm/io.h:71:90: note: expected 'const volatile void *' but argument is of type 'unsigned int'

It seems I misinterpreted this, and it's actually a bug in the watchdog
driver that should be fixed using this patch instead (and backport it
to stable)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index fceec4f..7b45802 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -218,9 +218,11 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 	case WDIOC_GETSTATUS:
 		return put_user(0, (int __user *)arg);
 	case WDIOC_GETBOOTSTATUS:
+#ifdef CONFIG_ARCH_OMAP1
 		if (cpu_is_omap16xx())
-			return put_user(__raw_readw(ARM_SYSST),
+			return put_user(omap_readw(ARM_SYSST),
 					(int __user *)arg);
+#endif
 		if (cpu_is_omap24xx())
 			return put_user(omap_prcm_get_reset_sources(),
 					(int __user *)arg);

This bug seems to have been introduced in 2008 by 9f69e3b0c "[WATCHDOG]
omap_wdt.c: another ioremap() fix" without anyone ever noticing and now
got caught. Of course it should be replaced by something better when
omap_read/write is finally getting removed.

I'll drop my omap patch for now, because it's obviously wrong, and let
you guys figure out what to do about the watchdog driver.

	Arnd
