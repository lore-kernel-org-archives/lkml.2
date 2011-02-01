Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1BATS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:18:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab1BATSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:18:18 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH v2] release kvmclock page on reset
Date: Tue,  1 Feb 2011 14:16:40 -0500
Message-Id: <1296587800-19589-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a vcpu is reset, kvmclock page keeps being writen to this days.
This is wrong and inconsistent: a cpu reset should take it to its
initial state.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/x86/kvm/x86.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bcc0efc..c39ab4a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1453,6 +1453,14 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
+static void kvmclock_reset(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.time_page) {
+		kvm_release_page_dirty(vcpu->arch.time_page);
+		vcpu->arch.time_page = NULL;
+	}
+}
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	switch (msr) {
@@ -1510,10 +1518,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 	case MSR_KVM_SYSTEM_TIME: {
-		if (vcpu->arch.time_page) {
-			kvm_release_page_dirty(vcpu->arch.time_page);
-			vcpu->arch.time_page = NULL;
-		}
+		kvmclock_reset(vcpu);
 
 		vcpu->arch.time = data;
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -5814,10 +5819,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.time_page) {
-		kvm_release_page_dirty(vcpu->arch.time_page);
-		vcpu->arch.time_page = NULL;
-	}
+	kvmclock_reset(vcpu);
 
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	fx_free(vcpu);
@@ -5878,6 +5880,8 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	vcpu->arch.apf.msr_val = 0;
 
+	kvmclock_reset(vcpu);
+
 	kvm_clear_async_pf_completion_queue(vcpu);
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
-- 
1.7.2.3

