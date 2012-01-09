Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab2AITAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:00:54 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:47573 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab2AITAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:00:53 -0500
From: Boris Ostrovsky <ostr@amd64.org>
To: avi@redhat.com, mtosatti@redhat.com, Joerg.Roedel@amd.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, boris.ostrovsky@amd.com
Subject: [PATCH v2.2] KVM: SVM: Add support for AMD's OSVW feature in guests
Date: Mon,  9 Jan 2012 14:00:35 -0500
Message-Id: <1326135635-10756-1-git-send-email-ostr@amd64.org>
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
---
 arch/x86/include/asm/kvm_host.h |    6 ++++
 arch/x86/kvm/cpuid.c            |    2 +-
 arch/x86/kvm/cpuid.h            |    8 +++++
 arch/x86/kvm/svm.c              |   59 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |   20 +++++++++++++
 5 files changed, 94 insertions(+), 1 deletions(-)

Now generated against KVM tree.

-boris

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 52d6640..bd69c93 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -478,6 +478,12 @@ struct kvm_vcpu_arch {
 		u32 id;
 		bool send_user_only;
 	} apf;
+
+	/* OSVW MSRs (AMD only) */
+	struct {
+		u64 length;
+		u64 status;
+	} osvw;
 };
 
 struct kvm_arch {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 89b02bf..9fed5be 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -236,7 +236,7 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	const u32 kvm_supported_word6_x86_features =
 		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
-		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(XOP) |
+		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
 		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM);
 
 	/* cpuid 0xC0000001.edx */
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 5b97e17..26d1fb4 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -43,4 +43,12 @@ static inline bool guest_cpuid_has_fsgsbase(struct kvm_vcpu *vcpu)
 	return best && (best->ebx & bit(X86_FEATURE_FSGSBASE));
 }
 
+static inline bool guest_cpuid_has_osvw(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
+	return best && (best->ecx & bit(X86_FEATURE_OSVW));
+}
+
 #endif
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5fa553b..249cbdc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -110,6 +110,12 @@ struct nested_state {
 #define MSRPM_OFFSETS	16
 static u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 
+/*
+ * Set osvw_len to higher value when updated Revision Guides
+ * are published and we know what the new status bits are
+ */
+static uint64_t osvw_len = 4, osvw_status;
+
 struct vcpu_svm {
 	struct kvm_vcpu vcpu;
 	struct vmcb *vmcb;
@@ -556,6 +562,27 @@ static void svm_init_erratum_383(void)
 	erratum_383_found = true;
 }
 
+static void svm_init_osvw(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Guests should see errata 400 and 415 as fixed (assuming that
+	 * HLT and IO instructions are intercepted).
+	 */
+	vcpu->arch.osvw.length = (osvw_len >= 3) ? (osvw_len) : 3;
+	vcpu->arch.osvw.status = osvw_status & ~(6ULL);
+
+	/*
+	 * By increasing VCPU's osvw.length to 3 we are telling the guest that
+	 * all osvw.status bits inside that length, including bit 0 (which is
+	 * reserved for erratum 298), are valid. However, if host processor's
+	 * osvw_len is 0 then osvw_status[0] carries no information. We need to
+	 * be conservative here and therefore we tell the guest that erratum 298
+	 * is present (because we really don't know).
+	 */
+	if (osvw_len == 0 && boot_cpu_data.x86 == 0x10)
+		vcpu->arch.osvw.status |= 1;
+}
+
 static int has_svm(void)
 {
 	const char *msg;
@@ -620,6 +647,36 @@ static int svm_hardware_enable(void *garbage)
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
+		if (err)
+			osvw_status = osvw_len = 0;
+		else {
+			if (len < osvw_len)
+				osvw_len = len;
+			osvw_status |= status;
+			osvw_status &= (1ULL << osvw_len) - 1;
+		}
+	} else
+		osvw_status = osvw_len = 0;
+
 	svm_init_erratum_383();
 
 	return 0;
@@ -1186,6 +1243,8 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (kvm_vcpu_is_bsp(&svm->vcpu))
 		svm->vcpu.arch.apic_base |= MSR_IA32_APICBASE_BSP;
 
+	svm_init_osvw(&svm->vcpu);
+
 	return &svm->vcpu;
 
 free_page4:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1171def..9f0d081 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1661,6 +1661,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		 */
 		pr_unimpl(vcpu, "ignored wrmsr: 0x%x data %llx\n", msr, data);
 		break;
+	case MSR_AMD64_OSVW_ID_LENGTH:
+		if (!guest_cpuid_has_osvw(vcpu))
+			return 1;
+		vcpu->arch.osvw.length = data;
+		break;
+	case MSR_AMD64_OSVW_STATUS:
+		if (!guest_cpuid_has_osvw(vcpu))
+			return 1;
+		vcpu->arch.osvw.status = data;
+		break;
 	default:
 		if (msr && (msr == vcpu->kvm->arch.xen_hvm_config.msr))
 			return xen_hvm_config(vcpu, data);
@@ -1937,6 +1947,16 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		 */
 		data = 0xbe702111;
 		break;
+	case MSR_AMD64_OSVW_ID_LENGTH:
+		if (!guest_cpuid_has_osvw(vcpu))
+			return 1;
+		data = vcpu->arch.osvw.length;
+		break;
+	case MSR_AMD64_OSVW_STATUS:
+		if (!guest_cpuid_has_osvw(vcpu))
+			return 1;
+		data = vcpu->arch.osvw.status;
+		break;
 	default:
 		if (kvm_pmu_msr(vcpu, msr))
 			return kvm_pmu_get_msr(vcpu, msr, pdata);
-- 
1.7.3.4

