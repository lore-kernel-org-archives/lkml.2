Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110Ab1J3Mvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:51:36 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:56018 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015Ab1J3Mst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 04/27] m68k/irq: Rename irq_node to irq_data
Date: Sun, 30 Oct 2011 13:48:12 +0100
Message-Id: <1319978915-10933-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it more similar to the genirq version:
  - Add an irq field

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/include/asm/irq.h |    9 +++++----
 arch/m68k/kernel/ints.c     |   21 +++++++++++----------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index bfc521f..3cb037c 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -75,10 +75,11 @@ struct pt_regs;
  * This structure is used to chain together the ISRs for a particular
  * interrupt source (if it supports chaining).
  */
-struct irq_node {
+struct irq_data {
+	unsigned int	irq;
 	irqreturn_t	(*handler)(int, void *);
 	void		*dev_id;
-	struct irq_node *next;
+	struct irq_data *next;
 	unsigned long	flags;
 	const char	*devname;
 };
@@ -105,9 +106,9 @@ extern unsigned int m68k_irq_startup(unsigned int);
 extern void m68k_irq_shutdown(unsigned int);
 
 /*
- * This function returns a new struct irq_node
+ * This function returns a new struct irq_data
  */
-extern struct irq_node *new_irq_node(void);
+extern struct irq_data *new_irq_node(void);
 
 extern void m68k_setup_auto_interrupt(void (*handler)(unsigned int, struct pt_regs *));
 extern void m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 9de8eb4..8877932 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -51,7 +51,7 @@ extern u32 user_irqhandler_fixup[];
 extern u16 user_irqvec_fixup[];
 
 /* table for system interrupt handlers */
-static struct irq_node *irq_list[NR_IRQS];
+static struct irq_data *irq_list[NR_IRQS];
 static struct irq_chip *irq_chip[NR_IRQS];
 static int irq_depth[NR_IRQS];
 
@@ -70,7 +70,7 @@ static struct irq_chip user_irq_chip = {
 };
 
 #define NUM_IRQ_NODES 100
-static struct irq_node nodes[NUM_IRQ_NODES];
+static struct irq_data nodes[NUM_IRQ_NODES];
 
 /*
  * void init_IRQ(void)
@@ -160,9 +160,9 @@ void m68k_setup_irq_chip(struct irq_chip *contr, unsigned int irq,
 		irq_chip[irq + i] = contr;
 }
 
-struct irq_node *new_irq_node(void)
+struct irq_data *new_irq_node(void)
 {
-	struct irq_node *node;
+	struct irq_data *node;
 	short i;
 
 	for (node = nodes, i = NUM_IRQ_NODES-1; i >= 0; node++, i--) {
@@ -176,10 +176,10 @@ struct irq_node *new_irq_node(void)
 	return NULL;
 }
 
-int setup_irq(unsigned int irq, struct irq_node *node)
+int setup_irq(unsigned int irq, struct irq_data *node)
 {
 	struct irq_chip *contr;
-	struct irq_node **prev;
+	struct irq_data **prev;
 	unsigned long flags;
 
 	if (irq >= NR_IRQS || !(contr = irq_chip[irq])) {
@@ -219,13 +219,14 @@ int request_irq(unsigned int irq,
 		irq_handler_t handler,
 		unsigned long flags, const char *devname, void *dev_id)
 {
-	struct irq_node *node;
+	struct irq_data *node;
 	int res;
 
 	node = new_irq_node();
 	if (!node)
 		return -ENOMEM;
 
+	node->irq     = irq;
 	node->handler = handler;
 	node->flags   = flags;
 	node->dev_id  = dev_id;
@@ -243,7 +244,7 @@ EXPORT_SYMBOL(request_irq);
 void free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_chip *contr;
-	struct irq_node **p, *node;
+	struct irq_data **p, *node;
 	unsigned long flags;
 
 	if (irq >= NR_IRQS || !(contr = irq_chip[irq])) {
@@ -386,7 +387,7 @@ EXPORT_SYMBOL(irq_canonicalize);
 
 asmlinkage void m68k_handle_int(unsigned int irq)
 {
-	struct irq_node *node;
+	struct irq_data *node;
 	kstat_cpu(0).irqs[irq]++;
 	node = irq_list[irq];
 	do {
@@ -412,7 +413,7 @@ asmlinkage void handle_badint(struct pt_regs *regs)
 int show_interrupts(struct seq_file *p, void *v)
 {
 	struct irq_chip *contr;
-	struct irq_node *node;
+	struct irq_data *node;
 	int i = *(loff_t *) v;
 
 	/* autovector interrupts */
-- 
1.7.0.4

