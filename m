Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab0EZUaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:30:09 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4278 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab0EZUaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:30:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5994"; a="42508730"
From: adharmap@codeaurora.org
To: tglx@linutronix.de
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       Bryan Huntsman <bryanh@quicinc.com>,
       Iliyan Malchev <malchev@google.com>, Michael Buesch <mb@bu3sch.de>,
       Bruno Premont <bonbons@linux-vserver.org>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] irq: handle private interrupt registration
Date: Wed, 26 May 2010 13:29:54 -0700
Message-Id: <1274905794-7848-1-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

The current code fails to register a handler for the same irq
without taking in to account that it could be a per cpu interrupt.
If the IRQF_PERCPU flag is set, enable the interrupt on that cpu
and return success.

Change-Id: I748b3aa08d794342ad74cbd0bb900cc599f883a6
Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---

On systems with an interrupt controller that supports
private interrupts per core, it is not possible to call 
request_irq/setup_irq from multiple cores for the same irq. This is because
the second+ invocation of __setup_irq checks if the previous
hndler had a IRQ_SHARED flag set and errors out if not. 

The current irq handling code doesnt take in to account what cpu it 
is executing on.  Usually the local interrupt controller registers are banked 
per cpu a.k.a. a cpu can enable its local interrupt by writing to its banked 
registers.

One way to get around this problem is to call the setup_irq on a single cpu 
while other cpus simply enable their private interrupts by writing to their 
banked registers

For eg. code in arch/arm/time/smp_twd.c
	/* Make sure our local interrupt controller has this enabled */
	local_irq_save(flags);
	get_irq_chip(clk->irq)->unmask(clk->irq);
	local_irq_restore(flags);

This looks like a hacky way to get local interrupts working on 
multiple cores.

The patch adds a check for PERCPU flag in __setup_irq - if an handler is 
present it simply enables that interrupt for that core and returns 0.

 arch/arm/Kconfig    |    5 +++++
 kernel/irq/manage.c |   38 +++++++++++++++++++++++++++++++-------
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fcb79c9..ceefffd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -979,6 +979,11 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
+config IRQ_PER_CPU
+	bool
+	depends on SMP
+	default y
+
 config HAVE_ARM_SCU
 	bool
 	depends on SMP
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index bde4c66..9592a2d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -683,6 +683,37 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	old_ptr = &desc->action;
 	old = *old_ptr;
 	if (old) {
+#if defined(CONFIG_IRQ_PER_CPU)
+		/* All handlers must agree on per-cpuness */
+		if ((old->flags & IRQF_PERCPU) !=
+			(new->flags & IRQF_PERCPU))
+			goto mismatch;
+
+		if (old->flags & IRQF_PERCPU) {
+			/* the chip must have been set for this interrupt*/
+			if (!(desc->status & IRQ_NOAUTOEN)) {
+				desc->depth = 0;
+				desc->status &= ~IRQ_DISABLED;
+				desc->chip->startup(irq);
+			} else
+				/* Undo nested disables: */
+				desc->depth = 1;
+
+			spin_unlock_irqrestore(&desc->lock, flags);
+			if (new->thread)
+				wake_up_process(new->thread);
+			return 0;
+		}
+#endif
+
+		/* they are the same types and same handler
+		 * perhaps it is a private cpu interrupt
+		 */
+		if (old->flags == new->flags
+			&& old->handler == new->handler)
+			setup_affinity(irq, desc);
+			return 0;
+
 		/*
 		 * Can't share interrupts unless both agree to and are
 		 * the same type (level, edge, polarity). So both flag
@@ -695,13 +726,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			goto mismatch;
 		}
 
-#if defined(CONFIG_IRQ_PER_CPU)
-		/* All handlers must agree on per-cpuness */
-		if ((old->flags & IRQF_PERCPU) !=
-		    (new->flags & IRQF_PERCPU))
-			goto mismatch;
-#endif
-
 		/* add new interrupt at end of irq queue */
 		do {
 			old_ptr = &old->next;
-- 
1.5.6.3
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum


