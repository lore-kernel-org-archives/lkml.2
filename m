Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935015Ab2JXPeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:34:25 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11102 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933942Ab2JXPeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:34:23 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <voice.shen@atmel.com>,
        <marek.belisko@open-nandra.com>, <ivan.shugov@gmail.com>,
        <josh.wu@atmel.com>
Subject: [PATCH 3/8] ARM: at91: fix external interrupts in non-DT case
Date: Wed, 24 Oct 2012 17:33:52 +0200
Message-ID: <d431a4eca966e5faf17cc3c3af2fe1653bf2f2c5.1351092432.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <cover.1351092432.git.nicolas.ferre@atmel.com>
References: <cover.1351092432.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Management of external interrupts has changed but the
non-DT code has not integrated these changes.
Add a mask to pass external irq specification from SoC
specific code to the at91_aic_init() function.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> [v3.6]
---
 arch/arm/mach-at91/generic.h | 3 ++-
 arch/arm/mach-at91/irq.c     | 9 +++++++--
 arch/arm/mach-at91/setup.c   | 2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index f496506..b62f560e 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -26,7 +26,8 @@ extern void __init at91_dt_initialize(void);
 extern void __init at91_init_irq_default(void);
 extern void __init at91_init_interrupts(unsigned int priority[]);
 extern void __init at91x40_init_interrupts(unsigned int priority[]);
-extern void __init at91_aic_init(unsigned int priority[]);
+extern void __init at91_aic_init(unsigned int priority[],
+				 unsigned int ext_irq_mask);
 extern int  __init at91_aic_of_init(struct device_node *node,
 				    struct device_node *parent);
 extern int  __init at91_aic5_of_init(struct device_node *node,
diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
index 1e02c0e..febc2ee 100644
--- a/arch/arm/mach-at91/irq.c
+++ b/arch/arm/mach-at91/irq.c
@@ -502,14 +502,19 @@ int __init at91_aic5_of_init(struct device_node *node,
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
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 6a3d4bb..0b32c81 100644
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
-- 
1.7.11.3

