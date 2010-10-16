Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab0JPBBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:01:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0JPBBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:01:38 -0400
Date: Fri, 15 Oct 2010 21:01:37 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Hirokazu Takata <takata@linux-m32r.org>, tglx@redhat.com,
        linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca
Subject: [PATCH 2/3] m32r: clean up irq handlers and kill off __do_IRQ use
Message-ID: <20101016010137.GO8332@bombadil.infradead.org>
References: <20101016005719.GM8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016005719.GM8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All handlers were using a mask-ack to disable, and end to
enable, so handle_level_irq with mask/unmask maintains the
same logical flow.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/m32r/Kconfig                    |    3 +
 arch/m32r/kernel/irq.c               |    2 +-
 arch/m32r/platforms/m32104ut/setup.c |   35 ++------
 arch/m32r/platforms/m32700ut/setup.c |  142 +++++++++-----------------------
 arch/m32r/platforms/mappi/setup.c    |   47 ++++-------
 arch/m32r/platforms/mappi2/setup.c   |   53 +++++-------
 arch/m32r/platforms/mappi3/setup.c   |   53 +++++-------
 arch/m32r/platforms/oaks32r/setup.c  |   41 +++------
 arch/m32r/platforms/opsput/setup.c   |  150 ++++++++++------------------------
 arch/m32r/platforms/usrv/setup.c     |   75 +++++------------
 10 files changed, 195 insertions(+), 406 deletions(-)

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 836abbb..9856c08f 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -30,6 +30,9 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	def_bool y
+
 config GENERIC_IRQ_PROBE
 	bool
 	default y
diff --git a/arch/m32r/kernel/irq.c b/arch/m32r/kernel/irq.c
index d0c8872..e01c690 100644
--- a/arch/m32r/kernel/irq.c
+++ b/arch/m32r/kernel/irq.c
@@ -80,7 +80,7 @@ asmlinkage unsigned int do_IRQ(int irq, struct pt_regs *regs)
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	/* FIXME M32R */
 #endif
-	__do_IRQ(irq);
+	generic_handle_irq(irq);
 	irq_exit();
 	set_irq_regs(old_regs);
 
diff --git a/arch/m32r/platforms/m32104ut/setup.c b/arch/m32r/platforms/m32104ut/setup.c
index 9c23c9b..8d78d7f 100644
--- a/arch/m32r/platforms/m32104ut/setup.c
+++ b/arch/m32r/platforms/m32104ut/setup.c
@@ -39,22 +39,6 @@ static void enable_m32104ut_irq(unsigned int irq)
 	outl(data, port);
 }
 
-static void mask_and_ack_m32104ut(unsigned int irq)
-{
-	disable_m32104ut_irq(irq);
-}
-
-static void end_m32104ut_irq(unsigned int irq)
-{
-	enable_m32104ut_irq(irq);
-}
-
-static unsigned int startup_m32104ut_irq(unsigned int irq)
-{
-	enable_m32104ut_irq(irq);
-	return (0);
-}
-
 static void shutdown_m32104ut_irq(unsigned int irq)
 {
 	unsigned long port;
@@ -66,12 +50,9 @@ static void shutdown_m32104ut_irq(unsigned int irq)
 static struct irq_chip m32104ut_irq_type =
 {
 	.typename = "M32104UT-IRQ",
-	.startup = startup_m32104ut_irq,
 	.shutdown = shutdown_m32104ut_irq,
-	.enable = enable_m32104ut_irq,
-	.disable = disable_m32104ut_irq,
-	.ack = mask_and_ack_m32104ut,
-	.end = end_m32104ut_irq
+	.unmask	= enable_m32104ut_irq,
+	.mask = disable_m32104ut_irq,
 };
 
 void __init init_IRQ(void)
@@ -85,24 +66,28 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32104UT-LAN (SMC91C111)*/
-	set_irq_chip(M32R_IRQ_INT0, &m32104ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT0, &m32104ut_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD11; /* "H" level sense */
 	disable_m32104ut_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &m32104ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &m32104ut_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO0_R, &m32104ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &m32104ut_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO0_S, &m32104ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &m32104ut_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = M32R_ICUCR_IEN;
 	disable_m32104ut_irq(M32R_IRQ_SIO0_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
diff --git a/arch/m32r/platforms/m32700ut/setup.c b/arch/m32r/platforms/m32700ut/setup.c
index 363dce9..a43bdf4 100644
--- a/arch/m32r/platforms/m32700ut/setup.c
+++ b/arch/m32r/platforms/m32700ut/setup.c
@@ -45,22 +45,6 @@ static void enable_m32700ut_irq(unsigned int irq)
 	outl(data, port);
 }
 
-static void mask_and_ack_m32700ut(unsigned int irq)
-{
-	disable_m32700ut_irq(irq);
-}
-
-static void end_m32700ut_irq(unsigned int irq)
-{
-	enable_m32700ut_irq(irq);
-}
-
-static unsigned int startup_m32700ut_irq(unsigned int irq)
-{
-	enable_m32700ut_irq(irq);
-	return (0);
-}
-
 static void shutdown_m32700ut_irq(unsigned int irq)
 {
 	unsigned long port;
@@ -72,12 +56,9 @@ static void shutdown_m32700ut_irq(unsigned int irq)
 static struct irq_chip m32700ut_irq_type =
 {
 	.typename = "M32700UT-IRQ",
-	.startup = startup_m32700ut_irq,
 	.shutdown = shutdown_m32700ut_irq,
-	.enable = enable_m32700ut_irq,
-	.disable = disable_m32700ut_irq,
-	.ack = mask_and_ack_m32700ut,
-	.end = end_m32700ut_irq
+	.unmask = enable_m32700ut_irq,
+	.mask = disable_m32700ut_irq,
 };
 
 /*
@@ -111,28 +92,10 @@ static void enable_m32700ut_pld_irq(unsigned int irq)
 	unsigned int pldirq;
 
 	pldirq = irq2pldirq(irq);
-//	enable_m32700ut_irq(M32R_IRQ_INT1);
 	port = pldirq2port(pldirq);
 	data = pld_icu_data[pldirq].icucr|PLD_ICUCR_IEN|PLD_ICUCR_ILEVEL6;
 	outw(data, port);
-}
-
-static void mask_and_ack_m32700ut_pld(unsigned int irq)
-{
-	disable_m32700ut_pld_irq(irq);
-//	mask_and_ack_m32700ut(M32R_IRQ_INT1);
-}
-
-static void end_m32700ut_pld_irq(unsigned int irq)
-{
-	enable_m32700ut_pld_irq(irq);
-	end_m32700ut_irq(M32R_IRQ_INT1);
-}
-
-static unsigned int startup_m32700ut_pld_irq(unsigned int irq)
-{
-	enable_m32700ut_pld_irq(irq);
-	return (0);
+	enable_m32700ut_irq(M32R_IRQ_INT1);
 }
 
 static void shutdown_m32700ut_pld_irq(unsigned int irq)
@@ -149,12 +112,9 @@ static void shutdown_m32700ut_pld_irq(unsigned int irq)
 static struct irq_chip m32700ut_pld_irq_type =
 {
 	.typename = "M32700UT-PLD-IRQ",
-	.startup = startup_m32700ut_pld_irq,
 	.shutdown = shutdown_m32700ut_pld_irq,
-	.enable = enable_m32700ut_pld_irq,
-	.disable = disable_m32700ut_pld_irq,
-	.ack = mask_and_ack_m32700ut_pld,
-	.end = end_m32700ut_pld_irq
+	.unmask = enable_m32700ut_pld_irq,
+	.mask = disable_m32700ut_pld_irq,
 };
 
 /*
@@ -186,23 +146,7 @@ static void enable_m32700ut_lanpld_irq(unsigned int irq)
 	port = lanpldirq2port(pldirq);
 	data = lanpld_icu_data[pldirq].icucr|PLD_ICUCR_IEN|PLD_ICUCR_ILEVEL6;
 	outw(data, port);
-}
-
-static void mask_and_ack_m32700ut_lanpld(unsigned int irq)
-{
-	disable_m32700ut_lanpld_irq(irq);
-}
-
-static void end_m32700ut_lanpld_irq(unsigned int irq)
-{
-	enable_m32700ut_lanpld_irq(irq);
-	end_m32700ut_irq(M32R_IRQ_INT0);
-}
-
-static unsigned int startup_m32700ut_lanpld_irq(unsigned int irq)
-{
-	enable_m32700ut_lanpld_irq(irq);
-	return (0);
+	enable_m32700ut_irq(M32R_IRQ_INT0);
 }
 
 static void shutdown_m32700ut_lanpld_irq(unsigned int irq)
@@ -218,12 +162,9 @@ static void shutdown_m32700ut_lanpld_irq(unsigned int irq)
 static struct irq_chip m32700ut_lanpld_irq_type =
 {
 	.typename = "M32700UT-PLD-LAN-IRQ",
-	.startup = startup_m32700ut_lanpld_irq,
 	.shutdown = shutdown_m32700ut_lanpld_irq,
-	.enable = enable_m32700ut_lanpld_irq,
-	.disable = disable_m32700ut_lanpld_irq,
-	.ack = mask_and_ack_m32700ut_lanpld,
-	.end = end_m32700ut_lanpld_irq
+	.unmask = enable_m32700ut_lanpld_irq,
+	.mask = disable_m32700ut_lanpld_irq,
 };
 
 /*
@@ -255,23 +196,7 @@ static void enable_m32700ut_lcdpld_irq(unsigned int irq)
 	port = lcdpldirq2port(pldirq);
 	data = lcdpld_icu_data[pldirq].icucr|PLD_ICUCR_IEN|PLD_ICUCR_ILEVEL6;
 	outw(data, port);
-}
-
-static void mask_and_ack_m32700ut_lcdpld(unsigned int irq)
-{
-	disable_m32700ut_lcdpld_irq(irq);
-}
-
-static void end_m32700ut_lcdpld_irq(unsigned int irq)
-{
-	enable_m32700ut_lcdpld_irq(irq);
-	end_m32700ut_irq(M32R_IRQ_INT2);
-}
-
-static unsigned int startup_m32700ut_lcdpld_irq(unsigned int irq)
-{
-	enable_m32700ut_lcdpld_irq(irq);
-	return (0);
+	enable_m32700ut_irq(M32R_IRQ_INT2);
 }
 
 static void shutdown_m32700ut_lcdpld_irq(unsigned int irq)
@@ -287,77 +212,86 @@ static void shutdown_m32700ut_lcdpld_irq(unsigned int irq)
 static struct irq_chip m32700ut_lcdpld_irq_type =
 {
 	.typename = "M32700UT-PLD-LCD-IRQ",
-	.startup = startup_m32700ut_lcdpld_irq,
 	.shutdown = shutdown_m32700ut_lcdpld_irq,
-	.enable = enable_m32700ut_lcdpld_irq,
-	.disable = disable_m32700ut_lcdpld_irq,
-	.ack = mask_and_ack_m32700ut_lcdpld,
-	.end = end_m32700ut_lcdpld_irq
+	.unmask = enable_m32700ut_lcdpld_irq,
+	.mask = disable_m32700ut_lcdpld_irq,
 };
 
 void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on M32700UT-LAN (SMC91C111)*/
-	set_irq_chip(M32700UT_LAN_IRQ_LAN, &m32700ut_lanpld_irq_type);
+	set_irq_chip_and_handler(M32700UT_LAN_IRQ_LAN, &m32700ut_lanpld_irq_type,
+		handle_level_irq);
 	lanpld_icu_data[irq2lanpldirq(M32700UT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_m32700ut_lanpld_irq(M32700UT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &m32700ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &m32700ut_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_m32700ut_irq(M32R_IRQ_MFT2);
 
 	/* SIO0 : receive */
-	set_irq_chip(M32R_IRQ_SIO0_R, &m32700ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &m32700ut_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0 : send */
-	set_irq_chip(M32R_IRQ_SIO0_S, &m32700ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &m32700ut_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1 : receive */
-	set_irq_chip(M32R_IRQ_SIO1_R, &m32700ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &m32700ut_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1 : send */
-	set_irq_chip(M32R_IRQ_SIO1_S, &m32700ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &m32700ut_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_SIO1_S);
 
 	/* DMA1 : */
-	set_irq_chip(M32R_IRQ_DMA1, &m32700ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_DMA1, &m32700ut_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_DMA1].icucr = 0;
 	disable_m32700ut_irq(M32R_IRQ_DMA1);
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	set_irq_chip(PLD_IRQ_SIO0_RCV, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_SIO0_RCV, &m32700ut_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	set_irq_chip(PLD_IRQ_SIO0_SND, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_SIO0_SND, &m32700ut_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_m32700ut_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	set_irq_chip(PLD_IRQ_CFIREQ, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &m32700ut_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	set_irq_chip(PLD_IRQ_CFC_INSERT, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &m32700ut_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	set_irq_chip(PLD_IRQ_CFC_EJECT, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_EJECT, &m32700ut_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_CFC_EJECT);
 
@@ -377,7 +311,8 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_USB)
 	outw(USBCR_OTGS, USBCR); 	/* USBCR: non-OTG */
-	set_irq_chip(M32700UT_LCD_IRQ_USB_INT1, &m32700ut_lcdpld_irq_type);
+	set_irq_chip_and_handler(M32700UT_LCD_IRQ_USB_INT1, &m32700ut_lcdpld_irq_type,
+		handle_level_irq);
 
 	lcdpld_icu_data[irq2lcdpldirq(M32700UT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
 	disable_m32700ut_lcdpld_irq(M32700UT_LCD_IRQ_USB_INT1);
@@ -393,7 +328,8 @@ void __init init_IRQ(void)
 	/*
 	 * INT3# is used for AR
 	 */
-	set_irq_chip(M32R_IRQ_INT3, &m32700ut_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT3, &m32700ut_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_m32700ut_irq(M32R_IRQ_INT3);
 #endif	/* CONFIG_VIDEO_M32R_AR */
diff --git a/arch/m32r/platforms/mappi/setup.c b/arch/m32r/platforms/mappi/setup.c
index 8a63b85..1223db3 100644
--- a/arch/m32r/platforms/mappi/setup.c
+++ b/arch/m32r/platforms/mappi/setup.c
@@ -38,22 +38,6 @@ static void enable_mappi_irq(unsigned int irq)
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi(unsigned int irq)
-{
-	disable_mappi_irq(irq);
-}
-
-static void end_mappi_irq(unsigned int irq)
-{
-		enable_mappi_irq(irq);
-}
-
-static unsigned int startup_mappi_irq(unsigned int irq)
-{
-	enable_mappi_irq(irq);
-	return (0);
-}
-
 static void shutdown_mappi_irq(unsigned int irq)
 {
 	unsigned long port;
@@ -65,12 +49,9 @@ static void shutdown_mappi_irq(unsigned int irq)
 static struct irq_chip mappi_irq_type =
 {
 	.typename = "MAPPI-IRQ",
-	.startup = startup_mappi_irq,
 	.shutdown = shutdown_mappi_irq,
-	.enable = enable_mappi_irq,
-	.disable = disable_mappi_irq,
-	.ack = mask_and_ack_mappi,
-	.end = end_mappi_irq
+	.unmask = enable_mappi_irq,
+	.mask = disable_mappi_irq,
 };
 
 void __init init_IRQ(void)
@@ -84,46 +65,54 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT0 : LAN controller (RTL8019AS) */
-	set_irq_chip(M32R_IRQ_INT0, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT0, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD11;
 	disable_mappi_irq(M32R_IRQ_INT0);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO0_R, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO0_S, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO1_R, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO1_S, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
 
 #if defined(CONFIG_M32R_PCC)
 	/* INT1 : pccard0 interrupt */
-	set_irq_chip(M32R_IRQ_INT1, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT1, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT1);
 
 	/* INT2 : pccard1 interrupt */
-	set_irq_chip(M32R_IRQ_INT2, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT2, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_INT2].icucr = M32R_ICUCR_IEN | M32R_ICUCR_ISMOD00;
 	disable_mappi_irq(M32R_IRQ_INT2);
 #endif /* CONFIG_M32RPCC */
diff --git a/arch/m32r/platforms/mappi2/setup.c b/arch/m32r/platforms/mappi2/setup.c
index 8d7ef39..42558a5 100644
--- a/arch/m32r/platforms/mappi2/setup.c
+++ b/arch/m32r/platforms/mappi2/setup.c
@@ -46,22 +46,6 @@ static void enable_mappi2_irq(unsigned int irq)
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi2(unsigned int irq)
-{
-	disable_mappi2_irq(irq);
-}
-
-static void end_mappi2_irq(unsigned int irq)
-{
-	enable_mappi2_irq(irq);
-}
-
-static unsigned int startup_mappi2_irq(unsigned int irq)
-{
-	enable_mappi2_irq(irq);
-	return (0);
-}
-
 static void shutdown_mappi2_irq(unsigned int irq)
 {
 	unsigned long port;
@@ -73,69 +57,76 @@ static void shutdown_mappi2_irq(unsigned int irq)
 static struct irq_chip mappi2_irq_type =
 {
 	.typename = "MAPPI2-IRQ",
-	.startup = startup_mappi2_irq,
 	.shutdown = shutdown_mappi2_irq,
-	.enable = enable_mappi2_irq,
-	.disable = disable_mappi2_irq,
-	.ack = mask_and_ack_mappi2,
-	.end = end_mappi2_irq
+	.unmask = enable_mappi2_irq,
+	.mask = disable_mappi2_irq,
 };
 
 void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-	set_irq_chip(M32R_IRQ_INT0, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT0, &mappi2_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi2_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi2_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO0_R, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &mappi2_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO0_S, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &mappi2_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO1_R, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &mappi2_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO1_S, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &mappi2_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi2_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_M32R_USE_DBG_CONSOLE */
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	set_irq_chip(M32R_IRQ_INT1, &mappi2_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT1, &mappi2_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* ICUCR40: CFC IREQ */
-	set_irq_chip(PLD_IRQ_CFIREQ, &mappi2_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &mappi2_irq_type,
+		handle_level_irq);
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi2_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert */
-	set_irq_chip(PLD_IRQ_CFC_INSERT, &mappi2_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &mappi2_irq_type,
+		handle_level_irq);
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi2_irq(PLD_IRQ_CFC_INSERT);
 
 	/* ICUCR42: CFC Eject */
-	set_irq_chip(PLD_IRQ_CFC_EJECT, &mappi2_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_EJECT, &mappi2_irq_type,
+		handle_level_irq);
 	icu_data[PLD_IRQ_CFC_EJECT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi2_irq(PLD_IRQ_CFC_EJECT);
 #endif /* CONFIG_MAPPI2_CFC */
diff --git a/arch/m32r/platforms/mappi3/setup.c b/arch/m32r/platforms/mappi3/setup.c
index 6e25bb7..e88a178 100644
--- a/arch/m32r/platforms/mappi3/setup.c
+++ b/arch/m32r/platforms/mappi3/setup.c
@@ -46,22 +46,6 @@ static void enable_mappi3_irq(unsigned int irq)
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi3(unsigned int irq)
-{
-	disable_mappi3_irq(irq);
-}
-
-static void end_mappi3_irq(unsigned int irq)
-{
-	enable_mappi3_irq(irq);
-}
-
-static unsigned int startup_mappi3_irq(unsigned int irq)
-{
-	enable_mappi3_irq(irq);
-	return (0);
-}
-
 static void shutdown_mappi3_irq(unsigned int irq)
 {
 	unsigned long port;
@@ -73,71 +57,78 @@ static void shutdown_mappi3_irq(unsigned int irq)
 static struct irq_chip mappi3_irq_type =
 {
 	.typename = "MAPPI3-IRQ",
-	.startup = startup_mappi3_irq,
 	.shutdown = shutdown_mappi3_irq,
-	.enable = enable_mappi3_irq,
-	.disable = disable_mappi3_irq,
-	.ack = mask_and_ack_mappi3,
-	.end = end_mappi3_irq
+	.unmask = enable_mappi3_irq,
+	.mask = disable_mappi3_irq,
 };
 
 void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT0 : LAN controller (SMC91111) */
-	set_irq_chip(M32R_IRQ_INT0, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT0, &mappi3_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(M32R_IRQ_INT0);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi3_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi3_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO0_R, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &mappi3_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO0_S, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &mappi3_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO0_S);
 	/* SIO1_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO1_R, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &mappi3_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO1_S, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &mappi3_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi3_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_M32R_USE_DBG_CONSOLE */
 
 #if defined(CONFIG_USB)
 	/* INT1 : USB Host controller interrupt */
-	set_irq_chip(M32R_IRQ_INT1, &mappi3_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT1, &mappi3_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_INT1].icucr = M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(M32R_IRQ_INT1);
 #endif /* CONFIG_USB */
 
 	/* CFC IREQ */
-	set_irq_chip(PLD_IRQ_CFIREQ, &mappi3_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &mappi3_irq_type,
+		handle_level_irq);
 	icu_data[PLD_IRQ_CFIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD01;
 	disable_mappi3_irq(PLD_IRQ_CFIREQ);
 
 #if defined(CONFIG_M32R_CFC)
 	/* ICUCR41: CFC Insert & eject */
-	set_irq_chip(PLD_IRQ_CFC_INSERT, &mappi3_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &mappi3_irq_type,
+		handle_level_irq);
 	icu_data[PLD_IRQ_CFC_INSERT].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD00;
 	disable_mappi3_irq(PLD_IRQ_CFC_INSERT);
 
 #endif /* CONFIG_M32R_CFC */
 
 	/* IDE IREQ */
-	set_irq_chip(PLD_IRQ_IDEIREQ, &mappi3_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_IDEIREQ, &mappi3_irq_type,
+		handle_level_irq);
 	icu_data[PLD_IRQ_IDEIREQ].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_mappi3_irq(PLD_IRQ_IDEIREQ);
 
diff --git a/arch/m32r/platforms/oaks32r/setup.c b/arch/m32r/platforms/oaks32r/setup.c
index 12a794d..c062437 100644
--- a/arch/m32r/platforms/oaks32r/setup.c
+++ b/arch/m32r/platforms/oaks32r/setup.c
@@ -37,22 +37,6 @@ static void enable_oaks32r_irq(unsigned int irq)
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi(unsigned int irq)
-{
-	disable_oaks32r_irq(irq);
-}
-
-static void end_oaks32r_irq(unsigned int irq)
-{
-	enable_oaks32r_irq(irq);
-}
-
-static unsigned int startup_oaks32r_irq(unsigned int irq)
-{
-	enable_oaks32r_irq(irq);
-	return (0);
-}
-
 static void shutdown_oaks32r_irq(unsigned int irq)
 {
 	unsigned long port;
@@ -64,12 +48,9 @@ static void shutdown_oaks32r_irq(unsigned int irq)
 static struct irq_chip oaks32r_irq_type =
 {
 	.typename = "OAKS32R-IRQ",
-	.startup = startup_oaks32r_irq,
 	.shutdown = shutdown_oaks32r_irq,
-	.enable = enable_oaks32r_irq,
-	.disable = disable_oaks32r_irq,
-	.ack = mask_and_ack_mappi,
-	.end = end_oaks32r_irq
+	.unmask = enable_oaks32r_irq,
+	.mask = disable_oaks32r_irq,
 };
 
 void __init init_IRQ(void)
@@ -83,34 +64,40 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_NE2000
 	/* INT3 : LAN controller (RTL8019AS) */
-	set_irq_chip(M32R_IRQ_INT3, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT3, &oaks32r_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_oaks32r_irq(M32R_IRQ_INT3);
 #endif /* CONFIG_M32R_NE2000 */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &oaks32r_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_oaks32r_irq(M32R_IRQ_MFT2);
 
 #ifdef CONFIG_SERIAL_M32R_SIO
 	/* SIO0_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO0_R, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &oaks32r_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO0_S, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &oaks32r_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO1_R, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &oaks32r_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO1_S, &oaks32r_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &oaks32r_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_oaks32r_irq(M32R_IRQ_SIO1_S);
 #endif /* CONFIG_SERIAL_M32R_SIO */
diff --git a/arch/m32r/platforms/opsput/setup.c b/arch/m32r/platforms/opsput/setup.c
index 423898a..c20050e 100644
--- a/arch/m32r/platforms/opsput/setup.c
+++ b/arch/m32r/platforms/opsput/setup.c
@@ -46,22 +46,6 @@ static void enable_opsput_irq(unsigned int irq)
 	outl(data, port);
 }
 
-static void mask_and_ack_opsput(unsigned int irq)
-{
-	disable_opsput_irq(irq);
-}
-
-static void end_opsput_irq(unsigned int irq)
-{
-	enable_opsput_irq(irq);
-}
-
-static unsigned int startup_opsput_irq(unsigned int irq)
-{
-	enable_opsput_irq(irq);
-	return (0);
-}
-
 static void shutdown_opsput_irq(unsigned int irq)
 {
 	unsigned long port;
@@ -73,12 +57,9 @@ static void shutdown_opsput_irq(unsigned int irq)
 static struct irq_chip opsput_irq_type =
 {
 	.typename = "OPSPUT-IRQ",
-	.startup = startup_opsput_irq,
 	.shutdown = shutdown_opsput_irq,
-	.enable = enable_opsput_irq,
-	.disable = disable_opsput_irq,
-	.ack = mask_and_ack_opsput,
-	.end = end_opsput_irq
+	.unmask = enable_opsput_irq,
+	.mask = disable_opsput_irq,
 };
 
 /*
@@ -112,28 +93,10 @@ static void enable_opsput_pld_irq(unsigned int irq)
 	unsigned int pldirq;
 
 	pldirq = irq2pldirq(irq);
-//	enable_opsput_irq(M32R_IRQ_INT1);
 	port = pldirq2port(pldirq);
 	data = pld_icu_data[pldirq].icucr|PLD_ICUCR_IEN|PLD_ICUCR_ILEVEL6;
 	outw(data, port);
-}
-
-static void mask_and_ack_opsput_pld(unsigned int irq)
-{
-	disable_opsput_pld_irq(irq);
-//	mask_and_ack_opsput(M32R_IRQ_INT1);
-}
-
-static void end_opsput_pld_irq(unsigned int irq)
-{
-	enable_opsput_pld_irq(irq);
-	end_opsput_irq(M32R_IRQ_INT1);
-}
-
-static unsigned int startup_opsput_pld_irq(unsigned int irq)
-{
-	enable_opsput_pld_irq(irq);
-	return (0);
+	enable_opsput_irq(M32R_IRQ_INT1);
 }
 
 static void shutdown_opsput_pld_irq(unsigned int irq)
@@ -150,12 +113,9 @@ static void shutdown_opsput_pld_irq(unsigned int irq)
 static struct irq_chip opsput_pld_irq_type =
 {
 	.typename = "OPSPUT-PLD-IRQ",
-	.startup = startup_opsput_pld_irq,
 	.shutdown = shutdown_opsput_pld_irq,
-	.enable = enable_opsput_pld_irq,
-	.disable = disable_opsput_pld_irq,
-	.ack = mask_and_ack_opsput_pld,
-	.end = end_opsput_pld_irq
+	.unmask = enable_opsput_pld_irq,
+	.mask = disable_opsput_pld_irq,
 };
 
 /*
@@ -187,23 +147,7 @@ static void enable_opsput_lanpld_irq(unsigned int irq)
 	port = lanpldirq2port(pldirq);
 	data = lanpld_icu_data[pldirq].icucr|PLD_ICUCR_IEN|PLD_ICUCR_ILEVEL6;
 	outw(data, port);
-}
-
-static void mask_and_ack_opsput_lanpld(unsigned int irq)
-{
-	disable_opsput_lanpld_irq(irq);
-}
-
-static void end_opsput_lanpld_irq(unsigned int irq)
-{
-	enable_opsput_lanpld_irq(irq);
-	end_opsput_irq(M32R_IRQ_INT0);
-}
-
-static unsigned int startup_opsput_lanpld_irq(unsigned int irq)
-{
-	enable_opsput_lanpld_irq(irq);
-	return (0);
+	enable_opsput_irq(M32R_IRQ_INT0);
 }
 
 static void shutdown_opsput_lanpld_irq(unsigned int irq)
@@ -219,12 +163,9 @@ static void shutdown_opsput_lanpld_irq(unsigned int irq)
 static struct irq_chip opsput_lanpld_irq_type =
 {
 	.typename = "OPSPUT-PLD-LAN-IRQ",
-	.startup = startup_opsput_lanpld_irq,
 	.shutdown = shutdown_opsput_lanpld_irq,
-	.enable = enable_opsput_lanpld_irq,
-	.disable = disable_opsput_lanpld_irq,
-	.ack = mask_and_ack_opsput_lanpld,
-	.end = end_opsput_lanpld_irq
+	.unmask = enable_opsput_lanpld_irq,
+	.mask = disable_opsput_lanpld_irq,
 };
 
 /*
@@ -256,23 +197,7 @@ static void enable_opsput_lcdpld_irq(unsigned int irq)
 	port = lcdpldirq2port(pldirq);
 	data = lcdpld_icu_data[pldirq].icucr|PLD_ICUCR_IEN|PLD_ICUCR_ILEVEL6;
 	outw(data, port);
-}
-
-static void mask_and_ack_opsput_lcdpld(unsigned int irq)
-{
-	disable_opsput_lcdpld_irq(irq);
-}
-
-static void end_opsput_lcdpld_irq(unsigned int irq)
-{
-	enable_opsput_lcdpld_irq(irq);
-	end_opsput_irq(M32R_IRQ_INT2);
-}
-
-static unsigned int startup_opsput_lcdpld_irq(unsigned int irq)
-{
-	enable_opsput_lcdpld_irq(irq);
-	return (0);
+	enable_opsput_irq(M32R_IRQ_INT2);
 }
 
 static void shutdown_opsput_lcdpld_irq(unsigned int irq)
@@ -287,78 +212,87 @@ static void shutdown_opsput_lcdpld_irq(unsigned int irq)
 
 static struct irq_chip opsput_lcdpld_irq_type =
 {
-	"OPSPUT-PLD-LCD-IRQ",
-	startup_opsput_lcdpld_irq,
-	shutdown_opsput_lcdpld_irq,
-	enable_opsput_lcdpld_irq,
-	disable_opsput_lcdpld_irq,
-	mask_and_ack_opsput_lcdpld,
-	end_opsput_lcdpld_irq
+	.typename = "OPSPUT-PLD-LCD-IRQ",
+	.shutdown = shutdown_opsput_lcdpld_irq,
+	.unmask = enable_opsput_lcdpld_irq,
+	.mask = disable_opsput_lcdpld_irq,
 };
 
 void __init init_IRQ(void)
 {
 #if defined(CONFIG_SMC91X)
 	/* INT#0: LAN controller on OPSPUT-LAN (SMC91C111)*/
-	set_irq_chip(OPSPUT_LAN_IRQ_LAN, &opsput_lanpld_irq_type);
+	set_irq_chip_and_handler(OPSPUT_LAN_IRQ_LAN, &opsput_lanpld_irq_type,
+		handle_level_irq);
 	lanpld_icu_data[irq2lanpldirq(OPSPUT_LAN_IRQ_LAN)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* "H" edge sense */
 	disable_opsput_lanpld_irq(OPSPUT_LAN_IRQ_LAN);
 #endif  /* CONFIG_SMC91X */
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &opsput_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_opsput_irq(M32R_IRQ_MFT2);
 
 	/* SIO0 : receive */
-	set_irq_chip(M32R_IRQ_SIO0_R, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &opsput_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0 : send */
-	set_irq_chip(M32R_IRQ_SIO0_S, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &opsput_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1 : receive */
-	set_irq_chip(M32R_IRQ_SIO1_R, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &opsput_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1 : send */
-	set_irq_chip(M32R_IRQ_SIO1_S, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &opsput_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_SIO1_S);
 
 	/* DMA1 : */
-	set_irq_chip(M32R_IRQ_DMA1, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_DMA1, &opsput_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_DMA1].icucr = 0;
 	disable_opsput_irq(M32R_IRQ_DMA1);
 
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
 	/* INT#1: SIO0 Receive on PLD */
-	set_irq_chip(PLD_IRQ_SIO0_RCV, &opsput_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_SIO0_RCV, &opsput_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_RCV)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_RCV);
 
 	/* INT#1: SIO0 Send on PLD */
-	set_irq_chip(PLD_IRQ_SIO0_SND, &opsput_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_SIO0_SND, &opsput_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SIO0_SND)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD03;
 	disable_opsput_pld_irq(PLD_IRQ_SIO0_SND);
 #endif  /* CONFIG_SERIAL_M32R_PLDSIO */
 
 	/* INT#1: CFC IREQ on PLD */
-	set_irq_chip(PLD_IRQ_CFIREQ, &opsput_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFIREQ, &opsput_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFIREQ)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFIREQ);
 
 	/* INT#1: CFC Insert on PLD */
-	set_irq_chip(PLD_IRQ_CFC_INSERT, &opsput_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_INSERT, &opsput_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_INSERT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD00;	/* 'L' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_INSERT);
 
 	/* INT#1: CFC Eject on PLD */
-	set_irq_chip(PLD_IRQ_CFC_EJECT, &opsput_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_CFC_EJECT, &opsput_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_CFC_EJECT)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD02;	/* 'H' edge sense */
 	disable_opsput_pld_irq(PLD_IRQ_CFC_EJECT);
 
@@ -379,9 +313,10 @@ void __init init_IRQ(void)
 #if defined(CONFIG_USB)
 	outw(USBCR_OTGS, USBCR); 	/* USBCR: non-OTG */
 
-    set_irq_chip(OPSPUT_LCD_IRQ_USB_INT1, &opsput_lcdpld_irq_type);
-    lcdpld_icu_data[irq2lcdpldirq(OPSPUT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
-    disable_opsput_lcdpld_irq(OPSPUT_LCD_IRQ_USB_INT1);
+	set_irq_chip_and_handler(OPSPUT_LCD_IRQ_USB_INT1, &opsput_lcdpld_irq_type,
+		handle_level_irq);
+	lcdpld_icu_data[irq2lcdpldirq(OPSPUT_LCD_IRQ_USB_INT1)].icucr = PLD_ICUCR_IEN|PLD_ICUCR_ISMOD01;	/* "L" level sense */
+	disable_opsput_lcdpld_irq(OPSPUT_LCD_IRQ_USB_INT1);
 #endif
 	/*
 	 * INT2# is used for BAT, USB, AUDIO
@@ -394,7 +329,8 @@ void __init init_IRQ(void)
 	/*
 	 * INT3# is used for AR
 	 */
-	set_irq_chip(M32R_IRQ_INT3, &opsput_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_INT3, &opsput_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_INT3].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
 	disable_opsput_irq(M32R_IRQ_INT3);
 #endif /* CONFIG_VIDEO_M32R_AR */
diff --git a/arch/m32r/platforms/usrv/setup.c b/arch/m32r/platforms/usrv/setup.c
index fc25ef9..343bb0b 100644
--- a/arch/m32r/platforms/usrv/setup.c
+++ b/arch/m32r/platforms/usrv/setup.c
@@ -37,22 +37,6 @@ static void enable_mappi_irq(unsigned int irq)
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi(unsigned int irq)
-{
-	disable_mappi_irq(irq);
-}
-
-static void end_mappi_irq(unsigned int irq)
-{
-	enable_mappi_irq(irq);
-}
-
-static unsigned int startup_mappi_irq(unsigned int irq)
-{
-	enable_mappi_irq(irq);
-	return 0;
-}
-
 static void shutdown_mappi_irq(unsigned int irq)
 {
 	unsigned long port;
@@ -64,12 +48,9 @@ static void shutdown_mappi_irq(unsigned int irq)
 static struct irq_chip mappi_irq_type =
 {
 	.typename = "M32700-IRQ",
-	.startup = startup_mappi_irq,
 	.shutdown = shutdown_mappi_irq,
-	.enable = enable_mappi_irq,
-	.disable = disable_mappi_irq,
-	.ack = mask_and_ack_mappi,
-	.end = end_mappi_irq
+	.unmask = enable_mappi_irq,
+	.mask = disable_mappi_irq,
 };
 
 /*
@@ -105,23 +86,7 @@ static void enable_m32700ut_pld_irq(unsigned int irq)
 	port = pldirq2port(pldirq);
 	data = pld_icu_data[pldirq].icucr|PLD_ICUCR_IEN|PLD_ICUCR_ILEVEL6;
 	outw(data, port);
-}
-
-static void mask_and_ack_m32700ut_pld(unsigned int irq)
-{
-	disable_m32700ut_pld_irq(irq);
-}
-
-static void end_m32700ut_pld_irq(unsigned int irq)
-{
-	enable_m32700ut_pld_irq(irq);
-	end_mappi_irq(M32R_IRQ_INT1);
-}
-
-static unsigned int startup_m32700ut_pld_irq(unsigned int irq)
-{
-	enable_m32700ut_pld_irq(irq);
-	return 0;
+	enable_mappi_irq(M32R_IRQ_INT1);
 }
 
 static void shutdown_m32700ut_pld_irq(unsigned int irq)
@@ -137,12 +102,9 @@ static void shutdown_m32700ut_pld_irq(unsigned int irq)
 static struct irq_chip m32700ut_pld_irq_type =
 {
 	.typename = "USRV-PLD-IRQ",
-	.startup = startup_m32700ut_pld_irq,
 	.shutdown = shutdown_m32700ut_pld_irq,
-	.enable = enable_m32700ut_pld_irq,
-	.disable = disable_m32700ut_pld_irq,
-	.ack = mask_and_ack_m32700ut_pld,
-	.end = end_m32700ut_pld_irq
+	.unmask = enable_m32700ut_pld_irq,
+	.mask = disable_m32700ut_pld_irq,
 };
 
 void __init init_IRQ(void)
@@ -156,35 +118,41 @@ void __init init_IRQ(void)
 		once++;
 
 	/* MFT2 : system timer */
-	set_irq_chip(M32R_IRQ_MFT2, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_MFT2, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_MFT2].icucr = M32R_ICUCR_IEN;
 	disable_mappi_irq(M32R_IRQ_MFT2);
 
 #if defined(CONFIG_SERIAL_M32R_SIO)
 	/* SIO0_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO0_R, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_R, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_R);
 
 	/* SIO0_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO0_S, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO0_S, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO0_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO0_S);
 
 	/* SIO1_R : uart receive data */
-	set_irq_chip(M32R_IRQ_SIO1_R, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_R, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_R].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_R);
 
 	/* SIO1_S : uart send data */
-	set_irq_chip(M32R_IRQ_SIO1_S, &mappi_irq_type);
+	set_irq_chip_and_handler(M32R_IRQ_SIO1_S, &mappi_irq_type,
+		handle_level_irq);
 	icu_data[M32R_IRQ_SIO1_S].icucr = 0;
 	disable_mappi_irq(M32R_IRQ_SIO1_S);
 #endif  /* CONFIG_SERIAL_M32R_SIO */
 
 	/* INT#67-#71: CFC#0 IREQ on PLD */
 	for (i = 0 ; i < CONFIG_M32R_CFC_NUM ; i++ ) {
-		set_irq_chip(PLD_IRQ_CF0 + i, &m32700ut_pld_irq_type);
+		set_irq_chip_and_handler(PLD_IRQ_CF0 + i, &m32700ut_pld_irq_type,
+			handle_level_irq);
 		pld_icu_data[irq2pldirq(PLD_IRQ_CF0 + i)].icucr
 			= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 		disable_m32700ut_pld_irq(PLD_IRQ_CF0 + i);
@@ -192,13 +160,15 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
 	/* INT#76: 16552D#0 IREQ on PLD */
-	set_irq_chip(PLD_IRQ_UART0, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_UART0, &m32700ut_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART0)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_UART0);
 
 	/* INT#77: 16552D#1 IREQ on PLD */
-	set_irq_chip(PLD_IRQ_UART1, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_UART1, &m32700ut_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_UART1)].icucr
 		= PLD_ICUCR_ISMOD03;	/* 'H' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_UART1);
@@ -206,7 +176,8 @@ void __init init_IRQ(void)
 
 #if defined(CONFIG_IDC_AK4524) || defined(CONFIG_IDC_AK4524_MODULE)
 	/* INT#80: AK4524 IREQ on PLD */
-	set_irq_chip(PLD_IRQ_SNDINT, &m32700ut_pld_irq_type);
+	set_irq_chip_and_handler(PLD_IRQ_SNDINT, &m32700ut_pld_irq_type,
+		handle_level_irq);
 	pld_icu_data[irq2pldirq(PLD_IRQ_SNDINT)].icucr
 		= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
 	disable_m32700ut_pld_irq(PLD_IRQ_SNDINT);
-- 
1.7.3.1

