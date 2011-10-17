Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1JQNzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:55:17 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:29010 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1JQNzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:55:12 -0400
X-IronPort-AV: E=Sophos;i="4.69,359,1315180800"; 
   d="scan'208";a="8425373"
Subject: Re: [Xen-devel] Re: xen: IPI interrupts not resumed early enough on
 suspend/resume
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>, <stable@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 17 Oct 2011 14:55:10 +0100
In-Reply-To: <alpine.LFD.2.02.1110171049440.3240@ionos>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.02.1110032033530.1489@ionos>
	 <1317668908.11991.20.camel@dagon.hellion.org.uk>
	 <alpine.LFD.2.02.1110032229250.1489@ionos>
	 <1318001583.21903.355.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.02.1110071822160.3240@ionos>
	 <1318251990.21903.433.camel@zakaz.uk.xensource.com>
	 <1318598637.21903.889.camel@zakaz.uk.xensource.com>
	 <1318713254.11016.52.camel@dagon.hellion.org.uk>
	 <alpine.LFD.2.02.1110171049440.3240@ionos>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318859710.16132.15.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, 2011-10-17 at 09:51 +0100, Thomas Gleixner wrote:
> On Sat, 15 Oct 2011, Ian Campbell wrote:
> > I noticed that the backport to longterm 2.6.32 won't work since syscore
> > isn't available back then. I think one approach for the backport would
> > be to call irq_pm_syscore_resume() directly from sysdev_resume(), does
> > that sound sensible?
> 
> I think so. [...]

The following is a backport of 9bab0b7fbaceec47d32db51cd9e59c82fb071f5a
(currently in tip.git#irq/core tree and queued for 3.2) to 2.6.32 as
described above.

8<-------------------------------------------------

>From 0e3acef83438e502ca5a1985cc5231c325ca73e2 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Mon, 3 Oct 2011 15:37:00 +0100
Subject: [PATCH] genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier

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
Cc: stable@kernel.org (at least to 2.6.32.y)
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/base/sys.c        |    6 ++++++
 drivers/xen/events.c      |    2 +-
 include/linux/interrupt.h |    5 +++++
 kernel/irq/pm.c           |   35 ++++++++++++++++++++++++++++-------
 4 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 0d90390..3f202f7 100644
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
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 009ca4e..15ed43e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -536,7 +536,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 	if (irq < 0)
 		return irq;
 
-	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME;
+	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME | IRQF_EARLY_RESUME;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 4528f29..c7e1aa5 100644
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
 
@@ -196,6 +199,7 @@ extern void enable_irq(unsigned int irq);
 #ifdef CONFIG_GENERIC_HARDIRQS
 extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
+extern void irq_pm_syscore_resume(void);
 #ifdef CONFIG_PM_SLEEP
 extern int check_wakeup_irqs(void);
 #else
@@ -204,6 +208,7 @@ static inline int check_wakeup_irqs(void) { return 0; }
 #else
 static inline void suspend_device_irqs(void) { };
 static inline void resume_device_irqs(void) { };
+static inline void irq_pm_syscore_resume(void) { };
 static inline int check_wakeup_irqs(void) { return 0; }
 #endif
 
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 0067abb..b1fc3dd 100644
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
-- 
1.7.2.5



