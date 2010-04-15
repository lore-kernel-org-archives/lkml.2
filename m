Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab0DOSjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:39:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab0DOSjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:39:09 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH 2/5] change msr numbers for kvmclock
Date: Thu, 15 Apr 2010 14:37:25 -0400
Message-Id: <1271356648-5108-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1271356648-5108-2-git-send-email-glommer@redhat.com>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
 <1271356648-5108-2-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi pointed out a while ago that those MSRs falls into the pentium
PMU range. So the idea here is to add new ones, and after a while,
deprecate the old ones.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |    8 ++++++--
 arch/x86/kvm/x86.c              |    7 ++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index ffae142..0cffb96 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -17,8 +17,12 @@
 #define KVM_FEATURE_NOP_IO_DELAY	1
 #define KVM_FEATURE_MMU_OP		2
 
-#define MSR_KVM_WALL_CLOCK  0x11
-#define MSR_KVM_SYSTEM_TIME 0x12
+#define MSR_KVM_WALL_CLOCK_OLD  0x11
+#define MSR_KVM_SYSTEM_TIME_OLD 0x12
+
+/* Custom MSRs falls in the range 0x4b564d00-0x4b564dff */
+#define MSR_KVM_WALL_CLOCK  0x4b564d00
+#define MSR_KVM_SYSTEM_TIME 0x4b564d01
 
 #define KVM_MAX_MMU_OP_BATCH           32
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8824b73..714aae2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -575,9 +575,10 @@ static inline u32 bit(int bitno)
  * kvm-specific. Those are put in the beginning of the list.
  */
 
-#define KVM_SAVE_MSRS_BEGIN	5
+#define KVM_SAVE_MSRS_BEGIN	7
 static u32 msrs_to_save[] = {
 	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
+	MSR_KVM_SYSTEM_TIME_OLD, MSR_KVM_WALL_CLOCK_OLD,
 	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
 	HV_X64_MSR_APIC_ASSIST_PAGE,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
@@ -1099,10 +1100,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	case MSR_IA32_MISC_ENABLE:
 		vcpu->arch.ia32_misc_enable_msr = data;
 		break;
+	case MSR_KVM_WALL_CLOCK_OLD:
 	case MSR_KVM_WALL_CLOCK:
 		vcpu->kvm->arch.wall_clock = data;
 		kvm_write_wall_clock(vcpu->kvm, data);
 		break;
+	case MSR_KVM_SYSTEM_TIME_OLD:
 	case MSR_KVM_SYSTEM_TIME: {
 		if (vcpu->arch.time_page) {
 			kvm_release_page_dirty(vcpu->arch.time_page);
@@ -1374,9 +1377,11 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		data = vcpu->arch.efer;
 		break;
 	case MSR_KVM_WALL_CLOCK:
+	case MSR_KVM_WALL_CLOCK_OLD:
 		data = vcpu->kvm->arch.wall_clock;
 		break;
 	case MSR_KVM_SYSTEM_TIME:
+	case MSR_KVM_SYSTEM_TIME_OLD:
 		data = vcpu->arch.time;
 		break;
 	case MSR_IA32_P5_MC_ADDR:
-- 
1.6.2.2

