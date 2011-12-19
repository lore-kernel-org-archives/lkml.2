Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1LSRqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:46:10 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51986 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1LSRqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:46:07 -0500
From: Boris Ostrovsky <ostr@amd64.org>
To: avi@redhat.com, mtosatti@redhat.com, Joerg.Roedel@amd.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, boris.ostrovsky@amd.com
Subject: [PATCH] KVM: SVM: Add support for AMD's OSVW feature in guests
Date: Mon, 19 Dec 2011 12:46:03 -0500
Message-Id: <1324316763-24080-1-git-send-email-ostr@amd64.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

In some cases guests should not provide workarounds for errata even when the
physical processor is affected. For example, because of erratum 400 on family
10h processors a Linux guest will read an MSR (resulting in VMEXIT) before
going to idle in order to avoid getting stuck in a non-C0 state. This is not
necessary: HLT and IO instructions are intercepted and therefore there is no
reason for erratum 400 workaround in the guest.

This patch allows us to present a guest with certain errata as fixed,
regardless of the state of actual hardware.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Acked-by: Joerg.Roedel <Joerg.Roedel@amd.com>
---
 arch/x86/kvm/svm.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c |    2 +-
 2 files changed, 75 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e32243e..4bd41b7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -110,6 +110,13 @@ struct nested_state {
 #define MSRPM_OFFSETS	16
 static u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 
+/*
+ * Set osvw_len to higher value when updated Revision Guides
+ * are published and we know what the new status bits are
+ */
+static uint64_t osvw_len = 4, osvw_status;
+static DEFINE_SPINLOCK(svm_lock);
+
 struct vcpu_svm {
 	struct kvm_vcpu vcpu;
 	struct vmcb *vmcb;
@@ -556,6 +563,35 @@ static void svm_init_erratum_383(void)
 	erratum_383_found = true;
 }
 
+
+static int svm_handle_osvw(struct kvm_vcpu *vcpu,
+			   uint32_t msr, uint64_t *val)
+{
+	struct kvm_cpuid_entry2 *cpuid_entry;
+
+	/* Guest OSVW support */
+	cpuid_entry = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
+	if (!cpuid_entry || !(cpuid_entry->ecx & bit(X86_FEATURE_OSVW)))
+		return -1;
+
+	/*
+	 * Guests should see errata 400 and 415 as fixed (assuming that
+	 * HLT and IO instructions are intercepted).
+	 */
+	if (msr == MSR_AMD64_OSVW_ID_LENGTH)
+		*val = (osvw_len >= 3) ? (osvw_len) : 3;
+	else {
+		*val = osvw_status & ~(6ULL);
+
+		if (osvw_len == 0 && boot_cpu_data.x86 == 0x10)
+			/* Mark erratum 298 as present */
+			*val |= 1;
+	}
+
+	return 0;
+}
+
+
 static int has_svm(void)
 {
 	const char *msg;
@@ -620,6 +656,37 @@ static int svm_hardware_enable(void *garbage)
 		__get_cpu_var(current_tsc_ratio) = TSC_RATIO_DEFAULT;
 	}
 
+
+	/*
+	 * Get OSVW bits.
+	 *
+	 * Note that it is possible to have a system with mixed processor
+	 * revisions and therefore different OSVW bits. If bits are not the same
+	 * on different processors then choose the worst case (i.e. if erratum
+	 * is present on one processor and not on another then assume that the
+	 * erratum is present everywhere).
+	 */
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_OSVW)) {
+		uint64_t len, status;
+		int err;
+
+		len = native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &err);
+		if (!err)
+			status = native_read_msr_safe(MSR_AMD64_OSVW_STATUS,
+						      &err);
+
+		spin_lock(&svm_lock);
+		if (err)
+			osvw_status = osvw_len = 0;
+		else {
+			if (len < osvw_len)
+				osvw_len = len;
+			osvw_status |= status;
+			osvw_status &= (1ULL << osvw_len) - 1;
+		}
+		spin_unlock(&svm_lock);
+	}
+
 	svm_init_erratum_383();
 
 	return 0;
@@ -2982,6 +3049,9 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 	case MSR_IA32_UCODE_REV:
 		*data = 0x01000065;
 		break;
+	case MSR_AMD64_OSVW_ID_LENGTH:
+	case MSR_AMD64_OSVW_STATUS:
+		return svm_handle_osvw(vcpu, ecx, data);
 	default:
 		return kvm_get_msr_common(vcpu, ecx, data);
 	}
@@ -3092,6 +3162,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 	case MSR_VM_IGNNE:
 		pr_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
 		break;
+	case MSR_AMD64_OSVW_ID_LENGTH:
+	case MSR_AMD64_OSVW_STATUS:
+		/* Writes are ignored */
+		break;
 	default:
 		return kvm_set_msr_common(vcpu, ecx, data);
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c38efd7..0a84162 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2452,7 +2452,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	const u32 kvm_supported_word6_x86_features =
 		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
-		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(XOP) |
+		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
 		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM);
 
 	/* cpuid 0xC0000001.edx */
-- 
1.7.3.4

