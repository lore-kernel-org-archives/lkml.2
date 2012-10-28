Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2J1Ufo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:35:44 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:56314 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753192Ab2J1Ufn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:35:43 -0400
From: Roland Stigge <stigge@antcom.de>
To: tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        benh@kernel.crashing.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 2/3] ARM: LPC32xx: Relocate calls to irq_set_chained_handler()
Date: Sun, 28 Oct 2012 21:35:21 +0100
Message-Id: <1351456522-22309-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351456522-22309-1-git-send-email-stigge@antcom.de>
References: <1351456522-22309-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the issue of an access to a yet uninitialized data structure
at the point where irq_set_chained_handler() was called by moving the
respective calls to the end of lpc32xx_init_irq().

The call path was:

irq_set_chained_handler()
-> __irq_set_handler()
-> irq_startup()
-> irq_enable()
-> desc->irq_data.chip->irq_unmask()

at which point lpc32xx_unmask_irq() effectively read desc->irq_data.hwirq which
was only later initialized.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-lpc32xx/irq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/irq.c
+++ linux-2.6/arch/arm/mach-lpc32xx/irq.c
@@ -447,10 +447,6 @@ void __init lpc32xx_init_irq(void)
 	__raw_writel(0, LPC32XX_INTC_MASK(LPC32XX_SIC1_BASE));
 	__raw_writel(0, LPC32XX_INTC_MASK(LPC32XX_SIC2_BASE));
 
-	/* MIC SUBIRQx interrupts will route handling to the chain handlers */
-	irq_set_chained_handler(IRQ_LPC32XX_SUB1IRQ, lpc32xx_sic1_handler);
-	irq_set_chained_handler(IRQ_LPC32XX_SUB2IRQ, lpc32xx_sic2_handler);
-
 	/* Initially disable all wake events */
 	__raw_writel(0, LPC32XX_CLKPWR_P01_ER);
 	__raw_writel(0, LPC32XX_CLKPWR_INT_ER);
@@ -479,4 +475,8 @@ void __init lpc32xx_init_irq(void)
 						   NULL);
 	if (!lpc32xx_mic_domain)
 		panic("Unable to add MIC irq domain\n");
+
+	/* MIC SUBIRQx interrupts will route handling to the chain handlers */
+	irq_set_chained_handler(IRQ_LPC32XX_SUB1IRQ, lpc32xx_sic1_handler);
+	irq_set_chained_handler(IRQ_LPC32XX_SUB2IRQ, lpc32xx_sic2_handler);
 }
