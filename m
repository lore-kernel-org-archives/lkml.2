Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935987Ab1KJDks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:40:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965258Ab1KJDkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:40:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:53 2011
Message-Id: <20111109213153.300523313@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ian Campbell <ian.campbell@citrix.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [111/264] genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit 9bab0b7fbaceec47d32db51cd9e59c82fb071f5a upstream.

This adds a mechanism to resume selected IRQs during syscore_resume
instead of dpm_resume_noirq.

Under Xen we need to resume IRQs associated with IPIs early enough
that the resched IPI is unmasked and we can therefore schedule
ourselves out of the stop_machine where the suspend/resume takes
place.

This issue was introduced by 676dc3cf5bc3 "xen: Use IRQF_FORCE_RESUME".

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Cc: xen-devel <xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1318713254.11016.52.camel@dagon.hellion.org.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/events.c      |    2 -
 include/linux/interrupt.h |    3 ++
 kernel/irq/pm.c           |   48 +++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 45 insertions(+), 8 deletions(-)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1021,7 +1021,7 @@ int bind_ipi_to_irqhandler(enum ipi_vect
 	if (irq < 0)
 		return irq;
 
-	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME;
+	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME | IRQF_EARLY_RESUME;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -59,6 +59,8 @@
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
  * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
  * IRQF_NO_THREAD - Interrupt cannot be threaded
+ * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
+ *                resume time.
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -72,6 +74,7 @@
 #define IRQF_NO_SUSPEND		0x00004000
 #define IRQF_FORCE_RESUME	0x00008000
 #define IRQF_NO_THREAD		0x00010000
+#define IRQF_EARLY_RESUME	0x00020000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -9,6 +9,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/syscore_ops.h>
 
 #include "internals.h"
 
@@ -39,25 +40,58 @@ void suspend_device_irqs(void)
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
-/**
- * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
- *
- * Enable all interrupt lines previously disabled by suspend_device_irqs() that
- * have the IRQS_SUSPENDED flag set.
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
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
 		__enable_irq(desc, irq, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
+
+/**
+ * irq_pm_syscore_ops - enable interrupt lines early
+ *
+ * Enable all interrupt lines with %IRQF_EARLY_RESUME set.
+ */
+static void irq_pm_syscore_resume(void)
+{
+	resume_irqs(true);
+}
+
+static struct syscore_ops irq_pm_syscore_ops = {
+	.resume		= irq_pm_syscore_resume,
+};
+
+static int __init irq_pm_init_ops(void)
+{
+	register_syscore_ops(&irq_pm_syscore_ops);
+	return 0;
+}
+
+device_initcall(irq_pm_init_ops);
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


