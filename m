Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141Ab1IKMEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:04:11 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:53543 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094Ab1IKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 07/28] m68k/irq: Switch irq_chip methods to "struct irq_data *data"
Date: Sun, 11 Sep 2011 13:59:33 +0200
Message-Id: <1315742394-16036-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/amiga/amiints.c   |   16 ++++++++--------
 arch/m68k/amiga/cia.c       |   25 ++++++++++++++-----------
 arch/m68k/apollo/dn_ints.c  |    8 ++++++--
 arch/m68k/atari/ataints.c   |   30 ++++++++++++++++++++++--------
 arch/m68k/include/asm/irq.h |   13 +++++++------
 arch/m68k/kernel/ints.c     |   23 +++++++++++++++--------
 arch/m68k/mac/macints.c     |   14 ++++++++++++--
 arch/m68k/q40/q40ints.c     |   28 +++++++++++++++++-----------
 arch/m68k/sun3/sun3ints.c   |   14 ++++++++++++--
 9 files changed, 113 insertions(+), 58 deletions(-)

diff --git a/arch/m68k/amiga/amiints.c b/arch/m68k/amiga/amiints.c
index 320c5d0..09a695b 100644
--- a/arch/m68k/amiga/amiints.c
+++ b/arch/m68k/amiga/amiints.c
@@ -45,8 +45,8 @@
 #include <asm/amigaints.h>
 #include <asm/amipcmcia.h>
 
-static void amiga_enable_irq(unsigned int irq);
-static void amiga_disable_irq(unsigned int irq);
+static void amiga_irq_enable(struct irq_data *data);
+static void amiga_irq_disable(struct irq_data *data);
 static irqreturn_t ami_int1(int irq, void *dev_id);
 static irqreturn_t ami_int3(int irq, void *dev_id);
 static irqreturn_t ami_int4(int irq, void *dev_id);
@@ -54,8 +54,8 @@ static irqreturn_t ami_int5(int irq, void *dev_id);
 
 static struct irq_chip amiga_irq_chip = {
 	.name		= "amiga",
-	.irq_enable	= amiga_enable_irq,
-	.irq_disable	= amiga_disable_irq,
+	.irq_enable	= amiga_irq_enable,
+	.irq_disable	= amiga_irq_disable,
 };
 
 /*
@@ -102,14 +102,14 @@ void __init amiga_init_IRQ(void)
  * internal data, that may not be changed by the interrupt at the same time.
  */
 
-static void amiga_enable_irq(unsigned int irq)
+static void amiga_irq_enable(struct irq_data *data)
 {
-	amiga_custom.intena = IF_SETCLR | (1 << (irq - IRQ_USER));
+	amiga_custom.intena = IF_SETCLR | (1 << (data->irq - IRQ_USER));
 }
 
-static void amiga_disable_irq(unsigned int irq)
+static void amiga_irq_disable(struct irq_data *data)
 {
-	amiga_custom.intena = 1 << (irq - IRQ_USER);
+	amiga_custom.intena = 1 << (data->irq - IRQ_USER);
 }
 
 /*
diff --git a/arch/m68k/amiga/cia.c b/arch/m68k/amiga/cia.c
index 637ef53..b04b453 100644
--- a/arch/m68k/amiga/cia.c
+++ b/arch/m68k/amiga/cia.c
@@ -98,8 +98,9 @@ static irqreturn_t cia_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void cia_enable_irq(unsigned int irq)
+static void cia_irq_enable(struct irq_data *data)
 {
+	unsigned int irq = data->irq;
 	unsigned char mask;
 
 	if (irq >= IRQ_AMIGA_CIAB) {
@@ -113,8 +114,10 @@ static void cia_enable_irq(unsigned int irq)
 	}
 }
 
-static void cia_disable_irq(unsigned int irq)
+static void cia_irq_disable(struct irq_data *data)
 {
+	unsigned int irq = data->irq;
+
 	if (irq >= IRQ_AMIGA_CIAB)
 		cia_able_irq(&ciab_base, 1 << (irq - IRQ_AMIGA_CIAB));
 	else
@@ -123,8 +126,8 @@ static void cia_disable_irq(unsigned int irq)
 
 static struct irq_chip cia_irq_chip = {
 	.name		= "cia",
-	.irq_enable	= cia_enable_irq,
-	.irq_disable	= cia_disable_irq,
+	.irq_enable	= cia_irq_enable,
+	.irq_disable	= cia_irq_disable,
 };
 
 /*
@@ -133,9 +136,9 @@ static struct irq_chip cia_irq_chip = {
  * into this chain.
  */
 
-static void auto_enable_irq(unsigned int irq)
+static void auto_irq_enable(struct irq_data *data)
 {
-	switch (irq) {
+	switch (data->irq) {
 	case IRQ_AUTO_2:
 		amiga_custom.intena = IF_SETCLR | IF_PORTS;
 		break;
@@ -145,9 +148,9 @@ static void auto_enable_irq(unsigned int irq)
 	}
 }
 
-static void auto_disable_irq(unsigned int irq)
+static void auto_irq_disable(struct irq_data *data)
 {
-	switch (irq) {
+	switch (data->irq) {
 	case IRQ_AUTO_2:
 		amiga_custom.intena = IF_PORTS;
 		break;
@@ -159,8 +162,8 @@ static void auto_disable_irq(unsigned int irq)
 
 static struct irq_chip auto_irq_chip = {
 	.name		= "auto",
-	.irq_enable	= auto_enable_irq,
-	.irq_disable	= auto_disable_irq,
+	.irq_enable	= auto_irq_enable,
+	.irq_disable	= auto_irq_disable,
 };
 
 void __init cia_init_IRQ(struct ciabase *base)
@@ -173,7 +176,7 @@ void __init cia_init_IRQ(struct ciabase *base)
 
 	/* override auto int and install CIA handler */
 	m68k_setup_irq_chip(&auto_irq_chip, base->handler_irq, 1);
-	m68k_irq_startup(base->handler_irq);
+	m68k_irq_startup_irq(base->handler_irq);
 	if (request_irq(base->handler_irq, cia_handler, IRQF_SHARED,
 			base->name, base))
 		pr_err("Couldn't register %s interrupt\n", base->name);
diff --git a/arch/m68k/apollo/dn_ints.c b/arch/m68k/apollo/dn_ints.c
index d6e8f33..2bdab49 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -12,8 +12,10 @@ void dn_process_int(unsigned int irq, struct pt_regs *fp)
 	*(volatile unsigned char *)(picb)=0x20;
 }
 
-unsigned int apollo_irq_startup(unsigned int irq)
+unsigned int apollo_irq_startup(struct irq_data *data)
 {
+	unsigned int irq = data->irq;
+
 	if (irq < 8)
 		*(volatile unsigned char *)(pica+1) &= ~(1 << irq);
 	else
@@ -21,8 +23,10 @@ unsigned int apollo_irq_startup(unsigned int irq)
 	return 0;
 }
 
-void apollo_irq_shutdown(unsigned int irq)
+void apollo_irq_shutdown(struct irq_data *data)
 {
+	unsigned int irq = data->irq;
+
 	if (irq < 8)
 		*(volatile unsigned char *)(pica+1) |= (1 << irq);
 	else
diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 3e1be40..de0cb42 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -318,30 +318,44 @@ __ALIGN_STR "\n\t"
 
 extern void atari_microwire_cmd(int cmd);
 
-static unsigned int atari_startup_irq(unsigned int irq)
+static unsigned int atari_irq_startup(struct irq_data *data)
 {
-	m68k_irq_startup(irq);
+	unsigned int irq = data->irq;
+
+	m68k_irq_startup(data);
 	atari_turnon_irq(irq);
 	atari_enable_irq(irq);
 	return 0;
 }
 
-static void atari_shutdown_irq(unsigned int irq)
+static void atari_irq_shutdown(struct irq_data *data)
 {
+	unsigned int irq = data->irq;
+
 	atari_disable_irq(irq);
 	atari_turnoff_irq(irq);
-	m68k_irq_shutdown(irq);
+	m68k_irq_shutdown(data);
 
 	if (irq == IRQ_AUTO_4)
 	    vectors[VEC_INT4] = falcon_hblhandler;
 }
 
+static void atari_irq_enable(struct irq_data *data)
+{
+	atari_enable_irq(data->irq);
+}
+
+static void atari_irq_disable(struct irq_data *data)
+{
+	atari_disable_irq(data->irq);
+}
+
 static struct irq_chip atari_irq_chip = {
 	.name		= "atari",
-	.irq_startup	= atari_startup_irq,
-	.irq_shutdown	= atari_shutdown_irq,
-	.irq_enable	= atari_enable_irq,
-	.irq_disable	= atari_disable_irq,
+	.irq_startup	= atari_irq_startup,
+	.irq_shutdown	= atari_irq_shutdown,
+	.irq_enable	= atari_irq_enable,
+	.irq_disable	= atari_irq_disable,
 };
 
 /*
diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index 3cb037c..423f064 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -96,14 +96,15 @@ struct irq_handler {
 
 struct irq_chip {
 	const char *name;
-	unsigned int (*irq_startup)(unsigned int irq);
-	void (*irq_shutdown)(unsigned int irq);
-	void (*irq_enable)(unsigned int irq);
-	void (*irq_disable)(unsigned int irq);
+	unsigned int (*irq_startup)(struct irq_data *data);
+	void (*irq_shutdown)(struct irq_data *data);
+	void (*irq_enable)(struct irq_data *data);
+	void (*irq_disable)(struct irq_data *data);
 };
 
-extern unsigned int m68k_irq_startup(unsigned int);
-extern void m68k_irq_shutdown(unsigned int);
+extern unsigned int m68k_irq_startup(struct irq_data *data);
+extern unsigned int m68k_irq_startup_irq(unsigned int irq);
+extern void m68k_irq_shutdown(struct irq_data *data);
 
 /*
  * This function returns a new struct irq_data
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 8877932..404d832 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -203,9 +203,9 @@ int setup_irq(unsigned int irq, struct irq_data *node)
 
 	if (!irq_list[irq]) {
 		if (contr->irq_startup)
-			contr->irq_startup(irq);
+			contr->irq_startup(node);
 		else
-			contr->irq_enable(irq);
+			contr->irq_enable(node);
 	}
 	node->next = NULL;
 	*prev = node;
@@ -270,9 +270,9 @@ void free_irq(unsigned int irq, void *dev_id)
 
 	if (!irq_list[irq]) {
 		if (contr->irq_shutdown)
-			contr->irq_shutdown(irq);
+			contr->irq_shutdown(node);
 		else
-			contr->irq_disable(irq);
+			contr->irq_disable(node);
 	}
 
 	local_irq_restore(flags);
@@ -295,7 +295,7 @@ void enable_irq(unsigned int irq)
 	if (irq_depth[irq]) {
 		if (!--irq_depth[irq]) {
 			if (contr->irq_enable)
-				contr->irq_enable(irq);
+				contr->irq_enable(irq_list[irq]);
 		}
 	} else
 		WARN_ON(1);
@@ -318,7 +318,7 @@ void disable_irq(unsigned int irq)
 	local_irq_save(flags);
 	if (!irq_depth[irq]++) {
 		if (contr->irq_disable)
-			contr->irq_disable(irq);
+			contr->irq_disable(irq_list[irq]);
 	}
 	local_irq_restore(flags);
 }
@@ -329,7 +329,7 @@ void disable_irq_nosync(unsigned int irq) __attribute__((alias("disable_irq")));
 
 EXPORT_SYMBOL(disable_irq_nosync);
 
-unsigned int m68k_irq_startup(unsigned int irq)
+unsigned int m68k_irq_startup_irq(unsigned int irq)
 {
 	if (irq <= IRQ_AUTO_7)
 		vectors[VEC_SPUR + irq] = auto_inthandler;
@@ -338,8 +338,15 @@ unsigned int m68k_irq_startup(unsigned int irq)
 	return 0;
 }
 
-void m68k_irq_shutdown(unsigned int irq)
+unsigned int m68k_irq_startup(struct irq_data *data)
 {
+	return m68k_irq_startup_irq(data->irq);
+}
+
+void m68k_irq_shutdown(struct irq_data *data)
+{
+	unsigned int irq = data->irq;
+
 	if (irq <= IRQ_AUTO_7)
 		vectors[VEC_SPUR + irq] = bad_inthandler;
 	else
diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
index ffa1b3f..3cee6d2 100644
--- a/arch/m68k/mac/macints.c
+++ b/arch/m68k/mac/macints.c
@@ -193,10 +193,20 @@ irqreturn_t mac_debug_handler(int, void *);
 void mac_enable_irq(unsigned int irq);
 void mac_disable_irq(unsigned int irq);
 
+static void mac_irq_enable(struct irq_data *data)
+{
+	mac_enable_irq(data->irq);
+}
+
+static void mac_irq_disable(struct irq_data *data)
+{
+	mac_disable_irq(data->irq);
+}
+
 static struct irq_chip mac_irq_chip = {
 	.name		= "mac",
-	.irq_enable	= mac_enable_irq,
-	.irq_disable	= mac_disable_irq,
+	.irq_enable	= mac_irq_enable,
+	.irq_disable	= mac_irq_disable,
 };
 
 void __init mac_init_IRQ(void)
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index fa05a03..cb245f9 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -35,14 +35,16 @@
 */
 
 static void q40_irq_handler(unsigned int, struct pt_regs *fp);
-static void q40_enable_irq(unsigned int);
-static void q40_disable_irq(unsigned int);
+static void q40_irq_enable(struct irq_data *data);
+static void q40_irq_disable(struct irq_data *data);
 
 unsigned short q40_ablecount[35];
 unsigned short q40_state[35];
 
-static unsigned int q40_irq_startup(unsigned int irq)
+static unsigned int q40_irq_startup(struct irq_data *data)
 {
+	unsigned int irq = data->irq;
+
 	/* test for ISA ints not implemented by HW */
 	switch (irq) {
 	case 1: case 2: case 8: case 9:
@@ -53,7 +55,7 @@ static unsigned int q40_irq_startup(unsigned int irq)
 	return 0;
 }
 
-static void q40_irq_shutdown(unsigned int irq)
+static void q40_irq_shutdown(struct irq_data *data)
 {
 }
 
@@ -61,8 +63,8 @@ static struct irq_chip q40_irq_chip = {
 	.name		= "q40",
 	.irq_startup	= q40_irq_startup,
 	.irq_shutdown	= q40_irq_shutdown,
-	.irq_enable	= q40_enable_irq,
-	.irq_disable	= q40_disable_irq,
+	.irq_enable	= q40_irq_enable,
+	.irq_disable	= q40_irq_disable,
 };
 
 /*
@@ -85,8 +87,8 @@ void __init q40_init_IRQ(void)
 	/* setup handler for ISA ints */
 	m68k_setup_auto_interrupt(q40_irq_handler);
 
-	m68k_irq_startup(IRQ_AUTO_2);
-	m68k_irq_startup(IRQ_AUTO_4);
+	m68k_irq_startup_irq(IRQ_AUTO_2);
+	m68k_irq_startup_irq(IRQ_AUTO_4);
 
 	/* now enable some ints.. */
 	master_outb(1, EXT_ENABLE_REG);  /* ISA IRQ 5-15 */
@@ -292,20 +294,24 @@ static void q40_irq_handler(unsigned int irq, struct pt_regs *fp)
 	return;
 }
 
-void q40_enable_irq(unsigned int irq)
+void q40_irq_enable(struct irq_data *data)
 {
+	unsigned int irq = data->irq;
+
 	if (irq >= 5 && irq <= 15) {
 		mext_disabled--;
 		if (mext_disabled > 0)
-			printk("q40_enable_irq : nested disable/enable\n");
+			printk("q40_irq_enable : nested disable/enable\n");
 		if (mext_disabled == 0)
 			master_outb(1, EXT_ENABLE_REG);
 	}
 }
 
 
-void q40_disable_irq(unsigned int irq)
+void q40_irq_disable(struct irq_data *data)
 {
+	unsigned int irq = data->irq;
+
 	/* disable ISA iqs : only do something if the driver has been
 	 * verified to be Q40 "compatible" - right now IDE, NE2K
 	 * Any driver should not attempt to sleep across disable_irq !!
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 97fa9ed..5d45e00 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -86,12 +86,22 @@ static void sun3_inthandle(unsigned int irq, struct pt_regs *fp)
 	__m68k_handle_int(irq, fp);
 }
 
+static void sun3_irq_enable(struct irq_data *data)
+{
+    sun3_enable_irq(data->irq);
+};
+
+static void sun3_irq_disable(struct irq_data *data)
+{
+    sun3_disable_irq(data->irq);
+};
+
 static struct irq_chip sun3_irq_chip = {
 	.name		= "sun3",
 	.irq_startup	= m68k_irq_startup,
 	.irq_shutdown	= m68k_irq_shutdown,
-	.irq_enable	= sun3_enable_irq,
-	.irq_disable	= sun3_disable_irq,
+	.irq_enable	= sun3_irq_enable,
+	.irq_disable	= sun3_irq_disable,
 };
 
 void __init sun3_init_IRQ(void)
-- 
1.7.0.4

