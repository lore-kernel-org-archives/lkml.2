Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab2HVOaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:30:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52441 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab2HVOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:30:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Magnus Damm <damm@opensource.se>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/4] ARM: export set_irq_flags/irq_set_chip_and_handler
Date: Wed, 22 Aug 2012 16:29:39 +0200
Message-Id: <1345645780-2749-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1345645780-2749-1-git-send-email-arnd@arndb.de>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:EWdEv/4gQfVX8pc5MiApoTmorp5e3UR0kDbyDBe0ioC
 YMQAfZc9NU6dsr5abhw6Vzo3aVA+kOCoWcCHpNnZuuqR5bpxlE
 d1uHrJj/xyMnYL4iVmoRK6GDgLEcaeUak5vxhcZFR0PoKfGxyB
 qbQoTPtAXClxxqL6nW2pOivPuCnKfKfc+jJb2+CjBZyXjq7Zk+
 zKdqpDWsH73wJx+YukOqJ0yq/6voLwkAsNGsSJj7QpPC2FFWPd
 bNbrnlKZzqbXMOxK/29MI86AsIuEm/zGL56Y2tzcvcbAp7wgZl
 Rl1agphnGV0YrnErOZlfM/ZpPNDvnxfkrG8NgY04cfEU6P/B3E
 mYao8jZOm1Ksma/O1Edvf7EnG0eEAoex7a/HZOu/My1QAPPoyU
 tRfC5Ymy1mpnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recently added Emma Mobile GPIO driver calls set_irq_flags
and irq_set_chip_and_handler for the interrupts it exports and
it can be built as a module, which currently fails with

ERROR: "set_irq_flags" [drivers/gpio/gpio-em.ko] undefined!
ERROR: "irq_set_chip_and_handler_name" [drivers/gpio/gpio-em.ko] undefined!

We either need to replace the call to set_irq_flags with something
else or export that function. This patch does the latter.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Magnus Damm <damm@opensource.se>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/kernel/irq.c |    2 ++
 kernel/irq/chip.c     |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 16cedb4..8961650 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -34,6 +34,7 @@
 #include <linux/list.h>
 #include <linux/kallsyms.h>
 #include <linux/proc_fs.h>
+#include <linux/export.h>
 
 #include <asm/exception.h>
 #include <asm/mach/arch.h>
@@ -109,6 +110,7 @@ void set_irq_flags(unsigned int irq, unsigned int iflags)
 	/* Order is clear bits in "clr" then set bits in "set" */
 	irq_modify_status(irq, clr, set & ~clr);
 }
+EXPORT_SYMBOL_GPL(set_irq_flags);
 
 void __init init_IRQ(void)
 {
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index eebd6d5..3c3cea3 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -13,6 +13,7 @@
 #include <linux/irq.h>
 #include <linux/msi.h>
 #include <linux/module.h>
+#include <linux/export.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 
@@ -671,6 +672,7 @@ irq_set_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
 	irq_set_chip(irq, chip);
 	__irq_set_handler(irq, handle, 0, name);
 }
+EXPORT_SYMBOL_GPL(irq_set_chip_and_handler_name);
 
 void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
 {
-- 
1.7.10

