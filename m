Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab1GNVit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:38:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25665 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab1GNVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:38:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=g679+LOSlxDezbwoAEUtRqzxZWR13LgCNeflgb+9TWKQahtXa8NWEJc9anYcYxOr4
	w6TCsIm0FGpKu1UcIUboQ==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 1/6] trace,x86: Add tracepoint to x86 timer interrupt handler
Date: Thu, 14 Jul 2011 14:38:10 -0700
Message-Id: <1310679495-29104-2-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 timer interrupt handler is the only handler not traced in the
irq/irq_handler_{entry|exit} trace events.

Add tracepoints to the interrupt handler to trace it.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 arch/x86/kernel/time.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 00cbb27..dcaf19a 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -51,6 +51,13 @@ unsigned long profile_pc(struct pt_regs *regs)
 }
 EXPORT_SYMBOL(profile_pc);
 
+static irqreturn_t timer_interrupt(int irq, void *dev_id);
+static struct irqaction irq0  = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
+	.name = "timer"
+};
+
 /*
  * Default timer interrupt handler for PIT/HPET
  */
@@ -59,7 +66,9 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	/* Keep nmi watchdog up to date */
 	inc_irq_stat(irq0_irqs);
 
+	trace_irq_handler_entry(irq, &irq0);
 	global_clock_event->event_handler(global_clock_event);
+	trace_irq_handler_exit(irq, &irq0, 1);
 
 	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
 	if (MCA_bus)
@@ -68,12 +77,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction irq0  = {
-	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
-	.name = "timer"
-};
-
 void __init setup_default_timer_irq(void)
 {
 	setup_irq(0, &irq0);
-- 
1.7.3.1

