Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab0EKQXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:23:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0EKQVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:21:24 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com
Subject: [PATCH 3/9] change msr numbers for kvmclock
Date: Tue, 11 May 2010 12:17:41 -0400
Message-Id: <1273594667-17175-4-git-send-email-glommer@redhat.com>
In-Reply-To: <1273594667-17175-3-git-send-email-glommer@redhat.com>
References: <1273594667-17175-1-git-send-email-glommer@redhat.com>
 <1273594667-17175-2-git-send-email-glommer@redhat.com>
 <1273594667-17175-3-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi pointed out a while ago that those MSRs falls into the pentium
PMU range. So the idea here is to add new ones, and after a while,
deprecate the old ones.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |    4 ++++
 arch/x86/kvm/x86.c              |    7 ++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index ffae142..9734808 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -20,6 +20,10 @@
 #define MSR_KVM_WALL_CLOCK  0x11
 #define MSR_KVM_SYSTEM_TIME 0x12
 
+/* Custom MSRs falls in the range 0x4b564d00-0x4b564dff */
+#define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
+#define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
+
 #define KVM_MAX_MMU_OP_BATCH           32
 
 /* Operations for KVM_HC_MMU_OP */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6b2ce1d..eb84947 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -664,9 +664,10 @@ static inline u32 bit(int bitno)
  * kvm-specific. Those are put in the beginning of the list.
  */
 
-#define KVM_SAVE_MSRS_BEGIN	5
+#define KVM_SAVE_MSRS_BEGIN	7
 static u32 msrs_to_save[] = {
 	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
+	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
 	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
 	HV_X64_MSR_APIC_ASSIST_PAGE,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
@@ -1192,10 +1193,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	case MSR_IA32_MISC_ENABLE:
 		vcpu->arch.ia32_misc_enable_msr = data;
 		break;
+	case MSR_KVM_WALL_CLOCK_NEW:
 	case MSR_KVM_WALL_CLOCK:
 		vcpu->kvm->arch.wall_clock = data;
 		kvm_write_wall_clock(vcpu->kvm, data);
 		break;
+	case MSR_KVM_SYSTEM_TIME_NEW:
 	case MSR_KVM_SYSTEM_TIME: {
 		if (vcpu->arch.time_page) {
 			kvm_release_page_dirty(vcpu->arch.time_page);
@@ -1467,9 +1470,11 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		data = vcpu->arch.efer;
 		break;
 	case MSR_KVM_WALL_CLOCK:
+	case MSR_KVM_WALL_CLOCK_NEW:
 		data = vcpu->kvm->arch.wall_clock;
 		break;
 	case MSR_KVM_SYSTEM_TIME:
+	case MSR_KVM_SYSTEM_TIME_NEW:
 		data = vcpu->arch.time;
 		break;
 	case MSR_IA32_P5_MC_ADDR:
-- 
1.6.2.2

