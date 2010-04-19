Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0DSFd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 01:33:27 -0400
Received: from mga12.intel.com ([143.182.124.36]:39678 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751744Ab0DSFdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 01:33:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,234,1270450800"; 
   d="scan'208";a="267235202"
Subject: [PATCH V5 1/3] perf & kvm: Enhance perf to collect KVM guest os
 statistics from host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 19 Apr 2010 13:32:41 +0800
Message-Id: <1271655161.2078.603.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below patch introduces perf_guest_info_callbacks and related register/unregister
functions. Add more PERF_RECORD_MISC_XXX bits meaning guest kernel and guest user
space.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup --exclude-from=exclude.diff linux-2.6_tip0417/arch/x86/include/asm/perf_event.h linux-2.6_tip0417_perfkvm/arch/x86/include/asm/perf_event.h
--- linux-2.6_tip0417/arch/x86/include/asm/perf_event.h	2010-04-19 09:51:47.557797121 +0800
+++ linux-2.6_tip0417_perfkvm/arch/x86/include/asm/perf_event.h	2010-04-19 09:53:59.689452915 +0800
@@ -135,17 +135,10 @@ extern void perf_events_lapic_init(void)
  */
 #define PERF_EFLAGS_EXACT	(1UL << 3)
 
-#define perf_misc_flags(regs)				\
-({	int misc = 0;					\
-	if (user_mode(regs))				\
-		misc |= PERF_RECORD_MISC_USER;		\
-	else						\
-		misc |= PERF_RECORD_MISC_KERNEL;	\
-	if (regs->flags & PERF_EFLAGS_EXACT)		\
-		misc |= PERF_RECORD_MISC_EXACT;		\
-	misc; })
-
-#define perf_instruction_pointer(regs)	((regs)->ip)
+struct pt_regs;
+extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
+extern unsigned long perf_misc_flags(struct pt_regs *regs);
+#define perf_misc_flags(regs)	perf_misc_flags(regs)
 
 #else
 static inline void init_hw_perf_events(void)		{ }
diff -Nraup --exclude-from=exclude.diff linux-2.6_tip0417/arch/x86/kernel/cpu/perf_event.c linux-2.6_tip0417_perfkvm/arch/x86/kernel/cpu/perf_event.c
--- linux-2.6_tip0417/arch/x86/kernel/cpu/perf_event.c	2010-04-19 09:51:48.347655964 +0800
+++ linux-2.6_tip0417_perfkvm/arch/x86/kernel/cpu/perf_event.c	2010-04-19 09:53:59.689452915 +0800
@@ -1720,6 +1720,11 @@ struct perf_callchain_entry *perf_callch
 {
 	struct perf_callchain_entry *entry;
 
+	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+		/* TODO: We don't support guest os callchain now */
+		return NULL;
+	}
+
 	if (in_nmi())
 		entry = &__get_cpu_var(pmc_nmi_entry);
 	else
@@ -1743,3 +1748,30 @@ void perf_arch_fetch_caller_regs(struct 
 	regs->cs = __KERNEL_CS;
 	local_save_flags(regs->flags);
 }
+
+unsigned long perf_instruction_pointer(struct pt_regs *regs)
+{
+	unsigned long ip;
+	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
+		ip = perf_guest_cbs->get_guest_ip();
+	else
+		ip = instruction_pointer(regs);
+	return ip;
+}
+
+unsigned long perf_misc_flags(struct pt_regs *regs)
+{
+	int misc = 0;
+	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+		misc |= perf_guest_cbs->is_user_mode() ?
+			PERF_RECORD_MISC_GUEST_USER :
+			PERF_RECORD_MISC_GUEST_KERNEL;
+	} else
+		misc |= user_mode(regs) ? PERF_RECORD_MISC_USER :
+			PERF_RECORD_MISC_KERNEL;
+	if (regs->flags & PERF_EFLAGS_EXACT)
+		misc |= PERF_RECORD_MISC_EXACT;
+
+	return misc;
+}
+
diff -Nraup --exclude-from=exclude.diff linux-2.6_tip0417/include/linux/perf_event.h linux-2.6_tip0417_perfkvm/include/linux/perf_event.h
--- linux-2.6_tip0417/include/linux/perf_event.h	2010-04-19 09:51:59.544791000 +0800
+++ linux-2.6_tip0417_perfkvm/include/linux/perf_event.h	2010-04-19 09:53:59.691378953 +0800
@@ -288,11 +288,13 @@ struct perf_event_mmap_page {
 	__u64	data_tail;		/* user-space written tail */
 };
 
-#define PERF_RECORD_MISC_CPUMODE_MASK		(3 << 0)
+#define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
 #define PERF_RECORD_MISC_CPUMODE_UNKNOWN	(0 << 0)
 #define PERF_RECORD_MISC_KERNEL			(1 << 0)
 #define PERF_RECORD_MISC_USER			(2 << 0)
 #define PERF_RECORD_MISC_HYPERVISOR		(3 << 0)
+#define PERF_RECORD_MISC_GUEST_KERNEL		(4 << 0)
+#define PERF_RECORD_MISC_GUEST_USER		(5 << 0)
 
 #define PERF_RECORD_MISC_EXACT			(1 << 14)
 /*
@@ -446,6 +448,12 @@ enum perf_callchain_context {
 # include <asm/perf_event.h>
 #endif
 
+struct perf_guest_info_callbacks {
+	int (*is_in_guest) (void);
+	int (*is_user_mode) (void);
+	unsigned long (*get_guest_ip) (void);
+};
+
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 #include <asm/hw_breakpoint.h>
 #endif
@@ -932,6 +940,12 @@ static inline void perf_event_mmap(struc
 		__perf_event_mmap(vma);
 }
 
+extern struct perf_guest_info_callbacks *perf_guest_cbs;
+extern int perf_register_guest_info_callbacks(
+		struct perf_guest_info_callbacks *);
+extern int perf_unregister_guest_info_callbacks(
+		struct perf_guest_info_callbacks *);
+
 extern void perf_event_comm(struct task_struct *tsk);
 extern void perf_event_fork(struct task_struct *tsk);
 
@@ -1001,6 +1015,11 @@ perf_sw_event(u32 event_id, u64 nr, int 
 static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
+static inline int perf_register_guest_info_callbacks
+(struct perf_guest_info_callbacks *) {return 0; }
+static inline int perf_unregister_guest_info_callbacks
+(struct perf_guest_info_callbacks *) {return 0; }
+
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
diff -Nraup --exclude-from=exclude.diff linux-2.6_tip0417/kernel/perf_event.c linux-2.6_tip0417_perfkvm/kernel/perf_event.c
--- linux-2.6_tip0417/kernel/perf_event.c	2010-04-19 09:52:40.907135718 +0800
+++ linux-2.6_tip0417_perfkvm/kernel/perf_event.c	2010-04-19 09:53:59.693377237 +0800
@@ -2798,6 +2798,27 @@ void perf_arch_fetch_caller_regs(struct 
 
 
 /*
+ * We assume there is only KVM supporting the callbacks.
+ * Later on, we might change it to a list if there is
+ * another virtualization implementation supporting the callbacks.
+ */
+struct perf_guest_info_callbacks *perf_guest_cbs;
+
+int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
+{
+	perf_guest_cbs = cbs;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
+
+int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
+{
+	perf_guest_cbs = NULL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
+
+/*
  * Output
  */
 static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
@@ -3749,7 +3770,7 @@ void __perf_event_mmap(struct vm_area_st
 		.event_id  = {
 			.header = {
 				.type = PERF_RECORD_MMAP,
-				.misc = 0,
+				.misc = PERF_RECORD_MISC_USER,
 				/* .size */
 			},
 			/* .pid */


