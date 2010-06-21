Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab0FUJb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 05:31:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:25716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab0FUJbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 05:31:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,452,1272870000"; 
   d="scan'208";a="632117947"
Subject: [PATCH V2 2/5] ara virt interface of perf to support kvm guest os
 statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 21 Jun 2010 17:31:24 +0800
Message-Id: <1277112686.2096.510.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2nd patch is to change the definition of perf_event to facilitate
perf attr copy when a hypercall happens.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

--- linux-2.6_tip0620/include/linux/perf_event.h	2010-06-21 15:19:52.821999849 +0800
+++ linux-2.6_tip0620perfkvm/include/linux/perf_event.h	2010-06-21 16:53:49.283999849 +0800
@@ -188,7 +188,10 @@ struct perf_event_attr {
 	__u64			sample_type;
 	__u64			read_format;
 
-	__u64			disabled       :  1, /* off by default        */
+	union {
+		__u64		flags;
+		struct {
+			__u64	disabled       :  1, /* off by default        */
 				inherit	       :  1, /* children inherit it   */
 				pinned	       :  1, /* must always be on PMU */
 				exclusive      :  1, /* only group on PMU     */
@@ -217,6 +220,8 @@ struct perf_event_attr {
 				mmap_data      :  1, /* non-exec mmap data    */
 
 				__reserved_1   : 46;
+		};
+	};
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -465,12 +470,6 @@ enum perf_callchain_context {
 # include <asm/local64.h>
 #endif
 
-struct perf_guest_info_callbacks {
-	int (*is_in_guest) (void);
-	int (*is_user_mode) (void);
-	unsigned long (*get_guest_ip) (void);
-};
-
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 #include <asm/hw_breakpoint.h>
 #endif
@@ -753,6 +752,20 @@ struct perf_event {
 
 	perf_overflow_handler_t		overflow_handler;
 
+	/*
+	 * pointers used by kvm perf paravirt interface.
+	 *
+	 * 1) Used in host kernel and points to host_perf_shadow which
+	 * has information about guest perf_event
+	 */
+	void				*host_perf_shadow;
+	/*
+	 * 2) Used in guest kernel and points to guest_perf_shadow which
+	 * is used as a communication area with host kernel. Host kernel
+	 * copies overflow data to it when an event overflows.
+	 */
+	void				*guest_perf_shadow;
+
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
@@ -838,6 +851,16 @@ struct perf_output_handle {
 	int				sample;
 };
 
+struct perf_guest_info_callbacks {
+	/* Support collect guest statistics from host side */
+	int (*is_in_guest) (void);
+	int (*is_user_mode) (void);
+	unsigned long (*get_guest_ip) (void);
+
+	/* Support paravirt interface */
+	void (*copy_event_to_shadow) (struct perf_event *event, int overflows);
+};
+
 #ifdef CONFIG_PERF_EVENTS
 
 /*
@@ -871,6 +894,10 @@ perf_event_create_kernel_counter(struct 
 				perf_overflow_handler_t callback);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
+extern void perf_event_output(struct perf_event *event, int nmi,
+		struct perf_sample_data *data, struct pt_regs *regs);
+void perf_event_attach(struct perf_event *event);
+void perf_event_detach(struct perf_event *event);
 
 struct perf_sample_data {
 	u64				type;
@@ -1023,6 +1050,14 @@ perf_event_task_sched_in(struct task_str
 static inline void
 perf_event_task_sched_out(struct task_struct *task,
 			    struct task_struct *next)			{ }
+
+static inline void
+perf_event_output(struct perf_event *event, int nmi,
+		struct perf_sample_data *data, struct pt_regs *regs)	{ }
+
+static inline void perf_event_attach(struct perf_event *event)		{ }
+static inline void perf_event_detach(struct perf_event *event)		{ }
+
 static inline void
 perf_event_task_tick(struct task_struct *task)				{ }
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
--- linux-2.6_tip0620/kernel/watchdog.c	2010-06-21 15:20:48.517999849 +0800
+++ linux-2.6_tip0620perfkvm/kernel/watchdog.c	2010-06-21 15:21:39.315999849 +0800
@@ -197,8 +197,6 @@ static struct perf_event_attr wd_hw_attr
 	.type		= PERF_TYPE_HARDWARE,
 	.config		= PERF_COUNT_HW_CPU_CYCLES,
 	.size		= sizeof(struct perf_event_attr),
-	.pinned		= 1,
-	.disabled	= 1,
 };
 
 /* Callback function for perf event subsystem */
@@ -361,6 +359,8 @@ static int watchdog_nmi_enable(int cpu)
 	/* Try to register using hardware perf events */
 	wd_attr = &wd_hw_attr;
 	wd_attr->sample_period = hw_nmi_get_sample_period();
+	wd_attr->pinned = 1;
+	wd_attr->disabled = 1;
 	event = perf_event_create_kernel_counter(wd_attr, cpu, -1, watchdog_overflow_callback);
 	if (!IS_ERR(event)) {
 		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
--- linux-2.6_tip0620/kernel/perf_event.c	2010-06-21 15:20:49.013999849 +0800
+++ linux-2.6_tip0620perfkvm/kernel/perf_event.c	2010-06-21 16:52:35.432999849 +0800
@@ -32,6 +32,7 @@
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/kvm_para.h>
 
 #include <asm/irq_regs.h>
 
@@ -747,6 +748,7 @@ static int group_can_go_on(struct perf_e
 	 */
 	if (event->attr.exclusive && cpuctx->active_oncpu)
 		return 0;
+
 	/*
 	 * Otherwise, try to add it if all previous groups were able
 	 * to go on.
@@ -1613,6 +1615,7 @@ void perf_event_task_tick(struct task_st
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
 	int rotate = 0;
+	int adjust_freq = 1;
 
 	if (!atomic_read(&nr_events))
 		return;
@@ -1626,9 +1629,22 @@ void perf_event_task_tick(struct task_st
 	if (ctx && ctx->nr_events && ctx->nr_events != ctx->nr_active)
 		rotate = 1;
 
-	perf_ctx_adjust_freq(&cpuctx->ctx);
-	if (ctx)
-		perf_ctx_adjust_freq(ctx);
+#ifdef CONFIG_KVM_PERF
+	if (kvm_para_available()) {
+		/*
+		 * perf_ctx_adjust_freq causes lots of pmu->read which would
+		 * trigger too many vmexit to host kernel. We disable it
+		 * under para virt situation
+		 */
+		adjust_freq = 0;
+	}
+#endif
+
+	if (adjust_freq) {
+		perf_ctx_adjust_freq(&cpuctx->ctx);
+		if (ctx)
+			perf_ctx_adjust_freq(ctx);
+	}
 
 	if (!rotate)
 		return;
@@ -3434,7 +3450,7 @@ void perf_prepare_sample(struct perf_eve
 	}
 }
 
-static void perf_event_output(struct perf_event *event, int nmi,
+void perf_event_output(struct perf_event *event, int nmi,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
@@ -5261,6 +5277,47 @@ perf_event_create_kernel_counter(struct 
 }
 EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
 
+void perf_event_attach(struct perf_event *event)
+{
+	struct perf_event_context *old_ctx, *new_ctx;
+
+	old_ctx = event->ctx;
+	new_ctx = find_get_context(current->pid, -1);
+	if (old_ctx != new_ctx) {
+		if (old_ctx) {
+			/* Delete from old ctx before joining new ctx */
+			mutex_lock(&old_ctx->mutex);
+			raw_spin_lock(&old_ctx->lock);
+			list_del_event(event, old_ctx);
+			raw_spin_unlock(&old_ctx->lock);
+			mutex_unlock(&old_ctx->mutex);
+			put_ctx(old_ctx);
+		}
+
+		mutex_lock(&new_ctx->mutex);
+		raw_spin_lock(&new_ctx->lock);
+		list_add_event(event, new_ctx);
+		event->ctx = new_ctx;
+		raw_spin_unlock(&new_ctx->lock);
+		mutex_unlock(&new_ctx->mutex);
+	} else
+		put_ctx(new_ctx);
+
+	perf_event_enable(event);
+}
+EXPORT_SYMBOL_GPL(perf_event_attach);
+
+void perf_event_detach(struct perf_event *event)
+{
+	/*
+	 * Just disable the event and don't del it from
+	 * ctx->event_list in case there is a race condition
+	 * with perf_event_read_value
+	 */
+	perf_event_disable(event);
+}
+EXPORT_SYMBOL_GPL(perf_event_detach);
+
 /*
  * inherit a event from parent task to child task:
  */


