Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1KIMX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:23:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53396 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab1KIMXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:23:23 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.48+drm33.20
Date: Wed,  9 Nov 2011 13:23:18 +0100
Message-Id: <1320841398-8297-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.48+drm33.20 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release contains patches from upstream 2.6.32.48, but dropped any patches
to the DRM subsystem.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
or
  git://kernel.ubuntu.com/smb/linux-2.6.32.y-drm33.z.git

and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary
or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* Revert "genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier"
* Revert "ASoC: wm8940: Properly set codec->dapm.bias_level"
* Revert "powerpc/mpic: Fix problem that affinity is not updated"
* Linux 2.6.32.48

 Makefile                   |    2 +-
 arch/powerpc/sysdev/mpic.c |   17 ++++++++++++-----
 drivers/base/sys.c         |    6 ------
 drivers/xen/events.c       |    2 +-
 include/linux/interrupt.h  |    5 -----
 kernel/irq/pm.c            |   35 +++++++----------------------------
 sound/soc/codecs/wm8940.c  |    2 --
 7 files changed, 21 insertions(+), 48 deletions(-)

diff --git a/Makefile b/Makefile
index cdd0c95..23da129 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .47+drm33.20
+EXTRAVERSION = .48+drm33.20
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

