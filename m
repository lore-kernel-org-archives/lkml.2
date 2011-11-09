Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab1KIAJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:09:59 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48586 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932999Ab1KIAJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:09:57 -0500
X-Sasl-enc: R3x8TB5C7ad+YEPVJk1qKIUGm2labyBifCP8TmoFtPo6 1320797396
Date: Tue, 8 Nov 2011 16:09:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.48
Message-ID: <20111109000942.GB26052@kroah.com>
References: <20111109000925.GA26052@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109000925.GA26052@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 87c02aa..400a175 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .47
+EXTRAVERSION = .48
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index b54d581..30c44e6 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -567,10 +567,12 @@ static void __init mpic_scan_ht_pics(struct mpic *mpic)
 #endif /* CONFIG_MPIC_U3_HT_IRQS */
 
 #ifdef CONFIG_SMP
-static int irq_choose_cpu(const cpumask_t *mask)
+static int irq_choose_cpu(unsigned int virt_irq)
 {
+	cpumask_t mask;
 	int cpuid;
 
+	cpumask_copy(&mask, irq_desc[virt_irq].affinity);
 	if (cpus_equal(mask, CPU_MASK_ALL)) {
 		static int irq_rover;
 		static DEFINE_SPINLOCK(irq_rover_lock);
@@ -592,15 +594,20 @@ static int irq_choose_cpu(const cpumask_t *mask)
 
 		spin_unlock_irqrestore(&irq_rover_lock, flags);
 	} else {
-		cpuid = cpumask_first_and(mask, cpu_online_mask);
-		if (cpuid >= nr_cpu_ids)
+		cpumask_t tmp;
+
+		cpus_and(tmp, cpu_online_map, mask);
+
+		if (cpus_empty(tmp))
 			goto do_round_robin;
+
+		cpuid = first_cpu(tmp);
 	}
 
 	return get_hard_smp_processor_id(cpuid);
 }
 #else
-static int irq_choose_cpu(const cpumask_t *mask)
+static int irq_choose_cpu(unsigned int virt_irq)
 {
 	return hard_smp_processor_id();
 }
@@ -809,7 +816,7 @@ int mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 	unsigned int src = mpic_irq_to_hw(irq);
 
 	if (mpic->flags & MPIC_SINGLE_DEST_CPU) {
-		int cpuid = irq_choose_cpu(cpumask);
+		int cpuid = irq_choose_cpu(irq);
 
 		mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION), 1 << cpuid);
 	} else {
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 3f202f7..0d90390 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -471,12 +471,6 @@ int sysdev_resume(void)
 {
 	struct sysdev_class *cls;
 
-	/*
-	 * Called from syscore in mainline but called directly here
-	 * since syscore does not exist in this tree.
-	 */
-	irq_pm_syscore_resume();
-
 	WARN_ONCE(!irqs_disabled(),
 		"Interrupts enabled while resuming system devices\n");
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 15ed43e..009ca4e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -536,7 +536,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 	if (irq < 0)
 		return irq;
 
-	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME | IRQF_EARLY_RESUME;
+	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c7e1aa5..4528f29 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -54,8 +54,6 @@
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
  * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
- * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
- *                resume time.
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -68,7 +66,6 @@
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
 #define IRQF_FORCE_RESUME	0x00008000
-#define IRQF_EARLY_RESUME	0x00020000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
@@ -199,7 +196,6 @@ extern void enable_irq(unsigned int irq);
 #ifdef CONFIG_GENERIC_HARDIRQS
 extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
-extern void irq_pm_syscore_resume(void);
 #ifdef CONFIG_PM_SLEEP
 extern int check_wakeup_irqs(void);
 #else
@@ -208,7 +204,6 @@ static inline int check_wakeup_irqs(void) { return 0; }
 #else
 static inline void suspend_device_irqs(void) { };
 static inline void resume_device_irqs(void) { };
-static inline void irq_pm_syscore_resume(void) { };
 static inline int check_wakeup_irqs(void) { return 0; }
 #endif
 
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index b1fc3dd..0067abb 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -39,46 +39,25 @@ void suspend_device_irqs(void)
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
-static void resume_irqs(bool want_early)
+/**
+ * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
+ *
+ * Enable all interrupt lines previously disabled by suspend_device_irqs() that
+ * have the IRQ_SUSPENDED flag set.
+ */
+void resume_device_irqs(void)
 {
 	struct irq_desc *desc;
 	int irq;
 
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
-		bool is_early = desc->action &&
-			desc->action->flags & IRQF_EARLY_RESUME;
-
-		if (is_early != want_early)
-			continue;
 
 		spin_lock_irqsave(&desc->lock, flags);
 		__enable_irq(desc, irq, true);
 		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
-
-/**
- * irq_pm_syscore_ops - enable interrupt lines early
- *
- * Enable all interrupt lines with %IRQF_EARLY_RESUME set.
- */
-void irq_pm_syscore_resume(void)
-{
-	resume_irqs(true);
-}
-
-/**
- * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
- *
- * Enable all non-%IRQF_EARLY_RESUME interrupt lines previously
- * disabled by suspend_device_irqs() that have the IRQS_SUSPENDED flag
- * set as well as those with %IRQF_FORCE_RESUME.
- */
-void resume_device_irqs(void)
-{
-	resume_irqs(false);
-}
 EXPORT_SYMBOL_GPL(resume_device_irqs);
 
 /**
diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index c9510a5..63bc2ae 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -473,8 +473,6 @@ static int wm8940_set_bias_level(struct snd_soc_codec *codec,
 		break;
 	}
 
-	codec->dapm.bias_level = level;
-
 	return ret;
 }
 
