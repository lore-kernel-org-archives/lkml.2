Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1G0S6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:58:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31867 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1G0S6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:58:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=mpzsRhk9mLSk4+H2sbx8qKoOIeR+wG9/VTIqclNHm6vR2JQwuWdgh8Uf7VUb5hm36
	+Rm7s3MtqQQdti+52E5kg==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v2 3/6] trace: Add tracepoints to IRQ work run handler
Date: Wed, 27 Jul 2011 11:57:15 -0700
Message-Id: <1311793038-15155-4-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a part of overall effort to trace all the interrupts happening
in a system. This shows how the interrupts are interacting with other
events and what time is spent in kernel space versus user space.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 include/trace/events/irq.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq_work.c          |    3 +++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index e6e72e0..d8fab89 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -295,6 +295,50 @@ DEFINE_EVENT(timer_interrupt, timer_nohz_exit,
 	TP_ARGS(ignore)
 );
 
+DECLARE_EVENT_CLASS(irq_work,
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
+ * irq_work_run_entry - called immediately after entering the irq work
+ * handler
+ *
+ * When used in combination with the irq_work_run_exit tracepoint
+ * we can determine the irq work handler runtime.
+ */
+DEFINE_EVENT(irq_work, irq_work_run_entry,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * irq_work_run_exit - called just before the irq work handler returns
+ *
+ * When used in combination with the irq_work_run_entry tracepoint
+ * we can determine the irq work handler runtime.
+ */
+DEFINE_EVENT(irq_work, irq_work_run_exit,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index c58fa7d..39473b2 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/irq_work.h>
 #include <linux/hardirq.h>
+#include <trace/events/irq.h>
 
 /*
  * An entry can be in one of four states:
@@ -122,6 +123,7 @@ void irq_work_run(void)
 {
 	struct irq_work *list;
 
+	trace_irq_work_run_entry(0);
 	if (this_cpu_read(irq_work_list) == NULL)
 		return;
 
@@ -149,6 +151,7 @@ void irq_work_run(void)
 			      next_flags(NULL, IRQ_WORK_BUSY),
 			      NULL);
 	}
+	trace_irq_work_run_exit(0);
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
 
-- 
1.7.3.1

