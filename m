Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab1IKMCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:02:53 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:42649 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760090Ab1IKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 10/28] m68k/irq: Add m68k_setup_irq_controller()
Date: Sun, 11 Sep 2011 13:59:36 +0200
Message-Id: <1315742394-16036-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a wrapper around m68k_setup_irq_chip() that discards its dummy
second parameter, to ease the future transition to genirq.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v3: Use handle_simple_irq() instead of handle_level_irq()

v2: Added this changeset
---
 arch/m68k/amiga/amiints.c   |    3 ++-
 arch/m68k/amiga/cia.c       |    6 ++++--
 arch/m68k/apollo/dn_ints.c  |    3 ++-
 arch/m68k/atari/ataints.c   |    3 ++-
 arch/m68k/include/asm/irq.h |    2 ++
 arch/m68k/mac/macints.c     |    2 +-
 arch/m68k/q40/q40ints.c     |    3 ++-
 arch/m68k/sun3/sun3ints.c   |    3 ++-
 8 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/amiga/amiints.c b/arch/m68k/amiga/amiints.c
index 09a695b..8af5ea3 100644
--- a/arch/m68k/amiga/amiints.c
+++ b/arch/m68k/amiga/amiints.c
@@ -80,7 +80,8 @@ void __init amiga_init_IRQ(void)
 	if (request_irq(IRQ_AUTO_5, ami_int5, 0, "int5", NULL))
 		pr_err("Couldn't register int%d\n", 5);
 
-	m68k_setup_irq_chip(&amiga_irq_chip, IRQ_USER, AMI_STD_IRQS);
+	m68k_setup_irq_controller(&amiga_irq_chip, handle_simple_irq, IRQ_USER,
+				  AMI_STD_IRQS);
 
 	/* turn off PCMCIA interrupts */
 	if (AMIGAHW_PRESENT(PCMCIA))
diff --git a/arch/m68k/amiga/cia.c b/arch/m68k/amiga/cia.c
index b04b453..84663ae 100644
--- a/arch/m68k/amiga/cia.c
+++ b/arch/m68k/amiga/cia.c
@@ -168,14 +168,16 @@ static struct irq_chip auto_irq_chip = {
 
 void __init cia_init_IRQ(struct ciabase *base)
 {
-	m68k_setup_irq_chip(&cia_irq_chip, base->cia_irq, CIA_IRQS);
+	m68k_setup_irq_controller(&cia_irq_chip, handle_simple_irq,
+				  base->cia_irq, CIA_IRQS);
 
 	/* clear any pending interrupt and turn off all interrupts */
 	cia_set_irq(base, CIA_ICR_ALL);
 	cia_able_irq(base, CIA_ICR_ALL);
 
 	/* override auto int and install CIA handler */
-	m68k_setup_irq_chip(&auto_irq_chip, base->handler_irq, 1);
+	m68k_setup_irq_controller(&auto_irq_chip, handle_simple_irq,
+				  base->handler_irq, 1);
 	m68k_irq_startup_irq(base->handler_irq);
 	if (request_irq(base->handler_irq, cia_handler, IRQF_SHARED,
 			base->name, base))
diff --git a/arch/m68k/apollo/dn_ints.c b/arch/m68k/apollo/dn_ints.c
index 2bdab49..bdc4428 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -43,5 +43,6 @@ static struct irq_chip apollo_irq_chip = {
 void __init dn_init_IRQ(void)
 {
 	m68k_setup_user_interrupt(VEC_USER + 96, 16, dn_process_int);
-	m68k_setup_irq_chip(&apollo_irq_chip, IRQ_APOLLO, 16);
+	m68k_setup_irq_controller(&apollo_irq_chip, handle_simple_irq,
+				  IRQ_APOLLO, 16);
 }
diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index de0cb42..ab3ac13 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -372,7 +372,8 @@ static struct irq_chip atari_irq_chip = {
 void __init atari_init_IRQ(void)
 {
 	m68k_setup_user_interrupt(VEC_USER, NUM_ATARI_SOURCES - IRQ_USER, NULL);
-	m68k_setup_irq_chip(&atari_irq_chip, 1, NUM_ATARI_SOURCES - 1);
+	m68k_setup_irq_controller(&atari_irq_chip, handle_simple_irq, 1,
+				  NUM_ATARI_SOURCES - 1);
 
 	/* Initialize the MFP(s) */
 
diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index 423f064..d0b7efd 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -115,6 +115,8 @@ extern void m68k_setup_auto_interrupt(void (*handler)(unsigned int, struct pt_re
 extern void m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
 				      void (*handler)(unsigned int, struct pt_regs *));
 extern void m68k_setup_irq_chip(struct irq_chip *, unsigned int, unsigned int);
+#define m68k_setup_irq_controller(chip, dummy, irq, cnt) \
+	m68k_setup_irq_chip((chip), (irq), (cnt))
 
 asmlinkage void m68k_handle_int(unsigned int);
 asmlinkage void __m68k_handle_int(unsigned int, struct pt_regs *);
diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
index 3cee6d2..98497d2 100644
--- a/arch/m68k/mac/macints.c
+++ b/arch/m68k/mac/macints.c
@@ -214,7 +214,7 @@ void __init mac_init_IRQ(void)
 #ifdef DEBUG_MACINTS
 	printk("mac_init_IRQ(): Setting things up...\n");
 #endif
-	m68k_setup_irq_chip(&mac_irq_chip, IRQ_USER,
+	m68k_setup_irq_controller(&mac_irq_chip, handle_simple_irq, IRQ_USER,
 				  NUM_MAC_SOURCES - IRQ_USER);
 	/* Make sure the SONIC interrupt is cleared or things get ugly */
 #ifdef SHUTUP_SONIC
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index cb245f9..a8a5ce8 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -82,7 +82,8 @@ static int disabled;
 
 void __init q40_init_IRQ(void)
 {
-	m68k_setup_irq_chip(&q40_irq_chip, 1, Q40_IRQ_MAX);
+	m68k_setup_irq_controller(&q40_irq_chip, handle_simple_irq, 1,
+				  Q40_IRQ_MAX);
 
 	/* setup handler for ISA ints */
 	m68k_setup_auto_interrupt(q40_irq_handler);
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 5d45e00..2046127 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -109,7 +109,8 @@ void __init sun3_init_IRQ(void)
 	*sun3_intreg = 1;
 
 	m68k_setup_auto_interrupt(sun3_inthandle);
-	m68k_setup_irq_chip(&sun3_irq_chip, IRQ_AUTO_1, 7);
+	m68k_setup_irq_controller(&sun3_irq_chip, handle_simple_irq,
+				  IRQ_AUTO_1, 7);
 	m68k_setup_user_interrupt(VEC_USER, 128, NULL);
 
 	if (request_irq(IRQ_AUTO_5, sun3_int5, 0, "int5", NULL))
-- 
1.7.0.4

