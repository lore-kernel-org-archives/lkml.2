Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986Ab0GAV0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:26:53 -0400
Received: from kroah.org ([198.145.64.141]:33287 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933196Ab0GAVPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:41 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:03 2010
Message-Id: <20100701174303.143665343@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [197/200] KVM: x86: Inject #GP with the right rip on efer writes
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

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

(Cherry-picked from commit b69e8caef5b190af48c525f6d715e7b7728a77f6)
---
 arch/x86/kvm/x86.c |   31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -624,37 +624,29 @@ static u32 emulated_msrs[] = {
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
-	    && (vcpu->arch.efer & EFER_LME) != (efer & EFER_LME)) {
-		kvm_inject_gp(vcpu, 0);
-		return;
-	}
+	    && (vcpu->arch.efer & EFER_LME) != (efer & EFER_LME))
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
@@ -666,6 +658,8 @@ static void set_efer(struct kvm_vcpu *vc
 
 	vcpu->arch.mmu.base_role.nxe = (efer & EFER_NX) && !tdp_enabled;
 	kvm_mmu_reset_context(vcpu);
+
+	return 0;
 }
 
 void kvm_enable_efer_bits(u64 mask)
@@ -1094,8 +1088,7 @@ int kvm_set_msr_common(struct kvm_vcpu *
 {
 	switch (msr) {
 	case MSR_EFER:
-		set_efer(vcpu, data);
-		break;
+		return set_efer(vcpu, data);
 	case MSR_K7_HWCR:
 		data &= ~(u64)0x40;	/* ignore flush filter disable */
 		if (data != 0) {


