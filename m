Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172Ab1IKMCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:02:37 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:38298 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760118Ab1IKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Zidlicky <rz@linux-m68k.org>
Subject: [PATCH 26/28] m68k/q40: Convert Q40/Q60 to genirq
Date: Sun, 11 Sep 2011 13:59:52 +0200
Message-Id: <1315742394-16036-27-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

q40_irq_handler() must be kept to translate ISA IRQs to the range 1-15.
q40_probe_irq_o{ff,n}() become unused.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Zidlicky <rz@linux-m68k.org>
---
v5: Added this changeset
---
 arch/m68k/Kconfig.mmu           |    1 -
 arch/m68k/include/asm/q40ints.h |    2 ++
 arch/m68k/q40/q40ints.c         |    8 +++++++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/Kconfig.mmu b/arch/m68k/Kconfig.mmu
index fa98287..39da911 100644
--- a/arch/m68k/Kconfig.mmu
+++ b/arch/m68k/Kconfig.mmu
@@ -200,7 +200,6 @@ config SUN3
 
 config USE_GENERIC_HARDIRQS
 	bool "Use genirq"
-	depends on !Q40
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 
diff --git a/arch/m68k/include/asm/q40ints.h b/arch/m68k/include/asm/q40ints.h
index 3d970af..01cdbb4 100644
--- a/arch/m68k/include/asm/q40ints.h
+++ b/arch/m68k/include/asm/q40ints.h
@@ -25,5 +25,7 @@
 #define Q40_IRQ14_MASK       (1<<6)
 #define Q40_IRQ15_MASK       (1<<7)
 
+#ifndef CONFIG_GENERIC_HARDIRQS
 extern unsigned long q40_probe_irq_on (void);
 extern int q40_probe_irq_off (unsigned long irqs);
+#endif
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index afe600c..f1e5288 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -15,10 +15,14 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
+#ifdef CONFIG_GENERIC_HARDIRQS
+#include <linux/irq.h>
+#else
+#include <asm/irq.h>
+#endif
 
 #include <asm/ptrace.h>
 #include <asm/system.h>
-#include <asm/irq.h>
 #include <asm/traps.h>
 
 #include <asm/q40_master.h>
@@ -326,6 +330,7 @@ void q40_irq_disable(struct irq_data *data)
 	}
 }
 
+#ifndef CONFIG_GENERIC_HARDIRQS
 unsigned long q40_probe_irq_on(void)
 {
 	printk("irq probing not working - reconfigure the driver to avoid this\n");
@@ -335,3 +340,4 @@ int q40_probe_irq_off(unsigned long irqs)
 {
 	return -1;
 }
+#endif
-- 
1.7.0.4

