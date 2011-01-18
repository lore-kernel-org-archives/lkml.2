Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab1ARMaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 07:30:00 -0500
Received: from mail.bugwerft.de ([212.112.241.193]:42397 "EHLO
	mail.bugwerft.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1ARM37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 07:29:59 -0500
From: Sven Neumann <s.neumann@raumfeld.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Lars-Peter Clausen <lars@metafoo.de>,
        Sven Neumann <s.neumann@raumfeld.com>,
        stable@kernel.org (for 2.6.37 only)
Subject: [PATCH] ARM: pxa: fix GPIO IRQ handling
Date: Tue, 18 Jan 2011 13:29:45 +0100
Message-Id: <1295353785-14972-1-git-send-email-s.neumann@raumfeld.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4D357DC0.2030006@metafoo.de>
References: <4D357DC0.2030006@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

Set the "set_wake" field of the irq_chip struct before calling
set_irq_chip() for all of the IRQs, so that the compat handler
actually gets installed.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org (for 2.6.37 only)
---
 arch/arm/mach-pxa/irq.c    |    7 ++++---
 arch/arm/mach-pxa/pxa3xx.c |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
index 1beb40f..a5b42a7 100644
--- a/arch/arm/mach-pxa/irq.c
+++ b/arch/arm/mach-pxa/irq.c
@@ -111,13 +111,13 @@ static void __init pxa_init_low_gpio_irq(set_wake_t fn)
 	GRER0 &= ~0x3;
 	GEDR0 = 0x3;
 
+	pxa_low_gpio_chip.set_wake = fn;
+
 	for (irq = IRQ_GPIO0; irq <= IRQ_GPIO1; irq++) {
 		set_irq_chip(irq, &pxa_low_gpio_chip);
 		set_irq_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
-
-	pxa_low_gpio_chip.set_wake = fn;
 }
 
 void __init pxa_init_irq(int irq_nr, set_wake_t fn)
@@ -142,13 +142,14 @@ void __init pxa_init_irq(int irq_nr, set_wake_t fn)
 	/* only unmasked interrupts kick us out of idle */
 	ICCR = 1;
 
+	pxa_internal_irq_chip.set_wake = fn;
+
 	for (irq = PXA_IRQ(0); irq < PXA_IRQ(irq_nr); irq++) {
 		set_irq_chip(irq, &pxa_internal_irq_chip);
 		set_irq_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
-	pxa_internal_irq_chip.set_wake = fn;
 	pxa_init_low_gpio_irq(fn);
 }
 
diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index 276e8fb..5a8fe5c 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -567,13 +567,13 @@ static void __init pxa_init_ext_wakeup_irq(set_wake_t fn)
 {
 	int irq;
 
+	pxa_ext_wakeup_chip.set_wake = fn;
+
 	for (irq = IRQ_WAKEUP0; irq <= IRQ_WAKEUP1; irq++) {
 		set_irq_chip(irq, &pxa_ext_wakeup_chip);
 		set_irq_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
-
-	pxa_ext_wakeup_chip.set_wake = fn;
 }
 
 void __init pxa3xx_init_irq(void)
-- 
1.7.1

