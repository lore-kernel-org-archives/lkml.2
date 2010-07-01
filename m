Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab0GAS0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:26:35 -0400
Received: from kroah.org ([198.145.64.141]:40864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758171Ab0GASYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:33 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:18 2010
Message-Id: <20100701173218.799346610@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 142/149] KVM: x86: Inject #GP with the right rip on efer writes
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roedel, Joerg <Joerg.Roedel@amd.com>

This patch fixes a bug in the KVM efer-msr write path. If a
guest writes to a reserved efer bit the set_efer function
injects the #GP directly. The architecture dependent wrmsr
function does not see this, assumes success and advances the
rip. This results in a #GP in the guest with the wrong rip.
This patch fixes this by reporting efer write errors back to
the architectural wrmsr function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
(cherry picked from commit b69e8caef5b190af48c525f6d715e7b7728a77f6)
---
 arch/x86/kvm/x86.c |   31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -483,37 +483,29 @@ static u32 emulated_msrs[] = {
 	MSR_IA32_MISC_ENABLE,
 };
 
-static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
+static int set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
-	if (efer & efer_reserved_bits) {
-		kvm_inject_gp(vcpu, 0);
-		return;
-	}
+	if (efer & efer_reserved_bits)
+		return 1;
 
 	if (is_paging(vcpu)
-	    && (vcpu->arch.shadow_efer & EFER_LME) != (efer & EFER_LME)) {
-		kvm_inject_gp(vcpu, 0);
-		return;
-	}
+	    && (vcpu->arch.shadow_efer & EFER_LME) != (efer & EFER_LME))
+		return 1;
 
 	if (efer & EFER_FFXSR) {
 		struct kvm_cpuid_entry2 *feat;
 
 		feat = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
-		if (!feat || !(feat->edx & bit(X86_FEATURE_FXSR_OPT))) {
-			kvm_inject_gp(vcpu, 0);
-			return;
-		}
+		if (!feat || !(feat->edx & bit(X86_FEATURE_FXSR_OPT)))
+			return 1;
 	}
 
 	if (efer & EFER_SVME) {
 		struct kvm_cpuid_entry2 *feat;
 
 		feat = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
-		if (!feat || !(feat->ecx & bit(X86_FEATURE_SVM))) {
-			kvm_inject_gp(vcpu, 0);
-			return;
-		}
+		if (!feat || !(feat->ecx & bit(X86_FEATURE_SVM)))
+			return 1;
 	}
 
 	efer &= ~EFER_LMA;
@@ -525,6 +517,8 @@ static void set_efer(struct kvm_vcpu *vc
 
 	vcpu->arch.mmu.base_role.nxe = (efer & EFER_NX) && !tdp_enabled;
 	kvm_mmu_reset_context(vcpu);
+
+	return 0;
 }
 
 void kvm_enable_efer_bits(u64 mask)
@@ -827,8 +821,7 @@ int kvm_set_msr_common(struct kvm_vcpu *
 {
 	switch (msr) {
 	case MSR_EFER:
-		set_efer(vcpu, data);
-		break;
+		return set_efer(vcpu, data);
 	case MSR_K7_HWCR:
 		data &= ~(u64)0x40;	/* ignore flush filter disable */
 		if (data != 0) {


