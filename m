Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab2J2WCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:02:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:47874 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761345Ab2J2Vhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [ 076/101] ARM: at91: fix external interrupts in non-DT case
Date: Mon, 29 Oct 2012 14:35:29 -0700
Message-Id: <20121029213248.765524647@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 738a0fd752dc60e20beeda6f2f0f62e58dc0e344 upstream.

Management of external interrupts has changed but the
non-DT code has not integrated these changes.
Add a mask to pass external irq specification from SoC
specific code to the at91_aic_init() function.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/generic.h |    3 ++-
 arch/arm/mach-at91/irq.c     |    9 +++++++--
 arch/arm/mach-at91/setup.c   |    2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -26,7 +26,8 @@ extern void __init at91_dt_initialize(vo
 extern void __init at91_init_irq_default(void);
 extern void __init at91_init_interrupts(unsigned int priority[]);
 extern void __init at91x40_init_interrupts(unsigned int priority[]);
-extern void __init at91_aic_init(unsigned int priority[]);
+extern void __init at91_aic_init(unsigned int priority[],
+				 unsigned int ext_irq_mask);
 extern int  __init at91_aic_of_init(struct device_node *node,
 				    struct device_node *parent);
 extern int  __init at91_aic5_of_init(struct device_node *node,
--- a/arch/arm/mach-at91/irq.c
+++ b/arch/arm/mach-at91/irq.c
@@ -502,14 +502,19 @@ int __init at91_aic5_of_init(struct devi
 /*
  * Initialize the AIC interrupt controller.
  */
-void __init at91_aic_init(unsigned int *priority)
+void __init at91_aic_init(unsigned int *priority, unsigned int ext_irq_mask)
 {
 	unsigned int i;
 	int irq_base;
 
-	if (at91_aic_pm_init())
+	at91_extern_irq = kzalloc(BITS_TO_LONGS(n_irqs)
+				  * sizeof(*at91_extern_irq), GFP_KERNEL);
+
+	if (at91_aic_pm_init() || at91_extern_irq == NULL)
 		panic("Unable to allocate bit maps\n");
 
+	*at91_extern_irq = ext_irq_mask;
+
 	at91_aic_base = ioremap(AT91_AIC, 512);
 	if (!at91_aic_base)
 		panic("Unable to ioremap AIC registers\n");
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -47,7 +47,7 @@ void __init at91_init_irq_default(void)
 void __init at91_init_interrupts(unsigned int *priority)
 {
 	/* Initialize the AIC interrupt controller */
-	at91_aic_init(priority);
+	at91_aic_init(priority, at91_extern_irq);
 
 	/* Enable GPIO interrupts */
 	at91_gpio_irq_setup();


