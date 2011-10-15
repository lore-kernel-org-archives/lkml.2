Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab1JOVOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 17:14:20 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:59254 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1JOVOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 17:14:19 -0400
X-IronPort-AV: E=Sophos;i="4.69,351,1315180800"; 
   d="scan'208";a="8408469"
Subject: Re: [Xen-devel] Re: xen: IPI interrupts not resumed early enough
 on suspend/resume
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
In-Reply-To: <1318598637.21903.889.camel@zakaz.uk.xensource.com>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.02.1110032033530.1489@ionos>
	 <1317668908.11991.20.camel@dagon.hellion.org.uk>
	 <alpine.LFD.2.02.1110032229250.1489@ionos>
	 <1318001583.21903.355.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.02.1110071822160.3240@ionos>
	 <1318251990.21903.433.camel@zakaz.uk.xensource.com>
	 <1318598637.21903.889.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Sat, 15 Oct 2011 22:14:13 +0100
Message-ID: <1318713254.11016.52.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 14:23 +0100, Ian Campbell wrote:
> Ping? The original issue has made it into longterm-2.6.32.y and then
> onto Debian (bug #644604) so people keep asking me about it...

Sorry, the previous version had a warning in it (was missing the return
type for resume_irqs), fixed up version follows.

I noticed that the backport to longterm 2.6.32 won't work since syscore
isn't available back then. I think one approach for the backport would
be to call irq_pm_syscore_resume() directly from sysdev_resume(), does
that sound sensible?

Ian.

8<------------------------------

>From cac68962d009cd916cc66b4d870630adc49c1e1e Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Mon, 3 Oct 2011 15:37:00 +0100
Subject: [PATCH] irq: add IRQF_RESUME_EARLY and resume such IRQs earlier in the process
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
[v2: refactor common code in irq_pm_syscore_resume and resume_device_irqs]
[v3: resume_irqs returns void, "fixing warning: return type defaults to ‘int’"]
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
index f76fc00..15e53b1 100644
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
-- 
1.7.2.5



