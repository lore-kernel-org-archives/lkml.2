Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab2DDMg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:36:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61240 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2DDMg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:36:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 1/5] ARM: remove ixp23xx and ixp2000 platforms
Date: Wed, 4 Apr 2012 12:35:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Russell Nelson <nelson@crynwr.com>
References: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204041235.32648.arnd@arndb.de>
X-Provags-ID: V02:K0:sKAu1J1xQ4TCx4QGf5j1K0DfHd5viKwY+OzJTwju74z
 6uVvDMSqSQdwvsE30PXY0J/eOvDKufuiGR6qtFrZP1+oR3mxWl
 wlp2r83c7i39sFzgu00Vgqfw6KjQK+f8BFdaPPpacedIb8xEtY
 9glXaO6rZuy4+1i4qBWqWsYIpwIAa5n7kyV+roTswMixhlg7qD
 f1AA0erK2pPKDsLWCbX/9aWsDm6rb7yAOAVFdm00lX3fb4C56N
 loheUG20737124BlPu4wBqDryQoHEHwHhjhp4Trzb/Hlo3YkX2
 E4aN2TEdXYGF56rWeSWeRAclhgzviBP0IaOI9uW1VhGeudLaDp
 NBcsTjYdSKg2vuAp4OEA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2012, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> ixp2xxx platforms have had no real changes since ~2006 and the maintainer
> has said on irc that they can be removed:
> 
> 13:05 < nico> do you still care about ixp2000?
> 13:22 < lennert> not really, no
> 13:58 < nico> do you think we could remove it from the kernel tree?
> 14:01 < lennert> go for it, and remove ixp23xx too while you're at it
> 
> Removing will help simplify ARM consolidation in general and PCI re-work
> specifically.

This will let us kill another bit of ugly code:
8<-----
[PATCH] net: cs89x0: remove ixp2xxx specific hacks

The IXDP2351 and IXDP2X01 machines are getting removed from the kernel, so there
is no longer a need to special-case them in the cs89x0 driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/cirrus/cs89x0.c |   36 ----------------------------------
 1 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index b9406cb..6b92080 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -173,21 +173,11 @@ static char version[] __initdata =
 /* The cs8900 has 4 IRQ pins, software selectable. cs8900_irq_map maps
    them to system IRQ numbers. This mapping is card specific and is set to
    the configuration of the Cirrus Eval board for this chip. */
-#if defined(CONFIG_MACH_IXDP2351)
-#define CS89x0_NONISA_IRQ
-static unsigned int netcard_portlist[] __used __initdata = {IXDP2351_VIRT_CS8900_BASE, 0};
-static unsigned int cs8900_irq_map[] = {IRQ_IXDP2351_CS8900, 0, 0, 0};
-#elif defined(CONFIG_ARCH_IXDP2X01)
-#define CS89x0_NONISA_IRQ
-static unsigned int netcard_portlist[] __used __initdata = {IXDP2X01_CS8900_VIRT_BASE, 0};
-static unsigned int cs8900_irq_map[] = {IRQ_IXDP2X01_CS8900, 0, 0, 0};
-#else
 #ifndef CONFIG_CS89x0_PLATFORM
 static unsigned int netcard_portlist[] __used __initdata =
    { 0x300, 0x320, 0x340, 0x360, 0x200, 0x220, 0x240, 0x260, 0x280, 0x2a0, 0x2c0, 0x2e0, 0};
 static unsigned int cs8900_irq_map[] = {10,11,12,5};
 #endif
-#endif
 
 #if DEBUGGING
 static unsigned int net_debug = DEBUGGING;
@@ -345,31 +335,6 @@ out:
 #endif
 #endif
 
-#if defined(CONFIG_MACH_IXDP2351)
-static u16
-readword(unsigned long base_addr, int portno)
-{
-	return __raw_readw(base_addr + (portno << 1));
-}
-
-static void
-writeword(unsigned long base_addr, int portno, u16 value)
-{
-	__raw_writew(value, base_addr + (portno << 1));
-}
-#elif defined(CONFIG_ARCH_IXDP2X01)
-static u16
-readword(unsigned long base_addr, int portno)
-{
-	return __raw_readl(base_addr + (portno << 1));
-}
-
-static void
-writeword(unsigned long base_addr, int portno, u16 value)
-{
-	__raw_writel(value, base_addr + (portno << 1));
-}
-#else
 static u16
 readword(unsigned long base_addr, int portno)
 {
@@ -381,7 +346,6 @@ writeword(unsigned long base_addr, int portno, u16 value)
 {
 	outw(value, base_addr + portno);
 }
-#endif
 
 static void
 readwords(unsigned long base_addr, int portno, void *buf, int length)
