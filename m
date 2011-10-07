Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1JGPdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 11:33:07 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48286 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1JGPdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 11:33:06 -0400
X-IronPort-AV: E=Sophos;i="4.68,502,1312156800"; 
   d="scan'208";a="8277427"
Subject: Re: xen: IPI interrupts not resumed early enough on suspend/resume
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Fri, 7 Oct 2011 16:32:58 +0100
In-Reply-To: <alpine.LFD.2.02.1110032229250.1489@ionos>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com>
	  <alpine.LFD.2.02.1110032033530.1489@ionos>
	 <1317668908.11991.20.camel@dagon.hellion.org.uk>
	 <alpine.LFD.2.02.1110032229250.1489@ionos>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318001583.21903.355.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 22:35 +0200, Thomas Gleixner wrote:
> > > >       * Add "IRQF_RESUME_EARLY", driven from syscore_resume, and
> use it
> > > >         for these interrupts.
> > > 
> > > That's the preferable solution, as we could use that for PPC as
> well,
> > > unless we can move stuff around, so we disable stuff later.
> > 
> > OK
> 
> I guess we should go down that road then.

How does this look? I've done 100 successful migrations with it and am
running another batch as we speak.

BTW original changeset which exposed this has made it into at least the
longterm 2.6.32 release (http://bugs.debian.org/644604) so I'm cc'ing
stable@ too.

Ian.

8<--------------------------

>From bb24b9b45e071e5290a71a6445f4c156b8341699 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Mon, 3 Oct 2011 15:37:00 +0100
Subject: [PATCH] irq: add IRQF_RESUME_EARLY and resume such IRQs earlier in the process

This adds a mechanism to resume selected IRQs during syscore_resume instead of
dpm_resume_noirq.

Under Xen we need to resume IRQs associated with IPIs earlier enough that the
resched ipi is unmasked and we can therefore schedule ourselves out of the
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
 include/linux/interrupt.h |    2 ++
 kernel/irq/pm.c           |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletions(-)

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
index a103732..a3b8baa 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -59,6 +59,7 @@
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
  * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
  * IRQF_NO_THREAD - Interrupt cannot be threaded
+ * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device resume time
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -72,6 +73,7 @@
 #define IRQF_NO_SUSPEND		0x00004000
 #define IRQF_FORCE_RESUME	0x00008000
 #define IRQF_NO_THREAD		0x00010000
+#define IRQF_EARLY_RESUME	0x00020000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index f76fc00..4fbfb36 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -9,6 +9,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/syscore_ops.h>
 
 #include "internals.h"
 
@@ -40,6 +41,40 @@ void suspend_device_irqs(void)
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
 /**
+ * irq_pm_syscore_ops - enable interrupt lines early
+ *
+ * Enable all interrupt lines with %IRQF_EARLY_RESUME set
+ */
+static void irq_pm_syscore_resume(void)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	for_each_irq_desc(irq, desc) {
+		unsigned long flags;
+
+		if (!desc->action || !(desc->action->flags & IRQF_EARLY_RESUME))
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		__enable_irq(desc, irq, true);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
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
  * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
  *
  * Enable all interrupt lines previously disabled by suspend_device_irqs() that
@@ -53,6 +88,9 @@ void resume_device_irqs(void)
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
 
+		if (desc->action && desc->action->flags & IRQF_EARLY_RESUME)
+			continue;
+
 		raw_spin_lock_irqsave(&desc->lock, flags);
 		__enable_irq(desc, irq, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
-- 
1.7.2.5



