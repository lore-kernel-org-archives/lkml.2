Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab0I3XQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:16:59 -0400
Received: from www.tglx.de ([62.245.132.106]:52696 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab0I3XQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:16:55 -0400
Message-Id: <20100930221740.835901506@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 24/47] x86: i8259: Convert to new irq_chip functions
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-convert-i8259.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/i8259.h   |    2 +
 arch/x86/kernel/apic/io_apic.c |   20 ++++++-------
 arch/x86/kernel/apic/nmi.c     |    2 -
 arch/x86/kernel/i8259.c        |   63 ++++++++++++++++++++---------------------
 arch/x86/kernel/smpboot.c      |    4 +-
 5 files changed, 47 insertions(+), 44 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/i8259.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/i8259.h
+++ linux-2.6-tip/arch/x86/include/asm/i8259.h
@@ -55,6 +55,8 @@ extern struct irq_chip i8259A_chip;
 struct legacy_pic {
 	int nr_legacy_irqs;
 	struct irq_chip *chip;
+	void (*mask)(unsigned int irq);
+	void (*unmask)(unsigned int irq);
 	void (*mask_all)(void);
 	void (*restore_mask)(void);
 	void (*init)(int auto_eoi);
Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -1474,7 +1474,7 @@ static void setup_IO_APIC_irq(int apic_i
 
 	ioapic_register_intr(irq, desc, trigger);
 	if (irq < legacy_pic->nr_legacy_irqs)
-		legacy_pic->chip->mask(irq);
+		legacy_pic->mask(irq);
 
 	ioapic_write_entry(apic_id, pin, entry);
 }
@@ -2248,7 +2248,7 @@ static unsigned int startup_ioapic_irq(u
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	if (irq < legacy_pic->nr_legacy_irqs) {
-		legacy_pic->chip->mask(irq);
+		legacy_pic->mask(irq);
 		if (legacy_pic->irq_pending(irq))
 			was_pending = 1;
 	}
@@ -2943,7 +2943,7 @@ static inline void __init check_timer(vo
 	/*
 	 * get/set the timer IRQ vector:
 	 */
-	legacy_pic->chip->mask(0);
+	legacy_pic->mask(0);
 	assign_irq_vector(0, cfg, apic->target_cpus());
 
 	/*
@@ -3015,7 +3015,7 @@ static inline void __init check_timer(vo
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
-				legacy_pic->chip->unmask(0);
+				legacy_pic->unmask(0);
 			}
 			if (disable_timer_pin_1 > 0)
 				clear_IO_APIC_pin(0, pin1);
@@ -3038,14 +3038,14 @@ static inline void __init check_timer(vo
 		 */
 		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
-		legacy_pic->chip->unmask(0);
+		legacy_pic->unmask(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
 			timer_through_8259 = 1;
 			if (nmi_watchdog == NMI_IO_APIC) {
-				legacy_pic->chip->mask(0);
+				legacy_pic->mask(0);
 				setup_nmi();
-				legacy_pic->chip->unmask(0);
+				legacy_pic->unmask(0);
 			}
 			goto out;
 		}
@@ -3053,7 +3053,7 @@ static inline void __init check_timer(vo
 		 * Cleanup, just in case ...
 		 */
 		local_irq_disable();
-		legacy_pic->chip->mask(0);
+		legacy_pic->mask(0);
 		clear_IO_APIC_pin(apic2, pin2);
 		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
 	}
@@ -3072,14 +3072,14 @@ static inline void __init check_timer(vo
 
 	lapic_register_intr(0, desc);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
-	legacy_pic->chip->unmask(0);
+	legacy_pic->unmask(0);
 
 	if (timer_irq_works()) {
 		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
 		goto out;
 	}
 	local_irq_disable();
-	legacy_pic->chip->mask(0);
+	legacy_pic->mask(0);
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
 
Index: linux-2.6-tip/arch/x86/kernel/apic/nmi.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/nmi.c
+++ linux-2.6-tip/arch/x86/kernel/apic/nmi.c
@@ -178,7 +178,7 @@ int __init check_nmi_watchdog(void)
 error:
 	if (nmi_watchdog == NMI_IO_APIC) {
 		if (!timer_through_8259)
-			legacy_pic->chip->mask(0);
+			legacy_pic->mask(0);
 		on_each_cpu(__acpi_nmi_disable, NULL, 1);
 	}
 
Index: linux-2.6-tip/arch/x86/kernel/i8259.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/i8259.c
+++ linux-2.6-tip/arch/x86/kernel/i8259.c
@@ -29,24 +29,10 @@
  * plus some generic x86 specific things if generic specifics makes
  * any sense at all.
  */
+static void init_8259A(int auto_eoi);
 
 static int i8259A_auto_eoi;
 DEFINE_RAW_SPINLOCK(i8259A_lock);
-static void mask_and_ack_8259A(unsigned int);
-static void mask_8259A(void);
-static void unmask_8259A(void);
-static void disable_8259A_irq(unsigned int irq);
-static void enable_8259A_irq(unsigned int irq);
-static void init_8259A(int auto_eoi);
-static int i8259A_irq_pending(unsigned int irq);
-
-struct irq_chip i8259A_chip = {
-	.name		= "XT-PIC",
-	.mask		= disable_8259A_irq,
-	.disable	= disable_8259A_irq,
-	.unmask		= enable_8259A_irq,
-	.mask_ack	= mask_and_ack_8259A,
-};
 
 /*
  * 8259A PIC functions to handle ISA devices:
@@ -68,7 +54,7 @@ unsigned int cached_irq_mask = 0xffff;
  */
 unsigned long io_apic_irqs;
 
-static void disable_8259A_irq(unsigned int irq)
+static void mask_8259A_irq(unsigned int irq)
 {
 	unsigned int mask = 1 << irq;
 	unsigned long flags;
@@ -82,7 +68,12 @@ static void disable_8259A_irq(unsigned i
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-static void enable_8259A_irq(unsigned int irq)
+static void disable_8259A_irq(struct irq_data *data)
+{
+	mask_8259A_irq(data->irq);
+}
+
+static void unmask_8259A_irq(unsigned int irq)
 {
 	unsigned int mask = ~(1 << irq);
 	unsigned long flags;
@@ -96,6 +87,11 @@ static void enable_8259A_irq(unsigned in
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
+static void enable_8259A_irq(struct irq_data *data)
+{
+	unmask_8259A_irq(data->irq);
+}
+
 static int i8259A_irq_pending(unsigned int irq)
 {
 	unsigned int mask = 1<<irq;
@@ -117,7 +113,7 @@ static void make_8259A_irq(unsigned int 
 	disable_irq_nosync(irq);
 	io_apic_irqs &= ~(1<<irq);
 	set_irq_chip_and_handler_name(irq, &i8259A_chip, handle_level_irq,
-				      "XT");
+				      i8259A_chip.name);
 	enable_irq(irq);
 }
 
@@ -150,8 +146,9 @@ static inline int i8259A_irq_real(unsign
  * first, _then_ send the EOI, and the order of EOI
  * to the two 8259s is important!
  */
-static void mask_and_ack_8259A(unsigned int irq)
+static void mask_and_ack_8259A(struct irq_data *data)
 {
+	unsigned int irq = data->irq;
 	unsigned int irqmask = 1 << irq;
 	unsigned long flags;
 
@@ -223,6 +220,14 @@ spurious_8259A_irq:
 	}
 }
 
+struct irq_chip i8259A_chip = {
+	.name		= "XT-PIC",
+	.irq_mask	= disable_8259A_irq,
+	.irq_disable	= disable_8259A_irq,
+	.irq_unmask	= enable_8259A_irq,
+	.irq_mask_ack	= mask_and_ack_8259A,
+};
+
 static char irq_trigger[2];
 /**
  * ELCR registers (0x4d0, 0x4d1) control edge/level of IRQ
@@ -342,9 +347,9 @@ static void init_8259A(int auto_eoi)
 		 * In AEOI mode we just have to mask the interrupt
 		 * when acking.
 		 */
-		i8259A_chip.mask_ack = disable_8259A_irq;
+		i8259A_chip.irq_mask_ack = disable_8259A_irq;
 	else
-		i8259A_chip.mask_ack = mask_and_ack_8259A;
+		i8259A_chip.irq_mask_ack = mask_and_ack_8259A;
 
 	udelay(100);		/* wait for 8259A to initialize */
 
@@ -363,14 +368,6 @@ static void init_8259A(int auto_eoi)
 static void legacy_pic_noop(void) { };
 static void legacy_pic_uint_noop(unsigned int unused) { };
 static void legacy_pic_int_noop(int unused) { };
-
-static struct irq_chip dummy_pic_chip  = {
-	.name = "dummy pic",
-	.mask = legacy_pic_uint_noop,
-	.unmask = legacy_pic_uint_noop,
-	.disable = legacy_pic_uint_noop,
-	.mask_ack = legacy_pic_uint_noop,
-};
 static int legacy_pic_irq_pending_noop(unsigned int irq)
 {
 	return 0;
@@ -378,7 +375,9 @@ static int legacy_pic_irq_pending_noop(u
 
 struct legacy_pic null_legacy_pic = {
 	.nr_legacy_irqs = 0,
-	.chip = &dummy_pic_chip,
+	.chip = &dummy_irq_chip,
+	.mask = legacy_pic_uint_noop,
+	.unmask = legacy_pic_uint_noop,
 	.mask_all = legacy_pic_noop,
 	.restore_mask = legacy_pic_noop,
 	.init = legacy_pic_int_noop,
@@ -389,7 +388,9 @@ struct legacy_pic null_legacy_pic = {
 struct legacy_pic default_legacy_pic = {
 	.nr_legacy_irqs = NR_IRQS_LEGACY,
 	.chip  = &i8259A_chip,
-	.mask_all  = mask_8259A,
+	.mask = mask_8259A_irq,
+	.unmask = unmask_8259A_irq,
+	.mask_all = mask_8259A,
 	.restore_mask = unmask_8259A,
 	.init = init_8259A,
 	.irq_pending = i8259A_irq_pending,
Index: linux-2.6-tip/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6-tip/arch/x86/kernel/smpboot.c
@@ -324,9 +324,9 @@ notrace static void __cpuinit start_seco
 	check_tsc_sync_target();
 
 	if (nmi_watchdog == NMI_IO_APIC) {
-		legacy_pic->chip->mask(0);
+		legacy_pic->mask(0);
 		enable_NMI_through_LVT0();
-		legacy_pic->chip->unmask(0);
+		legacy_pic->unmask(0);
 	}
 
 	/* This must be done before setting cpu_online_mask */


