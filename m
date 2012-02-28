Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965687Ab2B1P4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:56:03 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:32133
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965641Ab2B1Pz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:55:59 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M041L3-01-3VO-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] perf/x86: Fix HO/GO counting with SVM disabled
Date: Tue, 28 Feb 2012 16:55:44 +0100
Message-ID: <1330444544-15665-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20120227182325.GA12302@8bytes.org>
References: <20120227182325.GA12302@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: stable@vger.kernel.org # 3.2
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/perf_event.h    |    5 +++++
 arch/x86/kernel/cpu/perf_event.c     |   30 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.h     |    6 +++++-
 arch/x86/kernel/cpu/perf_event_amd.c |    6 ++++--
 arch/x86/kvm/svm.c                   |    5 +++++
 5 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 096c975e..e0a4ad4 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -227,6 +227,8 @@ struct perf_guest_switch_msr {
 
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
+extern void x86_pmu_enable_virt(void);
+extern void x86_pmu_disable_virt(void);
 #else
 static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
@@ -240,6 +242,9 @@ static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 }
 
 static inline void perf_events_lapic_init(void)	{ }
+
+static inline void x86_pmu_enable_virt(void) { }
+static inline void x86_pmu_disable_virt(void) { }
 #endif
 
 #endif /* _ASM_X86_PERF_EVENT_H */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5adce10..f1ba9bf 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -477,6 +477,36 @@ void x86_pmu_enable_all(int added)
 	}
 }
 
+void x86_pmu_enable_virt(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	cpuc->perf_ctr_virt_mask = 0;
+
+	/* Reload all events */
+	x86_pmu_disable_all();
+	x86_pmu_enable_all(0);
+}
+EXPORT_SYMBOL_GPL(x86_pmu_enable_virt);
+
+void x86_pmu_disable_virt(void)
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
+EXPORT_SYMBOL_GPL(x86_pmu_disable_virt);
+
 static struct pmu pmu;
 
 static inline int is_x86_event(struct perf_event *event)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 8944062..2c581b9 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -148,6 +148,8 @@ struct cpu_hw_events {
 	 * AMD specific bits
 	 */
 	struct amd_nb		*amd_nb;
+	/* Inverted mask of bits to clear in the perf_ctr ctrl registers */
+	u64			perf_ctr_virt_mask;
 
 	void				*kfree_on_online;
 };
@@ -417,9 +419,11 @@ void x86_pmu_disable_all(void);
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
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 0397b23..0487b12 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -357,7 +357,9 @@ static void amd_pmu_cpu_starting(int cpu)
 	struct amd_nb *nb;
 	int i, nb_id;
 
-	if (boot_cpu_data.x86_max_cores < 2)
+	cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
+
+	if (boot_cpu_data.x86_max_cores < 2 || boot_cpu_data.x86 == 0x15)
 		return;
 
 	nb_id = amd_get_nb_id(cpu);
@@ -587,9 +589,9 @@ static __initconst const struct x86_pmu amd_pmu_f15h = {
 	.put_event_constraints	= amd_put_event_constraints,
 
 	.cpu_prepare		= amd_pmu_cpu_prepare,
-	.cpu_starting		= amd_pmu_cpu_starting,
 	.cpu_dead		= amd_pmu_cpu_dead,
 #endif
+	.cpu_starting		= amd_pmu_cpu_starting,
 };
 
 __init int amd_pmu_init(void)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5fa553b..773fee2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -29,6 +29,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/slab.h>
 
+#include <asm/perf_event.h>
 #include <asm/tlbflush.h>
 #include <asm/desc.h>
 #include <asm/kvm_para.h>
@@ -575,6 +576,8 @@ static void svm_hardware_disable(void *garbage)
 		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
 
 	cpu_svm_disable();
+
+	x86_pmu_disable_virt();
 }
 
 static int svm_hardware_enable(void *garbage)
@@ -622,6 +625,8 @@ static int svm_hardware_enable(void *garbage)
 
 	svm_init_erratum_383();
 
+	x86_pmu_enable_virt();
+
 	return 0;
 }
 
-- 
1.7.5.4


