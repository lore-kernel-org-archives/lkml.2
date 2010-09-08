Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab0IHM3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:29:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:33877 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab0IHM3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:29:47 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org
Cc: peterz@infradead.org, Sven-Thorsten Dietrich <sdietrich@novell.com>,
        Michael Galbraith <MGalbraith@novell.com>,
        Jan Blunck <jblunck@suse.de>
Subject: [RFC 1/4] ftrace: Add events for tracing timer interrupts
Date: Wed,  8 Sep 2010 14:29:21 +0200
Message-Id: <1283948964-6418-2-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1283948964-6418-1-git-send-email-jblunck@suse.de>
References: <1283948964-6418-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace the execution of the timer interrupt. I did not find an argument that
makes any sense so traces look like this:

<idle>-0     [000] 181019.693546: timerirq_enter: unused=1
<idle>-0     [000] 181019.693553: timerirq_exit: unused=1

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 arch/x86/kernel/apic/apic.c |    4 ++++
 arch/x86/kernel/time.c      |    5 +++++
 include/trace/events/irq.h  |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a96489e..edd775b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -35,6 +35,8 @@
 #include <linux/smp.h>
 #include <linux/mm.h>
 
+#include <trace/events/irq.h>
+
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
 #include <asm/pgalloc.h>
@@ -823,7 +825,9 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	 */
 	exit_idle();
 	irq_enter();
+	trace_timerirq_enter(1);
 	local_apic_timer_interrupt();
+	trace_timerirq_exit(1);
 	irq_exit();
 
 	set_irq_regs(old_regs);
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index fb5cc5e..01c2395 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -14,6 +14,8 @@
 #include <linux/time.h>
 #include <linux/mca.h>
 
+#include <trace/events/irq.h>
+
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
 #include <asm/i8259.h>
@@ -63,6 +65,8 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	/* Keep nmi watchdog up to date */
 	inc_irq_stat(irq0_irqs);
 
+	trace_timerirq_enter(0);
+
 	/* Optimized out for !IO_APIC and x86_64 */
 	if (timer_ack) {
 		/*
@@ -83,6 +87,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	if (MCA_bus)
 		outb_p(inb_p(0x61)| 0x80, 0x61);
 
+	trace_timerirq_exit(0);
 	return IRQ_HANDLED;
 }
 
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 0e4cfb6..c638ab0 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -136,6 +136,44 @@ DEFINE_EVENT(softirq, softirq_exit,
 	TP_ARGS(h, vec)
 );
 
+/**
+ * timerirq_enter
+ */
+TRACE_EVENT(timerirq_enter,
+
+	TP_PROTO(int unused),
+
+	TP_ARGS(unused),
+
+	TP_STRUCT__entry(
+		__field(u64, unused)
+		),
+
+	TP_fast_assign(
+		__entry->unused = unused;
+		),
+	TP_printk("unused=%lu", (unsigned long)__entry->unused)
+);
+
+/**
+ * timerirq_exit
+ */
+TRACE_EVENT(timerirq_exit,
+
+	TP_PROTO(int unused),
+
+	TP_ARGS(unused),
+
+	TP_STRUCT__entry(
+		__field(u64, unused)
+		),
+
+	TP_fast_assign(
+		__entry->unused = unused;
+		),
+	TP_printk("unused=%lu", (unsigned long)__entry->unused)
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
-- 
1.6.4.2

