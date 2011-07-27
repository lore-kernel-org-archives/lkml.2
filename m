Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1G0S6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:58:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31881 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab1G0S6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:58:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=jCzfPo5HCmqGEXme5Ie34W3E1NbL+rbPnZtQb3To0rFV8yo3wTPlR4SDj4jZO2orv
	6mR9HMzNufE18dtkfPJbA==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v2 5/6] trace: Add tracepoints to call function interrupt handlers
Date: Wed, 27 Jul 2011 11:57:17 -0700
Message-Id: <1311793038-15155-6-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracepoints to call function and call function single interrupt
handlers.

This is a part of overall effort to trace all the interrupts happening
in a system. This shows how the interrupts are interacting with other
events and what time is spent in kernel space versus user space.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 include/trace/events/irq.h |   73 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/smp.c               |    6 +++-
 2 files changed, 78 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index a2a0a49..5e4f731 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -384,6 +384,79 @@ DEFINE_EVENT(reschedule_interrupt, reschedule_interrupt_exit,
 	TP_ARGS(ignore)
 );
 
+DECLARE_EVENT_CLASS(call_function_ipi,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	ignore	)
+	),
+
+	TP_fast_assign(
+		__entry->ignore = ignore;
+	),
+
+	TP_printk("%u", __entry->ignore)
+);
+
+/**
+ * call_function_ipi_entry - called immediately after entering the
+ * call function interrupt handler
+ *
+ * When used in combination with the call_function_ipi_exit tracepoint
+ * we can determine the call function interrupt handler runtime.
+ */
+DEFINE_EVENT(call_function_ipi, call_function_ipi_entry,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * call_function_ipi_exit - called just before the call function interrupt
+ * handler returns
+ *
+ * When used in combination with the call_function_ipi_entry tracepoint
+ * we can determine the call function interrupt handler runtime.
+ */
+DEFINE_EVENT(call_function_ipi, call_function_ipi_exit,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * call_function_single_ipi_entry - called immediately after entering the
+ * call function single interrupt handler
+ *
+ * When used in combination with the call_function_single_ipi_exit tracepoint
+ * we can determine the call function single interrupt handler runtime.
+ */
+DEFINE_EVENT(call_function_ipi, call_function_single_ipi_entry,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * call_function_single_ipi_exit - called just before the call function single
+ * interrupt handler returns
+ *
+ * When used in combination with the call_function_single_ipi_entry tracepoint
+ * we can determine the call function single interrupt handler runtime.
+ */
+DEFINE_EVENT(call_function_ipi, call_function_single_ipi_exit,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
diff --git a/kernel/smp.c b/kernel/smp.c
index fb67dfa..4ea6769 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <trace/events/irq.h>
 
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 static struct {
@@ -172,6 +173,7 @@ void generic_smp_call_function_interrupt(void)
 	struct call_function_data *data;
 	int cpu = smp_processor_id();
 
+	trace_call_function_ipi_entry(0);
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
@@ -239,7 +241,7 @@ void generic_smp_call_function_interrupt(void)
 
 		csd_unlock(&data->csd);
 	}
-
+	trace_call_function_ipi_exit(0);
 }
 
 /*
@@ -252,6 +254,7 @@ void generic_smp_call_function_single_interrupt(void)
 	unsigned int data_flags;
 	LIST_HEAD(list);
 
+	trace_call_function_single_ipi_entry(0);
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
@@ -282,6 +285,7 @@ void generic_smp_call_function_single_interrupt(void)
 		if (data_flags & CSD_FLAG_LOCK)
 			csd_unlock(data);
 	}
+	trace_call_function_single_ipi_exit(0);
 }
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_data, csd_data);
-- 
1.7.3.1

