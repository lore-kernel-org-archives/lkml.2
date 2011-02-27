Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1B0QBs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:01:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:58549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab1B0QBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:01:45 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 08/17] unicore32: modify function names and parameters for irq_chips
Date: Sun, 27 Feb 2011 15:59:36 +0000
Message-Id: <31797b3a96e9074225c8e455169576882354bb08.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

  -- by advice with Thomas Gleixner

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig      |    1 +
 arch/unicore32/kernel/irq.c |   82 +++++++++++++++++++++---------------------
 2 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 90835c9..7f65018 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -10,6 +10,7 @@ config UNICORE32
 	select HAVE_KERNEL_LZMA
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select ARCH_WANT_FRAME_POINTERS
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
diff --git a/arch/unicore32/kernel/irq.c b/arch/unicore32/kernel/irq.c
index 7c211f5..38e3089 100644
--- a/arch/unicore32/kernel/irq.c
+++ b/arch/unicore32/kernel/irq.c
@@ -42,14 +42,14 @@ static int GPIO_IRQ_mask = 0;
 
 #define GPIO_MASK(irq)		(1 << (irq - IRQ_GPIO0))
 
-static int puv3_gpio_type(unsigned int irq, unsigned int type)
+static int puv3_gpio_type(struct irq_data *d, unsigned int type)
 {
 	unsigned int mask;
 
-	if (irq < IRQ_GPIOHIGH)
-		mask = 1 << irq;
+	if (d->irq < IRQ_GPIOHIGH)
+		mask = 1 << d->irq;
 	else
-		mask = GPIO_MASK(irq);
+		mask = GPIO_MASK(d->irq);
 
 	if (type == IRQ_TYPE_PROBE) {
 		if ((GPIO_IRQ_rising_edge | GPIO_IRQ_falling_edge) & mask)
@@ -75,37 +75,37 @@ static int puv3_gpio_type(unsigned int irq, unsigned int type)
 /*
  * GPIO IRQs must be acknowledged.  This is for IRQs from 0 to 7.
  */
-static void puv3_low_gpio_ack(unsigned int irq)
+static void puv3_low_gpio_ack(struct irq_data *d)
 {
-	GPIO_GEDR = (1 << irq);
+	GPIO_GEDR = (1 << d->irq);
 }
 
-static void puv3_low_gpio_mask(unsigned int irq)
+static void puv3_low_gpio_mask(struct irq_data *d)
 {
-	INTC_ICMR &= ~(1 << irq);
+	INTC_ICMR &= ~(1 << d->irq);
 }
 
-static void puv3_low_gpio_unmask(unsigned int irq)
+static void puv3_low_gpio_unmask(struct irq_data *d)
 {
-	INTC_ICMR |= 1 << irq;
+	INTC_ICMR |= 1 << d->irq;
 }
 
-static int puv3_low_gpio_wake(unsigned int irq, unsigned int on)
+static int puv3_low_gpio_wake(struct irq_data *d, unsigned int on)
 {
 	if (on)
-		PM_PWER |= 1 << irq;
+		PM_PWER |= 1 << d->irq;
 	else
-		PM_PWER &= ~(1 << irq);
+		PM_PWER &= ~(1 << d->irq);
 	return 0;
 }
 
 static struct irq_chip puv3_low_gpio_chip = {
 	.name		= "GPIO-low",
-	.ack		= puv3_low_gpio_ack,
-	.mask		= puv3_low_gpio_mask,
-	.unmask		= puv3_low_gpio_unmask,
-	.set_type	= puv3_gpio_type,
-	.set_wake	= puv3_low_gpio_wake,
+	.irq_ack	= puv3_low_gpio_ack,
+	.irq_mask	= puv3_low_gpio_mask,
+	.irq_unmask	= puv3_low_gpio_unmask,
+	.irq_set_type	= puv3_gpio_type,
+	.irq_set_wake	= puv3_low_gpio_wake,
 };
 
 /*
@@ -142,16 +142,16 @@ puv3_gpio_handler(unsigned int irq, struct irq_desc *desc)
  * In addition, the IRQs are all collected up into one bit in the
  * interrupt controller registers.
  */
-static void puv3_high_gpio_ack(unsigned int irq)
+static void puv3_high_gpio_ack(struct irq_data *d)
 {
-	unsigned int mask = GPIO_MASK(irq);
+	unsigned int mask = GPIO_MASK(d->irq);
 
 	GPIO_GEDR = mask;
 }
 
-static void puv3_high_gpio_mask(unsigned int irq)
+static void puv3_high_gpio_mask(struct irq_data *d)
 {
-	unsigned int mask = GPIO_MASK(irq);
+	unsigned int mask = GPIO_MASK(d->irq);
 
 	GPIO_IRQ_mask &= ~mask;
 
@@ -159,9 +159,9 @@ static void puv3_high_gpio_mask(unsigned int irq)
 	GPIO_GFER &= ~mask;
 }
 
-static void puv3_high_gpio_unmask(unsigned int irq)
+static void puv3_high_gpio_unmask(struct irq_data *d)
 {
-	unsigned int mask = GPIO_MASK(irq);
+	unsigned int mask = GPIO_MASK(d->irq);
 
 	GPIO_IRQ_mask |= mask;
 
@@ -169,7 +169,7 @@ static void puv3_high_gpio_unmask(unsigned int irq)
 	GPIO_GFER = GPIO_IRQ_falling_edge & GPIO_IRQ_mask;
 }
 
-static int puv3_high_gpio_wake(unsigned int irq, unsigned int on)
+static int puv3_high_gpio_wake(struct irq_data *d, unsigned int on)
 {
 	if (on)
 		PM_PWER |= PM_PWER_GPIOHIGH;
@@ -180,33 +180,33 @@ static int puv3_high_gpio_wake(unsigned int irq, unsigned int on)
 
 static struct irq_chip puv3_high_gpio_chip = {
 	.name		= "GPIO-high",
-	.ack		= puv3_high_gpio_ack,
-	.mask		= puv3_high_gpio_mask,
-	.unmask		= puv3_high_gpio_unmask,
-	.set_type	= puv3_gpio_type,
-	.set_wake	= puv3_high_gpio_wake,
+	.irq_ack	= puv3_high_gpio_ack,
+	.irq_mask	= puv3_high_gpio_mask,
+	.irq_unmask	= puv3_high_gpio_unmask,
+	.irq_set_type	= puv3_gpio_type,
+	.irq_set_wake	= puv3_high_gpio_wake,
 };
 
 /*
  * We don't need to ACK IRQs on the PKUnity unless they're GPIOs
  * this is for internal IRQs i.e. from 8 to 31.
  */
-static void puv3_mask_irq(unsigned int irq)
+static void puv3_mask_irq(struct irq_data *d)
 {
-	INTC_ICMR &= ~(1 << irq);
+	INTC_ICMR &= ~(1 << d->irq);
 }
 
-static void puv3_unmask_irq(unsigned int irq)
+static void puv3_unmask_irq(struct irq_data *d)
 {
-	INTC_ICMR |= (1 << irq);
+	INTC_ICMR |= (1 << d->irq);
 }
 
 /*
  * Apart form GPIOs, only the RTC alarm can be a wakeup event.
  */
-static int puv3_set_wake(unsigned int irq, unsigned int on)
+static int puv3_set_wake(struct irq_data *d, unsigned int on)
 {
-	if (irq == IRQ_RTCAlarm) {
+	if (d->irq == IRQ_RTCAlarm) {
 		if (on)
 			PM_PWER |= PM_PWER_RTC;
 		else
@@ -218,10 +218,10 @@ static int puv3_set_wake(unsigned int irq, unsigned int on)
 
 static struct irq_chip puv3_normal_chip = {
 	.name		= "PKUnity-v3",
-	.ack		= puv3_mask_irq,
-	.mask		= puv3_mask_irq,
-	.unmask		= puv3_unmask_irq,
-	.set_wake	= puv3_set_wake,
+	.irq_ack	= puv3_mask_irq,
+	.irq_mask	= puv3_mask_irq,
+	.irq_unmask	= puv3_unmask_irq,
+	.irq_set_wake	= puv3_set_wake,
 };
 
 static struct resource irq_resource = {
@@ -383,7 +383,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%3d: ", i);
 		for_each_present_cpu(cpu)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
-		seq_printf(p, " %10s", desc->chip->name ? : "-");
+		seq_printf(p, " %10s", desc->irq_data.chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
-- 
1.7.4.1

