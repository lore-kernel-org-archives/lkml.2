Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1BIRaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:30:00 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:43722 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab1BIR35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:29:57 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGD1XP-01-3VN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/6] KVM: X86: Implement userspace interface to set virtual_tsc_khz
Date: Wed, 9 Feb 2011 18:29:44 +0100
Message-ID: <1297272584-22689-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements two new vm-ioctls to get and set the
virtual_tsc_khz if the machine supports tsc-scaling. Setting
the tsc-frequency is only possible before userspace creates
any vcpu.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/svm.c              |    3 +++
 arch/x86/kvm/x86.c              |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/kvm.h             |    4 ++++
 4 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8c40425..dfdd0aa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -633,6 +633,7 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 extern bool tdp_enabled;
+extern int kvm_has_tsc_control;
 
 enum emulation_result {
 	EMULATE_DONE,       /* no further processing */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f938585..0b8f4f7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -797,6 +797,9 @@ static __init int svm_hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
 		kvm_enable_efer_bits(EFER_FFXSR);
 
+	if (boot_cpu_has(X86_FEATURE_TSCRATEMSR))
+		kvm_has_tsc_control = 1;
+
 	if (nested) {
 		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
 		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6caaf4b..1ac94cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -99,6 +99,9 @@ EXPORT_SYMBOL_GPL(kvm_x86_ops);
 int ignore_msrs = 0;
 module_param_named(ignore_msrs, ignore_msrs, bool, S_IRUGO | S_IWUSR);
 
+int kvm_has_tsc_control;
+EXPORT_SYMBOL_GPL(kvm_has_tsc_control);
+
 #define KVM_NR_SHARED_MSRS 16
 
 struct kvm_shared_msrs_global {
@@ -2024,6 +2027,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_XCRS:
 		r = cpu_has_xsave;
 		break;
+	case KVM_CAP_TSC_CONTROL:
+		r = kvm_has_tsc_control;
+		break;
 	default:
 		r = 0;
 		break;
@@ -3575,6 +3581,38 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_SET_TSC_KHZ: {
+		u32 user_tsc_khz;
+
+		if (!kvm_has_tsc_control)
+			break;
+
+		/*
+		 * We force the tsc frequency to be set before any
+		 * vcpu is created
+		 */
+		if (atomic_read(&kvm->online_vcpus) > 0)
+			goto out;
+
+		user_tsc_khz = arg;
+
+		kvm_arch_set_tsc_khz(kvm, user_tsc_khz);
+
+		r = 0;
+		goto out;
+	}
+	case KVM_GET_TSC_KHZ: {
+
+		if (!kvm_has_tsc_control)
+			break;
+
+		r = -EFAULT;
+		if (copy_to_user(argp, &kvm->arch.virtual_tsc_khz, sizeof(__u32)))
+			goto out;
+
+		r = 0;
+		goto out;
+	}
 
 	default:
 		;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ea2dc1a..a96ff92 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -541,6 +541,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_PPC_GET_PVINFO 57
 #define KVM_CAP_PPC_IRQ_LEVEL 58
 #define KVM_CAP_ASYNC_PF 59
+#define KVM_CAP_TSC_CONTROL 60
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -677,6 +678,9 @@ struct kvm_clock_data {
 #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
 /* Available with KVM_CAP_PPC_GET_PVINFO */
 #define KVM_PPC_GET_PVINFO	  _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
+/* Available with KVM_CAP_TSC_CONTROL */
+#define KVM_SET_TSC_KHZ           _IOW(KVMIO,  0xa2, __u32)
+#define KVM_GET_TSC_KHZ           _IOR(KVMIO,  0xa3, __u32)
 
 /*
  * ioctls for vcpu fds
-- 
1.7.1


