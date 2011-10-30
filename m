Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114Ab1J3MuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:50:25 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:37513 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab1J3Mst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 18/27] m68k/mac: Optimize interrupts using chain handlers
Date: Sun, 30 Oct 2011 13:48:26 +0100
Message-Id: <1319978915-10933-19-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mac/baboon.c |   38 +++++++++++++
 arch/m68k/mac/oss.c    |  106 +++++++++++++++++++++++++++++-------
 arch/m68k/mac/psc.c    |   74 +++++++++++++++++++------
 arch/m68k/mac/via.c    |  143 +++++++++++++++++++++++++++++++++++++++---------
 4 files changed, 298 insertions(+), 63 deletions(-)

diff --git a/arch/m68k/mac/baboon.c b/arch/m68k/mac/baboon.c
index ff11746..425144c 100644
--- a/arch/m68k/mac/baboon.c
+++ b/arch/m68k/mac/baboon.c
@@ -56,6 +56,39 @@ void __init baboon_init(void)
  * Baboon interrupt handler. This works a lot like a VIA.
  */
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+static void baboon_irq(unsigned int irq, struct irq_desc *desc)
+{
+	int irq_bit, irq_num;
+	unsigned char events;
+
+#ifdef DEBUG_IRQS
+	printk("baboon_irq: mb_control %02X mb_ifr %02X mb_status %02X\n",
+		(uint) baboon->mb_control, (uint) baboon->mb_ifr,
+		(uint) baboon->mb_status);
+#endif
+
+	events = baboon->mb_ifr & 0x07;
+	if (!events)
+		return;
+
+	irq_num = IRQ_BABOON_0;
+	irq_bit = 1;
+	do {
+	        if (events & irq_bit) {
+			baboon->mb_ifr &= ~irq_bit;
+			generic_handle_irq(irq_num);
+		}
+		irq_bit <<= 1;
+		irq_num++;
+	} while(events >= irq_bit);
+#if 0
+	if (baboon->mb_ifr & 0x02) macide_ack_intr(NULL);
+	/* for now we need to smash all interrupts */
+	baboon->mb_ifr &= ~events;
+#endif
+}
+#else
 static irqreturn_t baboon_irq(int irq, void *dev_id)
 {
 	int irq_bit, irq_num;
@@ -87,6 +120,7 @@ static irqreturn_t baboon_irq(int irq, void *dev_id)
 #endif
 	return IRQ_HANDLED;
 }
+#endif
 
 /*
  * Register the Baboon interrupt dispatcher on nubus slot $C.
@@ -95,8 +129,12 @@ static irqreturn_t baboon_irq(int irq, void *dev_id)
 void __init baboon_register_interrupts(void)
 {
 	baboon_disabled = 0;
+#ifdef CONFIG_GENERIC_HARDIRQS
+	irq_set_chained_handler(IRQ_NUBUS_C, baboon_irq);
+#else
 	if (request_irq(IRQ_NUBUS_C, baboon_irq, 0, "baboon", (void *)baboon))
 		pr_err("Couldn't register baboon interrupt\n");
+#endif
 }
 
 /*
diff --git a/arch/m68k/mac/oss.c b/arch/m68k/mac/oss.c
index ed95270..cc784c2 100644
--- a/arch/m68k/mac/oss.c
+++ b/arch/m68k/mac/oss.c
@@ -32,10 +32,11 @@
 int oss_present;
 volatile struct mac_oss *oss;
 
-static irqreturn_t oss_irq(int, void *);
-static irqreturn_t oss_nubus_irq(int, void *);
-
+#ifdef CONFIG_GENERIC_HARDIRQS
+extern void via1_irq(unsigned int irq, struct irq_desc *desc);
+#else
 extern irqreturn_t via1_irq(int, void *);
+#endif
 
 /*
  * Initialize the OSS
@@ -63,23 +64,6 @@ void __init oss_init(void)
 }
 
 /*
- * Register the OSS and NuBus interrupt dispatchers.
- */
-
-void __init oss_register_interrupts(void)
-{
-	if (request_irq(OSS_IRQLEV_SCSI, oss_irq, 0, "scsi", (void *)oss))
-		pr_err("Couldn't register %s interrupt\n", "scsi");
-	if (request_irq(OSS_IRQLEV_NUBUS, oss_nubus_irq, 0, "nubus",
-			(void *)oss))
-		pr_err("Couldn't register %s interrupt\n", "nubus");
-	if (request_irq(OSS_IRQLEV_SOUND, oss_irq, 0, "sound", (void *)oss))
-		pr_err("Couldn't register %s interrupt\n", "sound");
-	if (request_irq(OSS_IRQLEV_VIA1, via1_irq, 0, "via1", (void *)via1))
-		pr_err("Couldn't register %s interrupt\n", "via1");
-}
-
-/*
  * Initialize OSS for Nubus access
  */
 
@@ -92,6 +76,34 @@ void __init oss_nubus_init(void)
  * and SCSI; everything else is routed to its own autovector IRQ.
  */
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+static void oss_irq(unsigned int irq, struct irq_desc *desc)
+{
+	int events;
+
+	events = oss->irq_pending & (OSS_IP_SOUND|OSS_IP_SCSI);
+	if (!events)
+		return;
+
+#ifdef DEBUG_IRQS
+	if ((console_loglevel == 10) && !(events & OSS_IP_SCSI)) {
+		printk("oss_irq: irq %u events = 0x%04X\n", irq,
+			(int) oss->irq_pending);
+	}
+#endif
+	/* FIXME: how do you clear a pending IRQ?    */
+
+	if (events & OSS_IP_SOUND) {
+		oss->irq_pending &= ~OSS_IP_SOUND;
+		/* FIXME: call sound handler */
+	} else if (events & OSS_IP_SCSI) {
+		oss->irq_pending &= ~OSS_IP_SCSI;
+		generic_handle_irq(IRQ_MAC_SCSI);
+	} else {
+		/* FIXME: error check here? */
+	}
+}
+#else
 static irqreturn_t oss_irq(int irq, void *dev_id)
 {
 	int events;
@@ -119,6 +131,7 @@ static irqreturn_t oss_irq(int irq, void *dev_id)
 	}
 	return IRQ_HANDLED;
 }
+#endif
 
 /*
  * Nubus IRQ handler, OSS style
@@ -126,6 +139,34 @@ static irqreturn_t oss_irq(int irq, void *dev_id)
  * Unlike the VIA/RBV this is on its own autovector interrupt level.
  */
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+static void oss_nubus_irq(unsigned int irq, struct irq_desc *desc)
+{
+	int events, irq_bit, i;
+
+	events = oss->irq_pending & OSS_IP_NUBUS;
+	if (!events)
+		return;
+
+#ifdef DEBUG_NUBUS_INT
+	if (console_loglevel > 7) {
+		printk("oss_nubus_irq: events = 0x%04X\n", events);
+	}
+#endif
+	/* There are only six slots on the OSS, not seven */
+
+	i = 6;
+	irq_bit = 0x40;
+	do {
+		--i;
+		irq_bit >>= 1;
+		if (events & irq_bit) {
+			oss->irq_pending &= ~irq_bit;
+			generic_handle_irq(NUBUS_SOURCE_BASE + i);
+		}
+	} while(events & (irq_bit - 1));
+}
+#else
 static irqreturn_t oss_nubus_irq(int irq, void *dev_id)
 {
 	int events, irq_bit, i;
@@ -153,6 +194,31 @@ static irqreturn_t oss_nubus_irq(int irq, void *dev_id)
 	} while(events & (irq_bit - 1));
 	return IRQ_HANDLED;
 }
+#endif
+
+/*
+ * Register the OSS and NuBus interrupt dispatchers.
+ */
+
+void __init oss_register_interrupts(void)
+{
+#ifdef CONFIG_GENERIC_HARDIRQS
+	irq_set_chained_handler(OSS_IRQLEV_SCSI, oss_irq);
+	irq_set_chained_handler(OSS_IRQLEV_NUBUS, oss_nubus_irq);
+	irq_set_chained_handler(OSS_IRQLEV_SOUND, oss_irq);
+	irq_set_chained_handler(OSS_IRQLEV_VIA1, via1_irq);
+#else /* !CONFIG_GENERIC_HARDIRQS */
+	if (request_irq(OSS_IRQLEV_SCSI, oss_irq, 0, "scsi", (void *)oss))
+		pr_err("Couldn't register %s interrupt\n", "scsi");
+	if (request_irq(OSS_IRQLEV_NUBUS, oss_nubus_irq, 0, "nubus",
+			(void *)oss))
+		pr_err("Couldn't register %s interrupt\n", "nubus");
+	if (request_irq(OSS_IRQLEV_SOUND, oss_irq, 0, "sound", (void *)oss))
+		pr_err("Couldn't register %s interrupt\n", "sound");
+	if (request_irq(OSS_IRQLEV_VIA1, via1_irq, 0, "via1", (void *)via1))
+		pr_err("Couldn't register %s interrupt\n", "via1");
+#endif /* !CONFIG_GENERIC_HARDIRQS */
+}
 
 /*
  * Enable an OSS interrupt
diff --git a/arch/m68k/mac/psc.c b/arch/m68k/mac/psc.c
index 0a34b7a..52840b8 100644
--- a/arch/m68k/mac/psc.c
+++ b/arch/m68k/mac/psc.c
@@ -33,8 +33,6 @@
 int psc_present;
 volatile __u8 *psc;
 
-irqreturn_t psc_irq(int, void *);
-
 /*
  * Debugging dump, used in various places to see what's going on.
  */
@@ -115,26 +113,40 @@ void __init psc_init(void)
 }
 
 /*
- * Register the PSC interrupt dispatchers for autovector interrupts 3-6.
+ * PSC interrupt handler. It's a lot like the VIA interrupt handler.
  */
 
-void __init psc_register_interrupts(void)
+#ifdef CONFIG_GENERIC_HARDIRQS
+static void psc_irq(unsigned int irq, struct irq_desc *desc)
 {
-	if (request_irq(IRQ_AUTO_3, psc_irq, 0, "psc3", (void *) 0x30))
-		pr_err("Couldn't register psc%d interrupt\n", 3);
-	if (request_irq(IRQ_AUTO_4, psc_irq, 0, "psc4", (void *) 0x40))
-		pr_err("Couldn't register psc%d interrupt\n", 4);
-	if (request_irq(IRQ_AUTO_5, psc_irq, 0, "psc5", (void *) 0x50))
-		pr_err("Couldn't register psc%d interrupt\n", 5);
-	if (request_irq(IRQ_AUTO_6, psc_irq, 0, "psc6", (void *) 0x60))
-		pr_err("Couldn't register psc%d interrupt\n", 6);
-}
+	unsigned int offset = (unsigned int)irq_desc_get_handler_data(desc);
+	int pIFR	= pIFRbase + offset;
+	int pIER	= pIERbase + offset;
+	int irq_num;
+	unsigned char irq_bit, events;
 
-/*
- * PSC interrupt handler. It's a lot like the VIA interrupt handler.
- */
+#ifdef DEBUG_IRQS
+	printk("psc_irq: irq %u pIFR = 0x%02X pIER = 0x%02X\n",
+		irq, (int) psc_read_byte(pIFR), (int) psc_read_byte(pIER));
+#endif
 
-irqreturn_t psc_irq(int irq, void *dev_id)
+	events = psc_read_byte(pIFR) & psc_read_byte(pIER) & 0xF;
+	if (!events)
+		return;
+
+	irq_num = irq << 3;
+	irq_bit = 1;
+	do {
+		if (events & irq_bit) {
+			psc_write_byte(pIFR, irq_bit);
+			generic_handle_irq(irq_num);
+		}
+		irq_num++;
+		irq_bit <<= 1;
+	} while (events >= irq_bit);
+}
+#else
+static irqreturn_t psc_irq(int irq, void *dev_id)
 {
 	int pIFR	= pIFRbase + ((int) dev_id);
 	int pIER	= pIERbase + ((int) dev_id);
@@ -162,6 +174,34 @@ irqreturn_t psc_irq(int irq, void *dev_id)
 	} while (events >= irq_bit);
 	return IRQ_HANDLED;
 }
+#endif
+
+/*
+ * Register the PSC interrupt dispatchers for autovector interrupts 3-6.
+ */
+
+void __init psc_register_interrupts(void)
+{
+#ifdef CONFIG_GENERIC_HARDIRQS
+	irq_set_chained_handler(IRQ_AUTO_3, psc_irq);
+	irq_set_handler_data(IRQ_AUTO_3, (void *)0x30);
+	irq_set_chained_handler(IRQ_AUTO_4, psc_irq);
+	irq_set_handler_data(IRQ_AUTO_4, (void *)0x40);
+	irq_set_chained_handler(IRQ_AUTO_5, psc_irq);
+	irq_set_handler_data(IRQ_AUTO_5, (void *)0x50);
+	irq_set_chained_handler(IRQ_AUTO_6, psc_irq);
+	irq_set_handler_data(IRQ_AUTO_6, (void *)0x60);
+#else /* !CONFIG_GENERIC_HARDIRQS */
+	if (request_irq(IRQ_AUTO_3, psc_irq, 0, "psc3", (void *) 0x30))
+		pr_err("Couldn't register psc%d interrupt\n", 3);
+	if (request_irq(IRQ_AUTO_4, psc_irq, 0, "psc4", (void *) 0x40))
+		pr_err("Couldn't register psc%d interrupt\n", 4);
+	if (request_irq(IRQ_AUTO_5, psc_irq, 0, "psc5", (void *) 0x50))
+		pr_err("Couldn't register psc%d interrupt\n", 5);
+	if (request_irq(IRQ_AUTO_6, psc_irq, 0, "psc6", (void *) 0x60))
+		pr_err("Couldn't register psc%d interrupt\n", 6);
+#endif /* !CONFIG_GENERIC_HARDIRQS */
+}
 
 void psc_irq_enable(int irq) {
 	int irq_src	= IRQ_SRC(irq);
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index bde156c..b8156ac 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -80,9 +80,6 @@ static int gIER,gIFR,gBufA,gBufB;
 static u8 nubus_disabled;
 
 void via_debug_dump(void);
-irqreturn_t via1_irq(int, void *);
-irqreturn_t via2_irq(int, void *);
-irqreturn_t via_nubus_irq(int, void *);
 void via_irq_enable(int irq);
 void via_irq_disable(int irq);
 void via_irq_clear(int irq);
@@ -289,29 +286,6 @@ void __init via_init_clock(irq_handler_t func)
 }
 
 /*
- * Register the interrupt dispatchers for VIA or RBV machines only.
- */
-
-void __init via_register_interrupts(void)
-{
-	if (via_alt_mapping) {
-		if (request_irq(IRQ_AUTO_1, via1_irq, 0, "software",
-				(void *)via1))
-			pr_err("Couldn't register %s interrupt\n", "software");
-		if (request_irq(IRQ_AUTO_6, via1_irq, 0, "via1", (void *)via1))
-			pr_err("Couldn't register %s interrupt\n", "via1");
-	} else {
-		if (request_irq(IRQ_AUTO_1, via1_irq, 0, "via1", (void *)via1))
-			pr_err("Couldn't register %s interrupt\n", "via1");
-	}
-	if (request_irq(IRQ_AUTO_2, via2_irq, 0, "via2", (void *)via2))
-		pr_err("Couldn't register %s interrupt\n", "via2");
-	if (request_irq(IRQ_MAC_NUBUS, via_nubus_irq, 0, "nubus",
-			(void *)via2))
-		pr_err("Couldn't register %s interrupt\n", "nubus");
-}
-
-/*
  * Debugging dump, used in various places to see what's going on.
  */
 
@@ -443,6 +417,49 @@ void __init via_nubus_init(void)
  * via6522.c :-), disable/pending masks added.
  */
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+void via1_irq(unsigned int irq, struct irq_desc *desc)
+{
+	int irq_num;
+	unsigned char irq_bit, events;
+
+	events = via1[vIFR] & via1[vIER] & 0x7F;
+	if (!events)
+		return;
+
+	irq_num = VIA1_SOURCE_BASE;
+	irq_bit = 1;
+	do {
+		if (events & irq_bit) {
+			via1[vIFR] = irq_bit;
+			generic_handle_irq(irq_num);
+		}
+		++irq_num;
+		irq_bit <<= 1;
+	} while (events >= irq_bit);
+}
+
+static void via2_irq(unsigned int irq, struct irq_desc *desc)
+{
+	int irq_num;
+	unsigned char irq_bit, events;
+
+	events = via2[gIFR] & via2[gIER] & 0x7F;
+	if (!events)
+		return;
+
+	irq_num = VIA2_SOURCE_BASE;
+	irq_bit = 1;
+	do {
+		if (events & irq_bit) {
+			via2[gIFR] = irq_bit | rbv_clear;
+			generic_handle_irq(irq_num);
+		}
+		++irq_num;
+		irq_bit <<= 1;
+	} while (events >= irq_bit);
+}
+#else
 irqreturn_t via1_irq(int irq, void *dev_id)
 {
 	int irq_num;
@@ -486,12 +503,49 @@ irqreturn_t via2_irq(int irq, void *dev_id)
 	} while (events >= irq_bit);
 	return IRQ_HANDLED;
 }
+#endif
 
 /*
  * Dispatch Nubus interrupts. We are called as a secondary dispatch by the
  * VIA2 dispatcher as a fast interrupt handler.
  */
 
+#ifdef CONFIG_GENERIC_HARDIRQS
+void via_nubus_irq(unsigned int irq, struct irq_desc *desc)
+{
+	int slot_irq;
+	unsigned char slot_bit, events;
+
+	events = ~via2[gBufA] & 0x7F;
+	if (rbv_present)
+		events &= via2[rSIER];
+	else
+		events &= ~via2[vDirA];
+	if (!events)
+		return;
+
+	do {
+		slot_irq = IRQ_NUBUS_F;
+		slot_bit = 0x40;
+		do {
+			if (events & slot_bit) {
+				events &= ~slot_bit;
+				generic_handle_irq(slot_irq);
+			}
+			--slot_irq;
+			slot_bit >>= 1;
+		} while (events);
+
+ 		/* clear the CA1 interrupt and make certain there's no more. */
+		via2[gIFR] = 0x02 | rbv_clear;
+		events = ~via2[gBufA] & 0x7F;
+		if (rbv_present)
+			events &= via2[rSIER];
+		else
+			events &= ~via2[vDirA];
+	} while (events);
+}
+#else
 irqreturn_t via_nubus_irq(int irq, void *dev_id)
 {
 	int slot_irq;
@@ -527,6 +581,43 @@ irqreturn_t via_nubus_irq(int irq, void *dev_id)
 	} while (events);
 	return IRQ_HANDLED;
 }
+#endif
+
+/*
+ * Register the interrupt dispatchers for VIA or RBV machines only.
+ */
+
+void __init via_register_interrupts(void)
+{
+#ifdef CONFIG_GENERIC_HARDIRQS
+	if (via_alt_mapping) {
+		/* software interrupt */
+		irq_set_chained_handler(IRQ_AUTO_1, via1_irq);
+		/* via1 interrupt */
+		irq_set_chained_handler(IRQ_AUTO_6, via1_irq);
+	} else {
+		irq_set_chained_handler(IRQ_AUTO_1, via1_irq);
+	}
+	irq_set_chained_handler(IRQ_AUTO_2, via2_irq);
+	irq_set_chained_handler(IRQ_MAC_NUBUS, via_nubus_irq);
+#else
+	if (via_alt_mapping) {
+		if (request_irq(IRQ_AUTO_1, via1_irq, 0, "software",
+				(void *)via1))
+			pr_err("Couldn't register %s interrupt\n", "software");
+		if (request_irq(IRQ_AUTO_6, via1_irq, 0, "via1", (void *)via1))
+			pr_err("Couldn't register %s interrupt\n", "via1");
+	} else {
+		if (request_irq(IRQ_AUTO_1, via1_irq, 0, "via1", (void *)via1))
+			pr_err("Couldn't register %s interrupt\n", "via1");
+	}
+	if (request_irq(IRQ_AUTO_2, via2_irq, 0, "via2", (void *)via2))
+		pr_err("Couldn't register %s interrupt\n", "via2");
+	if (request_irq(IRQ_MAC_NUBUS, via_nubus_irq, 0, "nubus",
+			(void *)via2))
+		pr_err("Couldn't register %s interrupt\n", "nubus");
+#endif
+}
 
 void via_irq_enable(int irq) {
 	int irq_src	= IRQ_SRC(irq);
-- 
1.7.0.4

