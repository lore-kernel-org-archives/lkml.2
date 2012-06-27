Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab2F0W11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:27:27 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:55282 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932329Ab2F0W1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:27:22 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 3/8] ARM: LPC32xx: Remove wrong re-initialization of MMC clock register
Date: Thu, 28 Jun 2012 00:26:13 +0200
Message-Id: <1340835978-20331-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1340835978-20331-1-git-send-email-stigge@antcom.de>
References: <1340835978-20331-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug, (wrongfully) resetting the value of
LPC32XX_CLKPWR_MS_CTRL back to its initial contents (after careful setup). This
was discovered only with a board/bootloader combination (EA3250) where the
contents of the respective register wasn't already at the correct value on
Linux boot.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

---
 arch/arm/mach-lpc32xx/clock.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -871,7 +871,7 @@ static unsigned long mmc_round_rate(stru
 
 static int mmc_set_rate(struct clk *clk, unsigned long rate)
 {
-	u32 oldclk, tmp;
+	u32 tmp;
 	unsigned long prate, div, crate = mmc_round_rate(clk, rate);
 
 	prate = clk->parent->get_rate(clk->parent);
@@ -879,16 +879,12 @@ static int mmc_set_rate(struct clk *clk,
 	div = prate / crate;
 
 	/* The MMC clock must be on when accessing an MMC register */
-	oldclk = __raw_readl(LPC32XX_CLKPWR_MS_CTRL);
-	__raw_writel(oldclk | LPC32XX_CLKPWR_MSCARD_SDCARD_EN,
-		LPC32XX_CLKPWR_MS_CTRL);
 	tmp = __raw_readl(LPC32XX_CLKPWR_MS_CTRL) &
 		~LPC32XX_CLKPWR_MSCARD_SDCARD_DIV(0xf);
-	tmp |= LPC32XX_CLKPWR_MSCARD_SDCARD_DIV(div);
+	tmp |= LPC32XX_CLKPWR_MSCARD_SDCARD_DIV(div) |
+		LPC32XX_CLKPWR_MSCARD_SDCARD_EN;
 	__raw_writel(tmp, LPC32XX_CLKPWR_MS_CTRL);
 
-	__raw_writel(oldclk, LPC32XX_CLKPWR_MS_CTRL);
-
 	return 0;
 }
 
