Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686Ab1KCBhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:37:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933661Ab1KCBhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:58 2011
Message-Id: <20111102221458.645704243@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ian Campbell <ian.campbell@citrix.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [093/107] genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit 9bab0b7fbaceec47d32db51cd9e59c82fb071f5a upstream

This adds a mechanism to resume selected IRQs during syscore_resume
instead of dpm_resume_noirq.

Under Xen we need to resume IRQs associated with IPIs early enough
that the resched IPI is unmasked and we can therefore schedule
ourselves out of the stop_machine where the suspend/resume takes
place.

This issue was introduced by 676dc3cf5bc3 "xen: Use IRQF_FORCE_RESUME".

Back ported to 2.6.32 (which lacks syscore support) by calling the relavant
resume function directly from sysdev_resume).

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Cc: xen-devel <xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1318713254.11016.52.camel@dagon.hellion.org.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/sys.c        |    6 ++++++
 drivers/xen/events.c      |    2 +-
 include/linux/interrupt.h |    5 +++++
 kernel/irq/pm.c           |   35 ++++++++++++++++++++++++++++-------
 4 files changed, 40 insertions(+), 8 deletions(-)

--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -471,6 +471,12 @@ int sysdev_resume(void)
 {
 	struct sysdev_class *cls;
 
+	/*
+	 * Called from syscore in mainline but called directly here
+	 * since syscore does not exist in this tree.
+	 */
+	irq_pm_syscore_resume();
+
 	WARN_ONCE(!irqs_disabled(),
 		"Interrupts enabled while resuming system devices\n");
 
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -536,7 +536,7 @@ int bind_ipi_to_irqhandler(enum ipi_vect
 	if (irq < 0)
 		return irq;
 
-	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME;
+	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME | IRQF_EARLY_RESUME;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -54,6 +54,8 @@
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
  * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
+ * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
+ *                resume time.
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -66,6 +68,7 @@
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
 #define IRQF_FORCE_RESUME	0x00008000
+#define IRQF_EARLY_RESUME	0x00020000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
@@ -196,6 +199,7 @@ extern void enable_irq(unsigned int irq)
 #ifdef CONFIG_GENERIC_HARDIRQS
 extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
+extern void irq_pm_syscore_resume(void);
 #ifdef CONFIG_PM_SLEEP
 extern int check_wakeup_irqs(void);
 #else
@@ -204,6 +208,7 @@ static inline int check_wakeup_irqs(void
 #else
 static inline void suspend_device_irqs(void) { };
 static inline void resume_device_irqs(void) { };
+static inline void irq_pm_syscore_resume(void) { };
 static inline int check_wakeup_irqs(void) { return 0; }
 #endif
 
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -39,25 +39,46 @@ void suspend_device_irqs(void)
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
-/**
- * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
- *
- * Enable all interrupt lines previously disabled by suspend_device_irqs() that
- * have the IRQ_SUSPENDED flag set.
- */
-void resume_device_irqs(void)
+static void resume_irqs(bool want_early)
 {
 	struct irq_desc *desc;
 	int irq;
 
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
+		bool is_early = desc->action &&
+			desc->action->flags & IRQF_EARLY_RESUME;
+
+		if (is_early != want_early)
+			continue;
 
 		spin_lock_irqsave(&desc->lock, flags);
 		__enable_irq(desc, irq, true);
 		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
+
+/**
+ * irq_pm_syscore_ops - enable interrupt lines early
+ *
+ * Enable all interrupt lines with %IRQF_EARLY_RESUME set.
+ */
+void irq_pm_syscore_resume(void)
+{
+	resume_irqs(true);
+}
+
+/**
+ * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
+ *
+ * Enable all non-%IRQF_EARLY_RESUME interrupt lines previously
+ * disabled by suspend_device_irqs() that have the IRQS_SUSPENDED flag
+ * set as well as those with %IRQF_FORCE_RESUME.
+ */
+void resume_device_irqs(void)
+{
+	resume_irqs(false);
+}
 EXPORT_SYMBOL_GPL(resume_device_irqs);
 
 /**


