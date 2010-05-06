Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab0EFJjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:39:08 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:36393 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab0EFJjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:39:04 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz98dN936eMab9bhzz1202hzz6ff19hz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1ZS4J-01-6A1-02
X-M-MSG: 
Date: Thu, 6 May 2010 11:38:43 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "Przywara, Andre" <Andre.Przywara@amd.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] KVM: SVM: Allow EFER.LMSLE to be set with nested
 svm
Message-ID: <20100506093842.GE7515@amd.com>
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
 <1273068285-3105-5-git-send-email-joerg.roedel@amd.com>
 <4BE184E3.1010508@redhat.com>
 <4BE1DB9C.7000405@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BE1DB9C.7000405@amd.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 04:57:00PM -0400, Przywara, Andre wrote:

> If I understood this correctly, there is a bug somewhere, maybe even in 
> KVM's nested SVM implementation. Xen is fine with this bit-set provoking 
> a #GP. I haven't had time yet to further investigate this, though.

Ok, I looked at this again and reproduced the traces I already deleted
and fetched the Xen crash message and found something I missed before.
The relevant part of the KVM trace is:

 qemu-system-x86-7364  [012]   790.715351: kvm_exit: reason msr rip 0xffff82c4801b5c93
 qemu-system-x86-7364  [012]   790.715352: kvm_msr: msr_write c0000080 = 0x3d01
 qemu-system-x86-7364  [012]   790.715354: kvm_inj_exception: #GP (0x0)

And the Xen-Crash message is:

(XEN) Xen call trace:
(XEN)    [<ffff82c4801b5c95>] svm_cpu_up+0x135/0x200
(XEN)    [<ffff82c4801b5d9c>] start_svm+0x3c/0xe0
(XEN)    [<ffff82c4801948b2>] identify_cpu+0xd2/0x240
(XEN)    [<ffff82c480252c6b>] __start_xen+0x1dbb/0x3660
(XEN)    [<ffff82c4801000b5>] __high_start+0xa1/0xa3
(XEN)    
(XEN) 
(XEN) ****************************************
(XEN) Panic on CPU 0:
(XEN) GENERAL PROTECTION FAULT
(XEN) [error_code=0000]
(XEN) ****************************************

The MSR write happens on rip 0xffff82c4801b5c93 while the #GP is
injected at rip ffff82c4801b5c95 (== right after the wrmsr instruction).
So yes, there is another bug in KVM here. The problem is that the
set_efer function does not report write errors to ist caller and injects
the #GP directly. The svm:wrmsr_interception recognizes a success and
advances the rip.
The attached patch fixes this.

>From e0d69cf7a396d35ae9aa4778e87f82c243bfa0ae Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 6 May 2010 11:07:46 +0200
Subject: [PATCH] KVM: X86: Inject #GP with the right rip on efer writes

This patch fixes a bug in the KVM efer-msr write path. If a
guest writes to a reserved efer bit the set_efer function
injects the #GP directly. The architecture dependent wrmsr
function does not see this, assumes success and advances the
rip. This results in a #GP in the guest with the wrong rip.
This patch fixes this by reporting efer write errors back to
the architectural wrmsr function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c |   31 ++++++++++++-------------------
 1 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c83528e..5bd7b30 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -683,37 +683,29 @@ static u32 emulated_msrs[] = {
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
 
 	kvm_x86_ops->set_efer(vcpu, efer);
@@ -725,6 +717,8 @@ static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	vcpu->arch.mmu.base_role.nxe = (efer & EFER_NX) && !tdp_enabled;
 	kvm_mmu_reset_context(vcpu);
+
+	return 0;
 }
 
 void kvm_enable_efer_bits(u64 mask)
@@ -1145,8 +1139,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	switch (msr) {
 	case MSR_EFER:
-		set_efer(vcpu, data);
-		break;
+		return set_efer(vcpu, data);
 	case MSR_K7_HWCR:
 		data &= ~(u64)0x40;	/* ignore flush filter disable */
 		data &= ~(u64)0x100;	/* ignore ignne emulation enable */
-- 
1.7.1



