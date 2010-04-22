Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0DVUEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:04:36 -0400
Received: from kroah.org ([198.145.64.141]:60124 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017Ab0DVUCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:02:09 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:18 2010
Message-Id: <20100422195418.670519986@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [133/139] KVM: VMX: Save/restore rflags.vm correctly in real mode
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

(Cherry-picked from commit 78ac8b47c566dd6177a3b9b291b756ccb70670b7)

Currently we set eflags.vm unconditionally when entering real mode emulation
through virtual-8086 mode, and clear it unconditionally when we enter protected
mode.  The means that the following sequence

  KVM_SET_REGS  (rflags.vm=1)
  KVM_SET_SREGS (cr0.pe=1)

Ends up with rflags.vm clear due to KVM_SET_SREGS triggering enter_pmode().

Fix by shadowing rflags.vm (and rflags.iopl) correctly while in real mode:
reads and writes to those bits access a shadow register instead of the actual
register.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/vmx.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -61,6 +61,8 @@ module_param_named(unrestricted_guest,
 static int __read_mostly emulate_invalid_guest_state = 0;
 module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 
+#define RMODE_GUEST_OWNED_EFLAGS_BITS (~(X86_EFLAGS_IOPL | X86_EFLAGS_VM))
+
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * ple_gap:    upper bound on the amount of time between two successive
@@ -115,7 +117,7 @@ struct vcpu_vmx {
 	} host_state;
 	struct {
 		int vm86_active;
-		u8 save_iopl;
+		ulong save_rflags;
 		struct kvm_save_segment {
 			u16 selector;
 			unsigned long base;
@@ -787,18 +789,23 @@ static void vmx_fpu_deactivate(struct kv
 
 static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 {
-	unsigned long rflags;
+	unsigned long rflags, save_rflags;
 
 	rflags = vmcs_readl(GUEST_RFLAGS);
-	if (to_vmx(vcpu)->rmode.vm86_active)
-		rflags &= ~(unsigned long)(X86_EFLAGS_IOPL | X86_EFLAGS_VM);
+	if (to_vmx(vcpu)->rmode.vm86_active) {
+		rflags &= RMODE_GUEST_OWNED_EFLAGS_BITS;
+		save_rflags = to_vmx(vcpu)->rmode.save_rflags;
+		rflags |= save_rflags & ~RMODE_GUEST_OWNED_EFLAGS_BITS;
+	}
 	return rflags;
 }
 
 static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
-	if (to_vmx(vcpu)->rmode.vm86_active)
+	if (to_vmx(vcpu)->rmode.vm86_active) {
+		to_vmx(vcpu)->rmode.save_rflags = rflags;
 		rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
+	}
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
 
@@ -1431,8 +1438,8 @@ static void enter_pmode(struct kvm_vcpu
 	vmcs_write32(GUEST_TR_AR_BYTES, vmx->rmode.tr.ar);
 
 	flags = vmcs_readl(GUEST_RFLAGS);
-	flags &= ~(X86_EFLAGS_IOPL | X86_EFLAGS_VM);
-	flags |= (vmx->rmode.save_iopl << IOPL_SHIFT);
+	flags &= RMODE_GUEST_OWNED_EFLAGS_BITS;
+	flags |= vmx->rmode.save_rflags & ~RMODE_GUEST_OWNED_EFLAGS_BITS;
 	vmcs_writel(GUEST_RFLAGS, flags);
 
 	vmcs_writel(GUEST_CR4, (vmcs_readl(GUEST_CR4) & ~X86_CR4_VME) |
@@ -1501,8 +1508,7 @@ static void enter_rmode(struct kvm_vcpu
 	vmcs_write32(GUEST_TR_AR_BYTES, 0x008b);
 
 	flags = vmcs_readl(GUEST_RFLAGS);
-	vmx->rmode.save_iopl
-		= (flags & X86_EFLAGS_IOPL) >> IOPL_SHIFT;
+	vmx->rmode.save_rflags = flags;
 
 	flags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
 


