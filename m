Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1JJNGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:06:33 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:11787 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab1JJNGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:06:32 -0400
X-IronPort-AV: E=Sophos;i="4.68,517,1312156800"; 
   d="scan'208";a="8302885"
Subject: Re: xen: IPI interrupts not resumed early enough on suspend/resume
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 10 Oct 2011 14:06:30 +0100
In-Reply-To: <alpine.LFD.2.02.1110071822160.3240@ionos>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.02.1110032033530.1489@ionos>
	 <1317668908.11991.20.camel@dagon.hellion.org.uk>
	 <alpine.LFD.2.02.1110032229250.1489@ionos>
	 <1318001583.21903.355.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.02.1110071822160.3240@ionos>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318251990.21903.433.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 17:29 +0100, Thomas Gleixner wrote:
> On Fri, 7 Oct 2011, Ian Campbell wrote:
> > On Mon, 2011-10-03 at 22:35 +0200, Thomas Gleixner wrote:
> >  /**
> > + * irq_pm_syscore_ops - enable interrupt lines early
> > + *
> > + * Enable all interrupt lines with %IRQF_EARLY_RESUME set
> > + */
> > +static void irq_pm_syscore_resume(void)
> > +{
> > +	struct irq_desc *desc;
> > +	int irq;
> > +
> > +	for_each_irq_desc(irq, desc) {
> > +		unsigned long flags;
> > +
> > +		if (!desc->action || !(desc->action->flags & IRQF_EARLY_RESUME))
> > +			continue;
> > +
> > +		raw_spin_lock_irqsave(&desc->lock, flags);
> > +		__enable_irq(desc, irq, true);
> > +		raw_spin_unlock_irqrestore(&desc->lock, flags);
> > +	}
> > +}
> 
> Come on, this is a full copy of resume_device_irqs(). What about
> having a common function with an (bool early) argument and call it
> from both syscore and resume_device?

Yes, that's a good idea.

>From dc8a8329f3e97f30e1290c898c816250aa7e8957 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Mon, 3 Oct 2011 15:37:00 +0100
Subject: [PATCH] irq: add IRQF_RESUME_EARLY and resume such IRQs earlier in the process

This adds a mechanism to resume selected IRQs during syscore_resume instead of
dpm_resume_noirq.

Under Xen we need to resume IRQs associated with IPIs early enough that the
resched IPI is unmasked and we can therefore schedule ourselves out of the
stop_machine where the suspend/resume takes place.

This issue was introduced by 676dc3cf5bc3 "xen: Use IRQF_FORCE_RESUME".

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel <xen-devel@lists.xensource.com>
Cc: stable@kernel.org (at least to 2.6.32.y)
---
 drivers/xen/events.c      |    2 +-
 include/linux/interrupt.h |    3 ++
 kernel/irq/pm.c           |   48 ++++++++++++++++++++++++++++++++++++++------
 3 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 7523719..44490de 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1021,7 +1021,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 	if (irq < 0)
 		return irq;
 
-	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME;
+	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME | IRQF_EARLY_RESUME;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a103732..f51a81b 100644
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
 
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index f76fc00..86bcd79 100644
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
+static resume_irqs(bool want_early)
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
-- 
1.7.2.5



