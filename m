Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408Ab0IHIem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:34:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:55607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab0IHIei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:34:38 -0400
Date: Wed, 8 Sep 2010 08:33:56 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: mingo@redhat.com, mathieu.desnoyers@efficios.com,
        sanagi.koki@jp.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
        nhorman@tuxdriver.com, scott.a.mcmillan@intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        davem@davemloft.net, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@redhat.com, mathieu.desnoyers@efficios.com,
        sanagi.koki@jp.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
        nhorman@tuxdriver.com, scott.a.mcmillan@intel.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        davem@davemloft.net, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <4C724298.4050509@jp.fujitsu.com>
References: <4C724298.4050509@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] irq: Add tracepoint to softirq_raise
Message-ID: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
Git-Commit-ID: 2bf2160d8805de64308e2e7c3cd97813cb58ed2f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 08:33:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bf2160d8805de64308e2e7c3cd97813cb58ed2f
Gitweb:     http://git.kernel.org/tip/2bf2160d8805de64308e2e7c3cd97813cb58ed2f
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Mon, 23 Aug 2010 18:42:48 +0900
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 7 Sep 2010 17:49:34 +0200

irq: Add tracepoint to softirq_raise

Add a tracepoint for tracing when softirq action is raised.

This and the existing tracepoints complete softirq's tracepoints:
softirq_raise, softirq_entry and softirq_exit.

And when this tracepoint is used in combination with
the softirq_entry tracepoint we can determine
the softirq raise latency.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>
Cc: Kaneshige Kenji <kaneshige.kenji@jp.fujitsu.com>
Cc: Izumo Taku <izumi.taku@jp.fujitsu.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Scott Mcmillan <scott.a.mcmillan@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <4C724298.4050509@jp.fujitsu.com>
[ factorize softirq events with DECLARE_EVENT_CLASS ]
Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/interrupt.h  |    8 +++++++-
 include/trace/events/irq.h |   26 ++++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a0384a4..531495d 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -18,6 +18,7 @@
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
+#include <trace/events/irq.h>
 
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
@@ -407,7 +408,12 @@ asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
-#define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
+static inline void __raise_softirq_irqoff(unsigned int nr)
+{
+	trace_softirq_raise((struct softirq_action *)(unsigned long)nr, NULL);
+	or_softirq_pending(1UL << nr);
+}
+
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
 extern void wakeup_softirqd(void);
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 0e4cfb6..6fa7cba 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -5,7 +5,9 @@
 #define _TRACE_IRQ_H
 
 #include <linux/tracepoint.h>
-#include <linux/interrupt.h>
+
+struct irqaction;
+struct softirq_action;
 
 #define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
 #define show_softirq_name(val)				\
@@ -93,7 +95,10 @@ DECLARE_EVENT_CLASS(softirq,
 	),
 
 	TP_fast_assign(
-		__entry->vec = (int)(h - vec);
+		if (vec)
+			__entry->vec = (int)(h - vec);
+		else
+			__entry->vec = (int)(long)h;
 	),
 
 	TP_printk("vec=%d [action=%s]", __entry->vec,
@@ -136,6 +141,23 @@ DEFINE_EVENT(softirq, softirq_exit,
 	TP_ARGS(h, vec)
 );
 
+/**
+ * softirq_raise - called immediately when a softirq is raised
+ * @h: pointer to struct softirq_action
+ * @vec: pointer to first struct softirq_action in softirq_vec array
+ *
+ * The @h parameter contains a pointer to the softirq vector number which is
+ * raised. @vec is NULL and it means @h includes vector number not
+ * softirq_action. When used in combination with the softirq_entry tracepoint
+ * we can determine the softirq raise latency.
+ */
+DEFINE_EVENT(softirq, softirq_raise,
+
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+
+	TP_ARGS(h, vec)
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
