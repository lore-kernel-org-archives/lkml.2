Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab1GNVj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:39:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25690 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab1GNVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:38:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Sf8RzDCAcm3LQfpga52kr1MFYdMSrzHuPNaF0TNHJ6nj/JYHrmrwKbbAfkwZHgfl9
	PAygxaVogcH7kX0qo5PGw==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 5/6] trace: Add tracepoints to call function interrupt handlers
Date: Thu, 14 Jul 2011 14:38:14 -0700
Message-Id: <1310679495-29104-6-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracepoints to call function and call function single interrupt
handlers.

This is a part of overall effort to trace all the interrupts happening
in a system to figure out what time is spent in kernel space versus user
space.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 include/trace/events/irq.h |   73 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/smp.c               |    5 +++
 2 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index a2a0a49..40b19f4 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -384,6 +384,79 @@ DEFINE_EVENT(reschedule_interrupt, reschedule_interrupt_exit,
 	TP_ARGS(ignore)
 );
 
+DECLARE_EVENT_CLASS(call_function,
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
+ * call_function_entry - called immediately after entering the
+ * call function interrupt handler
+ *
+ * When used in combination with the call_function_exit tracepoint
+ * we can determine the call function interrupt handler runtime.
+ */
+DEFINE_EVENT(call_function, call_function_entry,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * call_function_exit - called just before the call function interrupt
+ * handler returns
+ *
+ * When used in combination with the call_function_entry tracepoint
+ * we can determine the call function interrupt handler runtime.
+ */
+DEFINE_EVENT(call_function, call_function_exit,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * call_function_single_entry - called immediately after entering the
+ * call function single interrupt handler
+ *
+ * When used in combination with the call_function_single_exit tracepoint
+ * we can determine the call function single interrupt handler runtime.
+ */
+DEFINE_EVENT(call_function, call_function_single_entry,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * call_function_single_exit - called just before the call function single
+ * interrupt handler returns
+ *
+ * When used in combination with the call_function_single_entry tracepoint
+ * we can determine the call function single interrupt handler runtime.
+ */
+DEFINE_EVENT(call_function, call_function_single_exit,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
diff --git a/kernel/smp.c b/kernel/smp.c
index fb67dfa..3c4ce30 100644
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
 
+	trace_call_function_entry(0);
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
@@ -240,6 +242,7 @@ void generic_smp_call_function_interrupt(void)
 		csd_unlock(&data->csd);
 	}
 
+	trace_call_function_exit(0);
 }
 
 /*
@@ -252,6 +255,7 @@ void generic_smp_call_function_single_interrupt(void)
 	unsigned int data_flags;
 	LIST_HEAD(list);
 
+	trace_call_function_single_entry(0);
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
@@ -282,6 +286,7 @@ void generic_smp_call_function_single_interrupt(void)
 		if (data_flags & CSD_FLAG_LOCK)
 			csd_unlock(data);
 	}
+	trace_call_function_single_exit(0);
 }
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_data, csd_data);
-- 
1.7.3.1

