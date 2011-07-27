Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab1G0S6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:58:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53974 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1G0S6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:58:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=HgMmF88zyPMYd0isvGuCyzeSo16tssUvAeGDl9aJ/wuxjBFJLPvNzzrJuyvxBSr9G
	O4evMRKsK69RuGZenm1Bg==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v2 4/6] trace: Add tracepoints to reschedule interrupt handler
Date: Wed, 27 Jul 2011 11:57:16 -0700
Message-Id: <1311793038-15155-5-git-send-email-vnagarnaik@google.com>
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
 include/trace/events/irq.h |   45 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c             |    3 ++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index d8fab89..a2a0a49 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -339,6 +339,51 @@ DEFINE_EVENT(irq_work, irq_work_run_exit,
 	TP_ARGS(ignore)
 );
 
+DECLARE_EVENT_CLASS(reschedule_interrupt,
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
+ * reschedule_interrupt_entry - called immediately after entering the
+ * reschedule interrupt handler
+ *
+ * When used in combination with the reschedule_interrupt_exit tracepoint
+ * we can determine the reschedule interrupt handler runtime.
+ */
+DEFINE_EVENT(reschedule_interrupt, reschedule_interrupt_entry,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
+/**
+ * reschedule_interrupt_exit - called just before the reschedule interrupt
+ * handler returns
+ *
+ * When used in combination with the reschedule_interrupt_entry tracepoint
+ * we can determine the reschedule interrupt handler runtime.
+ */
+DEFINE_EVENT(reschedule_interrupt, reschedule_interrupt_exit,
+
+	TP_PROTO(unsigned int ignore),
+
+	TP_ARGS(ignore)
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..f48b5aa 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -82,6 +82,7 @@
 #include "sched_cpupri.h"
 #include "workqueue_sched.h"
 #include "sched_autogroup.h"
+#include <trace/events/irq.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
@@ -2578,6 +2579,7 @@ static void sched_ttwu_pending(void)
 	struct rq *rq = this_rq();
 	struct task_struct *list = xchg(&rq->wake_list, NULL);
 
+	trace_reschedule_interrupt_entry(0);
 	if (!list)
 		return;
 
@@ -2610,6 +2612,7 @@ void scheduler_ipi(void)
 	irq_enter();
 	sched_ttwu_do_pending(list);
 	irq_exit();
+	trace_reschedule_interrupt_exit(0);
 }
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
-- 
1.7.3.1

