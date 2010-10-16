Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab0JPBBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:01:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0JPBBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:01:20 -0400
Date: Fri, 15 Oct 2010 21:01:19 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Hirokazu Takata <takata@linux-m32r.org>, tglx@redhat.com,
        linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca
Subject: [PATCH 1/3] m32r: clean up direct irq_desc access
Message-ID: <20101016010119.GN8332@bombadil.infradead.org>
References: <20101016005719.GM8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016005719.GM8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
(tglx-- only change was to fix a place where you accidentally had left
in a [, ie: set_irq_chip([IRQ... , &type) --kyle)

 arch/m32r/kernel/irq.c               |    8 ++-
 arch/m32r/platforms/m32104ut/setup.c |   20 ++-------
 arch/m32r/platforms/m32700ut/setup.c |   74 +++++++--------------------------
 arch/m32r/platforms/mappi/setup.c    |   41 ++++---------------
 arch/m32r/platforms/mappi2/setup.c   |   50 +++++------------------
 arch/m32r/platforms/mappi3/setup.c   |   50 +++++------------------
 arch/m32r/platforms/oaks32r/setup.c  |   30 +++-----------
 arch/m32r/platforms/opsput/setup.c   |   70 ++++++-------------------------
 arch/m32r/platforms/usrv/setup.c     |   45 ++++----------------
 9 files changed, 82 insertions(+), 306 deletions(-)

diff --git a/arch/m32r/kernel/irq.c b/arch/m32r/kernel/irq.c
index 3c71f77..d0c8872 100644
--- a/arch/m32r/kernel/irq.c
+++ b/arch/m32r/kernel/irq.c
@@ -40,8 +40,10 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_to_desc(i);
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -59,7 +61,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 	return 0;
 }
diff --git a/arch/m32r/platforms/m32104ut/setup.c b/arch/m32r/platforms/m32104ut/setup.c
index 922fdfd..9c23c9b 100644
--- a/arch/m32r/platforms/m32104ut/setup.c
+++ b/arch/m32r/platforms/m32104ut/setup.c
@@ -85,36 +85,24 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32104UT-LAN (SMC91C111)*/
-	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT0].chip = &m32104ut_irq_type;
-	irq_desc[M32R_IRQ_INT0].action = 0;
-	irq_desc[M32R_IRQ_INT0].depth = 1;
+	set_irq_chip(M32R_IRQ_INT0, &m32104ut_irq_type);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD11; /* "H" level sense */
 	disable_m32104ut_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &m32104ut_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	set_irq_chip(M32R_IRQ_MFT2, &m32104ut_irq_type);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &m32104ut_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_R, &m32104ut_irq_type);
 	icu_data[M32R_IRQ_SIO0_R].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &m32104ut_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_S, &m32104ut_irq_type);
 	icu_data[M32R_IRQ_SIO0_S].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
diff --git a/arch/m32r/platforms/m32700ut/setup.c b/arch/m32r/platforms/m32700ut/setup.c
index 9c1bc74..363dce9 100644
--- a/arch/m32r/platforms/m32700ut/setup.c
+++ b/arch/m32r/platforms/m32700ut/setup.c
@@ -299,101 +299,65 @@ void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32700UT-LAN (SMC91C111)*/
-	irq_desc[M32700UT_LAN_IRQ_LAN].status = IRQ_DISABLED;
-	irq_desc[M32700UT_LAN_IRQ_LAN].chip = &m32700ut_lanpld_irq_type;
-	irq_desc[M32700UT_LAN_IRQ_LAN].action = 0;
-	irq_desc[M32700UT_LAN_IRQ_LAN].depth = 1;	/* disable nested irq */
+	set_irq_chip(M32700UT_LAN_IRQ_LAN, &m32700ut_lanpld_irq_type);
 	lanpld_icu_data[irq2lanpldirq(M32700UT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_m32700ut_lanpld_irq(M32700UT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	set_irq_chip(M32R_IRQ_MFT2, &m32700ut_irq_type);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_m32700ut_irq(M32R_IRQ_MFT2);
 
 	/* SIO0 : receive */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_R, &m32700ut_irq_type);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0 : send */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_S, &m32700ut_irq_type);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1 : receive */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_R, &m32700ut_irq_type);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1 : send */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_S, &m32700ut_irq_type);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO1_S);
 
 	/* DMA1 : */
-	irq_desc[M32R_IRQ_DMA1].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_DMA1].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_DMA1].action = 0;
-	irq_desc[M32R_IRQ_DMA1].depth = 1;
+	set_irq_chip(M32R_IRQ_DMA1, &m32700ut_irq_type);
 	icu_data[M32R_IRQ_DMA1].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_DMA1);
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	irq_desc[PLD_IRQ_SIO0_RCV].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_SIO0_RCV].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_SIO0_RCV].action = 0;
-	irq_desc[PLD_IRQ_SIO0_RCV].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_SIO0_RCV, &m32700ut_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	irq_desc[PLD_IRQ_SIO0_SND].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_SIO0_SND].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_SIO0_SND].action = 0;
-	irq_desc[PLD_IRQ_SIO0_SND].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_SIO0_SND, &m32700ut_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFIREQ].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_CFIREQ].action = 0;
-	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_CFIREQ, &m32700ut_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_INSERT].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
-	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_CFC_INSERT, &m32700ut_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	irq_desc[PLD_IRQ_CFC_EJECT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_EJECT].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_CFC_EJECT].action = 0;
-	irq_desc[PLD_IRQ_CFC_EJECT].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_CFC_EJECT, &m32700ut_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_EJECT);
 
@@ -413,13 +377,10 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_USB)
 	outw(USBCR_OTGS, USBCR); 	/* USBCR: non-OTG */
+	set_irq_chip(M32700UT_LCD_IRQ_USB_INT1, &m32700ut_lcdpld_irq_type);
 
-    irq_desc[M32700UT_LCD_IRQ_USB_INT1].status = IRQ_DISABLED;
-    irq_desc[M32700UT_LCD_IRQ_USB_INT1].chip = &m32700ut_lcdpld_irq_type;
-    irq_desc[M32700UT_LCD_IRQ_USB_INT1].action = 0;
-    irq_desc[M32700UT_LCD_IRQ_USB_INT1].depth = 1;
-    lcdpld_icu_data[irq2lcdpldirq(M32700UT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
-    disable_m32700ut_lcdpld_irq(M32700UT_LCD_IRQ_USB_INT1);
+	lcdpld_icu_data[irq2lcdpldirq(M32700UT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
+	disable_m32700ut_lcdpld_irq(M32700UT_LCD_IRQ_USB_INT1);
 #endif
 	/*
 	 * INT2# is used for BAT, USB, AUDIO
@@ -432,10 +393,7 @@ void __init init_IRQ(void)
 	/*
 	 * INT3# is used for AR
 	 */
-	irq_desc[M32R_IRQ_INT3].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT3].chip = &m32700ut_irq_type;
-	irq_desc[M32R_IRQ_INT3].action = 0;
-	irq_desc[M32R_IRQ_INT3].depth = 1;
+	set_irq_chip(M32R_IRQ_INT3, &m32700ut_irq_type);
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_m32700ut_irq(M32R_IRQ_INT3);
 #endif	/* CONFIG_VIDEO_M32R_AR */
diff --git a/arch/m32r/platforms/mappi/setup.c b/arch/m32r/platforms/mappi/setup.c
index fb4b177..8a63b85 100644
--- a/arch/m32r/platforms/mappi/setup.c
+++ b/arch/m32r/platforms/mappi/setup.c
@@ -45,7 +45,6 @@ static void mask_and_ack_mappi(unsigned int irq)
 
 static void end_mappi_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		enable_mappi_irq(irq);
 }
 
@@ -85,70 +84,46 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT0 : LAN controller (RTL8019AS) */
-	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT0].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_INT0].action = NULL;
-	irq_desc[M32R_IRQ_INT0].depth = 1;
+	set_irq_chip(M32R_IRQ_INT0, &mappi_irq_type);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD11;
 	disable_mappi_irq(M32R_IRQ_INT0);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = NULL;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	set_irq_chip(M32R_IRQ_MFT2, &mappi_irq_type);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = NULL;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_R, &mappi_irq_type);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = NULL;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_S, &mappi_irq_type);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = NULL;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_R, &mappi_irq_type);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = NULL;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_S, &mappi_irq_type);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
 
 #if defined(CONFIG_M32R_PCC)
 	/* INT1 : pccard0 interrupt */
-	irq_desc[M32R_IRQ_INT1].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT1].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_INT1].action = NULL;
-	irq_desc[M32R_IRQ_INT1].depth = 1;
+	set_irq_chip(M32R_IRQ_INT1, &mappi_irq_type);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT1);
 
 	/* INT2 : pccard1 interrupt */
-	irq_desc[M32R_IRQ_INT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT2].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_INT2].action = NULL;
-	irq_desc[M32R_IRQ_INT2].depth = 1;
+	set_irq_chip(M32R_IRQ_INT2, &mappi_irq_type);
 	icu_data[M32R_IRQ_INT2].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT2);
 #endif /* CONFIG_M32RPCC */
diff --git a/arch/m32r/platforms/mappi2/setup.c b/arch/m32r/platforms/mappi2/setup.c
index 6a65eda..8d7ef39 100644
--- a/arch/m32r/platforms/mappi2/setup.c
+++ b/arch/m32r/platforms/mappi2/setup.c
@@ -85,87 +85,57 @@ void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT0].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_INT0].action = 0;
-	irq_desc[M32R_IRQ_INT0].depth = 1;
+	set_irq_chip(M32R_IRQ_INT0, &mappi2_irq_type);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	set_irq_chip(M32R_IRQ_MFT2, &mappi2_irq_type);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi2_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_R, &mappi2_irq_type);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_S, &mappi2_irq_type);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_R, &mappi2_irq_type);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_S, &mappi2_irq_type);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_M32R_USE_DBG_CONSOLE */
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	irq_desc[M32R_IRQ_INT1].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT1].chip = &mappi2_irq_type;
-	irq_desc[M32R_IRQ_INT1].action = 0;
-	irq_desc[M32R_IRQ_INT1].depth = 1;
+	set_irq_chip(M32R_IRQ_INT1, &mappi2_irq_type);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* ICUCR40: CFC IREQ */
-	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFIREQ].chip = &mappi2_irq_type;
-	irq_desc[PLD_IRQ_CFIREQ].action = 0;
-	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_CFIREQ, &mappi2_irq_type);
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert */
-	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_INSERT].chip = &mappi2_irq_type;
-	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
-	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_CFC_INSERT, &mappi2_irq_type);
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi2_irq(PLD_IRQ_CFC_INSERT);
 
 	/* ICUCR42: CFC Eject */
-	irq_desc[PLD_IRQ_CFC_EJECT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_EJECT].chip = &mappi2_irq_type;
-	irq_desc[PLD_IRQ_CFC_EJECT].action = 0;
-	irq_desc[PLD_IRQ_CFC_EJECT].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_CFC_EJECT, &mappi2_irq_type);
 	icu_data[PLD_IRQ_CFC_EJECT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(PLD_IRQ_CFC_EJECT);
 #endif /* CONFIG_MAPPI2_CFC */
diff --git a/arch/m32r/platforms/mappi3/setup.c b/arch/m32r/platforms/mappi3/setup.c
index 9c337ae..6e25bb7 100644
--- a/arch/m32r/platforms/mappi3/setup.c
+++ b/arch/m32r/platforms/mappi3/setup.c
@@ -85,89 +85,59 @@ void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-	irq_desc[M32R_IRQ_INT0].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT0].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_INT0].action = 0;
-	irq_desc[M32R_IRQ_INT0].depth = 1;
+	set_irq_chip(M32R_IRQ_INT0, &mappi3_irq_type);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	set_irq_chip(M32R_IRQ_MFT2, &mappi3_irq_type);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi3_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_R, &mappi3_irq_type);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_S, &mappi3_irq_type);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_R, &mappi3_irq_type);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_S, &mappi3_irq_type);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_M32R_USE_DBG_CONSOLE */
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	irq_desc[M32R_IRQ_INT1].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT1].chip = &mappi3_irq_type;
-	irq_desc[M32R_IRQ_INT1].action = 0;
-	irq_desc[M32R_IRQ_INT1].depth = 1;
+	set_irq_chip(M32R_IRQ_INT1, &mappi3_irq_type);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* CFC IREQ */
-	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFIREQ].chip = &mappi3_irq_type;
-	irq_desc[PLD_IRQ_CFIREQ].action = 0;
-	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_CFIREQ, &mappi3_irq_type);
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert & eject */
-	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_INSERT].chip = &mappi3_irq_type;
-	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
-	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_CFC_INSERT, &mappi3_irq_type);
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi3_irq(PLD_IRQ_CFC_INSERT);
 
 #endif /* CONFIG_M32R_CFC */
 
 	/* IDE IREQ */
-	irq_desc[PLD_IRQ_IDEIREQ].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_IDEIREQ].chip = &mappi3_irq_type;
-	irq_desc[PLD_IRQ_IDEIREQ].action = 0;
-	irq_desc[PLD_IRQ_IDEIREQ].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_IDEIREQ, &mappi3_irq_type);
 	icu_data[PLD_IRQ_IDEIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(PLD_IRQ_IDEIREQ);
 
diff --git a/arch/m32r/platforms/oaks32r/setup.c b/arch/m32r/platforms/oaks32r/setup.c
index ed86574..12a794d 100644
--- a/arch/m32r/platforms/oaks32r/setup.c
+++ b/arch/m32r/platforms/oaks32r/setup.c
@@ -83,52 +83,34 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT3 : LAN controller (RTL8019AS) */
-	irq_desc[M32R_IRQ_INT3].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT3].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_INT3].action = 0;
-	irq_desc[M32R_IRQ_INT3].depth = 1;
+	set_irq_chip(M32R_IRQ_INT3, &oaks32r_irq_type);
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_oaks32r_irq(M32R_IRQ_INT3);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	set_irq_chip(M32R_IRQ_MFT2, &oaks32r_irq_type);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_oaks32r_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_R, &oaks32r_irq_type);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_S, &oaks32r_irq_type);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_R, &oaks32r_irq_type);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &oaks32r_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_S, &oaks32r_irq_type);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
diff --git a/arch/m32r/platforms/opsput/setup.c b/arch/m32r/platforms/opsput/setup.c
index 80d6806..423898a 100644
--- a/arch/m32r/platforms/opsput/setup.c
+++ b/arch/m32r/platforms/opsput/setup.c
@@ -300,101 +300,65 @@ void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on OPSPUT-LAN (SMC91C111)*/
-	irq_desc[OPSPUT_LAN_IRQ_LAN].status = IRQ_DISABLED;
-	irq_desc[OPSPUT_LAN_IRQ_LAN].chip = &opsput_lanpld_irq_type;
-	irq_desc[OPSPUT_LAN_IRQ_LAN].action = 0;
-	irq_desc[OPSPUT_LAN_IRQ_LAN].depth = 1;	/* disable nested irq */
+	set_irq_chip(OPSPUT_LAN_IRQ_LAN, &opsput_lanpld_irq_type);
 	lanpld_icu_data[irq2lanpldirq(OPSPUT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_opsput_lanpld_irq(OPSPUT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	set_irq_chip(M32R_IRQ_MFT2, &opsput_irq_type);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_opsput_irq(M32R_IRQ_MFT2);
 
 	/* SIO0 : receive */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_R, &opsput_irq_type);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0 : send */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_S, &opsput_irq_type);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1 : receive */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_R, &opsput_irq_type);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1 : send */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_S, &opsput_irq_type);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_S);
 
 	/* DMA1 : */
-	irq_desc[M32R_IRQ_DMA1].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_DMA1].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_DMA1].action = 0;
-	irq_desc[M32R_IRQ_DMA1].depth = 1;
+	set_irq_chip(M32R_IRQ_DMA1, &opsput_irq_type);
 	icu_data[M32R_IRQ_DMA1].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_DMA1);
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	irq_desc[PLD_IRQ_SIO0_RCV].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_SIO0_RCV].chip = &opsput_pld_irq_type;
-	irq_desc[PLD_IRQ_SIO0_RCV].action = 0;
-	irq_desc[PLD_IRQ_SIO0_RCV].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_SIO0_RCV, &opsput_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	irq_desc[PLD_IRQ_SIO0_SND].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_SIO0_SND].chip = &opsput_pld_irq_type;
-	irq_desc[PLD_IRQ_SIO0_SND].action = 0;
-	irq_desc[PLD_IRQ_SIO0_SND].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_SIO0_SND, &opsput_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	irq_desc[PLD_IRQ_CFIREQ].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFIREQ].chip = &opsput_pld_irq_type;
-	irq_desc[PLD_IRQ_CFIREQ].action = 0;
-	irq_desc[PLD_IRQ_CFIREQ].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_CFIREQ, &opsput_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	irq_desc[PLD_IRQ_CFC_INSERT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_INSERT].chip = &opsput_pld_irq_type;
-	irq_desc[PLD_IRQ_CFC_INSERT].action = 0;
-	irq_desc[PLD_IRQ_CFC_INSERT].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_CFC_INSERT, &opsput_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	irq_desc[PLD_IRQ_CFC_EJECT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_CFC_EJECT].chip = &opsput_pld_irq_type;
-	irq_desc[PLD_IRQ_CFC_EJECT].action = 0;
-	irq_desc[PLD_IRQ_CFC_EJECT].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_CFC_EJECT, &opsput_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_EJECT);
 
@@ -415,10 +379,7 @@ void __init init_IRQ(void)
 #if defined(CONFIG_USB)
 	outw(USBCR_OTGS, USBCR); 	/* USBCR: non-OTG */
 
-    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].status = IRQ_DISABLED;
-    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].chip = &opsput_lcdpld_irq_type;
-    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].action = 0;
-    irq_desc[OPSPUT_LCD_IRQ_USB_INT1].depth = 1;
+    set_irq_chip(OPSPUT_LCD_IRQ_USB_INT1, &opsput_lcdpld_irq_type);
     lcdpld_icu_data[irq2lcdpldirq(OPSPUT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
     disable_opsput_lcdpld_irq(OPSPUT_LCD_IRQ_USB_INT1);
 #endif
@@ -433,10 +394,7 @@ void __init init_IRQ(void)
 	/*
 	 * INT3# is used for AR
 	 */
-	irq_desc[M32R_IRQ_INT3].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_INT3].chip = &opsput_irq_type;
-	irq_desc[M32R_IRQ_INT3].action = 0;
-	irq_desc[M32R_IRQ_INT3].depth = 1;
+	set_irq_chip(M32R_IRQ_INT3, &opsput_irq_type);
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_opsput_irq(M32R_IRQ_INT3);
 #endif /* CONFIG_VIDEO_M32R_AR */
diff --git a/arch/m32r/platforms/usrv/setup.c b/arch/m32r/platforms/usrv/setup.c
index 7573026..fc25ef9 100644
--- a/arch/m32r/platforms/usrv/setup.c
+++ b/arch/m32r/platforms/usrv/setup.c
@@ -156,53 +156,35 @@ void __init init_IRQ(void)
 		once++;
 
 	/* MFT2 : system timer */
-	irq_desc[M32R_IRQ_MFT2].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_MFT2].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_MFT2].action = 0;
-	irq_desc[M32R_IRQ_MFT2].depth = 1;
+	set_irq_chip(M32R_IRQ_MFT2, &mappi_irq_type);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #if defined(CONFIG_SERIAL_M32R_SIO)
 	/* SIO0_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO0_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_R].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO0_R].action = 0;
-	irq_desc[M32R_IRQ_SIO0_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_R, &mappi_irq_type);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	irq_desc[M32R_IRQ_SIO0_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO0_S].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO0_S].action = 0;
-	irq_desc[M32R_IRQ_SIO0_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO0_S, &mappi_irq_type);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	irq_desc[M32R_IRQ_SIO1_R].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_R].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO1_R].action = 0;
-	irq_desc[M32R_IRQ_SIO1_R].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_R, &mappi_irq_type);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	irq_desc[M32R_IRQ_SIO1_S].status = IRQ_DISABLED;
-	irq_desc[M32R_IRQ_SIO1_S].chip = &mappi_irq_type;
-	irq_desc[M32R_IRQ_SIO1_S].action = 0;
-	irq_desc[M32R_IRQ_SIO1_S].depth = 1;
+	set_irq_chip(M32R_IRQ_SIO1_S, &mappi_irq_type);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_SERIAL_M32R_SIO */
 
 	/* INT#67-#71: CFC#0 IREQ on PLD */
 	for (i = 0 ; i < CONFIG_M32R_CFC_NUM ; i++ ) {
-		irq_desc[PLD_IRQ_CF0 + i].status = IRQ_DISABLED;
-		irq_desc[PLD_IRQ_CF0 + i].chip = &m32700ut_pld_irq_type;
-		irq_desc[PLD_IRQ_CF0 + i].action = 0;
-		irq_desc[PLD_IRQ_CF0 + i].depth = 1;	/* disable nested irq */
+		set_irq_chip(PLD_IRQ_CF0 + i, &m32700ut_pld_irq_type);
 		pld_icu_data[irq2pldirq(PLD_IRQ_CF0 + i)].icucr
 			= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 		disable_m32700ut_pld_irq(PLD_IRQ_CF0 + i);
@@ -210,19 +192,13 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
 	/* INT#76: 16552D#0 IREQ on PLD */
-	irq_desc[PLD_IRQ_UART0].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_UART0].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_UART0].action = 0;
-	irq_desc[PLD_IRQ_UART0].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_UART0, &m32700ut_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART0)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_UART0);
 
 	/* INT#77: 16552D#1 IREQ on PLD */
-	irq_desc[PLD_IRQ_UART1].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_UART1].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_UART1].action = 0;
-	irq_desc[PLD_IRQ_UART1].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_UART1, &m32700ut_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART1)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_UART1);
@@ -230,10 +206,7 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_IDC_AK4524) || defined(CONFIG_IDC_AK4524_MODULE)
 	/* INT#80: AK4524 IREQ on PLD */
-	irq_desc[PLD_IRQ_SNDINT].status = IRQ_DISABLED;
-	irq_desc[PLD_IRQ_SNDINT].chip = &m32700ut_pld_irq_type;
-	irq_desc[PLD_IRQ_SNDINT].action = 0;
-	irq_desc[PLD_IRQ_SNDINT].depth = 1;	/* disable nested irq */
+	set_irq_chip(PLD_IRQ_SNDINT, &m32700ut_pld_irq_type);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SNDINT)].icucr
 		= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_SNDINT);
-- 
1.7.3.1

