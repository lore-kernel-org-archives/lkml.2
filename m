Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab0IGQtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:49:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47445 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab0IGQsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=RKzh5wDMcrSQKAaXCivhVrtTheev7XtGdx6dMVbIgl35cTcxW+Jllu0G35aNRj+sEN
         Pbae2DtamfoFTdJQqbToAMc2QPEAONHMiBY92ZPDz386a/o6nIS1oWcnDafzjFyzQ4yH
         3n5N/ezTXETlEKkVI8PZnJJQjKtV5mqVQiaz8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        David Miller <davem@davemloft.net>,
        Kaneshige Kenji <kaneshige.kenji@jp.fujitsu.com>,
        Izumo Taku <izumi.taku@jp.fujitsu.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Scott Mcmillan <scott.a.mcmillan@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/5] irq: Add tracepoint to softirq_raise
Date: Tue,  7 Sep 2010 18:48:07 +0200
Message-Id: <1283878091-5751-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1283878091-5751-1-git-send-regression-fweisbec@gmail.com>
References: <1283878091-5751-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

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
-- 
1.6.2.3

