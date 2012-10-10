Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab2JKAQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:16:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43591 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932966Ab2JKAP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:15:58 -0400
X-Sasl-enc: qmZtNmueA2x9LWlChyQ61Z0+vnuawtFDp5IvuTi935uM 1349914556
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [ 117/133] Revert "KVM: VMX: Fix KVM_SET_SREGS with big real mode segments"
Date: Thu, 11 Oct 2012 07:52:23 +0900
Message-Id: <20121010224915.584742394@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

This reverts commit b398aa3174cd.  It
causes a regression with some versions of ipxe.  3.6 has other fixes
that cannot be backported to 3.5, so it is better to live with the
minor problem that b398aa3174cd fixes.

https://bugzilla.redhat.com/show_bug.cgi?id=854983

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |   74 ++++++++++-------------------------------------------
 1 file changed, 14 insertions(+), 60 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -615,10 +615,6 @@ static void kvm_cpu_vmxon(u64 addr);
 static void kvm_cpu_vmxoff(void);
 static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
-static void vmx_set_segment(struct kvm_vcpu *vcpu,
-			    struct kvm_segment *var, int seg);
-static void vmx_get_segment(struct kvm_vcpu *vcpu,
-			    struct kvm_segment *var, int seg);
 
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
@@ -2767,7 +2763,6 @@ static void enter_rmode(struct kvm_vcpu
 {
 	unsigned long flags;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct kvm_segment var;
 
 	if (enable_unrestricted_guest)
 		return;
@@ -2811,23 +2806,20 @@ static void enter_rmode(struct kvm_vcpu
 	if (emulate_invalid_guest_state)
 		goto continue_rmode;
 
-	vmx_get_segment(vcpu, &var, VCPU_SREG_SS);
-	vmx_set_segment(vcpu, &var, VCPU_SREG_SS);
-
-	vmx_get_segment(vcpu, &var, VCPU_SREG_CS);
-	vmx_set_segment(vcpu, &var, VCPU_SREG_CS);
-
-	vmx_get_segment(vcpu, &var, VCPU_SREG_ES);
-	vmx_set_segment(vcpu, &var, VCPU_SREG_ES);
-
-	vmx_get_segment(vcpu, &var, VCPU_SREG_DS);
-	vmx_set_segment(vcpu, &var, VCPU_SREG_DS);
-
-	vmx_get_segment(vcpu, &var, VCPU_SREG_GS);
-	vmx_set_segment(vcpu, &var, VCPU_SREG_GS);
-
-	vmx_get_segment(vcpu, &var, VCPU_SREG_FS);
-	vmx_set_segment(vcpu, &var, VCPU_SREG_FS);
+	vmcs_write16(GUEST_SS_SELECTOR, vmcs_readl(GUEST_SS_BASE) >> 4);
+	vmcs_write32(GUEST_SS_LIMIT, 0xffff);
+	vmcs_write32(GUEST_SS_AR_BYTES, 0xf3);
+
+	vmcs_write32(GUEST_CS_AR_BYTES, 0xf3);
+	vmcs_write32(GUEST_CS_LIMIT, 0xffff);
+	if (vmcs_readl(GUEST_CS_BASE) == 0xffff0000)
+		vmcs_writel(GUEST_CS_BASE, 0xf0000);
+	vmcs_write16(GUEST_CS_SELECTOR, vmcs_readl(GUEST_CS_BASE) >> 4);
+
+	fix_rmode_seg(VCPU_SREG_ES, &vmx->rmode.es);
+	fix_rmode_seg(VCPU_SREG_DS, &vmx->rmode.ds);
+	fix_rmode_seg(VCPU_SREG_GS, &vmx->rmode.gs);
+	fix_rmode_seg(VCPU_SREG_FS, &vmx->rmode.fs);
 
 continue_rmode:
 	kvm_mmu_reset_context(vcpu);
@@ -3230,44 +3222,6 @@ static void vmx_set_segment(struct kvm_v
 
 	vmcs_write32(sf->ar_bytes, ar);
 	__clear_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
-
-	/*
-	 * Fix segments for real mode guest in hosts that don't have
-	 * "unrestricted_mode" or it was disabled.
-	 * This is done to allow migration of the guests from hosts with
-	 * unrestricted guest like Westmere to older host that don't have
-	 * unrestricted guest like Nehelem.
-	 */
-	if (!enable_unrestricted_guest && vmx->rmode.vm86_active) {
-		switch (seg) {
-		case VCPU_SREG_CS:
-			vmcs_write32(GUEST_CS_AR_BYTES, 0xf3);
-			vmcs_write32(GUEST_CS_LIMIT, 0xffff);
-			if (vmcs_readl(GUEST_CS_BASE) == 0xffff0000)
-				vmcs_writel(GUEST_CS_BASE, 0xf0000);
-			vmcs_write16(GUEST_CS_SELECTOR,
-				     vmcs_readl(GUEST_CS_BASE) >> 4);
-			break;
-		case VCPU_SREG_ES:
-			fix_rmode_seg(VCPU_SREG_ES, &vmx->rmode.es);
-			break;
-		case VCPU_SREG_DS:
-			fix_rmode_seg(VCPU_SREG_DS, &vmx->rmode.ds);
-			break;
-		case VCPU_SREG_GS:
-			fix_rmode_seg(VCPU_SREG_GS, &vmx->rmode.gs);
-			break;
-		case VCPU_SREG_FS:
-			fix_rmode_seg(VCPU_SREG_FS, &vmx->rmode.fs);
-			break;
-		case VCPU_SREG_SS:
-			vmcs_write16(GUEST_SS_SELECTOR,
-				     vmcs_readl(GUEST_SS_BASE) >> 4);
-			vmcs_write32(GUEST_SS_LIMIT, 0xffff);
-			vmcs_write32(GUEST_SS_AR_BYTES, 0xf3);
-			break;
-		}
-	}
 }
 
 static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)


