Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab0FXDFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:05:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:24624 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab0FXDFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:05:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,471,1272870000"; 
   d="scan'208";a="810964574"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>
Subject: [RFC 2/5] NMI return notifier
Date: Thu, 24 Jun 2010 11:04:55 +0800
Message-Id: <1277348698-17311-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many kernel services can not be used in NMI handler. So NMI handler
needs a mechanism to do these operations in other contexts such as IRQ
and process.

This patch implements such a mechanism based on soft_irq in a similar
way as user return notifier. A new soft_irq named
NMI_RETURN_NOTIFIER_SOFTIRQ is defined and a lock-less single link
list is used to hold functions which will be called in the soft_irq
after NMI handler returned.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/interrupt.h |    1 
 include/linux/nmi.h       |   11 +++++
 kernel/Makefile           |    2 -
 kernel/nmi.c              |   86 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/softirq.c          |    2 +
 5 files changed, 101 insertions(+), 1 deletion(-)
 create mode 100644 kernel/nmi.c

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -374,6 +374,7 @@ enum
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
 	HRTIMER_SOFTIRQ,
+	NMI_RETURN_NOTIFIER_SOFTIRQ,
 	RCU_SOFTIRQ,	/* Preferable RCU should always be the last softirq */
 
 	NR_SOFTIRQS
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -47,4 +47,15 @@ static inline bool trigger_all_cpu_backt
 }
 #endif
 
+struct nmi_return_notifier {
+	void (*on_nmi_return)(struct nmi_return_notifier *nrn);
+	void *data;
+	struct nmi_return_notifier *next;
+};
+
+void nmi_return_notifier_schedule(struct nmi_return_notifier *nrn);
+void fire_nmi_return_notifiers(void);
+struct softirq_action;
+void nmi_return_notifier_action(struct softirq_action *a);
+
 #endif
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o
+	    async.o range.o nmi.o
 obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o
 obj-y += groups.o
 
--- /dev/null
+++ b/kernel/nmi.c
@@ -0,0 +1,86 @@
+/*
+ * nmi.c
+ *
+ * Copyright 2010 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/nmi.h>
+#include <linux/percpu.h>
+
+#define NMI_RETURN_NOTIFIER_TAIL	((struct nmi_return_notifier *)-1UL)
+
+static DEFINE_PER_CPU(struct nmi_return_notifier *, nmi_return_notifier_head) =
+	NMI_RETURN_NOTIFIER_TAIL;
+
+/*
+ * Some architectures can used this function to trigger soft_irq, for
+ * example via self interrupt.
+ */
+void __weak arch_nmi_return_notifier_schedule(struct nmi_return_notifier *nrn)
+{
+}
+
+/*
+ * Schedule a notification after current CPU returns from NMI handler.
+ * Must be called in atomic context.  The notifier will be called in
+ * IRQ or soft_irq context.
+ *
+ * This function is based on perf_pending_queue().
+ */
+void nmi_return_notifier_schedule(struct nmi_return_notifier *nrn)
+{
+	struct nmi_return_notifier **head;
+
+	if (cmpxchg(&nrn->next, NULL, NMI_RETURN_NOTIFIER_TAIL) != NULL)
+		return;
+
+	head = &get_cpu_var(nmi_return_notifier_head);
+
+	do {
+		nrn->next = *head;
+	} while (cmpxchg(head, nrn->next, nrn) != nrn->next);
+
+	raise_softirq_preempt_off(NMI_RETURN_NOTIFIER_SOFTIRQ);
+
+	arch_nmi_return_notifier_schedule(nrn);
+
+	put_cpu_var(nmi_return_notifier_head);
+}
+EXPORT_SYMBOL_GPL(nmi_return_notifier_schedule);
+
+void fire_nmi_return_notifiers(void)
+{
+	struct nmi_return_notifier *nrn, *list;
+
+	list = xchg(&__get_cpu_var(nmi_return_notifier_head),
+		    NMI_RETURN_NOTIFIER_TAIL);
+	while (list != NMI_RETURN_NOTIFIER_TAIL) {
+		nrn = list;
+		list = list->next;
+		nrn->next = NULL;
+		nrn->on_nmi_return(nrn);
+	}
+}
+EXPORT_SYMBOL_GPL(fire_nmi_return_notifiers);
+
+void nmi_return_notifier_action(struct softirq_action *a)
+{
+	fire_nmi_return_notifiers();
+}
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -24,6 +24,7 @@
 #include <linux/ftrace.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
+#include <linux/nmi.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
@@ -687,6 +688,7 @@ void __init softirq_init(void)
 
 	open_softirq(TASKLET_SOFTIRQ, tasklet_action);
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
+	open_softirq(NMI_RETURN_NOTIFIER_SOFTIRQ, nmi_return_notifier_action);
 }
 
 static int run_ksoftirqd(void * __bind_cpu)
