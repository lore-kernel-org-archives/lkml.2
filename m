Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab0LCJvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:51:03 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:2602
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494Ab0LCJvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:51:00 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zzbb2cK1432N98dNzz1202hzz8275bh15d4Rz32i691h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LCUJCM-02-3EL-02
X-M-MSG: 
Date: Fri, 3 Dec 2010 10:50:51 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] KVM: SVM: Add manipulation functions for CRx
 intercepts
Message-ID: <20101203095051.GA2115@amd.com>
References: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
 <1291136641-4874-3-git-send-email-joerg.roedel@amd.com>
 <20101202164350.GB23017@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101202164350.GB23017@amt.cnet>
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

On Thu, Dec 02, 2010 at 11:43:50AM -0500, Marcelo Tosatti wrote:
> On Tue, Nov 30, 2010 at 06:03:57PM +0100, Joerg Roedel wrote:
> > -	control->intercept_cr_read =	INTERCEPT_CR0_MASK |
> > -					INTERCEPT_CR3_MASK |
> > -					INTERCEPT_CR4_MASK;
> > -
> > -	control->intercept_cr_write =	INTERCEPT_CR0_MASK |
> > -					INTERCEPT_CR3_MASK |
> > -					INTERCEPT_CR4_MASK |
> > -					INTERCEPT_CR8_MASK;
> > +	set_cr_intercept(svm, INTERCEPT_CR0_READ);
> > +	set_cr_intercept(svm, INTERCEPT_CR3_READ);
> > +	set_cr_intercept(svm, INTERCEPT_CR4_READ);
> > +	set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
> > +	set_cr_intercept(svm, INTERCEPT_CR3_WRITE);
> > +	set_cr_intercept(svm, INTERCEPT_CR4_WRITE);
> > +	set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
> 
> Should clear hflags before using is_guest_mode().

Right, thanks. Here is the updated patch.

>From 78e9a425d1440fdf9232e38dc3093127b96f26bb Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Tue, 30 Nov 2010 15:30:21 +0100
Subject: [PATCH 2/6] KVM: SVM: Add manipulation functions for CRx intercepts

This patch wraps changes to the CRx intercepts of SVM into
seperate functions to abstract nested-svm better and prepare
the implementation of the vmcb-clean-bits feature.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/svm.h |   15 +++--
 arch/x86/kvm/svm.c         |  120 +++++++++++++++++++++++--------------------
 2 files changed, 73 insertions(+), 62 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0e83105..39f9ddf 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -51,8 +51,7 @@ enum {
 
 
 struct __attribute__ ((__packed__)) vmcb_control_area {
-	u16 intercept_cr_read;
-	u16 intercept_cr_write;
+	u32 intercept_cr;
 	u16 intercept_dr_read;
 	u16 intercept_dr_write;
 	u32 intercept_exceptions;
@@ -204,10 +203,14 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_SELECTOR_READ_MASK SVM_SELECTOR_WRITE_MASK
 #define SVM_SELECTOR_CODE_MASK (1 << 3)
 
-#define INTERCEPT_CR0_MASK 1
-#define INTERCEPT_CR3_MASK (1 << 3)
-#define INTERCEPT_CR4_MASK (1 << 4)
-#define INTERCEPT_CR8_MASK (1 << 8)
+#define INTERCEPT_CR0_READ	0
+#define INTERCEPT_CR3_READ	3
+#define INTERCEPT_CR4_READ	4
+#define INTERCEPT_CR8_READ	8
+#define INTERCEPT_CR0_WRITE	(16 + 0)
+#define INTERCEPT_CR3_WRITE	(16 + 3)
+#define INTERCEPT_CR4_WRITE	(16 + 4)
+#define INTERCEPT_CR8_WRITE	(16 + 8)
 
 #define INTERCEPT_DR0_MASK 1
 #define INTERCEPT_DR1_MASK (1 << 1)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 05fe851..57c597b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -98,8 +98,7 @@ struct nested_state {
 	unsigned long vmexit_rax;
 
 	/* cache for intercepts of the guest */
-	u16 intercept_cr_read;
-	u16 intercept_cr_write;
+	u32 intercept_cr;
 	u16 intercept_dr_read;
 	u16 intercept_dr_write;
 	u32 intercept_exceptions;
@@ -204,14 +203,46 @@ static void recalc_intercepts(struct vcpu_svm *svm)
 	h = &svm->nested.hsave->control;
 	g = &svm->nested;
 
-	c->intercept_cr_read = h->intercept_cr_read | g->intercept_cr_read;
-	c->intercept_cr_write = h->intercept_cr_write | g->intercept_cr_write;
+	c->intercept_cr = h->intercept_cr | g->intercept_cr;
 	c->intercept_dr_read = h->intercept_dr_read | g->intercept_dr_read;
 	c->intercept_dr_write = h->intercept_dr_write | g->intercept_dr_write;
 	c->intercept_exceptions = h->intercept_exceptions | g->intercept_exceptions;
 	c->intercept = h->intercept | g->intercept;
 }
 
+static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
+{
+	if (is_guest_mode(&svm->vcpu))
+		return svm->nested.hsave;
+	else
+		return svm->vmcb;
+}
+
+static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	vmcb->control.intercept_cr |= (1U << bit);
+
+	recalc_intercepts(svm);
+}
+
+static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	vmcb->control.intercept_cr &= ~(1U << bit);
+
+	recalc_intercepts(svm);
+}
+
+static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	return vmcb->control.intercept_cr & (1U << bit);
+}
+
 static inline void enable_gif(struct vcpu_svm *svm)
 {
 	svm->vcpu.arch.hflags |= HF_GIF_MASK;
@@ -766,15 +797,15 @@ static void init_vmcb(struct vcpu_svm *svm)
 	struct vmcb_save_area *save = &svm->vmcb->save;
 
 	svm->vcpu.fpu_active = 1;
+	svm->vcpu.arch.hflags = 0;
 
-	control->intercept_cr_read =	INTERCEPT_CR0_MASK |
-					INTERCEPT_CR3_MASK |
-					INTERCEPT_CR4_MASK;
-
-	control->intercept_cr_write =	INTERCEPT_CR0_MASK |
-					INTERCEPT_CR3_MASK |
-					INTERCEPT_CR4_MASK |
-					INTERCEPT_CR8_MASK;
+	set_cr_intercept(svm, INTERCEPT_CR0_READ);
+	set_cr_intercept(svm, INTERCEPT_CR3_READ);
+	set_cr_intercept(svm, INTERCEPT_CR4_READ);
+	set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
+	set_cr_intercept(svm, INTERCEPT_CR3_WRITE);
+	set_cr_intercept(svm, INTERCEPT_CR4_WRITE);
+	set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	control->intercept_dr_read =	INTERCEPT_DR0_MASK |
 					INTERCEPT_DR1_MASK |
@@ -875,8 +906,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		control->intercept &= ~((1ULL << INTERCEPT_TASK_SWITCH) |
 					(1ULL << INTERCEPT_INVLPG));
 		control->intercept_exceptions &= ~(1 << PF_VECTOR);
-		control->intercept_cr_read &= ~INTERCEPT_CR3_MASK;
-		control->intercept_cr_write &= ~INTERCEPT_CR3_MASK;
+		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
+		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = 0x0007040600070406ULL;
 		save->cr3 = 0;
 		save->cr4 = 0;
@@ -1210,7 +1241,6 @@ static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 
 static void update_cr0_intercept(struct vcpu_svm *svm)
 {
-	struct vmcb *vmcb = svm->vmcb;
 	ulong gcr0 = svm->vcpu.arch.cr0;
 	u64 *hcr0 = &svm->vmcb->save.cr0;
 
@@ -1222,25 +1252,11 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
 
 
 	if (gcr0 == *hcr0 && svm->vcpu.fpu_active) {
-		vmcb->control.intercept_cr_read &= ~INTERCEPT_CR0_MASK;
-		vmcb->control.intercept_cr_write &= ~INTERCEPT_CR0_MASK;
-		if (is_guest_mode(&svm->vcpu)) {
-			struct vmcb *hsave = svm->nested.hsave;
-
-			hsave->control.intercept_cr_read  &= ~INTERCEPT_CR0_MASK;
-			hsave->control.intercept_cr_write &= ~INTERCEPT_CR0_MASK;
-			vmcb->control.intercept_cr_read  |= svm->nested.intercept_cr_read;
-			vmcb->control.intercept_cr_write |= svm->nested.intercept_cr_write;
-		}
+		clr_cr_intercept(svm, INTERCEPT_CR0_READ);
+		clr_cr_intercept(svm, INTERCEPT_CR0_WRITE);
 	} else {
-		svm->vmcb->control.intercept_cr_read |= INTERCEPT_CR0_MASK;
-		svm->vmcb->control.intercept_cr_write |= INTERCEPT_CR0_MASK;
-		if (is_guest_mode(&svm->vcpu)) {
-			struct vmcb *hsave = svm->nested.hsave;
-
-			hsave->control.intercept_cr_read |= INTERCEPT_CR0_MASK;
-			hsave->control.intercept_cr_write |= INTERCEPT_CR0_MASK;
-		}
+		set_cr_intercept(svm, INTERCEPT_CR0_READ);
+		set_cr_intercept(svm, INTERCEPT_CR0_WRITE);
 	}
 }
 
@@ -1900,15 +1916,9 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 	case SVM_EXIT_IOIO:
 		vmexit = nested_svm_intercept_ioio(svm);
 		break;
-	case SVM_EXIT_READ_CR0 ... SVM_EXIT_READ_CR8: {
-		u32 cr_bits = 1 << (exit_code - SVM_EXIT_READ_CR0);
-		if (svm->nested.intercept_cr_read & cr_bits)
-			vmexit = NESTED_EXIT_DONE;
-		break;
-	}
-	case SVM_EXIT_WRITE_CR0 ... SVM_EXIT_WRITE_CR8: {
-		u32 cr_bits = 1 << (exit_code - SVM_EXIT_WRITE_CR0);
-		if (svm->nested.intercept_cr_write & cr_bits)
+	case SVM_EXIT_READ_CR0 ... SVM_EXIT_WRITE_CR8: {
+		u32 bit = 1U << (exit_code - SVM_EXIT_READ_CR0);
+		if (svm->nested.intercept_cr & bit)
 			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
@@ -1965,8 +1975,7 @@ static inline void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *fr
 	struct vmcb_control_area *dst  = &dst_vmcb->control;
 	struct vmcb_control_area *from = &from_vmcb->control;
 
-	dst->intercept_cr_read    = from->intercept_cr_read;
-	dst->intercept_cr_write   = from->intercept_cr_write;
+	dst->intercept_cr         = from->intercept_cr;
 	dst->intercept_dr_read    = from->intercept_dr_read;
 	dst->intercept_dr_write   = from->intercept_dr_write;
 	dst->intercept_exceptions = from->intercept_exceptions;
@@ -2188,8 +2197,8 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 			       nested_vmcb->control.event_inj,
 			       nested_vmcb->control.nested_ctl);
 
-	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr_read,
-				    nested_vmcb->control.intercept_cr_write,
+	trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr & 0xffff,
+				    nested_vmcb->control.intercept_cr >> 16,
 				    nested_vmcb->control.intercept_exceptions,
 				    nested_vmcb->control.intercept);
 
@@ -2269,8 +2278,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->nested.vmcb_iopm  = nested_vmcb->control.iopm_base_pa  & ~0x0fffULL;
 
 	/* cache intercepts */
-	svm->nested.intercept_cr_read    = nested_vmcb->control.intercept_cr_read;
-	svm->nested.intercept_cr_write   = nested_vmcb->control.intercept_cr_write;
+	svm->nested.intercept_cr         = nested_vmcb->control.intercept_cr;
 	svm->nested.intercept_dr_read    = nested_vmcb->control.intercept_dr_read;
 	svm->nested.intercept_dr_write   = nested_vmcb->control.intercept_dr_write;
 	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
@@ -2285,8 +2293,8 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
 		/* We only want the cr8 intercept bits of the guest */
-		svm->vmcb->control.intercept_cr_read &= ~INTERCEPT_CR8_MASK;
-		svm->vmcb->control.intercept_cr_write &= ~INTERCEPT_CR8_MASK;
+		clr_cr_intercept(svm, INTERCEPT_CR8_READ);
+		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
 	}
 
 	/* We don't want to see VMMCALLs from a nested guest */
@@ -2578,7 +2586,7 @@ static int cr8_write_interception(struct vcpu_svm *svm)
 	/* instruction emulation calls kvm_set_cr8() */
 	emulate_instruction(&svm->vcpu, 0, 0, 0);
 	if (irqchip_in_kernel(svm->vcpu.kvm)) {
-		svm->vmcb->control.intercept_cr_write &= ~INTERCEPT_CR8_MASK;
+		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
 		return 1;
 	}
 	if (cr8_prev <= kvm_get_cr8(&svm->vcpu))
@@ -2895,8 +2903,8 @@ void dump_vmcb(struct kvm_vcpu *vcpu)
 	struct vmcb_save_area *save = &svm->vmcb->save;
 
 	pr_err("VMCB Control Area:\n");
-	pr_err("cr_read:            %04x\n", control->intercept_cr_read);
-	pr_err("cr_write:           %04x\n", control->intercept_cr_write);
+	pr_err("cr_read:            %04x\n", control->intercept_cr & 0xffff);
+	pr_err("cr_write:           %04x\n", control->intercept_cr >> 16);
 	pr_err("dr_read:            %04x\n", control->intercept_dr_read);
 	pr_err("dr_write:           %04x\n", control->intercept_dr_write);
 	pr_err("exceptions:         %08x\n", control->intercept_exceptions);
@@ -2997,7 +3005,7 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
 	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
 
-	if (!(svm->vmcb->control.intercept_cr_write & INTERCEPT_CR0_MASK))
+	if (!is_cr_intercept(svm, INTERCEPT_CR0_WRITE))
 		vcpu->arch.cr0 = svm->vmcb->save.cr0;
 	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
@@ -3123,7 +3131,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 		return;
 
 	if (tpr >= irr)
-		svm->vmcb->control.intercept_cr_write |= INTERCEPT_CR8_MASK;
+		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
 }
 
 static int svm_nmi_allowed(struct kvm_vcpu *vcpu)
@@ -3230,7 +3238,7 @@ static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK))
 		return;
 
-	if (!(svm->vmcb->control.intercept_cr_write & INTERCEPT_CR8_MASK)) {
+	if (!is_cr_intercept(svm, INTERCEPT_CR8_WRITE)) {
 		int cr8 = svm->vmcb->control.int_ctl & V_TPR_MASK;
 		kvm_set_cr8(vcpu, cr8);
 	}
-- 
1.7.1


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

