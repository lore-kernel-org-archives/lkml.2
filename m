Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226Ab1IKMBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:01:55 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:42716 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119Ab1IKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 28/28] m68k/irq: Remove obsolete support for user vector interrupt fixups
Date: Sun, 11 Sep 2011 13:59:54 +0200
Message-Id: <1315742394-16036-29-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was used on Apollo only, before its conversion to genirq.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v6: Added this changeset
---
 arch/m68k/apollo/dn_ints.c  |    2 +-
 arch/m68k/atari/ataints.c   |    2 +-
 arch/m68k/bvme6000/config.c |    2 +-
 arch/m68k/include/asm/irq.h |    4 +---
 arch/m68k/kernel/entry_mm.S |    3 +--
 arch/m68k/kernel/ints.c     |   11 ++---------
 arch/m68k/mvme147/config.c  |    2 +-
 arch/m68k/mvme16x/config.c  |    2 +-
 arch/m68k/sun3/sun3ints.c   |    2 +-
 9 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/m68k/apollo/dn_ints.c b/arch/m68k/apollo/dn_ints.c
index b7d0aa3..17be1e7 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -41,7 +41,7 @@ static struct irq_chip apollo_irq_chip = {
 
 void __init dn_init_IRQ(void)
 {
-	m68k_setup_user_interrupt(VEC_USER + 96, 16, NULL);
+	m68k_setup_user_interrupt(VEC_USER + 96, 16);
 	m68k_setup_irq_controller(&apollo_irq_chip, handle_fasteoi_irq,
 				  IRQ_APOLLO, 16);
 }
diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 908bcfc..8048e1b 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -135,7 +135,7 @@ static struct irq_chip atari_irq_chip = {
 
 void __init atari_init_IRQ(void)
 {
-	m68k_setup_user_interrupt(VEC_USER, NUM_ATARI_SOURCES - IRQ_USER, NULL);
+	m68k_setup_user_interrupt(VEC_USER, NUM_ATARI_SOURCES - IRQ_USER);
 	m68k_setup_irq_controller(&atari_irq_chip, handle_simple_irq, 1,
 				  NUM_ATARI_SOURCES - 1);
 
diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index 1edd950..8128647 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -86,7 +86,7 @@ static void bvme6000_get_model(char *model)
  */
 static void __init bvme6000_init_IRQ(void)
 {
-	m68k_setup_user_interrupt(VEC_USER, 192, NULL);
+	m68k_setup_user_interrupt(VEC_USER, 192);
 }
 
 void __init config_bvme6000(void)
diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index 6f28dd8..d3a8acd 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -57,9 +57,7 @@ extern unsigned int m68k_irq_startup_irq(unsigned int irq);
 extern void m68k_irq_shutdown(struct irq_data *data);
 extern void m68k_setup_auto_interrupt(void (*handler)(unsigned int,
 						      struct pt_regs *));
-extern void m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
-				      void (*handler)(unsigned int,
-						      struct pt_regs *));
+extern void m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt);
 extern void m68k_setup_irq_controller(struct irq_chip *,
 				      void (*handle)(unsigned int irq,
 						     struct irq_desc *desc),
diff --git a/arch/m68k/kernel/entry_mm.S b/arch/m68k/kernel/entry_mm.S
index f5927d0..c713f51 100644
--- a/arch/m68k/kernel/entry_mm.S
+++ b/arch/m68k/kernel/entry_mm.S
@@ -48,7 +48,7 @@
 .globl sys_fork, sys_clone, sys_vfork
 .globl ret_from_interrupt, bad_interrupt
 .globl auto_irqhandler_fixup
-.globl user_irqvec_fixup, user_irqhandler_fixup
+.globl user_irqvec_fixup
 
 .text
 ENTRY(buserr)
@@ -240,7 +240,6 @@ user_irqvec_fixup = . + 2
 
 	movel	%sp,%sp@-
 	movel	%d0,%sp@-		|  put vector # on stack
-user_irqhandler_fixup = . + 2
 	jsr	do_IRQ			|  process the IRQ
 	addql	#8,%sp			|  pop parameters off stack
 
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index e2b056b..74fefac 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -28,7 +28,6 @@
 #endif
 
 extern u32 auto_irqhandler_fixup[];
-extern u32 user_irqhandler_fixup[];
 extern u16 user_irqvec_fixup[];
 
 static int m68k_first_user_vec;
@@ -91,16 +90,12 @@ void __init m68k_setup_auto_interrupt(void (*handler)(unsigned int, struct pt_re
  * m68k_setup_user_interrupt
  * @vec: first user vector interrupt to handle
  * @cnt: number of active user vector interrupts
- * @handler: called from user vector interrupts
  *
  * setup user vector interrupts, this includes activating the specified range
  * of interrupts, only then these interrupts can be requested (note: this is
- * different from auto vector interrupts). An optional handler can be installed
- * to be called instead of the default do_IRQ(), it will be called
- * with irq numbers starting from IRQ_USER.
+ * different from auto vector interrupts).
  */
-void __init m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
-				      void (*handler)(unsigned int, struct pt_regs *))
+void __init m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt)
 {
 	int i;
 
@@ -109,8 +104,6 @@ void __init m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
 	for (i = 0; i < cnt; i++)
 		irq_set_chip(IRQ_USER + i, &user_irq_chip);
 	*user_irqvec_fixup = vec - IRQ_USER;
-	if (handler)
-		*user_irqhandler_fixup = (u32)handler;
 	flush_icache();
 }
 
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 01f2adf..5de924e 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -81,7 +81,7 @@ static void mvme147_get_model(char *model)
 
 void __init mvme147_init_IRQ(void)
 {
-	m68k_setup_user_interrupt(VEC_USER, 192, NULL);
+	m68k_setup_user_interrupt(VEC_USER, 192);
 }
 
 void __init config_mvme147(void)
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index ea9ebad..c3fb3bd 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -117,7 +117,7 @@ static void mvme16x_get_hardware_list(struct seq_file *m)
 
 static void __init mvme16x_init_IRQ (void)
 {
-	m68k_setup_user_interrupt(VEC_USER, 192, NULL);
+	m68k_setup_user_interrupt(VEC_USER, 192);
 }
 
 #define pcc2chip	((volatile u_char *)0xfff42000)
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 7eb3781..78b60f5 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -109,7 +109,7 @@ void __init sun3_init_IRQ(void)
 
 	m68k_setup_irq_controller(&sun3_irq_chip, handle_level_irq, IRQ_AUTO_1,
 				  7);
-	m68k_setup_user_interrupt(VEC_USER, 128, NULL);
+	m68k_setup_user_interrupt(VEC_USER, 128);
 
 	if (request_irq(IRQ_AUTO_5, sun3_int5, 0, "int5", NULL))
 		pr_err("Couldn't register %s interrupt\n", "int5");
-- 
1.7.0.4

