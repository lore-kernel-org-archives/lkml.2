Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab1J3MuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:50:22 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:43236 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934024Ab1J3Mst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 27/27] m68k/mac: Remove mac_irq_{en,dis}able() wrappers
Date: Sun, 30 Oct 2011 13:48:35 +0100
Message-Id: <1319978915-10933-28-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/macintosh.h |    2 ++
 arch/m68k/mac/baboon.c            |    7 ++-----
 arch/m68k/mac/macints.c           |   25 +++++++------------------
 3 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/arch/m68k/include/asm/macintosh.h b/arch/m68k/include/asm/macintosh.h
index c2a1c5e..12ebe43 100644
--- a/arch/m68k/include/asm/macintosh.h
+++ b/arch/m68k/include/asm/macintosh.h
@@ -12,6 +12,8 @@ extern void mac_reset(void);
 extern void mac_poweroff(void);
 extern void mac_init_IRQ(void);
 extern int mac_irq_pending(unsigned int);
+extern void mac_irq_enable(struct irq_data *data);
+extern void mac_irq_disable(struct irq_data *data);
 
 /*
  *	Floppy driver magic hook - probably shouldn't be here
diff --git a/arch/m68k/mac/baboon.c b/arch/m68k/mac/baboon.c
index b55ead2..b403924 100644
--- a/arch/m68k/mac/baboon.c
+++ b/arch/m68k/mac/baboon.c
@@ -21,9 +21,6 @@
 
 /* #define DEBUG_IRQS */
 
-extern void mac_enable_irq(unsigned int);
-extern void mac_disable_irq(unsigned int);
-
 int baboon_present;
 static volatile struct baboon *baboon;
 static unsigned char baboon_disabled;
@@ -111,7 +108,7 @@ void baboon_irq_enable(int irq)
 
 	baboon_disabled &= ~(1 << irq_idx);
 	if (!baboon_disabled)
-		mac_enable_irq(IRQ_NUBUS_C);
+		mac_irq_enable(irq_get_irq_data(IRQ_NUBUS_C));
 }
 
 void baboon_irq_disable(int irq)
@@ -124,7 +121,7 @@ void baboon_irq_disable(int irq)
 
 	baboon_disabled |= 1 << irq_idx;
 	if (baboon_disabled)
-		mac_disable_irq(IRQ_NUBUS_C);
+		mac_irq_disable(irq_get_irq_data(IRQ_NUBUS_C));
 }
 
 void baboon_irq_clear(int irq)
diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
index 98497d2..ba220b7 100644
--- a/arch/m68k/mac/macints.c
+++ b/arch/m68k/mac/macints.c
@@ -190,19 +190,6 @@ irqreturn_t mac_debug_handler(int, void *);
 
 /* #define DEBUG_MACINTS */
 
-void mac_enable_irq(unsigned int irq);
-void mac_disable_irq(unsigned int irq);
-
-static void mac_irq_enable(struct irq_data *data)
-{
-	mac_enable_irq(data->irq);
-}
-
-static void mac_irq_disable(struct irq_data *data)
-{
-	mac_disable_irq(data->irq);
-}
-
 static struct irq_chip mac_irq_chip = {
 	.name		= "mac",
 	.irq_enable	= mac_irq_enable,
@@ -250,16 +237,17 @@ void __init mac_init_IRQ(void)
 }
 
 /*
- *  mac_enable_irq - enable an interrupt source
- * mac_disable_irq - disable an interrupt source
+ *  mac_irq_enable - enable an interrupt source
+ * mac_irq_disable - disable an interrupt source
  *   mac_clear_irq - clears a pending interrupt
- * mac_pending_irq - Returns the pending status of an IRQ (nonzero = pending)
+ * mac_irq_pending - returns the pending status of an IRQ (nonzero = pending)
  *
  * These routines are just dispatchers to the VIA/OSS/PSC routines.
  */
 
-void mac_enable_irq(unsigned int irq)
+void mac_irq_enable(struct irq_data *data)
 {
+	int irq = data->irq;
 	int irq_src = IRQ_SRC(irq);
 
 	switch(irq_src) {
@@ -292,8 +280,9 @@ void mac_enable_irq(unsigned int irq)
 	}
 }
 
-void mac_disable_irq(unsigned int irq)
+void mac_irq_disable(struct irq_data *data)
 {
+	int irq = data->irq;
 	int irq_src = IRQ_SRC(irq);
 
 	switch(irq_src) {
-- 
1.7.0.4

