Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab0LCMP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:15:28 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:5272 "EHLO
	VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932355Ab0LCMP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:15:27 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK98dNzz1202hzz8275bh15d4Rz32i691h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCUQ1H-01-15Q-02
X-M-MSG: 
Date: Fri, 3 Dec 2010 13:15:21 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/12] KVM: SVM: Add clean-bits infrastructure code
Message-ID: <20101203121521.GA4936@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
 <1291373159-4822-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1291373159-4822-2-git-send-email-joerg.roedel@amd.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 05:45:48AM -0500, Joerg Roedel wrote:
> +enum {
> +	VMCB_CLEAN_MAX,
> +};

This is a left-over from an earlier version. I forgot to remove it. Here
is an updated patch. Sorry.


>From 7e3f4f175561429d0054daac94763e67d12424ba Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Wed, 1 Dec 2010 12:01:08 +0100
Subject: [PATCH 01/12] KVM: SVM: Add clean-bits infrastructure code

This patch adds the infrastructure for the implementation of
the individual clean-bits.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/svm.h |    3 ++-
 arch/x86/kvm/svm.c         |   31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 11dbca7..235dd73 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -79,7 +79,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 event_inj_err;
 	u64 nested_cr3;
 	u64 lbr_ctl;
-	u64 reserved_5;
+	u32 clean;
+	u32 reserved_5;
 	u64 next_rip;
 	u8 reserved_6[816];
 };
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c00ea90..3ee59b0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -185,6 +185,28 @@ static int nested_svm_vmexit(struct vcpu_svm *svm);
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code);
 
+enum {
+	VMCB_DIRTY_MAX,
+};
+
+#define VMCB_ALWAYS_DIRTY_MASK	0U
+
+static inline void mark_all_dirty(struct vmcb *vmcb)
+{
+	vmcb->control.clean = 0;
+}
+
+static inline void mark_all_clean(struct vmcb *vmcb)
+{
+	vmcb->control.clean = ((1 << VMCB_DIRTY_MAX) - 1)
+			       & ~VMCB_ALWAYS_DIRTY_MASK;
+}
+
+static inline void mark_dirty(struct vmcb *vmcb, int bit)
+{
+	vmcb->control.clean &= ~(1 << bit);
+}
+
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
@@ -973,6 +995,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		set_intercept(svm, INTERCEPT_PAUSE);
 	}
 
+	mark_all_dirty(svm->vmcb);
+
 	enable_gif(svm);
 }
 
@@ -1089,6 +1113,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	if (unlikely(cpu != vcpu->cpu)) {
 		svm->asid_generation = 0;
+		mark_all_dirty(svm->vmcb);
 	}
 
 #ifdef CONFIG_X86_64
@@ -2139,6 +2164,8 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
 
+	mark_all_dirty(svm->vmcb);
+
 	nested_svm_unmap(page);
 
 	nested_svm_uninit_mmu_context(&svm->vcpu);
@@ -2350,6 +2377,8 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	enable_gif(svm);
 
+	mark_all_dirty(svm->vmcb);
+
 	return true;
 }
 
@@ -3487,6 +3516,8 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->vmcb->control.exit_code ==
 		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
 		svm_handle_mce(svm);
+
+	mark_all_clean(svm->vmcb);
 }
 
 #undef R
-- 
1.7.1

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

