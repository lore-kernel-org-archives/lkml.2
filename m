Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1AFKLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:11:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1AFKLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:11:05 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, linux-kernel@vger.kernel.org
Subject: [KVM TSC trapping / migration 2/2] Add TSC KHZ MSR
Date: Thu,  6 Jan 2011 00:10:45 -1000
Message-Id: <1294308645-31113-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1294308645-31113-1-git-send-email-zamsden@redhat.com>
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use an MSR to allow "soft" migration to hosts which do not support
TSC trapping.  Rather than make this a required element of any
migration protocol, we allow the TSC rate to be exported as a data
field (useful in its own right), but we also allow a one time write
of the MSR during VM creation.  The result is that for the common
use case, no protocol change is required to communicate TSC rate
to the receiving host.

This allows administrative tools to configure migration policy
as they see appropriate.  Rather than dictate this policy with the
KVM implementation, we properly allow migration to hosts which both
do and do not support setting of the TSC rate on the receiving end.
If it is wished to not support migration to a host which lacks
support for the TSC rate feature, that can be coordinated externally.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |    1 +
 arch/x86/kvm/x86.c              |   28 ++++++++++++++++++++++++++--
 include/linux/kvm.h             |    1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 7b562b6..723e60d 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -32,6 +32,7 @@
 /* Custom MSRs falls in the range 0x4b564d00-0x4b564dff */
 #define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
 #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
+#define MSR_KVM_TSC_KHZ		0x4b564d02
 
 #define KVM_MAX_MMU_OP_BATCH           32
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbcd582..ff5addc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -786,10 +786,11 @@ EXPORT_SYMBOL_GPL(kvm_get_dr);
  * kvm-specific. Those are put in the beginning of the list.
  */
 
-#define KVM_SAVE_MSRS_BEGIN	7
+#define KVM_SAVE_MSRS_BEGIN	8
 static u32 msrs_to_save[] = {
 	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
 	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
+	MSR_KVM_TSC_KHZ,
 	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
 	HV_X64_MSR_APIC_ASSIST_PAGE,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
@@ -1608,6 +1609,25 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		}
 		break;
 	}
+	case MSR_KVM_TSC_KHZ: {
+		struct kvm_arch *arch = &vcpu->kvm->arch;
+		/*
+		 * If userspace indicates a fixed rate TSC, accept attempts
+		 * to set the TSC rate to support incoming migrations.
+		 * This is a write once MSR, to prevent guest tampering.
+		 */
+		if (arch->tsc_flags & KVM_TSC_FLAG_KHZ_MSR_WRITABLE) {
+			if (data > KVM_TSC_MAX_KHZ || data < KVM_TSC_MIN_KHZ)
+				return 1;
+
+			spin_lock(&arch->clock_lock);
+			kvm_arch_set_tsc_khz(vcpu->kvm, data);
+			kvm_setup_tsc_trapping(vcpu);
+			arch->tsc_flags &= ~KVM_TSC_FLAG_KHZ_MSR_WRITABLE;
+			spin_unlock(&arch->clock_lock);
+		}
+		break;
+	}
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
@@ -1884,6 +1904,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_KVM_SYSTEM_TIME_NEW:
 		data = vcpu->arch.time;
 		break;
+	case MSR_KVM_TSC_KHZ:
+		data = vcpu->kvm->arch.virtual_tsc_khz;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -3615,7 +3638,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -EINVAL;
 		if (user_tsc.flags &
 		    ~(KVM_TSC_FLAG_FIXED_RATE |
-		      KVM_TSC_FLAG_SMP_COHERENCY))
+		      KVM_TSC_FLAG_SMP_COHERENCY |
+		      KVM_TSC_FLAG_KHZ_MSR_WRITABLE))
 			goto out;
 
 		if (user_tsc.tsc_khz &&
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index cb97e53..0e316d8 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -628,6 +628,7 @@ struct kvm_tsc_control {
 
 #define KVM_TSC_FLAG_FIXED_RATE		(1 << 0)
 #define KVM_TSC_FLAG_SMP_COHERENCY	(1 << 1)
+#define KVM_TSC_FLAG_KHZ_MSR_WRITABLE	(1 << 2)
 
 #define KVM_TSC_MIN_KHZ 16000		/* 16 MHz, slower than first Pentium */
 #define KVM_TSC_MAX_KHZ 100000000	/* 100 GHz, good for a few years */
-- 
1.7.1

