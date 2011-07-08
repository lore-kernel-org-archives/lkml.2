Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1GHFRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:17:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab1GHFCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:56 2011
Message-Id: <20110708001656.008955390@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Boojin Kim <boojin.kim@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [034/107] ARM: SAMSUNG: serial: Fix on handling of one clock source for UART
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Boojin Kim <boojin.kim@samsung.com>

commit 470f22975448a65a1084a6f0721fa5df15323f02 upstream.

This patch fixes the way of comparison for handling of two or more
clock sources for UART.

For example, if just only one clock source is defined even though
there are two clock sources for UART, the serial driver does not
set proper clock up. Of course, it is problem.

So this patch changes the condition of comparison to avoid useless
setup clock and adds a flag 'NO_NEED_CHECK_CLKSRC' which means
selection of source clock is not required.

In addition, since the Exynos4210 has only one clock source for UART
this patch adds the flag into its common_init_uarts().

Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-exynos4/init.c                     |    1 +
 arch/arm/plat-samsung/include/plat/regs-serial.h |    2 ++
 drivers/tty/serial/s5pv210.c                     |    4 ++--
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-exynos4/init.c
+++ b/arch/arm/mach-exynos4/init.c
@@ -35,6 +35,7 @@ void __init exynos4_common_init_uarts(st
 			tcfg->clocks = exynos4_serial_clocks;
 			tcfg->clocks_size = ARRAY_SIZE(exynos4_serial_clocks);
 		}
+		tcfg->flags |= NO_NEED_CHECK_CLKSRC;
 	}
 
 	s3c24xx_init_uartdevs("s5pv210-uart", s5p_uart_resources, cfg, no);
--- a/arch/arm/plat-samsung/include/plat/regs-serial.h
+++ b/arch/arm/plat-samsung/include/plat/regs-serial.h
@@ -224,6 +224,8 @@
 #define S5PV210_UFSTAT_RXMASK	(255<<0)
 #define S5PV210_UFSTAT_RXSHIFT	(0)
 
+#define NO_NEED_CHECK_CLKSRC	1
+
 #ifndef __ASSEMBLY__
 
 /* struct s3c24xx_uart_clksrc
--- a/drivers/tty/serial/s5pv210.c
+++ b/drivers/tty/serial/s5pv210.c
@@ -31,7 +31,7 @@ static int s5pv210_serial_setsource(stru
 	struct s3c2410_uartcfg *cfg = port->dev->platform_data;
 	unsigned long ucon = rd_regl(port, S3C2410_UCON);
 
-	if ((cfg->clocks_size) == 1)
+	if (cfg->flags & NO_NEED_CHECK_CLKSRC)
 		return 0;
 
 	if (strcmp(clk->name, "pclk") == 0)
@@ -56,7 +56,7 @@ static int s5pv210_serial_getsource(stru
 
 	clk->divisor = 1;
 
-	if ((cfg->clocks_size) == 1)
+	if (cfg->flags & NO_NEED_CHECK_CLKSRC)
 		return 0;
 
 	switch (ucon & S5PV210_UCON_CLKMASK) {


