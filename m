Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2HTEDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:03:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab2HTEB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:01:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Orit Wasserman <owasserm@rehdat.com>, Avi Kivity <avi@redhat.com>
Subject: [ 44/46] KVM: VMX: Fix KVM_SET_SREGS with big real mode segments
Date: Sun, 19 Aug 2012 20:59:20 -0700
Message-Id: <20120820035838.375306085@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Orit Wasserman <owasserm@redhat.com>

(cherry picked from commit b246dd5df139501b974bd6b28f7815e53b3a792f)

For example migration between Westmere and Nehelem hosts, caught in big real mode.

The code that fixes the segments for real mode guest was moved from enter_rmode
to vmx_set_segments. enter_rmode calls vmx_set_segments for each segment.

Signed-off-by: Orit Wasserman <owasserm@rehdat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx.c |   74 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 14 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -615,6 +615,10 @@ static void kvm_cpu_vmxon(u64 addr);
 static void kvm_cpu_vmxoff(void);
 static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
+static void vmx_set_segment(struct kvm_vcpu *vcpu,
+			    struct kvm_segment *var, int seg);
+static void vmx_get_segment(struct kvm_vcpu *vcpu,
+			    struct kvm_segment *var, int seg);
 
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
@@ -2763,6 +2767,7 @@ static void enter_rmode(struct kvm_vcpu
 {
 	unsigned long flags;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_segment var;
 
 	if (enable_unrestricted_guest)
 		return;
@@ -2806,20 +2811,23 @@ static void enter_rmode(struct kvm_vcpu
 	if (emulate_invalid_guest_state)
 		goto continue_rmode;
 
-	vmcs_write16(GUEST_SS_SELECTOR, vmcs_readl(GUEST_SS_BASE) >> 4);
-	vmcs_write32(GUEST_SS_LIMIT, 0xffff);
-	vmcs_write32(GUEST_SS_AR_BYTES, 0xf3);
-
-	vmcs_write32(GUEST_CS_AR_BYTES, 0xf3);
-	vmcs_write32(GUEST_CS_LIMIT, 0xffff);
-	if (vmcs_readl(GUEST_CS_BASE) == 0xffff0000)
-		vmcs_writel(GUEST_CS_BASE, 0xf0000);
-	vmcs_write16(GUEST_CS_SELECTOR, vmcs_readl(GUEST_CS_BASE) >> 4);
-
-	fix_rmode_seg(VCPU_SREG_ES, &vmx->rmode.es);
-	fix_rmode_seg(VCPU_SREG_DS, &vmx->rmode.ds);
-	fix_rmode_seg(VCPU_SREG_GS, &vmx->rmode.gs);
-	fix_rmode_seg(VCPU_SREG_FS, &vmx->rmode.fs);
+	vmx_get_segment(vcpu, &var, VCPU_SREG_SS);
+	vmx_set_segment(vcpu, &var, VCPU_SREG_SS);
+
+	vmx_get_segment(vcpu, &var, VCPU_SREG_CS);
+	vmx_set_segment(vcpu, &var, VCPU_SREG_CS);
+
+	vmx_get_segment(vcpu, &var, VCPU_SREG_ES);
+	vmx_set_segment(vcpu, &var, VCPU_SREG_ES);
+
+	vmx_get_segment(vcpu, &var, VCPU_SREG_DS);
+	vmx_set_segment(vcpu, &var, VCPU_SREG_DS);
+
+	vmx_get_segment(vcpu, &var, VCPU_SREG_GS);
+	vmx_set_segment(vcpu, &var, VCPU_SREG_GS);
+
+	vmx_get_segment(vcpu, &var, VCPU_SREG_FS);
+	vmx_set_segment(vcpu, &var, VCPU_SREG_FS);
 
 continue_rmode:
 	kvm_mmu_reset_context(vcpu);
@@ -3222,6 +3230,44 @@ static void vmx_set_segment(struct kvm_v
 
 	vmcs_write32(sf->ar_bytes, ar);
 	__clear_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
+
+	/*
+	 * Fix segments for real mode guest in hosts that don't have
+	 * "unrestricted_mode" or it was disabled.
+	 * This is done to allow migration of the guests from hosts with
+	 * unrestricted guest like Westmere to older host that don't have
+	 * unrestricted guest like Nehelem.
+	 */
+	if (!enable_unrestricted_guest && vmx->rmode.vm86_active) {
+		switch (seg) {
+		case VCPU_SREG_CS:
+			vmcs_write32(GUEST_CS_AR_BYTES, 0xf3);
+			vmcs_write32(GUEST_CS_LIMIT, 0xffff);
+			if (vmcs_readl(GUEST_CS_BASE) == 0xffff0000)
+				vmcs_writel(GUEST_CS_BASE, 0xf0000);
+			vmcs_write16(GUEST_CS_SELECTOR,
+				     vmcs_readl(GUEST_CS_BASE) >> 4);
+			break;
+		case VCPU_SREG_ES:
+			fix_rmode_seg(VCPU_SREG_ES, &vmx->rmode.es);
+			break;
+		case VCPU_SREG_DS:
+			fix_rmode_seg(VCPU_SREG_DS, &vmx->rmode.ds);
+			break;
+		case VCPU_SREG_GS:
+			fix_rmode_seg(VCPU_SREG_GS, &vmx->rmode.gs);
+			break;
+		case VCPU_SREG_FS:
+			fix_rmode_seg(VCPU_SREG_FS, &vmx->rmode.fs);
+			break;
+		case VCPU_SREG_SS:
+			vmcs_write16(GUEST_SS_SELECTOR,
+				     vmcs_readl(GUEST_SS_BASE) >> 4);
+			vmcs_write32(GUEST_SS_LIMIT, 0xffff);
+			vmcs_write32(GUEST_SS_AR_BYTES, 0xf3);
+			break;
+		}
+	}
 }
 
 static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)


