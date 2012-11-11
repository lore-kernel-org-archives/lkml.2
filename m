Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab2KKIEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 03:04:44 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35093 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2KKIEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 03:04:42 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: linux-s390@vger.kernel.org, Srikar <srikar@linux.vnet.ibm.com>,
        <joerg.roedel@amd.com>, <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, <chegu_vinod@hp.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, <drjones@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        <srivatsa.vaddagiri@gmail.com>, <ouyang@cs.pitt.edu>
Date: Sun, 11 Nov 2012 13:29:39 +0530
Message-Id: <20121111075938.3617.4526.sendpatchset@codeblue>
Subject: [PATCH RFC 1/1] kvm: Add dynamic ple window feature
x-cbid: 12111108-5490-0000-0000-0000027232E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces dynamic PLE window that is based on detecting potential
undrcommit case patch series (patch 1 and RESENT patch 2) from the thread
https://lkml.org/lkml/2012/10/29/287.

Results are on expected lines from the discussion of ple_window experiment
where  summary showed improvement for undercommit cases for ebizzy workload.
link: https://lkml.org/lkml/2012/10/9/545

32 vcpu guest on 32 core (HT diabled) mx3850 PLE machine
base = 3.7.0-rc1 
A = base + bail out on successive failures patch. (link above)
B = A + dynamic ple window patch (below patch)

Results w.r.t base. (Tested only on x86_64)

                 A               B
ebizzy_1x      147.47995       182.69864
ebizzy_2x      -4.52835        -12.22457
ebizzy_3x      -5.17241        -39.55113

dbench_1x      61.14888        54.31150      
dbench_2x      -4.17130        -6.15509       
dbench_3x      -3.18740        -9.63721       
			       
Result shows improvement for 1x ebizzy case. 

Comments/suggestions welcome.

----8<----
kvm: Add dynamic ple window feature

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

The current value of PLE window is tuned very well for overcommited
cases. However for less than 1:1 overcommit, PLE is a big overhead.
A PLE window of 16k is good for such cases.

This patch adds the logic of dynamic PLE window, where,
upon successful yield_to in PLE handler we decrement window size until 4k
Similarly when we find yield_to have been unsuccessful, we increment
until 16k.

With this patchset we change the defult PLE window size to 16k.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---

 arch/s390/include/asm/kvm_host.h |    2 ++
 arch/x86/include/asm/kvm_host.h  |    4 ++++
 arch/x86/kvm/svm.c               |   10 ++++++++++
 arch/x86/kvm/vmx.c               |   32 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c               |   10 ++++++++++
 virt/kvm/kvm_main.c              |    5 +++++
 6 files changed, 61 insertions(+), 2 deletions(-)


diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index b784154..012b48d 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -257,4 +257,6 @@ struct kvm_arch{
 };
 
 extern int sie64a(struct kvm_s390_sie_block *, u64 *);
+static inline void kvm_inc_ple_window(void) {}
+static inline void kvm_dec_ple_window(void) {}
 #endif
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b2e11f4..4629e59 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -707,6 +707,8 @@ struct kvm_x86_ops {
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage);
+	void (*inc_ple_window)(void);
+	void (*dec_ple_window)(void);
 };
 
 struct kvm_arch_async_pf {
@@ -1007,5 +1009,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 void kvm_handle_pmu_event(struct kvm_vcpu *vcpu);
 void kvm_deliver_pmi(struct kvm_vcpu *vcpu);
+void kvm_inc_ple_window(void);
+void kvm_dec_ple_window(void);
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d017df3..198523e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4220,6 +4220,14 @@ out:
 	return ret;
 }
 
+static inline void svm_inc_ple_window(void)
+{
+}
+
+static inline void svm_dec_ple_window(void)
+{
+}
+
 static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -4310,6 +4318,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_tdp_cr3 = set_tdp_cr3,
 
 	.check_intercept = svm_check_intercept,
+	.inc_ple_window = svm_inc_ple_window,
+	.dec_ple_window = svm_dec_ple_window,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ad6b1dd..68fb3e4 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -115,12 +115,17 @@ module_param(nested, bool, S_IRUGO);
  *             According to test, this time is usually smaller than 128 cycles.
  * ple_window: upper bound on the amount of time a guest is allowed to execute
  *             in a PAUSE loop. Tests indicate that most spinlocks are held for
- *             less than 2^12 cycles
+ *             less than 2^12 cycles. But we keep the default value 2^14 to
+ *             ensure less overhead in uncontended cases.
  * Time is measured based on a counter that runs at the same rate as the TSC,
  * refer SDM volume 3b section 21.6.13 & 22.1.3.
  */
 #define KVM_VMX_DEFAULT_PLE_GAP    128
-#define KVM_VMX_DEFAULT_PLE_WINDOW 4096
+#define KVM_VMX_DEFAULT_PLE_WINDOW 16384
+#define KVM_VMX_MAX_PLE_WINDOW     16384
+#define KVM_VMX_MIN_PLE_WINDOW     4096
+#define KVM_VMX_PLE_WINDOW_DELTA   1024
+
 static int ple_gap = KVM_VMX_DEFAULT_PLE_GAP;
 module_param(ple_gap, int, S_IRUGO);
 
@@ -7149,6 +7154,27 @@ void load_vmcs12_host_state(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 			vmcs12->host_ia32_perf_global_ctrl);
 }
 
+#define MAX(a, b) ((a) > (b) ? (a) : (b))
+#define MIN(a, b) ((a) < (b) ? (a) : (b))
+
+static inline void vmx_inc_ple_window(void)
+{
+	if (ple_gap) {
+		ple_window = MIN(KVM_VMX_MAX_PLE_WINDOW,
+					ple_window + KVM_VMX_PLE_WINDOW_DELTA);
+		vmcs_write32(PLE_WINDOW, ple_window);
+	}
+}
+
+static inline void vmx_dec_ple_window(void)
+{
+	if (ple_gap) {
+		ple_window = MAX(KVM_VMX_MIN_PLE_WINDOW,
+				ple_window - (KVM_VMX_PLE_WINDOW_DELTA>>2));
+		vmcs_write32(PLE_WINDOW, ple_window);
+	}
+}
+
 /*
  * Emulate an exit from nested guest (L2) to L1, i.e., prepare to run L1
  * and modify vmcs12 to make it see what it would expect to see there if
@@ -7314,6 +7340,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_tdp_cr3 = vmx_set_cr3,
 
 	.check_intercept = vmx_check_intercept,
+	.inc_ple_window = vmx_inc_ple_window,
+	.dec_ple_window = vmx_dec_ple_window,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 224a7e7..7af4315 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6052,6 +6052,16 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+void kvm_inc_ple_window(void)
+{
+	kvm_x86_ops->inc_ple_window();
+}
+
+void kvm_dec_ple_window(void)
+{
+	kvm_x86_ops->dec_ple_window();
+}
+
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	int r;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9f390e7..0272863 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1731,15 +1731,20 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 
 			yielded = kvm_vcpu_yield_to(vcpu);
 			if (yielded > 0) {
+				kvm_dec_ple_window();
 				kvm->last_boosted_vcpu = i;
 				break;
 			} else if (yielded < 0) {
 				try--;
+				kvm_inc_ple_window();
 				if (!try)
 					break;
 			}
 		}
 	}
+	if (!yielded)
+		kvm_inc_ple_window();
+
 	kvm_vcpu_set_in_spin_loop(me, false);
 
 	/* Ensure vcpu is not eligible during next spinloop */

