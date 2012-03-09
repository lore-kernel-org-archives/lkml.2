Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030418Ab2CITqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:46:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43174 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030325Ab2CITqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:46:16 -0500
Message-Id: <20120309190203.535020513@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Gleb Natapov <gleb@redhat.com>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [ 15/95] perf/x86/kvm: Fix Host-Only/Guest-Only counting with SVM disabled
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 1018faa6cf23b256bf25919ef203cd7c129f06f2 upstream.

It turned out that a performance counter on AMD does not
count at all when the GO or HO bit is set in the control
register and SVM is disabled in EFER.

This patch works around this issue by masking out the HO bit
in the performance counter control register when SVM is not
enabled.

The GO bit is not touched because it is only set when the
user wants to count in guest-mode only. So when SVM is
disabled the counter should not run at all and the
not-counting is the intended behaviour.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>
Link: http://lkml.kernel.org/r/1330523852-19566-1-git-send-email-joerg.roedel@amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/perf_event.h    |    8 +++++++
 arch/x86/kernel/cpu/perf_event.h     |    8 +++++--
 arch/x86/kernel/cpu/perf_event_amd.c |   37 +++++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm.c                   |    5 ++++
 4 files changed, 54 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -212,4 +212,12 @@ static inline perf_guest_switch_msr *per
 static inline void perf_events_lapic_init(void)	{ }
 #endif
 
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
+ extern void amd_pmu_enable_virt(void);
+ extern void amd_pmu_disable_virt(void);
+#else
+ static inline void amd_pmu_enable_virt(void) { }
+ static inline void amd_pmu_disable_virt(void) { }
+#endif
+
 #endif /* _ASM_X86_PERF_EVENT_H */
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -146,7 +146,9 @@ struct cpu_hw_events {
 	/*
 	 * AMD specific bits
 	 */
-	struct amd_nb		*amd_nb;
+	struct amd_nb			*amd_nb;
+	/* Inverted mask of bits to clear in the perf_ctr ctrl registers */
+	u64				perf_ctr_virt_mask;
 
 	void				*kfree_on_online;
 };
@@ -372,9 +374,11 @@ void x86_pmu_disable_all(void);
 static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 					  u64 enable_mask)
 {
+	u64 disable_mask = __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);
+
 	if (hwc->extra_reg.reg)
 		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
-	wrmsrl(hwc->config_base, hwc->config | enable_mask);
+	wrmsrl(hwc->config_base, (hwc->config | enable_mask) & ~disable_mask);
 }
 
 void x86_pmu_enable_all(int added);
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -1,4 +1,5 @@
 #include <linux/perf_event.h>
+#include <linux/export.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -357,7 +358,9 @@ static void amd_pmu_cpu_starting(int cpu
 	struct amd_nb *nb;
 	int i, nb_id;
 
-	if (boot_cpu_data.x86_max_cores < 2)
+	cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
+
+	if (boot_cpu_data.x86_max_cores < 2 || boot_cpu_data.x86 == 0x15)
 		return;
 
 	nb_id = amd_get_nb_id(cpu);
@@ -587,9 +590,9 @@ static __initconst const struct x86_pmu
 	.put_event_constraints	= amd_put_event_constraints,
 
 	.cpu_prepare		= amd_pmu_cpu_prepare,
-	.cpu_starting		= amd_pmu_cpu_starting,
 	.cpu_dead		= amd_pmu_cpu_dead,
 #endif
+	.cpu_starting		= amd_pmu_cpu_starting,
 };
 
 __init int amd_pmu_init(void)
@@ -621,3 +624,33 @@ __init int amd_pmu_init(void)
 
 	return 0;
 }
+
+void amd_pmu_enable_virt(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	cpuc->perf_ctr_virt_mask = 0;
+
+	/* Reload all events */
+	x86_pmu_disable_all();
+	x86_pmu_enable_all(0);
+}
+EXPORT_SYMBOL_GPL(amd_pmu_enable_virt);
+
+void amd_pmu_disable_virt(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	/*
+	 * We only mask out the Host-only bit so that host-only counting works
+	 * when SVM is disabled. If someone sets up a guest-only counter when
+	 * SVM is disabled the Guest-only bits still gets set and the counter
+	 * will not count anything.
+	 */
+	cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
+
+	/* Reload all events */
+	x86_pmu_disable_all();
+	x86_pmu_enable_all(0);
+}
+EXPORT_SYMBOL_GPL(amd_pmu_disable_virt);
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -29,6 +29,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/slab.h>
 
+#include <asm/perf_event.h>
 #include <asm/tlbflush.h>
 #include <asm/desc.h>
 #include <asm/kvm_para.h>
@@ -575,6 +576,8 @@ static void svm_hardware_disable(void *g
 		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
 
 	cpu_svm_disable();
+
+	amd_pmu_disable_virt();
 }
 
 static int svm_hardware_enable(void *garbage)
@@ -622,6 +625,8 @@ static int svm_hardware_enable(void *gar
 
 	svm_init_erratum_383();
 
+	amd_pmu_enable_virt();
+
 	return 0;
 }
 


