Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab0HELKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:10:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758995Ab0HELJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:09:58 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, yhlu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] apic,trace: IPI sent trace event.
Date: Thu,  5 Aug 2010 13:09:38 +0200
Message-Id: <1281006578-5073-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1281006578-5073-1-git-send-email-jolsa@redhat.com>
References: <1281006578-5073-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding apic IPI trace event.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/include/asm/apic_trace.h |   53 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/apic.c       |   21 ++++++++++++++
 2 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/apic_trace.h

diff --git a/arch/x86/include/asm/apic_trace.h b/arch/x86/include/asm/apic_trace.h
new file mode 100644
index 0000000..03eea8e
--- /dev/null
+++ b/arch/x86/include/asm/apic_trace.h
@@ -0,0 +1,53 @@
+
+#if !defined(_TRACE_APIC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_APIC_H
+
+#include <linux/tracepoint.h>
+#include <linux/cpumask.h>
+
+#define BUFSIZE (50)
+#define CPU_MASK_PRINTK() ({						\
+	const char *ret = p->buffer + p->len;				\
+	char buf[BUFSIZE];						\
+	bitmap_scnlistprintf(buf, BUFSIZE,				\
+			     __entry->mask, nr_cpumask_bits);		\
+	trace_seq_printf(p, "to cpu(s) %s\n", buf);			\
+	ret;								\
+})
+
+/**
+ * apic_send_IPI_mask - called before the IPI is send
+ * @mask: cpu mask the IPI is directed to
+ * @vector: interrupt number
+ */
+TRACE_EVENT(apic_send_IPI,
+
+	TP_PROTO(const struct cpumask *mask, int vector),
+
+	TP_ARGS(mask, vector),
+
+	TP_STRUCT__entry(
+		__array(unsigned long, mask, nr_cpumask_bits)
+		__field(int, vector)
+	),
+
+	TP_fast_assign(
+		bitmap_copy(__entry->mask, cpumask_bits(mask), nr_cpumask_bits);
+		__entry->vector = vector;
+	),
+
+	TP_printk("irq %d, %s", __entry->vector, CPU_MASK_PRINTK())
+);
+
+#endif /* _TRACE_APIC_H */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM irq
+
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE apic_trace
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH asm
+
+#include <trace/define_trace.h>
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2ab2f26..d8cddf0 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -53,6 +53,9 @@
 #include <asm/kvm_para.h>
 #include <asm/tsc.h>
 
+#define CREATE_TRACE_POINTS
+#include <asm/apic_trace.h>
+
 unsigned int num_processors;
 
 unsigned disabled_cpus __cpuinitdata;
@@ -2335,25 +2338,43 @@ late_initcall(lapic_insert_resource);
 
 void apic_send_IPI_mask(const struct cpumask *mask, int vector)
 {
+	trace_apic_send_IPI(mask, vector);
+
 	apic->send_IPI_mask(mask, vector);
 }
 
 void apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
+	trace_apic_send_IPI(mask, vector);
+
 	apic->send_IPI_mask_allbutself(mask, vector);
 }
 
 void apic_send_IPI_allbutself(int vector)
 {
+	struct cpumask mask;
+
+	cpumask_copy(&mask, cpu_possible_mask);
+	cpumask_clear_cpu(smp_processor_id(), &mask);
+	trace_apic_send_IPI(&mask, vector);
+
 	apic->send_IPI_allbutself(vector);
 }
 
 void apic_send_IPI_all(int vector)
 {
+	trace_apic_send_IPI(cpu_online_mask, vector);
+
 	apic->send_IPI_all(vector);
 }
 
 void apic_send_IPI_self(int vector)
 {
+	struct cpumask mask;
+
+	cpumask_clear(&mask);
+	cpumask_set_cpu(smp_processor_id(), &mask);
+	trace_apic_send_IPI(&mask, vector);
+
 	apic->send_IPI_self(vector);
 }
-- 
1.7.2

