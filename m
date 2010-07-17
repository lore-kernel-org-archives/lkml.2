Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956Ab0GQNDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 09:03:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52139 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab0GQNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 09:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ccn3Xk+CO5Y4GFlklEeA9ig6cBxxgtZTXeahlPW1b9+gnTDiPpSrUqpV2Dsyp1QFYB
         Ym/7ysb5MMH1kdEV5uAvqV76cBg7+sWNk3tevrklGUYlfvAYDhSmbgpcCoe6USGK0jXa
         B4kk0OqyxTHYsnROuapB7i9lvm6OT9ZFRKvWQ=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: Remove redundant K6 MSRs
Date: Sat, 17 Jul 2010 09:03:26 -0400
Message-Id: <1279371808-24804-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSR_K6_EFER is unused, and MSR_K6_STAR is redundant with MSR_STAR.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/msr-index.h |    2 --
 arch/x86/kvm/svm.c               |    6 +++---
 arch/x86/kvm/vmx.c               |    8 ++++----
 arch/x86/kvm/x86.c               |    2 +-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7bc36f6..f553151 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -156,8 +156,6 @@
 #define MSR_K7_FID_VID_STATUS		0xc0010042
 
 /* K6 MSRs */
-#define MSR_K6_EFER			0xc0000080
-#define MSR_K6_STAR			0xc0000081
 #define MSR_K6_WHCR			0xc0000082
 #define MSR_K6_UWCCR			0xc0000085
 #define MSR_K6_EPMR			0xc0000086
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ce438e0..24a2206 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -130,7 +130,7 @@ static struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
 	bool always; /* True if intercept is always on */
 } direct_access_msrs[] = {
-	{ .index = MSR_K6_STAR,				.always = true  },
+	{ .index = MSR_STAR,				.always = true  },
 	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
 #ifdef CONFIG_X86_64
 	{ .index = MSR_GS_BASE,				.always = true  },
@@ -2431,7 +2431,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 		*data = tsc_offset + native_read_tsc();
 		break;
 	}
-	case MSR_K6_STAR:
+	case MSR_STAR:
 		*data = svm->vmcb->save.star;
 		break;
 #ifdef CONFIG_X86_64
@@ -2555,7 +2555,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 
 		break;
 	}
-	case MSR_K6_STAR:
+	case MSR_STAR:
 		svm->vmcb->save.star = data;
 		break;
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 859a01a..51555f6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -231,14 +231,14 @@ static u64 host_efer;
 static void ept_save_pdptrs(struct kvm_vcpu *vcpu);
 
 /*
- * Keep MSR_K6_STAR at the end, as setup_msrs() will try to optimize it
+ * Keep MSR_STAR at the end, as setup_msrs() will try to optimize it
  * away by decrementing the array size.
  */
 static const u32 vmx_msr_index[] = {
 #ifdef CONFIG_X86_64
 	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
 #endif
-	MSR_EFER, MSR_TSC_AUX, MSR_K6_STAR,
+	MSR_EFER, MSR_TSC_AUX, MSR_STAR,
 };
 #define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
@@ -1057,10 +1057,10 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		if (index >= 0 && vmx->rdtscp_enabled)
 			move_msr_up(vmx, index, save_nmsrs++);
 		/*
-		 * MSR_K6_STAR is only needed on long mode guests, and only
+		 * MSR_STAR is only needed on long mode guests, and only
 		 * if efer.sce is enabled.
 		 */
-		index = __find_msr_index(vmx, MSR_K6_STAR);
+		index = __find_msr_index(vmx, MSR_STAR);
 		if ((index >= 0) && (vmx->vcpu.arch.efer & EFER_SCE))
 			move_msr_up(vmx, index, save_nmsrs++);
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05d571f..6127468 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -671,7 +671,7 @@ static u32 msrs_to_save[] = {
 	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
 	HV_X64_MSR_APIC_ASSIST_PAGE,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
-	MSR_K6_STAR,
+	MSR_STAR,
 #ifdef CONFIG_X86_64
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
-- 
1.7.1.1

